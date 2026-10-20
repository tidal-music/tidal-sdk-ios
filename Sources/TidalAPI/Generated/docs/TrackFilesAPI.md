# TrackFilesAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**trackFilesIdGet**](TrackFilesAPI.md#trackfilesidget) | **GET** /trackFiles/{id} | Get single trackFile.


# **trackFilesIdGet**
```swift
    open class func trackFilesIdGet(formats: [Formats_trackFilesIdGet], id: String, usage: Usage_trackFilesIdGet) async throws -> TrackFilesSingleResourceDataDocument
```

Get single trackFile.

Retrieves single trackFile by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let formats = ["formats_example"] // [String] | 
let id = "id_example" // String | Track file id
let usage = "usage_example" // String | 

// Get single trackFile.
do {
    let response = try await TrackFilesAPI.trackFilesIdGet(formats: formats, id: id, usage: usage)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formats** | [**[String]**](String.md) |  | 
 **id** | **String** | Track file id | 
 **usage** | **String** |  | 

### Return type

[**TrackFilesSingleResourceDataDocument**](TrackFilesSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

