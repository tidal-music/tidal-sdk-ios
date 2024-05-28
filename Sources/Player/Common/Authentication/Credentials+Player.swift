import Auth
import Foundation

extension Credentials {
	/// Boolean flag indicating whether the user is authorized with user level.
	var isAuthorized: Bool {
		level == .user
	}
}
