# ScopesAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**scopesGet**](ScopesAPI.md#scopesget) | **GET** /scopes | Get multiple scopes.


# **scopesGet**
```swift
    open class func scopesGet(filterRequiredAccessTier: [FilterRequiredAccessTier_scopesGet]) async throws -> ScopesMultiResourceDataDocument
```

Get multiple scopes.

Retrieves multiple scopes by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let filterRequiredAccessTier = ["filterRequiredAccessTier_example"] // [String] | Filters scopes by their `requiredAccessTier`. (e.g. `THIRD_PARTY`)

// Get multiple scopes.
do {
    let response = try await ScopesAPI.scopesGet(filterRequiredAccessTier: filterRequiredAccessTier)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **filterRequiredAccessTier** | [**[String]**](String.md) | Filters scopes by their &#x60;requiredAccessTier&#x60;. (e.g. &#x60;THIRD_PARTY&#x60;) | 

### Return type

[**ScopesMultiResourceDataDocument**](ScopesMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

