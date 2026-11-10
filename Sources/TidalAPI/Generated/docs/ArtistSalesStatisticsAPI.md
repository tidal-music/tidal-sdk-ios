# ArtistSalesStatisticsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**artistSalesStatisticsGet**](ArtistSalesStatisticsAPI.md#artistsalesstatisticsget) | **GET** /artistSalesStatistics | Get multiple artistSalesStatistics.
[**artistSalesStatisticsIdRelationshipsArtistGet**](ArtistSalesStatisticsAPI.md#artistsalesstatisticsidrelationshipsartistget) | **GET** /artistSalesStatistics/{id}/relationships/artist | Get artist relationship (\&quot;to-one\&quot;).
[**artistSalesStatisticsIdRelationshipsTopSellersGet**](ArtistSalesStatisticsAPI.md#artistsalesstatisticsidrelationshipstopsellersget) | **GET** /artistSalesStatistics/{id}/relationships/topSellers | Get topSellers relationship (\&quot;to-many\&quot;).


# **artistSalesStatisticsGet**
```swift
    open class func artistSalesStatisticsGet(filterArtistId: [String], include: [String]? = nil, includeLinkage: [IncludeLinkage_artistSalesStatisticsGet]? = nil, replaceMedia: String? = nil) async throws -> ArtistSalesStatisticsMultiResourceDataDocument
```

Get multiple artistSalesStatistics.

Retrieves multiple artistSalesStatistics by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let filterArtistId = ["inner_example"] // [String] | Artist ID. Every published range of the artist is returned (e.g. `1566`)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: artist, topSellers (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: artist.albums (optional)

// Get multiple artistSalesStatistics.
do {
    let response = try await ArtistSalesStatisticsAPI.artistSalesStatisticsGet(filterArtistId: filterArtistId, include: include, includeLinkage: includeLinkage, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **filterArtistId** | [**[String]**](String.md) | Artist ID. Every published range of the artist is returned (e.g. &#x60;1566&#x60;) | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: artist, topSellers | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: artist.albums | [optional] 

### Return type

[**ArtistSalesStatisticsMultiResourceDataDocument**](ArtistSalesStatisticsMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artistSalesStatisticsIdRelationshipsArtistGet**
```swift
    open class func artistSalesStatisticsIdRelationshipsArtistGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> ArtistSalesStatisticsArtistSingleRelationshipDataDocument
```

Get artist relationship (\"to-one\").

Retrieves artist relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist sales statistics id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: artist (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: artist.albums (optional)

// Get artist relationship (\"to-one\").
do {
    let response = try await ArtistSalesStatisticsAPI.artistSalesStatisticsIdRelationshipsArtistGet(id: id, include: include, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Artist sales statistics id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: artist | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: artist.albums | [optional] 

### Return type

[**ArtistSalesStatisticsArtistSingleRelationshipDataDocument**](ArtistSalesStatisticsArtistSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artistSalesStatisticsIdRelationshipsTopSellersGet**
```swift
    open class func artistSalesStatisticsIdRelationshipsTopSellersGet(id: String, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil) async throws -> ArtistSalesStatisticsTopSellersMultiRelationshipDataDocument
```

Get topSellers relationship (\"to-many\").

Retrieves topSellers relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist sales statistics id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: topSellers (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: topSellers (optional)

// Get topSellers relationship (\"to-many\").
do {
    let response = try await ArtistSalesStatisticsAPI.artistSalesStatisticsIdRelationshipsTopSellersGet(id: id, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Artist sales statistics id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: topSellers | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: topSellers | [optional] 

### Return type

[**ArtistSalesStatisticsTopSellersMultiRelationshipDataDocument**](ArtistSalesStatisticsTopSellersMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

