# TracksMetadataStatusAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**tracksMetadataStatusGet**](TracksMetadataStatusAPI.md#tracksmetadatastatusget) | **GET** /tracksMetadataStatus | Get multiple tracksMetadataStatus.
[**tracksMetadataStatusIdGet**](TracksMetadataStatusAPI.md#tracksmetadatastatusidget) | **GET** /tracksMetadataStatus/{id} | Get single tracksMetadataStatu.


# **tracksMetadataStatusGet**
```swift
    open class func tracksMetadataStatusGet(filterId: [String]? = nil, completion: @escaping (_ data: TracksMetadataStatusMultiResourceDataDocument?, _ error: Error?) -> Void)
```

Get multiple tracksMetadataStatus.

Retrieves multiple tracksMetadataStatus by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let filterId = ["inner_example"] // [String] | Track id (optional)

// Get multiple tracksMetadataStatus.
TracksMetadataStatusAPI.tracksMetadataStatusGet(filterId: filterId) { (response, error) in
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
 **filterId** | [**[String]**](String.md) | Track id | [optional] 

### Return type

[**TracksMetadataStatusMultiResourceDataDocument**](TracksMetadataStatusMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tracksMetadataStatusIdGet**
```swift
    open class func tracksMetadataStatusIdGet(id: String, completion: @escaping (_ data: TracksMetadataStatusSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single tracksMetadataStatu.

Retrieves single tracksMetadataStatu by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Tracks metadata status id

// Get single tracksMetadataStatu.
TracksMetadataStatusAPI.tracksMetadataStatusIdGet(id: id) { (response, error) in
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
 **id** | **String** | Tracks metadata status id | 

### Return type

[**TracksMetadataStatusSingleResourceDataDocument**](TracksMetadataStatusSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

