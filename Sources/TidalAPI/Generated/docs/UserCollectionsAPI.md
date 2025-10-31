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
[**userCollectionsIdRelationshipsTracksDelete**](UserCollectionsAPI.md#usercollectionsidrelationshipstracksdelete) | **DELETE** /userCollections/{id}/relationships/tracks | Delete from tracks relationship (\&quot;to-many\&quot;).
[**userCollectionsIdRelationshipsTracksGet**](UserCollectionsAPI.md#usercollectionsidrelationshipstracksget) | **GET** /userCollections/{id}/relationships/tracks | Get tracks relationship (\&quot;to-many\&quot;).
[**userCollectionsIdRelationshipsTracksPost**](UserCollectionsAPI.md#usercollectionsidrelationshipstrackspost) | **POST** /userCollections/{id}/relationships/tracks | Add to tracks relationship (\&quot;to-many\&quot;).
[**userCollectionsIdRelationshipsVideosDelete**](UserCollectionsAPI.md#usercollectionsidrelationshipsvideosdelete) | **DELETE** /userCollections/{id}/relationships/videos | Delete from videos relationship (\&quot;to-many\&quot;).
[**userCollectionsIdRelationshipsVideosGet**](UserCollectionsAPI.md#usercollectionsidrelationshipsvideosget) | **GET** /userCollections/{id}/relationships/videos | Get videos relationship (\&quot;to-many\&quot;).
[**userCollectionsIdRelationshipsVideosPost**](UserCollectionsAPI.md#usercollectionsidrelationshipsvideospost) | **POST** /userCollections/{id}/relationships/videos | Add to videos relationship (\&quot;to-many\&quot;).


# **userCollectionsIdGet**
```swift
    open class func userCollectionsIdGet(id: String, locale: String, countryCode: String? = nil, include: [String]? = nil, completion: @escaping (_ data: UserCollectionsSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single userCollection.

Retrieves single userCollection by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User id
let locale = "locale_example" // String | BCP 47 locale (default to "en-US")
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: albums, artists, owners, playlists, tracks, videos (optional)

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
 **locale** | **String** | BCP 47 locale | [default to &quot;en-US&quot;]
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: albums, artists, owners, playlists, tracks, videos | [optional] 

### Return type

[**UserCollectionsSingleResourceDataDocument**](UserCollectionsSingleResourceDataDocument.md)

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
let userCollectionAlbumsRelationshipRemoveOperationPayload = UserCollectionAlbumsRelationshipRemoveOperation_Payload(data: [UserCollectionAlbumsRelationshipRemoveOperation_Payload_Data(id: "id_example", type: "type_example")]) // UserCollectionAlbumsRelationshipRemoveOperationPayload |  (optional)

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
    open class func userCollectionsIdRelationshipsAlbumsGet(id: String, locale: String, pageCursor: String? = nil, sort: [Sort_userCollectionsIdRelationshipsAlbumsGet]? = nil, countryCode: String? = nil, include: [String]? = nil, completion: @escaping (_ data: UserCollectionsAlbumsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get albums relationship (\"to-many\").

Retrieves albums relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User id
let locale = "locale_example" // String | BCP 47 locale (default to "en-US")
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let sort = ["sort_example"] // [String] | Values prefixed with \"-\" are sorted descending; values without it are sorted ascending. (optional)
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: albums (optional)

// Get albums relationship (\"to-many\").
UserCollectionsAPI.userCollectionsIdRelationshipsAlbumsGet(id: id, locale: locale, pageCursor: pageCursor, sort: sort, countryCode: countryCode, include: include) { (response, error) in
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
 **locale** | **String** | BCP 47 locale | [default to &quot;en-US&quot;]
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **sort** | [**[String]**](String.md) | Values prefixed with \&quot;-\&quot; are sorted descending; values without it are sorted ascending. | [optional] 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: albums | [optional] 

### Return type

[**UserCollectionsAlbumsMultiRelationshipDataDocument**](UserCollectionsAlbumsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionsIdRelationshipsAlbumsPost**
```swift
    open class func userCollectionsIdRelationshipsAlbumsPost(id: String, countryCode: String? = nil, userCollectionAlbumsRelationshipAddOperationPayload: UserCollectionAlbumsRelationshipAddOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Add to albums relationship (\"to-many\").

Adds item(s) to albums relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
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
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
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
let userCollectionArtistsRelationshipRemoveOperationPayload = UserCollectionArtistsRelationshipRemoveOperation_Payload(data: [UserCollectionArtistsRelationshipRemoveOperation_Payload_Data(id: "id_example", type: "type_example")]) // UserCollectionArtistsRelationshipRemoveOperationPayload |  (optional)

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
    open class func userCollectionsIdRelationshipsArtistsGet(id: String, locale: String, pageCursor: String? = nil, sort: [Sort_userCollectionsIdRelationshipsArtistsGet]? = nil, countryCode: String? = nil, include: [String]? = nil, completion: @escaping (_ data: UserCollectionsArtistsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get artists relationship (\"to-many\").

Retrieves artists relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User id
let locale = "locale_example" // String | BCP 47 locale (default to "en-US")
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let sort = ["sort_example"] // [String] | Values prefixed with \"-\" are sorted descending; values without it are sorted ascending. (optional)
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: artists (optional)

// Get artists relationship (\"to-many\").
UserCollectionsAPI.userCollectionsIdRelationshipsArtistsGet(id: id, locale: locale, pageCursor: pageCursor, sort: sort, countryCode: countryCode, include: include) { (response, error) in
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
 **locale** | **String** | BCP 47 locale | [default to &quot;en-US&quot;]
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **sort** | [**[String]**](String.md) | Values prefixed with \&quot;-\&quot; are sorted descending; values without it are sorted ascending. | [optional] 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: artists | [optional] 

### Return type

[**UserCollectionsArtistsMultiRelationshipDataDocument**](UserCollectionsArtistsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionsIdRelationshipsArtistsPost**
```swift
    open class func userCollectionsIdRelationshipsArtistsPost(id: String, countryCode: String? = nil, userCollectionArtistsRelationshipAddOperationPayload: UserCollectionArtistsRelationshipAddOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Add to artists relationship (\"to-many\").

Adds item(s) to artists relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
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
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
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
    open class func userCollectionsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: UserCollectionsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
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

[**UserCollectionsMultiRelationshipDataDocument**](UserCollectionsMultiRelationshipDataDocument.md)

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
    open class func userCollectionsIdRelationshipsPlaylistsGet(id: String, collectionView: String? = nil, pageCursor: String? = nil, sort: [Sort_userCollectionsIdRelationshipsPlaylistsGet]? = nil, include: [String]? = nil, completion: @escaping (_ data: UserCollectionsPlaylistsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get playlists relationship (\"to-many\").

Retrieves playlists relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User id
let collectionView = "collectionView_example" // String |  (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let sort = ["sort_example"] // [String] | Values prefixed with \"-\" are sorted descending; values without it are sorted ascending. (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: playlists (optional)

// Get playlists relationship (\"to-many\").
UserCollectionsAPI.userCollectionsIdRelationshipsPlaylistsGet(id: id, collectionView: collectionView, pageCursor: pageCursor, sort: sort, include: include) { (response, error) in
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
 **collectionView** | **String** |  | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **sort** | [**[String]**](String.md) | Values prefixed with \&quot;-\&quot; are sorted descending; values without it are sorted ascending. | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: playlists | [optional] 

### Return type

[**UserCollectionsPlaylistsMultiRelationshipDataDocument**](UserCollectionsPlaylistsMultiRelationshipDataDocument.md)

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

# **userCollectionsIdRelationshipsTracksDelete**
```swift
    open class func userCollectionsIdRelationshipsTracksDelete(id: String, userCollectionTracksRelationshipRemoveOperationPayload: UserCollectionTracksRelationshipRemoveOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Delete from tracks relationship (\"to-many\").

Deletes item(s) from tracks relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User id
let userCollectionTracksRelationshipRemoveOperationPayload = UserCollectionTracksRelationshipRemoveOperation_Payload(data: [UserCollectionTracksRelationshipRemoveOperation_Payload_Data(id: "id_example", type: "type_example")]) // UserCollectionTracksRelationshipRemoveOperationPayload |  (optional)

// Delete from tracks relationship (\"to-many\").
UserCollectionsAPI.userCollectionsIdRelationshipsTracksDelete(id: id, userCollectionTracksRelationshipRemoveOperationPayload: userCollectionTracksRelationshipRemoveOperationPayload) { (response, error) in
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
 **userCollectionTracksRelationshipRemoveOperationPayload** | [**UserCollectionTracksRelationshipRemoveOperationPayload**](UserCollectionTracksRelationshipRemoveOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionsIdRelationshipsTracksGet**
```swift
    open class func userCollectionsIdRelationshipsTracksGet(id: String, locale: String, pageCursor: String? = nil, sort: [Sort_userCollectionsIdRelationshipsTracksGet]? = nil, countryCode: String? = nil, include: [String]? = nil, completion: @escaping (_ data: UserCollectionsTracksMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get tracks relationship (\"to-many\").

Retrieves tracks relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User id
let locale = "locale_example" // String | BCP 47 locale (default to "en-US")
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let sort = ["sort_example"] // [String] | Values prefixed with \"-\" are sorted descending; values without it are sorted ascending. (optional)
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: tracks (optional)

// Get tracks relationship (\"to-many\").
UserCollectionsAPI.userCollectionsIdRelationshipsTracksGet(id: id, locale: locale, pageCursor: pageCursor, sort: sort, countryCode: countryCode, include: include) { (response, error) in
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
 **locale** | **String** | BCP 47 locale | [default to &quot;en-US&quot;]
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **sort** | [**[String]**](String.md) | Values prefixed with \&quot;-\&quot; are sorted descending; values without it are sorted ascending. | [optional] 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: tracks | [optional] 

### Return type

[**UserCollectionsTracksMultiRelationshipDataDocument**](UserCollectionsTracksMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionsIdRelationshipsTracksPost**
```swift
    open class func userCollectionsIdRelationshipsTracksPost(id: String, countryCode: String? = nil, userCollectionTracksRelationshipAddOperationPayload: UserCollectionTracksRelationshipAddOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Add to tracks relationship (\"to-many\").

Adds item(s) to tracks relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let userCollectionTracksRelationshipAddOperationPayload = UserCollectionTracksRelationshipAddOperation_Payload(data: [UserCollectionTracksRelationshipAddOperation_Payload_Data(id: "id_example", type: "type_example")]) // UserCollectionTracksRelationshipAddOperationPayload |  (optional)

// Add to tracks relationship (\"to-many\").
UserCollectionsAPI.userCollectionsIdRelationshipsTracksPost(id: id, countryCode: countryCode, userCollectionTracksRelationshipAddOperationPayload: userCollectionTracksRelationshipAddOperationPayload) { (response, error) in
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
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **userCollectionTracksRelationshipAddOperationPayload** | [**UserCollectionTracksRelationshipAddOperationPayload**](UserCollectionTracksRelationshipAddOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionsIdRelationshipsVideosDelete**
```swift
    open class func userCollectionsIdRelationshipsVideosDelete(id: String, userCollectionVideosRelationshipRemoveOperationPayload: UserCollectionVideosRelationshipRemoveOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Delete from videos relationship (\"to-many\").

Deletes item(s) from videos relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User id
let userCollectionVideosRelationshipRemoveOperationPayload = UserCollectionVideosRelationshipRemoveOperation_Payload(data: [UserCollectionVideosRelationshipRemoveOperation_Payload_Data(id: "id_example", type: "type_example")]) // UserCollectionVideosRelationshipRemoveOperationPayload |  (optional)

// Delete from videos relationship (\"to-many\").
UserCollectionsAPI.userCollectionsIdRelationshipsVideosDelete(id: id, userCollectionVideosRelationshipRemoveOperationPayload: userCollectionVideosRelationshipRemoveOperationPayload) { (response, error) in
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
 **userCollectionVideosRelationshipRemoveOperationPayload** | [**UserCollectionVideosRelationshipRemoveOperationPayload**](UserCollectionVideosRelationshipRemoveOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionsIdRelationshipsVideosGet**
```swift
    open class func userCollectionsIdRelationshipsVideosGet(id: String, locale: String, pageCursor: String? = nil, sort: [Sort_userCollectionsIdRelationshipsVideosGet]? = nil, countryCode: String? = nil, include: [String]? = nil, completion: @escaping (_ data: UserCollectionsVideosMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get videos relationship (\"to-many\").

Retrieves videos relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User id
let locale = "locale_example" // String | BCP 47 locale (default to "en-US")
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let sort = ["sort_example"] // [String] | Values prefixed with \"-\" are sorted descending; values without it are sorted ascending. (optional)
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: videos (optional)

// Get videos relationship (\"to-many\").
UserCollectionsAPI.userCollectionsIdRelationshipsVideosGet(id: id, locale: locale, pageCursor: pageCursor, sort: sort, countryCode: countryCode, include: include) { (response, error) in
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
 **locale** | **String** | BCP 47 locale | [default to &quot;en-US&quot;]
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **sort** | [**[String]**](String.md) | Values prefixed with \&quot;-\&quot; are sorted descending; values without it are sorted ascending. | [optional] 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: videos | [optional] 

### Return type

[**UserCollectionsVideosMultiRelationshipDataDocument**](UserCollectionsVideosMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionsIdRelationshipsVideosPost**
```swift
    open class func userCollectionsIdRelationshipsVideosPost(id: String, countryCode: String? = nil, userCollectionVideosRelationshipAddOperationPayload: UserCollectionVideosRelationshipAddOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Add to videos relationship (\"to-many\").

Adds item(s) to videos relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let userCollectionVideosRelationshipAddOperationPayload = UserCollectionVideosRelationshipAddOperation_Payload(data: [UserCollectionVideosRelationshipAddOperation_Payload_Data(id: "id_example", type: "type_example")]) // UserCollectionVideosRelationshipAddOperationPayload |  (optional)

// Add to videos relationship (\"to-many\").
UserCollectionsAPI.userCollectionsIdRelationshipsVideosPost(id: id, countryCode: countryCode, userCollectionVideosRelationshipAddOperationPayload: userCollectionVideosRelationshipAddOperationPayload) { (response, error) in
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
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **userCollectionVideosRelationshipAddOperationPayload** | [**UserCollectionVideosRelationshipAddOperationPayload**](UserCollectionVideosRelationshipAddOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

