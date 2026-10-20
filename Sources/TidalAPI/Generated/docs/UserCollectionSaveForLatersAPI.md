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
    open class func userCollectionSaveForLatersIdGet(id: String, include: [String]? = nil, includeLinkage: [IncludeLinkage_userCollectionSaveForLatersIdGet]? = nil, replaceMedia: String? = nil) async throws -> UserCollectionSaveForLatersSingleResourceDataDocument
```

Get single userCollectionSaveForLater.

Retrieves single userCollectionSaveForLater by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection save for later id. Use `me` for the authenticated user's resource
let include = ["inner_example"] // [String] | Include related resources. Available relationships: items, owners (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: items (optional)

// Get single userCollectionSaveForLater.
do {
    let response = try await UserCollectionSaveForLatersAPI.userCollectionSaveForLatersIdGet(id: id, include: include, includeLinkage: includeLinkage, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | User collection save for later id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: items, owners | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: items | [optional] 

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
    open class func userCollectionSaveForLatersIdRelationshipsItemsDelete(id: String, idempotencyKey: String? = nil, userCollectionSaveForLatersItemsRelationshipRemoveOperationPayload: UserCollectionSaveForLatersItemsRelationshipRemoveOperationPayload? = nil) async throws -> MutationResponseDocument
```

Delete from items relationship (\"to-many\").

Deletes item(s) from items relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection save for later id. Use `me` for the authenticated user's resource
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let userCollectionSaveForLatersItemsRelationshipRemoveOperationPayload = UserCollectionSaveForLatersItemsRelationshipRemoveOperation_Payload(data: [UserCollectionSaveForLatersItemsRelationshipRemoveOperation_Payload_Data(id: "id_example", type: "type_example")]) // UserCollectionSaveForLatersItemsRelationshipRemoveOperationPayload |  (optional)

// Delete from items relationship (\"to-many\").
do {
    let response = try await UserCollectionSaveForLatersAPI.userCollectionSaveForLatersIdRelationshipsItemsDelete(id: id, idempotencyKey: idempotencyKey, userCollectionSaveForLatersItemsRelationshipRemoveOperationPayload: userCollectionSaveForLatersItemsRelationshipRemoveOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | User collection save for later id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **userCollectionSaveForLatersItemsRelationshipRemoveOperationPayload** | [**UserCollectionSaveForLatersItemsRelationshipRemoveOperationPayload**](UserCollectionSaveForLatersItemsRelationshipRemoveOperationPayload.md) |  | [optional] 

### Return type

[**MutationResponseDocument**](MutationResponseDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionSaveForLatersIdRelationshipsItemsGet**
```swift
    open class func userCollectionSaveForLatersIdRelationshipsItemsGet(id: String, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil) async throws -> UserCollectionSaveForLatersItemsMultiRelationshipDataDocument
```

Get items relationship (\"to-many\").

Retrieves items relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection save for later id. Use `me` for the authenticated user's resource
let include = ["inner_example"] // [String] | Include related resources. Available relationships: items (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: items (optional)

// Get items relationship (\"to-many\").
do {
    let response = try await UserCollectionSaveForLatersAPI.userCollectionSaveForLatersIdRelationshipsItemsGet(id: id, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | User collection save for later id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: items | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: items | [optional] 

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
    open class func userCollectionSaveForLatersIdRelationshipsItemsPost(id: String, idempotencyKey: String? = nil, userCollectionSaveForLatersItemsRelationshipAddOperationPayload: UserCollectionSaveForLatersItemsRelationshipAddOperationPayload? = nil) async throws -> UserCollectionSaveForLatersItemsAddMultiRelationshipDataDocument
```

Add to items relationship (\"to-many\").

Adds item(s) to items relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection save for later id. Use `me` for the authenticated user's resource
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let userCollectionSaveForLatersItemsRelationshipAddOperationPayload = UserCollectionSaveForLatersItemsRelationshipAddOperation_Payload(data: [UserCollectionSaveForLatersItemsRelationshipAddOperation_Payload_Data(id: "id_example", type: "type_example")]) // UserCollectionSaveForLatersItemsRelationshipAddOperationPayload |  (optional)

// Add to items relationship (\"to-many\").
do {
    let response = try await UserCollectionSaveForLatersAPI.userCollectionSaveForLatersIdRelationshipsItemsPost(id: id, idempotencyKey: idempotencyKey, userCollectionSaveForLatersItemsRelationshipAddOperationPayload: userCollectionSaveForLatersItemsRelationshipAddOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | User collection save for later id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **userCollectionSaveForLatersItemsRelationshipAddOperationPayload** | [**UserCollectionSaveForLatersItemsRelationshipAddOperationPayload**](UserCollectionSaveForLatersItemsRelationshipAddOperationPayload.md) |  | [optional] 

### Return type

[**UserCollectionSaveForLatersItemsAddMultiRelationshipDataDocument**](UserCollectionSaveForLatersItemsAddMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionSaveForLatersIdRelationshipsOwnersGet**
```swift
    open class func userCollectionSaveForLatersIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> UserCollectionSaveForLatersOwnersMultiRelationshipDataDocument
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection save for later id. Use `me` for the authenticated user's resource
let include = ["inner_example"] // [String] | Include related resources. Available relationships: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get owners relationship (\"to-many\").
do {
    let response = try await UserCollectionSaveForLatersAPI.userCollectionSaveForLatersIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | User collection save for later id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**UserCollectionSaveForLatersOwnersMultiRelationshipDataDocument**](UserCollectionSaveForLatersOwnersMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

