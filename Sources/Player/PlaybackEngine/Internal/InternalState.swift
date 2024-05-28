import Foundation

enum InternalState {
	case IDLE
	case PLAYING
	case PAUSED
	case NOT_PLAYING
	case STALLED

	var publicState: State {
		switch self {
		case .IDLE:
			.IDLE
		case .PLAYING:
			.PLAYING
		case .PAUSED, .NOT_PLAYING:
			.NOT_PLAYING
		case .STALLED:
			.STALLED
		}
	}
}
