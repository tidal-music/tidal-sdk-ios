# SearchResultsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**searchResultsGet**](SearchResultsAPI.md#searchresultsget) | **GET** /searchResults | Get search results by query.
[**searchResultsIdRelationshipsAlbumsGet**](SearchResultsAPI.md#searchresultsidrelationshipsalbumsget) | **GET** /searchResults/{id}/relationships/albums | Get albums relationship (\&quot;to-many\&quot;).
[**searchResultsIdRelationshipsArtistsGet**](SearchResultsAPI.md#searchresultsidrelationshipsartistsget) | **GET** /searchResults/{id}/relationships/artists | Get artists relationship (\&quot;to-many\&quot;).
[**searchResultsIdRelationshipsPlaylistsGet**](SearchResultsAPI.md#searchresultsidrelationshipsplaylistsget) | **GET** /searchResults/{id}/relationships/playlists | Get playlists relationship (\&quot;to-many\&quot;).
[**searchResultsIdRelationshipsTopHitsGet**](SearchResultsAPI.md#searchresultsidrelationshipstophitsget) | **GET** /searchResults/{id}/relationships/topHits | Get topHits relationship (\&quot;to-many\&quot;).
[**searchResultsIdRelationshipsTracksGet**](SearchResultsAPI.md#searchresultsidrelationshipstracksget) | **GET** /searchResults/{id}/relationships/tracks | Get tracks relationship (\&quot;to-many\&quot;).
[**searchResultsIdRelationshipsVideosGet**](SearchResultsAPI.md#searchresultsidrelationshipsvideosget) | **GET** /searchResults/{id}/relationships/videos | Get videos relationship (\&quot;to-many\&quot;).


# **searchResultsGet**
```swift
    open class func searchResultsGet(filterQuery: String, clientVersion: String? = nil, countryCode: String? = nil, deviceType: DeviceType_searchResultsGet? = nil, explicitFilter: ExplicitFilter_searchResultsGet? = nil, include: [String]? = nil, includeLinkage: [IncludeLinkage_searchResultsGet]? = nil, replaceMedia: String? = nil, systemType: SystemType_searchResultsGet? = nil, completion: @escaping (_ data: SearchResultsMultiResourceDataDocument?, _ error: Error?) -> Void)
```

Get search results by query.

Searches for a query and returns a collection containing exactly one search results resource.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let filterQuery = "filterQuery_example" // String | Search query (e.g. `hello`)
let clientVersion = "clientVersion_example" // String | Client version number (optional)
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let deviceType = "deviceType_example" // String | The type of device making the request (optional)
let explicitFilter = "explicitFilter_example" // String | Explicit filter. Valid values: INCLUDE or EXCLUDE (optional) (default to .include)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: albums, artists, playlists, topHits, tracks, videos (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: albums (optional)
let systemType = "systemType_example" // String | The system type of the device making the request (optional)

// Get search results by query.
SearchResultsAPI.searchResultsGet(filterQuery: filterQuery, clientVersion: clientVersion, countryCode: countryCode, deviceType: deviceType, explicitFilter: explicitFilter, include: include, includeLinkage: includeLinkage, replaceMedia: replaceMedia, systemType: systemType) { (response, error) in
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
 **filterQuery** | **String** | Search query (e.g. &#x60;hello&#x60;) | 
 **clientVersion** | **String** | Client version number | [optional] 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **deviceType** | **String** | The type of device making the request | [optional] 
 **explicitFilter** | **String** | Explicit filter. Valid values: INCLUDE or EXCLUDE | [optional] [default to .include]
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: albums, artists, playlists, topHits, tracks, videos | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: albums | [optional] 
 **systemType** | **String** | The system type of the device making the request | [optional] 

### Return type

[**SearchResultsMultiResourceDataDocument**](SearchResultsMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **searchResultsIdRelationshipsAlbumsGet**
```swift
    open class func searchResultsIdRelationshipsAlbumsGet(id: String, clientVersion: String? = nil, countryCode: String? = nil, deviceType: DeviceType_searchResultsIdRelationshipsAlbumsGet? = nil, explicitFilter: ExplicitFilter_searchResultsIdRelationshipsAlbumsGet? = nil, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil, systemType: SystemType_searchResultsIdRelationshipsAlbumsGet? = nil, completion: @escaping (_ data: SearchResultsAlbumsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get albums relationship (\"to-many\").

Retrieves albums relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | An opaque search results identifier
let clientVersion = "clientVersion_example" // String | Client version number (optional)
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let deviceType = "deviceType_example" // String | The type of device making the request (optional)
let explicitFilter = "explicitFilter_example" // String | Explicit filter. Valid values: INCLUDE or EXCLUDE (optional) (default to .include)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: albums (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: albums (optional)
let systemType = "systemType_example" // String | The system type of the device making the request (optional)

// Get albums relationship (\"to-many\").
SearchResultsAPI.searchResultsIdRelationshipsAlbumsGet(id: id, clientVersion: clientVersion, countryCode: countryCode, deviceType: deviceType, explicitFilter: explicitFilter, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia, systemType: systemType) { (response, error) in
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
 **id** | **String** | An opaque search results identifier | 
 **clientVersion** | **String** | Client version number | [optional] 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **deviceType** | **String** | The type of device making the request | [optional] 
 **explicitFilter** | **String** | Explicit filter. Valid values: INCLUDE or EXCLUDE | [optional] [default to .include]
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: albums | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: albums | [optional] 
 **systemType** | **String** | The system type of the device making the request | [optional] 

### Return type

[**SearchResultsAlbumsMultiRelationshipDataDocument**](SearchResultsAlbumsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **searchResultsIdRelationshipsArtistsGet**
```swift
    open class func searchResultsIdRelationshipsArtistsGet(id: String, clientVersion: String? = nil, countryCode: String? = nil, deviceType: DeviceType_searchResultsIdRelationshipsArtistsGet? = nil, explicitFilter: ExplicitFilter_searchResultsIdRelationshipsArtistsGet? = nil, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil, systemType: SystemType_searchResultsIdRelationshipsArtistsGet? = nil, completion: @escaping (_ data: SearchResultsArtistsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get artists relationship (\"to-many\").

Retrieves artists relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | An opaque search results identifier
let clientVersion = "clientVersion_example" // String | Client version number (optional)
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let deviceType = "deviceType_example" // String | The type of device making the request (optional)
let explicitFilter = "explicitFilter_example" // String | Explicit filter. Valid values: INCLUDE or EXCLUDE (optional) (default to .include)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: artists (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: artists.albums (optional)
let systemType = "systemType_example" // String | The system type of the device making the request (optional)

// Get artists relationship (\"to-many\").
SearchResultsAPI.searchResultsIdRelationshipsArtistsGet(id: id, clientVersion: clientVersion, countryCode: countryCode, deviceType: deviceType, explicitFilter: explicitFilter, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia, systemType: systemType) { (response, error) in
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
 **id** | **String** | An opaque search results identifier | 
 **clientVersion** | **String** | Client version number | [optional] 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **deviceType** | **String** | The type of device making the request | [optional] 
 **explicitFilter** | **String** | Explicit filter. Valid values: INCLUDE or EXCLUDE | [optional] [default to .include]
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: artists | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: artists.albums | [optional] 
 **systemType** | **String** | The system type of the device making the request | [optional] 

### Return type

[**SearchResultsArtistsMultiRelationshipDataDocument**](SearchResultsArtistsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **searchResultsIdRelationshipsPlaylistsGet**
```swift
    open class func searchResultsIdRelationshipsPlaylistsGet(id: String, clientVersion: String? = nil, countryCode: String? = nil, deviceType: DeviceType_searchResultsIdRelationshipsPlaylistsGet? = nil, explicitFilter: ExplicitFilter_searchResultsIdRelationshipsPlaylistsGet? = nil, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil, systemType: SystemType_searchResultsIdRelationshipsPlaylistsGet? = nil, completion: @escaping (_ data: SearchResultsPlaylistsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get playlists relationship (\"to-many\").

Retrieves playlists relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | An opaque search results identifier
let clientVersion = "clientVersion_example" // String | Client version number (optional)
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let deviceType = "deviceType_example" // String | The type of device making the request (optional)
let explicitFilter = "explicitFilter_example" // String | Explicit filter. Valid values: INCLUDE or EXCLUDE (optional) (default to .include)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: playlists (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: playlists.items (optional)
let systemType = "systemType_example" // String | The system type of the device making the request (optional)

// Get playlists relationship (\"to-many\").
SearchResultsAPI.searchResultsIdRelationshipsPlaylistsGet(id: id, clientVersion: clientVersion, countryCode: countryCode, deviceType: deviceType, explicitFilter: explicitFilter, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia, systemType: systemType) { (response, error) in
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
 **id** | **String** | An opaque search results identifier | 
 **clientVersion** | **String** | Client version number | [optional] 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **deviceType** | **String** | The type of device making the request | [optional] 
 **explicitFilter** | **String** | Explicit filter. Valid values: INCLUDE or EXCLUDE | [optional] [default to .include]
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: playlists | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: playlists.items | [optional] 
 **systemType** | **String** | The system type of the device making the request | [optional] 

### Return type

[**SearchResultsPlaylistsMultiRelationshipDataDocument**](SearchResultsPlaylistsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **searchResultsIdRelationshipsTopHitsGet**
```swift
    open class func searchResultsIdRelationshipsTopHitsGet(id: String, clientVersion: String? = nil, countryCode: String? = nil, deviceType: DeviceType_searchResultsIdRelationshipsTopHitsGet? = nil, explicitFilter: ExplicitFilter_searchResultsIdRelationshipsTopHitsGet? = nil, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil, systemType: SystemType_searchResultsIdRelationshipsTopHitsGet? = nil, completion: @escaping (_ data: SearchResultsTopHitsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get topHits relationship (\"to-many\").

Retrieves topHits relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | An opaque search results identifier
let clientVersion = "clientVersion_example" // String | Client version number (optional)
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let deviceType = "deviceType_example" // String | The type of device making the request (optional)
let explicitFilter = "explicitFilter_example" // String | Explicit filter. Valid values: INCLUDE or EXCLUDE (optional) (default to .include)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: topHits (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: topHits (optional)
let systemType = "systemType_example" // String | The system type of the device making the request (optional)

// Get topHits relationship (\"to-many\").
SearchResultsAPI.searchResultsIdRelationshipsTopHitsGet(id: id, clientVersion: clientVersion, countryCode: countryCode, deviceType: deviceType, explicitFilter: explicitFilter, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia, systemType: systemType) { (response, error) in
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
 **id** | **String** | An opaque search results identifier | 
 **clientVersion** | **String** | Client version number | [optional] 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **deviceType** | **String** | The type of device making the request | [optional] 
 **explicitFilter** | **String** | Explicit filter. Valid values: INCLUDE or EXCLUDE | [optional] [default to .include]
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: topHits | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: topHits | [optional] 
 **systemType** | **String** | The system type of the device making the request | [optional] 

### Return type

[**SearchResultsTopHitsMultiRelationshipDataDocument**](SearchResultsTopHitsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **searchResultsIdRelationshipsTracksGet**
```swift
    open class func searchResultsIdRelationshipsTracksGet(id: String, clientVersion: String? = nil, countryCode: String? = nil, deviceType: DeviceType_searchResultsIdRelationshipsTracksGet? = nil, explicitFilter: ExplicitFilter_searchResultsIdRelationshipsTracksGet? = nil, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil, systemType: SystemType_searchResultsIdRelationshipsTracksGet? = nil, completion: @escaping (_ data: SearchResultsTracksMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get tracks relationship (\"to-many\").

Retrieves tracks relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | An opaque search results identifier
let clientVersion = "clientVersion_example" // String | Client version number (optional)
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let deviceType = "deviceType_example" // String | The type of device making the request (optional)
let explicitFilter = "explicitFilter_example" // String | Explicit filter. Valid values: INCLUDE or EXCLUDE (optional) (default to .include)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: tracks (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: tracks (optional)
let systemType = "systemType_example" // String | The system type of the device making the request (optional)

// Get tracks relationship (\"to-many\").
SearchResultsAPI.searchResultsIdRelationshipsTracksGet(id: id, clientVersion: clientVersion, countryCode: countryCode, deviceType: deviceType, explicitFilter: explicitFilter, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia, systemType: systemType) { (response, error) in
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
 **id** | **String** | An opaque search results identifier | 
 **clientVersion** | **String** | Client version number | [optional] 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **deviceType** | **String** | The type of device making the request | [optional] 
 **explicitFilter** | **String** | Explicit filter. Valid values: INCLUDE or EXCLUDE | [optional] [default to .include]
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: tracks | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: tracks | [optional] 
 **systemType** | **String** | The system type of the device making the request | [optional] 

### Return type

[**SearchResultsTracksMultiRelationshipDataDocument**](SearchResultsTracksMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **searchResultsIdRelationshipsVideosGet**
```swift
    open class func searchResultsIdRelationshipsVideosGet(id: String, clientVersion: String? = nil, countryCode: String? = nil, deviceType: DeviceType_searchResultsIdRelationshipsVideosGet? = nil, explicitFilter: ExplicitFilter_searchResultsIdRelationshipsVideosGet? = nil, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil, systemType: SystemType_searchResultsIdRelationshipsVideosGet? = nil, completion: @escaping (_ data: SearchResultsVideosMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get videos relationship (\"to-many\").

Retrieves videos relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | An opaque search results identifier
let clientVersion = "clientVersion_example" // String | Client version number (optional)
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let deviceType = "deviceType_example" // String | The type of device making the request (optional)
let explicitFilter = "explicitFilter_example" // String | Explicit filter. Valid values: INCLUDE or EXCLUDE (optional) (default to .include)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: videos (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: videos (optional)
let systemType = "systemType_example" // String | The system type of the device making the request (optional)

// Get videos relationship (\"to-many\").
SearchResultsAPI.searchResultsIdRelationshipsVideosGet(id: id, clientVersion: clientVersion, countryCode: countryCode, deviceType: deviceType, explicitFilter: explicitFilter, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia, systemType: systemType) { (response, error) in
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
 **id** | **String** | An opaque search results identifier | 
 **clientVersion** | **String** | Client version number | [optional] 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **deviceType** | **String** | The type of device making the request | [optional] 
 **explicitFilter** | **String** | Explicit filter. Valid values: INCLUDE or EXCLUDE | [optional] [default to .include]
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: videos | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: videos | [optional] 
 **systemType** | **String** | The system type of the device making the request | [optional] 

### Return type

[**SearchResultsVideosMultiRelationshipDataDocument**](SearchResultsVideosMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

