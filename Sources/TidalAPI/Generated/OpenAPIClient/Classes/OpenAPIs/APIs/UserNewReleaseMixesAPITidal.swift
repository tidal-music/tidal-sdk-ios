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
	public static func userNewReleaseMixesIdGet(id: String, locale: String? = nil, include: [String]? = nil, includeLinkage: [UserNewReleaseMixesAPITidal.IncludeLinkage_userNewReleaseMixesIdGet]? = nil, replaceMedia: String? = nil) async throws -> UserNewReleaseMixesSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			UserNewReleaseMixesAPI.userNewReleaseMixesIdGetWithRequestBuilder(id: id, locale: locale, include: include, includeLinkage: includeLinkage?.compactMap { $0.toUserNewReleaseMixesAPIEnum() }, replaceMedia: replaceMedia)
		}
	}


	/**
     Get items relationship (\&quot;to-many\&quot;).
     
     - returns: UserNewReleaseMixesItemsMultiRelationshipDataDocument
     */
	public static func userNewReleaseMixesIdRelationshipsItemsGet(id: String, pageCursor: String? = nil, locale: String? = nil, include: [String]? = nil, replaceMedia: String? = nil) async throws -> UserNewReleaseMixesItemsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserNewReleaseMixesAPI.userNewReleaseMixesIdRelationshipsItemsGetWithRequestBuilder(id: id, pageCursor: pageCursor, locale: locale, include: include, replaceMedia: replaceMedia)
		}
	}
}
