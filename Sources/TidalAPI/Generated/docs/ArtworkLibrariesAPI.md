# ArtworkLibrariesAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**artworkLibrariesGet**](ArtworkLibrariesAPI.md#artworklibrariesget) | **GET** /artworkLibraries | Get multiple artworkLibraries.
[**artworkLibrariesIdGet**](ArtworkLibrariesAPI.md#artworklibrariesidget) | **GET** /artworkLibraries/{id} | Get single artworkLibrarie.
[**artworkLibrariesIdRelationshipsArtworksGet**](ArtworkLibrariesAPI.md#artworklibrariesidrelationshipsartworksget) | **GET** /artworkLibraries/{id}/relationships/artworks | Get artworks relationship (\&quot;to-many\&quot;).
[**artworkLibrariesIdRelationshipsRandomArtworkGet**](ArtworkLibrariesAPI.md#artworklibrariesidrelationshipsrandomartworkget) | **GET** /artworkLibraries/{id}/relationships/randomArtwork | Get randomArtwork relationship (\&quot;to-one\&quot;).


# **artworkLibrariesGet**
```swift
    open class func artworkLibrariesGet(filterName: [String], include: [String]? = nil, includeLinkage: [IncludeLinkage_artworkLibrariesGet]? = nil) async throws -> ArtworkLibrariesMultiResourceDataDocument
```

Get multiple artworkLibraries.

Retrieves multiple artworkLibraries by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let filterName = ["inner_example"] // [String] | Library names (e.g. `album-defaults`)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: artworks, randomArtwork (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)

// Get multiple artworkLibraries.
do {
    let response = try await ArtworkLibrariesAPI.artworkLibrariesGet(filterName: filterName, include: include, includeLinkage: includeLinkage)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **filterName** | [**[String]**](String.md) | Library names (e.g. &#x60;album-defaults&#x60;) | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: artworks, randomArtwork | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 

### Return type

[**ArtworkLibrariesMultiResourceDataDocument**](ArtworkLibrariesMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artworkLibrariesIdGet**
```swift
    open class func artworkLibrariesIdGet(id: String, include: [String]? = nil, includeLinkage: [IncludeLinkage_artworkLibrariesIdGet]? = nil) async throws -> ArtworkLibrariesSingleResourceDataDocument
```

Get single artworkLibrarie.

Retrieves single artworkLibrarie by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artwork library ID
let include = ["inner_example"] // [String] | Include related resources. Available relationships: artworks, randomArtwork (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)

// Get single artworkLibrarie.
do {
    let response = try await ArtworkLibrariesAPI.artworkLibrariesIdGet(id: id, include: include, includeLinkage: includeLinkage)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Artwork library ID | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: artworks, randomArtwork | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 

### Return type

[**ArtworkLibrariesSingleResourceDataDocument**](ArtworkLibrariesSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artworkLibrariesIdRelationshipsArtworksGet**
```swift
    open class func artworkLibrariesIdRelationshipsArtworksGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> ArtworkLibrariesArtworksMultiRelationshipDataDocument
```

Get artworks relationship (\"to-many\").

Artworks in the library that have finished processing and are not flagged or taken down, newest first

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artwork library ID
let include = ["inner_example"] // [String] | Include related resources. Available relationships: artworks (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get artworks relationship (\"to-many\").
do {
    let response = try await ArtworkLibrariesAPI.artworkLibrariesIdRelationshipsArtworksGet(id: id, include: include, pageCursor: pageCursor)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Artwork library ID | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: artworks | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**ArtworkLibrariesArtworksMultiRelationshipDataDocument**](ArtworkLibrariesArtworksMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artworkLibrariesIdRelationshipsRandomArtworkGet**
```swift
    open class func artworkLibrariesIdRelationshipsRandomArtworkGet(id: String, include: [String]? = nil) async throws -> ArtworkLibrariesRandomArtworkSingleRelationshipDataDocument
```

Get randomArtwork relationship (\"to-one\").

A random artwork from the library, used by clients to supply a default artwork, for example for albums without cover art. Picked per request from the artworks that have finished processing and are not flagged or taken down, and not stored; empty when there are none. The same pick may be returned for as long as the response is cached

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artwork library ID
let include = ["inner_example"] // [String] | Include related resources. Available relationships: randomArtwork (optional)

// Get randomArtwork relationship (\"to-one\").
do {
    let response = try await ArtworkLibrariesAPI.artworkLibrariesIdRelationshipsRandomArtworkGet(id: id, include: include)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Artwork library ID | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: randomArtwork | [optional] 

### Return type

[**ArtworkLibrariesRandomArtworkSingleRelationshipDataDocument**](ArtworkLibrariesRandomArtworkSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

