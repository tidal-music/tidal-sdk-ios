import Foundation

// MARK: - LoudnessNormalizationConfiguration

public final class LoudnessNormalizationConfiguration {
	private let loudnessNormalizer: LoudnessNormalizer?
	private var loudnessNormalizationMode: LoudnessNormalizationMode

	init(loudnessNormalizationMode: LoudnessNormalizationMode, loudnessNormalizer: LoudnessNormalizer?) {
		self.loudnessNormalizationMode = loudnessNormalizationMode
		self.loudnessNormalizer = loudnessNormalizer
	}

	func setLoudnessNormalizationMode(_ loudnessNormalizationMode: LoudnessNormalizationMode) {
		self.loudnessNormalizationMode = loudnessNormalizationMode
	}

	public func getLoudnessNormalizer() -> LoudnessNormalizer? {
		switch loudnessNormalizationMode {
		case .NONE: nil
		case .ALBUM: loudnessNormalizer
		}
	}

	func getLoudnessNormalizationMode() -> LoudnessNormalizationMode {
		loudnessNormalizationMode
	}
}

// MARK: Equatable

extension LoudnessNormalizationConfiguration: Equatable {
	public static func == (lhs: LoudnessNormalizationConfiguration, rhs: LoudnessNormalizationConfiguration) -> Bool {
		lhs.loudnessNormalizationMode == rhs.loudnessNormalizationMode &&
			lhs.loudnessNormalizer == rhs.loudnessNormalizer
	}
}

// MARK: CustomStringConvertible

extension LoudnessNormalizationConfiguration: CustomStringConvertible {
	public var description: String {
		"LoudnessNormalizationConfiguration(loudnessNormalizationMode: \(loudnessNormalizationMode), loudnessNormalizer: \(String(describing: loudnessNormalizer))"
	}
}
