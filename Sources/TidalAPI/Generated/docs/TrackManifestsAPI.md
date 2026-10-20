# TrackManifestsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**trackManifestsIdGet**](TrackManifestsAPI.md#trackmanifestsidget) | **GET** /trackManifests/{id} | Get single trackManifest.


# **trackManifestsIdGet**
```swift
    open class func trackManifestsIdGet(adaptive: Bool, formats: [Formats_trackManifestsIdGet], id: String, manifestType: ManifestType_trackManifestsIdGet, uriScheme: UriScheme_trackManifestsIdGet, usage: Usage_trackManifestsIdGet, shareCode: String? = nil) async throws -> TrackManifestsSingleResourceDataDocument
```

Get single trackManifest.

Retrieves single trackManifest by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let adaptive = true // Bool | 
let formats = ["formats_example"] // [String] | 
let id = "id_example" // String | Track manifest id
let manifestType = "manifestType_example" // String | 
let uriScheme = "uriScheme_example" // String | 
let usage = "usage_example" // String | 
let shareCode = "shareCode_example" // String | Share code used as a bearer credential for the resource. (optional)

// Get single trackManifest.
do {
    let response = try await TrackManifestsAPI.trackManifestsIdGet(adaptive: adaptive, formats: formats, id: id, manifestType: manifestType, uriScheme: uriScheme, usage: usage, shareCode: shareCode)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **adaptive** | **Bool** |  | 
 **formats** | [**[String]**](String.md) |  | 
 **id** | **String** | Track manifest id | 
 **manifestType** | **String** |  | 
 **uriScheme** | **String** |  | 
 **usage** | **String** |  | 
 **shareCode** | **String** | Share code used as a bearer credential for the resource. | [optional] 

### Return type

[**TrackManifestsSingleResourceDataDocument**](TrackManifestsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

