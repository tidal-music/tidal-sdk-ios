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
	public nonisolated let events: AsyncStream<Event>
	nonisolated let relatedCollection: OfflineCollectionReference?

	private let continuation: AsyncStream<Event>.Continuation
	private let progressHandler: (@Sendable (Double) async -> Void)?

	init(
		title: String,
		artists: [String],
		imageURL: URL?,
		relatedCollection: OfflineCollectionReference? = nil,
		progressHandler: (@Sendable (Double) async -> Void)? = nil
	) {
		self.title = title
		self.artists = artists
		self.imageURL = imageURL
		self.relatedCollection = relatedCollection
		self.progressHandler = progressHandler

		let (stream, continuation) = AsyncStream<Event>.makeStream()
		events = stream
		self.continuation = continuation
	}

	func updateState(_ newState: State) {
		continuation.yield(.state(newState))

		if newState == .completed || newState == .failed {
			continuation.finish()
		}
	}

	func updateProgress(_ newProgress: Double) async {
		continuation.yield(.progress(newProgress))
		await progressHandler?(newProgress)
	}
}
