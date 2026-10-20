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
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_userDiscoveryMixesIdGet: String, CaseIterable {
		case items = "items"

		func toUserDiscoveryMixesAPIEnum() -> UserDiscoveryMixesAPI.IncludeLinkage_userDiscoveryMixesIdGet {
			switch self {
			case .items: return .items
			}
		}
	}

	/**
     Get single userDiscoveryMixe.
     
     - returns: UserDiscoveryMixesSingleResourceDataDocument
     */
	public static func userDiscoveryMixesIdGet(id: String, include: [String]? = nil, includeLinkage: [UserDiscoveryMixesAPITidal.IncludeLinkage_userDiscoveryMixesIdGet]? = nil, locale: String? = nil, replaceMedia: String? = nil) async throws -> UserDiscoveryMixesSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			UserDiscoveryMixesAPI.userDiscoveryMixesIdGetWithRequestBuilder(id: id, include: include, includeLinkage: includeLinkage?.compactMap { $0.toUserDiscoveryMixesAPIEnum() }, locale: locale, replaceMedia: replaceMedia)
		}
	}


	/**
     Get items relationship (\&quot;to-many\&quot;).
     
     - returns: UserDiscoveryMixesItemsMultiRelationshipDataDocument
     */
	public static func userDiscoveryMixesIdRelationshipsItemsGet(id: String, include: [String]? = nil, locale: String? = nil, pageCursor: String? = nil, replaceMedia: String? = nil) async throws -> UserDiscoveryMixesItemsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserDiscoveryMixesAPI.userDiscoveryMixesIdRelationshipsItemsGetWithRequestBuilder(id: id, include: include, locale: locale, pageCursor: pageCursor, replaceMedia: replaceMedia)
		}
	}
}
