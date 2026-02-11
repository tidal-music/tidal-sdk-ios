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
    open class func userCollectionsIdGet(id: String, countryCode: String? = nil, locale: String? = nil, include: [String]? = nil, completion: @escaping (_ data: UserCollectionsSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single userCollection.

Deprecated. Use the dedicated collection resources instead: userCollectionAlbums, userCollectionArtists, userCollectionTracks, userCollectionVideos, or userCollectionPlaylists.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let locale = "locale_example" // String | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. (optional) (default to "en-US")
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: albums, artists, owners, playlists, tracks, videos (optional)

// Get single userCollection.
UserCollectionsAPI.userCollectionsIdGet(id: id, countryCode: countryCode, locale: locale, include: include) { (response, error) in
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
 **id** | **String** | User collection id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **locale** | **String** | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. | [optional] [default to &quot;en-US&quot;]
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
    open class func userCollectionsIdRelationshipsAlbumsDelete(id: String, userCollectionsAlbumsRelationshipRemoveOperationPayload: UserCollectionsAlbumsRelationshipRemoveOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Delete from albums relationship (\"to-many\").

Deprecated. Use the userCollectionAlbums resource and its items relationship instead.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection id
let userCollectionsAlbumsRelationshipRemoveOperationPayload = UserCollectionsAlbumsRelationshipRemoveOperation_Payload(data: [UserCollectionsAlbumsRelationshipRemoveOperation_Payload_Data(id: "id_example", type: "type_example")]) // UserCollectionsAlbumsRelationshipRemoveOperationPayload |  (optional)

// Delete from albums relationship (\"to-many\").
UserCollectionsAPI.userCollectionsIdRelationshipsAlbumsDelete(id: id, userCollectionsAlbumsRelationshipRemoveOperationPayload: userCollectionsAlbumsRelationshipRemoveOperationPayload) { (response, error) in
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
 **id** | **String** | User collection id | 
 **userCollectionsAlbumsRelationshipRemoveOperationPayload** | [**UserCollectionsAlbumsRelationshipRemoveOperationPayload**](UserCollectionsAlbumsRelationshipRemoveOperationPayload.md) |  | [optional] 

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
    open class func userCollectionsIdRelationshipsAlbumsGet(id: String, pageCursor: String? = nil, sort: [Sort_userCollectionsIdRelationshipsAlbumsGet]? = nil, countryCode: String? = nil, locale: String? = nil, include: [String]? = nil, completion: @escaping (_ data: UserCollectionsAlbumsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get albums relationship (\"to-many\").

Deprecated. Use the userCollectionAlbums resource and its items relationship instead.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection id
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let sort = ["sort_example"] // [String] | Values prefixed with \"-\" are sorted descending; values without it are sorted ascending. (optional)
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let locale = "locale_example" // String | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. (optional) (default to "en-US")
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: albums (optional)

// Get albums relationship (\"to-many\").
UserCollectionsAPI.userCollectionsIdRelationshipsAlbumsGet(id: id, pageCursor: pageCursor, sort: sort, countryCode: countryCode, locale: locale, include: include) { (response, error) in
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
 **id** | **String** | User collection id | 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **sort** | [**[String]**](String.md) | Values prefixed with \&quot;-\&quot; are sorted descending; values without it are sorted ascending. | [optional] 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **locale** | **String** | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. | [optional] [default to &quot;en-US&quot;]
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
    open class func userCollectionsIdRelationshipsAlbumsPost(id: String, countryCode: String? = nil, userCollectionsAlbumsRelationshipAddOperationPayload: UserCollectionsAlbumsRelationshipAddOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Add to albums relationship (\"to-many\").

Deprecated. Use the userCollectionAlbums resource and its items relationship instead.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let userCollectionsAlbumsRelationshipAddOperationPayload = UserCollectionsAlbumsRelationshipAddOperation_Payload(data: [UserCollectionsAlbumsRelationshipAddOperation_Payload_Data(id: "id_example", meta: UserCollectionsAlbumsRelationshipAddOperation_Payload_Data_Meta(addedAt: Date()), type: "type_example")]) // UserCollectionsAlbumsRelationshipAddOperationPayload |  (optional)

// Add to albums relationship (\"to-many\").
UserCollectionsAPI.userCollectionsIdRelationshipsAlbumsPost(id: id, countryCode: countryCode, userCollectionsAlbumsRelationshipAddOperationPayload: userCollectionsAlbumsRelationshipAddOperationPayload) { (response, error) in
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
 **id** | **String** | User collection id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **userCollectionsAlbumsRelationshipAddOperationPayload** | [**UserCollectionsAlbumsRelationshipAddOperationPayload**](UserCollectionsAlbumsRelationshipAddOperationPayload.md) |  | [optional] 

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
    open class func userCollectionsIdRelationshipsArtistsDelete(id: String, userCollectionsArtistsRelationshipRemoveOperationPayload: UserCollectionsArtistsRelationshipRemoveOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Delete from artists relationship (\"to-many\").

Deprecated. Use the userCollectionArtists resource and its items relationship instead.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection id
let userCollectionsArtistsRelationshipRemoveOperationPayload = UserCollectionsArtistsRelationshipRemoveOperation_Payload(data: [UserCollectionsArtistsRelationshipRemoveOperation_Payload_Data(id: "id_example", type: "type_example")]) // UserCollectionsArtistsRelationshipRemoveOperationPayload |  (optional)

// Delete from artists relationship (\"to-many\").
UserCollectionsAPI.userCollectionsIdRelationshipsArtistsDelete(id: id, userCollectionsArtistsRelationshipRemoveOperationPayload: userCollectionsArtistsRelationshipRemoveOperationPayload) { (response, error) in
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
 **id** | **String** | User collection id | 
 **userCollectionsArtistsRelationshipRemoveOperationPayload** | [**UserCollectionsArtistsRelationshipRemoveOperationPayload**](UserCollectionsArtistsRelationshipRemoveOperationPayload.md) |  | [optional] 

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
    open class func userCollectionsIdRelationshipsArtistsGet(id: String, pageCursor: String? = nil, sort: [Sort_userCollectionsIdRelationshipsArtistsGet]? = nil, countryCode: String? = nil, locale: String? = nil, include: [String]? = nil, completion: @escaping (_ data: UserCollectionsArtistsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get artists relationship (\"to-many\").

Deprecated. Use the userCollectionArtists resource and its items relationship instead.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection id
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let sort = ["sort_example"] // [String] | Values prefixed with \"-\" are sorted descending; values without it are sorted ascending. (optional)
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let locale = "locale_example" // String | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. (optional) (default to "en-US")
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: artists (optional)

// Get artists relationship (\"to-many\").
UserCollectionsAPI.userCollectionsIdRelationshipsArtistsGet(id: id, pageCursor: pageCursor, sort: sort, countryCode: countryCode, locale: locale, include: include) { (response, error) in
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
 **id** | **String** | User collection id | 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **sort** | [**[String]**](String.md) | Values prefixed with \&quot;-\&quot; are sorted descending; values without it are sorted ascending. | [optional] 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **locale** | **String** | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. | [optional] [default to &quot;en-US&quot;]
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
    open class func userCollectionsIdRelationshipsArtistsPost(id: String, countryCode: String? = nil, userCollectionsArtistsRelationshipAddOperationPayload: UserCollectionsArtistsRelationshipAddOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Add to artists relationship (\"to-many\").

Deprecated. Use the userCollectionArtists resource and its items relationship instead.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let userCollectionsArtistsRelationshipAddOperationPayload = UserCollectionsArtistsRelationshipAddOperation_Payload(data: [UserCollectionsArtistsRelationshipAddOperation_Payload_Data(id: "id_example", meta: UserCollectionsArtistsRelationshipAddOperation_Payload_Data_Meta(addedAt: Date()), type: "type_example")]) // UserCollectionsArtistsRelationshipAddOperationPayload |  (optional)

// Add to artists relationship (\"to-many\").
UserCollectionsAPI.userCollectionsIdRelationshipsArtistsPost(id: id, countryCode: countryCode, userCollectionsArtistsRelationshipAddOperationPayload: userCollectionsArtistsRelationshipAddOperationPayload) { (response, error) in
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
 **id** | **String** | User collection id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **userCollectionsArtistsRelationshipAddOperationPayload** | [**UserCollectionsArtistsRelationshipAddOperationPayload**](UserCollectionsArtistsRelationshipAddOperationPayload.md) |  | [optional] 

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

let id = "id_example" // String | User collection id
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
 **id** | **String** | User collection id | 
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
    open class func userCollectionsIdRelationshipsPlaylistsDelete(id: String, userCollectionsPlaylistsRelationshipRemoveOperationPayload: UserCollectionsPlaylistsRelationshipRemoveOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Delete from playlists relationship (\"to-many\").

Deprecated. Use the userCollectionPlaylists resource and its items relationship instead.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection id
let userCollectionsPlaylistsRelationshipRemoveOperationPayload = UserCollectionsPlaylistsRelationshipRemoveOperation_Payload(data: [UserCollectionsPlaylistsRelationshipRemoveOperation_Payload_Data(id: "id_example", type: "type_example")]) // UserCollectionsPlaylistsRelationshipRemoveOperationPayload |  (optional)

// Delete from playlists relationship (\"to-many\").
UserCollectionsAPI.userCollectionsIdRelationshipsPlaylistsDelete(id: id, userCollectionsPlaylistsRelationshipRemoveOperationPayload: userCollectionsPlaylistsRelationshipRemoveOperationPayload) { (response, error) in
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
 **id** | **String** | User collection id | 
 **userCollectionsPlaylistsRelationshipRemoveOperationPayload** | [**UserCollectionsPlaylistsRelationshipRemoveOperationPayload**](UserCollectionsPlaylistsRelationshipRemoveOperationPayload.md) |  | [optional] 

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
    open class func userCollectionsIdRelationshipsPlaylistsGet(id: String, collectionView: CollectionView_userCollectionsIdRelationshipsPlaylistsGet? = nil, pageCursor: String? = nil, sort: [Sort_userCollectionsIdRelationshipsPlaylistsGet]? = nil, include: [String]? = nil, completion: @escaping (_ data: UserCollectionsPlaylistsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get playlists relationship (\"to-many\").

Deprecated. Use the userCollectionPlaylists resource and its items relationship instead.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection id
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
 **id** | **String** | User collection id | 
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
    open class func userCollectionsIdRelationshipsPlaylistsPost(id: String, userCollectionsPlaylistsRelationshipAddOperationPayload: UserCollectionsPlaylistsRelationshipAddOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Add to playlists relationship (\"to-many\").

Deprecated. Use the userCollectionPlaylists resource and its items relationship instead.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection id
let userCollectionsPlaylistsRelationshipAddOperationPayload = UserCollectionsPlaylistsRelationshipAddOperation_Payload(data: [UserCollectionsPlaylistsRelationshipAddOperation_Payload_Data(id: "id_example", type: "type_example")]) // UserCollectionsPlaylistsRelationshipAddOperationPayload |  (optional)

// Add to playlists relationship (\"to-many\").
UserCollectionsAPI.userCollectionsIdRelationshipsPlaylistsPost(id: id, userCollectionsPlaylistsRelationshipAddOperationPayload: userCollectionsPlaylistsRelationshipAddOperationPayload) { (response, error) in
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
 **id** | **String** | User collection id | 
 **userCollectionsPlaylistsRelationshipAddOperationPayload** | [**UserCollectionsPlaylistsRelationshipAddOperationPayload**](UserCollectionsPlaylistsRelationshipAddOperationPayload.md) |  | [optional] 

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
    open class func userCollectionsIdRelationshipsTracksDelete(id: String, userCollectionsTracksRelationshipRemoveOperationPayload: UserCollectionsTracksRelationshipRemoveOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Delete from tracks relationship (\"to-many\").

Deprecated. Use the userCollectionTracks resource and its items relationship instead.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection id
let userCollectionsTracksRelationshipRemoveOperationPayload = UserCollectionsTracksRelationshipRemoveOperation_Payload(data: [UserCollectionsTracksRelationshipRemoveOperation_Payload_Data(id: "id_example", type: "type_example")]) // UserCollectionsTracksRelationshipRemoveOperationPayload |  (optional)

// Delete from tracks relationship (\"to-many\").
UserCollectionsAPI.userCollectionsIdRelationshipsTracksDelete(id: id, userCollectionsTracksRelationshipRemoveOperationPayload: userCollectionsTracksRelationshipRemoveOperationPayload) { (response, error) in
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
 **id** | **String** | User collection id | 
 **userCollectionsTracksRelationshipRemoveOperationPayload** | [**UserCollectionsTracksRelationshipRemoveOperationPayload**](UserCollectionsTracksRelationshipRemoveOperationPayload.md) |  | [optional] 

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
    open class func userCollectionsIdRelationshipsTracksGet(id: String, pageCursor: String? = nil, sort: [Sort_userCollectionsIdRelationshipsTracksGet]? = nil, countryCode: String? = nil, locale: String? = nil, include: [String]? = nil, completion: @escaping (_ data: UserCollectionsTracksMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get tracks relationship (\"to-many\").

Deprecated. Use the userCollectionTracks resource and its items relationship instead.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection id
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let sort = ["sort_example"] // [String] | Values prefixed with \"-\" are sorted descending; values without it are sorted ascending. (optional)
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let locale = "locale_example" // String | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. (optional) (default to "en-US")
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: tracks (optional)

// Get tracks relationship (\"to-many\").
UserCollectionsAPI.userCollectionsIdRelationshipsTracksGet(id: id, pageCursor: pageCursor, sort: sort, countryCode: countryCode, locale: locale, include: include) { (response, error) in
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
 **id** | **String** | User collection id | 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **sort** | [**[String]**](String.md) | Values prefixed with \&quot;-\&quot; are sorted descending; values without it are sorted ascending. | [optional] 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **locale** | **String** | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. | [optional] [default to &quot;en-US&quot;]
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
    open class func userCollectionsIdRelationshipsTracksPost(id: String, countryCode: String? = nil, userCollectionsTracksRelationshipAddOperationPayload: UserCollectionsTracksRelationshipAddOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Add to tracks relationship (\"to-many\").

Deprecated. Use the userCollectionTracks resource and its items relationship instead.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let userCollectionsTracksRelationshipAddOperationPayload = UserCollectionsTracksRelationshipAddOperation_Payload(data: [UserCollectionsTracksRelationshipAddOperation_Payload_Data(id: "id_example", meta: UserCollectionsTracksRelationshipAddOperation_Payload_Data_Meta(addedAt: Date()), type: "type_example")]) // UserCollectionsTracksRelationshipAddOperationPayload |  (optional)

// Add to tracks relationship (\"to-many\").
UserCollectionsAPI.userCollectionsIdRelationshipsTracksPost(id: id, countryCode: countryCode, userCollectionsTracksRelationshipAddOperationPayload: userCollectionsTracksRelationshipAddOperationPayload) { (response, error) in
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
 **id** | **String** | User collection id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **userCollectionsTracksRelationshipAddOperationPayload** | [**UserCollectionsTracksRelationshipAddOperationPayload**](UserCollectionsTracksRelationshipAddOperationPayload.md) |  | [optional] 

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
    open class func userCollectionsIdRelationshipsVideosDelete(id: String, userCollectionsVideosRelationshipRemoveOperationPayload: UserCollectionsVideosRelationshipRemoveOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Delete from videos relationship (\"to-many\").

Deprecated. Use the userCollectionVideos resource and its items relationship instead.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection id
let userCollectionsVideosRelationshipRemoveOperationPayload = UserCollectionsVideosRelationshipRemoveOperation_Payload(data: [UserCollectionsVideosRelationshipRemoveOperation_Payload_Data(id: "id_example", type: "type_example")]) // UserCollectionsVideosRelationshipRemoveOperationPayload |  (optional)

// Delete from videos relationship (\"to-many\").
UserCollectionsAPI.userCollectionsIdRelationshipsVideosDelete(id: id, userCollectionsVideosRelationshipRemoveOperationPayload: userCollectionsVideosRelationshipRemoveOperationPayload) { (response, error) in
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
 **id** | **String** | User collection id | 
 **userCollectionsVideosRelationshipRemoveOperationPayload** | [**UserCollectionsVideosRelationshipRemoveOperationPayload**](UserCollectionsVideosRelationshipRemoveOperationPayload.md) |  | [optional] 

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
    open class func userCollectionsIdRelationshipsVideosGet(id: String, pageCursor: String? = nil, sort: [Sort_userCollectionsIdRelationshipsVideosGet]? = nil, countryCode: String? = nil, locale: String? = nil, include: [String]? = nil, completion: @escaping (_ data: UserCollectionsVideosMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get videos relationship (\"to-many\").

Deprecated. Use the userCollectionVideos resource and its items relationship instead.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection id
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let sort = ["sort_example"] // [String] | Values prefixed with \"-\" are sorted descending; values without it are sorted ascending. (optional)
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let locale = "locale_example" // String | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. (optional) (default to "en-US")
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: videos (optional)

// Get videos relationship (\"to-many\").
UserCollectionsAPI.userCollectionsIdRelationshipsVideosGet(id: id, pageCursor: pageCursor, sort: sort, countryCode: countryCode, locale: locale, include: include) { (response, error) in
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
 **id** | **String** | User collection id | 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **sort** | [**[String]**](String.md) | Values prefixed with \&quot;-\&quot; are sorted descending; values without it are sorted ascending. | [optional] 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **locale** | **String** | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. | [optional] [default to &quot;en-US&quot;]
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
    open class func userCollectionsIdRelationshipsVideosPost(id: String, countryCode: String? = nil, userCollectionsVideosRelationshipAddOperationPayload: UserCollectionsVideosRelationshipAddOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Add to videos relationship (\"to-many\").

Deprecated. Use the userCollectionVideos resource and its items relationship instead.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let userCollectionsVideosRelationshipAddOperationPayload = UserCollectionsVideosRelationshipAddOperation_Payload(data: [UserCollectionsVideosRelationshipAddOperation_Payload_Data(id: "id_example", type: "type_example")]) // UserCollectionsVideosRelationshipAddOperationPayload |  (optional)

// Add to videos relationship (\"to-many\").
UserCollectionsAPI.userCollectionsIdRelationshipsVideosPost(id: id, countryCode: countryCode, userCollectionsVideosRelationshipAddOperationPayload: userCollectionsVideosRelationshipAddOperationPayload) { (response, error) in
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
 **id** | **String** | User collection id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **userCollectionsVideosRelationshipAddOperationPayload** | [**UserCollectionsVideosRelationshipAddOperationPayload**](UserCollectionsVideosRelationshipAddOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

