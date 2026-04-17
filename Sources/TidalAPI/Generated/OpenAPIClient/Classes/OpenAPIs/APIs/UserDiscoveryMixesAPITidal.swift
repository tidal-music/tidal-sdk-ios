import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `UserDiscoveryMixesAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await UserDiscoveryMixesAPITidal.getResource()
/// ```
public enum UserDiscoveryMixesAPITidal {


	/**
     Get single userDiscoveryMixe.
     
     - returns: UserDiscoveryMixesSingleResourceDataDocument
     */
	public static func userDiscoveryMixesIdGet(id: String, countryCode: String? = nil, locale: String? = nil, include: [String]? = nil) async throws -> UserDiscoveryMixesSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			UserDiscoveryMixesAPI.userDiscoveryMixesIdGetWithRequestBuilder(id: id, countryCode: countryCode, locale: locale, include: include)
		}
	}


	/**
     Get items relationship (\&quot;to-many\&quot;).
     
     - returns: UserDiscoveryMixesMultiRelationshipDataDocument
     */
	public static func userDiscoveryMixesIdRelationshipsItemsGet(id: String, pageCursor: String? = nil, countryCode: String? = nil, locale: String? = nil, include: [String]? = nil) async throws -> UserDiscoveryMixesMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserDiscoveryMixesAPI.userDiscoveryMixesIdRelationshipsItemsGetWithRequestBuilder(id: id, pageCursor: pageCursor, countryCode: countryCode, locale: locale, include: include)
		}
	}
}
