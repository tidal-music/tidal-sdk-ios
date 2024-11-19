# VideosAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getVideoAlbumsRelationship**](VideosAPI.md#getvideoalbumsrelationship) | **GET** /videos/{id}/relationships/albums | Relationship: albums
[**getVideoArtistsRelationship**](VideosAPI.md#getvideoartistsrelationship) | **GET** /videos/{id}/relationships/artists | Relationship: artists
[**getVideoById**](VideosAPI.md#getvideobyid) | **GET** /videos/{id} | Get single video
[**getVideoProvidersRelationship**](VideosAPI.md#getvideoprovidersrelationship) | **GET** /videos/{id}/relationships/providers | Relationship: providers
[**getVideosByFilters**](VideosAPI.md#getvideosbyfilters) | **GET** /videos | Get multiple videos


# **getVideoAlbumsRelationship**
```swift
    open class func getVideoAlbumsRelationship(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: VideosMultiDataRelationshipDocument?, _ error: Error?) -> Void)
```

Relationship: albums

Retrieve album details of the related video.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | TIDAL video id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: albums (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Relationship: albums
VideosAPI.getVideoAlbumsRelationship(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | TIDAL video id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: albums | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**VideosMultiDataRelationshipDocument**](VideosMultiDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getVideoArtistsRelationship**
```swift
    open class func getVideoArtistsRelationship(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: VideosMultiDataRelationshipDocument?, _ error: Error?) -> Void)
```

Relationship: artists

Retrieve artist details of the related video.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | TIDAL video id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: artists (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Relationship: artists
VideosAPI.getVideoArtistsRelationship(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | TIDAL video id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: artists | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**VideosMultiDataRelationshipDocument**](VideosMultiDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getVideoById**
```swift
    open class func getVideoById(id: String, countryCode: String, include: [String]? = nil, completion: @escaping (_ data: VideosSingleDataDocument?, _ error: Error?) -> Void)
```

Get single video

Retrieve video details by TIDAL video id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | TIDAL video id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: artists, albums, providers (optional)

// Get single video
VideosAPI.getVideoById(id: id, countryCode: countryCode, include: include) { (response, error) in
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
 **id** | **String** | TIDAL video id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: artists, albums, providers | [optional] 

### Return type

[**VideosSingleDataDocument**](VideosSingleDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getVideoProvidersRelationship**
```swift
    open class func getVideoProvidersRelationship(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: VideosMultiDataRelationshipDocument?, _ error: Error?) -> Void)
```

Relationship: providers

This endpoint can be used to retrieve a list of video's related providers.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | TIDAL id of the video
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: providers (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Relationship: providers
VideosAPI.getVideoProvidersRelationship(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | TIDAL id of the video | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: providers | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**VideosMultiDataRelationshipDocument**](VideosMultiDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getVideosByFilters**
```swift
    open class func getVideosByFilters(countryCode: String, include: [String]? = nil, filterId: [String]? = nil, filterIsrc: [String]? = nil, completion: @escaping (_ data: VideosMultiDataDocument?, _ error: Error?) -> Void)
```

Get multiple videos

Retrieve multiple video details.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: artists, albums, providers (optional)
let filterId = ["inner_example"] // [String] | Allows to filter the collection of resources based on id attribute value (optional)
let filterIsrc = ["inner_example"] // [String] | Allows to filter the collection of resources based on isrc attribute value (optional)

// Get multiple videos
VideosAPI.getVideosByFilters(countryCode: countryCode, include: include, filterId: filterId, filterIsrc: filterIsrc) { (response, error) in
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
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: artists, albums, providers | [optional] 
 **filterId** | [**[String]**](String.md) | Allows to filter the collection of resources based on id attribute value | [optional] 
 **filterIsrc** | [**[String]**](String.md) | Allows to filter the collection of resources based on isrc attribute value | [optional] 

### Return type

[**VideosMultiDataDocument**](VideosMultiDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

