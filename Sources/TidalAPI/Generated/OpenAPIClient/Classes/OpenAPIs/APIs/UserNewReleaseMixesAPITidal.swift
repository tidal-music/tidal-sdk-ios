import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `UserNewReleaseMixesAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await UserNewReleaseMixesAPITidal.getResource()
/// ```
public enum UserNewReleaseMixesAPITidal {


	/**
     Get single userNewReleaseMixe.
     
     - returns: UserNewReleaseMixesSingleResourceDataDocument
     */
	public static func userNewReleaseMixesIdGet(id: String, countryCode: String? = nil, locale: String? = nil, include: [String]? = nil) async throws -> UserNewReleaseMixesSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			UserNewReleaseMixesAPI.userNewReleaseMixesIdGetWithRequestBuilder(id: id, countryCode: countryCode, locale: locale, include: include)
		}
	}


	/**
     Get items relationship (\&quot;to-many\&quot;).
     
     - returns: UserNewReleaseMixesMultiRelationshipDataDocument
     */
	public static func userNewReleaseMixesIdRelationshipsItemsGet(id: String, pageCursor: String? = nil, countryCode: String? = nil, locale: String? = nil, include: [String]? = nil) async throws -> UserNewReleaseMixesMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserNewReleaseMixesAPI.userNewReleaseMixesIdRelationshipsItemsGetWithRequestBuilder(id: id, pageCursor: pageCursor, countryCode: countryCode, locale: locale, include: include)
		}
	}
}
