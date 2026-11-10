import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `ArtworkLibrariesAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await ArtworkLibrariesAPITidal.getResource()
/// ```
public enum ArtworkLibrariesAPITidal {


	/**
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_artworkLibrariesGet: String, CaseIterable {
		case artworks = "artworks"
		case randomartwork = "randomArtwork"

		func toArtworkLibrariesAPIEnum() -> ArtworkLibrariesAPI.IncludeLinkage_artworkLibrariesGet {
			switch self {
			case .artworks: return .artworks
			case .randomartwork: return .randomartwork
			}
		}
	}

	/**
     Get multiple artworkLibraries.
     
     - returns: ArtworkLibrariesMultiResourceDataDocument
     */
	public static func artworkLibrariesGet(filterName: [String], include: [String]? = nil, includeLinkage: [ArtworkLibrariesAPITidal.IncludeLinkage_artworkLibrariesGet]? = nil) async throws -> ArtworkLibrariesMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			ArtworkLibrariesAPI.artworkLibrariesGetWithRequestBuilder(filterName: filterName, include: include, includeLinkage: includeLinkage?.compactMap { $0.toArtworkLibrariesAPIEnum() })
		}
	}


	/**
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_artworkLibrariesIdGet: String, CaseIterable {
		case artworks = "artworks"
		case randomartwork = "randomArtwork"

		func toArtworkLibrariesAPIEnum() -> ArtworkLibrariesAPI.IncludeLinkage_artworkLibrariesIdGet {
			switch self {
			case .artworks: return .artworks
			case .randomartwork: return .randomartwork
			}
		}
	}

	/**
     Get single artworkLibrarie.
     
     - returns: ArtworkLibrariesSingleResourceDataDocument
     */
	public static func artworkLibrariesIdGet(id: String, include: [String]? = nil, includeLinkage: [ArtworkLibrariesAPITidal.IncludeLinkage_artworkLibrariesIdGet]? = nil) async throws -> ArtworkLibrariesSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			ArtworkLibrariesAPI.artworkLibrariesIdGetWithRequestBuilder(id: id, include: include, includeLinkage: includeLinkage?.compactMap { $0.toArtworkLibrariesAPIEnum() })
		}
	}


	/**
     Get artworks relationship (\&quot;to-many\&quot;).
     
     - returns: ArtworkLibrariesArtworksMultiRelationshipDataDocument
     */
	public static func artworkLibrariesIdRelationshipsArtworksGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> ArtworkLibrariesArtworksMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ArtworkLibrariesAPI.artworkLibrariesIdRelationshipsArtworksGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get randomArtwork relationship (\&quot;to-one\&quot;).
     
     - returns: ArtworkLibrariesRandomArtworkSingleRelationshipDataDocument
     */
	public static func artworkLibrariesIdRelationshipsRandomArtworkGet(id: String, include: [String]? = nil) async throws -> ArtworkLibrariesRandomArtworkSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ArtworkLibrariesAPI.artworkLibrariesIdRelationshipsRandomArtworkGetWithRequestBuilder(id: id, include: include)
		}
	}
}
