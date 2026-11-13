import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `UserDataExportsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await UserDataExportsAPITidal.getResource()
/// ```
public enum UserDataExportsAPITidal {


	/**
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_userDataExportsGet: String, CaseIterable {
		case owners = "owners"

		func toUserDataExportsAPIEnum() -> UserDataExportsAPI.IncludeLinkage_userDataExportsGet {
			switch self {
			case .owners: return .owners
			}
		}
	}

	/**
     Get multiple userDataExports.
     
     - returns: UserDataExportsMultiResourceDataDocument
     */
	public static func userDataExportsGet(filterOwnersId: [String], include: [String]? = nil, includeLinkage: [UserDataExportsAPITidal.IncludeLinkage_userDataExportsGet]? = nil, pageCursor: String? = nil) async throws -> UserDataExportsMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			UserDataExportsAPI.userDataExportsGetWithRequestBuilder(filterOwnersId: filterOwnersId, include: include, includeLinkage: includeLinkage?.compactMap { $0.toUserDataExportsAPIEnum() }, pageCursor: pageCursor)
		}
	}


	/**
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_userDataExportsIdGet: String, CaseIterable {
		case owners = "owners"

		func toUserDataExportsAPIEnum() -> UserDataExportsAPI.IncludeLinkage_userDataExportsIdGet {
			switch self {
			case .owners: return .owners
			}
		}
	}

	/**
     Get single userDataExport.
     
     - returns: UserDataExportsSingleResourceDataDocument
     */
	public static func userDataExportsIdGet(id: String, include: [String]? = nil, includeLinkage: [UserDataExportsAPITidal.IncludeLinkage_userDataExportsIdGet]? = nil) async throws -> UserDataExportsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			UserDataExportsAPI.userDataExportsIdGetWithRequestBuilder(id: id, include: include, includeLinkage: includeLinkage?.compactMap { $0.toUserDataExportsAPIEnum() })
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: UserDataExportsOwnersMultiRelationshipDataDocument
     */
	public static func userDataExportsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> UserDataExportsOwnersMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserDataExportsAPI.userDataExportsIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Create single userDataExport.
     
     - returns: UserDataExportsCreateSingleResourceDataDocument
     */
	public static func userDataExportsPost(idempotencyKey: String? = nil, userDataExportsCreateOperationPayload: UserDataExportsCreateOperationPayload? = nil) async throws -> UserDataExportsCreateSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			UserDataExportsAPI.userDataExportsPostWithRequestBuilder(idempotencyKey: idempotencyKey, userDataExportsCreateOperationPayload: userDataExportsCreateOperationPayload)
		}
	}
}
