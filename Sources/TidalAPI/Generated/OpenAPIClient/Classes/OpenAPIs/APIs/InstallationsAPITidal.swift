import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `InstallationsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await InstallationsAPITidal.getResource()
/// ```
public enum InstallationsAPITidal {


	/**
     Get multiple installations.
     
     - returns: InstallationsMultiResourceDataDocument
     */
	public static func installationsGet(pageCursor: String? = nil, include: [String]? = nil, filterClientProvidedInstallationId: [String]? = nil, filterId: [String]? = nil, filterOwnersId: [String]? = nil) async throws -> InstallationsMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			InstallationsAPI.installationsGetWithRequestBuilder(pageCursor: pageCursor, include: include, filterClientProvidedInstallationId: filterClientProvidedInstallationId, filterId: filterId, filterOwnersId: filterOwnersId)
		}
	}


	/**
     Get single installation.
     
     - returns: InstallationsSingleResourceDataDocument
     */
	public static func installationsIdGet(id: String, include: [String]? = nil) async throws -> InstallationsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			InstallationsAPI.installationsIdGetWithRequestBuilder(id: id, include: include)
		}
	}


	/**
     Delete from offlineInventory relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func installationsIdRelationshipsOfflineInventoryDelete(id: String, installationsOfflineInventoryRelationshipRemoveOperationPayload: InstallationsOfflineInventoryRelationshipRemoveOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			InstallationsAPI.installationsIdRelationshipsOfflineInventoryDeleteWithRequestBuilder(id: id, installationsOfflineInventoryRelationshipRemoveOperationPayload: installationsOfflineInventoryRelationshipRemoveOperationPayload)
		}
	}


	/**
	 * enum for parameter filterType
	 */
	public enum FilterType_installationsIdRelationshipsOfflineInventoryGet: String, CaseIterable {
		case tracks = "tracks"
		case videos = "videos"
		case albums = "albums"
		case playlists = "playlists"

		func toInstallationsAPIEnum() -> InstallationsAPI.FilterType_installationsIdRelationshipsOfflineInventoryGet {
			switch self {
			case .tracks: return .tracks
			case .videos: return .videos
			case .albums: return .albums
			case .playlists: return .playlists
			}
		}
	}

	/**
     Get offlineInventory relationship (\&quot;to-many\&quot;).
     
     - returns: InstallationsOfflineInventoryMultiRelationshipDataDocument
     */
	public static func installationsIdRelationshipsOfflineInventoryGet(id: String, pageCursor: String? = nil, include: [String]? = nil, filterType: [InstallationsAPITidal.FilterType_installationsIdRelationshipsOfflineInventoryGet]? = nil) async throws -> InstallationsOfflineInventoryMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			InstallationsAPI.installationsIdRelationshipsOfflineInventoryGetWithRequestBuilder(id: id, pageCursor: pageCursor, include: include, filterType: filterType?.compactMap { $0.toInstallationsAPIEnum() })
		}
	}


	/**
     Add to offlineInventory relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func installationsIdRelationshipsOfflineInventoryPost(id: String, installationsOfflineInventoryRelationshipAddOperationPayload: InstallationsOfflineInventoryRelationshipAddOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			InstallationsAPI.installationsIdRelationshipsOfflineInventoryPostWithRequestBuilder(id: id, installationsOfflineInventoryRelationshipAddOperationPayload: installationsOfflineInventoryRelationshipAddOperationPayload)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: InstallationsMultiRelationshipDataDocument
     */
	public static func installationsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> InstallationsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			InstallationsAPI.installationsIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Create single installation.
     
     - returns: InstallationsSingleResourceDataDocument
     */
	public static func installationsPost(installationsCreateOperationPayload: InstallationsCreateOperationPayload? = nil) async throws -> InstallationsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			InstallationsAPI.installationsPostWithRequestBuilder(installationsCreateOperationPayload: installationsCreateOperationPayload)
		}
	}
}
