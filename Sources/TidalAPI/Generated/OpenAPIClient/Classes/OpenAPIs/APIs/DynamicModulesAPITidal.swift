import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `DynamicModulesAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await DynamicModulesAPITidal.getResource()
/// ```
public enum DynamicModulesAPITidal {


	/**
	 * enum for parameter deviceType
	 */
	public enum DeviceType_dynamicModulesGet: String, CaseIterable {
		case browser = "BROWSER"
		case car = "CAR"
		case desktop = "DESKTOP"
		case phone = "PHONE"
		case tablet = "TABLET"
		case tv = "TV"

		func toDynamicModulesAPIEnum() -> DynamicModulesAPI.DeviceType_dynamicModulesGet {
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
	public enum SystemType_dynamicModulesGet: String, CaseIterable {
		case android = "ANDROID"
		case desktop = "DESKTOP"
		case tesla = "TESLA"
		case ios = "IOS"
		case web = "WEB"

		func toDynamicModulesAPIEnum() -> DynamicModulesAPI.SystemType_dynamicModulesGet {
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
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_dynamicModulesGet: String, CaseIterable {
		case items = "items"
		case seeditem = "seedItem"

		func toDynamicModulesAPIEnum() -> DynamicModulesAPI.IncludeLinkage_dynamicModulesGet {
			switch self {
			case .items: return .items
			case .seeditem: return .seeditem
			}
		}
	}

	/**
     Get multiple dynamicModules.
     
     - returns: DynamicModulesMultiResourceDataDocument
     */
	public static func dynamicModulesGet(clientVersion: String, deviceType: DynamicModulesAPITidal.DeviceType_dynamicModulesGet, filterId: [String], systemType: DynamicModulesAPITidal.SystemType_dynamicModulesGet, countryCode: String? = nil, include: [String]? = nil, includeLinkage: [DynamicModulesAPITidal.IncludeLinkage_dynamicModulesGet]? = nil, locale: String? = nil, refreshSeed: String? = nil, replaceMedia: String? = nil) async throws -> DynamicModulesMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			DynamicModulesAPI.dynamicModulesGetWithRequestBuilder(clientVersion: clientVersion, deviceType: deviceType.toDynamicModulesAPIEnum(), filterId: filterId, systemType: systemType.toDynamicModulesAPIEnum(), countryCode: countryCode, include: include, includeLinkage: includeLinkage?.compactMap { $0.toDynamicModulesAPIEnum() }, locale: locale, refreshSeed: refreshSeed, replaceMedia: replaceMedia)
		}
	}


	/**
	 * enum for parameter deviceType
	 */
	public enum DeviceType_dynamicModulesIdGet: String, CaseIterable {
		case browser = "BROWSER"
		case car = "CAR"
		case desktop = "DESKTOP"
		case phone = "PHONE"
		case tablet = "TABLET"
		case tv = "TV"

		func toDynamicModulesAPIEnum() -> DynamicModulesAPI.DeviceType_dynamicModulesIdGet {
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
	public enum SystemType_dynamicModulesIdGet: String, CaseIterable {
		case android = "ANDROID"
		case desktop = "DESKTOP"
		case tesla = "TESLA"
		case ios = "IOS"
		case web = "WEB"

		func toDynamicModulesAPIEnum() -> DynamicModulesAPI.SystemType_dynamicModulesIdGet {
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
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_dynamicModulesIdGet: String, CaseIterable {
		case items = "items"
		case seeditem = "seedItem"

		func toDynamicModulesAPIEnum() -> DynamicModulesAPI.IncludeLinkage_dynamicModulesIdGet {
			switch self {
			case .items: return .items
			case .seeditem: return .seeditem
			}
		}
	}

	/**
     Get single dynamicModule.
     
     - returns: DynamicModulesSingleResourceDataDocument
     */
	public static func dynamicModulesIdGet(clientVersion: String, deviceType: DynamicModulesAPITidal.DeviceType_dynamicModulesIdGet, id: String, systemType: DynamicModulesAPITidal.SystemType_dynamicModulesIdGet, countryCode: String? = nil, include: [String]? = nil, includeLinkage: [DynamicModulesAPITidal.IncludeLinkage_dynamicModulesIdGet]? = nil, locale: String? = nil, refreshSeed: String? = nil, replaceMedia: String? = nil) async throws -> DynamicModulesSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			DynamicModulesAPI.dynamicModulesIdGetWithRequestBuilder(clientVersion: clientVersion, deviceType: deviceType.toDynamicModulesAPIEnum(), id: id, systemType: systemType.toDynamicModulesAPIEnum(), countryCode: countryCode, include: include, includeLinkage: includeLinkage?.compactMap { $0.toDynamicModulesAPIEnum() }, locale: locale, refreshSeed: refreshSeed, replaceMedia: replaceMedia)
		}
	}


	/**
	 * enum for parameter deviceType
	 */
	public enum DeviceType_dynamicModulesIdRelationshipsItemsGet: String, CaseIterable {
		case browser = "BROWSER"
		case car = "CAR"
		case desktop = "DESKTOP"
		case phone = "PHONE"
		case tablet = "TABLET"
		case tv = "TV"

		func toDynamicModulesAPIEnum() -> DynamicModulesAPI.DeviceType_dynamicModulesIdRelationshipsItemsGet {
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
	public enum SystemType_dynamicModulesIdRelationshipsItemsGet: String, CaseIterable {
		case android = "ANDROID"
		case desktop = "DESKTOP"
		case tesla = "TESLA"
		case ios = "IOS"
		case web = "WEB"

		func toDynamicModulesAPIEnum() -> DynamicModulesAPI.SystemType_dynamicModulesIdRelationshipsItemsGet {
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
     Get items relationship (\&quot;to-many\&quot;).
     
     - returns: DynamicModulesItemsMultiRelationshipDataDocument
     */
	public static func dynamicModulesIdRelationshipsItemsGet(clientVersion: String, deviceType: DynamicModulesAPITidal.DeviceType_dynamicModulesIdRelationshipsItemsGet, id: String, systemType: DynamicModulesAPITidal.SystemType_dynamicModulesIdRelationshipsItemsGet, countryCode: String? = nil, include: [String]? = nil, locale: String? = nil, pageCursor: String? = nil, refreshSeed: String? = nil, replaceMedia: String? = nil) async throws -> DynamicModulesItemsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			DynamicModulesAPI.dynamicModulesIdRelationshipsItemsGetWithRequestBuilder(clientVersion: clientVersion, deviceType: deviceType.toDynamicModulesAPIEnum(), id: id, systemType: systemType.toDynamicModulesAPIEnum(), countryCode: countryCode, include: include, locale: locale, pageCursor: pageCursor, refreshSeed: refreshSeed, replaceMedia: replaceMedia)
		}
	}


	/**
	 * enum for parameter deviceType
	 */
	public enum DeviceType_dynamicModulesIdRelationshipsSeedItemGet: String, CaseIterable {
		case browser = "BROWSER"
		case car = "CAR"
		case desktop = "DESKTOP"
		case phone = "PHONE"
		case tablet = "TABLET"
		case tv = "TV"

		func toDynamicModulesAPIEnum() -> DynamicModulesAPI.DeviceType_dynamicModulesIdRelationshipsSeedItemGet {
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
	public enum SystemType_dynamicModulesIdRelationshipsSeedItemGet: String, CaseIterable {
		case android = "ANDROID"
		case desktop = "DESKTOP"
		case tesla = "TESLA"
		case ios = "IOS"
		case web = "WEB"

		func toDynamicModulesAPIEnum() -> DynamicModulesAPI.SystemType_dynamicModulesIdRelationshipsSeedItemGet {
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
     Get seedItem relationship (\&quot;to-one\&quot;).
     
     - returns: DynamicModulesSeedItemSingleRelationshipDataDocument
     */
	public static func dynamicModulesIdRelationshipsSeedItemGet(clientVersion: String, deviceType: DynamicModulesAPITidal.DeviceType_dynamicModulesIdRelationshipsSeedItemGet, id: String, systemType: DynamicModulesAPITidal.SystemType_dynamicModulesIdRelationshipsSeedItemGet, countryCode: String? = nil, include: [String]? = nil, locale: String? = nil, refreshSeed: String? = nil, replaceMedia: String? = nil) async throws -> DynamicModulesSeedItemSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			DynamicModulesAPI.dynamicModulesIdRelationshipsSeedItemGetWithRequestBuilder(clientVersion: clientVersion, deviceType: deviceType.toDynamicModulesAPIEnum(), id: id, systemType: systemType.toDynamicModulesAPIEnum(), countryCode: countryCode, include: include, locale: locale, refreshSeed: refreshSeed, replaceMedia: replaceMedia)
		}
	}
}
