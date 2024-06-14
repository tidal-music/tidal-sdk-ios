import Foundation

protocol UCMediaPlayer: AnyObject {
	func loadUC(
		_ url: URL,
		loudnessNormalizationConfiguration: LoudnessNormalizationConfiguration,
		headers: [String: String]
	) async -> Asset
}
