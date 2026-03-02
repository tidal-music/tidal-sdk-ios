# AlbumStatisticsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**albumStatisticsGet**](AlbumStatisticsAPI.md#albumstatisticsget) | **GET** /albumStatistics | Get multiple albumStatistics.
[**albumStatisticsIdGet**](AlbumStatisticsAPI.md#albumstatisticsidget) | **GET** /albumStatistics/{id} | Get single albumStatistic.
[**albumStatisticsIdRelationshipsOwnersGet**](AlbumStatisticsAPI.md#albumstatisticsidrelationshipsownersget) | **GET** /albumStatistics/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).


# **albumStatisticsGet**
```swift
    open class func albumStatisticsGet(include: [String]? = nil, filterId: [String]? = nil, completion: @escaping (_ data: AlbumStatisticsMultiResourceDataDocument?, _ error: Error?) -> Void)
```

Get multiple albumStatistics.

Retrieves multiple albumStatistics by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners (optional)
let filterId = ["inner_example"] // [String] | List of album IDs (e.g. `251380836`) (optional)

// Get multiple albumStatistics.
AlbumStatisticsAPI.albumStatisticsGet(include: include, filterId: filterId) { (response, error) in
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
 **filterId** | [**[String]**](String.md) | List of album IDs (e.g. &#x60;251380836&#x60;) | [optional] 

### Return type

[**AlbumStatisticsMultiResourceDataDocument**](AlbumStatisticsMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **albumStatisticsIdGet**
```swift
    open class func albumStatisticsIdGet(id: String, include: [String]? = nil, completion: @escaping (_ data: AlbumStatisticsSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single albumStatistic.

Retrieves single albumStatistic by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Album statistic id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners (optional)

// Get single albumStatistic.
AlbumStatisticsAPI.albumStatisticsIdGet(id: id, include: include) { (response, error) in
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
 **id** | **String** | Album statistic id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners | [optional] 

### Return type

[**AlbumStatisticsSingleResourceDataDocument**](AlbumStatisticsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **albumStatisticsIdRelationshipsOwnersGet**
```swift
    open class func albumStatisticsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: AlbumStatisticsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Album statistic id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get owners relationship (\"to-many\").
AlbumStatisticsAPI.albumStatisticsIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | Album statistic id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**AlbumStatisticsMultiRelationshipDataDocument**](AlbumStatisticsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

