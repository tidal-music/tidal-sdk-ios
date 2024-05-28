@testable import Player

final class StreamingPrivilegesHandlerDelegateMock: StreamingPrivilegesHandlerDelegate {
	private(set) var streamingPrivilegesLostClientNames = [String?]()

	func streamingPrivilegesLost(to clientName: String?) {
		streamingPrivilegesLostClientNames.append(clientName)
	}
}
