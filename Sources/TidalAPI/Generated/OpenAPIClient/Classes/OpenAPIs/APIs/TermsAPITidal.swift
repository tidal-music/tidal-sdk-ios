import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `TermsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await TermsAPITidal.getResource()
/// ```
public enum TermsAPITidal {


	/**
	 * enum for parameter filterTermsType
	 */
	public enum FilterTermsType_termsGet: String, CaseIterable {
		case developer = "DEVELOPER"
		case uploadMarketplace = "UPLOAD_MARKETPLACE"

		func toTermsAPIEnum() -> TermsAPI.FilterTermsType_termsGet {
			switch self {
			case .developer: return .developer
			case .uploadMarketplace: return .uploadMarketplace
			}
		}
	}

	/**
     Get multiple terms.
     
     - returns: TermsMultiResourceDataDocument
     */
	public static func termsGet(filterTermsType: [TermsAPITidal.FilterTermsType_termsGet], filterCountryCode: [String]? = nil, filterIsLatestVersion: [String]? = nil) async throws -> TermsMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			TermsAPI.termsGetWithRequestBuilder(filterTermsType: filterTermsType.compactMap { $0.toTermsAPIEnum() }, filterCountryCode: filterCountryCode, filterIsLatestVersion: filterIsLatestVersion)
		}
	}


	/**
     Get single term.
     
     - returns: TermsSingleResourceDataDocument
     */
	public static func termsIdGet(id: String) async throws -> TermsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			TermsAPI.termsIdGetWithRequestBuilder(id: id)
		}
	}
}
