# ArtistsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**artistsGet**](ArtistsAPI.md#artistsget) | **GET** /artists | Get multiple artists.
[**artistsIdGet**](ArtistsAPI.md#artistsidget) | **GET** /artists/{id} | Get single artist.
[**artistsIdPatch**](ArtistsAPI.md#artistsidpatch) | **PATCH** /artists/{id} | Update single artist.
[**artistsIdRelationshipsAlbumsGet**](ArtistsAPI.md#artistsidrelationshipsalbumsget) | **GET** /artists/{id}/relationships/albums | Get albums relationship (\&quot;to-many\&quot;).
[**artistsIdRelationshipsBannerArtGet**](ArtistsAPI.md#artistsidrelationshipsbannerartget) | **GET** /artists/{id}/relationships/bannerArt | Get bannerArt relationship (\&quot;to-many\&quot;).
[**artistsIdRelationshipsBannerArtPatch**](ArtistsAPI.md#artistsidrelationshipsbannerartpatch) | **PATCH** /artists/{id}/relationships/bannerArt | Update bannerArt relationship (\&quot;to-many\&quot;).
[**artistsIdRelationshipsBiographyGet**](ArtistsAPI.md#artistsidrelationshipsbiographyget) | **GET** /artists/{id}/relationships/biography | Get biography relationship (\&quot;to-one\&quot;).
[**artistsIdRelationshipsClaimStatusGet**](ArtistsAPI.md#artistsidrelationshipsclaimstatusget) | **GET** /artists/{id}/relationships/claimStatus | Get claimStatus relationship (\&quot;to-one\&quot;).
[**artistsIdRelationshipsFollowersGet**](ArtistsAPI.md#artistsidrelationshipsfollowersget) | **GET** /artists/{id}/relationships/followers | Get followers relationship (\&quot;to-many\&quot;).
[**artistsIdRelationshipsFollowingDelete**](ArtistsAPI.md#artistsidrelationshipsfollowingdelete) | **DELETE** /artists/{id}/relationships/following | Delete from following relationship (\&quot;to-many\&quot;).
[**artistsIdRelationshipsFollowingGet**](ArtistsAPI.md#artistsidrelationshipsfollowingget) | **GET** /artists/{id}/relationships/following | Get following relationship (\&quot;to-many\&quot;).
[**artistsIdRelationshipsFollowingPost**](ArtistsAPI.md#artistsidrelationshipsfollowingpost) | **POST** /artists/{id}/relationships/following | Add to following relationship (\&quot;to-many\&quot;).
[**artistsIdRelationshipsLogoArtGet**](ArtistsAPI.md#artistsidrelationshipslogoartget) | **GET** /artists/{id}/relationships/logoArt | Get logoArt relationship (\&quot;to-many\&quot;).
[**artistsIdRelationshipsLogoArtPatch**](ArtistsAPI.md#artistsidrelationshipslogoartpatch) | **PATCH** /artists/{id}/relationships/logoArt | Update logoArt relationship (\&quot;to-many\&quot;).
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
    open class func artistsGet(countryCode: String? = nil, filterHandle: [String]? = nil, filterId: [String]? = nil, filterOwnersId: [String]? = nil, include: [String]? = nil, includeLinkage: [IncludeLinkage_artistsGet]? = nil, replaceMedia: String? = nil) async throws -> ArtistsMultiResourceDataDocument
```

Get multiple artists.

Retrieves multiple artists by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let filterHandle = ["inner_example"] // [String] | Artist handle (e.g. `jayz`) (optional)
let filterId = ["inner_example"] // [String] | List of artist IDs (e.g. `1566`) (optional)
let filterOwnersId = ["inner_example"] // [String] | User id. Also accepts `me`. (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: albums, bannerArt, biography, claimStatus, followers, following, logoArt, owners, profileArt, radio, roles, similarArtists, trackProviders, tracks, videos (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: albums (optional)

// Get multiple artists.
do {
    let response = try await ArtistsAPI.artistsGet(countryCode: countryCode, filterHandle: filterHandle, filterId: filterId, filterOwnersId: filterOwnersId, include: include, includeLinkage: includeLinkage, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **filterHandle** | [**[String]**](String.md) | Artist handle (e.g. &#x60;jayz&#x60;) | [optional] 
 **filterId** | [**[String]**](String.md) | List of artist IDs (e.g. &#x60;1566&#x60;) | [optional] 
 **filterOwnersId** | [**[String]**](String.md) | User id. Also accepts &#x60;me&#x60;. | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: albums, bannerArt, biography, claimStatus, followers, following, logoArt, owners, profileArt, radio, roles, similarArtists, trackProviders, tracks, videos | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: albums | [optional] 

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
    open class func artistsIdGet(id: String, countryCode: String? = nil, include: [String]? = nil, includeLinkage: [IncludeLinkage_artistsIdGet]? = nil, replaceMedia: String? = nil) async throws -> ArtistsSingleResourceDataDocument
```

Get single artist.

Retrieves single artist by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: albums, bannerArt, biography, claimStatus, followers, following, logoArt, owners, profileArt, radio, roles, similarArtists, trackProviders, tracks, videos (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: albums (optional)

// Get single artist.
do {
    let response = try await ArtistsAPI.artistsIdGet(id: id, countryCode: countryCode, include: include, includeLinkage: includeLinkage, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Artist id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: albums, bannerArt, biography, claimStatus, followers, following, logoArt, owners, profileArt, radio, roles, similarArtists, trackProviders, tracks, videos | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: albums | [optional] 

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
    open class func artistsIdPatch(id: String, idempotencyKey: String? = nil, artistsUpdateOperationPayload: ArtistsUpdateOperationPayload? = nil) async throws -> MutationResponseDocument
```

Update single artist.

When both profile colours are available, they must have at least 3:1 contrast.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist id
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let artistsUpdateOperationPayload = ArtistsUpdateOperation_Payload(data: ArtistsUpdateOperation_Payload_Data(attributes: ArtistsUpdateOperation_Payload_Data_Attributes(backgroundColor: "backgroundColor_example", contributionsEnabled: false, contributionsSalesPitch: "contributionsSalesPitch_example", externalLinks: [External_Link_Payload(href: "href_example", meta: External_Link_Meta(type: "type_example"))], foregroundColor: "foregroundColor_example", handle: "handle_example", name: "name_example"), id: "id_example", type: "type_example"), meta: ArtistsUpdateOperation_Payload_Meta(dryRun: false)) // ArtistsUpdateOperationPayload |  (optional)

// Update single artist.
do {
    let response = try await ArtistsAPI.artistsIdPatch(id: id, idempotencyKey: idempotencyKey, artistsUpdateOperationPayload: artistsUpdateOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Artist id | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **artistsUpdateOperationPayload** | [**ArtistsUpdateOperationPayload**](ArtistsUpdateOperationPayload.md) |  | [optional] 

### Return type

[**MutationResponseDocument**](MutationResponseDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artistsIdRelationshipsAlbumsGet**
```swift
    open class func artistsIdRelationshipsAlbumsGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil) async throws -> ArtistsAlbumsMultiRelationshipDataDocument
```

Get albums relationship (\"to-many\").

Retrieves albums relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: albums (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: albums (optional)

// Get albums relationship (\"to-many\").
do {
    let response = try await ArtistsAPI.artistsIdRelationshipsAlbumsGet(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Artist id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: albums | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: albums | [optional] 

### Return type

[**ArtistsAlbumsMultiRelationshipDataDocument**](ArtistsAlbumsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artistsIdRelationshipsBannerArtGet**
```swift
    open class func artistsIdRelationshipsBannerArtGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil) async throws -> ArtistsBannerArtMultiRelationshipDataDocument
```

Get bannerArt relationship (\"to-many\").

Reads the selected header banner artwork.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: bannerArt (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get bannerArt relationship (\"to-many\").
do {
    let response = try await ArtistsAPI.artistsIdRelationshipsBannerArtGet(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Artist id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: bannerArt | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**ArtistsBannerArtMultiRelationshipDataDocument**](ArtistsBannerArtMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artistsIdRelationshipsBannerArtPatch**
```swift
    open class func artistsIdRelationshipsBannerArtPatch(id: String, idempotencyKey: String? = nil, artistsBannerArtRelationshipUpdateOperationPayload: ArtistsBannerArtRelationshipUpdateOperationPayload? = nil) async throws -> MutationResponseDocument
```

Update bannerArt relationship (\"to-many\").

Selects one owned, attachable IMAGE artwork by ID, replacing the selection. Empty data clears the selection; null data and more than one entry are rejected. Previous artwork no longer selected by profileArt, bannerArt or logoArt is soft-deleted unless system-managed. Returns an acknowledgement.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist id
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let artistsBannerArtRelationshipUpdateOperationPayload = ArtistsBannerArtRelationshipUpdateOperation_Payload(data: [ArtistsBannerArtRelationshipUpdateOperation_Payload_Data(id: "id_example", type: "type_example")], meta: AlbumsArtistsRelationshipUpdateOperation_Payload_meta(mode: "mode_example")) // ArtistsBannerArtRelationshipUpdateOperationPayload |  (optional)

// Update bannerArt relationship (\"to-many\").
do {
    let response = try await ArtistsAPI.artistsIdRelationshipsBannerArtPatch(id: id, idempotencyKey: idempotencyKey, artistsBannerArtRelationshipUpdateOperationPayload: artistsBannerArtRelationshipUpdateOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Artist id | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **artistsBannerArtRelationshipUpdateOperationPayload** | [**ArtistsBannerArtRelationshipUpdateOperationPayload**](ArtistsBannerArtRelationshipUpdateOperationPayload.md) |  | [optional] 

### Return type

[**MutationResponseDocument**](MutationResponseDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artistsIdRelationshipsBiographyGet**
```swift
    open class func artistsIdRelationshipsBiographyGet(id: String, countryCode: String? = nil, include: [String]? = nil) async throws -> ArtistsBiographySingleRelationshipDataDocument
```

Get biography relationship (\"to-one\").

Retrieves biography relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: biography (optional)

// Get biography relationship (\"to-one\").
do {
    let response = try await ArtistsAPI.artistsIdRelationshipsBiographyGet(id: id, countryCode: countryCode, include: include)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Artist id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: biography | [optional] 

### Return type

[**ArtistsBiographySingleRelationshipDataDocument**](ArtistsBiographySingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artistsIdRelationshipsClaimStatusGet**
```swift
    open class func artistsIdRelationshipsClaimStatusGet(id: String, include: [String]? = nil) async throws -> ArtistsClaimStatusSingleRelationshipDataDocument
```

Get claimStatus relationship (\"to-one\").

Retrieves claimStatus relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: claimStatus (optional)

// Get claimStatus relationship (\"to-one\").
do {
    let response = try await ArtistsAPI.artistsIdRelationshipsClaimStatusGet(id: id, include: include)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Artist id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: claimStatus | [optional] 

### Return type

[**ArtistsClaimStatusSingleRelationshipDataDocument**](ArtistsClaimStatusSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artistsIdRelationshipsFollowersGet**
```swift
    open class func artistsIdRelationshipsFollowersGet(id: String, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil, viewerContext: String? = nil) async throws -> ArtistsFollowersMultiRelationshipDataDocument
```

Get followers relationship (\"to-many\").

Retrieves followers relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: followers (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: followers.albums (optional)
let viewerContext = "viewerContext_example" // String |  (optional)

// Get followers relationship (\"to-many\").
do {
    let response = try await ArtistsAPI.artistsIdRelationshipsFollowersGet(id: id, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia, viewerContext: viewerContext)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Artist id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: followers | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: followers.albums | [optional] 
 **viewerContext** | **String** |  | [optional] 

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
    open class func artistsIdRelationshipsFollowingDelete(id: String, idempotencyKey: String? = nil, artistsFollowingRelationshipRemoveOperationPayload: ArtistsFollowingRelationshipRemoveOperationPayload? = nil) async throws -> MutationResponseDocument
```

Delete from following relationship (\"to-many\").

Deletes item(s) from following relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist id
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let artistsFollowingRelationshipRemoveOperationPayload = ArtistsFollowingRelationshipRemoveOperation_Payload(data: [ArtistsFollowingRelationshipRemoveOperation_Payload_Data(id: "id_example", type: "type_example")]) // ArtistsFollowingRelationshipRemoveOperationPayload |  (optional)

// Delete from following relationship (\"to-many\").
do {
    let response = try await ArtistsAPI.artistsIdRelationshipsFollowingDelete(id: id, idempotencyKey: idempotencyKey, artistsFollowingRelationshipRemoveOperationPayload: artistsFollowingRelationshipRemoveOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Artist id | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **artistsFollowingRelationshipRemoveOperationPayload** | [**ArtistsFollowingRelationshipRemoveOperationPayload**](ArtistsFollowingRelationshipRemoveOperationPayload.md) |  | [optional] 

### Return type

[**MutationResponseDocument**](MutationResponseDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artistsIdRelationshipsFollowingGet**
```swift
    open class func artistsIdRelationshipsFollowingGet(id: String, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil, viewerContext: String? = nil) async throws -> ArtistsFollowingMultiRelationshipDataDocument
```

Get following relationship (\"to-many\").

Retrieves following relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: following (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: following.albums (optional)
let viewerContext = "viewerContext_example" // String |  (optional)

// Get following relationship (\"to-many\").
do {
    let response = try await ArtistsAPI.artistsIdRelationshipsFollowingGet(id: id, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia, viewerContext: viewerContext)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Artist id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: following | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: following.albums | [optional] 
 **viewerContext** | **String** |  | [optional] 

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
    open class func artistsIdRelationshipsFollowingPost(id: String, idempotencyKey: String? = nil, artistsFollowingRelationshipAddOperationPayload: ArtistsFollowingRelationshipAddOperationPayload? = nil) async throws -> MutationResponseDocument
```

Add to following relationship (\"to-many\").

Adds item(s) to following relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist id
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let artistsFollowingRelationshipAddOperationPayload = ArtistsFollowingRelationshipAddOperation_Payload(data: [ArtistsFollowingRelationshipAddOperation_Payload_Data(id: "id_example", type: "type_example")]) // ArtistsFollowingRelationshipAddOperationPayload |  (optional)

// Add to following relationship (\"to-many\").
do {
    let response = try await ArtistsAPI.artistsIdRelationshipsFollowingPost(id: id, idempotencyKey: idempotencyKey, artistsFollowingRelationshipAddOperationPayload: artistsFollowingRelationshipAddOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Artist id | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **artistsFollowingRelationshipAddOperationPayload** | [**ArtistsFollowingRelationshipAddOperationPayload**](ArtistsFollowingRelationshipAddOperationPayload.md) |  | [optional] 

### Return type

[**MutationResponseDocument**](MutationResponseDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artistsIdRelationshipsLogoArtGet**
```swift
    open class func artistsIdRelationshipsLogoArtGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil) async throws -> ArtistsLogoArtMultiRelationshipDataDocument
```

Get logoArt relationship (\"to-many\").

Reads the selected logo artwork.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: logoArt (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get logoArt relationship (\"to-many\").
do {
    let response = try await ArtistsAPI.artistsIdRelationshipsLogoArtGet(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Artist id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: logoArt | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**ArtistsLogoArtMultiRelationshipDataDocument**](ArtistsLogoArtMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artistsIdRelationshipsLogoArtPatch**
```swift
    open class func artistsIdRelationshipsLogoArtPatch(id: String, idempotencyKey: String? = nil, artistsLogoArtRelationshipUpdateOperationPayload: ArtistsLogoArtRelationshipUpdateOperationPayload? = nil) async throws -> MutationResponseDocument
```

Update logoArt relationship (\"to-many\").

Selects one owned, attachable IMAGE artwork by ID, replacing the selection. Empty data clears the selection; null data and more than one entry are rejected. Previous artwork no longer selected by profileArt, bannerArt or logoArt is soft-deleted unless system-managed. Returns an acknowledgement.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist id
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let artistsLogoArtRelationshipUpdateOperationPayload = ArtistsLogoArtRelationshipUpdateOperation_Payload(data: [ArtistsLogoArtRelationshipUpdateOperation_Payload_Data(id: "id_example", type: "type_example")], meta: AlbumsArtistsRelationshipUpdateOperation_Payload_meta(mode: "mode_example")) // ArtistsLogoArtRelationshipUpdateOperationPayload |  (optional)

// Update logoArt relationship (\"to-many\").
do {
    let response = try await ArtistsAPI.artistsIdRelationshipsLogoArtPatch(id: id, idempotencyKey: idempotencyKey, artistsLogoArtRelationshipUpdateOperationPayload: artistsLogoArtRelationshipUpdateOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Artist id | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **artistsLogoArtRelationshipUpdateOperationPayload** | [**ArtistsLogoArtRelationshipUpdateOperationPayload**](ArtistsLogoArtRelationshipUpdateOperationPayload.md) |  | [optional] 

### Return type

[**MutationResponseDocument**](MutationResponseDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artistsIdRelationshipsOwnersGet**
```swift
    open class func artistsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> ArtistsOwnersMultiRelationshipDataDocument
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get owners relationship (\"to-many\").
do {
    let response = try await ArtistsAPI.artistsIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Artist id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**ArtistsOwnersMultiRelationshipDataDocument**](ArtistsOwnersMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artistsIdRelationshipsProfileArtGet**
```swift
    open class func artistsIdRelationshipsProfileArtGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil) async throws -> ArtistsProfileArtMultiRelationshipDataDocument
```

Get profileArt relationship (\"to-many\").

Reads the artist's avatar artwork.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: profileArt (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get profileArt relationship (\"to-many\").
do {
    let response = try await ArtistsAPI.artistsIdRelationshipsProfileArtGet(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Artist id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: profileArt | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**ArtistsProfileArtMultiRelationshipDataDocument**](ArtistsProfileArtMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artistsIdRelationshipsProfileArtPatch**
```swift
    open class func artistsIdRelationshipsProfileArtPatch(id: String, idempotencyKey: String? = nil, artistsProfileArtRelationshipUpdateOperationPayload: ArtistsProfileArtRelationshipUpdateOperationPayload? = nil) async throws -> MutationResponseDocument
```

Update profileArt relationship (\"to-many\").

Replaces the artist's uploaded avatar selection with one owned, attachable artwork. Empty data clears the uploaded selection; legacy pictures or album fallback artwork may still appear in profileArt. Previous artwork no longer selected by profileArt, bannerArt or logoArt is soft-deleted unless system-managed. Returns an acknowledgement.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist id
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let artistsProfileArtRelationshipUpdateOperationPayload = ArtistsProfileArtRelationshipUpdateOperation_Payload(data: [ArtistsProfileArtRelationshipUpdateOperation_Payload_Data(id: "id_example", type: "type_example")], meta: AlbumsArtistsRelationshipUpdateOperation_Payload_meta(mode: "mode_example")) // ArtistsProfileArtRelationshipUpdateOperationPayload |  (optional)

// Update profileArt relationship (\"to-many\").
do {
    let response = try await ArtistsAPI.artistsIdRelationshipsProfileArtPatch(id: id, idempotencyKey: idempotencyKey, artistsProfileArtRelationshipUpdateOperationPayload: artistsProfileArtRelationshipUpdateOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Artist id | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **artistsProfileArtRelationshipUpdateOperationPayload** | [**ArtistsProfileArtRelationshipUpdateOperationPayload**](ArtistsProfileArtRelationshipUpdateOperationPayload.md) |  | [optional] 

### Return type

[**MutationResponseDocument**](MutationResponseDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artistsIdRelationshipsRadioGet**
```swift
    open class func artistsIdRelationshipsRadioGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil) async throws -> ArtistsRadioMultiRelationshipDataDocument
```

Get radio relationship (\"to-many\").

Retrieves radio relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: radio (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: radio.items (optional)

// Get radio relationship (\"to-many\").
do {
    let response = try await ArtistsAPI.artistsIdRelationshipsRadioGet(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Artist id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: radio | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: radio.items | [optional] 

### Return type

[**ArtistsRadioMultiRelationshipDataDocument**](ArtistsRadioMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artistsIdRelationshipsRolesGet**
```swift
    open class func artistsIdRelationshipsRolesGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> ArtistsRolesMultiRelationshipDataDocument
```

Get roles relationship (\"to-many\").

Retrieves roles relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: roles (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get roles relationship (\"to-many\").
do {
    let response = try await ArtistsAPI.artistsIdRelationshipsRolesGet(id: id, include: include, pageCursor: pageCursor)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Artist id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: roles | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**ArtistsRolesMultiRelationshipDataDocument**](ArtistsRolesMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artistsIdRelationshipsSimilarArtistsGet**
```swift
    open class func artistsIdRelationshipsSimilarArtistsGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil) async throws -> ArtistsSimilarArtistsMultiRelationshipDataDocument
```

Get similarArtists relationship (\"to-many\").

Retrieves similarArtists relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: similarArtists (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: similarArtists.albums (optional)

// Get similarArtists relationship (\"to-many\").
do {
    let response = try await ArtistsAPI.artistsIdRelationshipsSimilarArtistsGet(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Artist id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: similarArtists | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: similarArtists.albums | [optional] 

### Return type

[**ArtistsSimilarArtistsMultiRelationshipDataDocument**](ArtistsSimilarArtistsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artistsIdRelationshipsTrackProvidersGet**
```swift
    open class func artistsIdRelationshipsTrackProvidersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> ArtistsTrackProvidersMultiRelationshipDataDocument
```

Get trackProviders relationship (\"to-many\").

Retrieves trackProviders relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: trackProviders (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get trackProviders relationship (\"to-many\").
do {
    let response = try await ArtistsAPI.artistsIdRelationshipsTrackProvidersGet(id: id, include: include, pageCursor: pageCursor)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Artist id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: trackProviders | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

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
    open class func artistsIdRelationshipsTracksGet(collapseBy: CollapseBy_artistsIdRelationshipsTracksGet, id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil) async throws -> ArtistsTracksMultiRelationshipDataDocument
```

Get tracks relationship (\"to-many\").

Retrieves tracks relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let collapseBy = "collapseBy_example" // String | Collapse by options for getting artist tracks. Available options: FINGERPRINT, ID. FINGERPRINT option might collapse similar tracks based entry fingerprints while collapsing by ID always returns all available items.
let id = "id_example" // String | Artist id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: tracks (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: tracks (optional)

// Get tracks relationship (\"to-many\").
do {
    let response = try await ArtistsAPI.artistsIdRelationshipsTracksGet(collapseBy: collapseBy, id: id, countryCode: countryCode, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **collapseBy** | **String** | Collapse by options for getting artist tracks. Available options: FINGERPRINT, ID. FINGERPRINT option might collapse similar tracks based entry fingerprints while collapsing by ID always returns all available items. | 
 **id** | **String** | Artist id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: tracks | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: tracks | [optional] 

### Return type

[**ArtistsTracksMultiRelationshipDataDocument**](ArtistsTracksMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artistsIdRelationshipsVideosGet**
```swift
    open class func artistsIdRelationshipsVideosGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil) async throws -> ArtistsVideosMultiRelationshipDataDocument
```

Get videos relationship (\"to-many\").

Retrieves videos relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: videos (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: videos (optional)

// Get videos relationship (\"to-many\").
do {
    let response = try await ArtistsAPI.artistsIdRelationshipsVideosGet(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Artist id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: videos | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: videos | [optional] 

### Return type

[**ArtistsVideosMultiRelationshipDataDocument**](ArtistsVideosMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artistsPost**
```swift
    open class func artistsPost(idempotencyKey: String? = nil, artistsCreateOperationPayload: ArtistsCreateOperationPayload? = nil) async throws -> MutationResponseDocument
```

Create single artist.

Creates a new artist.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let artistsCreateOperationPayload = ArtistsCreateOperation_Payload(data: ArtistsCreateOperation_Payload_Data(attributes: ArtistsCreateOperation_Payload_Data_Attributes(handle: "handle_example", name: "name_example"), type: "type_example"), meta: ArtistsCreateOperation_Payload_Meta(dryRun: false)) // ArtistsCreateOperationPayload |  (optional)

// Create single artist.
do {
    let response = try await ArtistsAPI.artistsPost(idempotencyKey: idempotencyKey, artistsCreateOperationPayload: artistsCreateOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **artistsCreateOperationPayload** | [**ArtistsCreateOperationPayload**](ArtistsCreateOperationPayload.md) |  | [optional] 

### Return type

[**MutationResponseDocument**](MutationResponseDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

