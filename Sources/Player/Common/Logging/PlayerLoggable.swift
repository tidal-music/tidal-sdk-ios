import Common
import Foundation
import Logging

// MARK: - Constants

private enum Constants {
	static let metadataAudioCodecKey = "audioCodec"
	static let metadataAudioModeKey = "audioMode"
	static let metadataErrorSubstatusKey = "errorSubstatus"
	static let metadataFormatFlagsKey = "formatFlags"
	static let metadataRetryStrategyKey = "retryStrategy"
	static let metadataRouteChangeReasonKey = "routeChangeReason"
}

// MARK: - PlayerLoggable

// swiftlint:disable identifier_name
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
	case eventSenderInitEventsDirectoryFailed
	case eventSenderInitOfflinePlaysDirectoryFailed
	case eventSenderInitializeDirectoryNoURLPath
	case writeEventNoClientId

	// MARK: Streaming Privileges

	case streamingNotifyGetCredentialFailed
	case streamingNotifyNotAuthorized(error: Error)
	case streamingConnectNotAuthorized(error: Error)
	case streamingConnectOfflineMode
	case streamingConnectNoToken
	case webSocketSendMessageInvalidData
	case webSocketSendMessageFailed(error: Error)
	case webSocketReceiveMessageInvalidData
	case webSocketReceiveMessageFailed(error: Error)
	case webSocketHandleErrorSleepAndReconnectionFailed(error: Error)
	case webSocketHandleErrorRetryStrategyNone
	case streamingHandleInvalidMessage(message: String)
	case streamingInterpretInvalidData(text: String)

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

	// MARK: Offline Storage

	case withDefaultDatabase(error: Error)
	case updateDBFileAttributes(error: Error)

	// MARK: Offline Engine

	case saveOfflinedItemFailed(error: Error)
	case deleteOfflinedItemFailed(error: Error)

	// MARK: StoredLicenseLoader

	case licenseLoaderContentKeyRequestFailed(error: Error)
	case licenseLoaderProcessContentKeyResponseFailed(error: Error)

	// MARK: StreamingLicenseLoader

	case streamingGetLicenseFailed(error: Error)

	// MARK: HttpClient

	case payloadEncodingFailed(error: Error)
	case payloadDecodingFailed(error: Error)

	// MARK: URLSession

	case loadDataForRequestFailed(error: Error)

	// MARK: ResponseHandler

	case backoffHandleResponseFailed(error: Error, retryStrategy: String)

	// MARK: Downloader

	case startDownloadFailed(error: Error)

	// MARK: LicenseDownloader

	case licenseDownloaderContentKeyRequestFailed(error: Error)
	case licenseDownloaderGetLicenseFailed(error: Error)

	// MARK: MediaDownloader

	case downloadFinishedMovingFileFailed(error: Error)
	case failedToCalculateSizeForHLSDownload(error: Error)
	case failedToCalculateSizeForProgressiveDownload(error: Error)

	// MARK: AVQueuePlayerWrapper

	case readPlaybackMetadataFailed(error: Error)
	case playWithoutQueuedItems
	case itemChangedWithoutQueuedItems

	// MARK: DJProducer

	case djSessionStartFailed(error: Error)
	case djSessionSendCommandFailed(error: Error)
	case djSessionStartNoCurationURL
	case djSessionPlayProductNotTrack
	case djSessionPauseNoCurationURL
	case djSessionStopNoCurationURL
	case djSessionStopOnNextCommand
	case djSessionResetNoCurationURL
	case djSessionSendStopOnNextCommand

	// MARK: InternalPlayerLoader

	case loadUCFailed(error: Error)

	// MARK: PlayerEngine

	case loadPlayerItemFailed(error: Error)
	case handleErrorNoNotificationsHandler
	case handleErrorCancellation
	case handleErrorPlayerItemNotCurrent
	case handleErrorPlayerItemNotNext

	// MARK: AudioCodec

	case audioCodecInitWithEmpty
	case audioCodecInitWithUnknown(codec: String)
	case audioCodecInitWithNilQuality(audioMode: String)
	case audioCodecInitWithLowQualityAndNilMode
	case audioCodecInitWithLowQualityAndUnsupportedMode(mode: String)

	// MARK: ErrorId

	case playbackErrorIdFromSubstatus(substatus: Int)

	// MARK: AVPlayer extension

	case avplayerSeekWithoutCurrentItem

	// MARK: AudioSessionInterruptionMonitor

	case interruptionMonitorHandleNotificationWithoutRequiredData
	case interruptionMonitorHandleNotificationEndedNoOptions
	case interruptionMonitorHandleNotificationEndedNoShouldResume
	case interruptionMonitorHandleNotificationEndedNotPlayingWhenInterrupted
	case interruptionMonitorHandleNotificationUnknownType

	// MARK: AudioSessionRouteChangeMonitor

	case changeMonitorHandleNotificationWithoutRequiredData
	case changeMonitorHandleNotificationDefaultReason(reason: String)
	case changeMonitorUpdateVolumeWithoutRequiredData

	// MARK: AudioSessionMediaServicesWereResetMonitor

	case handleMediaServicesWereLost
	case handleMediaServicesWereReset

	// MARK: AssetPlaybackMetadata

	case assetPlaybackMetadataInitWithoutRateAndDepthData
	case assetPlaybackMetadataInitWithoutRequiredData
	case assetPlaybackMetadataInitWithInvalidFormatFlags(formatFlags: String)

	// MARK: Metrics

	case metricsNoIdealStartTime

	// MARK: Player

	case alreadyInitialized
}

// swiftlint:enable identifier_name

// MARK: - Logging

extension PlayerLoggable {
	var loggingMessage: Logger.Message {
		switch self {
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
		case .eventSenderInitEventsDirectoryFailed:
			"EventSender-initEventsDirectoryFailed"
		case .eventSenderInitOfflinePlaysDirectoryFailed:
			"EventSender-initOfflinePlaysDirectoryFailed"
		case .eventSenderInitializeDirectoryNoURLPath:
			"EventSender-initializeDirectoryNoURLPath"
		case .writeEventNoClientId:
			"EventSender-writeEventNoClientId"

		// Streaming Privileges
		case .streamingNotifyGetCredentialFailed:
			"StreamingPrivileges-streamingNotifyGetCredentialFailed"
		case .streamingNotifyNotAuthorized:
			"StreamingPrivileges-streamingNotifyNotAuthorized"
		case .streamingConnectNotAuthorized:
			"StreamingPrivileges-streamingConnectNotAuthorized"
		case .streamingConnectOfflineMode:
			"StreamingPrivileges-streamingConnectOfflineMode"
		case .streamingConnectNoToken:
			"StreamingPrivileges-streamingConnectNoToken"
		case .webSocketSendMessageInvalidData:
			"StreamingPrivileges-webSocketSendMessageInvalidData"
		case .webSocketSendMessageFailed:
			"StreamingPrivileges-webSocketSendMessageFailed"
		case .webSocketReceiveMessageInvalidData:
			"StreamingPrivileges-webSocketReceiveMessageInvalidData"
		case .webSocketReceiveMessageFailed:
			"StreamingPrivileges-webSocketReceiveMessageFailed"
		case .webSocketHandleErrorSleepAndReconnectionFailed:
			"StreamingPrivileges-webSocketHandleErrorSleepAndReconnectionFailed"
		case .webSocketHandleErrorRetryStrategyNone:
			"StreamingPrivileges-webSocketHandleErrorRetryStrategyNone"
		case .streamingHandleInvalidMessage:
			"StreamingPrivileges-streamingHandleInvalidMessage"
		case .streamingInterpretInvalidData:
			"StreamingPrivileges-streamingInterpretInvalidData"

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

		// GRDBOfflineStorage
		case .withDefaultDatabase:
			"GRDBOfflineStorage-withDefaultDatabase"
		case .updateDBFileAttributes:
			"GRDBOfflineStorage-updateDBFileAttributes"

		// Offline Engine
		case .saveOfflinedItemFailed:
			"OfflineEngine-saveOfflinedItemFailed"
		case .deleteOfflinedItemFailed:
			"OfflineEngine-deleteOfflinedItemFailed"

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
		case .failedToCalculateSizeForHLSDownload:
			"MediaDownloader-failedToCalculateSizeForHLSDownload"
		case .failedToCalculateSizeForProgressiveDownload:
			"MediaDownloader-failedToCalculateSizeForProgressiveDownload"

		// AVQueuePlayerWrapper
		case .readPlaybackMetadataFailed:
			"AVQueuePlayerWrapper-readPlaybackMetadataFailed"
		case .playWithoutQueuedItems:
			"AVQueuePlayerWrapper-playWithoutQueuedItems"
		case .itemChangedWithoutQueuedItems:
			"AVQueuePlayerWrapper-itemChangedWithoutQueuedItems"

		// DJProducer
		case .djSessionStartFailed:
			"DJProducer-djSessionStartFailed"
		case .djSessionSendCommandFailed:
			"DJProducer-djSessionSendCommandFailed"
		case .djSessionStartNoCurationURL:
			"DJProducer-djSessionStartNoCurationURL"
		case .djSessionPlayProductNotTrack:
			"DJProducer-djSessionPlayProductNotTrack"
		case .djSessionPauseNoCurationURL:
			"DJProducer-djSessionPauseNoCurationURL"
		case .djSessionStopNoCurationURL:
			"DJProducer-djSessionStopNoCurationURL"
		case .djSessionStopOnNextCommand:
			"DJProducer-djSessionStopOnNextCommand"
		case .djSessionResetNoCurationURL:
			"DJProducer-djSessionResetNoCurationURL"
		case .djSessionSendStopOnNextCommand:
			"DJProducer-djSessionSendStopOnNextCommand"

		// InternalPlayerLoader
		case .loadUCFailed:
			"InternalPlayerLoader-loadUCFailed"

		// PlayerEngine
		case .loadPlayerItemFailed:
			"PlayerEngine-loadPlayerItemFailed"
		case .handleErrorNoNotificationsHandler:
			"PlayerEngine-handleErrorNoNotificationsHandler"
		case .handleErrorCancellation:
			"PlayerEngine-handleErrorCancellation"
		case .handleErrorPlayerItemNotCurrent:
			"PlayerEngine-handleErrorPlayerItemNotCurrent"
		case .handleErrorPlayerItemNotNext:
			"PlayerEngine-handleErrorPlayerItemNotNext"

		// AudioCodec
		case .audioCodecInitWithEmpty:
			"AudioCodec-audioCodecInitWithEmpty"
		case .audioCodecInitWithUnknown:
			"AudioCodec-audioCodecInitWithUnknown"
		case .audioCodecInitWithNilQuality:
			"AudioCodec-initWithNilQuality"
		case .audioCodecInitWithLowQualityAndNilMode:
			"AudioCodec-initWithLowQualityAndNilMode"
		case .audioCodecInitWithLowQualityAndUnsupportedMode:
			"AudioCodec-initWithLowQualityAndUnsupportedMode"

		// ErrorId
		case .playbackErrorIdFromSubstatus:
			"ErrorId-playbackErrorIdFromSubstatus"

		// AVPlayer
		case .avplayerSeekWithoutCurrentItem:
			"AVPlayer-avplayerSeekWithoutCurrentItem"

		// AudioSessionInterruptionMonitor
		case .interruptionMonitorHandleNotificationWithoutRequiredData:
			"AudioSessionInterruptionMonitor-handleNotificationWithoutRequiredData"
		case .interruptionMonitorHandleNotificationEndedNoOptions:
			"AudioSessionInterruptionMonitor-handleNotificationEndedNoOptions"
		case .interruptionMonitorHandleNotificationEndedNoShouldResume:
			"AudioSessionInterruptionMonitor-handleNotificationEndedNoShouldResume"
		case .interruptionMonitorHandleNotificationEndedNotPlayingWhenInterrupted:
			"AudioSessionInterruptionMonitor-handleNotificationEndedNotPlayingWhenInterrupted"
		case .interruptionMonitorHandleNotificationUnknownType:
			"AudioSessionInterruptionMonitor-handleNotificationUnknownType"

		// AudioSessionRouteChangeMonitor
		case .changeMonitorHandleNotificationWithoutRequiredData:
			"AudioSessionRouteChangeMonitor-handleNotificationWithoutRequiredData"
		case .changeMonitorHandleNotificationDefaultReason:
			"AudioSessionRouteChangeMonitor-handleNotificationUnknownReason"
		case .changeMonitorUpdateVolumeWithoutRequiredData:
			"AudioSessionRouteChangeMonitor-updateVolumeWithoutRequiredData"

		// AudioSessionMediaServicesWereResetMonitor
		case .handleMediaServicesWereLost:
			"AudioSessionMediaServicesWereResetMonitor-handleMediaServicesWereLost"
		case .handleMediaServicesWereReset:
			"AudioSessionMediaServicesWereResetMonitor-handleMediaServicesWereReset"

		// AssetPlaybackMetadata
		case .assetPlaybackMetadataInitWithoutRateAndDepthData:
			"AssetPlaybackMetadata-initWithoutRateAndDepthData"
		case .assetPlaybackMetadataInitWithoutRequiredData:
			"AssetPlaybackMetadata-initWithoutRequiredData"
		case .assetPlaybackMetadataInitWithInvalidFormatFlags:
			"AssetPlaybackMetadata-initWithInvalidFormatFlags"

		// Metrics
		case .metricsNoIdealStartTime:
			"Metrics-noIdealStartTime"

		// Player
		case .alreadyInitialized:
			"Player-alreadyInitialized"
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
		     let .withDefaultDatabase(error),
		     let .updateDBFileAttributes(error),
		     let .saveOfflinedItemFailed(error),
		     let .deleteOfflinedItemFailed(error),
		     let .getAuthBearerTokenCredentialFailed(error),
		     let .licenseLoaderContentKeyRequestFailed(error),
		     let .licenseLoaderProcessContentKeyResponseFailed(error),
		     let .streamingGetLicenseFailed(error),
		     let .payloadEncodingFailed(error),
		     let .payloadDecodingFailed(error),
		     let .loadDataForRequestFailed(error),
		     let .startDownloadFailed(error),
		     let .licenseDownloaderContentKeyRequestFailed(error),
		     let .licenseDownloaderGetLicenseFailed(error),
		     let .downloadFinishedMovingFileFailed(error),
		     let .failedToCalculateSizeForHLSDownload(error),
		     let .failedToCalculateSizeForProgressiveDownload(error),
		     let .readPlaybackMetadataFailed(error),
		     let .djSessionStartFailed(error),
		     let .djSessionSendCommandFailed(error),
		     let .loadUCFailed(error),
		     let .loadPlayerItemFailed(error):
			metadata[Logger.Metadata.errorKey] = "\(String(describing: error))"
		case let .backoffHandleResponseFailed(error, retryStrategy):
			metadata[Logger.Metadata.errorKey] = "\(String(describing: error))"
			metadata[Constants.metadataRetryStrategyKey] = "\(String(describing: retryStrategy))"
		case let .audioCodecInitWithUnknown(codec):
			metadata[Constants.metadataAudioCodecKey] = "\(String(describing: codec))"
		case let .audioCodecInitWithLowQualityAndUnsupportedMode(mode):
			metadata[Constants.metadataAudioModeKey] = "\(String(describing: mode))"
		case let .playbackErrorIdFromSubstatus(substatus):
			metadata[Constants.metadataErrorSubstatusKey] = "\(String(describing: substatus))"
		case let .assetPlaybackMetadataInitWithInvalidFormatFlags(formatFlags):
			metadata[Constants.metadataFormatFlagsKey] = "\(String(describing: formatFlags))"
		case let .changeMonitorHandleNotificationDefaultReason(reason):
			metadata[Constants.metadataRouteChangeReasonKey] = "\(String(describing: reason))"
		case let .audioCodecInitWithNilQuality(mode):
			metadata[Constants.metadataAudioModeKey] = "\(String(describing: mode))"
		case .streamingNotifyGetCredentialFailed,
		     .streamingConnectOfflineMode,
		     .streamingConnectNoToken,
		     .webSocketSendMessageInvalidData,
		     .webSocketReceiveMessageInvalidData,
		     .webSocketHandleErrorRetryStrategyNone,
		     .streamingHandleInvalidMessage,
		     .streamingInterpretInvalidData,
		     .writeEventNotAuthorized,
		     .sendToEventProducerSerializationFailed,
		     .sendEventsNotAuthorized,
		     .getAuthBearerTokenToBearerTokenFailed,
		     .audioCodecInitWithEmpty,
		     .audioCodecInitWithLowQualityAndNilMode,
		     .avplayerSeekWithoutCurrentItem,
		     .interruptionMonitorHandleNotificationWithoutRequiredData,
		     .interruptionMonitorHandleNotificationEndedNoOptions,
		     .interruptionMonitorHandleNotificationEndedNoShouldResume,
		     .interruptionMonitorHandleNotificationEndedNotPlayingWhenInterrupted,
		     .interruptionMonitorHandleNotificationUnknownType,
		     .changeMonitorHandleNotificationWithoutRequiredData,
		     .changeMonitorUpdateVolumeWithoutRequiredData,
		     .handleMediaServicesWereReset,
		     .handleMediaServicesWereLost,
		     .eventSenderInitEventsDirectoryFailed,
		     .eventSenderInitOfflinePlaysDirectoryFailed,
		     .eventSenderInitializeDirectoryNoURLPath,
		     .writeEventNoClientId,
		     .assetPlaybackMetadataInitWithoutRateAndDepthData,
		     .assetPlaybackMetadataInitWithoutRequiredData,
		     .djSessionStartNoCurationURL,
		     .djSessionPlayProductNotTrack,
		     .djSessionPauseNoCurationURL,
		     .djSessionStopNoCurationURL,
		     .djSessionStopOnNextCommand,
		     .djSessionResetNoCurationURL,
		     .djSessionSendStopOnNextCommand,
		     .metricsNoIdealStartTime,
		     .handleErrorNoNotificationsHandler,
		     .handleErrorCancellation,
		     .handleErrorPlayerItemNotCurrent,
		     .handleErrorPlayerItemNotNext,
		     .playWithoutQueuedItems,
		     .itemChangedWithoutQueuedItems,
		     .alreadyInitialized:
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
		     .withDefaultDatabase,
		     .updateDBFileAttributes,
		     .saveOfflinedItemFailed,
		     .deleteOfflinedItemFailed,
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
		     .failedToCalculateSizeForHLSDownload,
		     .failedToCalculateSizeForProgressiveDownload,
		     .readPlaybackMetadataFailed,
		     .djSessionStartFailed,
		     .djSessionSendCommandFailed,
		     .loadUCFailed,
		     .loadPlayerItemFailed,
		     .alreadyInitialized:
			.error
		case .streamingNotifyGetCredentialFailed,
		     .streamingConnectOfflineMode,
		     .streamingConnectNoToken,
		     .webSocketReceiveMessageInvalidData,
		     .webSocketSendMessageInvalidData,
		     .webSocketHandleErrorRetryStrategyNone,
		     .streamingHandleInvalidMessage,
		     .streamingInterpretInvalidData,
		     .audioCodecInitWithEmpty,
		     .audioCodecInitWithUnknown,
		     .audioCodecInitWithNilQuality,
		     .audioCodecInitWithLowQualityAndNilMode,
		     .audioCodecInitWithLowQualityAndUnsupportedMode,
		     .playbackErrorIdFromSubstatus,
		     .avplayerSeekWithoutCurrentItem,
		     .interruptionMonitorHandleNotificationWithoutRequiredData,
		     .interruptionMonitorHandleNotificationEndedNoOptions,
		     .interruptionMonitorHandleNotificationEndedNoShouldResume,
		     .interruptionMonitorHandleNotificationEndedNotPlayingWhenInterrupted,
		     .interruptionMonitorHandleNotificationUnknownType,
		     .changeMonitorHandleNotificationWithoutRequiredData,
		     .changeMonitorHandleNotificationDefaultReason,
		     .changeMonitorUpdateVolumeWithoutRequiredData,
		     .handleMediaServicesWereLost,
		     .handleMediaServicesWereReset,
		     .eventSenderInitEventsDirectoryFailed,
		     .eventSenderInitOfflinePlaysDirectoryFailed,
		     .eventSenderInitializeDirectoryNoURLPath,
		     .writeEventNoClientId,
		     .assetPlaybackMetadataInitWithoutRateAndDepthData,
		     .assetPlaybackMetadataInitWithoutRequiredData,
		     .assetPlaybackMetadataInitWithInvalidFormatFlags,
		     .djSessionStartNoCurationURL,
		     .djSessionPlayProductNotTrack,
		     .djSessionPauseNoCurationURL,
		     .djSessionStopNoCurationURL,
		     .djSessionStopOnNextCommand,
		     .djSessionResetNoCurationURL,
		     .djSessionSendStopOnNextCommand,
		     .metricsNoIdealStartTime,
		     .handleErrorNoNotificationsHandler,
		     .handleErrorCancellation,
		     .handleErrorPlayerItemNotCurrent,
		     .handleErrorPlayerItemNotNext,
		     .playWithoutQueuedItems,
		     .itemChangedWithoutQueuedItems:
			.debug
		}
	}

	var source: String? {
		"Player"
	}
}
