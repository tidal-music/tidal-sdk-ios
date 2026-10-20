import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `TrackManifestsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await TrackManifestsAPITidal.getResource()
/// ```
public enum TrackManifestsAPITidal {


	/**
	 * enum for parameter formats
	 */
	public enum Formats_trackManifestsIdGet: String, CaseIterable {
		case heaacv1 = "HEAACV1"
		case aaclc = "AACLC"
		case flac = "FLAC"
		case flacHires = "FLAC_HIRES"
		case eac3Joc = "EAC3_JOC"

		func toTrackManifestsAPIEnum() -> TrackManifestsAPI.Formats_trackManifestsIdGet {
			switch self {
			case .heaacv1: return .heaacv1
			case .aaclc: return .aaclc
			case .flac: return .flac
			case .flacHires: return .flacHires
			case .eac3Joc: return .eac3Joc
			}
		}
	}

	/**
	 * enum for parameter manifestType
	 */
	public enum ManifestType_trackManifestsIdGet: String, CaseIterable {
		case hls = "HLS"
		case mpegDash = "MPEG_DASH"

		func toTrackManifestsAPIEnum() -> TrackManifestsAPI.ManifestType_trackManifestsIdGet {
			switch self {
			case .hls: return .hls
			case .mpegDash: return .mpegDash
			}
		}
	}

	/**
	 * enum for parameter uriScheme
	 */
	public enum UriScheme_trackManifestsIdGet: String, CaseIterable {
		case https = "HTTPS"
		case data = "DATA"

		func toTrackManifestsAPIEnum() -> TrackManifestsAPI.UriScheme_trackManifestsIdGet {
			switch self {
			case .https: return .https
			case .data: return .data
			}
		}
	}

	/**
	 * enum for parameter usage
	 */
	public enum Usage_trackManifestsIdGet: String, CaseIterable {
		case playback = "PLAYBACK"
		case download = "DOWNLOAD"

		func toTrackManifestsAPIEnum() -> TrackManifestsAPI.Usage_trackManifestsIdGet {
			switch self {
			case .playback: return .playback
			case .download: return .download
			}
		}
	}

	/**
     Get single trackManifest.
     
     - returns: TrackManifestsSingleResourceDataDocument
     */
	public static func trackManifestsIdGet(adaptive: Bool, formats: [TrackManifestsAPITidal.Formats_trackManifestsIdGet], id: String, manifestType: TrackManifestsAPITidal.ManifestType_trackManifestsIdGet, uriScheme: TrackManifestsAPITidal.UriScheme_trackManifestsIdGet, usage: TrackManifestsAPITidal.Usage_trackManifestsIdGet, shareCode: String? = nil) async throws -> TrackManifestsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			TrackManifestsAPI.trackManifestsIdGetWithRequestBuilder(adaptive: adaptive, formats: formats.compactMap { $0.toTrackManifestsAPIEnum() }, id: id, manifestType: manifestType.toTrackManifestsAPIEnum(), uriScheme: uriScheme.toTrackManifestsAPIEnum(), usage: usage.toTrackManifestsAPIEnum(), shareCode: shareCode)
		}
	}
}
