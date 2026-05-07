# PurchasesAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**purchasesGet**](PurchasesAPI.md#purchasesget) | **GET** /purchases | Get multiple purchases.
[**purchasesIdRelationshipsOwnersGet**](PurchasesAPI.md#purchasesidrelationshipsownersget) | **GET** /purchases/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
[**purchasesIdRelationshipsSubjectGet**](PurchasesAPI.md#purchasesidrelationshipssubjectget) | **GET** /purchases/{id}/relationships/subject | Get subject relationship (\&quot;to-one\&quot;).


# **purchasesGet**
```swift
    open class func purchasesGet(pageCursor: String? = nil, include: [String]? = nil, filterOwnersId: [String]? = nil, filterSubjectType: [FilterSubjectType_purchasesGet]? = nil, completion: @escaping (_ data: PurchasesMultiResourceDataDocument?, _ error: Error?) -> Void)
```

Get multiple purchases.

Retrieves multiple purchases by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners, subject (optional)
let filterOwnersId = ["inner_example"] // [String] | User id. Use `me` for the authenticated user (optional)
let filterSubjectType = ["filterSubjectType_example"] // [String] | The type of purchased content (e.g. `albums`) (optional)

// Get multiple purchases.
PurchasesAPI.purchasesGet(pageCursor: pageCursor, include: include, filterOwnersId: filterOwnersId, filterSubjectType: filterSubjectType) { (response, error) in
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
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners, subject | [optional] 
 **filterOwnersId** | [**[String]**](String.md) | User id. Use &#x60;me&#x60; for the authenticated user | [optional] 
 **filterSubjectType** | [**[String]**](String.md) | The type of purchased content (e.g. &#x60;albums&#x60;) | [optional] 

### Return type

[**PurchasesMultiResourceDataDocument**](PurchasesMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **purchasesIdRelationshipsOwnersGet**
```swift
    open class func purchasesIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: PurchasesMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Purchase id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get owners relationship (\"to-many\").
PurchasesAPI.purchasesIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | Purchase id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**PurchasesMultiRelationshipDataDocument**](PurchasesMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **purchasesIdRelationshipsSubjectGet**
```swift
    open class func purchasesIdRelationshipsSubjectGet(id: String, include: [String]? = nil, completion: @escaping (_ data: PurchasesSingleRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get subject relationship (\"to-one\").

Retrieves subject relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Purchase id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: subject (optional)

// Get subject relationship (\"to-one\").
PurchasesAPI.purchasesIdRelationshipsSubjectGet(id: id, include: include) { (response, error) in
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
 **id** | **String** | Purchase id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: subject | [optional] 

### Return type

[**PurchasesSingleRelationshipDataDocument**](PurchasesSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

