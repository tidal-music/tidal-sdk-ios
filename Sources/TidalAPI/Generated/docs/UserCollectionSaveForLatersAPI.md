# UserCollectionSaveForLatersAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**userCollectionSaveForLatersIdGet**](UserCollectionSaveForLatersAPI.md#usercollectionsaveforlatersidget) | **GET** /userCollectionSaveForLaters/{id} | Get single userCollectionSaveForLater.
[**userCollectionSaveForLatersIdRelationshipsItemsDelete**](UserCollectionSaveForLatersAPI.md#usercollectionsaveforlatersidrelationshipsitemsdelete) | **DELETE** /userCollectionSaveForLaters/{id}/relationships/items | Delete from items relationship (\&quot;to-many\&quot;).
[**userCollectionSaveForLatersIdRelationshipsItemsGet**](UserCollectionSaveForLatersAPI.md#usercollectionsaveforlatersidrelationshipsitemsget) | **GET** /userCollectionSaveForLaters/{id}/relationships/items | Get items relationship (\&quot;to-many\&quot;).
[**userCollectionSaveForLatersIdRelationshipsItemsPost**](UserCollectionSaveForLatersAPI.md#usercollectionsaveforlatersidrelationshipsitemspost) | **POST** /userCollectionSaveForLaters/{id}/relationships/items | Add to items relationship (\&quot;to-many\&quot;).
[**userCollectionSaveForLatersIdRelationshipsOwnersGet**](UserCollectionSaveForLatersAPI.md#usercollectionsaveforlatersidrelationshipsownersget) | **GET** /userCollectionSaveForLaters/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).


# **userCollectionSaveForLatersIdGet**
```swift
    open class func userCollectionSaveForLatersIdGet(id: String, include: [String]? = nil, completion: @escaping (_ data: UserCollectionSaveForLatersSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single userCollectionSaveForLater.

Retrieves single userCollectionSaveForLater by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection save for later id. Use `me` for the authenticated user's resource
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: items, owners (optional)

// Get single userCollectionSaveForLater.
UserCollectionSaveForLatersAPI.userCollectionSaveForLatersIdGet(id: id, include: include) { (response, error) in
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
 **id** | **String** | User collection save for later id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: items, owners | [optional] 

### Return type

[**UserCollectionSaveForLatersSingleResourceDataDocument**](UserCollectionSaveForLatersSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionSaveForLatersIdRelationshipsItemsDelete**
```swift
    open class func userCollectionSaveForLatersIdRelationshipsItemsDelete(id: String, idempotencyKey: String? = nil, userCollectionSaveForLatersItemsRelationshipRemoveOperationPayload: UserCollectionSaveForLatersItemsRelationshipRemoveOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Delete from items relationship (\"to-many\").

Deletes item(s) from items relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection save for later id. Use `me` for the authenticated user's resource
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. (optional)
let userCollectionSaveForLatersItemsRelationshipRemoveOperationPayload = UserCollectionSaveForLatersItemsRelationshipRemoveOperation_Payload(data: [UserCollectionSaveForLatersItemsRelationshipRemoveOperation_Payload_Data(id: "id_example", type: "type_example")]) // UserCollectionSaveForLatersItemsRelationshipRemoveOperationPayload |  (optional)

// Delete from items relationship (\"to-many\").
UserCollectionSaveForLatersAPI.userCollectionSaveForLatersIdRelationshipsItemsDelete(id: id, idempotencyKey: idempotencyKey, userCollectionSaveForLatersItemsRelationshipRemoveOperationPayload: userCollectionSaveForLatersItemsRelationshipRemoveOperationPayload) { (response, error) in
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
 **id** | **String** | User collection save for later id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. | [optional] 
 **userCollectionSaveForLatersItemsRelationshipRemoveOperationPayload** | [**UserCollectionSaveForLatersItemsRelationshipRemoveOperationPayload**](UserCollectionSaveForLatersItemsRelationshipRemoveOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionSaveForLatersIdRelationshipsItemsGet**
```swift
    open class func userCollectionSaveForLatersIdRelationshipsItemsGet(id: String, pageCursor: String? = nil, include: [String]? = nil, completion: @escaping (_ data: UserCollectionSaveForLatersItemsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get items relationship (\"to-many\").

Retrieves items relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection save for later id. Use `me` for the authenticated user's resource
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: items (optional)

// Get items relationship (\"to-many\").
UserCollectionSaveForLatersAPI.userCollectionSaveForLatersIdRelationshipsItemsGet(id: id, pageCursor: pageCursor, include: include) { (response, error) in
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
 **id** | **String** | User collection save for later id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: items | [optional] 

### Return type

[**UserCollectionSaveForLatersItemsMultiRelationshipDataDocument**](UserCollectionSaveForLatersItemsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionSaveForLatersIdRelationshipsItemsPost**
```swift
    open class func userCollectionSaveForLatersIdRelationshipsItemsPost(id: String, idempotencyKey: String? = nil, userCollectionSaveForLatersItemsRelationshipAddOperationPayload: UserCollectionSaveForLatersItemsRelationshipAddOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Add to items relationship (\"to-many\").

Adds item(s) to items relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection save for later id. Use `me` for the authenticated user's resource
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. (optional)
let userCollectionSaveForLatersItemsRelationshipAddOperationPayload = UserCollectionSaveForLatersItemsRelationshipAddOperation_Payload(data: [UserCollectionSaveForLatersItemsRelationshipAddOperation_Payload_Data(id: "id_example", type: "type_example")]) // UserCollectionSaveForLatersItemsRelationshipAddOperationPayload |  (optional)

// Add to items relationship (\"to-many\").
UserCollectionSaveForLatersAPI.userCollectionSaveForLatersIdRelationshipsItemsPost(id: id, idempotencyKey: idempotencyKey, userCollectionSaveForLatersItemsRelationshipAddOperationPayload: userCollectionSaveForLatersItemsRelationshipAddOperationPayload) { (response, error) in
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
 **id** | **String** | User collection save for later id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. | [optional] 
 **userCollectionSaveForLatersItemsRelationshipAddOperationPayload** | [**UserCollectionSaveForLatersItemsRelationshipAddOperationPayload**](UserCollectionSaveForLatersItemsRelationshipAddOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionSaveForLatersIdRelationshipsOwnersGet**
```swift
    open class func userCollectionSaveForLatersIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: UserCollectionSaveForLatersMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection save for later id. Use `me` for the authenticated user's resource
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get owners relationship (\"to-many\").
UserCollectionSaveForLatersAPI.userCollectionSaveForLatersIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | User collection save for later id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**UserCollectionSaveForLatersMultiRelationshipDataDocument**](UserCollectionSaveForLatersMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

