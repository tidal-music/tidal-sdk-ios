import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `DspSharingLinksAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await DspSharingLinksAPITidal.getResource()
/// ```
public enum DspSharingLinksAPITidal {


	/**
	 * enum for parameter filterSubjectType
	 */
	public enum FilterSubjectType_dspSharingLinksGet: String, CaseIterable {
		case tracks = "tracks"
		case albums = "albums"
		case artists = "artists"

		func toDspSharingLinksAPIEnum() -> DspSharingLinksAPI.FilterSubjectType_dspSharingLinksGet {
			switch self {
			case .tracks: return .tracks
			case .albums: return .albums
			case .artists: return .artists
			}
		}
	}

	/**
     Get multiple dspSharingLinks.
     
     - returns: DspSharingLinksMultiResourceDataDocument
     */
	public static func dspSharingLinksGet(include: [String]? = nil, filterSubjectId: [String]? = nil, filterSubjectType: [DspSharingLinksAPITidal.FilterSubjectType_dspSharingLinksGet]? = nil) async throws -> DspSharingLinksMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			DspSharingLinksAPI.dspSharingLinksGetWithRequestBuilder(include: include, filterSubjectId: filterSubjectId, filterSubjectType: filterSubjectType?.compactMap { $0.toDspSharingLinksAPIEnum() })
		}
	}


	/**
     Get subject relationship (\&quot;to-one\&quot;).
     
     - returns: DspSharingLinksSingleRelationshipDataDocument
     */
	public static func dspSharingLinksIdRelationshipsSubjectGet(id: String, include: [String]? = nil) async throws -> DspSharingLinksSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			DspSharingLinksAPI.dspSharingLinksIdRelationshipsSubjectGetWithRequestBuilder(id: id, include: include)
		}
	}
}
