# SearchHistoryEntriesAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**searchHistoryEntriesGet**](SearchHistoryEntriesAPI.md#searchhistoryentriesget) | **GET** /searchHistoryEntries | Get multiple searchHistoryEntries.
[**searchHistoryEntriesIdDelete**](SearchHistoryEntriesAPI.md#searchhistoryentriesiddelete) | **DELETE** /searchHistoryEntries/{id} | Delete single searchHistoryEntrie.


# **searchHistoryEntriesGet**
```swift
    open class func searchHistoryEntriesGet(countryCode: String? = nil, filterId: [String]? = nil, completion: @escaping (_ data: SearchHistoryEntriesMultiResourceDataDocument?, _ error: Error?) -> Void)
```

Get multiple searchHistoryEntries.

Retrieves multiple searchHistoryEntries by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let filterId = ["inner_example"] // [String] | Opaque identifier for a search history entry (e.g. `MjcyNjg5OTAjamF5`) (optional)

// Get multiple searchHistoryEntries.
SearchHistoryEntriesAPI.searchHistoryEntriesGet(countryCode: countryCode, filterId: filterId) { (response, error) in
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
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **filterId** | [**[String]**](String.md) | Opaque identifier for a search history entry (e.g. &#x60;MjcyNjg5OTAjamF5&#x60;) | [optional] 

### Return type

[**SearchHistoryEntriesMultiResourceDataDocument**](SearchHistoryEntriesMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **searchHistoryEntriesIdDelete**
```swift
    open class func searchHistoryEntriesIdDelete(id: String, idempotencyKey: String? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Delete single searchHistoryEntrie.

Deletes existing searchHistoryEntrie.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Opaque identifier for a search history entry
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. (optional)

// Delete single searchHistoryEntrie.
SearchHistoryEntriesAPI.searchHistoryEntriesIdDelete(id: id, idempotencyKey: idempotencyKey) { (response, error) in
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
 **id** | **String** | Opaque identifier for a search history entry | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

