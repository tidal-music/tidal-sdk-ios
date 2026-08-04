import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `SearchResultsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await SearchResultsAPITidal.getResource()
/// ```
public enum SearchResultsAPITidal {


	/**
	 * enum for parameter explicitFilter
	 */
	public enum ExplicitFilter_searchResultsIdGet: String, CaseIterable {
		case include = "INCLUDE"
		case exclude = "EXCLUDE"

		func toSearchResultsAPIEnum() -> SearchResultsAPI.ExplicitFilter_searchResultsIdGet {
			switch self {
			case .include: return .include
			case .exclude: return .exclude
			}
		}
	}

	/**
	 * enum for parameter deviceType
	 */
	public enum DeviceType_searchResultsIdGet: String, CaseIterable {
		case browser = "BROWSER"
		case car = "CAR"
		case desktop = "DESKTOP"
		case phone = "PHONE"
		case tablet = "TABLET"
		case tv = "TV"

		func toSearchResultsAPIEnum() -> SearchResultsAPI.DeviceType_searchResultsIdGet {
			switch self {
			case .browser: return .browser
			case .car: return .car
			case .desktop: return .desktop
			case .phone: return .phone
			case .tablet: return .tablet
			case .tv: return .tv
			}
		}
	}

	/**
	 * enum for parameter systemType
	 */
	public enum SystemType_searchResultsIdGet: String, CaseIterable {
		case android = "ANDROID"
		case desktop = "DESKTOP"
		case tesla = "TESLA"
		case ios = "IOS"
		case web = "WEB"

		func toSearchResultsAPIEnum() -> SearchResultsAPI.SystemType_searchResultsIdGet {
			switch self {
			case .android: return .android
			case .desktop: return .desktop
			case .tesla: return .tesla
			case .ios: return .ios
			case .web: return .web
			}
		}
	}

	/**
     Get single searchResult.
     
     - returns: SearchResultsSingleResourceDataDocument
     */
	public static func searchResultsIdGet(id: String, explicitFilter: SearchResultsAPITidal.ExplicitFilter_searchResultsIdGet? = nil, countryCode: String? = nil, deviceType: SearchResultsAPITidal.DeviceType_searchResultsIdGet? = nil, systemType: SearchResultsAPITidal.SystemType_searchResultsIdGet? = nil, clientVersion: String? = nil, include: [String]? = nil, replaceMedia: String? = nil) async throws -> SearchResultsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			SearchResultsAPI.searchResultsIdGetWithRequestBuilder(id: id, explicitFilter: explicitFilter?.toSearchResultsAPIEnum(), countryCode: countryCode, deviceType: deviceType?.toSearchResultsAPIEnum(), systemType: systemType?.toSearchResultsAPIEnum(), clientVersion: clientVersion, include: include, replaceMedia: replaceMedia)
		}
	}


	/**
	 * enum for parameter explicitFilter
	 */
	public enum ExplicitFilter_searchResultsIdRelationshipsAlbumsGet: String, CaseIterable {
		case include = "INCLUDE"
		case exclude = "EXCLUDE"

		func toSearchResultsAPIEnum() -> SearchResultsAPI.ExplicitFilter_searchResultsIdRelationshipsAlbumsGet {
			switch self {
			case .include: return .include
			case .exclude: return .exclude
			}
		}
	}

	/**
	 * enum for parameter deviceType
	 */
	public enum DeviceType_searchResultsIdRelationshipsAlbumsGet: String, CaseIterable {
		case browser = "BROWSER"
		case car = "CAR"
		case desktop = "DESKTOP"
		case phone = "PHONE"
		case tablet = "TABLET"
		case tv = "TV"

		func toSearchResultsAPIEnum() -> SearchResultsAPI.DeviceType_searchResultsIdRelationshipsAlbumsGet {
			switch self {
			case .browser: return .browser
			case .car: return .car
			case .desktop: return .desktop
			case .phone: return .phone
			case .tablet: return .tablet
			case .tv: return .tv
			}
		}
	}

	/**
	 * enum for parameter systemType
	 */
	public enum SystemType_searchResultsIdRelationshipsAlbumsGet: String, CaseIterable {
		case android = "ANDROID"
		case desktop = "DESKTOP"
		case tesla = "TESLA"
		case ios = "IOS"
		case web = "WEB"

		func toSearchResultsAPIEnum() -> SearchResultsAPI.SystemType_searchResultsIdRelationshipsAlbumsGet {
			switch self {
			case .android: return .android
			case .desktop: return .desktop
			case .tesla: return .tesla
			case .ios: return .ios
			case .web: return .web
			}
		}
	}

	/**
     Get albums relationship (\&quot;to-many\&quot;).
     
     - returns: SearchResultsMultiRelationshipDataDocument
     */
	public static func searchResultsIdRelationshipsAlbumsGet(id: String, explicitFilter: SearchResultsAPITidal.ExplicitFilter_searchResultsIdRelationshipsAlbumsGet? = nil, pageCursor: String? = nil, countryCode: String? = nil, deviceType: SearchResultsAPITidal.DeviceType_searchResultsIdRelationshipsAlbumsGet? = nil, systemType: SearchResultsAPITidal.SystemType_searchResultsIdRelationshipsAlbumsGet? = nil, clientVersion: String? = nil, include: [String]? = nil, replaceMedia: String? = nil) async throws -> SearchResultsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			SearchResultsAPI.searchResultsIdRelationshipsAlbumsGetWithRequestBuilder(id: id, explicitFilter: explicitFilter?.toSearchResultsAPIEnum(), pageCursor: pageCursor, countryCode: countryCode, deviceType: deviceType?.toSearchResultsAPIEnum(), systemType: systemType?.toSearchResultsAPIEnum(), clientVersion: clientVersion, include: include, replaceMedia: replaceMedia)
		}
	}


	/**
	 * enum for parameter explicitFilter
	 */
	public enum ExplicitFilter_searchResultsIdRelationshipsArtistsGet: String, CaseIterable {
		case include = "INCLUDE"
		case exclude = "EXCLUDE"

		func toSearchResultsAPIEnum() -> SearchResultsAPI.ExplicitFilter_searchResultsIdRelationshipsArtistsGet {
			switch self {
			case .include: return .include
			case .exclude: return .exclude
			}
		}
	}

	/**
	 * enum for parameter deviceType
	 */
	public enum DeviceType_searchResultsIdRelationshipsArtistsGet: String, CaseIterable {
		case browser = "BROWSER"
		case car = "CAR"
		case desktop = "DESKTOP"
		case phone = "PHONE"
		case tablet = "TABLET"
		case tv = "TV"

		func toSearchResultsAPIEnum() -> SearchResultsAPI.DeviceType_searchResultsIdRelationshipsArtistsGet {
			switch self {
			case .browser: return .browser
			case .car: return .car
			case .desktop: return .desktop
			case .phone: return .phone
			case .tablet: return .tablet
			case .tv: return .tv
			}
		}
	}

	/**
	 * enum for parameter systemType
	 */
	public enum SystemType_searchResultsIdRelationshipsArtistsGet: String, CaseIterable {
		case android = "ANDROID"
		case desktop = "DESKTOP"
		case tesla = "TESLA"
		case ios = "IOS"
		case web = "WEB"

		func toSearchResultsAPIEnum() -> SearchResultsAPI.SystemType_searchResultsIdRelationshipsArtistsGet {
			switch self {
			case .android: return .android
			case .desktop: return .desktop
			case .tesla: return .tesla
			case .ios: return .ios
			case .web: return .web
			}
		}
	}

	/**
     Get artists relationship (\&quot;to-many\&quot;).
     
     - returns: SearchResultsMultiRelationshipDataDocument
     */
	public static func searchResultsIdRelationshipsArtistsGet(id: String, explicitFilter: SearchResultsAPITidal.ExplicitFilter_searchResultsIdRelationshipsArtistsGet? = nil, pageCursor: String? = nil, countryCode: String? = nil, deviceType: SearchResultsAPITidal.DeviceType_searchResultsIdRelationshipsArtistsGet? = nil, systemType: SearchResultsAPITidal.SystemType_searchResultsIdRelationshipsArtistsGet? = nil, clientVersion: String? = nil, include: [String]? = nil, replaceMedia: String? = nil) async throws -> SearchResultsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			SearchResultsAPI.searchResultsIdRelationshipsArtistsGetWithRequestBuilder(id: id, explicitFilter: explicitFilter?.toSearchResultsAPIEnum(), pageCursor: pageCursor, countryCode: countryCode, deviceType: deviceType?.toSearchResultsAPIEnum(), systemType: systemType?.toSearchResultsAPIEnum(), clientVersion: clientVersion, include: include, replaceMedia: replaceMedia)
		}
	}


	/**
	 * enum for parameter explicitFilter
	 */
	public enum ExplicitFilter_searchResultsIdRelationshipsPlaylistsGet: String, CaseIterable {
		case include = "INCLUDE"
		case exclude = "EXCLUDE"

		func toSearchResultsAPIEnum() -> SearchResultsAPI.ExplicitFilter_searchResultsIdRelationshipsPlaylistsGet {
			switch self {
			case .include: return .include
			case .exclude: return .exclude
			}
		}
	}

	/**
	 * enum for parameter deviceType
	 */
	public enum DeviceType_searchResultsIdRelationshipsPlaylistsGet: String, CaseIterable {
		case browser = "BROWSER"
		case car = "CAR"
		case desktop = "DESKTOP"
		case phone = "PHONE"
		case tablet = "TABLET"
		case tv = "TV"

		func toSearchResultsAPIEnum() -> SearchResultsAPI.DeviceType_searchResultsIdRelationshipsPlaylistsGet {
			switch self {
			case .browser: return .browser
			case .car: return .car
			case .desktop: return .desktop
			case .phone: return .phone
			case .tablet: return .tablet
			case .tv: return .tv
			}
		}
	}

	/**
	 * enum for parameter systemType
	 */
	public enum SystemType_searchResultsIdRelationshipsPlaylistsGet: String, CaseIterable {
		case android = "ANDROID"
		case desktop = "DESKTOP"
		case tesla = "TESLA"
		case ios = "IOS"
		case web = "WEB"

		func toSearchResultsAPIEnum() -> SearchResultsAPI.SystemType_searchResultsIdRelationshipsPlaylistsGet {
			switch self {
			case .android: return .android
			case .desktop: return .desktop
			case .tesla: return .tesla
			case .ios: return .ios
			case .web: return .web
			}
		}
	}

	/**
     Get playlists relationship (\&quot;to-many\&quot;).
     
     - returns: SearchResultsMultiRelationshipDataDocument
     */
	public static func searchResultsIdRelationshipsPlaylistsGet(id: String, explicitFilter: SearchResultsAPITidal.ExplicitFilter_searchResultsIdRelationshipsPlaylistsGet? = nil, pageCursor: String? = nil, countryCode: String? = nil, deviceType: SearchResultsAPITidal.DeviceType_searchResultsIdRelationshipsPlaylistsGet? = nil, systemType: SearchResultsAPITidal.SystemType_searchResultsIdRelationshipsPlaylistsGet? = nil, clientVersion: String? = nil, include: [String]? = nil, replaceMedia: String? = nil) async throws -> SearchResultsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			SearchResultsAPI.searchResultsIdRelationshipsPlaylistsGetWithRequestBuilder(id: id, explicitFilter: explicitFilter?.toSearchResultsAPIEnum(), pageCursor: pageCursor, countryCode: countryCode, deviceType: deviceType?.toSearchResultsAPIEnum(), systemType: systemType?.toSearchResultsAPIEnum(), clientVersion: clientVersion, include: include, replaceMedia: replaceMedia)
		}
	}


	/**
	 * enum for parameter explicitFilter
	 */
	public enum ExplicitFilter_searchResultsIdRelationshipsTopHitsGet: String, CaseIterable {
		case include = "INCLUDE"
		case exclude = "EXCLUDE"

		func toSearchResultsAPIEnum() -> SearchResultsAPI.ExplicitFilter_searchResultsIdRelationshipsTopHitsGet {
			switch self {
			case .include: return .include
			case .exclude: return .exclude
			}
		}
	}

	/**
	 * enum for parameter deviceType
	 */
	public enum DeviceType_searchResultsIdRelationshipsTopHitsGet: String, CaseIterable {
		case browser = "BROWSER"
		case car = "CAR"
		case desktop = "DESKTOP"
		case phone = "PHONE"
		case tablet = "TABLET"
		case tv = "TV"

		func toSearchResultsAPIEnum() -> SearchResultsAPI.DeviceType_searchResultsIdRelationshipsTopHitsGet {
			switch self {
			case .browser: return .browser
			case .car: return .car
			case .desktop: return .desktop
			case .phone: return .phone
			case .tablet: return .tablet
			case .tv: return .tv
			}
		}
	}

	/**
	 * enum for parameter systemType
	 */
	public enum SystemType_searchResultsIdRelationshipsTopHitsGet: String, CaseIterable {
		case android = "ANDROID"
		case desktop = "DESKTOP"
		case tesla = "TESLA"
		case ios = "IOS"
		case web = "WEB"

		func toSearchResultsAPIEnum() -> SearchResultsAPI.SystemType_searchResultsIdRelationshipsTopHitsGet {
			switch self {
			case .android: return .android
			case .desktop: return .desktop
			case .tesla: return .tesla
			case .ios: return .ios
			case .web: return .web
			}
		}
	}

	/**
     Get topHits relationship (\&quot;to-many\&quot;).
     
     - returns: SearchResultsMultiRelationshipDataDocument
     */
	public static func searchResultsIdRelationshipsTopHitsGet(id: String, explicitFilter: SearchResultsAPITidal.ExplicitFilter_searchResultsIdRelationshipsTopHitsGet? = nil, pageCursor: String? = nil, countryCode: String? = nil, deviceType: SearchResultsAPITidal.DeviceType_searchResultsIdRelationshipsTopHitsGet? = nil, systemType: SearchResultsAPITidal.SystemType_searchResultsIdRelationshipsTopHitsGet? = nil, clientVersion: String? = nil, include: [String]? = nil, replaceMedia: String? = nil) async throws -> SearchResultsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			SearchResultsAPI.searchResultsIdRelationshipsTopHitsGetWithRequestBuilder(id: id, explicitFilter: explicitFilter?.toSearchResultsAPIEnum(), pageCursor: pageCursor, countryCode: countryCode, deviceType: deviceType?.toSearchResultsAPIEnum(), systemType: systemType?.toSearchResultsAPIEnum(), clientVersion: clientVersion, include: include, replaceMedia: replaceMedia)
		}
	}


	/**
	 * enum for parameter explicitFilter
	 */
	public enum ExplicitFilter_searchResultsIdRelationshipsTracksGet: String, CaseIterable {
		case include = "INCLUDE"
		case exclude = "EXCLUDE"

		func toSearchResultsAPIEnum() -> SearchResultsAPI.ExplicitFilter_searchResultsIdRelationshipsTracksGet {
			switch self {
			case .include: return .include
			case .exclude: return .exclude
			}
		}
	}

	/**
	 * enum for parameter deviceType
	 */
	public enum DeviceType_searchResultsIdRelationshipsTracksGet: String, CaseIterable {
		case browser = "BROWSER"
		case car = "CAR"
		case desktop = "DESKTOP"
		case phone = "PHONE"
		case tablet = "TABLET"
		case tv = "TV"

		func toSearchResultsAPIEnum() -> SearchResultsAPI.DeviceType_searchResultsIdRelationshipsTracksGet {
			switch self {
			case .browser: return .browser
			case .car: return .car
			case .desktop: return .desktop
			case .phone: return .phone
			case .tablet: return .tablet
			case .tv: return .tv
			}
		}
	}

	/**
	 * enum for parameter systemType
	 */
	public enum SystemType_searchResultsIdRelationshipsTracksGet: String, CaseIterable {
		case android = "ANDROID"
		case desktop = "DESKTOP"
		case tesla = "TESLA"
		case ios = "IOS"
		case web = "WEB"

		func toSearchResultsAPIEnum() -> SearchResultsAPI.SystemType_searchResultsIdRelationshipsTracksGet {
			switch self {
			case .android: return .android
			case .desktop: return .desktop
			case .tesla: return .tesla
			case .ios: return .ios
			case .web: return .web
			}
		}
	}

	/**
     Get tracks relationship (\&quot;to-many\&quot;).
     
     - returns: SearchResultsMultiRelationshipDataDocument
     */
	public static func searchResultsIdRelationshipsTracksGet(id: String, explicitFilter: SearchResultsAPITidal.ExplicitFilter_searchResultsIdRelationshipsTracksGet? = nil, pageCursor: String? = nil, countryCode: String? = nil, deviceType: SearchResultsAPITidal.DeviceType_searchResultsIdRelationshipsTracksGet? = nil, systemType: SearchResultsAPITidal.SystemType_searchResultsIdRelationshipsTracksGet? = nil, clientVersion: String? = nil, include: [String]? = nil, replaceMedia: String? = nil) async throws -> SearchResultsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			SearchResultsAPI.searchResultsIdRelationshipsTracksGetWithRequestBuilder(id: id, explicitFilter: explicitFilter?.toSearchResultsAPIEnum(), pageCursor: pageCursor, countryCode: countryCode, deviceType: deviceType?.toSearchResultsAPIEnum(), systemType: systemType?.toSearchResultsAPIEnum(), clientVersion: clientVersion, include: include, replaceMedia: replaceMedia)
		}
	}


	/**
	 * enum for parameter explicitFilter
	 */
	public enum ExplicitFilter_searchResultsIdRelationshipsVideosGet: String, CaseIterable {
		case include = "INCLUDE"
		case exclude = "EXCLUDE"

		func toSearchResultsAPIEnum() -> SearchResultsAPI.ExplicitFilter_searchResultsIdRelationshipsVideosGet {
			switch self {
			case .include: return .include
			case .exclude: return .exclude
			}
		}
	}

	/**
	 * enum for parameter deviceType
	 */
	public enum DeviceType_searchResultsIdRelationshipsVideosGet: String, CaseIterable {
		case browser = "BROWSER"
		case car = "CAR"
		case desktop = "DESKTOP"
		case phone = "PHONE"
		case tablet = "TABLET"
		case tv = "TV"

		func toSearchResultsAPIEnum() -> SearchResultsAPI.DeviceType_searchResultsIdRelationshipsVideosGet {
			switch self {
			case .browser: return .browser
			case .car: return .car
			case .desktop: return .desktop
			case .phone: return .phone
			case .tablet: return .tablet
			case .tv: return .tv
			}
		}
	}

	/**
	 * enum for parameter systemType
	 */
	public enum SystemType_searchResultsIdRelationshipsVideosGet: String, CaseIterable {
		case android = "ANDROID"
		case desktop = "DESKTOP"
		case tesla = "TESLA"
		case ios = "IOS"
		case web = "WEB"

		func toSearchResultsAPIEnum() -> SearchResultsAPI.SystemType_searchResultsIdRelationshipsVideosGet {
			switch self {
			case .android: return .android
			case .desktop: return .desktop
			case .tesla: return .tesla
			case .ios: return .ios
			case .web: return .web
			}
		}
	}

	/**
     Get videos relationship (\&quot;to-many\&quot;).
     
     - returns: SearchResultsMultiRelationshipDataDocument
     */
	public static func searchResultsIdRelationshipsVideosGet(id: String, explicitFilter: SearchResultsAPITidal.ExplicitFilter_searchResultsIdRelationshipsVideosGet? = nil, pageCursor: String? = nil, countryCode: String? = nil, deviceType: SearchResultsAPITidal.DeviceType_searchResultsIdRelationshipsVideosGet? = nil, systemType: SearchResultsAPITidal.SystemType_searchResultsIdRelationshipsVideosGet? = nil, clientVersion: String? = nil, include: [String]? = nil, replaceMedia: String? = nil) async throws -> SearchResultsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			SearchResultsAPI.searchResultsIdRelationshipsVideosGetWithRequestBuilder(id: id, explicitFilter: explicitFilter?.toSearchResultsAPIEnum(), pageCursor: pageCursor, countryCode: countryCode, deviceType: deviceType?.toSearchResultsAPIEnum(), systemType: systemType?.toSearchResultsAPIEnum(), clientVersion: clientVersion, include: include, replaceMedia: replaceMedia)
		}
	}
}
