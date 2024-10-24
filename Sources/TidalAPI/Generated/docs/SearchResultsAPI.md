# SearchResultsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getSearchResultsAlbumsRelationship**](SearchResultsAPI.md#getsearchresultsalbumsrelationship) | **GET** /searchresults/{query}/relationships/albums | Relationship: albums
[**getSearchResultsArtistsRelationship**](SearchResultsAPI.md#getsearchresultsartistsrelationship) | **GET** /searchresults/{query}/relationships/artists | Relationship: artists
[**getSearchResultsByQuery**](SearchResultsAPI.md#getsearchresultsbyquery) | **GET** /searchresults/{query} | Search for music metadata by a query
[**getSearchResultsPlaylistsRelationship**](SearchResultsAPI.md#getsearchresultsplaylistsrelationship) | **GET** /searchresults/{query}/relationships/playlists | Relationship: playlists
[**getSearchResultsTopHitsRelationship**](SearchResultsAPI.md#getsearchresultstophitsrelationship) | **GET** /searchresults/{query}/relationships/topHits | Relationship: topHits
[**getSearchResultsTracksRelationship**](SearchResultsAPI.md#getsearchresultstracksrelationship) | **GET** /searchresults/{query}/relationships/tracks | Relationship: tracks
[**getSearchResultsVideosRelationship**](SearchResultsAPI.md#getsearchresultsvideosrelationship) | **GET** /searchresults/{query}/relationships/videos | Relationship: videos


# **getSearchResultsAlbumsRelationship**
```swift
    open class func getSearchResultsAlbumsRelationship(query: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: AlbumsRelationshipDocument?, _ error: Error?) -> Void)
```

Relationship: albums

Search for albums by a query.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let query = "query_example" // String | Search query
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: albums (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Relationship: albums
SearchResultsAPI.getSearchResultsAlbumsRelationship(query: query, countryCode: countryCode, include: include, pageCursor: pageCursor) { (response, error) in
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
 **query** | **String** | Search query | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: albums | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**AlbumsRelationshipDocument**](AlbumsRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getSearchResultsArtistsRelationship**
```swift
    open class func getSearchResultsArtistsRelationship(query: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: ArtistsRelationshipDocument?, _ error: Error?) -> Void)
```

Relationship: artists

Search for artists by a query.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let query = "query_example" // String | Search query
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: artists (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Relationship: artists
SearchResultsAPI.getSearchResultsArtistsRelationship(query: query, countryCode: countryCode, include: include, pageCursor: pageCursor) { (response, error) in
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
 **query** | **String** | Search query | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: artists | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**ArtistsRelationshipDocument**](ArtistsRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getSearchResultsByQuery**
```swift
    open class func getSearchResultsByQuery(query: String, countryCode: String, include: [String]? = nil, completion: @escaping (_ data: SearchResultsSingleDataDocument?, _ error: Error?) -> Void)
```

Search for music metadata by a query

Search for music: albums, artists, tracks, etc.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let query = "query_example" // String | Search query
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: artists, albums, tracks, videos, playlists, topHits (optional)

// Search for music metadata by a query
SearchResultsAPI.getSearchResultsByQuery(query: query, countryCode: countryCode, include: include) { (response, error) in
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
 **query** | **String** | Search query | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: artists, albums, tracks, videos, playlists, topHits | [optional] 

### Return type

[**SearchResultsSingleDataDocument**](SearchResultsSingleDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getSearchResultsPlaylistsRelationship**
```swift
    open class func getSearchResultsPlaylistsRelationship(query: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: PlaylistsRelationshipDocument?, _ error: Error?) -> Void)
```

Relationship: playlists

Search for playlists by a query.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let query = "query_example" // String | Searh query
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: playlists (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Relationship: playlists
SearchResultsAPI.getSearchResultsPlaylistsRelationship(query: query, countryCode: countryCode, include: include, pageCursor: pageCursor) { (response, error) in
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
 **query** | **String** | Searh query | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: playlists | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**PlaylistsRelationshipDocument**](PlaylistsRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getSearchResultsTopHitsRelationship**
```swift
    open class func getSearchResultsTopHitsRelationship(query: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: SearchResultsTopHitsRelationshipDocument?, _ error: Error?) -> Void)
```

Relationship: topHits

Search for top hits by a query: artists, albums, tracks, videos.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let query = "query_example" // String | Search query
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: topHits (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Relationship: topHits
SearchResultsAPI.getSearchResultsTopHitsRelationship(query: query, countryCode: countryCode, include: include, pageCursor: pageCursor) { (response, error) in
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
 **query** | **String** | Search query | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: topHits | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**SearchResultsTopHitsRelationshipDocument**](SearchResultsTopHitsRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getSearchResultsTracksRelationship**
```swift
    open class func getSearchResultsTracksRelationship(query: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: TracksRelationshipsDocument?, _ error: Error?) -> Void)
```

Relationship: tracks

Search for tracks by a query.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let query = "query_example" // String | Search query
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: tracks (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Relationship: tracks
SearchResultsAPI.getSearchResultsTracksRelationship(query: query, countryCode: countryCode, include: include, pageCursor: pageCursor) { (response, error) in
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
 **query** | **String** | Search query | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: tracks | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**TracksRelationshipsDocument**](TracksRelationshipsDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getSearchResultsVideosRelationship**
```swift
    open class func getSearchResultsVideosRelationship(query: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: VideosRelationshipsDocument?, _ error: Error?) -> Void)
```

Relationship: videos

Search for videos by a query.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let query = "query_example" // String | Search query
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: videos (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Relationship: videos
SearchResultsAPI.getSearchResultsVideosRelationship(query: query, countryCode: countryCode, include: include, pageCursor: pageCursor) { (response, error) in
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
 **query** | **String** | Search query | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: videos | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**VideosRelationshipsDocument**](VideosRelationshipsDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

