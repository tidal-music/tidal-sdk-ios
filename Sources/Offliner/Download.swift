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

	internal init(
		title: String,
		artists: [String],
		imageURL: URL?,
		relatedCollection: OfflineCollectionReference? = nil
	) {
		self.title = title
		self.artists = artists
		self.imageURL = imageURL
		self.relatedCollection = relatedCollection

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

	internal func updateProgress(_ newProgress: Double) {
		continuation.yield(.progress(newProgress))
	}
}
