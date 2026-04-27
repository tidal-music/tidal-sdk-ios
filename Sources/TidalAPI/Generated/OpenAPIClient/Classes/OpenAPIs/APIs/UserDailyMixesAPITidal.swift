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
     Get single userDailyMixe.
     
     - returns: UserDailyMixesSingleResourceDataDocument
     */
	public static func userDailyMixesIdGet(id: String, countryCode: String? = nil, locale: String? = nil, include: [String]? = nil) async throws -> UserDailyMixesSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			UserDailyMixesAPI.userDailyMixesIdGetWithRequestBuilder(id: id, countryCode: countryCode, locale: locale, include: include)
		}
	}


	/**
     Get items relationship (\&quot;to-many\&quot;).
     
     - returns: UserDailyMixesMultiRelationshipDataDocument
     */
	public static func userDailyMixesIdRelationshipsItemsGet(id: String, pageCursor: String? = nil, locale: String? = nil, include: [String]? = nil) async throws -> UserDailyMixesMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserDailyMixesAPI.userDailyMixesIdRelationshipsItemsGetWithRequestBuilder(id: id, pageCursor: pageCursor, locale: locale, include: include)
		}
	}
}
