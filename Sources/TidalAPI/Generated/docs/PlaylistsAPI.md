# PlaylistsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**playlistsGet**](PlaylistsAPI.md#playlistsget) | **GET** /playlists | Get all playlists
[**playlistsIdDelete**](PlaylistsAPI.md#playlistsiddelete) | **DELETE** /playlists/{id} | Delete single playlist
[**playlistsIdGet**](PlaylistsAPI.md#playlistsidget) | **GET** /playlists/{id} | Get single playlist
[**playlistsIdPatch**](PlaylistsAPI.md#playlistsidpatch) | **PATCH** /playlists/{id} | Update single playlist
[**playlistsIdRelationshipsItemsGet**](PlaylistsAPI.md#playlistsidrelationshipsitemsget) | **GET** /playlists/{id}/relationships/items | Relationship: items
[**playlistsIdRelationshipsOwnersGet**](PlaylistsAPI.md#playlistsidrelationshipsownersget) | **GET** /playlists/{id}/relationships/owners | Relationship: owners
[**playlistsMeGet**](PlaylistsAPI.md#playlistsmeget) | **GET** /playlists/me | Get current user&#39;s playlist data
[**playlistsPost**](PlaylistsAPI.md#playlistspost) | **POST** /playlists | Create single playlist


# **playlistsGet**
```swift
    open class func playlistsGet(countryCode: String? = nil, include: [String]? = nil, filterId: [String]? = nil, completion: @escaping (_ data: PlaylistsMultiDataDocument?, _ error: Error?) -> Void)
```

Get all playlists

Retrieves all playlist details by available filters or without (if applicable).

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code, only required if using client credentials (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: items, owners (optional)
let filterId = ["inner_example"] // [String] | Playlist id (optional)

// Get all playlists
PlaylistsAPI.playlistsGet(countryCode: countryCode, include: include, filterId: filterId) { (response, error) in
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
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code, only required if using client credentials | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: items, owners | [optional] 
 **filterId** | [**[String]**](String.md) | Playlist id | [optional] 

### Return type

[**PlaylistsMultiDataDocument**](PlaylistsMultiDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistsIdDelete**
```swift
    open class func playlistsIdDelete(id: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Delete single playlist

Deletes the existing instance of playlist's resource.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Playlist id

// Delete single playlist
PlaylistsAPI.playlistsIdDelete(id: id) { (response, error) in
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
 **id** | **String** | Playlist id | 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistsIdGet**
```swift
    open class func playlistsIdGet(id: String, countryCode: String? = nil, include: [String]? = nil, completion: @escaping (_ data: PlaylistsSingleDataDocument?, _ error: Error?) -> Void)
```

Get single playlist

Retrieves playlist details by an unique id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Playlist id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code, only required if using client credentials (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: items, owners (optional)

// Get single playlist
PlaylistsAPI.playlistsIdGet(id: id, countryCode: countryCode, include: include) { (response, error) in
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
 **id** | **String** | Playlist id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code, only required if using client credentials | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: items, owners | [optional] 

### Return type

[**PlaylistsSingleDataDocument**](PlaylistsSingleDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistsIdPatch**
```swift
    open class func playlistsIdPatch(id: String, updatePlaylistBody: UpdatePlaylistBody? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Update single playlist

Updates the existing instance of playlist's resource.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Playlist id
let updatePlaylistBody = UpdatePlaylistBody(data: UpdatePlaylistBody_Data(id: "id_example", type: "type_example", attributes: UpdatePlaylistBody_Data_Attributes(name: "name_example", description: "description_example", privacy: "privacy_example"))) // UpdatePlaylistBody |  (optional)

// Update single playlist
PlaylistsAPI.playlistsIdPatch(id: id, updatePlaylistBody: updatePlaylistBody) { (response, error) in
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
 **id** | **String** | Playlist id | 
 **updatePlaylistBody** | [**UpdatePlaylistBody**](UpdatePlaylistBody.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistsIdRelationshipsItemsGet**
```swift
    open class func playlistsIdRelationshipsItemsGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: PlaylistsMultiDataRelationshipDocument?, _ error: Error?) -> Void)
```

Relationship: items

Retrieves items relationship details of the related playlist resource.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Playlist id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code, only required if using client credentials (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: items (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Relationship: items
PlaylistsAPI.playlistsIdRelationshipsItemsGet(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | Playlist id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code, only required if using client credentials | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: items | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**PlaylistsMultiDataRelationshipDocument**](PlaylistsMultiDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistsIdRelationshipsOwnersGet**
```swift
    open class func playlistsIdRelationshipsOwnersGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: PlaylistsMultiDataRelationshipDocument?, _ error: Error?) -> Void)
```

Relationship: owners

Retrieves owners relationship details of the related playlist resource.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Playlist id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code, only required if using client credentials (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Relationship: owners
PlaylistsAPI.playlistsIdRelationshipsOwnersGet(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | Playlist id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code, only required if using client credentials | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**PlaylistsMultiDataRelationshipDocument**](PlaylistsMultiDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistsMeGet**
```swift
    open class func playlistsMeGet(include: [String]? = nil, completion: @escaping (_ data: PlaylistsMultiDataDocument?, _ error: Error?) -> Void)
```

Get current user's playlist data

Retrieves current user's playlist details.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: items, owners (optional)

// Get current user's playlist data
PlaylistsAPI.playlistsMeGet(include: include) { (response, error) in
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
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: items, owners | [optional] 

### Return type

[**PlaylistsMultiDataDocument**](PlaylistsMultiDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistsPost**
```swift
    open class func playlistsPost(createPlaylistBody: CreatePlaylistBody? = nil, completion: @escaping (_ data: PlaylistsSingleDataDocument?, _ error: Error?) -> Void)
```

Create single playlist

Creates a new instance of playlist's resource.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let createPlaylistBody = CreatePlaylistBody(data: CreatePlaylistBody_Data(type: "type_example", attributes: CreatePlaylistBody_Data_Attributes(name: "name_example", description: "description_example", privacy: "privacy_example"))) // CreatePlaylistBody |  (optional)

// Create single playlist
PlaylistsAPI.playlistsPost(createPlaylistBody: createPlaylistBody) { (response, error) in
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
 **createPlaylistBody** | [**CreatePlaylistBody**](CreatePlaylistBody.md) |  | [optional] 

### Return type

[**PlaylistsSingleDataDocument**](PlaylistsSingleDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

