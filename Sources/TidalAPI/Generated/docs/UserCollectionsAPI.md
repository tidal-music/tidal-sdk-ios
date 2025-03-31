# UserCollectionsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**userCollectionsGet**](UserCollectionsAPI.md#usercollectionsget) | **GET** /userCollections | Get all userCollections
[**userCollectionsIdGet**](UserCollectionsAPI.md#usercollectionsidget) | **GET** /userCollections/{id} | Get single userCollection
[**userCollectionsIdRelationshipsAlbumsDelete**](UserCollectionsAPI.md#usercollectionsidrelationshipsalbumsdelete) | **DELETE** /userCollections/{id}/relationships/albums | Relationship: albums (remove)
[**userCollectionsIdRelationshipsAlbumsGet**](UserCollectionsAPI.md#usercollectionsidrelationshipsalbumsget) | **GET** /userCollections/{id}/relationships/albums | Relationship: albums
[**userCollectionsIdRelationshipsAlbumsPost**](UserCollectionsAPI.md#usercollectionsidrelationshipsalbumspost) | **POST** /userCollections/{id}/relationships/albums | Relationship: albums (add)
[**userCollectionsIdRelationshipsArtistsDelete**](UserCollectionsAPI.md#usercollectionsidrelationshipsartistsdelete) | **DELETE** /userCollections/{id}/relationships/artists | Relationship: artists (remove)
[**userCollectionsIdRelationshipsArtistsGet**](UserCollectionsAPI.md#usercollectionsidrelationshipsartistsget) | **GET** /userCollections/{id}/relationships/artists | Relationship: artists
[**userCollectionsIdRelationshipsArtistsPost**](UserCollectionsAPI.md#usercollectionsidrelationshipsartistspost) | **POST** /userCollections/{id}/relationships/artists | Relationship: artists (add)
[**userCollectionsIdRelationshipsPlaylistsDelete**](UserCollectionsAPI.md#usercollectionsidrelationshipsplaylistsdelete) | **DELETE** /userCollections/{id}/relationships/playlists | Relationship: playlists (remove)
[**userCollectionsIdRelationshipsPlaylistsGet**](UserCollectionsAPI.md#usercollectionsidrelationshipsplaylistsget) | **GET** /userCollections/{id}/relationships/playlists | Relationship: playlists
[**userCollectionsIdRelationshipsPlaylistsPost**](UserCollectionsAPI.md#usercollectionsidrelationshipsplaylistspost) | **POST** /userCollections/{id}/relationships/playlists | Relationship: playlists (add)
[**userCollectionsMeGet**](UserCollectionsAPI.md#usercollectionsmeget) | **GET** /userCollections/me | Get current user&#39;s userCollection data


# **userCollectionsGet**
```swift
    open class func userCollectionsGet(countryCode: String, locale: String, include: [String]? = nil, filterId: [String]? = nil, completion: @escaping (_ data: UserCollectionsMultiDataDocument?, _ error: Error?) -> Void)
```

Get all userCollections

Retrieves all userCollection details by available filters or without (if applicable).

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let locale = "locale_example" // String | BCP47 locale code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: albums, artists, playlists (optional)
let filterId = ["inner_example"] // [String] | Allows to filter the collection of resources based on id attribute value (optional)

// Get all userCollections
UserCollectionsAPI.userCollectionsGet(countryCode: countryCode, locale: locale, include: include, filterId: filterId) { (response, error) in
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
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **locale** | **String** | BCP47 locale code | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: albums, artists, playlists | [optional] 
 **filterId** | [**[String]**](String.md) | Allows to filter the collection of resources based on id attribute value | [optional] 

### Return type

[**UserCollectionsMultiDataDocument**](UserCollectionsMultiDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionsIdGet**
```swift
    open class func userCollectionsIdGet(id: String, countryCode: String, locale: String, include: [String]? = nil, completion: @escaping (_ data: UserCollectionsSingleDataDocument?, _ error: Error?) -> Void)
```

Get single userCollection

Retrieves userCollection details by an unique id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let locale = "locale_example" // String | BCP47 locale code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: albums, artists, playlists (optional)

// Get single userCollection
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
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **locale** | **String** | BCP47 locale code | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: albums, artists, playlists | [optional] 

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
    open class func userCollectionsIdRelationshipsAlbumsDelete(updateMyCollectionRelationshipPayload: UpdateMyCollectionRelationshipPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Relationship: albums (remove)

Removes items from albums relationship of the related userCollection resource.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let updateMyCollectionRelationshipPayload = UpdateMyCollectionRelationshipPayload(data: [UpdateMyCollectionRelationshipPayload_Data(id: "id_example", type: "type_example")]) // UpdateMyCollectionRelationshipPayload |  (optional)

// Relationship: albums (remove)
UserCollectionsAPI.userCollectionsIdRelationshipsAlbumsDelete(updateMyCollectionRelationshipPayload: updateMyCollectionRelationshipPayload) { (response, error) in
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
 **updateMyCollectionRelationshipPayload** | [**UpdateMyCollectionRelationshipPayload**](UpdateMyCollectionRelationshipPayload.md) |  | [optional] 

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
    open class func userCollectionsIdRelationshipsAlbumsGet(id: String, countryCode: String, locale: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: UserCollectionsMultiDataRelationshipDocument?, _ error: Error?) -> Void)
```

Relationship: albums

Retrieves albums relationship details of the related userCollection resource.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let locale = "locale_example" // String | BCP47 locale code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: albums (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Relationship: albums
UserCollectionsAPI.userCollectionsIdRelationshipsAlbumsGet(id: id, countryCode: countryCode, locale: locale, include: include, pageCursor: pageCursor) { (response, error) in
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
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **locale** | **String** | BCP47 locale code | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: albums | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**UserCollectionsMultiDataRelationshipDocument**](UserCollectionsMultiDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionsIdRelationshipsAlbumsPost**
```swift
    open class func userCollectionsIdRelationshipsAlbumsPost(countryCode: String, updateMyCollectionRelationshipPayload: UpdateMyCollectionRelationshipPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Relationship: albums (add)

Adds items to albums relationship of the related userCollection resource.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let updateMyCollectionRelationshipPayload = UpdateMyCollectionRelationshipPayload(data: [UpdateMyCollectionRelationshipPayload_Data(id: "id_example", type: "type_example")]) // UpdateMyCollectionRelationshipPayload |  (optional)

// Relationship: albums (add)
UserCollectionsAPI.userCollectionsIdRelationshipsAlbumsPost(countryCode: countryCode, updateMyCollectionRelationshipPayload: updateMyCollectionRelationshipPayload) { (response, error) in
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
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **updateMyCollectionRelationshipPayload** | [**UpdateMyCollectionRelationshipPayload**](UpdateMyCollectionRelationshipPayload.md) |  | [optional] 

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
    open class func userCollectionsIdRelationshipsArtistsDelete(updateMyCollectionRelationshipPayload: UpdateMyCollectionRelationshipPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Relationship: artists (remove)

Removes items from artists relationship of the related userCollection resource.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let updateMyCollectionRelationshipPayload = UpdateMyCollectionRelationshipPayload(data: [UpdateMyCollectionRelationshipPayload_Data(id: "id_example", type: "type_example")]) // UpdateMyCollectionRelationshipPayload |  (optional)

// Relationship: artists (remove)
UserCollectionsAPI.userCollectionsIdRelationshipsArtistsDelete(updateMyCollectionRelationshipPayload: updateMyCollectionRelationshipPayload) { (response, error) in
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
 **updateMyCollectionRelationshipPayload** | [**UpdateMyCollectionRelationshipPayload**](UpdateMyCollectionRelationshipPayload.md) |  | [optional] 

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
    open class func userCollectionsIdRelationshipsArtistsGet(id: String, countryCode: String, locale: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: UserCollectionsMultiDataRelationshipDocument?, _ error: Error?) -> Void)
```

Relationship: artists

Retrieves artists relationship details of the related userCollection resource.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let locale = "locale_example" // String | BCP47 locale code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: artists (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Relationship: artists
UserCollectionsAPI.userCollectionsIdRelationshipsArtistsGet(id: id, countryCode: countryCode, locale: locale, include: include, pageCursor: pageCursor) { (response, error) in
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
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **locale** | **String** | BCP47 locale code | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: artists | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**UserCollectionsMultiDataRelationshipDocument**](UserCollectionsMultiDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionsIdRelationshipsArtistsPost**
```swift
    open class func userCollectionsIdRelationshipsArtistsPost(countryCode: String, updateMyCollectionRelationshipPayload: UpdateMyCollectionRelationshipPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Relationship: artists (add)

Adds items to artists relationship of the related userCollection resource.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let updateMyCollectionRelationshipPayload = UpdateMyCollectionRelationshipPayload(data: [UpdateMyCollectionRelationshipPayload_Data(id: "id_example", type: "type_example")]) // UpdateMyCollectionRelationshipPayload |  (optional)

// Relationship: artists (add)
UserCollectionsAPI.userCollectionsIdRelationshipsArtistsPost(countryCode: countryCode, updateMyCollectionRelationshipPayload: updateMyCollectionRelationshipPayload) { (response, error) in
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
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **updateMyCollectionRelationshipPayload** | [**UpdateMyCollectionRelationshipPayload**](UpdateMyCollectionRelationshipPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionsIdRelationshipsPlaylistsDelete**
```swift
    open class func userCollectionsIdRelationshipsPlaylistsDelete(updateMyCollectionRelationshipPayload: UpdateMyCollectionRelationshipPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Relationship: playlists (remove)

Removes items from playlists relationship of the related userCollection resource.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let updateMyCollectionRelationshipPayload = UpdateMyCollectionRelationshipPayload(data: [UpdateMyCollectionRelationshipPayload_Data(id: "id_example", type: "type_example")]) // UpdateMyCollectionRelationshipPayload |  (optional)

// Relationship: playlists (remove)
UserCollectionsAPI.userCollectionsIdRelationshipsPlaylistsDelete(updateMyCollectionRelationshipPayload: updateMyCollectionRelationshipPayload) { (response, error) in
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
 **updateMyCollectionRelationshipPayload** | [**UpdateMyCollectionRelationshipPayload**](UpdateMyCollectionRelationshipPayload.md) |  | [optional] 

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
    open class func userCollectionsIdRelationshipsPlaylistsGet(id: String, countryCode: String, locale: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: UserCollectionsMultiDataRelationshipDocument?, _ error: Error?) -> Void)
```

Relationship: playlists

Retrieves playlists relationship details of the related userCollection resource.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let locale = "locale_example" // String | BCP47 locale code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: playlists (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Relationship: playlists
UserCollectionsAPI.userCollectionsIdRelationshipsPlaylistsGet(id: id, countryCode: countryCode, locale: locale, include: include, pageCursor: pageCursor) { (response, error) in
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
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **locale** | **String** | BCP47 locale code | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: playlists | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**UserCollectionsMultiDataRelationshipDocument**](UserCollectionsMultiDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionsIdRelationshipsPlaylistsPost**
```swift
    open class func userCollectionsIdRelationshipsPlaylistsPost(countryCode: String, updateMyCollectionRelationshipPayload: UpdateMyCollectionRelationshipPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Relationship: playlists (add)

Adds items to playlists relationship of the related userCollection resource.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let updateMyCollectionRelationshipPayload = UpdateMyCollectionRelationshipPayload(data: [UpdateMyCollectionRelationshipPayload_Data(id: "id_example", type: "type_example")]) // UpdateMyCollectionRelationshipPayload |  (optional)

// Relationship: playlists (add)
UserCollectionsAPI.userCollectionsIdRelationshipsPlaylistsPost(countryCode: countryCode, updateMyCollectionRelationshipPayload: updateMyCollectionRelationshipPayload) { (response, error) in
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
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **updateMyCollectionRelationshipPayload** | [**UpdateMyCollectionRelationshipPayload**](UpdateMyCollectionRelationshipPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionsMeGet**
```swift
    open class func userCollectionsMeGet(countryCode: String, locale: String, include: [String]? = nil, completion: @escaping (_ data: UserCollectionsSingleDataDocument?, _ error: Error?) -> Void)
```

Get current user's userCollection data

Retrieves current user's userCollection details.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let locale = "locale_example" // String | BCP47 locale code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: albums, artists, playlists (optional)

// Get current user's userCollection data
UserCollectionsAPI.userCollectionsMeGet(countryCode: countryCode, locale: locale, include: include) { (response, error) in
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
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **locale** | **String** | BCP47 locale code | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: albums, artists, playlists | [optional] 

### Return type

[**UserCollectionsSingleDataDocument**](UserCollectionsSingleDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

