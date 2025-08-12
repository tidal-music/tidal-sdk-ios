# SearchResultsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**searchResultsIdGet**](SearchResultsAPI.md#searchresultsidget) | **GET** /searchResults/{id} | Get single searchResult.
[**searchResultsIdRelationshipsAlbumsGet**](SearchResultsAPI.md#searchresultsidrelationshipsalbumsget) | **GET** /searchResults/{id}/relationships/albums | Get albums relationship (\&quot;to-many\&quot;).
[**searchResultsIdRelationshipsArtistsGet**](SearchResultsAPI.md#searchresultsidrelationshipsartistsget) | **GET** /searchResults/{id}/relationships/artists | Get artists relationship (\&quot;to-many\&quot;).
[**searchResultsIdRelationshipsPlaylistsGet**](SearchResultsAPI.md#searchresultsidrelationshipsplaylistsget) | **GET** /searchResults/{id}/relationships/playlists | Get playlists relationship (\&quot;to-many\&quot;).
[**searchResultsIdRelationshipsTopHitsGet**](SearchResultsAPI.md#searchresultsidrelationshipstophitsget) | **GET** /searchResults/{id}/relationships/topHits | Get topHits relationship (\&quot;to-many\&quot;).
[**searchResultsIdRelationshipsTracksGet**](SearchResultsAPI.md#searchresultsidrelationshipstracksget) | **GET** /searchResults/{id}/relationships/tracks | Get tracks relationship (\&quot;to-many\&quot;).
[**searchResultsIdRelationshipsVideosGet**](SearchResultsAPI.md#searchresultsidrelationshipsvideosget) | **GET** /searchResults/{id}/relationships/videos | Get videos relationship (\&quot;to-many\&quot;).


# **searchResultsIdGet**
```swift
    open class func searchResultsIdGet(id: String, countryCode: String, explicitFilter: String? = nil, include: [String]? = nil, completion: @escaping (_ data: SearchResultsSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single searchResult.

Retrieves single searchResult by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Search query
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let explicitFilter = "explicitFilter_example" // String | Explicit filter (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: albums, artists, playlists, topHits, tracks, videos (optional)

// Get single searchResult.
SearchResultsAPI.searchResultsIdGet(id: id, countryCode: countryCode, explicitFilter: explicitFilter, include: include) { (response, error) in
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
 **id** | **String** | Search query | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **explicitFilter** | **String** | Explicit filter | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: albums, artists, playlists, topHits, tracks, videos | [optional] 

### Return type

[**SearchResultsSingleResourceDataDocument**](SearchResultsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **searchResultsIdRelationshipsAlbumsGet**
```swift
    open class func searchResultsIdRelationshipsAlbumsGet(id: String, countryCode: String, explicitFilter: String? = nil, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: SearchResultsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get albums relationship (\"to-many\").

Retrieves albums relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Search query
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let explicitFilter = "explicitFilter_example" // String | Explicit filter (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: albums (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get albums relationship (\"to-many\").
SearchResultsAPI.searchResultsIdRelationshipsAlbumsGet(id: id, countryCode: countryCode, explicitFilter: explicitFilter, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | Search query | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **explicitFilter** | **String** | Explicit filter | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: albums | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**SearchResultsMultiRelationshipDataDocument**](SearchResultsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **searchResultsIdRelationshipsArtistsGet**
```swift
    open class func searchResultsIdRelationshipsArtistsGet(id: String, countryCode: String, explicitFilter: String? = nil, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: SearchResultsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get artists relationship (\"to-many\").

Retrieves artists relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Search query
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let explicitFilter = "explicitFilter_example" // String | Explicit filter (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: artists (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get artists relationship (\"to-many\").
SearchResultsAPI.searchResultsIdRelationshipsArtistsGet(id: id, countryCode: countryCode, explicitFilter: explicitFilter, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | Search query | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **explicitFilter** | **String** | Explicit filter | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: artists | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**SearchResultsMultiRelationshipDataDocument**](SearchResultsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **searchResultsIdRelationshipsPlaylistsGet**
```swift
    open class func searchResultsIdRelationshipsPlaylistsGet(id: String, countryCode: String, explicitFilter: String? = nil, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: SearchResultsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get playlists relationship (\"to-many\").

Retrieves playlists relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Search query
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let explicitFilter = "explicitFilter_example" // String | Explicit filter (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: playlists (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get playlists relationship (\"to-many\").
SearchResultsAPI.searchResultsIdRelationshipsPlaylistsGet(id: id, countryCode: countryCode, explicitFilter: explicitFilter, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | Search query | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **explicitFilter** | **String** | Explicit filter | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: playlists | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**SearchResultsMultiRelationshipDataDocument**](SearchResultsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **searchResultsIdRelationshipsTopHitsGet**
```swift
    open class func searchResultsIdRelationshipsTopHitsGet(id: String, countryCode: String, explicitFilter: String? = nil, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: SearchResultsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get topHits relationship (\"to-many\").

Retrieves topHits relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Search query
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let explicitFilter = "explicitFilter_example" // String | Explicit filter (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: topHits (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get topHits relationship (\"to-many\").
SearchResultsAPI.searchResultsIdRelationshipsTopHitsGet(id: id, countryCode: countryCode, explicitFilter: explicitFilter, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | Search query | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **explicitFilter** | **String** | Explicit filter | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: topHits | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**SearchResultsMultiRelationshipDataDocument**](SearchResultsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **searchResultsIdRelationshipsTracksGet**
```swift
    open class func searchResultsIdRelationshipsTracksGet(id: String, countryCode: String, explicitFilter: String? = nil, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: SearchResultsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get tracks relationship (\"to-many\").

Retrieves tracks relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Search query
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let explicitFilter = "explicitFilter_example" // String | Explicit filter (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: tracks (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get tracks relationship (\"to-many\").
SearchResultsAPI.searchResultsIdRelationshipsTracksGet(id: id, countryCode: countryCode, explicitFilter: explicitFilter, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | Search query | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **explicitFilter** | **String** | Explicit filter | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: tracks | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**SearchResultsMultiRelationshipDataDocument**](SearchResultsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **searchResultsIdRelationshipsVideosGet**
```swift
    open class func searchResultsIdRelationshipsVideosGet(id: String, countryCode: String, explicitFilter: String? = nil, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: SearchResultsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get videos relationship (\"to-many\").

Retrieves videos relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Search query
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let explicitFilter = "explicitFilter_example" // String | Explicit filter (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: videos (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get videos relationship (\"to-many\").
SearchResultsAPI.searchResultsIdRelationshipsVideosGet(id: id, countryCode: countryCode, explicitFilter: explicitFilter, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | Search query | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **explicitFilter** | **String** | Explicit filter | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: videos | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**SearchResultsMultiRelationshipDataDocument**](SearchResultsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

