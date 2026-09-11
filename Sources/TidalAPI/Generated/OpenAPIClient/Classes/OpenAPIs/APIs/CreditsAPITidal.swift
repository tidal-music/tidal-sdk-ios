import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `CreditsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await CreditsAPITidal.getResource()
/// ```
public enum CreditsAPITidal {


	/**
     Get single credit.
     
     - returns: CreditsSingleResourceDataDocument
     */
	public static func creditsIdGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> CreditsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			CreditsAPI.creditsIdGetWithRequestBuilder(id: id, include: include, replaceMedia: replaceMedia)
		}
	}


	/**
     Get artist relationship (\&quot;to-one\&quot;).
     
     - returns: CreditsArtistSingleRelationshipDataDocument
     */
	public static func creditsIdRelationshipsArtistGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> CreditsArtistSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			CreditsAPI.creditsIdRelationshipsArtistGetWithRequestBuilder(id: id, include: include, replaceMedia: replaceMedia)
		}
	}


	/**
     Get category relationship (\&quot;to-one\&quot;).
     
     - returns: CreditsCategorySingleRelationshipDataDocument
     */
	public static func creditsIdRelationshipsCategoryGet(id: String, include: [String]? = nil) async throws -> CreditsCategorySingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			CreditsAPI.creditsIdRelationshipsCategoryGetWithRequestBuilder(id: id, include: include)
		}
	}
}
