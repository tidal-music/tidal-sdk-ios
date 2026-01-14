# VideosAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**videosGet**](VideosAPI.md#videosget) | **GET** /videos | Get multiple videos.
[**videosIdGet**](VideosAPI.md#videosidget) | **GET** /videos/{id} | Get single video.
[**videosIdRelationshipsAlbumsGet**](VideosAPI.md#videosidrelationshipsalbumsget) | **GET** /videos/{id}/relationships/albums | Get albums relationship (\&quot;to-many\&quot;).
[**videosIdRelationshipsArtistsGet**](VideosAPI.md#videosidrelationshipsartistsget) | **GET** /videos/{id}/relationships/artists | Get artists relationship (\&quot;to-many\&quot;).
[**videosIdRelationshipsProvidersGet**](VideosAPI.md#videosidrelationshipsprovidersget) | **GET** /videos/{id}/relationships/providers | Get providers relationship (\&quot;to-many\&quot;).
[**videosIdRelationshipsThumbnailArtGet**](VideosAPI.md#videosidrelationshipsthumbnailartget) | **GET** /videos/{id}/relationships/thumbnailArt | Get thumbnailArt relationship (\&quot;to-many\&quot;).


# **videosGet**
```swift
    open class func videosGet(countryCode: String? = nil, include: [String]? = nil, filterId: [String]? = nil, filterIsrc: [String]? = nil, completion: @escaping (_ data: VideosMultiResourceDataDocument?, _ error: Error?) -> Void)
```

Get multiple videos.

Retrieves multiple videos by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: albums, artists, providers, thumbnailArt (optional)
let filterId = ["inner_example"] // [String] | Video id (optional)
let filterIsrc = ["inner_example"] // [String] | International Standard Recording Code (ISRC) (optional)

// Get multiple videos.
VideosAPI.videosGet(countryCode: countryCode, include: include, filterId: filterId, filterIsrc: filterIsrc) { (response, error) in
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
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: albums, artists, providers, thumbnailArt | [optional] 
 **filterId** | [**[String]**](String.md) | Video id | [optional] 
 **filterIsrc** | [**[String]**](String.md) | International Standard Recording Code (ISRC) | [optional] 

### Return type

[**VideosMultiResourceDataDocument**](VideosMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **videosIdGet**
```swift
    open class func videosIdGet(id: String, countryCode: String? = nil, include: [String]? = nil, completion: @escaping (_ data: VideosSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single video.

Retrieves single video by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Video id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: albums, artists, providers, thumbnailArt (optional)

// Get single video.
VideosAPI.videosIdGet(id: id, countryCode: countryCode, include: include) { (response, error) in
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
 **id** | **String** | Video id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: albums, artists, providers, thumbnailArt | [optional] 

### Return type

[**VideosSingleResourceDataDocument**](VideosSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **videosIdRelationshipsAlbumsGet**
```swift
    open class func videosIdRelationshipsAlbumsGet(id: String, pageCursor: String? = nil, countryCode: String? = nil, include: [String]? = nil, completion: @escaping (_ data: VideosMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get albums relationship (\"to-many\").

Retrieves albums relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Video id
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: albums (optional)

// Get albums relationship (\"to-many\").
VideosAPI.videosIdRelationshipsAlbumsGet(id: id, pageCursor: pageCursor, countryCode: countryCode, include: include) { (response, error) in
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
 **id** | **String** | Video id | 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: albums | [optional] 

### Return type

[**VideosMultiRelationshipDataDocument**](VideosMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **videosIdRelationshipsArtistsGet**
```swift
    open class func videosIdRelationshipsArtistsGet(id: String, pageCursor: String? = nil, countryCode: String? = nil, include: [String]? = nil, completion: @escaping (_ data: VideosMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get artists relationship (\"to-many\").

Retrieves artists relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Video id
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: artists (optional)

// Get artists relationship (\"to-many\").
VideosAPI.videosIdRelationshipsArtistsGet(id: id, pageCursor: pageCursor, countryCode: countryCode, include: include) { (response, error) in
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
 **id** | **String** | Video id | 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: artists | [optional] 

### Return type

[**VideosMultiRelationshipDataDocument**](VideosMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **videosIdRelationshipsProvidersGet**
```swift
    open class func videosIdRelationshipsProvidersGet(id: String, pageCursor: String? = nil, countryCode: String? = nil, include: [String]? = nil, completion: @escaping (_ data: VideosMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get providers relationship (\"to-many\").

Retrieves providers relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Video id
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: providers (optional)

// Get providers relationship (\"to-many\").
VideosAPI.videosIdRelationshipsProvidersGet(id: id, pageCursor: pageCursor, countryCode: countryCode, include: include) { (response, error) in
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
 **id** | **String** | Video id | 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: providers | [optional] 

### Return type

[**VideosMultiRelationshipDataDocument**](VideosMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **videosIdRelationshipsThumbnailArtGet**
```swift
    open class func videosIdRelationshipsThumbnailArtGet(id: String, pageCursor: String? = nil, countryCode: String? = nil, include: [String]? = nil, completion: @escaping (_ data: VideosMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get thumbnailArt relationship (\"to-many\").

Retrieves thumbnailArt relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Video id
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: thumbnailArt (optional)

// Get thumbnailArt relationship (\"to-many\").
VideosAPI.videosIdRelationshipsThumbnailArtGet(id: id, pageCursor: pageCursor, countryCode: countryCode, include: include) { (response, error) in
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
 **id** | **String** | Video id | 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: thumbnailArt | [optional] 

### Return type

[**VideosMultiRelationshipDataDocument**](VideosMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

