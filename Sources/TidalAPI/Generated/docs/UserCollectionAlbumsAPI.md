# UserCollectionAlbumsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**userCollectionAlbumsIdGet**](UserCollectionAlbumsAPI.md#usercollectionalbumsidget) | **GET** /userCollectionAlbums/{id} | Get single userCollectionAlbum.
[**userCollectionAlbumsIdRelationshipsItemsDelete**](UserCollectionAlbumsAPI.md#usercollectionalbumsidrelationshipsitemsdelete) | **DELETE** /userCollectionAlbums/{id}/relationships/items | Delete from items relationship (\&quot;to-many\&quot;).
[**userCollectionAlbumsIdRelationshipsItemsGet**](UserCollectionAlbumsAPI.md#usercollectionalbumsidrelationshipsitemsget) | **GET** /userCollectionAlbums/{id}/relationships/items | Get items relationship (\&quot;to-many\&quot;).
[**userCollectionAlbumsIdRelationshipsItemsPost**](UserCollectionAlbumsAPI.md#usercollectionalbumsidrelationshipsitemspost) | **POST** /userCollectionAlbums/{id}/relationships/items | Add to items relationship (\&quot;to-many\&quot;).
[**userCollectionAlbumsIdRelationshipsOwnersGet**](UserCollectionAlbumsAPI.md#usercollectionalbumsidrelationshipsownersget) | **GET** /userCollectionAlbums/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).


# **userCollectionAlbumsIdGet**
```swift
    open class func userCollectionAlbumsIdGet(id: String, locale: String? = nil, include: [String]? = nil, includeLinkage: [IncludeLinkage_userCollectionAlbumsIdGet]? = nil, replaceMedia: String? = nil) async throws -> UserCollectionAlbumsSingleResourceDataDocument
```

Get single userCollectionAlbum.

Retrieves single userCollectionAlbum by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection albums id. Use `me` for the authenticated user's resource
let locale = "locale_example" // String | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. (optional) (default to "en-US")
let include = ["inner_example"] // [String] | Include related resources. Available relationships: items, owners (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: items (optional)

// Get single userCollectionAlbum.
do {
    let response = try await UserCollectionAlbumsAPI.userCollectionAlbumsIdGet(id: id, locale: locale, include: include, includeLinkage: includeLinkage, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | User collection albums id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **locale** | **String** | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. | [optional] [default to &quot;en-US&quot;]
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: items, owners | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: items | [optional] 

### Return type

[**UserCollectionAlbumsSingleResourceDataDocument**](UserCollectionAlbumsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionAlbumsIdRelationshipsItemsDelete**
```swift
    open class func userCollectionAlbumsIdRelationshipsItemsDelete(id: String, idempotencyKey: String? = nil, userCollectionAlbumsItemsRelationshipRemoveOperationPayload: UserCollectionAlbumsItemsRelationshipRemoveOperationPayload? = nil) async throws -> MutationResponseDocument
```

Delete from items relationship (\"to-many\").

Deletes item(s) from items relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection albums id. Use `me` for the authenticated user's resource
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let userCollectionAlbumsItemsRelationshipRemoveOperationPayload = UserCollectionAlbumsItemsRelationshipRemoveOperation_Payload(data: [UserCollectionAlbumsItemsRelationshipRemoveOperation_Payload_Data(id: "id_example", type: "type_example")]) // UserCollectionAlbumsItemsRelationshipRemoveOperationPayload |  (optional)

// Delete from items relationship (\"to-many\").
do {
    let response = try await UserCollectionAlbumsAPI.userCollectionAlbumsIdRelationshipsItemsDelete(id: id, idempotencyKey: idempotencyKey, userCollectionAlbumsItemsRelationshipRemoveOperationPayload: userCollectionAlbumsItemsRelationshipRemoveOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | User collection albums id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **userCollectionAlbumsItemsRelationshipRemoveOperationPayload** | [**UserCollectionAlbumsItemsRelationshipRemoveOperationPayload**](UserCollectionAlbumsItemsRelationshipRemoveOperationPayload.md) |  | [optional] 

### Return type

[**MutationResponseDocument**](MutationResponseDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionAlbumsIdRelationshipsItemsGet**
```swift
    open class func userCollectionAlbumsIdRelationshipsItemsGet(id: String, pageCursor: String? = nil, sort: [Sort_userCollectionAlbumsIdRelationshipsItemsGet]? = nil, locale: String? = nil, include: [String]? = nil, filterQuery: String? = nil, replaceMedia: String? = nil) async throws -> UserCollectionAlbumsItemsMultiRelationshipDataDocument
```

Get items relationship (\"to-many\").

Retrieves items relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection albums id. Use `me` for the authenticated user's resource
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let sort = ["sort_example"] // [String] | Values prefixed with \"-\" are sorted descending; values without it are sorted ascending. (optional)
let locale = "locale_example" // String | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. (optional) (default to "en-US")
let include = ["inner_example"] // [String] | Include related resources. Available relationships: items (optional)
let filterQuery = "filterQuery_example" // String | Filter albums by a free-text query matched against the album title and artist names. Internal clients only (e.g. `love`) (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: items (optional)

// Get items relationship (\"to-many\").
do {
    let response = try await UserCollectionAlbumsAPI.userCollectionAlbumsIdRelationshipsItemsGet(id: id, pageCursor: pageCursor, sort: sort, locale: locale, include: include, filterQuery: filterQuery, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | User collection albums id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **sort** | [**[String]**](String.md) | Values prefixed with \&quot;-\&quot; are sorted descending; values without it are sorted ascending. | [optional] 
 **locale** | **String** | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. | [optional] [default to &quot;en-US&quot;]
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: items | [optional] 
 **filterQuery** | **String** | Filter albums by a free-text query matched against the album title and artist names. Internal clients only (e.g. &#x60;love&#x60;) | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: items | [optional] 

### Return type

[**UserCollectionAlbumsItemsMultiRelationshipDataDocument**](UserCollectionAlbumsItemsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionAlbumsIdRelationshipsItemsPost**
```swift
    open class func userCollectionAlbumsIdRelationshipsItemsPost(id: String, idempotencyKey: String? = nil, userCollectionAlbumsItemsRelationshipAddOperationPayload: UserCollectionAlbumsItemsRelationshipAddOperationPayload? = nil) async throws -> UserCollectionAlbumsItemsAddMultiRelationshipDataDocument
```

Add to items relationship (\"to-many\").

Adds item(s) to items relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection albums id. Use `me` for the authenticated user's resource
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let userCollectionAlbumsItemsRelationshipAddOperationPayload = UserCollectionAlbumsItemsRelationshipAddOperation_Payload(data: [UserCollectionAlbumsItemsRelationshipAddOperation_Payload_Data(id: "id_example", meta: UserCollectionAlbumsItemsRelationshipAddOperation_Payload_Data_Meta(addedAt: Date()), type: "type_example")]) // UserCollectionAlbumsItemsRelationshipAddOperationPayload |  (optional)

// Add to items relationship (\"to-many\").
do {
    let response = try await UserCollectionAlbumsAPI.userCollectionAlbumsIdRelationshipsItemsPost(id: id, idempotencyKey: idempotencyKey, userCollectionAlbumsItemsRelationshipAddOperationPayload: userCollectionAlbumsItemsRelationshipAddOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | User collection albums id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **userCollectionAlbumsItemsRelationshipAddOperationPayload** | [**UserCollectionAlbumsItemsRelationshipAddOperationPayload**](UserCollectionAlbumsItemsRelationshipAddOperationPayload.md) |  | [optional] 

### Return type

[**UserCollectionAlbumsItemsAddMultiRelationshipDataDocument**](UserCollectionAlbumsItemsAddMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionAlbumsIdRelationshipsOwnersGet**
```swift
    open class func userCollectionAlbumsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> UserCollectionAlbumsOwnersMultiRelationshipDataDocument
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection albums id. Use `me` for the authenticated user's resource
let include = ["inner_example"] // [String] | Include related resources. Available relationships: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get owners relationship (\"to-many\").
do {
    let response = try await UserCollectionAlbumsAPI.userCollectionAlbumsIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | User collection albums id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**UserCollectionAlbumsOwnersMultiRelationshipDataDocument**](UserCollectionAlbumsOwnersMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

