# VideosAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**videosGet**](VideosAPI.md#videosget) | **GET** /videos | Get multiple videos.
[**videosIdGet**](VideosAPI.md#videosidget) | **GET** /videos/{id} | Get single video.
[**videosIdRelationshipsAlbumsGet**](VideosAPI.md#videosidrelationshipsalbumsget) | **GET** /videos/{id}/relationships/albums | Get albums relationship (\&quot;to-many\&quot;).
[**videosIdRelationshipsArtistsGet**](VideosAPI.md#videosidrelationshipsartistsget) | **GET** /videos/{id}/relationships/artists | Get artists relationship (\&quot;to-many\&quot;).
[**videosIdRelationshipsCreditsGet**](VideosAPI.md#videosidrelationshipscreditsget) | **GET** /videos/{id}/relationships/credits | Get credits relationship (\&quot;to-many\&quot;).
[**videosIdRelationshipsProvidersGet**](VideosAPI.md#videosidrelationshipsprovidersget) | **GET** /videos/{id}/relationships/providers | Get providers relationship (\&quot;to-many\&quot;).
[**videosIdRelationshipsReplacementGet**](VideosAPI.md#videosidrelationshipsreplacementget) | **GET** /videos/{id}/relationships/replacement | Get replacement relationship (\&quot;to-one\&quot;).
[**videosIdRelationshipsSimilarVideosGet**](VideosAPI.md#videosidrelationshipssimilarvideosget) | **GET** /videos/{id}/relationships/similarVideos | Get similarVideos relationship (\&quot;to-many\&quot;).
[**videosIdRelationshipsSuggestedVideosGet**](VideosAPI.md#videosidrelationshipssuggestedvideosget) | **GET** /videos/{id}/relationships/suggestedVideos | Get suggestedVideos relationship (\&quot;to-many\&quot;).
[**videosIdRelationshipsThumbnailArtGet**](VideosAPI.md#videosidrelationshipsthumbnailartget) | **GET** /videos/{id}/relationships/thumbnailArt | Get thumbnailArt relationship (\&quot;to-many\&quot;).
[**videosIdRelationshipsUsageRulesGet**](VideosAPI.md#videosidrelationshipsusagerulesget) | **GET** /videos/{id}/relationships/usageRules | Get usageRules relationship (\&quot;to-one\&quot;).


# **videosGet**
```swift
    open class func videosGet(countryCode: String? = nil, filterId: [String]? = nil, filterIsrc: [String]? = nil, include: [String]? = nil, includeLinkage: [IncludeLinkage_videosGet]? = nil, replaceMedia: String? = nil) async throws -> VideosMultiResourceDataDocument
```

Get multiple videos.

Retrieves multiple videos by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let filterId = ["inner_example"] // [String] | List of video IDs (e.g. `75623239`) (optional)
let filterIsrc = ["inner_example"] // [String] | List of ISRCs (e.g. `QMJMT1701237`) (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: albums, artists, credits, providers, replacement, similarVideos, suggestedVideos, thumbnailArt, usageRules (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: albums (optional)

// Get multiple videos.
do {
    let response = try await VideosAPI.videosGet(countryCode: countryCode, filterId: filterId, filterIsrc: filterIsrc, include: include, includeLinkage: includeLinkage, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **filterId** | [**[String]**](String.md) | List of video IDs (e.g. &#x60;75623239&#x60;) | [optional] 
 **filterIsrc** | [**[String]**](String.md) | List of ISRCs (e.g. &#x60;QMJMT1701237&#x60;) | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: albums, artists, credits, providers, replacement, similarVideos, suggestedVideos, thumbnailArt, usageRules | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: albums | [optional] 

### Return type

[**VideosMultiResourceDataDocument**](VideosMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **videosIdGet**
```swift
    open class func videosIdGet(id: String, countryCode: String? = nil, include: [String]? = nil, includeLinkage: [IncludeLinkage_videosIdGet]? = nil, replaceMedia: String? = nil) async throws -> VideosSingleResourceDataDocument
```

Get single video.

Retrieves single video by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Video id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: albums, artists, credits, providers, replacement, similarVideos, suggestedVideos, thumbnailArt, usageRules (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: albums (optional)

// Get single video.
do {
    let response = try await VideosAPI.videosIdGet(id: id, countryCode: countryCode, include: include, includeLinkage: includeLinkage, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Video id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: albums, artists, credits, providers, replacement, similarVideos, suggestedVideos, thumbnailArt, usageRules | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: albums | [optional] 

### Return type

[**VideosSingleResourceDataDocument**](VideosSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **videosIdRelationshipsAlbumsGet**
```swift
    open class func videosIdRelationshipsAlbumsGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil) async throws -> VideosAlbumsMultiRelationshipDataDocument
```

Get albums relationship (\"to-many\").

Retrieves albums relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Video id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: albums (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: albums (optional)

// Get albums relationship (\"to-many\").
do {
    let response = try await VideosAPI.videosIdRelationshipsAlbumsGet(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Video id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: albums | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: albums | [optional] 

### Return type

[**VideosAlbumsMultiRelationshipDataDocument**](VideosAlbumsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **videosIdRelationshipsArtistsGet**
```swift
    open class func videosIdRelationshipsArtistsGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil) async throws -> VideosArtistsMultiRelationshipDataDocument
```

Get artists relationship (\"to-many\").

Retrieves artists relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Video id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: artists (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: artists.albums (optional)

// Get artists relationship (\"to-many\").
do {
    let response = try await VideosAPI.videosIdRelationshipsArtistsGet(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Video id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: artists | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: artists.albums | [optional] 

### Return type

[**VideosArtistsMultiRelationshipDataDocument**](VideosArtistsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **videosIdRelationshipsCreditsGet**
```swift
    open class func videosIdRelationshipsCreditsGet(id: String, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil) async throws -> VideosCreditsMultiRelationshipDataDocument
```

Get credits relationship (\"to-many\").

Retrieves credits relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Video id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: credits (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: credits.artist.albums (optional)

// Get credits relationship (\"to-many\").
do {
    let response = try await VideosAPI.videosIdRelationshipsCreditsGet(id: id, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Video id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: credits | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: credits.artist.albums | [optional] 

### Return type

[**VideosCreditsMultiRelationshipDataDocument**](VideosCreditsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **videosIdRelationshipsProvidersGet**
```swift
    open class func videosIdRelationshipsProvidersGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil) async throws -> VideosProvidersMultiRelationshipDataDocument
```

Get providers relationship (\"to-many\").

Retrieves providers relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Video id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: providers (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get providers relationship (\"to-many\").
do {
    let response = try await VideosAPI.videosIdRelationshipsProvidersGet(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Video id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: providers | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**VideosProvidersMultiRelationshipDataDocument**](VideosProvidersMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **videosIdRelationshipsReplacementGet**
```swift
    open class func videosIdRelationshipsReplacementGet(id: String, countryCode: String? = nil, include: [String]? = nil, replaceMedia: String? = nil) async throws -> VideosReplacementSingleRelationshipDataDocument
```

Get replacement relationship (\"to-one\").

Retrieves replacement relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Video id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: replacement (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: replacement (optional)

// Get replacement relationship (\"to-one\").
do {
    let response = try await VideosAPI.videosIdRelationshipsReplacementGet(id: id, countryCode: countryCode, include: include, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Video id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: replacement | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: replacement | [optional] 

### Return type

[**VideosReplacementSingleRelationshipDataDocument**](VideosReplacementSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **videosIdRelationshipsSimilarVideosGet**
```swift
    open class func videosIdRelationshipsSimilarVideosGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil) async throws -> VideosSimilarVideosMultiRelationshipDataDocument
```

Get similarVideos relationship (\"to-many\").

Retrieves similarVideos relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Video id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: similarVideos (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: similarVideos (optional)

// Get similarVideos relationship (\"to-many\").
do {
    let response = try await VideosAPI.videosIdRelationshipsSimilarVideosGet(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Video id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: similarVideos | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: similarVideos | [optional] 

### Return type

[**VideosSimilarVideosMultiRelationshipDataDocument**](VideosSimilarVideosMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **videosIdRelationshipsSuggestedVideosGet**
```swift
    open class func videosIdRelationshipsSuggestedVideosGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil) async throws -> VideosSuggestedVideosMultiRelationshipDataDocument
```

Get suggestedVideos relationship (\"to-many\").

Retrieves suggestedVideos relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Video id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: suggestedVideos (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: suggestedVideos (optional)

// Get suggestedVideos relationship (\"to-many\").
do {
    let response = try await VideosAPI.videosIdRelationshipsSuggestedVideosGet(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Video id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: suggestedVideos | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: suggestedVideos | [optional] 

### Return type

[**VideosSuggestedVideosMultiRelationshipDataDocument**](VideosSuggestedVideosMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **videosIdRelationshipsThumbnailArtGet**
```swift
    open class func videosIdRelationshipsThumbnailArtGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil) async throws -> VideosThumbnailArtMultiRelationshipDataDocument
```

Get thumbnailArt relationship (\"to-many\").

Retrieves thumbnailArt relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Video id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: thumbnailArt (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get thumbnailArt relationship (\"to-many\").
do {
    let response = try await VideosAPI.videosIdRelationshipsThumbnailArtGet(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Video id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: thumbnailArt | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**VideosThumbnailArtMultiRelationshipDataDocument**](VideosThumbnailArtMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **videosIdRelationshipsUsageRulesGet**
```swift
    open class func videosIdRelationshipsUsageRulesGet(id: String, countryCode: String? = nil, include: [String]? = nil) async throws -> VideosUsageRulesSingleRelationshipDataDocument
```

Get usageRules relationship (\"to-one\").

Retrieves usageRules relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Video id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: usageRules (optional)

// Get usageRules relationship (\"to-one\").
do {
    let response = try await VideosAPI.videosIdRelationshipsUsageRulesGet(id: id, countryCode: countryCode, include: include)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Video id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: usageRules | [optional] 

### Return type

[**VideosUsageRulesSingleRelationshipDataDocument**](VideosUsageRulesSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

