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
    open class func userCollectionAlbumsIdGet(id: String, countryCode: String? = nil, locale: String? = nil, include: [String]? = nil, completion: @escaping (_ data: UserCollectionAlbumsSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single userCollectionAlbum.

Retrieves single userCollectionAlbum by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection albums id. Use `me` for the authenticated user's resource
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let locale = "locale_example" // String | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. (optional) (default to "en-US")
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: items, owners (optional)

// Get single userCollectionAlbum.
UserCollectionAlbumsAPI.userCollectionAlbumsIdGet(id: id, countryCode: countryCode, locale: locale, include: include) { (response, error) in
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
 **id** | **String** | User collection albums id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **locale** | **String** | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. | [optional] [default to &quot;en-US&quot;]
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: items, owners | [optional] 

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
    open class func userCollectionAlbumsIdRelationshipsItemsDelete(id: String, idempotencyKey: String? = nil, userCollectionAlbumsItemsRelationshipRemoveOperationPayload: UserCollectionAlbumsItemsRelationshipRemoveOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Delete from items relationship (\"to-many\").

Deletes item(s) from items relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection albums id. Use `me` for the authenticated user's resource
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. (optional)
let userCollectionAlbumsItemsRelationshipRemoveOperationPayload = UserCollectionAlbumsItemsRelationshipRemoveOperation_Payload(data: [UserCollectionAlbumsItemsRelationshipRemoveOperation_Payload_Data(id: "id_example", type: "type_example")]) // UserCollectionAlbumsItemsRelationshipRemoveOperationPayload |  (optional)

// Delete from items relationship (\"to-many\").
UserCollectionAlbumsAPI.userCollectionAlbumsIdRelationshipsItemsDelete(id: id, idempotencyKey: idempotencyKey, userCollectionAlbumsItemsRelationshipRemoveOperationPayload: userCollectionAlbumsItemsRelationshipRemoveOperationPayload) { (response, error) in
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
 **id** | **String** | User collection albums id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. | [optional] 
 **userCollectionAlbumsItemsRelationshipRemoveOperationPayload** | [**UserCollectionAlbumsItemsRelationshipRemoveOperationPayload**](UserCollectionAlbumsItemsRelationshipRemoveOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionAlbumsIdRelationshipsItemsGet**
```swift
    open class func userCollectionAlbumsIdRelationshipsItemsGet(id: String, pageCursor: String? = nil, sort: [Sort_userCollectionAlbumsIdRelationshipsItemsGet]? = nil, countryCode: String? = nil, locale: String? = nil, include: [String]? = nil, completion: @escaping (_ data: UserCollectionAlbumsItemsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
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
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let locale = "locale_example" // String | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. (optional) (default to "en-US")
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: items (optional)

// Get items relationship (\"to-many\").
UserCollectionAlbumsAPI.userCollectionAlbumsIdRelationshipsItemsGet(id: id, pageCursor: pageCursor, sort: sort, countryCode: countryCode, locale: locale, include: include) { (response, error) in
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
 **id** | **String** | User collection albums id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **sort** | [**[String]**](String.md) | Values prefixed with \&quot;-\&quot; are sorted descending; values without it are sorted ascending. | [optional] 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **locale** | **String** | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. | [optional] [default to &quot;en-US&quot;]
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: items | [optional] 

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
    open class func userCollectionAlbumsIdRelationshipsItemsPost(id: String, countryCode: String? = nil, idempotencyKey: String? = nil, userCollectionAlbumsItemsRelationshipAddOperationPayload: UserCollectionAlbumsItemsRelationshipAddOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Add to items relationship (\"to-many\").

Adds item(s) to items relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection albums id. Use `me` for the authenticated user's resource
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. (optional)
let userCollectionAlbumsItemsRelationshipAddOperationPayload = UserCollectionAlbumsItemsRelationshipAddOperation_Payload(data: [UserCollectionAlbumsItemsRelationshipAddOperation_Payload_Data(id: "id_example", meta: UserCollectionAlbumsItemsRelationshipAddOperation_Payload_Data_Meta(addedAt: Date()), type: "type_example")]) // UserCollectionAlbumsItemsRelationshipAddOperationPayload |  (optional)

// Add to items relationship (\"to-many\").
UserCollectionAlbumsAPI.userCollectionAlbumsIdRelationshipsItemsPost(id: id, countryCode: countryCode, idempotencyKey: idempotencyKey, userCollectionAlbumsItemsRelationshipAddOperationPayload: userCollectionAlbumsItemsRelationshipAddOperationPayload) { (response, error) in
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
 **id** | **String** | User collection albums id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. | [optional] 
 **userCollectionAlbumsItemsRelationshipAddOperationPayload** | [**UserCollectionAlbumsItemsRelationshipAddOperationPayload**](UserCollectionAlbumsItemsRelationshipAddOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionAlbumsIdRelationshipsOwnersGet**
```swift
    open class func userCollectionAlbumsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: UserCollectionAlbumsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection albums id. Use `me` for the authenticated user's resource
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get owners relationship (\"to-many\").
UserCollectionAlbumsAPI.userCollectionAlbumsIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | User collection albums id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**UserCollectionAlbumsMultiRelationshipDataDocument**](UserCollectionAlbumsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

