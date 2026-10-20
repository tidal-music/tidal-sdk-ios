import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `UserFeedItemsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await UserFeedItemsAPITidal.getResource()
/// ```
public enum UserFeedItemsAPITidal {


	/**
	 * enum for parameter filterSurface
	 */
	public enum FilterSurface_userFeedItemsGet: String, CaseIterable {
		case inbox = "INBOX"
		case feed = "FEED"

		func toUserFeedItemsAPIEnum() -> UserFeedItemsAPI.FilterSurface_userFeedItemsGet {
			switch self {
			case .inbox: return .inbox
			case .feed: return .feed
			}
		}
	}

	/**
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_userFeedItemsGet: String, CaseIterable {
		case actors = "actors"
		case subject = "subject"

		func toUserFeedItemsAPIEnum() -> UserFeedItemsAPI.IncludeLinkage_userFeedItemsGet {
			switch self {
			case .actors: return .actors
			case .subject: return .subject
			}
		}
	}

	/**
     Get multiple userFeedItems.
     
     - returns: UserFeedItemsMultiResourceDataDocument
     */
	public static func userFeedItemsGet(filterOwnersId: [String], filterSurface: UserFeedItemsAPITidal.FilterSurface_userFeedItemsGet, include: [String]? = nil, includeLinkage: [UserFeedItemsAPITidal.IncludeLinkage_userFeedItemsGet]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil) async throws -> UserFeedItemsMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			UserFeedItemsAPI.userFeedItemsGetWithRequestBuilder(filterOwnersId: filterOwnersId, filterSurface: filterSurface.toUserFeedItemsAPIEnum(), include: include, includeLinkage: includeLinkage?.compactMap { $0.toUserFeedItemsAPIEnum() }, pageCursor: pageCursor, replaceMedia: replaceMedia)
		}
	}


	/**
     Get actors relationship (\&quot;to-many\&quot;).
     
     - returns: UserFeedItemsActorsMultiRelationshipDataDocument
     */
	public static func userFeedItemsIdRelationshipsActorsGet(id: String, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil) async throws -> UserFeedItemsActorsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserFeedItemsAPI.userFeedItemsIdRelationshipsActorsGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia)
		}
	}


	/**
     Get subject relationship (\&quot;to-one\&quot;).
     
     - returns: UserFeedItemsSubjectSingleRelationshipDataDocument
     */
	public static func userFeedItemsIdRelationshipsSubjectGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> UserFeedItemsSubjectSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserFeedItemsAPI.userFeedItemsIdRelationshipsSubjectGetWithRequestBuilder(id: id, include: include, replaceMedia: replaceMedia)
		}
	}
}
