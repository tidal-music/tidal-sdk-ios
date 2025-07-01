# UserCollectionsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**userCollectionsIdGet**](UserCollectionsAPI.md#usercollectionsidget) | **GET** /userCollections/{id} | Get single userCollection.
[**userCollectionsIdRelationshipsAlbumsDelete**](UserCollectionsAPI.md#usercollectionsidrelationshipsalbumsdelete) | **DELETE** /userCollections/{id}/relationships/albums | Delete from albums relationship (\&quot;to-many\&quot;).
[**userCollectionsIdRelationshipsAlbumsGet**](UserCollectionsAPI.md#usercollectionsidrelationshipsalbumsget) | **GET** /userCollections/{id}/relationships/albums | Get albums relationship (\&quot;to-many\&quot;).
[**userCollectionsIdRelationshipsAlbumsPost**](UserCollectionsAPI.md#usercollectionsidrelationshipsalbumspost) | **POST** /userCollections/{id}/relationships/albums | Add to albums relationship (\&quot;to-many\&quot;).
[**userCollectionsIdRelationshipsArtistsDelete**](UserCollectionsAPI.md#usercollectionsidrelationshipsartistsdelete) | **DELETE** /userCollections/{id}/relationships/artists | Delete from artists relationship (\&quot;to-many\&quot;).
[**userCollectionsIdRelationshipsArtistsGet**](UserCollectionsAPI.md#usercollectionsidrelationshipsartistsget) | **GET** /userCollections/{id}/relationships/artists | Get artists relationship (\&quot;to-many\&quot;).
[**userCollectionsIdRelationshipsArtistsPost**](UserCollectionsAPI.md#usercollectionsidrelationshipsartistspost) | **POST** /userCollections/{id}/relationships/artists | Add to artists relationship (\&quot;to-many\&quot;).
[**userCollectionsIdRelationshipsOwnersGet**](UserCollectionsAPI.md#usercollectionsidrelationshipsownersget) | **GET** /userCollections/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
[**userCollectionsIdRelationshipsPlaylistsDelete**](UserCollectionsAPI.md#usercollectionsidrelationshipsplaylistsdelete) | **DELETE** /userCollections/{id}/relationships/playlists | Delete from playlists relationship (\&quot;to-many\&quot;).
[**userCollectionsIdRelationshipsPlaylistsGet**](UserCollectionsAPI.md#usercollectionsidrelationshipsplaylistsget) | **GET** /userCollections/{id}/relationships/playlists | Get playlists relationship (\&quot;to-many\&quot;).
[**userCollectionsIdRelationshipsPlaylistsPost**](UserCollectionsAPI.md#usercollectionsidrelationshipsplaylistspost) | **POST** /userCollections/{id}/relationships/playlists | Add to playlists relationship (\&quot;to-many\&quot;).


# **userCollectionsIdGet**
```swift
    open class func userCollectionsIdGet(id: String, locale: String, countryCode: String, include: [String]? = nil, completion: @escaping (_ data: UserCollectionsSingleDataDocument?, _ error: Error?) -> Void)
```

Get single userCollection.

Retrieves single userCollection by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User id
let locale = "locale_example" // String | BCP 47 locale
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: albums, artists, owners, playlists (optional)

// Get single userCollection.
UserCollectionsAPI.userCollectionsIdGet(id: id, locale: locale, countryCode: countryCode, include: include) { (response, error) in
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
 **locale** | **String** | BCP 47 locale | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: albums, artists, owners, playlists | [optional] 

### Return type

[**UserCollectionsSingleDataDocument**](UserCollectionsSingleDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionsIdRelationshipsAlbumsDelete**
```swift
    open class func userCollectionsIdRelationshipsAlbumsDelete(id: String, userCollectionAlbumsRelationshipRemoveOperationPayload: UserCollectionAlbumsRelationshipRemoveOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Delete from albums relationship (\"to-many\").

Deletes item(s) from albums relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User id
let userCollectionAlbumsRelationshipRemoveOperationPayload = UserCollectionAlbumsRelationshipRemoveOperation_Payload(data: [UserCollectionAlbumsRelationshipRemoveOperation_Payload_Data(id: "id_example", type: "type_example", meta: UserCollectionAlbumsRelationshipRemoveOperation_Payload_Data_Meta(itemId: "itemId_example"))]) // UserCollectionAlbumsRelationshipRemoveOperationPayload |  (optional)

// Delete from albums relationship (\"to-many\").
UserCollectionsAPI.userCollectionsIdRelationshipsAlbumsDelete(id: id, userCollectionAlbumsRelationshipRemoveOperationPayload: userCollectionAlbumsRelationshipRemoveOperationPayload) { (response, error) in
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
 **userCollectionAlbumsRelationshipRemoveOperationPayload** | [**UserCollectionAlbumsRelationshipRemoveOperationPayload**](UserCollectionAlbumsRelationshipRemoveOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionsIdRelationshipsAlbumsGet**
```swift
    open class func userCollectionsIdRelationshipsAlbumsGet(id: String, countryCode: String, locale: String, pageCursor: String? = nil, include: [String]? = nil, completion: @escaping (_ data: UserCollectionsAlbumsMultiDataRelationshipDocument?, _ error: Error?) -> Void)
```

Get albums relationship (\"to-many\").

Retrieves albums relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let locale = "locale_example" // String | BCP 47 locale
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: albums (optional)

// Get albums relationship (\"to-many\").
UserCollectionsAPI.userCollectionsIdRelationshipsAlbumsGet(id: id, countryCode: countryCode, locale: locale, pageCursor: pageCursor, include: include) { (response, error) in
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
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **locale** | **String** | BCP 47 locale | 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: albums | [optional] 

### Return type

[**UserCollectionsAlbumsMultiDataRelationshipDocument**](UserCollectionsAlbumsMultiDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionsIdRelationshipsAlbumsPost**
```swift
    open class func userCollectionsIdRelationshipsAlbumsPost(id: String, countryCode: String, userCollectionAlbumsRelationshipAddOperationPayload: UserCollectionAlbumsRelationshipAddOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Add to albums relationship (\"to-many\").

Adds item(s) to albums relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let userCollectionAlbumsRelationshipAddOperationPayload = UserCollectionAlbumsRelationshipAddOperation_Payload(data: [UserCollectionAlbumsRelationshipAddOperation_Payload_Data(id: "id_example", type: "type_example")]) // UserCollectionAlbumsRelationshipAddOperationPayload |  (optional)

// Add to albums relationship (\"to-many\").
UserCollectionsAPI.userCollectionsIdRelationshipsAlbumsPost(id: id, countryCode: countryCode, userCollectionAlbumsRelationshipAddOperationPayload: userCollectionAlbumsRelationshipAddOperationPayload) { (response, error) in
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
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **userCollectionAlbumsRelationshipAddOperationPayload** | [**UserCollectionAlbumsRelationshipAddOperationPayload**](UserCollectionAlbumsRelationshipAddOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionsIdRelationshipsArtistsDelete**
```swift
    open class func userCollectionsIdRelationshipsArtistsDelete(id: String, userCollectionArtistsRelationshipRemoveOperationPayload: UserCollectionArtistsRelationshipRemoveOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Delete from artists relationship (\"to-many\").

Deletes item(s) from artists relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User id
let userCollectionArtistsRelationshipRemoveOperationPayload = UserCollectionArtistsRelationshipRemoveOperation_Payload(data: [UserCollectionArtistsRelationshipRemoveOperation_Payload_Data(id: "id_example", type: "type_example", meta: UserCollectionArtistsRelationshipRemoveOperation_Payload_Data_Meta(itemId: "itemId_example"))]) // UserCollectionArtistsRelationshipRemoveOperationPayload |  (optional)

// Delete from artists relationship (\"to-many\").
UserCollectionsAPI.userCollectionsIdRelationshipsArtistsDelete(id: id, userCollectionArtistsRelationshipRemoveOperationPayload: userCollectionArtistsRelationshipRemoveOperationPayload) { (response, error) in
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
 **userCollectionArtistsRelationshipRemoveOperationPayload** | [**UserCollectionArtistsRelationshipRemoveOperationPayload**](UserCollectionArtistsRelationshipRemoveOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionsIdRelationshipsArtistsGet**
```swift
    open class func userCollectionsIdRelationshipsArtistsGet(id: String, countryCode: String, locale: String, pageCursor: String? = nil, include: [String]? = nil, completion: @escaping (_ data: UserCollectionsArtistsMultiDataRelationshipDocument?, _ error: Error?) -> Void)
```

Get artists relationship (\"to-many\").

Retrieves artists relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let locale = "locale_example" // String | BCP 47 locale
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: artists (optional)

// Get artists relationship (\"to-many\").
UserCollectionsAPI.userCollectionsIdRelationshipsArtistsGet(id: id, countryCode: countryCode, locale: locale, pageCursor: pageCursor, include: include) { (response, error) in
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
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **locale** | **String** | BCP 47 locale | 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: artists | [optional] 

### Return type

[**UserCollectionsArtistsMultiDataRelationshipDocument**](UserCollectionsArtistsMultiDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionsIdRelationshipsArtistsPost**
```swift
    open class func userCollectionsIdRelationshipsArtistsPost(id: String, countryCode: String, userCollectionArtistsRelationshipAddOperationPayload: UserCollectionArtistsRelationshipAddOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Add to artists relationship (\"to-many\").

Adds item(s) to artists relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let userCollectionArtistsRelationshipAddOperationPayload = UserCollectionArtistsRelationshipAddOperation_Payload(data: [UserCollectionArtistsRelationshipAddOperation_Payload_Data(id: "id_example", type: "type_example")]) // UserCollectionArtistsRelationshipAddOperationPayload |  (optional)

// Add to artists relationship (\"to-many\").
UserCollectionsAPI.userCollectionsIdRelationshipsArtistsPost(id: id, countryCode: countryCode, userCollectionArtistsRelationshipAddOperationPayload: userCollectionArtistsRelationshipAddOperationPayload) { (response, error) in
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
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **userCollectionArtistsRelationshipAddOperationPayload** | [**UserCollectionArtistsRelationshipAddOperationPayload**](UserCollectionArtistsRelationshipAddOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionsIdRelationshipsOwnersGet**
```swift
    open class func userCollectionsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: UserCollectionsMultiDataRelationshipDocument?, _ error: Error?) -> Void)
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
UserCollectionsAPI.userCollectionsIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor) { (response, error) in
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

[**UserCollectionsMultiDataRelationshipDocument**](UserCollectionsMultiDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionsIdRelationshipsPlaylistsDelete**
```swift
    open class func userCollectionsIdRelationshipsPlaylistsDelete(id: String, userCollectionPlaylistsRelationshipRemoveOperationPayload: UserCollectionPlaylistsRelationshipRemoveOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Delete from playlists relationship (\"to-many\").

Deletes item(s) from playlists relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User id
let userCollectionPlaylistsRelationshipRemoveOperationPayload = UserCollectionPlaylistsRelationshipRemoveOperation_Payload(data: [UserCollectionPlaylistsRelationshipRemoveOperation_Payload_Data(id: "id_example", type: "type_example")]) // UserCollectionPlaylistsRelationshipRemoveOperationPayload |  (optional)

// Delete from playlists relationship (\"to-many\").
UserCollectionsAPI.userCollectionsIdRelationshipsPlaylistsDelete(id: id, userCollectionPlaylistsRelationshipRemoveOperationPayload: userCollectionPlaylistsRelationshipRemoveOperationPayload) { (response, error) in
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
 **userCollectionPlaylistsRelationshipRemoveOperationPayload** | [**UserCollectionPlaylistsRelationshipRemoveOperationPayload**](UserCollectionPlaylistsRelationshipRemoveOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionsIdRelationshipsPlaylistsGet**
```swift
    open class func userCollectionsIdRelationshipsPlaylistsGet(id: String, countryCode: String, pageCursor: String? = nil, include: [String]? = nil, completion: @escaping (_ data: UserCollectionsPlaylistsMultiDataRelationshipDocument?, _ error: Error?) -> Void)
```

Get playlists relationship (\"to-many\").

Retrieves playlists relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: playlists (optional)

// Get playlists relationship (\"to-many\").
UserCollectionsAPI.userCollectionsIdRelationshipsPlaylistsGet(id: id, countryCode: countryCode, pageCursor: pageCursor, include: include) { (response, error) in
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
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: playlists | [optional] 

### Return type

[**UserCollectionsPlaylistsMultiDataRelationshipDocument**](UserCollectionsPlaylistsMultiDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionsIdRelationshipsPlaylistsPost**
```swift
    open class func userCollectionsIdRelationshipsPlaylistsPost(id: String, userCollectionPlaylistsRelationshipRemoveOperationPayload: UserCollectionPlaylistsRelationshipRemoveOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Add to playlists relationship (\"to-many\").

Adds item(s) to playlists relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User id
let userCollectionPlaylistsRelationshipRemoveOperationPayload = UserCollectionPlaylistsRelationshipRemoveOperation_Payload(data: [UserCollectionPlaylistsRelationshipRemoveOperation_Payload_Data(id: "id_example", type: "type_example")]) // UserCollectionPlaylistsRelationshipRemoveOperationPayload |  (optional)

// Add to playlists relationship (\"to-many\").
UserCollectionsAPI.userCollectionsIdRelationshipsPlaylistsPost(id: id, userCollectionPlaylistsRelationshipRemoveOperationPayload: userCollectionPlaylistsRelationshipRemoveOperationPayload) { (response, error) in
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
 **userCollectionPlaylistsRelationshipRemoveOperationPayload** | [**UserCollectionPlaylistsRelationshipRemoveOperationPayload**](UserCollectionPlaylistsRelationshipRemoveOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

