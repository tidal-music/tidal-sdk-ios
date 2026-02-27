import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `VideoManifestsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await VideoManifestsAPITidal.getResource()
/// ```
public enum VideoManifestsAPITidal {


	/**
	 * enum for parameter uriScheme
	 */
	public enum UriScheme_videoManifestsIdGet: String, CaseIterable {
		case https = "HTTPS"
		case data = "DATA"

		func toVideoManifestsAPIEnum() -> VideoManifestsAPI.UriScheme_videoManifestsIdGet {
			switch self {
			case .https: return .https
			case .data: return .data
			}
		}
	}

	/**
	 * enum for parameter usage
	 */
	public enum Usage_videoManifestsIdGet: String, CaseIterable {
		case playback = "PLAYBACK"
		case download = "DOWNLOAD"

		func toVideoManifestsAPIEnum() -> VideoManifestsAPI.Usage_videoManifestsIdGet {
			switch self {
			case .playback: return .playback
			case .download: return .download
			}
		}
	}

	/**
     Get single videoManifest.
     
     - returns: VideoManifestsSingleResourceDataDocument
     */
	public static func videoManifestsIdGet(id: String, uriScheme: VideoManifestsAPITidal.UriScheme_videoManifestsIdGet, usage: VideoManifestsAPITidal.Usage_videoManifestsIdGet) async throws -> VideoManifestsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			VideoManifestsAPI.videoManifestsIdGetWithRequestBuilder(id: id, uriScheme: uriScheme.toVideoManifestsAPIEnum(), usage: usage.toVideoManifestsAPIEnum())
		}
	}
}
