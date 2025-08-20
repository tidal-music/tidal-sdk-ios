import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `GenresAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await GenresAPITidal.getResource()
/// ```
public enum GenresAPITidal {


	/**
     Get multiple genres.
     
     - returns: GenresMultiResourceDataDocument
     */
	public static func genresGet(pageCursor: String? = nil, filterId: [String]? = nil) async throws -> GenresMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			GenresAPI.genresGetWithRequestBuilder(pageCursor: pageCursor, filterId: filterId)
		}
	}


	/**
     Get single genre.
     
     - returns: GenresSingleResourceDataDocument
     */
	public static func genresIdGet(id: String) async throws -> GenresSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			GenresAPI.genresIdGetWithRequestBuilder(id: id)
		}
	}
}
