# UserEntitlementsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**userEntitlementsIdGet**](UserEntitlementsAPI.md#userentitlementsidget) | **GET** /userEntitlements/{id} | Get single userEntitlement.
[**userEntitlementsIdRelationshipsOwnersGet**](UserEntitlementsAPI.md#userentitlementsidrelationshipsownersget) | **GET** /userEntitlements/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).


# **userEntitlementsIdGet**
```swift
    open class func userEntitlementsIdGet(id: String, include: [String]? = nil, completion: @escaping (_ data: UserEntitlementsSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single userEntitlement.

Retrieves single userEntitlement by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners (optional)

// Get single userEntitlement.
UserEntitlementsAPI.userEntitlementsIdGet(id: id, include: include) { (response, error) in
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
 **id** | **String** | User id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners | [optional] 

### Return type

[**UserEntitlementsSingleResourceDataDocument**](UserEntitlementsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userEntitlementsIdRelationshipsOwnersGet**
```swift
    open class func userEntitlementsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: UserEntitlementsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get owners relationship (\"to-many\").
UserEntitlementsAPI.userEntitlementsIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | User id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**UserEntitlementsMultiRelationshipDataDocument**](UserEntitlementsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

