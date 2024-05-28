import SafariServices
import SwiftUI

// MARK: - SafariWebView

struct SafariWebView: UIViewControllerRepresentable {
	let url: URL
	let redicrectUrl: String
	let onSuccess: (String) -> Void
	let delegate: SafariDelegate

	init(url: URL, redicrectUrl: String, onSuccess: @escaping (String) -> Void) {
		self.url = url
		self.redicrectUrl = redicrectUrl
		self.onSuccess = onSuccess
		delegate = SafariDelegate(redicrectUrl: redicrectUrl, onSuccess: onSuccess)
	}

	func makeUIViewController(context: Context) -> SFSafariViewController {
		let viewController = SFSafariViewController(url: url)
		viewController.delegate = delegate
		viewController.preferredControlTintColor = .white
		viewController.preferredBarTintColor = .black
		return viewController
	}

	func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

// MARK: - SafariDelegate

final class SafariDelegate: NSObject, SFSafariViewControllerDelegate {
	let redicrectUrl: String
	let onSuccess: (String) -> Void

	init(redicrectUrl: String, onSuccess: @escaping (String) -> Void) {
		self.redicrectUrl = redicrectUrl
		self.onSuccess = onSuccess
	}

	func safariViewController(_ controller: SFSafariViewController, initialLoadDidRedirectTo URL: URL) {
		if URL.absoluteString.starts(with: redicrectUrl) {
			onSuccess(URL.absoluteString)
		}
	}
}
