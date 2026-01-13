import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `DynamicPagesAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await DynamicPagesAPITidal.getResource()
/// ```
public enum DynamicPagesAPITidal {


	/**
	 * enum for parameter deviceType
	 */
	public enum DeviceType_dynamicPagesGet: String, CaseIterable {
		case browser = "BROWSER"
		case car = "CAR"
		case desktop = "DESKTOP"
		case phone = "PHONE"
		case tablet = "TABLET"
		case tv = "TV"

		func toDynamicPagesAPIEnum() -> DynamicPagesAPI.DeviceType_dynamicPagesGet {
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
	 * enum for parameter platform
	 */
	public enum Platform_dynamicPagesGet: String, CaseIterable {
		case android = "ANDROID"
		case desktop = "DESKTOP"
		case tesla = "TESLA"
		case ios = "IOS"
		case web = "WEB"

		func toDynamicPagesAPIEnum() -> DynamicPagesAPI.Platform_dynamicPagesGet {
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
     Get multiple dynamicPages.
     
     - returns: DynamicPagesMultiResourceDataDocument
     */
	public static func dynamicPagesGet(clientVersion: String, deviceType: DynamicPagesAPITidal.DeviceType_dynamicPagesGet, platform: DynamicPagesAPITidal.Platform_dynamicPagesGet, refreshId: Int64? = nil, countryCode: String? = nil, locale: String? = nil, include: [String]? = nil, filterPageType: [String]? = nil, filterSubjectId: [String]? = nil) async throws -> DynamicPagesMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			DynamicPagesAPI.dynamicPagesGetWithRequestBuilder(clientVersion: clientVersion, deviceType: deviceType.toDynamicPagesAPIEnum(), platform: platform.toDynamicPagesAPIEnum(), refreshId: refreshId, countryCode: countryCode, locale: locale, include: include, filterPageType: filterPageType, filterSubjectId: filterSubjectId)
		}
	}


	/**
     Get subject relationship (\&quot;to-one\&quot;).
     
     - returns: DynamicPagesSingleRelationshipDataDocument
     */
	public static func dynamicPagesIdRelationshipsSubjectGet(id: String, include: [String]? = nil) async throws -> DynamicPagesSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			DynamicPagesAPI.dynamicPagesIdRelationshipsSubjectGetWithRequestBuilder(id: id, include: include)
		}
	}
}
