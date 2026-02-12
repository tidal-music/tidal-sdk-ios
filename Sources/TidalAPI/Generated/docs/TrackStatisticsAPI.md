# TrackStatisticsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**trackStatisticsGet**](TrackStatisticsAPI.md#trackstatisticsget) | **GET** /trackStatistics | Get multiple trackStatistics.
[**trackStatisticsIdGet**](TrackStatisticsAPI.md#trackstatisticsidget) | **GET** /trackStatistics/{id} | Get single trackStatistic.
[**trackStatisticsIdRelationshipsOwnersGet**](TrackStatisticsAPI.md#trackstatisticsidrelationshipsownersget) | **GET** /trackStatistics/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).


# **trackStatisticsGet**
```swift
    open class func trackStatisticsGet(include: [String]? = nil, filterId: [String]? = nil, completion: @escaping (_ data: TrackStatisticsMultiResourceDataDocument?, _ error: Error?) -> Void)
```

Get multiple trackStatistics.

Retrieves multiple trackStatistics by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners (optional)
let filterId = ["inner_example"] // [String] | Track id (e.g. `75413016`) (optional)

// Get multiple trackStatistics.
TrackStatisticsAPI.trackStatisticsGet(include: include, filterId: filterId) { (response, error) in
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
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners | [optional] 
 **filterId** | [**[String]**](String.md) | Track id (e.g. &#x60;75413016&#x60;) | [optional] 

### Return type

[**TrackStatisticsMultiResourceDataDocument**](TrackStatisticsMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **trackStatisticsIdGet**
```swift
    open class func trackStatisticsIdGet(id: String, include: [String]? = nil, completion: @escaping (_ data: TrackStatisticsSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single trackStatistic.

Retrieves single trackStatistic by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Track statistic id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners (optional)

// Get single trackStatistic.
TrackStatisticsAPI.trackStatisticsIdGet(id: id, include: include) { (response, error) in
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
 **id** | **String** | Track statistic id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners | [optional] 

### Return type

[**TrackStatisticsSingleResourceDataDocument**](TrackStatisticsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **trackStatisticsIdRelationshipsOwnersGet**
```swift
    open class func trackStatisticsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: TrackStatisticsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Track statistic id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get owners relationship (\"to-many\").
TrackStatisticsAPI.trackStatisticsIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | Track statistic id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**TrackStatisticsMultiRelationshipDataDocument**](TrackStatisticsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

