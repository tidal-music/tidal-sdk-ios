import CoreMedia
import Foundation

// MARK: - Constants

private enum Constants {
	static let fileExtension = "m4a"
	static let acceptableAssetPositionTimeRange: TimeInterval = 0.5
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

	static func isTimeDifferenceNegligible(assetPosition: Double, anotherAssetPosition: Double) -> Bool {
		let time = CMTimeGetSeconds(CMTime(seconds: assetPosition, preferredTimescale: CMTimeScale.max))
		let anotherTime = CMTimeGetSeconds(CMTime(seconds: anotherAssetPosition, preferredTimescale: CMTimeScale.max))
		let timeDifference = abs(anotherTime - time)
		guard timeDifference <= Constants.acceptableAssetPositionTimeRange else {
			return false
		}
		return true
	}
}
