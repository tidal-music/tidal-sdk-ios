# TracksAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**tracksGet**](TracksAPI.md#tracksget) | **GET** /tracks | Get multiple tracks.
[**tracksIdDelete**](TracksAPI.md#tracksiddelete) | **DELETE** /tracks/{id} | Delete single track.
[**tracksIdGet**](TracksAPI.md#tracksidget) | **GET** /tracks/{id} | Get single track.
[**tracksIdPatch**](TracksAPI.md#tracksidpatch) | **PATCH** /tracks/{id} | Update single track.
[**tracksIdRelationshipsAlbumsGet**](TracksAPI.md#tracksidrelationshipsalbumsget) | **GET** /tracks/{id}/relationships/albums | Get albums relationship (\&quot;to-many\&quot;).
[**tracksIdRelationshipsArtistsGet**](TracksAPI.md#tracksidrelationshipsartistsget) | **GET** /tracks/{id}/relationships/artists | Get artists relationship (\&quot;to-many\&quot;).
[**tracksIdRelationshipsLyricsGet**](TracksAPI.md#tracksidrelationshipslyricsget) | **GET** /tracks/{id}/relationships/lyrics | Get lyrics relationship (\&quot;to-many\&quot;).
[**tracksIdRelationshipsOwnersGet**](TracksAPI.md#tracksidrelationshipsownersget) | **GET** /tracks/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
[**tracksIdRelationshipsProvidersGet**](TracksAPI.md#tracksidrelationshipsprovidersget) | **GET** /tracks/{id}/relationships/providers | Get providers relationship (\&quot;to-many\&quot;).
[**tracksIdRelationshipsRadioGet**](TracksAPI.md#tracksidrelationshipsradioget) | **GET** /tracks/{id}/relationships/radio | Get radio relationship (\&quot;to-many\&quot;).
[**tracksIdRelationshipsSimilarTracksGet**](TracksAPI.md#tracksidrelationshipssimilartracksget) | **GET** /tracks/{id}/relationships/similarTracks | Get similarTracks relationship (\&quot;to-many\&quot;).
[**tracksIdRelationshipsTrackStatisticsGet**](TracksAPI.md#tracksidrelationshipstrackstatisticsget) | **GET** /tracks/{id}/relationships/trackStatistics | Get trackStatistics relationship (\&quot;to-one\&quot;).
[**tracksPost**](TracksAPI.md#trackspost) | **POST** /tracks | Create single track.


# **tracksGet**
```swift
    open class func tracksGet(countryCode: String, pageCursor: String? = nil, include: [String]? = nil, filterROwnersId: [String]? = nil, filterIsrc: [String]? = nil, filterId: [String]? = nil, completion: @escaping (_ data: TracksMultiDataDocument?, _ error: Error?) -> Void)
```

Get multiple tracks.

Retrieves multiple tracks by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: albums, artists, lyrics, owners, providers, radio, similarTracks, trackStatistics (optional)
let filterROwnersId = ["inner_example"] // [String] | User id (optional)
let filterIsrc = ["inner_example"] // [String] | International Standard Recording Code (ISRC) (optional)
let filterId = ["inner_example"] // [String] | A Tidal catalogue ID (optional)

// Get multiple tracks.
TracksAPI.tracksGet(countryCode: countryCode, pageCursor: pageCursor, include: include, filterROwnersId: filterROwnersId, filterIsrc: filterIsrc, filterId: filterId) { (response, error) in
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
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: albums, artists, lyrics, owners, providers, radio, similarTracks, trackStatistics | [optional] 
 **filterROwnersId** | [**[String]**](String.md) | User id | [optional] 
 **filterIsrc** | [**[String]**](String.md) | International Standard Recording Code (ISRC) | [optional] 
 **filterId** | [**[String]**](String.md) | A Tidal catalogue ID | [optional] 

### Return type

[**TracksMultiDataDocument**](TracksMultiDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tracksIdDelete**
```swift
    open class func tracksIdDelete(id: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Delete single track.

Deletes existing track.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | A Tidal catalogue ID

// Delete single track.
TracksAPI.tracksIdDelete(id: id) { (response, error) in
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
 **id** | **String** | A Tidal catalogue ID | 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tracksIdGet**
```swift
    open class func tracksIdGet(id: String, countryCode: String, include: [String]? = nil, completion: @escaping (_ data: TracksSingleDataDocument?, _ error: Error?) -> Void)
```

Get single track.

Retrieves single track by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | A Tidal catalogue ID
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: albums, artists, lyrics, owners, providers, radio, similarTracks, trackStatistics (optional)

// Get single track.
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
 **id** | **String** | A Tidal catalogue ID | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: albums, artists, lyrics, owners, providers, radio, similarTracks, trackStatistics | [optional] 

### Return type

[**TracksSingleDataDocument**](TracksSingleDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tracksIdPatch**
```swift
    open class func tracksIdPatch(id: String, trackUpdateOperationPayload: TrackUpdateOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Update single track.

Updates existing track.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | A Tidal catalogue ID
let trackUpdateOperationPayload = TrackUpdateOperation_Payload(data: TrackUpdateOperation_Payload_Data(attributes: TrackUpdateOperation_Payload_Data_Attributes(accessType: "accessType_example", bpm: 123, explicit: false, genreTags: ["genreTags_example"], key: "key_example", keyScale: "keyScale_example", title: "title_example", toneTags: ["toneTags_example"]), id: "id_example", type: "type_example")) // TrackUpdateOperationPayload |  (optional)

// Update single track.
TracksAPI.tracksIdPatch(id: id, trackUpdateOperationPayload: trackUpdateOperationPayload) { (response, error) in
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
 **id** | **String** | A Tidal catalogue ID | 
 **trackUpdateOperationPayload** | [**TrackUpdateOperationPayload**](TrackUpdateOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tracksIdRelationshipsAlbumsGet**
```swift
    open class func tracksIdRelationshipsAlbumsGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: TracksMultiDataRelationshipDocument?, _ error: Error?) -> Void)
```

Get albums relationship (\"to-many\").

Retrieves albums relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | A Tidal catalogue ID
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: albums (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get albums relationship (\"to-many\").
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
 **id** | **String** | A Tidal catalogue ID | 
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
    open class func tracksIdRelationshipsArtistsGet(id: String, countryCode: String, pageCursor: String? = nil, include: [String]? = nil, completion: @escaping (_ data: TracksMultiDataRelationshipDocument?, _ error: Error?) -> Void)
```

Get artists relationship (\"to-many\").

Retrieves artists relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | A Tidal catalogue ID
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: artists (optional)

// Get artists relationship (\"to-many\").
TracksAPI.tracksIdRelationshipsArtistsGet(id: id, countryCode: countryCode, pageCursor: pageCursor, include: include) { (response, error) in
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
 **id** | **String** | A Tidal catalogue ID | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: artists | [optional] 

### Return type

[**TracksMultiDataRelationshipDocument**](TracksMultiDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tracksIdRelationshipsLyricsGet**
```swift
    open class func tracksIdRelationshipsLyricsGet(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: TracksMultiDataRelationshipDocument?, _ error: Error?) -> Void)
```

Get lyrics relationship (\"to-many\").

Retrieves lyrics relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | A Tidal catalogue ID
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: lyrics (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get lyrics relationship (\"to-many\").
TracksAPI.tracksIdRelationshipsLyricsGet(id: id, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | A Tidal catalogue ID | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: lyrics | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**TracksMultiDataRelationshipDocument**](TracksMultiDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tracksIdRelationshipsOwnersGet**
```swift
    open class func tracksIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: TracksMultiDataRelationshipDocument?, _ error: Error?) -> Void)
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | A Tidal catalogue ID
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get owners relationship (\"to-many\").
TracksAPI.tracksIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | A Tidal catalogue ID | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**TracksMultiDataRelationshipDocument**](TracksMultiDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tracksIdRelationshipsProvidersGet**
```swift
    open class func tracksIdRelationshipsProvidersGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: TracksMultiDataRelationshipDocument?, _ error: Error?) -> Void)
```

Get providers relationship (\"to-many\").

Retrieves providers relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | A Tidal catalogue ID
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: providers (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get providers relationship (\"to-many\").
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
 **id** | **String** | A Tidal catalogue ID | 
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

Get radio relationship (\"to-many\").

Retrieves radio relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | A Tidal catalogue ID
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: radio (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get radio relationship (\"to-many\").
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
 **id** | **String** | A Tidal catalogue ID | 
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
    open class func tracksIdRelationshipsSimilarTracksGet(id: String, countryCode: String, pageCursor: String? = nil, include: [String]? = nil, completion: @escaping (_ data: TracksMultiDataRelationshipDocument?, _ error: Error?) -> Void)
```

Get similarTracks relationship (\"to-many\").

Retrieves similarTracks relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | A Tidal catalogue ID
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: similarTracks (optional)

// Get similarTracks relationship (\"to-many\").
TracksAPI.tracksIdRelationshipsSimilarTracksGet(id: id, countryCode: countryCode, pageCursor: pageCursor, include: include) { (response, error) in
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
 **id** | **String** | A Tidal catalogue ID | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: similarTracks | [optional] 

### Return type

[**TracksMultiDataRelationshipDocument**](TracksMultiDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tracksIdRelationshipsTrackStatisticsGet**
```swift
    open class func tracksIdRelationshipsTrackStatisticsGet(id: String, include: [String]? = nil, completion: @escaping (_ data: TracksSingletonDataRelationshipDocument?, _ error: Error?) -> Void)
```

Get trackStatistics relationship (\"to-one\").

Retrieves trackStatistics relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | A Tidal catalogue ID
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: trackStatistics (optional)

// Get trackStatistics relationship (\"to-one\").
TracksAPI.tracksIdRelationshipsTrackStatisticsGet(id: id, include: include) { (response, error) in
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
 **id** | **String** | A Tidal catalogue ID | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: trackStatistics | [optional] 

### Return type

[**TracksSingletonDataRelationshipDocument**](TracksSingletonDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tracksPost**
```swift
    open class func tracksPost(trackCreateOperationPayload: TrackCreateOperationPayload? = nil, completion: @escaping (_ data: TracksSingleDataDocument?, _ error: Error?) -> Void)
```

Create single track.

Creates a new track.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let trackCreateOperationPayload = TrackCreateOperation_Payload(data: TrackCreateOperation_Payload_Data(attributes: TrackCreateOperation_Payload_Data_Attributes(accessType: "accessType_example", explicit: false, title: "title_example"), relationships: TrackCreateOperation_Payload_Data_Relationships(albums: TrackCreateOperation_Payload_Data_Relationships_Albums(data: [TrackCreateOperation_Payload_Data_Relationships_Albums_Data(id: "id_example", type: "type_example")]), artists: TrackCreateOperation_Payload_Data_Relationships_Artists(data: [TrackCreateOperation_Payload_Data_Relationships_Artists_Data(id: "id_example", type: "type_example")])), type: "type_example")) // TrackCreateOperationPayload |  (optional)

// Create single track.
TracksAPI.tracksPost(trackCreateOperationPayload: trackCreateOperationPayload) { (response, error) in
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
 **trackCreateOperationPayload** | [**TrackCreateOperationPayload**](TrackCreateOperationPayload.md) |  | [optional] 

### Return type

[**TracksSingleDataDocument**](TracksSingleDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

