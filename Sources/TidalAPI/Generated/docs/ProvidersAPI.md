# ProvidersAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**providersGet**](ProvidersAPI.md#providersget) | **GET** /providers | Get multiple providers.
[**providersIdGet**](ProvidersAPI.md#providersidget) | **GET** /providers/{id} | Get single provider.


# **providersGet**
```swift
    open class func providersGet(filterId: [String]? = nil, completion: @escaping (_ data: ProvidersMultiResourceDataDocument?, _ error: Error?) -> Void)
```

Get multiple providers.

Retrieves multiple providers by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let filterId = ["inner_example"] // [String] | Provider ID (optional)

// Get multiple providers.
ProvidersAPI.providersGet(filterId: filterId) { (response, error) in
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
 **filterId** | [**[String]**](String.md) | Provider ID | [optional] 

### Return type

[**ProvidersMultiResourceDataDocument**](ProvidersMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **providersIdGet**
```swift
    open class func providersIdGet(id: String, completion: @escaping (_ data: ProvidersSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single provider.

Retrieves single provider by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Provider ID

// Get single provider.
ProvidersAPI.providersIdGet(id: id) { (response, error) in
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
 **id** | **String** | Provider ID | 

### Return type

[**ProvidersSingleResourceDataDocument**](ProvidersSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

