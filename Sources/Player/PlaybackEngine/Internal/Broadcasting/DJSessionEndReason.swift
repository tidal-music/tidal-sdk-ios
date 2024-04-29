import Foundation

public enum DJSessionEndReason: Equatable {
	/// Indicates that the DJ session ended because the user wanted it to end.
	case userControlled

	/// Indicates that the DJ session ended because the session's maximum duration was reached.
	case maxDurationReached

	/// Indicates that the DJ session ended because the user decided to play content that is not supported.
	case invalidContent

	/// Indicates that the DJ session failed to start. The 'code' value provides a technical description of the error which can be
	/// useful for debugging.
	case failedToStart(code: String)

	/// Indicates that the DJ session ended because of an error. The 'code' value provides a technical description of the error which
	/// can be useful for debugging.
	case error(code: String)
}
