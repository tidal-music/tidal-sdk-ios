import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `PriceConfigurationsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await PriceConfigurationsAPITidal.getResource()
/// ```
public enum PriceConfigurationsAPITidal {


	/**
     Get multiple priceConfigurations.
     
     - returns: PriceConfigurationsMultiResourceDataDocument
     */
	public static func priceConfigurationsGet(filterId: [String]? = nil) async throws -> PriceConfigurationsMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			PriceConfigurationsAPI.priceConfigurationsGetWithRequestBuilder(filterId: filterId)
		}
	}


	/**
     Get single priceConfiguration.
     
     - returns: PriceConfigurationsSingleResourceDataDocument
     */
	public static func priceConfigurationsIdGet(id: String) async throws -> PriceConfigurationsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			PriceConfigurationsAPI.priceConfigurationsIdGetWithRequestBuilder(id: id)
		}
	}


	/**
     Create single priceConfiguration.
     
     - returns: PriceConfigurationsSingleResourceDataDocument
     */
	public static func priceConfigurationsPost(priceConfigurationsCreateOperationPayload: PriceConfigurationsCreateOperationPayload? = nil) async throws -> PriceConfigurationsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			PriceConfigurationsAPI.priceConfigurationsPostWithRequestBuilder(priceConfigurationsCreateOperationPayload: priceConfigurationsCreateOperationPayload)
		}
	}
}
