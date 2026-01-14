# ArtistsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**artistsGet**](ArtistsAPI.md#artistsget) | **GET** /artists | Get multiple artists.
[**artistsIdGet**](ArtistsAPI.md#artistsidget) | **GET** /artists/{id} | Get single artist.
[**artistsIdPatch**](ArtistsAPI.md#artistsidpatch) | **PATCH** /artists/{id} | Update single artist.
[**artistsIdRelationshipsAlbumsGet**](ArtistsAPI.md#artistsidrelationshipsalbumsget) | **GET** /artists/{id}/relationships/albums | Get albums relationship (\&quot;to-many\&quot;).
[**artistsIdRelationshipsBiographyGet**](ArtistsAPI.md#artistsidrelationshipsbiographyget) | **GET** /artists/{id}/relationships/biography | Get biography relationship (\&quot;to-one\&quot;).
[**artistsIdRelationshipsFollowersGet**](ArtistsAPI.md#artistsidrelationshipsfollowersget) | **GET** /artists/{id}/relationships/followers | Get followers relationship (\&quot;to-many\&quot;).
[**artistsIdRelationshipsFollowingDelete**](ArtistsAPI.md#artistsidrelationshipsfollowingdelete) | **DELETE** /artists/{id}/relationships/following | Delete from following relationship (\&quot;to-many\&quot;).
[**artistsIdRelationshipsFollowingGet**](ArtistsAPI.md#artistsidrelationshipsfollowingget) | **GET** /artists/{id}/relationships/following | Get following relationship (\&quot;to-many\&quot;).
[**artistsIdRelationshipsFollowingPost**](ArtistsAPI.md#artistsidrelationshipsfollowingpost) | **POST** /artists/{id}/relationships/following | Add to following relationship (\&quot;to-many\&quot;).
[**artistsIdRelationshipsOwnersGet**](ArtistsAPI.md#artistsidrelationshipsownersget) | **GET** /artists/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
[**artistsIdRelationshipsProfileArtGet**](ArtistsAPI.md#artistsidrelationshipsprofileartget) | **GET** /artists/{id}/relationships/profileArt | Get profileArt relationship (\&quot;to-many\&quot;).
[**artistsIdRelationshipsProfileArtPatch**](ArtistsAPI.md#artistsidrelationshipsprofileartpatch) | **PATCH** /artists/{id}/relationships/profileArt | Update profileArt relationship (\&quot;to-many\&quot;).
[**artistsIdRelationshipsRadioGet**](ArtistsAPI.md#artistsidrelationshipsradioget) | **GET** /artists/{id}/relationships/radio | Get radio relationship (\&quot;to-many\&quot;).
[**artistsIdRelationshipsRolesGet**](ArtistsAPI.md#artistsidrelationshipsrolesget) | **GET** /artists/{id}/relationships/roles | Get roles relationship (\&quot;to-many\&quot;).
[**artistsIdRelationshipsSimilarArtistsGet**](ArtistsAPI.md#artistsidrelationshipssimilarartistsget) | **GET** /artists/{id}/relationships/similarArtists | Get similarArtists relationship (\&quot;to-many\&quot;).
[**artistsIdRelationshipsTrackProvidersGet**](ArtistsAPI.md#artistsidrelationshipstrackprovidersget) | **GET** /artists/{id}/relationships/trackProviders | Get trackProviders relationship (\&quot;to-many\&quot;).
[**artistsIdRelationshipsTracksGet**](ArtistsAPI.md#artistsidrelationshipstracksget) | **GET** /artists/{id}/relationships/tracks | Get tracks relationship (\&quot;to-many\&quot;).
[**artistsIdRelationshipsVideosGet**](ArtistsAPI.md#artistsidrelationshipsvideosget) | **GET** /artists/{id}/relationships/videos | Get videos relationship (\&quot;to-many\&quot;).
[**artistsPost**](ArtistsAPI.md#artistspost) | **POST** /artists | Create single artist.


# **artistsGet**
```swift
    open class func artistsGet(countryCode: String? = nil, include: [String]? = nil, filterHandle: [String]? = nil, filterId: [String]? = nil, completion: @escaping (_ data: ArtistsMultiResourceDataDocument?, _ error: Error?) -> Void)
```

Get multiple artists.

Retrieves multiple artists by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: albums, biography, followers, following, owners, profileArt, radio, roles, similarArtists, trackProviders, tracks, videos (optional)
let filterHandle = ["inner_example"] // [String] | Artist handle (optional)
let filterId = ["inner_example"] // [String] | Artist id (optional)

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
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: albums, biography, followers, following, owners, profileArt, radio, roles, similarArtists, trackProviders, tracks, videos | [optional] 
 **filterHandle** | [**[String]**](String.md) | Artist handle | [optional] 
 **filterId** | [**[String]**](String.md) | Artist id | [optional] 

### Return type

[**ArtistsMultiResourceDataDocument**](ArtistsMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artistsIdGet**
```swift
    open class func artistsIdGet(id: String, countryCode: String? = nil, include: [String]? = nil, completion: @escaping (_ data: ArtistsSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single artist.

Retrieves single artist by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: albums, biography, followers, following, owners, profileArt, radio, roles, similarArtists, trackProviders, tracks, videos (optional)

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
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: albums, biography, followers, following, owners, profileArt, radio, roles, similarArtists, trackProviders, tracks, videos | [optional] 

### Return type

[**ArtistsSingleResourceDataDocument**](ArtistsSingleResourceDataDocument.md)

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
let artistUpdateBody = ArtistUpdateBody(data: ArtistUpdateBody_Data(attributes: ArtistUpdateBody_Data_Attributes(contributionsEnabled: false, contributionsSalesPitch: "contributionsSalesPitch_example", externalLinks: [External_Link_Payload(href: "href_example", meta: External_Link_Meta(type: "type_example"))], handle: "handle_example", name: "name_example"), id: "id_example", type: "type_example"), meta: ArtistUpdateBody_Meta(dryRun: false)) // ArtistUpdateBody |  (optional)

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
    open class func artistsIdRelationshipsAlbumsGet(id: String, pageCursor: String? = nil, countryCode: String? = nil, include: [String]? = nil, completion: @escaping (_ data: ArtistsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get albums relationship (\"to-many\").

Retrieves albums relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist id
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: albums (optional)

// Get albums relationship (\"to-many\").
ArtistsAPI.artistsIdRelationshipsAlbumsGet(id: id, pageCursor: pageCursor, countryCode: countryCode, include: include) { (response, error) in
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
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: albums | [optional] 

### Return type

[**ArtistsMultiRelationshipDataDocument**](ArtistsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artistsIdRelationshipsBiographyGet**
```swift
    open class func artistsIdRelationshipsBiographyGet(id: String, countryCode: String? = nil, include: [String]? = nil, completion: @escaping (_ data: ArtistsSingleRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get biography relationship (\"to-one\").

Retrieves biography relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: biography (optional)

// Get biography relationship (\"to-one\").
ArtistsAPI.artistsIdRelationshipsBiographyGet(id: id, countryCode: countryCode, include: include) { (response, error) in
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
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: biography | [optional] 

### Return type

[**ArtistsSingleRelationshipDataDocument**](ArtistsSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artistsIdRelationshipsFollowersGet**
```swift
    open class func artistsIdRelationshipsFollowersGet(id: String, viewerContext: String? = nil, pageCursor: String? = nil, include: [String]? = nil, completion: @escaping (_ data: ArtistsFollowersMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get followers relationship (\"to-many\").

Retrieves followers relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist id
let viewerContext = "viewerContext_example" // String |  (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: followers (optional)

// Get followers relationship (\"to-many\").
ArtistsAPI.artistsIdRelationshipsFollowersGet(id: id, viewerContext: viewerContext, pageCursor: pageCursor, include: include) { (response, error) in
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
 **viewerContext** | **String** |  | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: followers | [optional] 

### Return type

[**ArtistsFollowersMultiRelationshipDataDocument**](ArtistsFollowersMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artistsIdRelationshipsFollowingDelete**
```swift
    open class func artistsIdRelationshipsFollowingDelete(id: String, artistFollowingRelationshipRemoveOperationPayload: ArtistFollowingRelationshipRemoveOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Delete from following relationship (\"to-many\").

Deletes item(s) from following relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist id
let artistFollowingRelationshipRemoveOperationPayload = ArtistFollowingRelationshipRemoveOperation_Payload(data: [ArtistFollowingRelationshipRemoveOperation_Payload_Data(id: "id_example", type: "type_example")]) // ArtistFollowingRelationshipRemoveOperationPayload |  (optional)

// Delete from following relationship (\"to-many\").
ArtistsAPI.artistsIdRelationshipsFollowingDelete(id: id, artistFollowingRelationshipRemoveOperationPayload: artistFollowingRelationshipRemoveOperationPayload) { (response, error) in
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
 **artistFollowingRelationshipRemoveOperationPayload** | [**ArtistFollowingRelationshipRemoveOperationPayload**](ArtistFollowingRelationshipRemoveOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artistsIdRelationshipsFollowingGet**
```swift
    open class func artistsIdRelationshipsFollowingGet(id: String, viewerContext: String? = nil, pageCursor: String? = nil, include: [String]? = nil, completion: @escaping (_ data: ArtistsFollowingMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get following relationship (\"to-many\").

Retrieves following relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist id
let viewerContext = "viewerContext_example" // String |  (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: following (optional)

// Get following relationship (\"to-many\").
ArtistsAPI.artistsIdRelationshipsFollowingGet(id: id, viewerContext: viewerContext, pageCursor: pageCursor, include: include) { (response, error) in
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
 **viewerContext** | **String** |  | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: following | [optional] 

### Return type

[**ArtistsFollowingMultiRelationshipDataDocument**](ArtistsFollowingMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artistsIdRelationshipsFollowingPost**
```swift
    open class func artistsIdRelationshipsFollowingPost(id: String, countryCode: String? = nil, artistFollowingRelationshipAddOperationPayload: ArtistFollowingRelationshipAddOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Add to following relationship (\"to-many\").

Adds item(s) to following relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let artistFollowingRelationshipAddOperationPayload = ArtistFollowingRelationshipAddOperation_Payload(data: [ArtistFollowingRelationshipAddOperation_Payload_Data(id: "id_example", type: "type_example")]) // ArtistFollowingRelationshipAddOperationPayload |  (optional)

// Add to following relationship (\"to-many\").
ArtistsAPI.artistsIdRelationshipsFollowingPost(id: id, countryCode: countryCode, artistFollowingRelationshipAddOperationPayload: artistFollowingRelationshipAddOperationPayload) { (response, error) in
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
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **artistFollowingRelationshipAddOperationPayload** | [**ArtistFollowingRelationshipAddOperationPayload**](ArtistFollowingRelationshipAddOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artistsIdRelationshipsOwnersGet**
```swift
    open class func artistsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: ArtistsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get owners relationship (\"to-many\").
ArtistsAPI.artistsIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor) { (response, error) in
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
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**ArtistsMultiRelationshipDataDocument**](ArtistsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artistsIdRelationshipsProfileArtGet**
```swift
    open class func artistsIdRelationshipsProfileArtGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: ArtistsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get profileArt relationship (\"to-many\").

Retrieves profileArt relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: profileArt (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get profileArt relationship (\"to-many\").
ArtistsAPI.artistsIdRelationshipsProfileArtGet(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor) { (response, error) in
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
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: profileArt | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**ArtistsMultiRelationshipDataDocument**](ArtistsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artistsIdRelationshipsProfileArtPatch**
```swift
    open class func artistsIdRelationshipsProfileArtPatch(id: String, artistProfileArtRelationshipUpdateOperationPayload: ArtistProfileArtRelationshipUpdateOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Update profileArt relationship (\"to-many\").

Updates profileArt relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist id
let artistProfileArtRelationshipUpdateOperationPayload = ArtistProfileArtRelationshipUpdateOperation_Payload(data: [ArtistProfileArtRelationshipUpdateOperation_Payload_Data(id: "id_example", type: "type_example")]) // ArtistProfileArtRelationshipUpdateOperationPayload |  (optional)

// Update profileArt relationship (\"to-many\").
ArtistsAPI.artistsIdRelationshipsProfileArtPatch(id: id, artistProfileArtRelationshipUpdateOperationPayload: artistProfileArtRelationshipUpdateOperationPayload) { (response, error) in
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
 **artistProfileArtRelationshipUpdateOperationPayload** | [**ArtistProfileArtRelationshipUpdateOperationPayload**](ArtistProfileArtRelationshipUpdateOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artistsIdRelationshipsRadioGet**
```swift
    open class func artistsIdRelationshipsRadioGet(id: String, pageCursor: String? = nil, countryCode: String? = nil, include: [String]? = nil, completion: @escaping (_ data: ArtistsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get radio relationship (\"to-many\").

Retrieves radio relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist id
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: radio (optional)

// Get radio relationship (\"to-many\").
ArtistsAPI.artistsIdRelationshipsRadioGet(id: id, pageCursor: pageCursor, countryCode: countryCode, include: include) { (response, error) in
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
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: radio | [optional] 

### Return type

[**ArtistsMultiRelationshipDataDocument**](ArtistsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artistsIdRelationshipsRolesGet**
```swift
    open class func artistsIdRelationshipsRolesGet(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: ArtistsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
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

[**ArtistsMultiRelationshipDataDocument**](ArtistsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artistsIdRelationshipsSimilarArtistsGet**
```swift
    open class func artistsIdRelationshipsSimilarArtistsGet(id: String, pageCursor: String? = nil, countryCode: String? = nil, include: [String]? = nil, completion: @escaping (_ data: ArtistsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get similarArtists relationship (\"to-many\").

Retrieves similarArtists relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist id
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: similarArtists (optional)

// Get similarArtists relationship (\"to-many\").
ArtistsAPI.artistsIdRelationshipsSimilarArtistsGet(id: id, pageCursor: pageCursor, countryCode: countryCode, include: include) { (response, error) in
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
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: similarArtists | [optional] 

### Return type

[**ArtistsMultiRelationshipDataDocument**](ArtistsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artistsIdRelationshipsTrackProvidersGet**
```swift
    open class func artistsIdRelationshipsTrackProvidersGet(id: String, pageCursor: String? = nil, include: [String]? = nil, completion: @escaping (_ data: ArtistsTrackProvidersMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get trackProviders relationship (\"to-many\").

Retrieves trackProviders relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist id
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: trackProviders (optional)

// Get trackProviders relationship (\"to-many\").
ArtistsAPI.artistsIdRelationshipsTrackProvidersGet(id: id, pageCursor: pageCursor, include: include) { (response, error) in
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
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: trackProviders | [optional] 

### Return type

[**ArtistsTrackProvidersMultiRelationshipDataDocument**](ArtistsTrackProvidersMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artistsIdRelationshipsTracksGet**
```swift
    open class func artistsIdRelationshipsTracksGet(id: String, collapseBy: CollapseBy_artistsIdRelationshipsTracksGet, pageCursor: String? = nil, countryCode: String? = nil, include: [String]? = nil, completion: @escaping (_ data: ArtistsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get tracks relationship (\"to-many\").

Retrieves tracks relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist id
let collapseBy = "collapseBy_example" // String | Collapse by options for getting artist tracks. Available options: FINGERPRINT, ID. FINGERPRINT option might collapse similar tracks based entry fingerprints while collapsing by ID always returns all available items.
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: tracks (optional)

// Get tracks relationship (\"to-many\").
ArtistsAPI.artistsIdRelationshipsTracksGet(id: id, collapseBy: collapseBy, pageCursor: pageCursor, countryCode: countryCode, include: include) { (response, error) in
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
 **collapseBy** | **String** | Collapse by options for getting artist tracks. Available options: FINGERPRINT, ID. FINGERPRINT option might collapse similar tracks based entry fingerprints while collapsing by ID always returns all available items. | 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: tracks | [optional] 

### Return type

[**ArtistsMultiRelationshipDataDocument**](ArtistsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artistsIdRelationshipsVideosGet**
```swift
    open class func artistsIdRelationshipsVideosGet(id: String, pageCursor: String? = nil, countryCode: String? = nil, include: [String]? = nil, completion: @escaping (_ data: ArtistsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get videos relationship (\"to-many\").

Retrieves videos relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist id
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: videos (optional)

// Get videos relationship (\"to-many\").
ArtistsAPI.artistsIdRelationshipsVideosGet(id: id, pageCursor: pageCursor, countryCode: countryCode, include: include) { (response, error) in
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
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: videos | [optional] 

### Return type

[**ArtistsMultiRelationshipDataDocument**](ArtistsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artistsPost**
```swift
    open class func artistsPost(artistCreateOperationPayload: ArtistCreateOperationPayload? = nil, completion: @escaping (_ data: ArtistsSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Create single artist.

Creates a new artist.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let artistCreateOperationPayload = ArtistCreateOperation_Payload(data: ArtistCreateOperation_Payload_Data(attributes: ArtistCreateOperation_Payload_Data_Attributes(handle: "handle_example", name: "name_example"), type: "type_example"), meta: ArtistCreateOperation_Meta(dryRun: false)) // ArtistCreateOperationPayload |  (optional)

// Create single artist.
ArtistsAPI.artistsPost(artistCreateOperationPayload: artistCreateOperationPayload) { (response, error) in
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
 **artistCreateOperationPayload** | [**ArtistCreateOperationPayload**](ArtistCreateOperationPayload.md) |  | [optional] 

### Return type

[**ArtistsSingleResourceDataDocument**](ArtistsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

