import Foundation

/// Represents errors that can occur during offline download operations.
public enum OfflineError: Error {
	/// Network-related errors such as connection loss, timeout, or no internet.
	case networkError(underlying: Error)

	/// Authentication error, typically HTTP 401. Token may be expired or invalid.
	case authenticationError(statusCode: Int)

	/// Authorization error, typically HTTP 403. Content may be geo-blocked or user lacks permission.
	case authorizationError(statusCode: Int)

	/// Rate limiting error, typically HTTP 429. Includes optional retry-after delay.
	case rateLimitExceeded(retryAfter: TimeInterval?)

	/// Server error, typically HTTP 5xx (500, 502, 503, etc.).
	case serverError(statusCode: Int)

	/// Content is not available, typically HTTP 404. Content may have been deleted or is not ready.
	case contentNotAvailable(statusCode: Int)

	/// Device has insufficient storage space for the download.
	case insufficientStorage

	/// Unknown or unclassified error.
	case unknown(underlying: Error?)

	// MARK: - Error Mapping

	/// Maps internal SDK errors to public OfflineError types.
	/// This enables intelligent retry strategies in client applications.
	static func from(_ error: Error) -> OfflineError {
		// Handle HTTP errors
		if let httpError = error as? HttpError {
			switch httpError {
			case let .httpClientError(statusCode, _):
				return mapHTTPClientError(statusCode: statusCode)
			case let .httpServerError(statusCode):
				return .serverError(statusCode: statusCode)
			}
		}

		// Handle PlayerInternalError
		if let internalError = error as? PlayerInternalError {
			return mapPlayerInternalError(internalError)
		}

		// Handle URL errors (network issues)
		if let urlError = error as? URLError {
			return mapURLError(urlError)
		}

		// Handle NSError for additional network and storage errors
		let nsError = error as NSError
		return mapNSError(nsError, originalError: error)
	}

	// MARK: - Private Mapping Helpers

	private static func mapHTTPClientError(statusCode: Int) -> OfflineError {
		switch statusCode {
		case 401:
			return .authenticationError(statusCode: statusCode)
		case 403:
			return .authorizationError(statusCode: statusCode)
		case 404:
			return .contentNotAvailable(statusCode: statusCode)
		case 429:
			// TODO: Extract retry-after header if available from response
			return .rateLimitExceeded(retryAfter: nil)
		default:
			return .unknown(underlying: nil)
		}
	}

	private static func mapPlayerInternalError(_ error: PlayerInternalError) -> OfflineError {
		switch error.errorType {
		case .networkError, .timeOutError:
			return .networkError(underlying: error)
		case .authError:
			return .authenticationError(statusCode: 401)
		case .playbackInfoForbidden:
			return .authorizationError(statusCode: 403)
		case .playbackInfoNotFound:
			return .contentNotAvailable(statusCode: 404)
		case .playbackInfoServerError:
			return .serverError(statusCode: 500)
		case .httpClientError:
			// Try to extract status code from error code if available
			return .unknown(underlying: error)
		default:
			return .unknown(underlying: error)
		}
	}

	private static func mapURLError(_ urlError: URLError) -> OfflineError {
		switch urlError.code {
		case .networkConnectionLost, .notConnectedToInternet, .cannotFindHost,
		     .cannotConnectToHost, .dnsLookupFailed, .timedOut:
			return .networkError(underlying: urlError)
		default:
			return .unknown(underlying: urlError)
		}
	}

	private static func mapNSError(_ nsError: NSError, originalError: Error) -> OfflineError {
		// Check for storage errors
		if nsError.domain == NSCocoaErrorDomain {
			switch nsError.code {
			case NSFileWriteOutOfSpaceError:
				return .insufficientStorage
			default:
				break
			}
		}

		// Check for network errors in NSURLErrorDomain
		if nsError.domain == NSURLErrorDomain {
			switch nsError.code {
			case URLError.networkConnectionLost.rawValue,
			     URLError.notConnectedToInternet.rawValue,
			     URLError.timedOut.rawValue,
			     URLError.cannotFindHost.rawValue,
			     URLError.cannotConnectToHost.rawValue,
			     URLError.dnsLookupFailed.rawValue:
				return .networkError(underlying: originalError)
			default:
				break
			}
		}

		return .unknown(underlying: originalError)
	}
}

public protocol OfflineEngineListener: AnyObject {
	func offliningStarted(for mediaProduct: MediaProduct)
	func offliningProgressed(for mediaProduct: MediaProduct, is downloadPercentage: Double)
	func offliningCompleted(for mediaProduct: MediaProduct)

	/// Called when a download fails. Override this method to receive detailed error information.
	/// - Parameters:
	///   - mediaProduct: The media product that failed to download
	///   - error: Detailed error information including type (network, auth, etc.) and context
	func offliningFailed(for mediaProduct: MediaProduct, error: OfflineError)

	func offlinedDeleted(for mediaProduct: MediaProduct)
	func allOfflinedMediaProductsDeleted()
}
