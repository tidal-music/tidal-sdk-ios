import AuthenticationServices
import Foundation

class PresentationContextProvider: NSObject, ASWebAuthenticationPresentationContextProviding {
	func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
		ASPresentationAnchor()
	}
}
