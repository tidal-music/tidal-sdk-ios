# VideoManifestsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**videoManifestsIdGet**](VideoManifestsAPI.md#videomanifestsidget) | **GET** /videoManifests/{id} | Get single videoManifest.


# **videoManifestsIdGet**
```swift
    open class func videoManifestsIdGet(id: String, uriScheme: UriScheme_videoManifestsIdGet, usage: Usage_videoManifestsIdGet, completion: @escaping (_ data: VideoManifestsSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single videoManifest.

Retrieves single videoManifest by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Video manifest id
let uriScheme = "uriScheme_example" // String | 
let usage = "usage_example" // String | 

// Get single videoManifest.
VideoManifestsAPI.videoManifestsIdGet(id: id, uriScheme: uriScheme, usage: usage) { (response, error) in
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
 **id** | **String** | Video manifest id | 
 **uriScheme** | **String** |  | 
 **usage** | **String** |  | 

### Return type

[**VideoManifestsSingleResourceDataDocument**](VideoManifestsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

