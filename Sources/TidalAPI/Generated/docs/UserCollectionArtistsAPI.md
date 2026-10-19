# UserCollectionArtistsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**userCollectionArtistsIdGet**](UserCollectionArtistsAPI.md#usercollectionartistsidget) | **GET** /userCollectionArtists/{id} | Get single userCollectionArtist.
[**userCollectionArtistsIdRelationshipsItemsDelete**](UserCollectionArtistsAPI.md#usercollectionartistsidrelationshipsitemsdelete) | **DELETE** /userCollectionArtists/{id}/relationships/items | Delete from items relationship (\&quot;to-many\&quot;).
[**userCollectionArtistsIdRelationshipsItemsGet**](UserCollectionArtistsAPI.md#usercollectionartistsidrelationshipsitemsget) | **GET** /userCollectionArtists/{id}/relationships/items | Get items relationship (\&quot;to-many\&quot;).
[**userCollectionArtistsIdRelationshipsItemsPost**](UserCollectionArtistsAPI.md#usercollectionartistsidrelationshipsitemspost) | **POST** /userCollectionArtists/{id}/relationships/items | Add to items relationship (\&quot;to-many\&quot;).
[**userCollectionArtistsIdRelationshipsOwnersGet**](UserCollectionArtistsAPI.md#usercollectionartistsidrelationshipsownersget) | **GET** /userCollectionArtists/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).


# **userCollectionArtistsIdGet**
```swift
    open class func userCollectionArtistsIdGet(id: String, locale: String? = nil, include: [String]? = nil, includeLinkage: [IncludeLinkage_userCollectionArtistsIdGet]? = nil, replaceMedia: String? = nil) async throws -> UserCollectionArtistsSingleResourceDataDocument
```

Get single userCollectionArtist.

Retrieves single userCollectionArtist by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection artists id. Use `me` for the authenticated user's resource
let locale = "locale_example" // String | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. (optional) (default to "en-US")
let include = ["inner_example"] // [String] | Include related resources. Available relationships: items, owners (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: items.albums (optional)

// Get single userCollectionArtist.
do {
    let response = try await UserCollectionArtistsAPI.userCollectionArtistsIdGet(id: id, locale: locale, include: include, includeLinkage: includeLinkage, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | User collection artists id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **locale** | **String** | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. | [optional] [default to &quot;en-US&quot;]
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: items, owners | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: items.albums | [optional] 

### Return type

[**UserCollectionArtistsSingleResourceDataDocument**](UserCollectionArtistsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionArtistsIdRelationshipsItemsDelete**
```swift
    open class func userCollectionArtistsIdRelationshipsItemsDelete(id: String, idempotencyKey: String? = nil, userCollectionArtistsItemsRelationshipRemoveOperationPayload: UserCollectionArtistsItemsRelationshipRemoveOperationPayload? = nil) async throws -> MutationResponseDocument
```

Delete from items relationship (\"to-many\").

Deletes item(s) from items relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection artists id. Use `me` for the authenticated user's resource
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let userCollectionArtistsItemsRelationshipRemoveOperationPayload = UserCollectionArtistsItemsRelationshipRemoveOperation_Payload(data: [UserCollectionArtistsItemsRelationshipRemoveOperation_Payload_Data(id: "id_example", type: "type_example")]) // UserCollectionArtistsItemsRelationshipRemoveOperationPayload |  (optional)

// Delete from items relationship (\"to-many\").
do {
    let response = try await UserCollectionArtistsAPI.userCollectionArtistsIdRelationshipsItemsDelete(id: id, idempotencyKey: idempotencyKey, userCollectionArtistsItemsRelationshipRemoveOperationPayload: userCollectionArtistsItemsRelationshipRemoveOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | User collection artists id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **userCollectionArtistsItemsRelationshipRemoveOperationPayload** | [**UserCollectionArtistsItemsRelationshipRemoveOperationPayload**](UserCollectionArtistsItemsRelationshipRemoveOperationPayload.md) |  | [optional] 

### Return type

[**MutationResponseDocument**](MutationResponseDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionArtistsIdRelationshipsItemsGet**
```swift
    open class func userCollectionArtistsIdRelationshipsItemsGet(id: String, pageCursor: String? = nil, sort: [Sort_userCollectionArtistsIdRelationshipsItemsGet]? = nil, locale: String? = nil, include: [String]? = nil, filterQuery: String? = nil, replaceMedia: String? = nil) async throws -> UserCollectionArtistsItemsMultiRelationshipDataDocument
```

Get items relationship (\"to-many\").

Retrieves items relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection artists id. Use `me` for the authenticated user's resource
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let sort = ["sort_example"] // [String] | Values prefixed with \"-\" are sorted descending; values without it are sorted ascending. (optional)
let locale = "locale_example" // String | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. (optional) (default to "en-US")
let include = ["inner_example"] // [String] | Include related resources. Available relationships: items (optional)
let filterQuery = "filterQuery_example" // String | Filter artists by a free-text query matched against the artist name. Internal clients only (e.g. `love`) (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: items.albums (optional)

// Get items relationship (\"to-many\").
do {
    let response = try await UserCollectionArtistsAPI.userCollectionArtistsIdRelationshipsItemsGet(id: id, pageCursor: pageCursor, sort: sort, locale: locale, include: include, filterQuery: filterQuery, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | User collection artists id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **sort** | [**[String]**](String.md) | Values prefixed with \&quot;-\&quot; are sorted descending; values without it are sorted ascending. | [optional] 
 **locale** | **String** | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. | [optional] [default to &quot;en-US&quot;]
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: items | [optional] 
 **filterQuery** | **String** | Filter artists by a free-text query matched against the artist name. Internal clients only (e.g. &#x60;love&#x60;) | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: items.albums | [optional] 

### Return type

[**UserCollectionArtistsItemsMultiRelationshipDataDocument**](UserCollectionArtistsItemsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionArtistsIdRelationshipsItemsPost**
```swift
    open class func userCollectionArtistsIdRelationshipsItemsPost(id: String, idempotencyKey: String? = nil, userCollectionArtistsItemsRelationshipAddOperationPayload: UserCollectionArtistsItemsRelationshipAddOperationPayload? = nil) async throws -> UserCollectionArtistsItemsAddMultiRelationshipDataDocument
```

Add to items relationship (\"to-many\").

Adds item(s) to items relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection artists id. Use `me` for the authenticated user's resource
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let userCollectionArtistsItemsRelationshipAddOperationPayload = UserCollectionArtistsItemsRelationshipAddOperation_Payload(data: [UserCollectionArtistsItemsRelationshipAddOperation_Payload_Data(id: "id_example", meta: UserCollectionArtistsItemsRelationshipAddOperation_Payload_Data_Meta(addedAt: Date()), type: "type_example")]) // UserCollectionArtistsItemsRelationshipAddOperationPayload |  (optional)

// Add to items relationship (\"to-many\").
do {
    let response = try await UserCollectionArtistsAPI.userCollectionArtistsIdRelationshipsItemsPost(id: id, idempotencyKey: idempotencyKey, userCollectionArtistsItemsRelationshipAddOperationPayload: userCollectionArtistsItemsRelationshipAddOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | User collection artists id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **userCollectionArtistsItemsRelationshipAddOperationPayload** | [**UserCollectionArtistsItemsRelationshipAddOperationPayload**](UserCollectionArtistsItemsRelationshipAddOperationPayload.md) |  | [optional] 

### Return type

[**UserCollectionArtistsItemsAddMultiRelationshipDataDocument**](UserCollectionArtistsItemsAddMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionArtistsIdRelationshipsOwnersGet**
```swift
    open class func userCollectionArtistsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> UserCollectionArtistsOwnersMultiRelationshipDataDocument
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection artists id. Use `me` for the authenticated user's resource
let include = ["inner_example"] // [String] | Include related resources. Available relationships: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get owners relationship (\"to-many\").
do {
    let response = try await UserCollectionArtistsAPI.userCollectionArtistsIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | User collection artists id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**UserCollectionArtistsOwnersMultiRelationshipDataDocument**](UserCollectionArtistsOwnersMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

