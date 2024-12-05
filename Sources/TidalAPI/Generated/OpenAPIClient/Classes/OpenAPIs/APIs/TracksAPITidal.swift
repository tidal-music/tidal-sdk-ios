import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - TracksAPITidal

/// This is a wrapper around `TracksAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await TracksAPITidal.getResource()
/// ```
public enum TracksAPITidal {
	/// Relationship: albums
	///
	/// - returns: TracksMultiDataRelationshipDocument
	public static func getTrackAlbumsRelationship(
		id: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) async throws -> TracksMultiDataRelationshipDocument {
		try await RequestHelper.createRequest {
			TracksAPI.getTrackAlbumsRelationshipWithRequestBuilder(
				id: id,
				countryCode: countryCode,
				include: include,
				pageCursor: pageCursor
			)
		}
	}

	/// Relationship: artists
	///
	/// - returns: TracksMultiDataRelationshipDocument
	public static func getTrackArtistsRelationship(
		id: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) async throws -> TracksMultiDataRelationshipDocument {
		try await RequestHelper.createRequest {
			TracksAPI.getTrackArtistsRelationshipWithRequestBuilder(
				id: id,
				countryCode: countryCode,
				include: include,
				pageCursor: pageCursor
			)
		}
	}

	/// Get single track
	///
	/// - returns: TracksSingleDataDocument
	public static func getTrackById(
		id: String,
		countryCode: String,
		include: [String]? = nil
	) async throws -> TracksSingleDataDocument {
		try await RequestHelper.createRequest {
			TracksAPI.getTrackByIdWithRequestBuilder(id: id, countryCode: countryCode, include: include)
		}
	}

	/// Relationship: providers
	///
	/// - returns: TracksMultiDataRelationshipDocument
	public static func getTrackProvidersRelationship(
		id: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) async throws -> TracksMultiDataRelationshipDocument {
		try await RequestHelper.createRequest {
			TracksAPI.getTrackProvidersRelationshipWithRequestBuilder(
				id: id,
				countryCode: countryCode,
				include: include,
				pageCursor: pageCursor
			)
		}
	}

	/// Relationship: radio
	///
	/// - returns: TracksMultiDataRelationshipDocument
	public static func getTrackRadioRelationship(
		id: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) async throws -> TracksMultiDataRelationshipDocument {
		try await RequestHelper.createRequest {
			TracksAPI.getTrackRadioRelationshipWithRequestBuilder(
				id: id,
				countryCode: countryCode,
				include: include,
				pageCursor: pageCursor
			)
		}
	}

	/// Relationship: similar tracks
	///
	/// - returns: TracksMultiDataRelationshipDocument
	public static func getTrackSimilarTracksRelationship(
		id: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) async throws -> TracksMultiDataRelationshipDocument {
		try await RequestHelper.createRequest {
			TracksAPI.getTrackSimilarTracksRelationshipWithRequestBuilder(
				id: id,
				countryCode: countryCode,
				include: include,
				pageCursor: pageCursor
			)
		}
	}

	/// Get multiple tracks
	///
	/// - returns: TracksMultiDataDocument
	public static func getTracksByFilters(
		countryCode: String,
		include: [String]? = nil,
		filterId: [String]? = nil,
		filterIsrc: [String]? = nil
	) async throws -> TracksMultiDataDocument {
		try await RequestHelper.createRequest {
			TracksAPI.getTracksByFiltersWithRequestBuilder(
				countryCode: countryCode,
				include: include,
				filterId: filterId,
				filterIsrc: filterIsrc
			)
		}
	}
}
