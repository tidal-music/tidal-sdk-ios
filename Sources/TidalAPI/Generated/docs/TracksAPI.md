# TracksAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**tracksGet**](TracksAPI.md#tracksget) | **GET** /tracks | Get multiple tracks.
[**tracksIdDelete**](TracksAPI.md#tracksiddelete) | **DELETE** /tracks/{id} | Delete single track.
[**tracksIdGet**](TracksAPI.md#tracksidget) | **GET** /tracks/{id} | Get single track.
[**tracksIdPatch**](TracksAPI.md#tracksidpatch) | **PATCH** /tracks/{id} | Update single track.
[**tracksIdRelationshipsAlbumsGet**](TracksAPI.md#tracksidrelationshipsalbumsget) | **GET** /tracks/{id}/relationships/albums | Get albums relationship (\&quot;to-many\&quot;).
[**tracksIdRelationshipsAlbumsPatch**](TracksAPI.md#tracksidrelationshipsalbumspatch) | **PATCH** /tracks/{id}/relationships/albums | Update albums relationship (\&quot;to-many\&quot;).
[**tracksIdRelationshipsArtistsGet**](TracksAPI.md#tracksidrelationshipsartistsget) | **GET** /tracks/{id}/relationships/artists | Get artists relationship (\&quot;to-many\&quot;).
[**tracksIdRelationshipsCreditsGet**](TracksAPI.md#tracksidrelationshipscreditsget) | **GET** /tracks/{id}/relationships/credits | Get credits relationship (\&quot;to-many\&quot;).
[**tracksIdRelationshipsGenresGet**](TracksAPI.md#tracksidrelationshipsgenresget) | **GET** /tracks/{id}/relationships/genres | Get genres relationship (\&quot;to-many\&quot;).
[**tracksIdRelationshipsLyricsGet**](TracksAPI.md#tracksidrelationshipslyricsget) | **GET** /tracks/{id}/relationships/lyrics | Get lyrics relationship (\&quot;to-many\&quot;).
[**tracksIdRelationshipsMetadataStatusGet**](TracksAPI.md#tracksidrelationshipsmetadatastatusget) | **GET** /tracks/{id}/relationships/metadataStatus | Get metadataStatus relationship (\&quot;to-one\&quot;).
[**tracksIdRelationshipsOwnersGet**](TracksAPI.md#tracksidrelationshipsownersget) | **GET** /tracks/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
[**tracksIdRelationshipsProvidersGet**](TracksAPI.md#tracksidrelationshipsprovidersget) | **GET** /tracks/{id}/relationships/providers | Get providers relationship (\&quot;to-many\&quot;).
[**tracksIdRelationshipsRadioGet**](TracksAPI.md#tracksidrelationshipsradioget) | **GET** /tracks/{id}/relationships/radio | Get radio relationship (\&quot;to-many\&quot;).
[**tracksIdRelationshipsReplacementGet**](TracksAPI.md#tracksidrelationshipsreplacementget) | **GET** /tracks/{id}/relationships/replacement | Get replacement relationship (\&quot;to-one\&quot;).
[**tracksIdRelationshipsSharesGet**](TracksAPI.md#tracksidrelationshipssharesget) | **GET** /tracks/{id}/relationships/shares | Get shares relationship (\&quot;to-many\&quot;).
[**tracksIdRelationshipsSimilarTracksGet**](TracksAPI.md#tracksidrelationshipssimilartracksget) | **GET** /tracks/{id}/relationships/similarTracks | Get similarTracks relationship (\&quot;to-many\&quot;).
[**tracksIdRelationshipsSourceFileGet**](TracksAPI.md#tracksidrelationshipssourcefileget) | **GET** /tracks/{id}/relationships/sourceFile | Get sourceFile relationship (\&quot;to-one\&quot;).
[**tracksIdRelationshipsTrackStatisticsGet**](TracksAPI.md#tracksidrelationshipstrackstatisticsget) | **GET** /tracks/{id}/relationships/trackStatistics | Get trackStatistics relationship (\&quot;to-one\&quot;).
[**tracksPost**](TracksAPI.md#trackspost) | **POST** /tracks | Create single track.


# **tracksGet**
```swift
    open class func tracksGet(pageCursor: String? = nil, countryCode: String? = nil, include: [String]? = nil, filterId: [String]? = nil, filterIsrc: [String]? = nil, filterOwnersId: [String]? = nil, shareCode: String? = nil, completion: @escaping (_ data: TracksMultiResourceDataDocument?, _ error: Error?) -> Void)
```

Get multiple tracks.

Retrieves multiple tracks by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: albums, artists, credits, genres, lyrics, metadataStatus, owners, providers, radio, replacement, shares, similarTracks, sourceFile, trackStatistics (optional)
let filterId = ["inner_example"] // [String] | Track id (optional)
let filterIsrc = ["inner_example"] // [String] | International Standard Recording Code (ISRC) (optional)
let filterOwnersId = ["inner_example"] // [String] | User id (optional)
let shareCode = "shareCode_example" // String | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. (optional)

// Get multiple tracks.
TracksAPI.tracksGet(pageCursor: pageCursor, countryCode: countryCode, include: include, filterId: filterId, filterIsrc: filterIsrc, filterOwnersId: filterOwnersId, shareCode: shareCode) { (response, error) in
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
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: albums, artists, credits, genres, lyrics, metadataStatus, owners, providers, radio, replacement, shares, similarTracks, sourceFile, trackStatistics | [optional] 
 **filterId** | [**[String]**](String.md) | Track id | [optional] 
 **filterIsrc** | [**[String]**](String.md) | International Standard Recording Code (ISRC) | [optional] 
 **filterOwnersId** | [**[String]**](String.md) | User id | [optional] 
 **shareCode** | **String** | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. | [optional] 

### Return type

[**TracksMultiResourceDataDocument**](TracksMultiResourceDataDocument.md)

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

let id = "id_example" // String | Track id

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
 **id** | **String** | Track id | 

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
    open class func tracksIdGet(id: String, countryCode: String? = nil, include: [String]? = nil, shareCode: String? = nil, completion: @escaping (_ data: TracksSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single track.

Retrieves single track by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Track id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: albums, artists, credits, genres, lyrics, metadataStatus, owners, providers, radio, replacement, shares, similarTracks, sourceFile, trackStatistics (optional)
let shareCode = "shareCode_example" // String | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. (optional)

// Get single track.
TracksAPI.tracksIdGet(id: id, countryCode: countryCode, include: include, shareCode: shareCode) { (response, error) in
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
 **id** | **String** | Track id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: albums, artists, credits, genres, lyrics, metadataStatus, owners, providers, radio, replacement, shares, similarTracks, sourceFile, trackStatistics | [optional] 
 **shareCode** | **String** | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. | [optional] 

### Return type

[**TracksSingleResourceDataDocument**](TracksSingleResourceDataDocument.md)

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

let id = "id_example" // String | Track id
let trackUpdateOperationPayload = TrackUpdateOperation_Payload(data: TrackUpdateOperation_Payload_Data(attributes: TrackUpdateOperation_Payload_Data_Attributes(accessType: "accessType_example", bpm: 123, explicit: false, key: "key_example", keyScale: "keyScale_example", title: "title_example", toneTags: ["toneTags_example"]), id: "id_example", relationships: TrackUpdateOperation_Payload_Data_Relationships(genres: TrackUpdateOperation_Payload_Data_Relationships_Genres(data: [TrackUpdateOperation_Payload_Data_Relationships_Genres_Data(id: "id_example", type: "type_example")])), type: "type_example")) // TrackUpdateOperationPayload |  (optional)

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
 **id** | **String** | Track id | 
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
    open class func tracksIdRelationshipsAlbumsGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil, shareCode: String? = nil, completion: @escaping (_ data: TracksMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get albums relationship (\"to-many\").

Retrieves albums relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Track id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: albums (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let shareCode = "shareCode_example" // String | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. (optional)

// Get albums relationship (\"to-many\").
TracksAPI.tracksIdRelationshipsAlbumsGet(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor, shareCode: shareCode) { (response, error) in
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
 **id** | **String** | Track id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: albums | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **shareCode** | **String** | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. | [optional] 

### Return type

[**TracksMultiRelationshipDataDocument**](TracksMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tracksIdRelationshipsAlbumsPatch**
```swift
    open class func tracksIdRelationshipsAlbumsPatch(id: String, trackAlbumsRelationshipUpdateOperationPayload: TrackAlbumsRelationshipUpdateOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Update albums relationship (\"to-many\").

Updates albums relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Track id
let trackAlbumsRelationshipUpdateOperationPayload = TrackAlbumsRelationshipUpdateOperation_Payload(data: [TrackAlbumsRelationshipUpdateOperation_Payload_Data(id: "id_example", type: "type_example")]) // TrackAlbumsRelationshipUpdateOperationPayload |  (optional)

// Update albums relationship (\"to-many\").
TracksAPI.tracksIdRelationshipsAlbumsPatch(id: id, trackAlbumsRelationshipUpdateOperationPayload: trackAlbumsRelationshipUpdateOperationPayload) { (response, error) in
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
 **id** | **String** | Track id | 
 **trackAlbumsRelationshipUpdateOperationPayload** | [**TrackAlbumsRelationshipUpdateOperationPayload**](TrackAlbumsRelationshipUpdateOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tracksIdRelationshipsArtistsGet**
```swift
    open class func tracksIdRelationshipsArtistsGet(id: String, pageCursor: String? = nil, countryCode: String? = nil, include: [String]? = nil, shareCode: String? = nil, completion: @escaping (_ data: TracksMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get artists relationship (\"to-many\").

Retrieves artists relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Track id
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: artists (optional)
let shareCode = "shareCode_example" // String | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. (optional)

// Get artists relationship (\"to-many\").
TracksAPI.tracksIdRelationshipsArtistsGet(id: id, pageCursor: pageCursor, countryCode: countryCode, include: include, shareCode: shareCode) { (response, error) in
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
 **id** | **String** | Track id | 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: artists | [optional] 
 **shareCode** | **String** | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. | [optional] 

### Return type

[**TracksMultiRelationshipDataDocument**](TracksMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tracksIdRelationshipsCreditsGet**
```swift
    open class func tracksIdRelationshipsCreditsGet(id: String, pageCursor: String? = nil, include: [String]? = nil, shareCode: String? = nil, completion: @escaping (_ data: TracksMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get credits relationship (\"to-many\").

Retrieves credits relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Track id
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: credits (optional)
let shareCode = "shareCode_example" // String | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. (optional)

// Get credits relationship (\"to-many\").
TracksAPI.tracksIdRelationshipsCreditsGet(id: id, pageCursor: pageCursor, include: include, shareCode: shareCode) { (response, error) in
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
 **id** | **String** | Track id | 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: credits | [optional] 
 **shareCode** | **String** | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. | [optional] 

### Return type

[**TracksMultiRelationshipDataDocument**](TracksMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tracksIdRelationshipsGenresGet**
```swift
    open class func tracksIdRelationshipsGenresGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil, shareCode: String? = nil, completion: @escaping (_ data: TracksMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get genres relationship (\"to-many\").

Retrieves genres relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Track id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: genres (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let shareCode = "shareCode_example" // String | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. (optional)

// Get genres relationship (\"to-many\").
TracksAPI.tracksIdRelationshipsGenresGet(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor, shareCode: shareCode) { (response, error) in
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
 **id** | **String** | Track id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: genres | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **shareCode** | **String** | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. | [optional] 

### Return type

[**TracksMultiRelationshipDataDocument**](TracksMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tracksIdRelationshipsLyricsGet**
```swift
    open class func tracksIdRelationshipsLyricsGet(id: String, include: [String]? = nil, pageCursor: String? = nil, shareCode: String? = nil, completion: @escaping (_ data: TracksMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get lyrics relationship (\"to-many\").

Retrieves lyrics relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Track id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: lyrics (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let shareCode = "shareCode_example" // String | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. (optional)

// Get lyrics relationship (\"to-many\").
TracksAPI.tracksIdRelationshipsLyricsGet(id: id, include: include, pageCursor: pageCursor, shareCode: shareCode) { (response, error) in
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
 **id** | **String** | Track id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: lyrics | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **shareCode** | **String** | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. | [optional] 

### Return type

[**TracksMultiRelationshipDataDocument**](TracksMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tracksIdRelationshipsMetadataStatusGet**
```swift
    open class func tracksIdRelationshipsMetadataStatusGet(id: String, include: [String]? = nil, shareCode: String? = nil, completion: @escaping (_ data: TracksSingleRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get metadataStatus relationship (\"to-one\").

Retrieves metadataStatus relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Track id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: metadataStatus (optional)
let shareCode = "shareCode_example" // String | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. (optional)

// Get metadataStatus relationship (\"to-one\").
TracksAPI.tracksIdRelationshipsMetadataStatusGet(id: id, include: include, shareCode: shareCode) { (response, error) in
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
 **id** | **String** | Track id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: metadataStatus | [optional] 
 **shareCode** | **String** | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. | [optional] 

### Return type

[**TracksSingleRelationshipDataDocument**](TracksSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tracksIdRelationshipsOwnersGet**
```swift
    open class func tracksIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil, shareCode: String? = nil, completion: @escaping (_ data: TracksMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Track id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let shareCode = "shareCode_example" // String | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. (optional)

// Get owners relationship (\"to-many\").
TracksAPI.tracksIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor, shareCode: shareCode) { (response, error) in
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
 **id** | **String** | Track id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **shareCode** | **String** | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. | [optional] 

### Return type

[**TracksMultiRelationshipDataDocument**](TracksMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tracksIdRelationshipsProvidersGet**
```swift
    open class func tracksIdRelationshipsProvidersGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil, shareCode: String? = nil, completion: @escaping (_ data: TracksMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get providers relationship (\"to-many\").

Retrieves providers relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Track id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: providers (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let shareCode = "shareCode_example" // String | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. (optional)

// Get providers relationship (\"to-many\").
TracksAPI.tracksIdRelationshipsProvidersGet(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor, shareCode: shareCode) { (response, error) in
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
 **id** | **String** | Track id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: providers | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **shareCode** | **String** | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. | [optional] 

### Return type

[**TracksMultiRelationshipDataDocument**](TracksMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tracksIdRelationshipsRadioGet**
```swift
    open class func tracksIdRelationshipsRadioGet(id: String, include: [String]? = nil, pageCursor: String? = nil, shareCode: String? = nil, completion: @escaping (_ data: TracksMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get radio relationship (\"to-many\").

Retrieves radio relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Track id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: radio (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let shareCode = "shareCode_example" // String | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. (optional)

// Get radio relationship (\"to-many\").
TracksAPI.tracksIdRelationshipsRadioGet(id: id, include: include, pageCursor: pageCursor, shareCode: shareCode) { (response, error) in
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
 **id** | **String** | Track id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: radio | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **shareCode** | **String** | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. | [optional] 

### Return type

[**TracksMultiRelationshipDataDocument**](TracksMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tracksIdRelationshipsReplacementGet**
```swift
    open class func tracksIdRelationshipsReplacementGet(id: String, countryCode: String? = nil, include: [String]? = nil, shareCode: String? = nil, completion: @escaping (_ data: TracksSingleRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get replacement relationship (\"to-one\").

Retrieves replacement relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Track id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: replacement (optional)
let shareCode = "shareCode_example" // String | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. (optional)

// Get replacement relationship (\"to-one\").
TracksAPI.tracksIdRelationshipsReplacementGet(id: id, countryCode: countryCode, include: include, shareCode: shareCode) { (response, error) in
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
 **id** | **String** | Track id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: replacement | [optional] 
 **shareCode** | **String** | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. | [optional] 

### Return type

[**TracksSingleRelationshipDataDocument**](TracksSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tracksIdRelationshipsSharesGet**
```swift
    open class func tracksIdRelationshipsSharesGet(id: String, include: [String]? = nil, pageCursor: String? = nil, shareCode: String? = nil, completion: @escaping (_ data: TracksMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get shares relationship (\"to-many\").

Retrieves shares relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Track id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: shares (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let shareCode = "shareCode_example" // String | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. (optional)

// Get shares relationship (\"to-many\").
TracksAPI.tracksIdRelationshipsSharesGet(id: id, include: include, pageCursor: pageCursor, shareCode: shareCode) { (response, error) in
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
 **id** | **String** | Track id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: shares | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **shareCode** | **String** | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. | [optional] 

### Return type

[**TracksMultiRelationshipDataDocument**](TracksMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tracksIdRelationshipsSimilarTracksGet**
```swift
    open class func tracksIdRelationshipsSimilarTracksGet(id: String, pageCursor: String? = nil, countryCode: String? = nil, include: [String]? = nil, shareCode: String? = nil, completion: @escaping (_ data: TracksMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get similarTracks relationship (\"to-many\").

Retrieves similarTracks relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Track id
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: similarTracks (optional)
let shareCode = "shareCode_example" // String | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. (optional)

// Get similarTracks relationship (\"to-many\").
TracksAPI.tracksIdRelationshipsSimilarTracksGet(id: id, pageCursor: pageCursor, countryCode: countryCode, include: include, shareCode: shareCode) { (response, error) in
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
 **id** | **String** | Track id | 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: similarTracks | [optional] 
 **shareCode** | **String** | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. | [optional] 

### Return type

[**TracksMultiRelationshipDataDocument**](TracksMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tracksIdRelationshipsSourceFileGet**
```swift
    open class func tracksIdRelationshipsSourceFileGet(id: String, include: [String]? = nil, shareCode: String? = nil, completion: @escaping (_ data: TracksSingleRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get sourceFile relationship (\"to-one\").

Retrieves sourceFile relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Track id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: sourceFile (optional)
let shareCode = "shareCode_example" // String | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. (optional)

// Get sourceFile relationship (\"to-one\").
TracksAPI.tracksIdRelationshipsSourceFileGet(id: id, include: include, shareCode: shareCode) { (response, error) in
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
 **id** | **String** | Track id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: sourceFile | [optional] 
 **shareCode** | **String** | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. | [optional] 

### Return type

[**TracksSingleRelationshipDataDocument**](TracksSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tracksIdRelationshipsTrackStatisticsGet**
```swift
    open class func tracksIdRelationshipsTrackStatisticsGet(id: String, include: [String]? = nil, shareCode: String? = nil, completion: @escaping (_ data: TracksSingleRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get trackStatistics relationship (\"to-one\").

Retrieves trackStatistics relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Track id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: trackStatistics (optional)
let shareCode = "shareCode_example" // String | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. (optional)

// Get trackStatistics relationship (\"to-one\").
TracksAPI.tracksIdRelationshipsTrackStatisticsGet(id: id, include: include, shareCode: shareCode) { (response, error) in
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
 **id** | **String** | Track id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: trackStatistics | [optional] 
 **shareCode** | **String** | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. | [optional] 

### Return type

[**TracksSingleRelationshipDataDocument**](TracksSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tracksPost**
```swift
    open class func tracksPost(trackCreateOperationPayload: TrackCreateOperationPayload? = nil, completion: @escaping (_ data: TracksSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Create single track.

Creates a new track.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let trackCreateOperationPayload = TrackCreateOperation_Payload(data: TrackCreateOperation_Payload_Data(attributes: TrackCreateOperation_Payload_Data_Attributes(accessType: "accessType_example", explicit: false, title: "title_example"), relationships: TrackCreateOperation_Payload_Data_Relationships(albums: TrackCreateOperation_Payload_Data_Relationships_Albums(data: [TrackCreateOperation_Payload_Data_Relationships_Albums_Data(id: "id_example", type: "type_example")]), artists: TrackCreateOperation_Payload_Data_Relationships_Artists(data: [TrackCreateOperation_Payload_Data_Relationships_Artists_Data(id: "id_example", type: "type_example")]), genres: TrackCreateOperation_Payload_Data_Relationships_Genres(data: [TrackCreateOperation_Payload_Data_Relationships_Genres_Data(id: "id_example", type: "type_example")])), type: "type_example")) // TrackCreateOperationPayload |  (optional)

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

[**TracksSingleResourceDataDocument**](TracksSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

