# PriceConfigurationsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**priceConfigurationsGet**](PriceConfigurationsAPI.md#priceconfigurationsget) | **GET** /priceConfigurations | Get multiple priceConfigurations.
[**priceConfigurationsIdGet**](PriceConfigurationsAPI.md#priceconfigurationsidget) | **GET** /priceConfigurations/{id} | Get single priceConfiguration.
[**priceConfigurationsPost**](PriceConfigurationsAPI.md#priceconfigurationspost) | **POST** /priceConfigurations | Create single priceConfiguration.


# **priceConfigurationsGet**
```swift
    open class func priceConfigurationsGet(filterId: [String]? = nil, completion: @escaping (_ data: PriceConfigurationsMultiResourceDataDocument?, _ error: Error?) -> Void)
```

Get multiple priceConfigurations.

Retrieves multiple priceConfigurations by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let filterId = ["inner_example"] // [String] | Price configuration id (optional)

// Get multiple priceConfigurations.
PriceConfigurationsAPI.priceConfigurationsGet(filterId: filterId) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **filterId** | [**[String]**](String.md) | Price configuration id | [optional] 

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
    open class func priceConfigurationsIdGet(id: String, completion: @escaping (_ data: PriceConfigurationsSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single priceConfiguration.

Retrieves single priceConfiguration by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Price configuration id

// Get single priceConfiguration.
PriceConfigurationsAPI.priceConfigurationsIdGet(id: id) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
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
    open class func priceConfigurationsPost(priceConfigurationsCreateOperationPayload: PriceConfigurationsCreateOperationPayload? = nil, completion: @escaping (_ data: PriceConfigurationsSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Create single priceConfiguration.

Creates a new priceConfiguration.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let priceConfigurationsCreateOperationPayload = PriceConfigurationsCreateOperation_Payload(data: PriceConfigurationsCreateOperation_Payload_Data(attributes: PriceConfigurationsCreateOperation_Payload_Data_Attributes(currency: "currency_example", price: 123), relationships: PriceConfigurationsCreateOperation_Payload_Data_Relationships(subjects: [PriceConfigurationsCreateOperation_Payload_Subjects(id: "id_example", type: "type_example")]), type: "type_example")) // PriceConfigurationsCreateOperationPayload |  (optional)

// Create single priceConfiguration.
PriceConfigurationsAPI.priceConfigurationsPost(priceConfigurationsCreateOperationPayload: priceConfigurationsCreateOperationPayload) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **priceConfigurationsCreateOperationPayload** | [**PriceConfigurationsCreateOperationPayload**](PriceConfigurationsCreateOperationPayload.md) |  | [optional] 

### Return type

[**PriceConfigurationsSingleResourceDataDocument**](PriceConfigurationsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

