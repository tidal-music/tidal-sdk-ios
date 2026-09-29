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
	public static func installationsGet(pageCursor: String? = nil, include: [String]? = nil, filterClientProvidedInstallationId: [String]? = nil, filterOwnersId: [String]? = nil, replaceMedia: String? = nil) async throws -> InstallationsMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			InstallationsAPI.installationsGetWithRequestBuilder(pageCursor: pageCursor, include: include, filterClientProvidedInstallationId: filterClientProvidedInstallationId, filterOwnersId: filterOwnersId, replaceMedia: replaceMedia)
		}
	}


	/**
     Get single installation.
     
     - returns: InstallationsSingleResourceDataDocument
     */
	public static func installationsIdGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> InstallationsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			InstallationsAPI.installationsIdGetWithRequestBuilder(id: id, include: include, replaceMedia: replaceMedia)
		}
	}


	/**
     Delete from offlineInventory relationship (\&quot;to-many\&quot;).
     
     - returns: MutationResponseDocument
     */
	public static func installationsIdRelationshipsOfflineInventoryDelete(id: String, idempotencyKey: String? = nil, installationsOfflineInventoryRelationshipRemoveOperationPayload: InstallationsOfflineInventoryRelationshipRemoveOperationPayload? = nil) async throws -> MutationResponseDocument {
		return try await RequestHelper.createRequest {
			InstallationsAPI.installationsIdRelationshipsOfflineInventoryDeleteWithRequestBuilder(id: id, idempotencyKey: idempotencyKey, installationsOfflineInventoryRelationshipRemoveOperationPayload: installationsOfflineInventoryRelationshipRemoveOperationPayload)
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
		case usercollectiontracks = "userCollectionTracks"

		func toInstallationsAPIEnum() -> InstallationsAPI.FilterType_installationsIdRelationshipsOfflineInventoryGet {
			switch self {
			case .tracks: return .tracks
			case .videos: return .videos
			case .albums: return .albums
			case .playlists: return .playlists
			case .usercollectiontracks: return .usercollectiontracks
			}
		}
	}

	/**
	 * enum for parameter filterState
	 */
	public enum FilterState_installationsIdRelationshipsOfflineInventoryGet: String, CaseIterable {
		case pending = "PENDING"
		case stored = "STORED"
		case failed = "FAILED"

		func toInstallationsAPIEnum() -> InstallationsAPI.FilterState_installationsIdRelationshipsOfflineInventoryGet {
			switch self {
			case .pending: return .pending
			case .stored: return .stored
			case .failed: return .failed
			}
		}
	}

	/**
     Get offlineInventory relationship (\&quot;to-many\&quot;).
     
     - returns: InstallationsOfflineInventoryMultiRelationshipDataDocument
     */
	public static func installationsIdRelationshipsOfflineInventoryGet(id: String, filterType: [InstallationsAPITidal.FilterType_installationsIdRelationshipsOfflineInventoryGet], pageCursor: String? = nil, include: [String]? = nil, filterId: [String]? = nil, filterState: [InstallationsAPITidal.FilterState_installationsIdRelationshipsOfflineInventoryGet]? = nil, replaceMedia: String? = nil) async throws -> InstallationsOfflineInventoryMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			InstallationsAPI.installationsIdRelationshipsOfflineInventoryGetWithRequestBuilder(id: id, filterType: filterType.compactMap { $0.toInstallationsAPIEnum() }, pageCursor: pageCursor, include: include, filterId: filterId, filterState: filterState?.compactMap { $0.toInstallationsAPIEnum() }, replaceMedia: replaceMedia)
		}
	}


	/**
     Add to offlineInventory relationship (\&quot;to-many\&quot;).
     
     - returns: MutationResponseDocument
     */
	public static func installationsIdRelationshipsOfflineInventoryPost(id: String, idempotencyKey: String? = nil, installationsOfflineInventoryRelationshipAddOperationPayload: InstallationsOfflineInventoryRelationshipAddOperationPayload? = nil) async throws -> MutationResponseDocument {
		return try await RequestHelper.createRequest {
			InstallationsAPI.installationsIdRelationshipsOfflineInventoryPostWithRequestBuilder(id: id, idempotencyKey: idempotencyKey, installationsOfflineInventoryRelationshipAddOperationPayload: installationsOfflineInventoryRelationshipAddOperationPayload)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: InstallationsOwnersMultiRelationshipDataDocument
     */
	public static func installationsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> InstallationsOwnersMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			InstallationsAPI.installationsIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Create single installation.
     
     - returns: InstallationsCreateSingleResourceDataDocument
     */
	public static func installationsPost(idempotencyKey: String? = nil, installationsCreateOperationPayload: InstallationsCreateOperationPayload? = nil) async throws -> InstallationsCreateSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			InstallationsAPI.installationsPostWithRequestBuilder(idempotencyKey: idempotencyKey, installationsCreateOperationPayload: installationsCreateOperationPayload)
		}
	}
}
