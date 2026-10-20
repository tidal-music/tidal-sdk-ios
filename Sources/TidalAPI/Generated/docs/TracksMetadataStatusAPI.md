# TracksMetadataStatusAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**tracksMetadataStatusIdGet**](TracksMetadataStatusAPI.md#tracksmetadatastatusidget) | **GET** /tracksMetadataStatus/{id} | Get single tracksMetadataStatu.


# **tracksMetadataStatusIdGet**
```swift
    open class func tracksMetadataStatusIdGet(id: String) async throws -> TracksMetadataStatusSingleResourceDataDocument
```

Get single tracksMetadataStatu.

Retrieves single tracksMetadataStatu by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Tracks metadata status id

// Get single tracksMetadataStatu.
do {
    let response = try await TracksMetadataStatusAPI.tracksMetadataStatusIdGet(id: id)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Tracks metadata status id | 

### Return type

[**TracksMetadataStatusSingleResourceDataDocument**](TracksMetadataStatusSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

