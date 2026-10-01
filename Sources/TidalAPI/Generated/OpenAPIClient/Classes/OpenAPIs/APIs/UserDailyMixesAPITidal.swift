import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `UserDailyMixesAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await UserDailyMixesAPITidal.getResource()
/// ```
public enum UserDailyMixesAPITidal {


	/**
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_userDailyMixesIdGet: String, CaseIterable {
		case items = "items"

		func toUserDailyMixesAPIEnum() -> UserDailyMixesAPI.IncludeLinkage_userDailyMixesIdGet {
			switch self {
			case .items: return .items
			}
		}
	}

	/**
     Get single userDailyMixe.
     
     - returns: UserDailyMixesSingleResourceDataDocument
     */
	public static func userDailyMixesIdGet(id: String, locale: String? = nil, include: [String]? = nil, includeLinkage: [UserDailyMixesAPITidal.IncludeLinkage_userDailyMixesIdGet]? = nil, replaceMedia: String? = nil) async throws -> UserDailyMixesSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			UserDailyMixesAPI.userDailyMixesIdGetWithRequestBuilder(id: id, locale: locale, include: include, includeLinkage: includeLinkage?.compactMap { $0.toUserDailyMixesAPIEnum() }, replaceMedia: replaceMedia)
		}
	}


	/**
     Get items relationship (\&quot;to-many\&quot;).
     
     - returns: UserDailyMixesItemsMultiRelationshipDataDocument
     */
	public static func userDailyMixesIdRelationshipsItemsGet(id: String, pageCursor: String? = nil, locale: String? = nil, include: [String]? = nil, replaceMedia: String? = nil) async throws -> UserDailyMixesItemsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserDailyMixesAPI.userDailyMixesIdRelationshipsItemsGetWithRequestBuilder(id: id, pageCursor: pageCursor, locale: locale, include: include, replaceMedia: replaceMedia)
		}
	}
}
