import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - ArtistsAPITidal

/// This is a wrapper around `ArtistsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await ArtistsAPITidal.getResource()
/// ```
public enum ArtistsAPITidal {
	/// Relationship: albums
	///
	/// - returns: ArtistsMultiDataRelationshipDocument
	public static func getArtistAlbumsRelationship(
		id: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) async throws -> ArtistsMultiDataRelationshipDocument {
		try await RequestHelper.createRequest {
			ArtistsAPI.getArtistAlbumsRelationshipWithRequestBuilder(
				id: id,
				countryCode: countryCode,
				include: include,
				pageCursor: pageCursor
			)
		}
	}

	/// Get single artist
	///
	/// - returns: ArtistsSingleDataDocument
	public static func getArtistById(
		id: String,
		countryCode: String,
		include: [String]? = nil
	) async throws -> ArtistsSingleDataDocument {
		try await RequestHelper.createRequest {
			ArtistsAPI.getArtistByIdWithRequestBuilder(id: id, countryCode: countryCode, include: include)
		}
	}

	/// Relationship: radio
	///
	/// - returns: ArtistsMultiDataRelationshipDocument
	public static func getArtistRadioRelationship(
		id: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) async throws -> ArtistsMultiDataRelationshipDocument {
		try await RequestHelper.createRequest {
			ArtistsAPI.getArtistRadioRelationshipWithRequestBuilder(
				id: id,
				countryCode: countryCode,
				include: include,
				pageCursor: pageCursor
			)
		}
	}

	/// Relationship: similar artists
	///
	/// - returns: ArtistsMultiDataRelationshipDocument
	public static func getArtistSimilarArtistsRelationship(
		id: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) async throws -> ArtistsMultiDataRelationshipDocument {
		try await RequestHelper.createRequest {
			ArtistsAPI.getArtistSimilarArtistsRelationshipWithRequestBuilder(
				id: id,
				countryCode: countryCode,
				include: include,
				pageCursor: pageCursor
			)
		}
	}

	/// Relationship: track providers
	///
	/// - returns: ArtistsTrackProvidersMultiDataRelationshipDocument
	public static func getArtistTrackProvidersRelationship(
		id: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) async throws -> ArtistsTrackProvidersMultiDataRelationshipDocument {
		try await RequestHelper.createRequest {
			ArtistsAPI.getArtistTrackProvidersRelationshipWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}

	/// enum for parameter collapseBy
	public enum CollapseBy_getArtistTracksRelationship: String, CaseIterable {
		case fingerprint = "FINGERPRINT"
		case _none = "NONE"

		func toArtistsAPIEnum() -> ArtistsAPI.CollapseBy_getArtistTracksRelationship {
			switch self {
			case .fingerprint: .fingerprint
			case ._none: ._none
			}
		}
	}

	/// Relationship: tracks
	///
	/// - returns: ArtistsMultiDataRelationshipDocument
	public static func getArtistTracksRelationship(
		id: String,
		countryCode: String,
		collapseBy: ArtistsAPITidal.CollapseBy_getArtistTracksRelationship? = nil,
		include: [String]? = nil,
		pageCursor: String? = nil
	) async throws -> ArtistsMultiDataRelationshipDocument {
		try await RequestHelper.createRequest {
			ArtistsAPI.getArtistTracksRelationshipWithRequestBuilder(
				id: id,
				countryCode: countryCode,
				collapseBy: collapseBy?.toArtistsAPIEnum(),
				include: include,
				pageCursor: pageCursor
			)
		}
	}

	/// Relationship: videos
	///
	/// - returns: ArtistsMultiDataRelationshipDocument
	public static func getArtistVideosRelationship(
		id: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) async throws -> ArtistsMultiDataRelationshipDocument {
		try await RequestHelper.createRequest {
			ArtistsAPI.getArtistVideosRelationshipWithRequestBuilder(
				id: id,
				countryCode: countryCode,
				include: include,
				pageCursor: pageCursor
			)
		}
	}

	/// Get multiple artists
	///
	/// - returns: ArtistsMultiDataDocument
	public static func getArtistsByFilters(
		countryCode: String,
		include: [String]? = nil,
		filterId: [String]? = nil
	) async throws -> ArtistsMultiDataDocument {
		try await RequestHelper.createRequest {
			ArtistsAPI.getArtistsByFiltersWithRequestBuilder(countryCode: countryCode, include: include, filterId: filterId)
		}
	}
}
