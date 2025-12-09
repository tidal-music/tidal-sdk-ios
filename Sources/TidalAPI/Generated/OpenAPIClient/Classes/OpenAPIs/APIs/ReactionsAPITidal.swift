import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `ReactionsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await ReactionsAPITidal.getResource()
/// ```
public enum ReactionsAPITidal {


	/**
	 * enum for parameter stats
	 */
	public enum Stats_reactionsGet: String, CaseIterable {
		case all = "ALL"
		case countsByType = "COUNTS_BY_TYPE"
		case totalCount = "TOTAL_COUNT"

		func toReactionsAPIEnum() -> ReactionsAPI.Stats_reactionsGet {
			switch self {
			case .all: return .all
			case .countsByType: return .countsByType
			case .totalCount: return .totalCount
			}
		}
	}

	/**
     Get multiple reactions.
     
     - returns: ReactionsMultiResourceDataDocument
     */
	public static func reactionsGet(stats: ReactionsAPITidal.Stats_reactionsGet? = nil, statsOnly: Bool? = nil, pageCursor: String? = nil, include: [String]? = nil, filterOwnerId: [String]? = nil, filterReactedResourceId: [String]? = nil, filterReactedResourceType: [String]? = nil, filterReactionType: [String]? = nil) async throws -> ReactionsMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			ReactionsAPI.reactionsGetWithRequestBuilder(stats: stats?.toReactionsAPIEnum(), statsOnly: statsOnly, pageCursor: pageCursor, include: include, filterOwnerId: filterOwnerId, filterReactedResourceId: filterReactedResourceId, filterReactedResourceType: filterReactedResourceType, filterReactionType: filterReactionType)
		}
	}


	/**
     Delete single reaction.
     
     - returns: 
     */
	public static func reactionsIdDelete(id: String) async throws {
		return try await RequestHelper.createRequest {
			ReactionsAPI.reactionsIdDeleteWithRequestBuilder(id: id)
		}
	}


	/**
     Get ownerProfiles relationship (\&quot;to-many\&quot;).
     
     - returns: ReactionsMultiRelationshipDataDocument
     */
	public static func reactionsIdRelationshipsOwnerProfilesGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> ReactionsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ReactionsAPI.reactionsIdRelationshipsOwnerProfilesGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Create single reaction.
     
     - returns: ReactionsSingleResourceDataDocument
     */
	public static func reactionsPost(createReactionPayload: CreateReactionPayload? = nil) async throws -> ReactionsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			ReactionsAPI.reactionsPostWithRequestBuilder(createReactionPayload: createReactionPayload)
		}
	}
}
