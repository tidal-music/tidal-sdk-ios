# PlaylistsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getMyPlaylists**](PlaylistsAPI.md#getmyplaylists) | **GET** /playlists/me | Get current user&#39;s playlists
[**getPlaylistById**](PlaylistsAPI.md#getplaylistbyid) | **GET** /playlists/{id} | Get single playlist
[**getPlaylistItemsRelationship**](PlaylistsAPI.md#getplaylistitemsrelationship) | **GET** /playlists/{id}/relationships/items | Relationship: items
[**getPlaylistOwnersRelationship**](PlaylistsAPI.md#getplaylistownersrelationship) | **GET** /playlists/{id}/relationships/owners | Relationship: owner
[**getPlaylistsByFilters**](PlaylistsAPI.md#getplaylistsbyfilters) | **GET** /playlists | Get multiple playlists


# **getMyPlaylists**
```swift
    open class func getMyPlaylists(include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: PlaylistsMultiDataDocument?, _ error: Error?) -> Void)
```

Get current user's playlists

Get my playlists

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: items, owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get current user's playlists
PlaylistsAPI.getMyPlaylists(include: include, pageCursor: pageCursor) { (response, error) in
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
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**PlaylistsMultiDataDocument**](PlaylistsMultiDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getPlaylistById**
```swift
    open class func getPlaylistById(countryCode: String, id: String, include: [String]? = nil, completion: @escaping (_ data: PlaylistsSingleDataDocument?, _ error: Error?) -> Void)
```

Get single playlist

Get playlist by id

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let countryCode = "countryCode_example" // String | Country code (ISO 3166-1 alpha-2)
let id = "id_example" // String | TIDAL playlist id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: items, owners (optional)

// Get single playlist
PlaylistsAPI.getPlaylistById(countryCode: countryCode, id: id, include: include) { (response, error) in
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
 **countryCode** | **String** | Country code (ISO 3166-1 alpha-2) | 
 **id** | **String** | TIDAL playlist id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: items, owners | [optional] 

### Return type

[**PlaylistsSingleDataDocument**](PlaylistsSingleDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getPlaylistItemsRelationship**
```swift
    open class func getPlaylistItemsRelationship(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: PlaylistsMultiDataRelationshipDocument?, _ error: Error?) -> Void)
```

Relationship: items

Get playlist items

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | TIDAL playlist id
let countryCode = "countryCode_example" // String | Country code (ISO 3166-1 alpha-2)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: items (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Relationship: items
PlaylistsAPI.getPlaylistItemsRelationship(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | TIDAL playlist id | 
 **countryCode** | **String** | Country code (ISO 3166-1 alpha-2) | 
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

# **getPlaylistOwnersRelationship**
```swift
    open class func getPlaylistOwnersRelationship(id: String, countryCode: String, include: [String]? = nil, completion: @escaping (_ data: PlaylistsMultiDataRelationshipDocument?, _ error: Error?) -> Void)
```

Relationship: owner

Get playlist owner

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | TIDAL playlist id
let countryCode = "countryCode_example" // String | Country code (ISO 3166-1 alpha-2)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners (optional)

// Relationship: owner
PlaylistsAPI.getPlaylistOwnersRelationship(id: id, countryCode: countryCode, include: include) { (response, error) in
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
 **id** | **String** | TIDAL playlist id | 
 **countryCode** | **String** | Country code (ISO 3166-1 alpha-2) | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners | [optional] 

### Return type

[**PlaylistsMultiDataRelationshipDocument**](PlaylistsMultiDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getPlaylistsByFilters**
```swift
    open class func getPlaylistsByFilters(countryCode: String, include: [String]? = nil, filterId: [String]? = nil, completion: @escaping (_ data: PlaylistsMultiDataDocument?, _ error: Error?) -> Void)
```

Get multiple playlists

Get user playlists

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let countryCode = "countryCode_example" // String | Country code (ISO 3166-1 alpha-2)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: items, owners (optional)
let filterId = ["inner_example"] // [String] | public.usercontent.getPlaylists.ids.descr (optional)

// Get multiple playlists
PlaylistsAPI.getPlaylistsByFilters(countryCode: countryCode, include: include, filterId: filterId) { (response, error) in
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
 **countryCode** | **String** | Country code (ISO 3166-1 alpha-2) | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: items, owners | [optional] 
 **filterId** | [**[String]**](String.md) | public.usercontent.getPlaylists.ids.descr | [optional] 

### Return type

[**PlaylistsMultiDataDocument**](PlaylistsMultiDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json, */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

