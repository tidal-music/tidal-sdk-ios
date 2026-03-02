# UserCollectionVideosAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**userCollectionVideosIdGet**](UserCollectionVideosAPI.md#usercollectionvideosidget) | **GET** /userCollectionVideos/{id} | Get single userCollectionVideo.
[**userCollectionVideosIdRelationshipsItemsDelete**](UserCollectionVideosAPI.md#usercollectionvideosidrelationshipsitemsdelete) | **DELETE** /userCollectionVideos/{id}/relationships/items | Delete from items relationship (\&quot;to-many\&quot;).
[**userCollectionVideosIdRelationshipsItemsGet**](UserCollectionVideosAPI.md#usercollectionvideosidrelationshipsitemsget) | **GET** /userCollectionVideos/{id}/relationships/items | Get items relationship (\&quot;to-many\&quot;).
[**userCollectionVideosIdRelationshipsItemsPost**](UserCollectionVideosAPI.md#usercollectionvideosidrelationshipsitemspost) | **POST** /userCollectionVideos/{id}/relationships/items | Add to items relationship (\&quot;to-many\&quot;).
[**userCollectionVideosIdRelationshipsOwnersGet**](UserCollectionVideosAPI.md#usercollectionvideosidrelationshipsownersget) | **GET** /userCollectionVideos/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).


# **userCollectionVideosIdGet**
```swift
    open class func userCollectionVideosIdGet(id: String, countryCode: String? = nil, locale: String? = nil, include: [String]? = nil, completion: @escaping (_ data: UserCollectionVideosSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single userCollectionVideo.

Retrieves single userCollectionVideo by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection videos id. Use `me` for the authenticated user's resource
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let locale = "locale_example" // String | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. (optional) (default to "en-US")
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: items, owners (optional)

// Get single userCollectionVideo.
UserCollectionVideosAPI.userCollectionVideosIdGet(id: id, countryCode: countryCode, locale: locale, include: include) { (response, error) in
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
 **id** | **String** | User collection videos id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **locale** | **String** | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. | [optional] [default to &quot;en-US&quot;]
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: items, owners | [optional] 

### Return type

[**UserCollectionVideosSingleResourceDataDocument**](UserCollectionVideosSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionVideosIdRelationshipsItemsDelete**
```swift
    open class func userCollectionVideosIdRelationshipsItemsDelete(id: String, idempotencyKey: String? = nil, userCollectionVideosItemsRelationshipRemoveOperationPayload: UserCollectionVideosItemsRelationshipRemoveOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Delete from items relationship (\"to-many\").

Deletes item(s) from items relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection videos id. Use `me` for the authenticated user's resource
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. (optional)
let userCollectionVideosItemsRelationshipRemoveOperationPayload = UserCollectionVideosItemsRelationshipRemoveOperation_Payload(data: [UserCollectionVideosItemsRelationshipRemoveOperation_Payload_Data(id: "id_example", type: "type_example")]) // UserCollectionVideosItemsRelationshipRemoveOperationPayload |  (optional)

// Delete from items relationship (\"to-many\").
UserCollectionVideosAPI.userCollectionVideosIdRelationshipsItemsDelete(id: id, idempotencyKey: idempotencyKey, userCollectionVideosItemsRelationshipRemoveOperationPayload: userCollectionVideosItemsRelationshipRemoveOperationPayload) { (response, error) in
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
 **id** | **String** | User collection videos id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. | [optional] 
 **userCollectionVideosItemsRelationshipRemoveOperationPayload** | [**UserCollectionVideosItemsRelationshipRemoveOperationPayload**](UserCollectionVideosItemsRelationshipRemoveOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionVideosIdRelationshipsItemsGet**
```swift
    open class func userCollectionVideosIdRelationshipsItemsGet(id: String, pageCursor: String? = nil, sort: [Sort_userCollectionVideosIdRelationshipsItemsGet]? = nil, countryCode: String? = nil, locale: String? = nil, include: [String]? = nil, completion: @escaping (_ data: UserCollectionVideosItemsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get items relationship (\"to-many\").

Retrieves items relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection videos id. Use `me` for the authenticated user's resource
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let sort = ["sort_example"] // [String] | Values prefixed with \"-\" are sorted descending; values without it are sorted ascending. (optional)
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let locale = "locale_example" // String | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. (optional) (default to "en-US")
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: items (optional)

// Get items relationship (\"to-many\").
UserCollectionVideosAPI.userCollectionVideosIdRelationshipsItemsGet(id: id, pageCursor: pageCursor, sort: sort, countryCode: countryCode, locale: locale, include: include) { (response, error) in
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
 **id** | **String** | User collection videos id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **sort** | [**[String]**](String.md) | Values prefixed with \&quot;-\&quot; are sorted descending; values without it are sorted ascending. | [optional] 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **locale** | **String** | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. | [optional] [default to &quot;en-US&quot;]
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: items | [optional] 

### Return type

[**UserCollectionVideosItemsMultiRelationshipDataDocument**](UserCollectionVideosItemsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionVideosIdRelationshipsItemsPost**
```swift
    open class func userCollectionVideosIdRelationshipsItemsPost(id: String, countryCode: String? = nil, idempotencyKey: String? = nil, userCollectionVideosItemsRelationshipAddOperationPayload: UserCollectionVideosItemsRelationshipAddOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Add to items relationship (\"to-many\").

Adds item(s) to items relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection videos id. Use `me` for the authenticated user's resource
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. (optional)
let userCollectionVideosItemsRelationshipAddOperationPayload = UserCollectionVideosItemsRelationshipAddOperation_Payload(data: [UserCollectionVideosItemsRelationshipAddOperation_Payload_Data(id: "id_example", type: "type_example")]) // UserCollectionVideosItemsRelationshipAddOperationPayload |  (optional)

// Add to items relationship (\"to-many\").
UserCollectionVideosAPI.userCollectionVideosIdRelationshipsItemsPost(id: id, countryCode: countryCode, idempotencyKey: idempotencyKey, userCollectionVideosItemsRelationshipAddOperationPayload: userCollectionVideosItemsRelationshipAddOperationPayload) { (response, error) in
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
 **id** | **String** | User collection videos id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. | [optional] 
 **userCollectionVideosItemsRelationshipAddOperationPayload** | [**UserCollectionVideosItemsRelationshipAddOperationPayload**](UserCollectionVideosItemsRelationshipAddOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionVideosIdRelationshipsOwnersGet**
```swift
    open class func userCollectionVideosIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: UserCollectionVideosMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection videos id. Use `me` for the authenticated user's resource
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get owners relationship (\"to-many\").
UserCollectionVideosAPI.userCollectionVideosIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | User collection videos id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**UserCollectionVideosMultiRelationshipDataDocument**](UserCollectionVideosMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

