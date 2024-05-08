import Foundation

// MARK: - Constants

private enum Constants {
	static let fileExtension = "m4a"
}

// MARK: - PlayLogTestsHelper

enum PlayLogTestsHelper {
	static func url(from fileName: String) -> URL? {
		let bundle = Bundle.module
		guard let filePath = bundle.path(forResource: fileName, ofType: Constants.fileExtension) else {
			return nil
		}

		let fileURL = URL(fileURLWithPath: filePath)
		return fileURL
	}
}
