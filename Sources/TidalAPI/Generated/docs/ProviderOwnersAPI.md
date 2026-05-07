# ProviderOwnersAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**providerOwnersGet**](ProviderOwnersAPI.md#providerownersget) | **GET** /providerOwners | Get multiple providerOwners.
[**providerOwnersIdRelationshipsOwnersGet**](ProviderOwnersAPI.md#providerownersidrelationshipsownersget) | **GET** /providerOwners/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
[**providerOwnersIdRelationshipsProviderGet**](ProviderOwnersAPI.md#providerownersidrelationshipsproviderget) | **GET** /providerOwners/{id}/relationships/provider | Get provider relationship (\&quot;to-one\&quot;).


# **providerOwnersGet**
```swift
    open class func providerOwnersGet(include: [String]? = nil, filterOwnersId: [String]? = nil, completion: @escaping (_ data: ProviderOwnersMultiResourceDataDocument?, _ error: Error?) -> Void)
```

Get multiple providerOwners.

Retrieves multiple providerOwners by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners, provider (optional)
let filterOwnersId = ["inner_example"] // [String] | User id. Use `me` for the authenticated user (optional)

// Get multiple providerOwners.
ProviderOwnersAPI.providerOwnersGet(include: include, filterOwnersId: filterOwnersId) { (response, error) in
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
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners, provider | [optional] 
 **filterOwnersId** | [**[String]**](String.md) | User id. Use &#x60;me&#x60; for the authenticated user | [optional] 

### Return type

[**ProviderOwnersMultiResourceDataDocument**](ProviderOwnersMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **providerOwnersIdRelationshipsOwnersGet**
```swift
    open class func providerOwnersIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: ProviderOwnersMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Provider owner id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get owners relationship (\"to-many\").
ProviderOwnersAPI.providerOwnersIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | Provider owner id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**ProviderOwnersMultiRelationshipDataDocument**](ProviderOwnersMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **providerOwnersIdRelationshipsProviderGet**
```swift
    open class func providerOwnersIdRelationshipsProviderGet(id: String, include: [String]? = nil, completion: @escaping (_ data: ProviderOwnersSingleRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get provider relationship (\"to-one\").

Retrieves provider relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Provider owner id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: provider (optional)

// Get provider relationship (\"to-one\").
ProviderOwnersAPI.providerOwnersIdRelationshipsProviderGet(id: id, include: include) { (response, error) in
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
 **id** | **String** | Provider owner id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: provider | [optional] 

### Return type

[**ProviderOwnersSingleRelationshipDataDocument**](ProviderOwnersSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

