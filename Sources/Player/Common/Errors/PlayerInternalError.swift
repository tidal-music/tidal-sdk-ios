import AVFoundation
import Foundation

// MARK: - PlayerInternalError

public struct PlayerInternalError: Error, CustomStringConvertible, Equatable {
	public enum ErrorType: Int {
		case playbackInfoForbidden = 0
		case playbackInfoNotFound
		case playbackInfoServerError
		case playbackInfoFetcherError
		case drmLicenseError
		case urlSessionError
		case networkError
		case timeOutError
		case httpClientError
		case avPlayerAvError
		case avPlayerUrlError
		case avPlayerOtherError
		case externalPlayerError
		case authError
		case unknown
		case playerLoaderError
		case mediaServicesWereReset
		case playerItemLoaderError
	}

	let errorId: ErrorId
	let errorType: ErrorType
	let errorCode: Int
	let technicalDescription: String?

	var code: String {
		"\(errorType.rawValue):\(errorCode)"
	}

	public var description: String {
		"\(errorId) (\(code)) - [\(technicalDescription ?? "NA")]"
	}

	public init(errorId: ErrorId, errorType: ErrorType, code: Int, description: String? = nil) {
		self.errorId = errorId
		self.errorType = errorType
		errorCode = code
		technicalDescription = description
	}

	static func from(_ error: Error) -> PlayerInternalError {
		if let internalError = error as? PlayerInternalError {
			return internalError
		}
		
		// Handle AVFoundation errors - these are critical for DRM and playback
		if let avError = error as? AVError {
			return mapAVFoundationError(avError)
		}
		
		// Handle URL errors (network/connection issues)
		if let urlError = error as? URLError {
			return mapURLError(urlError)
		}
		
		// Handle Foundation errors that might be wrapped
		let nsError = error as NSError
		
		// Check error domain to categorize by source
		switch nsError.domain {
		case AVFoundationErrorDomain:
			return mapAVFoundationNSError(nsError)
		case NSURLErrorDomain:
			return mapURLNSError(nsError)
		case NSOSStatusErrorDomain:
			return mapOSStatusError(nsError)
		default:
			// Only use .unknown when we truly can't determine the domain
			return PlayerInternalError(
				errorId: .EUnexpected,
				errorType: .unknown,
				code: nsError.code,
				description: String(describing: error)
			)
		}
	}

	func toPlayerError() -> PlayerError {
		PlayerError(errorId: errorId, errorCode: code)
	}
	
	// MARK: - Private Error Mapping Functions
	
	private static func mapAVFoundationError(_ avError: AVError) -> PlayerInternalError {
		switch avError.code {
		// DRM-related errors
		case .contentKeyRequestCancelled, .contentIsUnavailable:
			return PlayerInternalError(
				errorId: .PERetryable,
				errorType: .drmLicenseError,
				code: avError.code.rawValue,
				description: avError.localizedDescription
			)
		
		// Other AVPlayer errors
		default:
			return PlayerInternalError(
				errorId: .EUnexpected,
				errorType: .avPlayerAvError,
				code: avError.code.rawValue,
				description: avError.localizedDescription
			)
		}
	}
	
	private static func mapAVFoundationNSError(_ nsError: NSError) -> PlayerInternalError {
		switch nsError.code {
		// Your specific DRM error codes
		case -11800, -11862:
			return PlayerInternalError(
				errorId: .PERetryable,
				errorType: .drmLicenseError,
				code: nsError.code,
				description: nsError.localizedDescription
			)
		
		// URL-related AVFoundation errors
		case -11849, -11850:
			return PlayerInternalError(
				errorId: .PENetwork,
				errorType: .avPlayerUrlError,
				code: nsError.code,
				description: nsError.localizedDescription
			)
		
		// Other AVFoundation errors
		default:
			return PlayerInternalError(
				errorId: .EUnexpected,
				errorType: .avPlayerOtherError,
				code: nsError.code,
				description: nsError.localizedDescription
			)
		}
	}
	
	private static func mapURLError(_ urlError: URLError) -> PlayerInternalError {
		switch urlError.code {
		case .cancelled:
			// Special case - cancellation should be handled differently
			return PlayerInternalError(
				errorId: .EUnexpected,
				errorType: .urlSessionError,
				code: urlError.code.rawValue,
				description: "Operation cancelled"
			)
		case .timedOut:
			return PlayerInternalError(
				errorId: .PENetwork,
				errorType: .timeOutError,
				code: urlError.code.rawValue,
				description: urlError.localizedDescription
			)
		case .networkConnectionLost, .notConnectedToInternet, .cannotFindHost, .cannotConnectToHost, .dnsLookupFailed:
			return PlayerInternalError(
				errorId: .PENetwork,
				errorType: .networkError,
				code: urlError.code.rawValue,
				description: urlError.localizedDescription
			)
		default:
			return PlayerInternalError(
				errorId: .PERetryable,
				errorType: .urlSessionError,
				code: urlError.code.rawValue,
				description: urlError.localizedDescription
			)
		}
	}
	
	private static func mapURLNSError(_ nsError: NSError) -> PlayerInternalError {
		// Handle NSURLError domain errors that aren't URLError instances
		switch nsError.code {
		case URLError.cancelled.rawValue:
			return PlayerInternalError(
				errorId: .EUnexpected,
				errorType: .urlSessionError,
				code: nsError.code,
				description: "Operation cancelled"
			)
		case URLError.timedOut.rawValue:
			return PlayerInternalError(
				errorId: .PENetwork,
				errorType: .timeOutError,
				code: nsError.code,
				description: nsError.localizedDescription
			)
		case URLError.networkConnectionLost.rawValue, URLError.notConnectedToInternet.rawValue, 
			 URLError.cannotFindHost.rawValue, URLError.cannotConnectToHost.rawValue, URLError.dnsLookupFailed.rawValue:
			return PlayerInternalError(
				errorId: .PENetwork,
				errorType: .networkError,
				code: nsError.code,
				description: nsError.localizedDescription
			)
		default:
			return PlayerInternalError(
				errorId: .PERetryable,
				errorType: .urlSessionError,
				code: nsError.code,
				description: nsError.localizedDescription
			)
		}
	}
	
	private static func mapOSStatusError(_ nsError: NSError) -> PlayerInternalError {
		// OSStatus errors from Core Audio, Security framework, DRM, etc.
		switch nsError.code {
		// Known DRM-related OSStatus errors from your logs
		case -19156, -17377, -12158:
			return PlayerInternalError(
				errorId: .PERetryable,
				errorType: .drmLicenseError,
				code: nsError.code,
				description: nsError.localizedDescription
			)
		
		// Audio-related OSStatus errors (Core Audio framework)
		case -50, -66, -10851, -10852, -10853, -10854:
			return PlayerInternalError(
				errorId: .PERetryable,
				errorType: .avPlayerOtherError,
				code: nsError.code,
				description: nsError.localizedDescription
			)
		
		// Security framework errors that might be DRM-related
		case -25293, -25300, -25301, -25308:
			return PlayerInternalError(
				errorId: .PERetryable,
				errorType: .drmLicenseError,
				code: nsError.code,
				description: nsError.localizedDescription
			)
		
		default:
			// Only use .unknown for truly unknown OSStatus codes
			return PlayerInternalError(
				errorId: .EUnexpected,
				errorType: .unknown,
				code: nsError.code,
				description: nsError.localizedDescription
			)
		}
	}
}

extension Error {
	func isNetworkError() -> Bool {
		(self as? PlayerInternalError)?.errorType == .networkError
	}
}
