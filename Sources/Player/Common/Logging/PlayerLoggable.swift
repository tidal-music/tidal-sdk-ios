import Common
import Foundation
import Logging

private enum Constants {
	static let metadataErrorKey = "error"
}

enum PlayerLoggable: TidalLoggable {
	
	// MARK: Event Sender
	case sendEventOfflinePlayFailed(error: Error)
	case sendLegacyEventFailed(error: Error)
	case migrateLegacyDirectoryFailed(error: Error)
	case writeEventNotAuthorized
	case writeEventFailed(error: Error)
	case sendToEventProducerSerializationFailed
	case sendToEventProducerFailed(error: Error)
	case sendEventsNotAuthorized
	case sendEventsFailed(error: Error)
	case urlForDirectoryFailed(error: Error)
	case initializeDirectoryFailed(error: Error)

	// MARK: Streaming Privileges
	case streamingNotifyNotAuthorized(error: Error)
	case streamingConnectNotAuthorized(error: Error)
	case webSocketSendMessageFailed(error: Error)
	case webSocketReceiveMessageFailed(error: Error)
	case webSocketHandleErrorSleepAndReconnectionFailed(error: Error) // swiftlint:disable:this identifier_name

	// MARK: Playback Info Fetcher
	case getPlaybackInfoFailed(error: Error)

	// MARK: FairPlay License Fetcher
	case getLicenseFailed(error: Error)

	// MARK: Credentials Provider
	case getAuthBearerTokenCredentialFailed(error: Error)
	case getAuthBearerTokenToBearerTokenFailed

	// MARK: Credentials Success Data Parser
	case credentialsSuccessParserParsingFailed(error: Error)

	// MARK: Download Task
	case downloadFailed(error: Error)
	case downloadFinalizeFailed(error: Error)

	// MARK: Offline Engine
	case deleteOfflinedItem(error: Error)

	// MARK: Asset Cache Legacy
	case deleteAssetCacheFailed(error: Error)

	// MARK: StoredLicenseLoader
	case licenseLoaderContentKeyRequestFailed(error: Error)
	case licenseLoaderProcessContentKeyResponseFailed(error: Error) // swiftlint:disable:this identifier_name

	// MARK: StreamingLicenseLoader
	case streamingGetLicenseFailed(error: Error)

	// MARK: HttpClient
	case payloadEncodingFailed(error: Error)
	case payloadDecodingFailed(error: Error)

	// MARK: URLSession
	case loadDataForRequestFailed(error: Error)

	// MARK: ResponseHandler
	case backoffHandleResponseFailed(error: Error)

	// MARK: Downloader
	case startDownloadFailed(error: Error)

	// MARK: LicenseDownloader
	case licenseDownloaderContentKeyRequestFailed(error: Error)
	case licenseDownloaderGetLicenseFailed(error: Error)

	// MARK: MediaDownloader
	case downloadFinishedMovingFileFailed(error: Error)

	// MARK: AVQueuePlayerWrapperLegacy
	case legacyReadPlaybackMetadataFailed(error: Error)

	// MARK: AVQueuePlayerWrapper
	case readPlaybackMetadataFailed(error: Error)

	// MARK: DJProducer
	case djSessionStartFailed(error: Error)
	case djSessionSendCommandFailed(error: Error)

	// MARK: InternalPlayerLoader
	case loadUCFailed(error: Error)

	// MARK: PlayerEngine
	case loadPlayerItemFailed(error: Error)
}

// MARK: - Logging
extension PlayerLoggable {

	var loggingMessage: Logger.Message {
		return switch self {
		// Event Sender
		case .sendEventOfflinePlayFailed:
			"EventSender-sendEventOfflinePlayFailed"
		case .sendLegacyEventFailed:
			"EventSender-sendLegacyEventFailed"
		case .migrateLegacyDirectoryFailed:
			"EventSender-migrateLegacyDirectoryFailed"
		case .writeEventNotAuthorized:
			"EventSender-writeEventNotAuthorized"
		case .writeEventFailed:
			"EventSender-writeEventFailed"
		case .sendToEventProducerSerializationFailed:
			"EventSender-sendToEventProducerSerializationFailed"
		case .sendToEventProducerFailed:
			"EventSender-sendToEventProducerFailed"
		case .sendEventsNotAuthorized:
			"EventSender-sendEventsNotAuthorized"
		case .sendEventsFailed:
			"EventSender-sendEventsFailed"
		case .urlForDirectoryFailed:
			"EventSender-urlForDirectoryFailed"
		case .initializeDirectoryFailed:
			"EventSender-initializeDirectoryFailed"

		// Streaming Privileges
		case .streamingNotifyNotAuthorized:
			"StreamingPrivileges-streamingNotifyNotAuthorized"
		case .streamingConnectNotAuthorized:
			"StreamingPrivileges-streamingConnectNotAuthorized"
		case .webSocketSendMessageFailed:
			"StreamingPrivileges-webSocketSendMessageFailed"
		case .webSocketReceiveMessageFailed:
			"StreamingPrivileges-webSocketReceiveMessageFailed"
		case .webSocketHandleErrorSleepAndReconnectionFailed:
			"StreamingPrivileges-webSocketHandleErrorSleepAndReconnectionFailed"

		// Playback Info Fetcher
		case .getPlaybackInfoFailed:
			"PlaybackInfoFetcher-getPlaybackInfoFailed"

		// FairPlay License Fetcher
		case .getLicenseFailed:
			"FairPlayLicenseFetcher-getLicenseFailed"

		// Credentials Provider
		case .getAuthBearerTokenCredentialFailed:
			"CredentialsProvider-getAuthBearerTokenCredentialFailed"
		case .getAuthBearerTokenToBearerTokenFailed:
			"CredentialsProvider-getAuthBearerTokenToBearerTokenFailed"

		// Credentials Success Data Parser
		case .credentialsSuccessParserParsingFailed:
			"CredentialsSuccessDataParser-parsingFailed"

		// Download Task
		case .downloadFailed:
			"DownloadTask-downloadFailed"
		case .downloadFinalizeFailed:
			"DownloadTask-downloadFinalizeFailed"

		// Offline Engine
		case .deleteOfflinedItem:
			"OfflineEngine-deleteOfflinedItem"

		// Asset Cache Legacy
		case .deleteAssetCacheFailed:
			"AssetCacheLegacy-deleteAssetCacheFailed"

		// StoredLicenseLoader
		case .licenseLoaderContentKeyRequestFailed:
			"StoredLicenseLoader-contentKeyRequestFailed"
		case .licenseLoaderProcessContentKeyResponseFailed:
			"StoredLicenseLoader-processContentKeyResponseFailed"

		// StreamingLicenseLoader
		case .streamingGetLicenseFailed:
			"StreamingLicenseLoader-streamingGetLicense"

		// HttpClient
		case .payloadEncodingFailed:
			"HttpClient-payloadEncodingFailed"
		case .payloadDecodingFailed:
			"HttpClient-payloadDecodingFailed"

		// URLSession
		case .loadDataForRequestFailed:
			"URLSession-loadDataForRequestFailed"

		// ResponseHandler
		case .backoffHandleResponseFailed:
			"ResponseHandler-backoffHandleResponseFailed"

		// Downloader
		case .startDownloadFailed:
			"Downloader-startDownloadFailed"

		// LicenseDownloader
		case .licenseDownloaderContentKeyRequestFailed:
			"LicenseDownloader-contentKeyRequestFailed"
		case .licenseDownloaderGetLicenseFailed:
			"LicenseDownloader-getLicenseFailed"

		// MediaDownloader
		case .downloadFinishedMovingFileFailed:
			"MediaDownloader-downloadFinishedMovingFileFailed"

		// AVQueuePlayerWrapperLegacy
		case .legacyReadPlaybackMetadataFailed:
			"AVQueuePlayerWrapperLegacy-legacyReadPlaybackMetadataFailed"

		// AVQueuePlayerWrapper
		case .readPlaybackMetadataFailed:
			"AVQueuePlayerWrapper-readPlaybackMetadataFailed"

		// DJProducer
		case .djSessionStartFailed:
			"DJProducer-djSessionStartFailed"
		case .djSessionSendCommandFailed:
			"DJProducer-djSessionSendCommandFailed"

		// InternalPlayerLoader
		case .loadUCFailed:
			"InternalPlayerLoader-loadUCFailed"

		// PlayerEngine
		case .loadPlayerItemFailed:
			"PlayerEngine-loadPlayerItemFailed"
		}
	}

	var loggingMetadata: Logger.Metadata {
		var metadata = [String: Logger.MetadataValue]()

		switch self {
		case let .sendEventOfflinePlayFailed(error), 
			let .sendLegacyEventFailed(error),
			let .migrateLegacyDirectoryFailed(error),
			let .writeEventFailed(error), 
			let .sendToEventProducerFailed(error),
			let .sendEventsFailed(error),
			let .urlForDirectoryFailed(error),
			let .initializeDirectoryFailed(error),
			let .streamingNotifyNotAuthorized(error),
			let .streamingConnectNotAuthorized(error),
			let .webSocketSendMessageFailed(error),
			let .webSocketReceiveMessageFailed(error),
			let .webSocketHandleErrorSleepAndReconnectionFailed(error),
			let .getPlaybackInfoFailed(error),
			let .getLicenseFailed(error),
			let .credentialsSuccessParserParsingFailed(error),
			let .downloadFailed(error),
			let .downloadFinalizeFailed(error),
			let .deleteOfflinedItem(error),
			let .deleteAssetCacheFailed(error),
			let .getAuthBearerTokenCredentialFailed(error),
			let .licenseLoaderContentKeyRequestFailed(error),
			let .licenseLoaderProcessContentKeyResponseFailed(error),
			let .streamingGetLicenseFailed(error),
			let .payloadEncodingFailed(error),
			let .payloadDecodingFailed(error),
			let .loadDataForRequestFailed(error),
			let .backoffHandleResponseFailed(error),
			let .startDownloadFailed(error),
			let .licenseDownloaderContentKeyRequestFailed(error),
			let .licenseDownloaderGetLicenseFailed(error),
			let .downloadFinishedMovingFileFailed(error),
			let .legacyReadPlaybackMetadataFailed(error),
			let .readPlaybackMetadataFailed(error),
			let .djSessionStartFailed(error),
			let .djSessionSendCommandFailed(error),
			let .loadUCFailed(error),
			let .loadPlayerItemFailed(error):
			metadata[Constants.metadataErrorKey] = "\(String(describing: error))"
		case .writeEventNotAuthorized,
				.sendToEventProducerSerializationFailed,
				.sendEventsNotAuthorized,
				.getAuthBearerTokenToBearerTokenFailed:
			break
		}

		return metadata
	}

	var logLevel: Logger.Level {
		switch self {
		case .sendEventOfflinePlayFailed,
				.sendLegacyEventFailed,
				.migrateLegacyDirectoryFailed,
				.writeEventNotAuthorized,
				.writeEventFailed,
				.sendToEventProducerFailed,
				.sendToEventProducerSerializationFailed,
				.sendEventsNotAuthorized,
				.sendEventsFailed, 
				.urlForDirectoryFailed,
				.initializeDirectoryFailed,
				.streamingNotifyNotAuthorized,
				.streamingConnectNotAuthorized,
				.webSocketSendMessageFailed,
				.webSocketReceiveMessageFailed,
				.webSocketHandleErrorSleepAndReconnectionFailed,
				.getPlaybackInfoFailed,
				.getLicenseFailed,
				.getAuthBearerTokenCredentialFailed,
				.credentialsSuccessParserParsingFailed,
				.downloadFailed,
				.downloadFinalizeFailed,
				.deleteOfflinedItem,
				.deleteAssetCacheFailed,
				.getAuthBearerTokenToBearerTokenFailed,
				.licenseLoaderContentKeyRequestFailed,
				.licenseLoaderProcessContentKeyResponseFailed,
				.streamingGetLicenseFailed,
				.payloadEncodingFailed,
				.payloadDecodingFailed,
				.loadDataForRequestFailed,
				.backoffHandleResponseFailed,
				.startDownloadFailed,
				.licenseDownloaderContentKeyRequestFailed,
				.licenseDownloaderGetLicenseFailed,
				.downloadFinishedMovingFileFailed,
				.legacyReadPlaybackMetadataFailed,
				.readPlaybackMetadataFailed,
				.djSessionStartFailed,
				.djSessionSendCommandFailed,
				.loadUCFailed,
				.loadPlayerItemFailed:
			return .error
		}
	}

	var source: String {
		"Player"
	}
}
