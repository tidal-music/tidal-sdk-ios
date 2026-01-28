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
     Get multiple dynamicModules.
     
     - returns: DynamicModulesMultiResourceDataDocument
     */
	public static func dynamicModulesGet(deviceType: DynamicModulesAPITidal.DeviceType_dynamicModulesGet, systemType: DynamicModulesAPITidal.SystemType_dynamicModulesGet, clientVersion: String, refreshId: String? = nil, countryCode: String? = nil, locale: String? = nil, include: [String]? = nil, filterId: [String]? = nil) async throws -> DynamicModulesMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			DynamicModulesAPI.dynamicModulesGetWithRequestBuilder(deviceType: deviceType.toDynamicModulesAPIEnum(), systemType: systemType.toDynamicModulesAPIEnum(), clientVersion: clientVersion, refreshId: refreshId, countryCode: countryCode, locale: locale, include: include, filterId: filterId)
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
     
     - returns: DynamicModulesMultiRelationshipDataDocument
     */
	public static func dynamicModulesIdRelationshipsItemsGet(id: String, deviceType: DynamicModulesAPITidal.DeviceType_dynamicModulesIdRelationshipsItemsGet, systemType: DynamicModulesAPITidal.SystemType_dynamicModulesIdRelationshipsItemsGet, clientVersion: String, refreshId: Int64? = nil, pageCursor: String? = nil, countryCode: String? = nil, locale: String? = nil, include: [String]? = nil) async throws -> DynamicModulesMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			DynamicModulesAPI.dynamicModulesIdRelationshipsItemsGetWithRequestBuilder(id: id, deviceType: deviceType.toDynamicModulesAPIEnum(), systemType: systemType.toDynamicModulesAPIEnum(), clientVersion: clientVersion, refreshId: refreshId, pageCursor: pageCursor, countryCode: countryCode, locale: locale, include: include)
		}
	}
}
