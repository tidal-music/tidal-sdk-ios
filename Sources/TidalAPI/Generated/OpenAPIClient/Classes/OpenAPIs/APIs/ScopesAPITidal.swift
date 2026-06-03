import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `ScopesAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await ScopesAPITidal.getResource()
/// ```
public enum ScopesAPITidal {


	/**
	 * enum for parameter filterRequiredAccessTier
	 */
	public enum FilterRequiredAccessTier_scopesGet: String, CaseIterable {
		case thirdParty = "THIRD_PARTY"
		case thirdPartyProd = "THIRD_PARTY_PROD"
		case partner = "PARTNER"
		case _internal = "INTERNAL"

		func toScopesAPIEnum() -> ScopesAPI.FilterRequiredAccessTier_scopesGet {
			switch self {
			case .thirdParty: return .thirdParty
			case .thirdPartyProd: return .thirdPartyProd
			case .partner: return .partner
			case ._internal: return ._internal
			}
		}
	}

	/**
     Get multiple scopes.
     
     - returns: ScopesMultiResourceDataDocument
     */
	public static func scopesGet(filterRequiredAccessTier: [ScopesAPITidal.FilterRequiredAccessTier_scopesGet]? = nil) async throws -> ScopesMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			ScopesAPI.scopesGetWithRequestBuilder(filterRequiredAccessTier: filterRequiredAccessTier?.compactMap { $0.toScopesAPIEnum() })
		}
	}
}
