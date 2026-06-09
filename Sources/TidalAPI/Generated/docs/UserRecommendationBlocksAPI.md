# UserRecommendationBlocksAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**userRecommendationBlocksIdGet**](UserRecommendationBlocksAPI.md#userrecommendationblocksidget) | **GET** /userRecommendationBlocks/{id} | Get single userRecommendationBlock.
[**userRecommendationBlocksIdRelationshipsArtistsDelete**](UserRecommendationBlocksAPI.md#userrecommendationblocksidrelationshipsartistsdelete) | **DELETE** /userRecommendationBlocks/{id}/relationships/artists | Delete from artists relationship (\&quot;to-many\&quot;).
[**userRecommendationBlocksIdRelationshipsArtistsGet**](UserRecommendationBlocksAPI.md#userrecommendationblocksidrelationshipsartistsget) | **GET** /userRecommendationBlocks/{id}/relationships/artists | Get artists relationship (\&quot;to-many\&quot;).
[**userRecommendationBlocksIdRelationshipsArtistsPost**](UserRecommendationBlocksAPI.md#userrecommendationblocksidrelationshipsartistspost) | **POST** /userRecommendationBlocks/{id}/relationships/artists | Add to artists relationship (\&quot;to-many\&quot;).
[**userRecommendationBlocksIdRelationshipsOwnersGet**](UserRecommendationBlocksAPI.md#userrecommendationblocksidrelationshipsownersget) | **GET** /userRecommendationBlocks/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
[**userRecommendationBlocksIdRelationshipsTracksDelete**](UserRecommendationBlocksAPI.md#userrecommendationblocksidrelationshipstracksdelete) | **DELETE** /userRecommendationBlocks/{id}/relationships/tracks | Delete from tracks relationship (\&quot;to-many\&quot;).
[**userRecommendationBlocksIdRelationshipsTracksGet**](UserRecommendationBlocksAPI.md#userrecommendationblocksidrelationshipstracksget) | **GET** /userRecommendationBlocks/{id}/relationships/tracks | Get tracks relationship (\&quot;to-many\&quot;).
[**userRecommendationBlocksIdRelationshipsTracksPost**](UserRecommendationBlocksAPI.md#userrecommendationblocksidrelationshipstrackspost) | **POST** /userRecommendationBlocks/{id}/relationships/tracks | Add to tracks relationship (\&quot;to-many\&quot;).
[**userRecommendationBlocksIdRelationshipsVideosDelete**](UserRecommendationBlocksAPI.md#userrecommendationblocksidrelationshipsvideosdelete) | **DELETE** /userRecommendationBlocks/{id}/relationships/videos | Delete from videos relationship (\&quot;to-many\&quot;).
[**userRecommendationBlocksIdRelationshipsVideosGet**](UserRecommendationBlocksAPI.md#userrecommendationblocksidrelationshipsvideosget) | **GET** /userRecommendationBlocks/{id}/relationships/videos | Get videos relationship (\&quot;to-many\&quot;).
[**userRecommendationBlocksIdRelationshipsVideosPost**](UserRecommendationBlocksAPI.md#userrecommendationblocksidrelationshipsvideospost) | **POST** /userRecommendationBlocks/{id}/relationships/videos | Add to videos relationship (\&quot;to-many\&quot;).


# **userRecommendationBlocksIdGet**
```swift
    open class func userRecommendationBlocksIdGet(id: String, countryCode: String? = nil, locale: String? = nil, include: [String]? = nil, completion: @escaping (_ data: UserRecommendationBlocksSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single userRecommendationBlock.

Retrieves single userRecommendationBlock by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User recommendation blocks id. Use `me` for the authenticated user's resource
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let locale = "locale_example" // String | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. (optional) (default to "en-US")
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: artists, owners, tracks, videos (optional)

// Get single userRecommendationBlock.
UserRecommendationBlocksAPI.userRecommendationBlocksIdGet(id: id, countryCode: countryCode, locale: locale, include: include) { (response, error) in
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
 **id** | **String** | User recommendation blocks id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **locale** | **String** | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. | [optional] [default to &quot;en-US&quot;]
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: artists, owners, tracks, videos | [optional] 

### Return type

[**UserRecommendationBlocksSingleResourceDataDocument**](UserRecommendationBlocksSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userRecommendationBlocksIdRelationshipsArtistsDelete**
```swift
    open class func userRecommendationBlocksIdRelationshipsArtistsDelete(id: String, countryCode: String? = nil, idempotencyKey: String? = nil, userRecommendationBlocksArtistsRelationshipRemoveOperationPayload: UserRecommendationBlocksArtistsRelationshipRemoveOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Delete from artists relationship (\"to-many\").

Deletes item(s) from artists relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User recommendation blocks id. Use `me` for the authenticated user's resource
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. (optional)
let userRecommendationBlocksArtistsRelationshipRemoveOperationPayload = UserRecommendationBlocksArtistsRelationshipRemoveOperation_Payload(data: [UserRecommendationBlocksArtistsRelationshipRemoveOperation_Payload_Data(id: "id_example", type: "type_example")]) // UserRecommendationBlocksArtistsRelationshipRemoveOperationPayload |  (optional)

// Delete from artists relationship (\"to-many\").
UserRecommendationBlocksAPI.userRecommendationBlocksIdRelationshipsArtistsDelete(id: id, countryCode: countryCode, idempotencyKey: idempotencyKey, userRecommendationBlocksArtistsRelationshipRemoveOperationPayload: userRecommendationBlocksArtistsRelationshipRemoveOperationPayload) { (response, error) in
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
 **id** | **String** | User recommendation blocks id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. | [optional] 
 **userRecommendationBlocksArtistsRelationshipRemoveOperationPayload** | [**UserRecommendationBlocksArtistsRelationshipRemoveOperationPayload**](UserRecommendationBlocksArtistsRelationshipRemoveOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userRecommendationBlocksIdRelationshipsArtistsGet**
```swift
    open class func userRecommendationBlocksIdRelationshipsArtistsGet(id: String, pageCursor: String? = nil, countryCode: String? = nil, include: [String]? = nil, completion: @escaping (_ data: UserRecommendationBlocksArtistsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get artists relationship (\"to-many\").

Retrieves artists relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User recommendation blocks id. Use `me` for the authenticated user's resource
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: artists (optional)

// Get artists relationship (\"to-many\").
UserRecommendationBlocksAPI.userRecommendationBlocksIdRelationshipsArtistsGet(id: id, pageCursor: pageCursor, countryCode: countryCode, include: include) { (response, error) in
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
 **id** | **String** | User recommendation blocks id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: artists | [optional] 

### Return type

[**UserRecommendationBlocksArtistsMultiRelationshipDataDocument**](UserRecommendationBlocksArtistsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userRecommendationBlocksIdRelationshipsArtistsPost**
```swift
    open class func userRecommendationBlocksIdRelationshipsArtistsPost(id: String, countryCode: String? = nil, idempotencyKey: String? = nil, userRecommendationBlocksArtistsRelationshipAddOperationPayload: UserRecommendationBlocksArtistsRelationshipAddOperationPayload? = nil, completion: @escaping (_ data: UserRecommendationBlocksArtistsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Add to artists relationship (\"to-many\").

Adds item(s) to artists relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User recommendation blocks id. Use `me` for the authenticated user's resource
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. (optional)
let userRecommendationBlocksArtistsRelationshipAddOperationPayload = UserRecommendationBlocksArtistsRelationshipAddOperation_Payload(data: [UserRecommendationBlocksArtistsRelationshipAddOperation_Payload_Data(id: "id_example", type: "type_example")]) // UserRecommendationBlocksArtistsRelationshipAddOperationPayload |  (optional)

// Add to artists relationship (\"to-many\").
UserRecommendationBlocksAPI.userRecommendationBlocksIdRelationshipsArtistsPost(id: id, countryCode: countryCode, idempotencyKey: idempotencyKey, userRecommendationBlocksArtistsRelationshipAddOperationPayload: userRecommendationBlocksArtistsRelationshipAddOperationPayload) { (response, error) in
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
 **id** | **String** | User recommendation blocks id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. | [optional] 
 **userRecommendationBlocksArtistsRelationshipAddOperationPayload** | [**UserRecommendationBlocksArtistsRelationshipAddOperationPayload**](UserRecommendationBlocksArtistsRelationshipAddOperationPayload.md) |  | [optional] 

### Return type

[**UserRecommendationBlocksArtistsMultiRelationshipDataDocument**](UserRecommendationBlocksArtistsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userRecommendationBlocksIdRelationshipsOwnersGet**
```swift
    open class func userRecommendationBlocksIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: UserRecommendationBlocksMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User recommendation blocks id. Use `me` for the authenticated user's resource
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get owners relationship (\"to-many\").
UserRecommendationBlocksAPI.userRecommendationBlocksIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | User recommendation blocks id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**UserRecommendationBlocksMultiRelationshipDataDocument**](UserRecommendationBlocksMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userRecommendationBlocksIdRelationshipsTracksDelete**
```swift
    open class func userRecommendationBlocksIdRelationshipsTracksDelete(id: String, countryCode: String? = nil, idempotencyKey: String? = nil, userRecommendationBlocksTracksRelationshipRemoveOperationPayload: UserRecommendationBlocksTracksRelationshipRemoveOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Delete from tracks relationship (\"to-many\").

Deletes item(s) from tracks relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User recommendation blocks id. Use `me` for the authenticated user's resource
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. (optional)
let userRecommendationBlocksTracksRelationshipRemoveOperationPayload = UserRecommendationBlocksTracksRelationshipRemoveOperation_Payload(data: [UserRecommendationBlocksTracksRelationshipRemoveOperation_Payload_Data(id: "id_example", type: "type_example")]) // UserRecommendationBlocksTracksRelationshipRemoveOperationPayload |  (optional)

// Delete from tracks relationship (\"to-many\").
UserRecommendationBlocksAPI.userRecommendationBlocksIdRelationshipsTracksDelete(id: id, countryCode: countryCode, idempotencyKey: idempotencyKey, userRecommendationBlocksTracksRelationshipRemoveOperationPayload: userRecommendationBlocksTracksRelationshipRemoveOperationPayload) { (response, error) in
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
 **id** | **String** | User recommendation blocks id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. | [optional] 
 **userRecommendationBlocksTracksRelationshipRemoveOperationPayload** | [**UserRecommendationBlocksTracksRelationshipRemoveOperationPayload**](UserRecommendationBlocksTracksRelationshipRemoveOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userRecommendationBlocksIdRelationshipsTracksGet**
```swift
    open class func userRecommendationBlocksIdRelationshipsTracksGet(id: String, pageCursor: String? = nil, countryCode: String? = nil, include: [String]? = nil, completion: @escaping (_ data: UserRecommendationBlocksTracksMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get tracks relationship (\"to-many\").

Retrieves tracks relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User recommendation blocks id. Use `me` for the authenticated user's resource
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: tracks (optional)

// Get tracks relationship (\"to-many\").
UserRecommendationBlocksAPI.userRecommendationBlocksIdRelationshipsTracksGet(id: id, pageCursor: pageCursor, countryCode: countryCode, include: include) { (response, error) in
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
 **id** | **String** | User recommendation blocks id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: tracks | [optional] 

### Return type

[**UserRecommendationBlocksTracksMultiRelationshipDataDocument**](UserRecommendationBlocksTracksMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userRecommendationBlocksIdRelationshipsTracksPost**
```swift
    open class func userRecommendationBlocksIdRelationshipsTracksPost(id: String, countryCode: String? = nil, idempotencyKey: String? = nil, userRecommendationBlocksTracksRelationshipAddOperationPayload: UserRecommendationBlocksTracksRelationshipAddOperationPayload? = nil, completion: @escaping (_ data: UserRecommendationBlocksTracksMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Add to tracks relationship (\"to-many\").

Adds item(s) to tracks relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User recommendation blocks id. Use `me` for the authenticated user's resource
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. (optional)
let userRecommendationBlocksTracksRelationshipAddOperationPayload = UserRecommendationBlocksTracksRelationshipAddOperation_Payload(data: [UserRecommendationBlocksTracksRelationshipAddOperation_Payload_Data(id: "id_example", type: "type_example")]) // UserRecommendationBlocksTracksRelationshipAddOperationPayload |  (optional)

// Add to tracks relationship (\"to-many\").
UserRecommendationBlocksAPI.userRecommendationBlocksIdRelationshipsTracksPost(id: id, countryCode: countryCode, idempotencyKey: idempotencyKey, userRecommendationBlocksTracksRelationshipAddOperationPayload: userRecommendationBlocksTracksRelationshipAddOperationPayload) { (response, error) in
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
 **id** | **String** | User recommendation blocks id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. | [optional] 
 **userRecommendationBlocksTracksRelationshipAddOperationPayload** | [**UserRecommendationBlocksTracksRelationshipAddOperationPayload**](UserRecommendationBlocksTracksRelationshipAddOperationPayload.md) |  | [optional] 

### Return type

[**UserRecommendationBlocksTracksMultiRelationshipDataDocument**](UserRecommendationBlocksTracksMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userRecommendationBlocksIdRelationshipsVideosDelete**
```swift
    open class func userRecommendationBlocksIdRelationshipsVideosDelete(id: String, countryCode: String? = nil, idempotencyKey: String? = nil, userRecommendationBlocksVideosRelationshipRemoveOperationPayload: UserRecommendationBlocksVideosRelationshipRemoveOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Delete from videos relationship (\"to-many\").

Deletes item(s) from videos relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User recommendation blocks id. Use `me` for the authenticated user's resource
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. (optional)
let userRecommendationBlocksVideosRelationshipRemoveOperationPayload = UserRecommendationBlocksVideosRelationshipRemoveOperation_Payload(data: [UserRecommendationBlocksVideosRelationshipRemoveOperation_Payload_Data(id: "id_example", type: "type_example")]) // UserRecommendationBlocksVideosRelationshipRemoveOperationPayload |  (optional)

// Delete from videos relationship (\"to-many\").
UserRecommendationBlocksAPI.userRecommendationBlocksIdRelationshipsVideosDelete(id: id, countryCode: countryCode, idempotencyKey: idempotencyKey, userRecommendationBlocksVideosRelationshipRemoveOperationPayload: userRecommendationBlocksVideosRelationshipRemoveOperationPayload) { (response, error) in
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
 **id** | **String** | User recommendation blocks id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. | [optional] 
 **userRecommendationBlocksVideosRelationshipRemoveOperationPayload** | [**UserRecommendationBlocksVideosRelationshipRemoveOperationPayload**](UserRecommendationBlocksVideosRelationshipRemoveOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userRecommendationBlocksIdRelationshipsVideosGet**
```swift
    open class func userRecommendationBlocksIdRelationshipsVideosGet(id: String, pageCursor: String? = nil, countryCode: String? = nil, include: [String]? = nil, completion: @escaping (_ data: UserRecommendationBlocksVideosMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get videos relationship (\"to-many\").

Retrieves videos relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User recommendation blocks id. Use `me` for the authenticated user's resource
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: videos (optional)

// Get videos relationship (\"to-many\").
UserRecommendationBlocksAPI.userRecommendationBlocksIdRelationshipsVideosGet(id: id, pageCursor: pageCursor, countryCode: countryCode, include: include) { (response, error) in
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
 **id** | **String** | User recommendation blocks id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: videos | [optional] 

### Return type

[**UserRecommendationBlocksVideosMultiRelationshipDataDocument**](UserRecommendationBlocksVideosMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userRecommendationBlocksIdRelationshipsVideosPost**
```swift
    open class func userRecommendationBlocksIdRelationshipsVideosPost(id: String, countryCode: String? = nil, idempotencyKey: String? = nil, userRecommendationBlocksVideosRelationshipAddOperationPayload: UserRecommendationBlocksVideosRelationshipAddOperationPayload? = nil, completion: @escaping (_ data: UserRecommendationBlocksVideosMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Add to videos relationship (\"to-many\").

Adds item(s) to videos relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User recommendation blocks id. Use `me` for the authenticated user's resource
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. (optional)
let userRecommendationBlocksVideosRelationshipAddOperationPayload = UserRecommendationBlocksVideosRelationshipAddOperation_Payload(data: [UserRecommendationBlocksVideosRelationshipAddOperation_Payload_Data(id: "id_example", type: "type_example")]) // UserRecommendationBlocksVideosRelationshipAddOperationPayload |  (optional)

// Add to videos relationship (\"to-many\").
UserRecommendationBlocksAPI.userRecommendationBlocksIdRelationshipsVideosPost(id: id, countryCode: countryCode, idempotencyKey: idempotencyKey, userRecommendationBlocksVideosRelationshipAddOperationPayload: userRecommendationBlocksVideosRelationshipAddOperationPayload) { (response, error) in
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
 **id** | **String** | User recommendation blocks id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. | [optional] 
 **userRecommendationBlocksVideosRelationshipAddOperationPayload** | [**UserRecommendationBlocksVideosRelationshipAddOperationPayload**](UserRecommendationBlocksVideosRelationshipAddOperationPayload.md) |  | [optional] 

### Return type

[**UserRecommendationBlocksVideosMultiRelationshipDataDocument**](UserRecommendationBlocksVideosMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

