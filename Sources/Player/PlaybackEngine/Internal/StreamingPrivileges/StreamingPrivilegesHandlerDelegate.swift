import Foundation

protocol StreamingPrivilegesHandlerDelegate: AnyObject {
	func streamingPrivilegesLost(to clientName: String?)
}
