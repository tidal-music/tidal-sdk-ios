# StripeDashboardLinksAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**stripeDashboardLinksGet**](StripeDashboardLinksAPI.md#stripedashboardlinksget) | **GET** /stripeDashboardLinks | Get multiple stripeDashboardLinks.
[**stripeDashboardLinksIdRelationshipsOwnersGet**](StripeDashboardLinksAPI.md#stripedashboardlinksidrelationshipsownersget) | **GET** /stripeDashboardLinks/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).


# **stripeDashboardLinksGet**
```swift
    open class func stripeDashboardLinksGet(include: [String]? = nil, filterOwnersId: [String]? = nil, completion: @escaping (_ data: StripeDashboardLinksMultiResourceDataDocument?, _ error: Error?) -> Void)
```

Get multiple stripeDashboardLinks.

Retrieves multiple stripeDashboardLinks by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners (optional)
let filterOwnersId = ["inner_example"] // [String] | User id (e.g. `123456`) (optional)

// Get multiple stripeDashboardLinks.
StripeDashboardLinksAPI.stripeDashboardLinksGet(include: include, filterOwnersId: filterOwnersId) { (response, error) in
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
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners | [optional] 
 **filterOwnersId** | [**[String]**](String.md) | User id (e.g. &#x60;123456&#x60;) | [optional] 

### Return type

[**StripeDashboardLinksMultiResourceDataDocument**](StripeDashboardLinksMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **stripeDashboardLinksIdRelationshipsOwnersGet**
```swift
    open class func stripeDashboardLinksIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: StripeDashboardLinksMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Stripe dashboard link id (same as user id)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get owners relationship (\"to-many\").
StripeDashboardLinksAPI.stripeDashboardLinksIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | Stripe dashboard link id (same as user id) | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**StripeDashboardLinksMultiRelationshipDataDocument**](StripeDashboardLinksMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

