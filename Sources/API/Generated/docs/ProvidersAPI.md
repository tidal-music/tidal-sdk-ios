# ProvidersAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getProviderById**](ProvidersAPI.md#getproviderbyid) | **GET** /providers/{id} | Get single provider
[**getProvidersByFilters**](ProvidersAPI.md#getprovidersbyfilters) | **GET** /providers | Get multiple providers


# **getProviderById**
```swift
    open class func getProviderById(id: String, include: [String]? = nil, completion: @escaping (_ data: ProvidersSingleDataDocument?, _ error: Error?) -> Void)
```

Get single provider

Retrieve provider details by TIDAL provider id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | TIDAL provider id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned (optional)

// Get single provider
ProvidersAPI.getProviderById(id: id, include: include) { (response, error) in
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
 **id** | **String** | TIDAL provider id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned | [optional] 

### Return type

[**ProvidersSingleDataDocument**](ProvidersSingleDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getProvidersByFilters**
```swift
    open class func getProvidersByFilters(include: [String]? = nil, filterId: [String]? = nil, completion: @escaping (_ data: ProvidersMultiDataDocument?, _ error: Error?) -> Void)
```

Get multiple providers

Retrieve multiple provider details.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned (optional)
let filterId = ["inner_example"] // [String] | provider id (optional)

// Get multiple providers
ProvidersAPI.getProvidersByFilters(include: include, filterId: filterId) { (response, error) in
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
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned | [optional] 
 **filterId** | [**[String]**](String.md) | provider id | [optional] 

### Return type

[**ProvidersMultiDataDocument**](ProvidersMultiDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

