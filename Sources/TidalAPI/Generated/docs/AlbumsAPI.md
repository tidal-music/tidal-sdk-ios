# AlbumsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**albumsGet**](AlbumsAPI.md#albumsget) | **GET** /albums | Get multiple albums.
[**albumsIdDelete**](AlbumsAPI.md#albumsiddelete) | **DELETE** /albums/{id} | Delete single album.
[**albumsIdGet**](AlbumsAPI.md#albumsidget) | **GET** /albums/{id} | Get single album.
[**albumsIdPatch**](AlbumsAPI.md#albumsidpatch) | **PATCH** /albums/{id} | Update single album.
[**albumsIdRelationshipsAlbumStatisticsGet**](AlbumsAPI.md#albumsidrelationshipsalbumstatisticsget) | **GET** /albums/{id}/relationships/albumStatistics | Get albumStatistics relationship (\&quot;to-one\&quot;).
[**albumsIdRelationshipsArtistsGet**](AlbumsAPI.md#albumsidrelationshipsartistsget) | **GET** /albums/{id}/relationships/artists | Get artists relationship (\&quot;to-many\&quot;).
[**albumsIdRelationshipsCoverArtGet**](AlbumsAPI.md#albumsidrelationshipscoverartget) | **GET** /albums/{id}/relationships/coverArt | Get coverArt relationship (\&quot;to-many\&quot;).
[**albumsIdRelationshipsCoverArtPatch**](AlbumsAPI.md#albumsidrelationshipscoverartpatch) | **PATCH** /albums/{id}/relationships/coverArt | Update coverArt relationship (\&quot;to-many\&quot;).
[**albumsIdRelationshipsGenresGet**](AlbumsAPI.md#albumsidrelationshipsgenresget) | **GET** /albums/{id}/relationships/genres | Get genres relationship (\&quot;to-many\&quot;).
[**albumsIdRelationshipsItemsGet**](AlbumsAPI.md#albumsidrelationshipsitemsget) | **GET** /albums/{id}/relationships/items | Get items relationship (\&quot;to-many\&quot;).
[**albumsIdRelationshipsItemsPatch**](AlbumsAPI.md#albumsidrelationshipsitemspatch) | **PATCH** /albums/{id}/relationships/items | Update items relationship (\&quot;to-many\&quot;).
[**albumsIdRelationshipsOwnersGet**](AlbumsAPI.md#albumsidrelationshipsownersget) | **GET** /albums/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
[**albumsIdRelationshipsPriceConfigGet**](AlbumsAPI.md#albumsidrelationshipspriceconfigget) | **GET** /albums/{id}/relationships/priceConfig | Get priceConfig relationship (\&quot;to-one\&quot;).
[**albumsIdRelationshipsProvidersGet**](AlbumsAPI.md#albumsidrelationshipsprovidersget) | **GET** /albums/{id}/relationships/providers | Get providers relationship (\&quot;to-many\&quot;).
[**albumsIdRelationshipsReplacementGet**](AlbumsAPI.md#albumsidrelationshipsreplacementget) | **GET** /albums/{id}/relationships/replacement | Get replacement relationship (\&quot;to-one\&quot;).
[**albumsIdRelationshipsSharesGet**](AlbumsAPI.md#albumsidrelationshipssharesget) | **GET** /albums/{id}/relationships/shares | Get shares relationship (\&quot;to-many\&quot;).
[**albumsIdRelationshipsSimilarAlbumsGet**](AlbumsAPI.md#albumsidrelationshipssimilaralbumsget) | **GET** /albums/{id}/relationships/similarAlbums | Get similarAlbums relationship (\&quot;to-many\&quot;).
[**albumsIdRelationshipsSuggestedCoverArtsGet**](AlbumsAPI.md#albumsidrelationshipssuggestedcoverartsget) | **GET** /albums/{id}/relationships/suggestedCoverArts | Get suggestedCoverArts relationship (\&quot;to-many\&quot;).
[**albumsIdRelationshipsUsageRulesGet**](AlbumsAPI.md#albumsidrelationshipsusagerulesget) | **GET** /albums/{id}/relationships/usageRules | Get usageRules relationship (\&quot;to-one\&quot;).
[**albumsPost**](AlbumsAPI.md#albumspost) | **POST** /albums | Create single album.


# **albumsGet**
```swift
    open class func albumsGet(countryCode: String? = nil, filterBarcodeId: [String]? = nil, filterId: [String]? = nil, filterOwnersId: [String]? = nil, include: [String]? = nil, includeLinkage: [IncludeLinkage_albumsGet]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil, shareCode: String? = nil, sort: [Sort_albumsGet]? = nil) async throws -> AlbumsMultiResourceDataDocument
```

Get multiple albums.

Retrieves multiple albums by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let filterBarcodeId = ["inner_example"] // [String] | List of barcode IDs (EAN-13 or UPC-A). NOTE: Supplying more than one barcode ID will currently only return one album per barcode ID. (e.g. `196589525444`) (optional)
let filterId = ["inner_example"] // [String] | List of album IDs (e.g. `251380836`) (optional)
let filterOwnersId = ["inner_example"] // [String] | User id. Also accepts `me`. (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: albumStatistics, artists, coverArt, genres, items, owners, priceConfig, providers, replacement, shares, similarAlbums, suggestedCoverArts, usageRules (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: artists.albums (optional)
let shareCode = "shareCode_example" // String | Share code used as a bearer credential for the resource. (optional)
let sort = ["sort_example"] // [String] | Values prefixed with \"-\" are sorted descending; values without it are sorted ascending. (optional)

// Get multiple albums.
do {
    let response = try await AlbumsAPI.albumsGet(countryCode: countryCode, filterBarcodeId: filterBarcodeId, filterId: filterId, filterOwnersId: filterOwnersId, include: include, includeLinkage: includeLinkage, pageCursor: pageCursor, replaceMedia: replaceMedia, shareCode: shareCode, sort: sort)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **filterBarcodeId** | [**[String]**](String.md) | List of barcode IDs (EAN-13 or UPC-A). NOTE: Supplying more than one barcode ID will currently only return one album per barcode ID. (e.g. &#x60;196589525444&#x60;) | [optional] 
 **filterId** | [**[String]**](String.md) | List of album IDs (e.g. &#x60;251380836&#x60;) | [optional] 
 **filterOwnersId** | [**[String]**](String.md) | User id. Also accepts &#x60;me&#x60;. | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: albumStatistics, artists, coverArt, genres, items, owners, priceConfig, providers, replacement, shares, similarAlbums, suggestedCoverArts, usageRules | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: artists.albums | [optional] 
 **shareCode** | **String** | Share code used as a bearer credential for the resource. | [optional] 
 **sort** | [**[String]**](String.md) | Values prefixed with \&quot;-\&quot; are sorted descending; values without it are sorted ascending. | [optional] 

### Return type

[**AlbumsMultiResourceDataDocument**](AlbumsMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **albumsIdDelete**
```swift
    open class func albumsIdDelete(id: String, idempotencyKey: String? = nil, shareCode: String? = nil) async throws -> MutationResponseDocument
```

Delete single album.

Deletes existing album.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Album id
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let shareCode = "shareCode_example" // String | Share code used as a bearer credential for the resource. (optional)

// Delete single album.
do {
    let response = try await AlbumsAPI.albumsIdDelete(id: id, idempotencyKey: idempotencyKey, shareCode: shareCode)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Album id | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **shareCode** | **String** | Share code used as a bearer credential for the resource. | [optional] 

### Return type

[**MutationResponseDocument**](MutationResponseDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **albumsIdGet**
```swift
    open class func albumsIdGet(id: String, countryCode: String? = nil, include: [String]? = nil, includeLinkage: [IncludeLinkage_albumsIdGet]? = nil, replaceMedia: String? = nil, shareCode: String? = nil) async throws -> AlbumsSingleResourceDataDocument
```

Get single album.

Retrieves single album by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Album id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: albumStatistics, artists, coverArt, genres, items, owners, priceConfig, providers, replacement, shares, similarAlbums, suggestedCoverArts, usageRules (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: artists.albums (optional)
let shareCode = "shareCode_example" // String | Share code used as a bearer credential for the resource. (optional)

// Get single album.
do {
    let response = try await AlbumsAPI.albumsIdGet(id: id, countryCode: countryCode, include: include, includeLinkage: includeLinkage, replaceMedia: replaceMedia, shareCode: shareCode)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Album id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: albumStatistics, artists, coverArt, genres, items, owners, priceConfig, providers, replacement, shares, similarAlbums, suggestedCoverArts, usageRules | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: artists.albums | [optional] 
 **shareCode** | **String** | Share code used as a bearer credential for the resource. | [optional] 

### Return type

[**AlbumsSingleResourceDataDocument**](AlbumsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **albumsIdPatch**
```swift
    open class func albumsIdPatch(id: String, idempotencyKey: String? = nil, shareCode: String? = nil, albumsUpdateOperationPayload: AlbumsUpdateOperationPayload? = nil) async throws -> MutationResponseDocument
```

Update single album.

Updates existing album.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Album id
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let shareCode = "shareCode_example" // String | Share code used as a bearer credential for the resource. (optional)
let albumsUpdateOperationPayload = AlbumsUpdateOperation_Payload(data: AlbumsUpdateOperation_Payload_Data(attributes: AlbumsUpdateOperation_Payload_Data_Attributes(accessType: "accessType_example", albumType: "albumType_example", barcodeId: "barcodeId_example", copyright: Copyright(text: "text_example"), explicit: false, explicitLyrics: false, releaseDate: Date(), title: "title_example", version: "version_example"), id: "id_example", relationships: AlbumsUpdateOperation_Payload_Data_Relationships(genres: AlbumsUpdateOperation_Payload_Data_Relationships_Genres(data: [AlbumsUpdateOperation_Payload_Data_Relationships_Genres_Data(id: "id_example", type: "type_example")])), type: "type_example")) // AlbumsUpdateOperationPayload |  (optional)

// Update single album.
do {
    let response = try await AlbumsAPI.albumsIdPatch(id: id, idempotencyKey: idempotencyKey, shareCode: shareCode, albumsUpdateOperationPayload: albumsUpdateOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Album id | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **shareCode** | **String** | Share code used as a bearer credential for the resource. | [optional] 
 **albumsUpdateOperationPayload** | [**AlbumsUpdateOperationPayload**](AlbumsUpdateOperationPayload.md) |  | [optional] 

### Return type

[**MutationResponseDocument**](MutationResponseDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **albumsIdRelationshipsAlbumStatisticsGet**
```swift
    open class func albumsIdRelationshipsAlbumStatisticsGet(id: String, include: [String]? = nil, shareCode: String? = nil) async throws -> AlbumsAlbumStatisticsSingleRelationshipDataDocument
```

Get albumStatistics relationship (\"to-one\").

Retrieves albumStatistics relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Album id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: albumStatistics (optional)
let shareCode = "shareCode_example" // String | Share code used as a bearer credential for the resource. (optional)

// Get albumStatistics relationship (\"to-one\").
do {
    let response = try await AlbumsAPI.albumsIdRelationshipsAlbumStatisticsGet(id: id, include: include, shareCode: shareCode)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Album id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: albumStatistics | [optional] 
 **shareCode** | **String** | Share code used as a bearer credential for the resource. | [optional] 

### Return type

[**AlbumsAlbumStatisticsSingleRelationshipDataDocument**](AlbumsAlbumStatisticsSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **albumsIdRelationshipsArtistsGet**
```swift
    open class func albumsIdRelationshipsArtistsGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil, shareCode: String? = nil) async throws -> AlbumsArtistsMultiRelationshipDataDocument
```

Get artists relationship (\"to-many\").

Retrieves artists relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Album id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: artists (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: artists.albums (optional)
let shareCode = "shareCode_example" // String | Share code used as a bearer credential for the resource. (optional)

// Get artists relationship (\"to-many\").
do {
    let response = try await AlbumsAPI.albumsIdRelationshipsArtistsGet(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia, shareCode: shareCode)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Album id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: artists | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: artists.albums | [optional] 
 **shareCode** | **String** | Share code used as a bearer credential for the resource. | [optional] 

### Return type

[**AlbumsArtistsMultiRelationshipDataDocument**](AlbumsArtistsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **albumsIdRelationshipsCoverArtGet**
```swift
    open class func albumsIdRelationshipsCoverArtGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil, shareCode: String? = nil) async throws -> AlbumsCoverArtMultiRelationshipDataDocument
```

Get coverArt relationship (\"to-many\").

Retrieves coverArt relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Album id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: coverArt (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let shareCode = "shareCode_example" // String | Share code used as a bearer credential for the resource. (optional)

// Get coverArt relationship (\"to-many\").
do {
    let response = try await AlbumsAPI.albumsIdRelationshipsCoverArtGet(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor, shareCode: shareCode)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Album id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: coverArt | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **shareCode** | **String** | Share code used as a bearer credential for the resource. | [optional] 

### Return type

[**AlbumsCoverArtMultiRelationshipDataDocument**](AlbumsCoverArtMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **albumsIdRelationshipsCoverArtPatch**
```swift
    open class func albumsIdRelationshipsCoverArtPatch(id: String, idempotencyKey: String? = nil, shareCode: String? = nil, albumsCoverArtRelationshipUpdateOperationPayload: AlbumsCoverArtRelationshipUpdateOperationPayload? = nil) async throws -> MutationResponseDocument
```

Update coverArt relationship (\"to-many\").

Replaces the uploaded cover artwork selection with one attachable artwork. Empty data clears the selection. Previously attached uploaded artwork is soft-deleted unless system-managed. Returns an acknowledgement.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Album id
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let shareCode = "shareCode_example" // String | Share code used as a bearer credential for the resource. (optional)
let albumsCoverArtRelationshipUpdateOperationPayload = AlbumsCoverArtRelationshipUpdateOperation_Payload(data: [AlbumsCoverArtRelationshipUpdateOperation_Payload_Data(id: "id_example", type: "type_example")], meta: AlbumsCoverArtRelationshipUpdateOperation_Payload_meta(mode: "mode_example")) // AlbumsCoverArtRelationshipUpdateOperationPayload |  (optional)

// Update coverArt relationship (\"to-many\").
do {
    let response = try await AlbumsAPI.albumsIdRelationshipsCoverArtPatch(id: id, idempotencyKey: idempotencyKey, shareCode: shareCode, albumsCoverArtRelationshipUpdateOperationPayload: albumsCoverArtRelationshipUpdateOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Album id | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **shareCode** | **String** | Share code used as a bearer credential for the resource. | [optional] 
 **albumsCoverArtRelationshipUpdateOperationPayload** | [**AlbumsCoverArtRelationshipUpdateOperationPayload**](AlbumsCoverArtRelationshipUpdateOperationPayload.md) |  | [optional] 

### Return type

[**MutationResponseDocument**](MutationResponseDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **albumsIdRelationshipsGenresGet**
```swift
    open class func albumsIdRelationshipsGenresGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil, shareCode: String? = nil) async throws -> AlbumsGenresMultiRelationshipDataDocument
```

Get genres relationship (\"to-many\").

Retrieves genres relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Album id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: genres (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let shareCode = "shareCode_example" // String | Share code used as a bearer credential for the resource. (optional)

// Get genres relationship (\"to-many\").
do {
    let response = try await AlbumsAPI.albumsIdRelationshipsGenresGet(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor, shareCode: shareCode)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Album id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: genres | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **shareCode** | **String** | Share code used as a bearer credential for the resource. | [optional] 

### Return type

[**AlbumsGenresMultiRelationshipDataDocument**](AlbumsGenresMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **albumsIdRelationshipsItemsGet**
```swift
    open class func albumsIdRelationshipsItemsGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil, shareCode: String? = nil) async throws -> AlbumsItemsMultiRelationshipDataDocument
```

Get items relationship (\"to-many\").

Retrieves items relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Album id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: items (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: items (optional)
let shareCode = "shareCode_example" // String | Share code used as a bearer credential for the resource. (optional)

// Get items relationship (\"to-many\").
do {
    let response = try await AlbumsAPI.albumsIdRelationshipsItemsGet(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia, shareCode: shareCode)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Album id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: items | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: items | [optional] 
 **shareCode** | **String** | Share code used as a bearer credential for the resource. | [optional] 

### Return type

[**AlbumsItemsMultiRelationshipDataDocument**](AlbumsItemsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **albumsIdRelationshipsItemsPatch**
```swift
    open class func albumsIdRelationshipsItemsPatch(id: String, idempotencyKey: String? = nil, shareCode: String? = nil, albumsItemsRelationshipUpdateOperationPayload: AlbumsItemsRelationshipUpdateOperationPayload? = nil) async throws -> MutationResponseDocument
```

Update items relationship (\"to-many\").

Incrementally updates one existing track's 1-based track number to meta.positionIndex. Does not replace the album's items or add or remove tracks. Empty data is rejected. Returns an acknowledgement.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Album id
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let shareCode = "shareCode_example" // String | Share code used as a bearer credential for the resource. (optional)
let albumsItemsRelationshipUpdateOperationPayload = AlbumsItemsRelationshipUpdateOperation_Payload(data: [AlbumsItemsRelationshipUpdateOperation_Payload_Data(id: "id_example", type: "type_example")], meta: AlbumsItemsRelationshipUpdateOperation_Payload_meta(mode: "mode_example", positionIndex: 123)) // AlbumsItemsRelationshipUpdateOperationPayload |  (optional)

// Update items relationship (\"to-many\").
do {
    let response = try await AlbumsAPI.albumsIdRelationshipsItemsPatch(id: id, idempotencyKey: idempotencyKey, shareCode: shareCode, albumsItemsRelationshipUpdateOperationPayload: albumsItemsRelationshipUpdateOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Album id | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **shareCode** | **String** | Share code used as a bearer credential for the resource. | [optional] 
 **albumsItemsRelationshipUpdateOperationPayload** | [**AlbumsItemsRelationshipUpdateOperationPayload**](AlbumsItemsRelationshipUpdateOperationPayload.md) |  | [optional] 

### Return type

[**MutationResponseDocument**](MutationResponseDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **albumsIdRelationshipsOwnersGet**
```swift
    open class func albumsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil, shareCode: String? = nil) async throws -> AlbumsOwnersMultiRelationshipDataDocument
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Album id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let shareCode = "shareCode_example" // String | Share code used as a bearer credential for the resource. (optional)

// Get owners relationship (\"to-many\").
do {
    let response = try await AlbumsAPI.albumsIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor, shareCode: shareCode)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Album id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **shareCode** | **String** | Share code used as a bearer credential for the resource. | [optional] 

### Return type

[**AlbumsOwnersMultiRelationshipDataDocument**](AlbumsOwnersMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **albumsIdRelationshipsPriceConfigGet**
```swift
    open class func albumsIdRelationshipsPriceConfigGet(id: String, countryCode: String? = nil, include: [String]? = nil, shareCode: String? = nil) async throws -> AlbumsPriceConfigSingleRelationshipDataDocument
```

Get priceConfig relationship (\"to-one\").

Retrieves priceConfig relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Album id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: priceConfig (optional)
let shareCode = "shareCode_example" // String | Share code used as a bearer credential for the resource. (optional)

// Get priceConfig relationship (\"to-one\").
do {
    let response = try await AlbumsAPI.albumsIdRelationshipsPriceConfigGet(id: id, countryCode: countryCode, include: include, shareCode: shareCode)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Album id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: priceConfig | [optional] 
 **shareCode** | **String** | Share code used as a bearer credential for the resource. | [optional] 

### Return type

[**AlbumsPriceConfigSingleRelationshipDataDocument**](AlbumsPriceConfigSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **albumsIdRelationshipsProvidersGet**
```swift
    open class func albumsIdRelationshipsProvidersGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil, shareCode: String? = nil) async throws -> AlbumsProvidersMultiRelationshipDataDocument
```

Get providers relationship (\"to-many\").

Retrieves providers relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Album id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: providers (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let shareCode = "shareCode_example" // String | Share code used as a bearer credential for the resource. (optional)

// Get providers relationship (\"to-many\").
do {
    let response = try await AlbumsAPI.albumsIdRelationshipsProvidersGet(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor, shareCode: shareCode)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Album id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: providers | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **shareCode** | **String** | Share code used as a bearer credential for the resource. | [optional] 

### Return type

[**AlbumsProvidersMultiRelationshipDataDocument**](AlbumsProvidersMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **albumsIdRelationshipsReplacementGet**
```swift
    open class func albumsIdRelationshipsReplacementGet(id: String, countryCode: String? = nil, include: [String]? = nil, replaceMedia: String? = nil, shareCode: String? = nil) async throws -> AlbumsReplacementSingleRelationshipDataDocument
```

Get replacement relationship (\"to-one\").

Retrieves replacement relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Album id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: replacement (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: replacement (optional)
let shareCode = "shareCode_example" // String | Share code used as a bearer credential for the resource. (optional)

// Get replacement relationship (\"to-one\").
do {
    let response = try await AlbumsAPI.albumsIdRelationshipsReplacementGet(id: id, countryCode: countryCode, include: include, replaceMedia: replaceMedia, shareCode: shareCode)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Album id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: replacement | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: replacement | [optional] 
 **shareCode** | **String** | Share code used as a bearer credential for the resource. | [optional] 

### Return type

[**AlbumsReplacementSingleRelationshipDataDocument**](AlbumsReplacementSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **albumsIdRelationshipsSharesGet**
```swift
    open class func albumsIdRelationshipsSharesGet(id: String, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil, shareCode: String? = nil) async throws -> AlbumsSharesMultiRelationshipDataDocument
```

Get shares relationship (\"to-many\").

The album's share links, active and expired, newest first.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Album id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: shares (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: shares.sharedResources (optional)
let shareCode = "shareCode_example" // String | Share code used as a bearer credential for the resource. (optional)

// Get shares relationship (\"to-many\").
do {
    let response = try await AlbumsAPI.albumsIdRelationshipsSharesGet(id: id, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia, shareCode: shareCode)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Album id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: shares | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: shares.sharedResources | [optional] 
 **shareCode** | **String** | Share code used as a bearer credential for the resource. | [optional] 

### Return type

[**AlbumsSharesMultiRelationshipDataDocument**](AlbumsSharesMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **albumsIdRelationshipsSimilarAlbumsGet**
```swift
    open class func albumsIdRelationshipsSimilarAlbumsGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil, shareCode: String? = nil) async throws -> AlbumsSimilarAlbumsMultiRelationshipDataDocument
```

Get similarAlbums relationship (\"to-many\").

Retrieves similarAlbums relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Album id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: similarAlbums (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: similarAlbums (optional)
let shareCode = "shareCode_example" // String | Share code used as a bearer credential for the resource. (optional)

// Get similarAlbums relationship (\"to-many\").
do {
    let response = try await AlbumsAPI.albumsIdRelationshipsSimilarAlbumsGet(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia, shareCode: shareCode)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Album id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: similarAlbums | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: similarAlbums | [optional] 
 **shareCode** | **String** | Share code used as a bearer credential for the resource. | [optional] 

### Return type

[**AlbumsSimilarAlbumsMultiRelationshipDataDocument**](AlbumsSimilarAlbumsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **albumsIdRelationshipsSuggestedCoverArtsGet**
```swift
    open class func albumsIdRelationshipsSuggestedCoverArtsGet(id: String, include: [String]? = nil, pageCursor: String? = nil, shareCode: String? = nil) async throws -> AlbumsSuggestedCoverArtsMultiRelationshipDataDocument
```

Get suggestedCoverArts relationship (\"to-many\").

Retrieves suggestedCoverArts relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Album id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: suggestedCoverArts (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let shareCode = "shareCode_example" // String | Share code used as a bearer credential for the resource. (optional)

// Get suggestedCoverArts relationship (\"to-many\").
do {
    let response = try await AlbumsAPI.albumsIdRelationshipsSuggestedCoverArtsGet(id: id, include: include, pageCursor: pageCursor, shareCode: shareCode)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Album id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: suggestedCoverArts | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **shareCode** | **String** | Share code used as a bearer credential for the resource. | [optional] 

### Return type

[**AlbumsSuggestedCoverArtsMultiRelationshipDataDocument**](AlbumsSuggestedCoverArtsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **albumsIdRelationshipsUsageRulesGet**
```swift
    open class func albumsIdRelationshipsUsageRulesGet(id: String, countryCode: String? = nil, include: [String]? = nil, shareCode: String? = nil) async throws -> AlbumsUsageRulesSingleRelationshipDataDocument
```

Get usageRules relationship (\"to-one\").

Retrieves usageRules relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Album id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: usageRules (optional)
let shareCode = "shareCode_example" // String | Share code used as a bearer credential for the resource. (optional)

// Get usageRules relationship (\"to-one\").
do {
    let response = try await AlbumsAPI.albumsIdRelationshipsUsageRulesGet(id: id, countryCode: countryCode, include: include, shareCode: shareCode)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Album id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: usageRules | [optional] 
 **shareCode** | **String** | Share code used as a bearer credential for the resource. | [optional] 

### Return type

[**AlbumsUsageRulesSingleRelationshipDataDocument**](AlbumsUsageRulesSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **albumsPost**
```swift
    open class func albumsPost(idempotencyKey: String? = nil, albumsCreateOperationPayload: AlbumsCreateOperationPayload? = nil) async throws -> AlbumsCreateSingleResourceDataDocument
```

Create single album.

Creates a new album.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let albumsCreateOperationPayload = AlbumsCreateOperation_Payload(data: AlbumsCreateOperation_Payload_Data(attributes: AlbumsCreateOperation_Payload_Data_Attributes(albumType: "albumType_example", copyright: Copyright(text: "text_example"), explicit: false, explicitLyrics: false, releaseDate: Date(), title: "title_example", version: "version_example"), relationships: AlbumsCreateOperation_Payload_Data_Relationships(artists: AlbumsCreateOperation_Payload_Data_Relationships_Artists(data: [AlbumsCreateOperation_Payload_Data_Relationships_Artists_Data(id: "id_example", type: "type_example")]), genres: AlbumsCreateOperation_Payload_Data_Relationships_Genres(data: [AlbumsCreateOperation_Payload_Data_Relationships_Genres_Data(id: "id_example", type: "type_example")])), type: "type_example")) // AlbumsCreateOperationPayload |  (optional)

// Create single album.
do {
    let response = try await AlbumsAPI.albumsPost(idempotencyKey: idempotencyKey, albumsCreateOperationPayload: albumsCreateOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **albumsCreateOperationPayload** | [**AlbumsCreateOperationPayload**](AlbumsCreateOperationPayload.md) |  | [optional] 

### Return type

[**AlbumsCreateSingleResourceDataDocument**](AlbumsCreateSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

