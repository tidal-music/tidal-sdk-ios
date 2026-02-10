import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `UserCollectionTracksAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await UserCollectionTracksAPITidal.getResource()
/// ```
public enum UserCollectionTracksAPITidal {


	/**
     Get single userCollectionTrack.
     
     - returns: UserCollectionTracksSingleResourceDataDocument
     */
	public static func userCollectionTracksIdGet(id: String, countryCode: String? = nil, locale: String? = nil, include: [String]? = nil) async throws -> UserCollectionTracksSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			UserCollectionTracksAPI.userCollectionTracksIdGetWithRequestBuilder(id: id, countryCode: countryCode, locale: locale, include: include)
		}
	}


	/**
     Delete from items relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func userCollectionTracksIdRelationshipsItemsDelete(id: String, userCollectionTracksItemsRelationshipRemoveOperationPayload: UserCollectionTracksItemsRelationshipRemoveOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			UserCollectionTracksAPI.userCollectionTracksIdRelationshipsItemsDeleteWithRequestBuilder(id: id, userCollectionTracksItemsRelationshipRemoveOperationPayload: userCollectionTracksItemsRelationshipRemoveOperationPayload)
		}
	}


	/**
	 * enum for parameter sort
	 */
	public enum Sort_userCollectionTracksIdRelationshipsItemsGet: String, CaseIterable {
		case AddedAtAsc = "addedAt"
		case AddedAtDesc = "-addedAt"
		case AlbumsTitleAsc = "albums.title"
		case AlbumsTitleDesc = "-albums.title"
		case ArtistsNameAsc = "artists.name"
		case ArtistsNameDesc = "-artists.name"
		case DurationAsc = "duration"
		case DurationDesc = "-duration"
		case TitleAsc = "title"
		case TitleDesc = "-title"

		func toUserCollectionTracksAPIEnum() -> UserCollectionTracksAPI.Sort_userCollectionTracksIdRelationshipsItemsGet {
			switch self {
			case .AddedAtAsc: return .AddedAtAsc
			case .AddedAtDesc: return .AddedAtDesc
			case .AlbumsTitleAsc: return .AlbumsTitleAsc
			case .AlbumsTitleDesc: return .AlbumsTitleDesc
			case .ArtistsNameAsc: return .ArtistsNameAsc
			case .ArtistsNameDesc: return .ArtistsNameDesc
			case .DurationAsc: return .DurationAsc
			case .DurationDesc: return .DurationDesc
			case .TitleAsc: return .TitleAsc
			case .TitleDesc: return .TitleDesc
			}
		}
	}

	/**
     Get items relationship (\&quot;to-many\&quot;).
     
     - returns: UserCollectionTracksItemsMultiRelationshipDataDocument
     */
	public static func userCollectionTracksIdRelationshipsItemsGet(id: String, pageCursor: String? = nil, sort: [UserCollectionTracksAPITidal.Sort_userCollectionTracksIdRelationshipsItemsGet]? = nil, countryCode: String? = nil, locale: String? = nil, include: [String]? = nil) async throws -> UserCollectionTracksItemsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserCollectionTracksAPI.userCollectionTracksIdRelationshipsItemsGetWithRequestBuilder(id: id, pageCursor: pageCursor, sort: sort?.compactMap { $0.toUserCollectionTracksAPIEnum() }, countryCode: countryCode, locale: locale, include: include)
		}
	}


	/**
     Add to items relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func userCollectionTracksIdRelationshipsItemsPost(id: String, countryCode: String? = nil, userCollectionTracksItemsRelationshipAddOperationPayload: UserCollectionTracksItemsRelationshipAddOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			UserCollectionTracksAPI.userCollectionTracksIdRelationshipsItemsPostWithRequestBuilder(id: id, countryCode: countryCode, userCollectionTracksItemsRelationshipAddOperationPayload: userCollectionTracksItemsRelationshipAddOperationPayload)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: UserCollectionTracksMultiRelationshipDataDocument
     */
	public static func userCollectionTracksIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> UserCollectionTracksMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserCollectionTracksAPI.userCollectionTracksIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}
}
