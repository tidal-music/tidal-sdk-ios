# UserCollectionPlaylistsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**userCollectionPlaylistsIdGet**](UserCollectionPlaylistsAPI.md#usercollectionplaylistsidget) | **GET** /userCollectionPlaylists/{id} | Get single userCollectionPlaylist.
[**userCollectionPlaylistsIdRelationshipsItemsDelete**](UserCollectionPlaylistsAPI.md#usercollectionplaylistsidrelationshipsitemsdelete) | **DELETE** /userCollectionPlaylists/{id}/relationships/items | Delete from items relationship (\&quot;to-many\&quot;).
[**userCollectionPlaylistsIdRelationshipsItemsGet**](UserCollectionPlaylistsAPI.md#usercollectionplaylistsidrelationshipsitemsget) | **GET** /userCollectionPlaylists/{id}/relationships/items | Get items relationship (\&quot;to-many\&quot;).
[**userCollectionPlaylistsIdRelationshipsItemsPost**](UserCollectionPlaylistsAPI.md#usercollectionplaylistsidrelationshipsitemspost) | **POST** /userCollectionPlaylists/{id}/relationships/items | Add to items relationship (\&quot;to-many\&quot;).
[**userCollectionPlaylistsIdRelationshipsOwnersGet**](UserCollectionPlaylistsAPI.md#usercollectionplaylistsidrelationshipsownersget) | **GET** /userCollectionPlaylists/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).


# **userCollectionPlaylistsIdGet**
```swift
    open class func userCollectionPlaylistsIdGet(id: String, locale: String? = nil, include: [String]? = nil, includeLinkage: [IncludeLinkage_userCollectionPlaylistsIdGet]? = nil, replaceMedia: String? = nil) async throws -> UserCollectionPlaylistsSingleResourceDataDocument
```

Get single userCollectionPlaylist.

Retrieves single userCollectionPlaylist by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection playlists id. Use `me` for the authenticated user's resource
let locale = "locale_example" // String | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. (optional) (default to "en-US")
let include = ["inner_example"] // [String] | Include related resources. Available relationships: items, owners (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: items.items (optional)

// Get single userCollectionPlaylist.
do {
    let response = try await UserCollectionPlaylistsAPI.userCollectionPlaylistsIdGet(id: id, locale: locale, include: include, includeLinkage: includeLinkage, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | User collection playlists id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **locale** | **String** | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. | [optional] [default to &quot;en-US&quot;]
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: items, owners | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: items.items | [optional] 

### Return type

[**UserCollectionPlaylistsSingleResourceDataDocument**](UserCollectionPlaylistsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionPlaylistsIdRelationshipsItemsDelete**
```swift
    open class func userCollectionPlaylistsIdRelationshipsItemsDelete(id: String, idempotencyKey: String? = nil, userCollectionPlaylistsItemsRelationshipRemoveOperationPayload: UserCollectionPlaylistsItemsRelationshipRemoveOperationPayload? = nil) async throws -> MutationResponseDocument
```

Delete from items relationship (\"to-many\").

Deletes item(s) from items relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection playlists id. Use `me` for the authenticated user's resource
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let userCollectionPlaylistsItemsRelationshipRemoveOperationPayload = UserCollectionPlaylistsItemsRelationshipRemoveOperation_Payload(data: [UserCollectionPlaylistsItemsRelationshipRemoveOperation_Payload_Data(id: "id_example", type: "type_example")]) // UserCollectionPlaylistsItemsRelationshipRemoveOperationPayload |  (optional)

// Delete from items relationship (\"to-many\").
do {
    let response = try await UserCollectionPlaylistsAPI.userCollectionPlaylistsIdRelationshipsItemsDelete(id: id, idempotencyKey: idempotencyKey, userCollectionPlaylistsItemsRelationshipRemoveOperationPayload: userCollectionPlaylistsItemsRelationshipRemoveOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | User collection playlists id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **userCollectionPlaylistsItemsRelationshipRemoveOperationPayload** | [**UserCollectionPlaylistsItemsRelationshipRemoveOperationPayload**](UserCollectionPlaylistsItemsRelationshipRemoveOperationPayload.md) |  | [optional] 

### Return type

[**MutationResponseDocument**](MutationResponseDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionPlaylistsIdRelationshipsItemsGet**
```swift
    open class func userCollectionPlaylistsIdRelationshipsItemsGet(id: String, collectionView: CollectionView_userCollectionPlaylistsIdRelationshipsItemsGet? = nil, pageCursor: String? = nil, sort: [Sort_userCollectionPlaylistsIdRelationshipsItemsGet]? = nil, include: [String]? = nil, filterQuery: String? = nil, replaceMedia: String? = nil) async throws -> UserCollectionPlaylistsItemsMultiRelationshipDataDocument
```

Get items relationship (\"to-many\").

Retrieves items relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection playlists id. Use `me` for the authenticated user's resource
let collectionView = "collectionView_example" // String |  (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let sort = ["sort_example"] // [String] | Values prefixed with \"-\" are sorted descending; values without it are sorted ascending. (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: items (optional)
let filterQuery = "filterQuery_example" // String | Filter playlists by a free-text query. Returns matching playlists only (no mixes or folders), including playlists inside folders. Cannot be combined with collectionView=FOLDERS. Internal clients only (e.g. `summer`) (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: items.items (optional)

// Get items relationship (\"to-many\").
do {
    let response = try await UserCollectionPlaylistsAPI.userCollectionPlaylistsIdRelationshipsItemsGet(id: id, collectionView: collectionView, pageCursor: pageCursor, sort: sort, include: include, filterQuery: filterQuery, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | User collection playlists id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **collectionView** | **String** |  | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **sort** | [**[String]**](String.md) | Values prefixed with \&quot;-\&quot; are sorted descending; values without it are sorted ascending. | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: items | [optional] 
 **filterQuery** | **String** | Filter playlists by a free-text query. Returns matching playlists only (no mixes or folders), including playlists inside folders. Cannot be combined with collectionView&#x3D;FOLDERS. Internal clients only (e.g. &#x60;summer&#x60;) | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: items.items | [optional] 

### Return type

[**UserCollectionPlaylistsItemsMultiRelationshipDataDocument**](UserCollectionPlaylistsItemsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionPlaylistsIdRelationshipsItemsPost**
```swift
    open class func userCollectionPlaylistsIdRelationshipsItemsPost(id: String, idempotencyKey: String? = nil, userCollectionPlaylistsItemsRelationshipAddOperationPayload: UserCollectionPlaylistsItemsRelationshipAddOperationPayload? = nil) async throws -> UserCollectionPlaylistsItemsAddMultiRelationshipDataDocument
```

Add to items relationship (\"to-many\").

Adds item(s) to items relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection playlists id. Use `me` for the authenticated user's resource
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let userCollectionPlaylistsItemsRelationshipAddOperationPayload = UserCollectionPlaylistsItemsRelationshipAddOperation_Payload(data: [UserCollectionPlaylistsItemsRelationshipAddOperation_Payload_Data(id: "id_example", meta: UserCollectionPlaylistsItemsRelationshipAddOperation_Payload_Data_Meta(addedAt: Date()), type: "type_example")]) // UserCollectionPlaylistsItemsRelationshipAddOperationPayload |  (optional)

// Add to items relationship (\"to-many\").
do {
    let response = try await UserCollectionPlaylistsAPI.userCollectionPlaylistsIdRelationshipsItemsPost(id: id, idempotencyKey: idempotencyKey, userCollectionPlaylistsItemsRelationshipAddOperationPayload: userCollectionPlaylistsItemsRelationshipAddOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | User collection playlists id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **userCollectionPlaylistsItemsRelationshipAddOperationPayload** | [**UserCollectionPlaylistsItemsRelationshipAddOperationPayload**](UserCollectionPlaylistsItemsRelationshipAddOperationPayload.md) |  | [optional] 

### Return type

[**UserCollectionPlaylistsItemsAddMultiRelationshipDataDocument**](UserCollectionPlaylistsItemsAddMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionPlaylistsIdRelationshipsOwnersGet**
```swift
    open class func userCollectionPlaylistsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> UserCollectionPlaylistsOwnersMultiRelationshipDataDocument
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection playlists id. Use `me` for the authenticated user's resource
let include = ["inner_example"] // [String] | Include related resources. Available relationships: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get owners relationship (\"to-many\").
do {
    let response = try await UserCollectionPlaylistsAPI.userCollectionPlaylistsIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | User collection playlists id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**UserCollectionPlaylistsOwnersMultiRelationshipDataDocument**](UserCollectionPlaylistsOwnersMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

