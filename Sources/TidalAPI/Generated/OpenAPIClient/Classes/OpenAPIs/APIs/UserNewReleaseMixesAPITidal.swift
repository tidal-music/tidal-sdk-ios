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
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_userNewReleaseMixesIdGet: String, CaseIterable {
		case items = "items"

		func toUserNewReleaseMixesAPIEnum() -> UserNewReleaseMixesAPI.IncludeLinkage_userNewReleaseMixesIdGet {
			switch self {
			case .items: return .items
			}
		}
	}

	/**
     Get single userNewReleaseMixe.
     
     - returns: UserNewReleaseMixesSingleResourceDataDocument
     */
	public static func userNewReleaseMixesIdGet(id: String, include: [String]? = nil, includeLinkage: [UserNewReleaseMixesAPITidal.IncludeLinkage_userNewReleaseMixesIdGet]? = nil, locale: String? = nil, replaceMedia: String? = nil) async throws -> UserNewReleaseMixesSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			UserNewReleaseMixesAPI.userNewReleaseMixesIdGetWithRequestBuilder(id: id, include: include, includeLinkage: includeLinkage?.compactMap { $0.toUserNewReleaseMixesAPIEnum() }, locale: locale, replaceMedia: replaceMedia)
		}
	}


	/**
     Get items relationship (\&quot;to-many\&quot;).
     
     - returns: UserNewReleaseMixesItemsMultiRelationshipDataDocument
     */
	public static func userNewReleaseMixesIdRelationshipsItemsGet(id: String, include: [String]? = nil, locale: String? = nil, pageCursor: String? = nil, replaceMedia: String? = nil) async throws -> UserNewReleaseMixesItemsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserNewReleaseMixesAPI.userNewReleaseMixesIdRelationshipsItemsGetWithRequestBuilder(id: id, include: include, locale: locale, pageCursor: pageCursor, replaceMedia: replaceMedia)
		}
	}
}
