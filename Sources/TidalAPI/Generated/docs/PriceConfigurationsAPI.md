# PriceConfigurationsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**priceConfigurationsGet**](PriceConfigurationsAPI.md#priceconfigurationsget) | **GET** /priceConfigurations | Get multiple priceConfigurations.
[**priceConfigurationsIdGet**](PriceConfigurationsAPI.md#priceconfigurationsidget) | **GET** /priceConfigurations/{id} | Get single priceConfiguration.
[**priceConfigurationsPost**](PriceConfigurationsAPI.md#priceconfigurationspost) | **POST** /priceConfigurations | Create single priceConfiguration.


# **priceConfigurationsGet**
```swift
    open class func priceConfigurationsGet(filterId: [String]) async throws -> PriceConfigurationsMultiResourceDataDocument
```

Get multiple priceConfigurations.

Retrieves multiple priceConfigurations by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let filterId = ["inner_example"] // [String] | List of price configurations IDs (e.g. `cHJpY2UtY29uZmlnLTEyMzpVUw`)

// Get multiple priceConfigurations.
do {
    let response = try await PriceConfigurationsAPI.priceConfigurationsGet(filterId: filterId)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **filterId** | [**[String]**](String.md) | List of price configurations IDs (e.g. &#x60;cHJpY2UtY29uZmlnLTEyMzpVUw&#x60;) | 

### Return type

[**PriceConfigurationsMultiResourceDataDocument**](PriceConfigurationsMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **priceConfigurationsIdGet**
```swift
    open class func priceConfigurationsIdGet(id: String) async throws -> PriceConfigurationsSingleResourceDataDocument
```

Get single priceConfiguration.

Retrieves single priceConfiguration by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Price configuration id

// Get single priceConfiguration.
do {
    let response = try await PriceConfigurationsAPI.priceConfigurationsIdGet(id: id)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Price configuration id | 

### Return type

[**PriceConfigurationsSingleResourceDataDocument**](PriceConfigurationsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **priceConfigurationsPost**
```swift
    open class func priceConfigurationsPost(idempotencyKey: String? = nil, priceConfigurationsCreateOperationPayload: PriceConfigurationsCreateOperationPayload? = nil) async throws -> PriceConfigurationsCreateSingleResourceDataDocument
```

Create single priceConfiguration.

Creates a new priceConfiguration.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let priceConfigurationsCreateOperationPayload = PriceConfigurationsCreateOperation_Payload(data: PriceConfigurationsCreateOperation_Payload_Data(attributes: PriceConfigurationsCreateOperation_Payload_Data_Attributes(currency: "currency_example", price: "price_example"), relationships: PriceConfigurationsCreateOperation_Payload_Data_Relationships(subjects: PriceConfigurationsCreateOperation_Payload_Data_Relationships_Subjects(data: [PriceConfigurationsCreateOperation_Payload_Subjects(id: "id_example", type: "type_example")])), type: "type_example")) // PriceConfigurationsCreateOperationPayload |  (optional)

// Create single priceConfiguration.
do {
    let response = try await PriceConfigurationsAPI.priceConfigurationsPost(idempotencyKey: idempotencyKey, priceConfigurationsCreateOperationPayload: priceConfigurationsCreateOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **priceConfigurationsCreateOperationPayload** | [**PriceConfigurationsCreateOperationPayload**](PriceConfigurationsCreateOperationPayload.md) |  | [optional] 

### Return type

[**PriceConfigurationsCreateSingleResourceDataDocument**](PriceConfigurationsCreateSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

