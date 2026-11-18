# StudioHomeMusicTilesAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**studioHomeMusicTilesIdGet**](StudioHomeMusicTilesAPI.md#studiohomemusictilesidget) | **GET** /studioHomeMusicTiles/{id} | Get single studioHomeMusicTile.
[**studioHomeMusicTilesIdRelationshipsItemsGet**](StudioHomeMusicTilesAPI.md#studiohomemusictilesidrelationshipsitemsget) | **GET** /studioHomeMusicTiles/{id}/relationships/items | Get items relationship (\&quot;to-many\&quot;).


# **studioHomeMusicTilesIdGet**
```swift
    open class func studioHomeMusicTilesIdGet(id: String, include: [String]? = nil, includeLinkage: [IncludeLinkage_studioHomeMusicTilesIdGet]? = nil, replaceMedia: String? = nil) async throws -> StudioHomeMusicTilesSingleResourceDataDocument
```

Get single studioHomeMusicTile.

Retrieves single studioHomeMusicTile by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Studio Home music tile id. Use `me` for the authenticated user's resource
let include = ["inner_example"] // [String] | Include related resources. Available relationships: items (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: items (optional)

// Get single studioHomeMusicTile.
do {
    let response = try await StudioHomeMusicTilesAPI.studioHomeMusicTilesIdGet(id: id, include: include, includeLinkage: includeLinkage, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Studio Home music tile id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: items | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: items | [optional] 

### Return type

[**StudioHomeMusicTilesSingleResourceDataDocument**](StudioHomeMusicTilesSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **studioHomeMusicTilesIdRelationshipsItemsGet**
```swift
    open class func studioHomeMusicTilesIdRelationshipsItemsGet(id: String, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil) async throws -> StudioHomeMusicTilesItemsMultiRelationshipDataDocument
```

Get items relationship (\"to-many\").

The user's uploaded albums, newest first.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Studio Home music tile id. Use `me` for the authenticated user's resource
let include = ["inner_example"] // [String] | Include related resources. Available relationships: items (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: items (optional)

// Get items relationship (\"to-many\").
do {
    let response = try await StudioHomeMusicTilesAPI.studioHomeMusicTilesIdRelationshipsItemsGet(id: id, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Studio Home music tile id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: items | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: items | [optional] 

### Return type

[**StudioHomeMusicTilesItemsMultiRelationshipDataDocument**](StudioHomeMusicTilesItemsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

