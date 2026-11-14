# StudioHomeMerchTilesAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**studioHomeMerchTilesIdGet**](StudioHomeMerchTilesAPI.md#studiohomemerchtilesidget) | **GET** /studioHomeMerchTiles/{id} | Get single studioHomeMerchTile.
[**studioHomeMerchTilesIdRelationshipsItemsGet**](StudioHomeMerchTilesAPI.md#studiohomemerchtilesidrelationshipsitemsget) | **GET** /studioHomeMerchTiles/{id}/relationships/items | Get items relationship (\&quot;to-many\&quot;).


# **studioHomeMerchTilesIdGet**
```swift
    open class func studioHomeMerchTilesIdGet(id: String, include: [String]? = nil, includeLinkage: [IncludeLinkage_studioHomeMerchTilesIdGet]? = nil) async throws -> StudioHomeMerchTilesSingleResourceDataDocument
```

Get single studioHomeMerchTile.

Retrieves single studioHomeMerchTile by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Studio Home merch tile id. Use `me` for the authenticated user's resource
let include = ["inner_example"] // [String] | Include related resources. Available relationships: items (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)

// Get single studioHomeMerchTile.
do {
    let response = try await StudioHomeMerchTilesAPI.studioHomeMerchTilesIdGet(id: id, include: include, includeLinkage: includeLinkage)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Studio Home merch tile id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: items | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 

### Return type

[**StudioHomeMerchTilesSingleResourceDataDocument**](StudioHomeMerchTilesSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **studioHomeMerchTilesIdRelationshipsItemsGet**
```swift
    open class func studioHomeMerchTilesIdRelationshipsItemsGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> StudioHomeMerchTilesItemsMultiRelationshipDataDocument
```

Get items relationship (\"to-many\").

The seller's catalog items, in title order; empty until the latest merch guidelines are accepted. A page can be short or empty and still have a next cursor.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Studio Home merch tile id. Use `me` for the authenticated user's resource
let include = ["inner_example"] // [String] | Include related resources. Available relationships: items (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get items relationship (\"to-many\").
do {
    let response = try await StudioHomeMerchTilesAPI.studioHomeMerchTilesIdRelationshipsItemsGet(id: id, include: include, pageCursor: pageCursor)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Studio Home merch tile id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: items | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**StudioHomeMerchTilesItemsMultiRelationshipDataDocument**](StudioHomeMerchTilesItemsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

