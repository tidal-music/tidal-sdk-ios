import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `DownloadsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await DownloadsAPITidal.getResource()
/// ```
public enum DownloadsAPITidal {


	/**
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_downloadsGet: String, CaseIterable {
		case owners = "owners"

		func toDownloadsAPIEnum() -> DownloadsAPI.IncludeLinkage_downloadsGet {
			switch self {
			case .owners: return .owners
			}
		}
	}

	/**
     Get multiple downloads.
     
     - returns: DownloadsMultiResourceDataDocument
     */
	public static func downloadsGet(filterId: [String], include: [String]? = nil, includeLinkage: [DownloadsAPITidal.IncludeLinkage_downloadsGet]? = nil) async throws -> DownloadsMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			DownloadsAPI.downloadsGetWithRequestBuilder(filterId: filterId, include: include, includeLinkage: includeLinkage?.compactMap { $0.toDownloadsAPIEnum() })
		}
	}


	/**
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_downloadsIdGet: String, CaseIterable {
		case owners = "owners"

		func toDownloadsAPIEnum() -> DownloadsAPI.IncludeLinkage_downloadsIdGet {
			switch self {
			case .owners: return .owners
			}
		}
	}

	/**
     Get single download.
     
     - returns: DownloadsSingleResourceDataDocument
     */
	public static func downloadsIdGet(id: String, include: [String]? = nil, includeLinkage: [DownloadsAPITidal.IncludeLinkage_downloadsIdGet]? = nil) async throws -> DownloadsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			DownloadsAPI.downloadsIdGetWithRequestBuilder(id: id, include: include, includeLinkage: includeLinkage?.compactMap { $0.toDownloadsAPIEnum() })
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: DownloadsOwnersMultiRelationshipDataDocument
     */
	public static func downloadsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> DownloadsOwnersMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			DownloadsAPI.downloadsIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}
}
