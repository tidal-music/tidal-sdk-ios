# ArtistStreamsStatisticsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**artistStreamsStatisticsGet**](ArtistStreamsStatisticsAPI.md#artiststreamsstatisticsget) | **GET** /artistStreamsStatistics | Get multiple artistStreamsStatistics.
[**artistStreamsStatisticsIdRelationshipsArtistGet**](ArtistStreamsStatisticsAPI.md#artiststreamsstatisticsidrelationshipsartistget) | **GET** /artistStreamsStatistics/{id}/relationships/artist | Get artist relationship (\&quot;to-one\&quot;).
[**artistStreamsStatisticsIdRelationshipsTopTracksGet**](ArtistStreamsStatisticsAPI.md#artiststreamsstatisticsidrelationshipstoptracksget) | **GET** /artistStreamsStatistics/{id}/relationships/topTracks | Get topTracks relationship (\&quot;to-many\&quot;).


# **artistStreamsStatisticsGet**
```swift
    open class func artistStreamsStatisticsGet(filterArtistId: [String], include: [String]? = nil, includeLinkage: [IncludeLinkage_artistStreamsStatisticsGet]? = nil, replaceMedia: String? = nil, completion: @escaping (_ data: ArtistStreamsStatisticsMultiResourceDataDocument?, _ error: Error?) -> Void)
```

Get multiple artistStreamsStatistics.

Retrieves multiple artistStreamsStatistics by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let filterArtistId = ["inner_example"] // [String] | Artist ID. Every published range of the artist is returned (e.g. `1566`)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: artist, topTracks (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: artist.albums (optional)

// Get multiple artistStreamsStatistics.
ArtistStreamsStatisticsAPI.artistStreamsStatisticsGet(filterArtistId: filterArtistId, include: include, includeLinkage: includeLinkage, replaceMedia: replaceMedia) { (response, error) in
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
 **filterArtistId** | [**[String]**](String.md) | Artist ID. Every published range of the artist is returned (e.g. &#x60;1566&#x60;) | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: artist, topTracks | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: artist.albums | [optional] 

### Return type

[**ArtistStreamsStatisticsMultiResourceDataDocument**](ArtistStreamsStatisticsMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artistStreamsStatisticsIdRelationshipsArtistGet**
```swift
    open class func artistStreamsStatisticsIdRelationshipsArtistGet(id: String, include: [String]? = nil, replaceMedia: String? = nil, completion: @escaping (_ data: ArtistStreamsStatisticsArtistSingleRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get artist relationship (\"to-one\").

Retrieves artist relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist streams statistics id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: artist (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: artist.albums (optional)

// Get artist relationship (\"to-one\").
ArtistStreamsStatisticsAPI.artistStreamsStatisticsIdRelationshipsArtistGet(id: id, include: include, replaceMedia: replaceMedia) { (response, error) in
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
 **id** | **String** | Artist streams statistics id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: artist | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: artist.albums | [optional] 

### Return type

[**ArtistStreamsStatisticsArtistSingleRelationshipDataDocument**](ArtistStreamsStatisticsArtistSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artistStreamsStatisticsIdRelationshipsTopTracksGet**
```swift
    open class func artistStreamsStatisticsIdRelationshipsTopTracksGet(id: String, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil, completion: @escaping (_ data: ArtistStreamsStatisticsTopTracksMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get topTracks relationship (\"to-many\").

Retrieves topTracks relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist streams statistics id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: topTracks (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: topTracks (optional)

// Get topTracks relationship (\"to-many\").
ArtistStreamsStatisticsAPI.artistStreamsStatisticsIdRelationshipsTopTracksGet(id: id, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia) { (response, error) in
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
 **id** | **String** | Artist streams statistics id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: topTracks | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: topTracks | [optional] 

### Return type

[**ArtistStreamsStatisticsTopTracksMultiRelationshipDataDocument**](ArtistStreamsStatisticsTopTracksMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

