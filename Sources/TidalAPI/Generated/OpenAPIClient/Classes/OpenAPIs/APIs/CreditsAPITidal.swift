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
     Get multiple credits.
     
     - returns: CreditsMultiResourceDataDocument
     */
	public static func creditsGet(include: [String]? = nil, filterId: [String]? = nil) async throws -> CreditsMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			CreditsAPI.creditsGetWithRequestBuilder(include: include, filterId: filterId)
		}
	}


	/**
     Get single credit.
     
     - returns: CreditsSingleResourceDataDocument
     */
	public static func creditsIdGet(id: String, include: [String]? = nil) async throws -> CreditsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			CreditsAPI.creditsIdGetWithRequestBuilder(id: id, include: include)
		}
	}


	/**
     Get artist relationship (\&quot;to-one\&quot;).
     
     - returns: CreditsSingleRelationshipDataDocument
     */
	public static func creditsIdRelationshipsArtistGet(id: String, include: [String]? = nil) async throws -> CreditsSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			CreditsAPI.creditsIdRelationshipsArtistGetWithRequestBuilder(id: id, include: include)
		}
	}


	/**
     Get category relationship (\&quot;to-one\&quot;).
     
     - returns: CreditsSingleRelationshipDataDocument
     */
	public static func creditsIdRelationshipsCategoryGet(id: String, include: [String]? = nil) async throws -> CreditsSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			CreditsAPI.creditsIdRelationshipsCategoryGetWithRequestBuilder(id: id, include: include)
		}
	}
}
