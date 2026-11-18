# StudioHomeInsightTilesAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**studioHomeInsightTilesIdGet**](StudioHomeInsightTilesAPI.md#studiohomeinsighttilesidget) | **GET** /studioHomeInsightTiles/{id} | Get single studioHomeInsightTile.
[**studioHomeInsightTilesIdRelationshipsItemsGet**](StudioHomeInsightTilesAPI.md#studiohomeinsighttilesidrelationshipsitemsget) | **GET** /studioHomeInsightTiles/{id}/relationships/items | Get items relationship (\&quot;to-many\&quot;).


# **studioHomeInsightTilesIdGet**
```swift
    open class func studioHomeInsightTilesIdGet(id: String, include: [String]? = nil, includeLinkage: [IncludeLinkage_studioHomeInsightTilesIdGet]? = nil, replaceMedia: String? = nil) async throws -> StudioHomeInsightTilesSingleResourceDataDocument
```

Get single studioHomeInsightTile.

Retrieves single studioHomeInsightTile by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Studio Home insight tile id. Use `me` for the authenticated user's resource
let include = ["inner_example"] // [String] | Include related resources. Available relationships: items (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: items.topTracks (optional)

// Get single studioHomeInsightTile.
do {
    let response = try await StudioHomeInsightTilesAPI.studioHomeInsightTilesIdGet(id: id, include: include, includeLinkage: includeLinkage, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Studio Home insight tile id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: items | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: items.topTracks | [optional] 

### Return type

[**StudioHomeInsightTilesSingleResourceDataDocument**](StudioHomeInsightTilesSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **studioHomeInsightTilesIdRelationshipsItemsGet**
```swift
    open class func studioHomeInsightTilesIdRelationshipsItemsGet(id: String, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil) async throws -> StudioHomeInsightTilesItemsMultiRelationshipDataDocument
```

Get items relationship (\"to-many\").

The streams statistics of the user's artist over the last 28 days.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Studio Home insight tile id. Use `me` for the authenticated user's resource
let include = ["inner_example"] // [String] | Include related resources. Available relationships: items (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: items.topTracks (optional)

// Get items relationship (\"to-many\").
do {
    let response = try await StudioHomeInsightTilesAPI.studioHomeInsightTilesIdRelationshipsItemsGet(id: id, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Studio Home insight tile id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: items | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: items.topTracks | [optional] 

### Return type

[**StudioHomeInsightTilesItemsMultiRelationshipDataDocument**](StudioHomeInsightTilesItemsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

