# ArtistsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**artistsGet**](ArtistsAPI.md#artistsget) | **GET** /artists | Get multiple artists.
[**artistsIdGet**](ArtistsAPI.md#artistsidget) | **GET** /artists/{id} | Get single artist.
[**artistsIdPatch**](ArtistsAPI.md#artistsidpatch) | **PATCH** /artists/{id} | Update single artist.
[**artistsIdRelationshipsAlbumsGet**](ArtistsAPI.md#artistsidrelationshipsalbumsget) | **GET** /artists/{id}/relationships/albums | Get albums relationship (\&quot;to-many\&quot;).
[**artistsIdRelationshipsRadioGet**](ArtistsAPI.md#artistsidrelationshipsradioget) | **GET** /artists/{id}/relationships/radio | Get radio relationship (\&quot;to-many\&quot;).
[**artistsIdRelationshipsRolesGet**](ArtistsAPI.md#artistsidrelationshipsrolesget) | **GET** /artists/{id}/relationships/roles | Get roles relationship (\&quot;to-many\&quot;).
[**artistsIdRelationshipsSimilarArtistsGet**](ArtistsAPI.md#artistsidrelationshipssimilarartistsget) | **GET** /artists/{id}/relationships/similarArtists | Get similarArtists relationship (\&quot;to-many\&quot;).
[**artistsIdRelationshipsTrackProvidersGet**](ArtistsAPI.md#artistsidrelationshipstrackprovidersget) | **GET** /artists/{id}/relationships/trackProviders | Get trackProviders relationship (\&quot;to-many\&quot;).
[**artistsIdRelationshipsTracksGet**](ArtistsAPI.md#artistsidrelationshipstracksget) | **GET** /artists/{id}/relationships/tracks | Get tracks relationship (\&quot;to-many\&quot;).
[**artistsIdRelationshipsVideosGet**](ArtistsAPI.md#artistsidrelationshipsvideosget) | **GET** /artists/{id}/relationships/videos | Get videos relationship (\&quot;to-many\&quot;).


# **artistsGet**
```swift
    open class func artistsGet(countryCode: String, include: [String]? = nil, filterHandle: [String]? = nil, filterId: [String]? = nil, completion: @escaping (_ data: ArtistsMultiDataDocument?, _ error: Error?) -> Void)
```

Get multiple artists.

Retrieves multiple artists by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: albums, radio, roles, similarArtists, trackProviders, tracks, videos (optional)
let filterHandle = ["inner_example"] // [String] | Allows to filter the collection of resources based on handle attribute value (optional)
let filterId = ["inner_example"] // [String] | Allows to filter the collection of resources based on id attribute value (optional)

// Get multiple artists.
ArtistsAPI.artistsGet(countryCode: countryCode, include: include, filterHandle: filterHandle, filterId: filterId) { (response, error) in
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
 **filterHandle** | [**[String]**](String.md) | Allows to filter the collection of resources based on handle attribute value | [optional] 
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

Get single artist.

Retrieves single artist by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: albums, radio, roles, similarArtists, trackProviders, tracks, videos (optional)

// Get single artist.
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
 **id** | **String** | Artist id | 
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

# **artistsIdPatch**
```swift
    open class func artistsIdPatch(id: String, artistUpdateBody: ArtistUpdateBody? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Update single artist.

Updates existing artist.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist id
let artistUpdateBody = ArtistUpdateBody(data: ArtistUpdateBody_Data(id: "id_example", type: "type_example", attributes: ArtistUpdateBody_Data_Attributes(name: "name_example", handle: "handle_example", imageLinks: [Image_Link(href: "href_example", meta: Image_Link_Meta(width: 123, height: 123))], externalLinks: [External_Link(href: "href_example", meta: External_Link_Meta(type: "type_example"))]))) // ArtistUpdateBody |  (optional)

// Update single artist.
ArtistsAPI.artistsIdPatch(id: id, artistUpdateBody: artistUpdateBody) { (response, error) in
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
 **id** | **String** | Artist id | 
 **artistUpdateBody** | [**ArtistUpdateBody**](ArtistUpdateBody.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artistsIdRelationshipsAlbumsGet**
```swift
    open class func artistsIdRelationshipsAlbumsGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: ArtistsMultiDataRelationshipDocument?, _ error: Error?) -> Void)
```

Get albums relationship (\"to-many\").

Retrieves albums relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: albums (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get albums relationship (\"to-many\").
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
 **id** | **String** | Artist id | 
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

Get radio relationship (\"to-many\").

Retrieves radio relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: radio (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get radio relationship (\"to-many\").
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
 **id** | **String** | Artist id | 
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

Get roles relationship (\"to-many\").

Retrieves roles relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: roles (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get roles relationship (\"to-many\").
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
 **id** | **String** | Artist id | 
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

Get similarArtists relationship (\"to-many\").

Retrieves similarArtists relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: similarArtists (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get similarArtists relationship (\"to-many\").
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
 **id** | **String** | Artist id | 
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
    open class func artistsIdRelationshipsTrackProvidersGet(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: ArtistsTrackProvidersResourceIdentifier?, _ error: Error?) -> Void)
```

Get trackProviders relationship (\"to-many\").

Retrieves trackProviders relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: trackProviders (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get trackProviders relationship (\"to-many\").
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
 **id** | **String** | Artist id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: trackProviders | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**ArtistsTrackProvidersResourceIdentifier**](ArtistsTrackProvidersResourceIdentifier.md)

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

Get tracks relationship (\"to-many\").

Retrieves tracks relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let collapseBy = "collapseBy_example" // String | Collapse by options for getting artist tracks. Available options: FINGERPRINT, ID. FINGERPRINT option might collapse similar tracks based entry fingerprints while collapsing by ID always returns all available items.
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: tracks (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get tracks relationship (\"to-many\").
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
 **id** | **String** | Artist id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **collapseBy** | **String** | Collapse by options for getting artist tracks. Available options: FINGERPRINT, ID. FINGERPRINT option might collapse similar tracks based entry fingerprints while collapsing by ID always returns all available items. | 
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

Get videos relationship (\"to-many\").

Retrieves videos relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: videos (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get videos relationship (\"to-many\").
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
 **id** | **String** | Artist id | 
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

