# TrackManifestsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**trackManifestsIdGet**](TrackManifestsAPI.md#trackmanifestsidget) | **GET** /trackManifests/{id} | Get single trackManifest.


# **trackManifestsIdGet**
```swift
    open class func trackManifestsIdGet(id: String, manifestType: String, formats: String, uriScheme: String, usage: String, adaptive: String, completion: @escaping (_ data: TrackManifestsSingleDataDocument?, _ error: Error?) -> Void)
```

Get single trackManifest.

Retrieves single trackManifest by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | 
let manifestType = "manifestType_example" // String | 
let formats = "formats_example" // String | 
let uriScheme = "uriScheme_example" // String | 
let usage = "usage_example" // String | 
let adaptive = "adaptive_example" // String | 

// Get single trackManifest.
TrackManifestsAPI.trackManifestsIdGet(id: id, manifestType: manifestType, formats: formats, uriScheme: uriScheme, usage: usage, adaptive: adaptive) { (response, error) in
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
 **id** | **String** |  | 
 **manifestType** | **String** |  | 
 **formats** | **String** |  | 
 **uriScheme** | **String** |  | 
 **usage** | **String** |  | 
 **adaptive** | **String** |  | 

### Return type

[**TrackManifestsSingleDataDocument**](TrackManifestsSingleDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

