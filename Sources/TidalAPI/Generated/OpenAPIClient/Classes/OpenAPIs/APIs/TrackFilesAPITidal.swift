import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `TrackFilesAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await TrackFilesAPITidal.getResource()
/// ```
public enum TrackFilesAPITidal {


	/**
	 * enum for parameter formats
	 */
	public enum Formats_trackFilesIdGet: String, CaseIterable {
		case heaacv1 = "HEAACV1"
		case aaclc = "AACLC"
		case flac = "FLAC"
		case flacHires = "FLAC_HIRES"
		case eac3Joc = "EAC3_JOC"

		func toTrackFilesAPIEnum() -> TrackFilesAPI.Formats_trackFilesIdGet {
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
	 * enum for parameter usage
	 */
	public enum Usage_trackFilesIdGet: String, CaseIterable {
		case playback = "PLAYBACK"
		case download = "DOWNLOAD"

		func toTrackFilesAPIEnum() -> TrackFilesAPI.Usage_trackFilesIdGet {
			switch self {
			case .playback: return .playback
			case .download: return .download
			}
		}
	}

	/**
     Get single trackFile.
     
     - returns: TrackFilesSingleResourceDataDocument
     */
	public static func trackFilesIdGet(id: String, formats: [TrackFilesAPITidal.Formats_trackFilesIdGet], usage: TrackFilesAPITidal.Usage_trackFilesIdGet) async throws -> TrackFilesSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			TrackFilesAPI.trackFilesIdGetWithRequestBuilder(id: id, formats: formats.compactMap { $0.toTrackFilesAPIEnum() }, usage: usage.toTrackFilesAPIEnum())
		}
	}
}
