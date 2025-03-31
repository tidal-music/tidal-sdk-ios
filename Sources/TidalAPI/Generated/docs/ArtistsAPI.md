# ArtistsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**artistsGet**](ArtistsAPI.md#artistsget) | **GET** /artists | Get all artists
[**artistsIdGet**](ArtistsAPI.md#artistsidget) | **GET** /artists/{id} | Get single artist
[**artistsIdRelationshipsAlbumsGet**](ArtistsAPI.md#artistsidrelationshipsalbumsget) | **GET** /artists/{id}/relationships/albums | Relationship: albums
[**artistsIdRelationshipsRadioGet**](ArtistsAPI.md#artistsidrelationshipsradioget) | **GET** /artists/{id}/relationships/radio | Relationship: radio
[**artistsIdRelationshipsRolesGet**](ArtistsAPI.md#artistsidrelationshipsrolesget) | **GET** /artists/{id}/relationships/roles | Relationship: roles
[**artistsIdRelationshipsSimilarArtistsGet**](ArtistsAPI.md#artistsidrelationshipssimilarartistsget) | **GET** /artists/{id}/relationships/similarArtists | Relationship: similarArtists
[**artistsIdRelationshipsTrackProvidersGet**](ArtistsAPI.md#artistsidrelationshipstrackprovidersget) | **GET** /artists/{id}/relationships/trackProviders | Relationship: trackProviders
[**artistsIdRelationshipsTracksGet**](ArtistsAPI.md#artistsidrelationshipstracksget) | **GET** /artists/{id}/relationships/tracks | Relationship: tracks
[**artistsIdRelationshipsVideosGet**](ArtistsAPI.md#artistsidrelationshipsvideosget) | **GET** /artists/{id}/relationships/videos | Relationship: videos


# **artistsGet**
```swift
    open class func artistsGet(countryCode: String, include: [String]? = nil, filterId: [String]? = nil, completion: @escaping (_ data: ArtistsMultiDataDocument?, _ error: Error?) -> Void)
```

Get all artists

Retrieves all artist details by available filters or without (if applicable).

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: albums, radio, roles, similarArtists, trackProviders, tracks, videos (optional)
let filterId = ["inner_example"] // [String] | Allows to filter the collection of resources based on id attribute value (optional)

// Get all artists
ArtistsAPI.artistsGet(countryCode: countryCode, include: include, filterId: filterId) { (response, error) in
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
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: albums, radio, roles, similarArtists, trackProviders, tracks, videos | [optional] 
 **filterId** | [**[String]**](String.md) | Allows to filter the collection of resources based on id attribute value | [optional] 

### Return type

[**ArtistsMultiDataDocument**](ArtistsMultiDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artistsIdGet**
```swift
    open class func artistsIdGet(id: String, countryCode: String, include: [String]? = nil, completion: @escaping (_ data: ArtistsSingleDataDocument?, _ error: Error?) -> Void)
```

Get single artist

Retrieves artist details by an unique id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | TIDAL artist id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: albums, radio, roles, similarArtists, trackProviders, tracks, videos (optional)

// Get single artist
ArtistsAPI.artistsIdGet(id: id, countryCode: countryCode, include: include) { (response, error) in
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
 **id** | **String** | TIDAL artist id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: albums, radio, roles, similarArtists, trackProviders, tracks, videos | [optional] 

### Return type

[**ArtistsSingleDataDocument**](ArtistsSingleDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artistsIdRelationshipsAlbumsGet**
```swift
    open class func artistsIdRelationshipsAlbumsGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: ArtistsMultiDataRelationshipDocument?, _ error: Error?) -> Void)
```

Relationship: albums

Retrieves albums relationship details of the related artist resource.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | TIDAL artist id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: albums (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Relationship: albums
ArtistsAPI.artistsIdRelationshipsAlbumsGet(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | TIDAL artist id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: albums | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**ArtistsMultiDataRelationshipDocument**](ArtistsMultiDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artistsIdRelationshipsRadioGet**
```swift
    open class func artistsIdRelationshipsRadioGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: ArtistsMultiDataRelationshipDocument?, _ error: Error?) -> Void)
```

Relationship: radio

Retrieves radio relationship details of the related artist resource.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | TIDAL artist id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: radio (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Relationship: radio
ArtistsAPI.artistsIdRelationshipsRadioGet(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | TIDAL artist id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: radio | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**ArtistsMultiDataRelationshipDocument**](ArtistsMultiDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artistsIdRelationshipsRolesGet**
```swift
    open class func artistsIdRelationshipsRolesGet(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: ArtistsMultiDataRelationshipDocument?, _ error: Error?) -> Void)
```

Relationship: roles

Retrieves roles relationship details of the related artist resource.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | TIDAL artist id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: roles (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Relationship: roles
ArtistsAPI.artistsIdRelationshipsRolesGet(id: id, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | TIDAL artist id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: roles | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**ArtistsMultiDataRelationshipDocument**](ArtistsMultiDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artistsIdRelationshipsSimilarArtistsGet**
```swift
    open class func artistsIdRelationshipsSimilarArtistsGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: ArtistsMultiDataRelationshipDocument?, _ error: Error?) -> Void)
```

Relationship: similarArtists

Retrieves similarArtists relationship details of the related artist resource.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | TIDAL artist id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: similarArtists (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Relationship: similarArtists
ArtistsAPI.artistsIdRelationshipsSimilarArtistsGet(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | TIDAL artist id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: similarArtists | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**ArtistsMultiDataRelationshipDocument**](ArtistsMultiDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artistsIdRelationshipsTrackProvidersGet**
```swift
    open class func artistsIdRelationshipsTrackProvidersGet(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: ArtistsMultiDataRelationshipDocument?, _ error: Error?) -> Void)
```

Relationship: trackProviders

Retrieves trackProviders relationship details of the related artist resource.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | TIDAL artist id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: trackProviders (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Relationship: trackProviders
ArtistsAPI.artistsIdRelationshipsTrackProvidersGet(id: id, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | TIDAL artist id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: trackProviders | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**ArtistsMultiDataRelationshipDocument**](ArtistsMultiDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artistsIdRelationshipsTracksGet**
```swift
    open class func artistsIdRelationshipsTracksGet(id: String, countryCode: String, collapseBy: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: ArtistsMultiDataRelationshipDocument?, _ error: Error?) -> Void)
```

Relationship: tracks

Retrieves tracks relationship details of the related artist resource.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | TIDAL artist id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let collapseBy = "collapseBy_example" // String | Collapse by options for getting artist tracks. Available options: FINGERPRINT, ID. FINGERPRINT option might collapse similar tracks based item fingerprints while collapsing by ID always returns all available items
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: tracks (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Relationship: tracks
ArtistsAPI.artistsIdRelationshipsTracksGet(id: id, countryCode: countryCode, collapseBy: collapseBy, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | TIDAL artist id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **collapseBy** | **String** | Collapse by options for getting artist tracks. Available options: FINGERPRINT, ID. FINGERPRINT option might collapse similar tracks based item fingerprints while collapsing by ID always returns all available items | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: tracks | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**ArtistsMultiDataRelationshipDocument**](ArtistsMultiDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artistsIdRelationshipsVideosGet**
```swift
    open class func artistsIdRelationshipsVideosGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: ArtistsMultiDataRelationshipDocument?, _ error: Error?) -> Void)
```

Relationship: videos

Retrieves videos relationship details of the related artist resource.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | TIDAL artist id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: videos (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Relationship: videos
ArtistsAPI.artistsIdRelationshipsVideosGet(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | TIDAL artist id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: videos | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**ArtistsMultiDataRelationshipDocument**](ArtistsMultiDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

