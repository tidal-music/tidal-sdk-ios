import Foundation

public actor Download {
	public enum State {
		case pending
		case inProgress
		case failed
		case completed
	}

	public enum Event {
		case state(State)
		case progress(Double)
	}

	public nonisolated let title: String
	public nonisolated let artists: [String]
	public nonisolated let imageURL: URL?
	/// The backend task identifier used to correlate this transfer with task processing.
	public nonisolated let taskId: String
	/// The track or video transferred by this download.
	public nonisolated let resource: OfflineResource
	/// The collection that caused the transfer, when applicable.
	public nonisolated let collection: OfflineResource?
	public nonisolated let events: AsyncStream<Event>
	nonisolated let relatedCollection: OfflineCollectionReference?

	private let continuation: AsyncStream<Event>.Continuation
	private let progressHandler: (@Sendable (Double) async -> Void)?

	internal init(
		title: String,
		artists: [String],
		imageURL: URL?,
		taskId: String,
		resource: OfflineResource,
		relatedCollection: OfflineCollectionReference? = nil,
		progressHandler: (@Sendable (Double) async -> Void)? = nil
	) {
		self.title = title
		self.artists = artists
		self.imageURL = imageURL
		self.taskId = taskId
		self.resource = resource
		self.relatedCollection = relatedCollection
		self.collection = relatedCollection.map {
			.collection(type: $0.collectionType, resourceId: $0.resourceId)
		}
		self.progressHandler = progressHandler

		let (stream, continuation) = AsyncStream<Event>.makeStream()
		self.events = stream
		self.continuation = continuation
	}

	internal func updateState(_ newState: State) {
		continuation.yield(.state(newState))

		if newState == .completed || newState == .failed {
			continuation.finish()
		}
	}

	internal func updateProgress(_ newProgress: Double) async {
		continuation.yield(.progress(newProgress))
		await progressHandler?(newProgress)
	}
}
