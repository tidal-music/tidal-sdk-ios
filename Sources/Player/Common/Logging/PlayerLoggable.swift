import Common
import Foundation

private enum Constants {
	static let metadataErrorKey = "error"
}

enum PlayerLoggable: TidalLoggable {
	
	// MARK: Event Sender
	case sendEventOfflinePlay(error: Error)
	case sendLegacyEvent(error: Error)
	case migrateLegacyDirectory(error: Error)
	case writeEventNotAuthorized
	case writeEvent(error: Error)
	case sendToEventProducerSerializationFail
	case sendToEventProducer(error: Error)
	case sendEventsNotAuthorized
	case sendEvents(error: Error)

	// MARK: Streaming Privileges
	case streamingNotify(error: Error)
	case streamingConnect(error: Error)

	// MARK: Playback Info Fetcher
	case getPlaybackInfo(error: Error)

	// MARK: FairPlay License Fetcher
	case getLicense(error: Error)

	// MARK: Credentials Provider
	case getAuthBearerToken

	// MARK: Credentials Success Data Parser
	case clientIdFromToken(error: Error)

	// MARK: Download Task
	case downloadFailed(error: Error)
	case downloadFinalizeFailed(error: Error)

	// MARK: Offline Engine
	case deleteOfflineItem(error: Error)

	// MARK: Asset Cache Legacy
	case deleteAssetCache(error: Error)
}

// MARK: - Logging
extension PlayerLoggable {

	var loggingMessage: String {
		return switch self {
		// Event Sender
		case .sendEventOfflinePlay:
			"EventSender-sendEventOfflinePlay"
		case .sendLegacyEvent:
			"EventSender-sendLegacyEvent"
		case .migrateLegacyDirectory:
			"EventSender-migrateLegacyDirectory"
		case .writeEventNotAuthorized:
			"EventSender-writeEventNotAuthorized"
		case .writeEvent:
			"EventSender-writeEvent"
		case .sendToEventProducerSerializationFail:
			"EventSender-sendToEventProducerSerializationFail"
		case .sendToEventProducer:
			"EventSender-sendToEventProducer"
		case .sendEventsNotAuthorized:
			"EventSender-sendEventsNotAuthorized"
		case .sendEvents:
			"EventSender-sendEvents"

		// Streaming Privileges
		case .streamingNotify:
			"StreamingPrivileges-streamingNotify"
		case .streamingConnect:
			"StreamingPrivileges-streamingConnect"

		// Playback Info Fetcher
		case .getPlaybackInfo:
			"PlaybackInfoFetcher-getPlaybackInfo"

		// FairPlay License Fetcher
		case .getLicense:
			"FairPlayLicenseFetcher-getLicense"

		// Credentials Provider
		case .getAuthBearerToken:
			"CredentialsProvider-getAuthBearerToken"

		// Credentials Success Data Parser
		case .clientIdFromToken:
			"CredentialsSuccessDataParser-clientIdFromToken"

		// Download Task
		case .downloadFailed:
			"DownloadTask-downloadFailed"
		case .downloadFinalizeFailed:
			"DownloadTask-downloadFinalizeFailed"

		// Offline Engine
		case .deleteOfflineItem:
			"OfflineEngine-deleteOfflineItem"

		// Asset Cache Legacy
		case .deleteAssetCache:
			"AssetCacheLegacy-deleteAssetCache"
		}
	}

	var loggingMetadata: [String: String] {
		var metadata = [String: String]()

		switch self {
		case let .sendEventOfflinePlay(error), 
			let .sendLegacyEvent(error),
			let .migrateLegacyDirectory(error),
			let .writeEvent(error), 
			let .sendToEventProducer(error),
			let .sendEvents(error),
			let .streamingNotify(error),
			let .streamingConnect(error),
			let .getPlaybackInfo(error),
			let .getLicense(error),
			let .clientIdFromToken(error),
			let .downloadFailed(error),
			let .downloadFinalizeFailed(error),
			let .deleteOfflineItem(error),
			let .deleteAssetCache(error):
			metadata[Constants.metadataErrorKey] = String(describing: error)
		case .writeEventNotAuthorized,
				.sendToEventProducerSerializationFail,
				.sendEventsNotAuthorized,
				.getAuthBearerToken:
			break
		}

		return metadata
	}

	var logLevel: LoggingLevel {
		switch self {
		case .sendEventOfflinePlay,
				.sendLegacyEvent,
				.migrateLegacyDirectory,
				.writeEventNotAuthorized,
				.writeEvent,
				.sendToEventProducer,
				.sendToEventProducerSerializationFail,
				.sendEventsNotAuthorized,
				.sendEvents, 
				.streamingNotify,
				.streamingConnect,
				.getPlaybackInfo,
				.getLicense,
				.getAuthBearerToken,
				.clientIdFromToken,
				.downloadFailed,
				.downloadFinalizeFailed,
				.deleteOfflineItem,
				.deleteAssetCache:
			return .error
		}
	}

	var source: String {
		"Player"
	}
}
