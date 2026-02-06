import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `UsageRulesAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await UsageRulesAPITidal.getResource()
/// ```
public enum UsageRulesAPITidal {


	/**
     Get multiple usageRules.
     
     - returns: UsageRulesMultiResourceDataDocument
     */
	public static func usageRulesGet(filterId: [String]? = nil) async throws -> UsageRulesMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			UsageRulesAPI.usageRulesGetWithRequestBuilder(filterId: filterId)
		}
	}


	/**
     Get single usageRule.
     
     - returns: UsageRulesSingleResourceDataDocument
     */
	public static func usageRulesIdGet(id: String) async throws -> UsageRulesSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			UsageRulesAPI.usageRulesIdGetWithRequestBuilder(id: id)
		}
	}


	/**
     Create single usageRule.
     
     - returns: UsageRulesSingleResourceDataDocument
     */
	public static func usageRulesPost(usageRulesCreateOperationPayload: UsageRulesCreateOperationPayload? = nil) async throws -> UsageRulesSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			UsageRulesAPI.usageRulesPostWithRequestBuilder(usageRulesCreateOperationPayload: usageRulesCreateOperationPayload)
		}
	}
}
