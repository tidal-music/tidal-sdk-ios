import Foundation

// MARK: - LoudnessNormalizer

public final class LoudnessNormalizer {
	private(set) var preAmp: Float
	private let replayGain: Float
	private let peakAmplitude: Float

	public init?(preAmp: Float?, replayGain: Float?, peakAmplitude: Float?) {
		guard let preAmp, let replayGain, let peakAmplitude else {
			return nil
		}

		self.preAmp = preAmp
		self.replayGain = replayGain
		self.peakAmplitude = peakAmplitude
	}

	public func getScaleFactor() -> Float {
		min(pow(10.0, (replayGain + preAmp) / 20.0), 1.0)
	}

	public func getDecibelValue() -> Float {
		replayGain + preAmp
	}

	public func updatePreAmp(_ preAmpValue: Float) {
		preAmp = preAmpValue
	}
}

// MARK: - Static funcs

extension LoudnessNormalizer {
	static func create(from playbackInfo: PlaybackInfo, preAmp: Float) -> LoudnessNormalizer? {
		LoudnessNormalizer(
			preAmp: preAmp,
			replayGain: playbackInfo.albumReplayGain,
			peakAmplitude: playbackInfo.albumPeakAmplitude
		)
	}

	static func create(from playableStorageItem: PlayableOfflinedProduct, preAmp: Float) -> LoudnessNormalizer? {
		LoudnessNormalizer(
			preAmp: preAmp,
			replayGain: playableStorageItem.albumReplayGain,
			peakAmplitude: playableStorageItem.albumPeakAmplitude
		)
	}

	static func create(from storedMediaProduct: StoredMediaProduct, preAmp: Float) -> LoudnessNormalizer? {
		// Temporarily disable normalization of offlined content, reverting to how things were before we made the fix.
		// This should be re-enabled once we figure out why external player does the weird volume changes at the start of some tracks.
		nil
		//        LoudnessNormalizer(
		//            preAmp: preAmp,
		//            replayGain: storedMediaProduct.albumReplayGain,
		//            peakAmplitude: storedMediaProduct.albumPeakAmplitude
		//        )
	}
}

// MARK: Equatable

extension LoudnessNormalizer: Equatable {
	public static func == (lhs: LoudnessNormalizer, rhs: LoudnessNormalizer) -> Bool {
		lhs.preAmp == rhs.preAmp &&
			lhs.peakAmplitude == rhs.peakAmplitude &&
			lhs.replayGain == rhs.replayGain
	}
}

// MARK: CustomStringConvertible

extension LoudnessNormalizer: CustomStringConvertible {
	public var description: String {
		"LoudnessNormalizer(preAmp: \(preAmp), peakAmplitude: \(peakAmplitude), replayGain: \(replayGain))"
	}
}
