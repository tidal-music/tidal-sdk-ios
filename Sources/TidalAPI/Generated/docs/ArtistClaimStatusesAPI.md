# ArtistClaimStatusesAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**artistClaimStatusesGet**](ArtistClaimStatusesAPI.md#artistclaimstatusesget) | **GET** /artistClaimStatuses | Get multiple artistClaimStatuses.


# **artistClaimStatusesGet**
```swift
    open class func artistClaimStatusesGet(filterId: [String]) async throws -> ArtistClaimStatusesMultiResourceDataDocument
```

Get multiple artistClaimStatuses.

Retrieves multiple artistClaimStatuses by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let filterId = ["inner_example"] // [String] | List of artist claim status IDs (e.g. `QVJUSVNUUzoxNTY2`)

// Get multiple artistClaimStatuses.
do {
    let response = try await ArtistClaimStatusesAPI.artistClaimStatusesGet(filterId: filterId)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **filterId** | [**[String]**](String.md) | List of artist claim status IDs (e.g. &#x60;QVJUSVNUUzoxNTY2&#x60;) | 

### Return type

[**ArtistClaimStatusesMultiResourceDataDocument**](ArtistClaimStatusesMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

