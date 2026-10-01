import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `UserOfflineMixesAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await UserOfflineMixesAPITidal.getResource()
/// ```
public enum UserOfflineMixesAPITidal {


	/**
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_userOfflineMixesIdGet: String, CaseIterable {
		case items = "items"

		func toUserOfflineMixesAPIEnum() -> UserOfflineMixesAPI.IncludeLinkage_userOfflineMixesIdGet {
			switch self {
			case .items: return .items
			}
		}
	}

	/**
     Get single userOfflineMixe.
     
     - returns: UserOfflineMixesSingleResourceDataDocument
     */
	public static func userOfflineMixesIdGet(id: String, locale: String? = nil, include: [String]? = nil, includeLinkage: [UserOfflineMixesAPITidal.IncludeLinkage_userOfflineMixesIdGet]? = nil, replaceMedia: String? = nil) async throws -> UserOfflineMixesSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			UserOfflineMixesAPI.userOfflineMixesIdGetWithRequestBuilder(id: id, locale: locale, include: include, includeLinkage: includeLinkage?.compactMap { $0.toUserOfflineMixesAPIEnum() }, replaceMedia: replaceMedia)
		}
	}


	/**
     Get items relationship (\&quot;to-many\&quot;).
     
     - returns: UserOfflineMixesItemsMultiRelationshipDataDocument
     */
	public static func userOfflineMixesIdRelationshipsItemsGet(id: String, pageCursor: String? = nil, locale: String? = nil, include: [String]? = nil, replaceMedia: String? = nil) async throws -> UserOfflineMixesItemsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserOfflineMixesAPI.userOfflineMixesIdRelationshipsItemsGetWithRequestBuilder(id: id, pageCursor: pageCursor, locale: locale, include: include, replaceMedia: replaceMedia)
		}
	}
}
