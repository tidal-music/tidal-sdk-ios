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
     Get single userOfflineMixe.
     
     - returns: UserOfflineMixesSingleResourceDataDocument
     */
	public static func userOfflineMixesIdGet(id: String, countryCode: String? = nil, locale: String? = nil, include: [String]? = nil) async throws -> UserOfflineMixesSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			UserOfflineMixesAPI.userOfflineMixesIdGetWithRequestBuilder(id: id, countryCode: countryCode, locale: locale, include: include)
		}
	}


	/**
     Get items relationship (\&quot;to-many\&quot;).
     
     - returns: UserOfflineMixesMultiRelationshipDataDocument
     */
	public static func userOfflineMixesIdRelationshipsItemsGet(id: String, pageCursor: String? = nil, locale: String? = nil, include: [String]? = nil) async throws -> UserOfflineMixesMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserOfflineMixesAPI.userOfflineMixesIdRelationshipsItemsGetWithRequestBuilder(id: id, pageCursor: pageCursor, locale: locale, include: include)
		}
	}
}
