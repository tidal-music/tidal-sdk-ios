import Foundation

extension Player {
	static func mainPlayerType() -> MainPlayerType.Type {
		AVQueuePlayerWrapper.self
	}
}
