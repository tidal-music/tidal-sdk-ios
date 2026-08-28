# TrackFilesAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**trackFilesIdGet**](TrackFilesAPI.md#trackfilesidget) | **GET** /trackFiles/{id} | Get single trackFile.


# **trackFilesIdGet**
```swift
    open class func trackFilesIdGet(id: String, formats: [Formats_trackFilesIdGet], usage: Usage_trackFilesIdGet, completion: @escaping (_ data: TrackFilesSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single trackFile.

Retrieves single trackFile by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Track file id
let formats = ["formats_example"] // [String] | 
let usage = "usage_example" // String | 

// Get single trackFile.
TrackFilesAPI.trackFilesIdGet(id: id, formats: formats, usage: usage) { (response, error) in
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
 **id** | **String** | Track file id | 
 **formats** | [**[String]**](String.md) |  | 
 **usage** | **String** |  | 

### Return type

[**TrackFilesSingleResourceDataDocument**](TrackFilesSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

