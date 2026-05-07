import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `PurchasesAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await PurchasesAPITidal.getResource()
/// ```
public enum PurchasesAPITidal {


	/**
	 * enum for parameter filterSubjectType
	 */
	public enum FilterSubjectType_purchasesGet: String, CaseIterable {
		case albums = "albums"
		case tracks = "tracks"

		func toPurchasesAPIEnum() -> PurchasesAPI.FilterSubjectType_purchasesGet {
			switch self {
			case .albums: return .albums
			case .tracks: return .tracks
			}
		}
	}

	/**
     Get multiple purchases.
     
     - returns: PurchasesMultiResourceDataDocument
     */
	public static func purchasesGet(pageCursor: String? = nil, include: [String]? = nil, filterOwnersId: [String]? = nil, filterSubjectType: [PurchasesAPITidal.FilterSubjectType_purchasesGet]? = nil) async throws -> PurchasesMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			PurchasesAPI.purchasesGetWithRequestBuilder(pageCursor: pageCursor, include: include, filterOwnersId: filterOwnersId, filterSubjectType: filterSubjectType?.compactMap { $0.toPurchasesAPIEnum() })
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: PurchasesMultiRelationshipDataDocument
     */
	public static func purchasesIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> PurchasesMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			PurchasesAPI.purchasesIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get subject relationship (\&quot;to-one\&quot;).
     
     - returns: PurchasesSingleRelationshipDataDocument
     */
	public static func purchasesIdRelationshipsSubjectGet(id: String, include: [String]? = nil) async throws -> PurchasesSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			PurchasesAPI.purchasesIdRelationshipsSubjectGetWithRequestBuilder(id: id, include: include)
		}
	}
}
