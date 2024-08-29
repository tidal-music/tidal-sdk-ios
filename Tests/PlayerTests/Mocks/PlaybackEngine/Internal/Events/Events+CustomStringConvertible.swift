@testable import Player

// MARK: - StreamingSessionEnd + CustomDebugStringConvertible

// swiftlint:disable line_length

// The following extensions are helpers to get a better description in case of equatability failure in the tests.

extension StreamingSessionEnd: CustomDebugStringConvertible {
	public var debugDescription: String {
		"StreamingSessionEnd(streamingSessionId: \(streamingSessionId), name: \(name), timestamp: \(timestamp))"
	}
}

// MARK: - StreamingSessionStart + CustomDebugStringConvertible

extension StreamingSessionStart: CustomDebugStringConvertible {
	public var debugDescription: String {
		"StreamingSessionStart(streamingSessionId: \(streamingSessionId), startReason: \(startReason), timestamp: \(timestamp), networkType: \(networkType), outputDevice: \(String(describing: outputDevice)), sessionType: \(sessionType), hardwarePlatform: \(hardwarePlatform), operatingSystem: \(operatingSystem), operatingSystemVersion: \(operatingSystemVersion), screenWidth: \(screenWidth), screenHeight: \(screenHeight), mobileNetworkType: \(mobileNetworkType), sessionProductType: \(sessionProductType), sessionProductId: \(sessionProductId), sessionTags: \(String(describing: sessionTags))"
	}
}

// MARK: - DownloadStatistics + CustomDebugStringConvertible

extension DownloadStatistics: CustomDebugStringConvertible {
	public var debugDescription: String {
		"DownloadStatistics(streamingSessionId: \(streamingSessionId)), startTimestamp: \(startTimestamp), productType: \(productType), actualProductId: \(actualProductId), actualAssetPresentation: \(actualAssetPresentation), actualAudioMode: \(String(describing: actualAudioMode)), actualQuality: \(actualQuality), endReason: \(endReason), endTimestamp: \(endTimestamp), errorMessage: \(String(describing: errorMessage)), errorCode: \(String(describing: errorCode)))"
	}
}

// MARK: - DrmLicenseFetch + CustomDebugStringConvertible

extension DrmLicenseFetch: CustomDebugStringConvertible {
	public var debugDescription: String {
		"DrmLicenseFetch(streamingSessionId: \(streamingSessionId)), startTimestamp: \(startTimestamp), endTimestamp: \(endTimestamp), endReason: \(endReason), errorMessage: \(String(describing: errorMessage)), errorCode: \(String(describing: errorCode)))"
	}
}

// MARK: - PlaybackInfoFetch + CustomDebugStringConvertible

extension PlaybackInfoFetch: CustomDebugStringConvertible {
	public var debugDescription: String {
		"PlaybackInfoFetch(streamingSessionId: \(streamingSessionId)), startTimestamp: \(startTimestamp), endTimestamp: \(endTimestamp), endReason: \(endReason), errorMessage: \(String(describing: errorMessage)), errorCode: \(String(describing: errorCode)))"
	}
}

// MARK: - PlaybackStatistics + CustomDebugStringConvertible

extension PlaybackStatistics: CustomDebugStringConvertible {
	public var debugDescription: String {
		"PlaybackStatistics(streamingSessionId: \(streamingSessionId)), idealStartTimestamp: \(String(describing: idealStartTimestamp)), actualStartTimestamp: \(String(describing: actualStartTimestamp)), productType: \(productType), actualProductId: \(actualProductId), actualStreamType: \(actualStreamType), actualAssetPresentation: \(actualAssetPresentation), actualAudioMode: \(String(describing: actualAudioMode)), actualQuality: \(actualQuality), stalls: \(stalls), startReason: \(startReason), endReason: \(endReason), endTimestamp: \(endTimestamp), errorMessage: \(String(describing: errorMessage)), errorCode: \(String(describing: errorCode)))"
	}
}

// MARK: - PlayLogEvent + CustomDebugStringConvertible

extension PlayLogEvent: CustomDebugStringConvertible {
	public var debugDescription: String {
		"PlayLogEvent(playbackSessionId: \(playbackSessionId)), startTimestamp: \(startTimestamp), startAssetPosition: \(startAssetPosition), isPostPaywall: \(isPostPaywall), productType: \(productType), requestedProductId: \(requestedProductId), actualProductId: \(actualProductId), actualAssetPresentation: \(actualAssetPresentation), actualAudioMode: \(String(describing: actualAudioMode)), actualQuality: \(actualQuality), sourceType: \(String(describing: sourceType)), sourceId: \(String(describing: sourceId)), actions: \(actions), endTimestamp: \(endTimestamp), endAssetPosition: \(endAssetPosition))"
	}
}

// MARK: - OfflinePlay + CustomDebugStringConvertible

extension OfflinePlay: CustomDebugStringConvertible {
	public var debugDescription: String {
		"OfflinePlay(id: \(id)), quality: \(quality), deliveredDuration: \(deliveredDuration), playDate: \(playDate), productType: \(type), audioMode: \(String(describing: audioMode)), playbackSessionId: \(String(describing: playbackSessionId)))"
	}
}

// MARK: - LegacyEvent + CustomDebugStringConvertible

extension LegacyEvent: CustomDebugStringConvertible {
	public var debugDescription: String {
		"Event(group: \(group), name: \(name), version: \(version), ts: \(ts), uuid: \(uuid), user: \(user), client: \(client), payload: \(payload))"
	}
}

// swiftlint:enable line_length
