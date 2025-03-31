# TracksAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**tracksGet**](TracksAPI.md#tracksget) | **GET** /tracks | Get all tracks
[**tracksIdGet**](TracksAPI.md#tracksidget) | **GET** /tracks/{id} | Get single track
[**tracksIdRelationshipsAlbumsGet**](TracksAPI.md#tracksidrelationshipsalbumsget) | **GET** /tracks/{id}/relationships/albums | Relationship: albums
[**tracksIdRelationshipsArtistsGet**](TracksAPI.md#tracksidrelationshipsartistsget) | **GET** /tracks/{id}/relationships/artists | Relationship: artists
[**tracksIdRelationshipsProvidersGet**](TracksAPI.md#tracksidrelationshipsprovidersget) | **GET** /tracks/{id}/relationships/providers | Relationship: providers
[**tracksIdRelationshipsRadioGet**](TracksAPI.md#tracksidrelationshipsradioget) | **GET** /tracks/{id}/relationships/radio | Relationship: radio
[**tracksIdRelationshipsSimilarTracksGet**](TracksAPI.md#tracksidrelationshipssimilartracksget) | **GET** /tracks/{id}/relationships/similarTracks | Relationship: similarTracks


# **tracksGet**
```swift
    open class func tracksGet(countryCode: String, include: [String]? = nil, filterIsrc: [String]? = nil, filterId: [String]? = nil, completion: @escaping (_ data: TracksMultiDataDocument?, _ error: Error?) -> Void)
```

Get all tracks

Retrieves all track details by available filters or without (if applicable).

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: albums, artists, providers, radio, similarTracks (optional)
let filterIsrc = ["inner_example"] // [String] | Allows to filter the collection of resources based on isrc attribute value (optional)
let filterId = ["inner_example"] // [String] | Allows to filter the collection of resources based on id attribute value (optional)

// Get all tracks
TracksAPI.tracksGet(countryCode: countryCode, include: include, filterIsrc: filterIsrc, filterId: filterId) { (response, error) in
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
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: albums, artists, providers, radio, similarTracks | [optional] 
 **filterIsrc** | [**[String]**](String.md) | Allows to filter the collection of resources based on isrc attribute value | [optional] 
 **filterId** | [**[String]**](String.md) | Allows to filter the collection of resources based on id attribute value | [optional] 

### Return type

[**TracksMultiDataDocument**](TracksMultiDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tracksIdGet**
```swift
    open class func tracksIdGet(id: String, countryCode: String, include: [String]? = nil, completion: @escaping (_ data: TracksSingleDataDocument?, _ error: Error?) -> Void)
```

Get single track

Retrieves track details by an unique id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | TIDAL track id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: albums, artists, providers, radio, similarTracks (optional)

// Get single track
TracksAPI.tracksIdGet(id: id, countryCode: countryCode, include: include) { (response, error) in
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
 **id** | **String** | TIDAL track id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: albums, artists, providers, radio, similarTracks | [optional] 

### Return type

[**TracksSingleDataDocument**](TracksSingleDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tracksIdRelationshipsAlbumsGet**
```swift
    open class func tracksIdRelationshipsAlbumsGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: TracksMultiDataRelationshipDocument?, _ error: Error?) -> Void)
```

Relationship: albums

Retrieves albums relationship details of the related track resource.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | TIDAL track id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: albums (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Relationship: albums
TracksAPI.tracksIdRelationshipsAlbumsGet(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | TIDAL track id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: albums | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**TracksMultiDataRelationshipDocument**](TracksMultiDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tracksIdRelationshipsArtistsGet**
```swift
    open class func tracksIdRelationshipsArtistsGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: TracksMultiDataRelationshipDocument?, _ error: Error?) -> Void)
```

Relationship: artists

Retrieves artists relationship details of the related track resource.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | TIDAL track id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: artists (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Relationship: artists
TracksAPI.tracksIdRelationshipsArtistsGet(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | TIDAL track id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: artists | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**TracksMultiDataRelationshipDocument**](TracksMultiDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tracksIdRelationshipsProvidersGet**
```swift
    open class func tracksIdRelationshipsProvidersGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: TracksMultiDataRelationshipDocument?, _ error: Error?) -> Void)
```

Relationship: providers

Retrieves providers relationship details of the related track resource.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | TIDAL track id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: providers (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Relationship: providers
TracksAPI.tracksIdRelationshipsProvidersGet(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | TIDAL track id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: providers | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**TracksMultiDataRelationshipDocument**](TracksMultiDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tracksIdRelationshipsRadioGet**
```swift
    open class func tracksIdRelationshipsRadioGet(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: TracksMultiDataRelationshipDocument?, _ error: Error?) -> Void)
```

Relationship: radio

Retrieves radio relationship details of the related track resource.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | TIDAL track id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: radio (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Relationship: radio
TracksAPI.tracksIdRelationshipsRadioGet(id: id, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | TIDAL track id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: radio | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**TracksMultiDataRelationshipDocument**](TracksMultiDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tracksIdRelationshipsSimilarTracksGet**
```swift
    open class func tracksIdRelationshipsSimilarTracksGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: TracksMultiDataRelationshipDocument?, _ error: Error?) -> Void)
```

Relationship: similarTracks

Retrieves similarTracks relationship details of the related track resource.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | TIDAL track id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: similarTracks (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Relationship: similarTracks
TracksAPI.tracksIdRelationshipsSimilarTracksGet(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | TIDAL track id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: similarTracks | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**TracksMultiDataRelationshipDocument**](TracksMultiDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

