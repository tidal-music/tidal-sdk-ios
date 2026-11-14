# StudioHomeEventTilesAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**studioHomeEventTilesIdGet**](StudioHomeEventTilesAPI.md#studiohomeeventtilesidget) | **GET** /studioHomeEventTiles/{id} | Get single studioHomeEventTile.


# **studioHomeEventTilesIdGet**
```swift
    open class func studioHomeEventTilesIdGet(id: String) async throws -> StudioHomeEventTilesSingleResourceDataDocument
```

Get single studioHomeEventTile.

Retrieves single studioHomeEventTile by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Studio Home event tile id. Use `me` for the authenticated user's resource

// Get single studioHomeEventTile.
do {
    let response = try await StudioHomeEventTilesAPI.studioHomeEventTilesIdGet(id: id)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Studio Home event tile id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 

### Return type

[**StudioHomeEventTilesSingleResourceDataDocument**](StudioHomeEventTilesSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

