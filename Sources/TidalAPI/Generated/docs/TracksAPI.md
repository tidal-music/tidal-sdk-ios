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
[**tracksIdRelationshipsDownloadGet**](TracksAPI.md#tracksidrelationshipsdownloadget) | **GET** /tracks/{id}/relationships/download | Get download relationship (\&quot;to-one\&quot;).
[**tracksIdRelationshipsGenresGet**](TracksAPI.md#tracksidrelationshipsgenresget) | **GET** /tracks/{id}/relationships/genres | Get genres relationship (\&quot;to-many\&quot;).
[**tracksIdRelationshipsLyricsGet**](TracksAPI.md#tracksidrelationshipslyricsget) | **GET** /tracks/{id}/relationships/lyrics | Get lyrics relationship (\&quot;to-many\&quot;).
[**tracksIdRelationshipsMetadataStatusGet**](TracksAPI.md#tracksidrelationshipsmetadatastatusget) | **GET** /tracks/{id}/relationships/metadataStatus | Get metadataStatus relationship (\&quot;to-one\&quot;).
[**tracksIdRelationshipsOwnersGet**](TracksAPI.md#tracksidrelationshipsownersget) | **GET** /tracks/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
[**tracksIdRelationshipsPriceConfigGet**](TracksAPI.md#tracksidrelationshipspriceconfigget) | **GET** /tracks/{id}/relationships/priceConfig | Get priceConfig relationship (\&quot;to-one\&quot;).
[**tracksIdRelationshipsProvidersGet**](TracksAPI.md#tracksidrelationshipsprovidersget) | **GET** /tracks/{id}/relationships/providers | Get providers relationship (\&quot;to-many\&quot;).
[**tracksIdRelationshipsRadioGet**](TracksAPI.md#tracksidrelationshipsradioget) | **GET** /tracks/{id}/relationships/radio | Get radio relationship (\&quot;to-many\&quot;).
[**tracksIdRelationshipsReplacementGet**](TracksAPI.md#tracksidrelationshipsreplacementget) | **GET** /tracks/{id}/relationships/replacement | Get replacement relationship (\&quot;to-one\&quot;).
[**tracksIdRelationshipsSharesGet**](TracksAPI.md#tracksidrelationshipssharesget) | **GET** /tracks/{id}/relationships/shares | Get shares relationship (\&quot;to-many\&quot;).
[**tracksIdRelationshipsSimilarTracksGet**](TracksAPI.md#tracksidrelationshipssimilartracksget) | **GET** /tracks/{id}/relationships/similarTracks | Get similarTracks relationship (\&quot;to-many\&quot;).
[**tracksIdRelationshipsSourceFileGet**](TracksAPI.md#tracksidrelationshipssourcefileget) | **GET** /tracks/{id}/relationships/sourceFile | Get sourceFile relationship (\&quot;to-one\&quot;).
[**tracksIdRelationshipsSuggestedTracksGet**](TracksAPI.md#tracksidrelationshipssuggestedtracksget) | **GET** /tracks/{id}/relationships/suggestedTracks | Get suggestedTracks relationship (\&quot;to-many\&quot;).
[**tracksIdRelationshipsTrackStatisticsGet**](TracksAPI.md#tracksidrelationshipstrackstatisticsget) | **GET** /tracks/{id}/relationships/trackStatistics | Get trackStatistics relationship (\&quot;to-one\&quot;).
[**tracksIdRelationshipsUsageRulesGet**](TracksAPI.md#tracksidrelationshipsusagerulesget) | **GET** /tracks/{id}/relationships/usageRules | Get usageRules relationship (\&quot;to-one\&quot;).
[**tracksPost**](TracksAPI.md#trackspost) | **POST** /tracks | Create single track.


# **tracksGet**
```swift
    open class func tracksGet(countryCode: String? = nil, filterId: [String]? = nil, filterIsrc: [String]? = nil, filterOwnersId: [String]? = nil, include: [String]? = nil, includeLinkage: [IncludeLinkage_tracksGet]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil, shareCode: String? = nil, sort: [Sort_tracksGet]? = nil) async throws -> TracksMultiResourceDataDocument
```

Get multiple tracks.

Retrieves multiple tracks by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let filterId = ["inner_example"] // [String] | List of track IDs (e.g. `75413016`) (optional)
let filterIsrc = ["inner_example"] // [String] | List of ISRCs. When a single ISRC is provided, pagination is supported and multiple tracks may be returned. When multiple ISRCs are provided, one track per ISRC is returned without pagination. (e.g. `QMJMT1701237`) (optional)
let filterOwnersId = ["inner_example"] // [String] | User id. Also accepts `me`. (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: albums, artists, credits, download, genres, lyrics, metadataStatus, owners, priceConfig, providers, radio, replacement, shares, similarTracks, sourceFile, suggestedTracks, trackStatistics, usageRules (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: albums (optional)
let shareCode = "shareCode_example" // String | Share code used as a bearer credential for the resource. (optional)
let sort = ["sort_example"] // [String] | Values prefixed with \"-\" are sorted descending; values without it are sorted ascending. (optional)

// Get multiple tracks.
do {
    let response = try await TracksAPI.tracksGet(countryCode: countryCode, filterId: filterId, filterIsrc: filterIsrc, filterOwnersId: filterOwnersId, include: include, includeLinkage: includeLinkage, pageCursor: pageCursor, replaceMedia: replaceMedia, shareCode: shareCode, sort: sort)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **filterId** | [**[String]**](String.md) | List of track IDs (e.g. &#x60;75413016&#x60;) | [optional] 
 **filterIsrc** | [**[String]**](String.md) | List of ISRCs. When a single ISRC is provided, pagination is supported and multiple tracks may be returned. When multiple ISRCs are provided, one track per ISRC is returned without pagination. (e.g. &#x60;QMJMT1701237&#x60;) | [optional] 
 **filterOwnersId** | [**[String]**](String.md) | User id. Also accepts &#x60;me&#x60;. | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: albums, artists, credits, download, genres, lyrics, metadataStatus, owners, priceConfig, providers, radio, replacement, shares, similarTracks, sourceFile, suggestedTracks, trackStatistics, usageRules | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: albums | [optional] 
 **shareCode** | **String** | Share code used as a bearer credential for the resource. | [optional] 
 **sort** | [**[String]**](String.md) | Values prefixed with \&quot;-\&quot; are sorted descending; values without it are sorted ascending. | [optional] 

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
    open class func tracksIdDelete(id: String, idempotencyKey: String? = nil) async throws -> MutationResponseDocument
```

Delete single track.

Deletes existing track.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Track id
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)

// Delete single track.
do {
    let response = try await TracksAPI.tracksIdDelete(id: id, idempotencyKey: idempotencyKey)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Track id | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 

### Return type

[**MutationResponseDocument**](MutationResponseDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tracksIdGet**
```swift
    open class func tracksIdGet(id: String, countryCode: String? = nil, include: [String]? = nil, includeLinkage: [IncludeLinkage_tracksIdGet]? = nil, replaceMedia: String? = nil, shareCode: String? = nil) async throws -> TracksSingleResourceDataDocument
```

Get single track.

Retrieves single track by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Track id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: albums, artists, credits, download, genres, lyrics, metadataStatus, owners, priceConfig, providers, radio, replacement, shares, similarTracks, sourceFile, suggestedTracks, trackStatistics, usageRules (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: albums (optional)
let shareCode = "shareCode_example" // String | Share code used as a bearer credential for the resource. (optional)

// Get single track.
do {
    let response = try await TracksAPI.tracksIdGet(id: id, countryCode: countryCode, include: include, includeLinkage: includeLinkage, replaceMedia: replaceMedia, shareCode: shareCode)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Track id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: albums, artists, credits, download, genres, lyrics, metadataStatus, owners, priceConfig, providers, radio, replacement, shares, similarTracks, sourceFile, suggestedTracks, trackStatistics, usageRules | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: albums | [optional] 
 **shareCode** | **String** | Share code used as a bearer credential for the resource. | [optional] 

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
    open class func tracksIdPatch(id: String, idempotencyKey: String? = nil, tracksUpdateOperationPayload: TracksUpdateOperationPayload? = nil) async throws -> MutationResponseDocument
```

Update single track.

Updates existing track.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Track id
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let tracksUpdateOperationPayload = TracksUpdateOperation_Payload(data: TracksUpdateOperation_Payload_Data(attributes: TracksUpdateOperation_Payload_Data_Attributes(accessType: "accessType_example", bpm: 123, explicit: false, isrc: "isrc_example", key: "key_example", keyScale: "keyScale_example", title: "title_example", toneTags: ["toneTags_example"]), id: "id_example", relationships: TracksUpdateOperation_Payload_Data_Relationships(genres: TracksUpdateOperation_Payload_Data_Relationships_Genres(data: [TracksUpdateOperation_Payload_Data_Relationships_Genres_Data(id: "id_example", type: "type_example")])), type: "type_example")) // TracksUpdateOperationPayload |  (optional)

// Update single track.
do {
    let response = try await TracksAPI.tracksIdPatch(id: id, idempotencyKey: idempotencyKey, tracksUpdateOperationPayload: tracksUpdateOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Track id | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **tracksUpdateOperationPayload** | [**TracksUpdateOperationPayload**](TracksUpdateOperationPayload.md) |  | [optional] 

### Return type

[**MutationResponseDocument**](MutationResponseDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tracksIdRelationshipsAlbumsGet**
```swift
    open class func tracksIdRelationshipsAlbumsGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil, shareCode: String? = nil) async throws -> TracksAlbumsMultiRelationshipDataDocument
```

Get albums relationship (\"to-many\").

Retrieves albums relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Track id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: albums (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: albums (optional)
let shareCode = "shareCode_example" // String | Share code used as a bearer credential for the resource. (optional)

// Get albums relationship (\"to-many\").
do {
    let response = try await TracksAPI.tracksIdRelationshipsAlbumsGet(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia, shareCode: shareCode)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Track id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: albums | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: albums | [optional] 
 **shareCode** | **String** | Share code used as a bearer credential for the resource. | [optional] 

### Return type

[**TracksAlbumsMultiRelationshipDataDocument**](TracksAlbumsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tracksIdRelationshipsAlbumsPatch**
```swift
    open class func tracksIdRelationshipsAlbumsPatch(id: String, idempotencyKey: String? = nil, tracksAlbumsRelationshipUpdateOperationPayload: TracksAlbumsRelationshipUpdateOperationPayload? = nil) async throws -> MutationResponseDocument
```

Update albums relationship (\"to-many\").

Updates albums relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Track id
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let tracksAlbumsRelationshipUpdateOperationPayload = TracksAlbumsRelationshipUpdateOperation_Payload(data: [TracksAlbumsRelationshipUpdateOperation_Payload_Data(id: "id_example", type: "type_example")]) // TracksAlbumsRelationshipUpdateOperationPayload |  (optional)

// Update albums relationship (\"to-many\").
do {
    let response = try await TracksAPI.tracksIdRelationshipsAlbumsPatch(id: id, idempotencyKey: idempotencyKey, tracksAlbumsRelationshipUpdateOperationPayload: tracksAlbumsRelationshipUpdateOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Track id | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **tracksAlbumsRelationshipUpdateOperationPayload** | [**TracksAlbumsRelationshipUpdateOperationPayload**](TracksAlbumsRelationshipUpdateOperationPayload.md) |  | [optional] 

### Return type

[**MutationResponseDocument**](MutationResponseDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tracksIdRelationshipsArtistsGet**
```swift
    open class func tracksIdRelationshipsArtistsGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil, shareCode: String? = nil) async throws -> TracksArtistsMultiRelationshipDataDocument
```

Get artists relationship (\"to-many\").

Retrieves artists relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Track id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: artists (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: artists.albums (optional)
let shareCode = "shareCode_example" // String | Share code used as a bearer credential for the resource. (optional)

// Get artists relationship (\"to-many\").
do {
    let response = try await TracksAPI.tracksIdRelationshipsArtistsGet(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia, shareCode: shareCode)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Track id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: artists | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: artists.albums | [optional] 
 **shareCode** | **String** | Share code used as a bearer credential for the resource. | [optional] 

### Return type

[**TracksArtistsMultiRelationshipDataDocument**](TracksArtistsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tracksIdRelationshipsCreditsGet**
```swift
    open class func tracksIdRelationshipsCreditsGet(id: String, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil, shareCode: String? = nil) async throws -> TracksCreditsMultiRelationshipDataDocument
```

Get credits relationship (\"to-many\").

Retrieves credits relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Track id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: credits (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: credits.artist.albums (optional)
let shareCode = "shareCode_example" // String | Share code used as a bearer credential for the resource. (optional)

// Get credits relationship (\"to-many\").
do {
    let response = try await TracksAPI.tracksIdRelationshipsCreditsGet(id: id, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia, shareCode: shareCode)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Track id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: credits | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: credits.artist.albums | [optional] 
 **shareCode** | **String** | Share code used as a bearer credential for the resource. | [optional] 

### Return type

[**TracksCreditsMultiRelationshipDataDocument**](TracksCreditsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tracksIdRelationshipsDownloadGet**
```swift
    open class func tracksIdRelationshipsDownloadGet(id: String, include: [String]? = nil, shareCode: String? = nil) async throws -> TracksDownloadSingleRelationshipDataDocument
```

Get download relationship (\"to-one\").

Retrieves download relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Track id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: download (optional)
let shareCode = "shareCode_example" // String | Share code used as a bearer credential for the resource. (optional)

// Get download relationship (\"to-one\").
do {
    let response = try await TracksAPI.tracksIdRelationshipsDownloadGet(id: id, include: include, shareCode: shareCode)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Track id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: download | [optional] 
 **shareCode** | **String** | Share code used as a bearer credential for the resource. | [optional] 

### Return type

[**TracksDownloadSingleRelationshipDataDocument**](TracksDownloadSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tracksIdRelationshipsGenresGet**
```swift
    open class func tracksIdRelationshipsGenresGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil, shareCode: String? = nil) async throws -> TracksGenresMultiRelationshipDataDocument
```

Get genres relationship (\"to-many\").

Retrieves genres relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Track id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: genres (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let shareCode = "shareCode_example" // String | Share code used as a bearer credential for the resource. (optional)

// Get genres relationship (\"to-many\").
do {
    let response = try await TracksAPI.tracksIdRelationshipsGenresGet(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor, shareCode: shareCode)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Track id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: genres | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **shareCode** | **String** | Share code used as a bearer credential for the resource. | [optional] 

### Return type

[**TracksGenresMultiRelationshipDataDocument**](TracksGenresMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tracksIdRelationshipsLyricsGet**
```swift
    open class func tracksIdRelationshipsLyricsGet(id: String, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil, shareCode: String? = nil) async throws -> TracksLyricsMultiRelationshipDataDocument
```

Get lyrics relationship (\"to-many\").

Retrieves lyrics relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Track id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: lyrics (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: lyrics.track (optional)
let shareCode = "shareCode_example" // String | Share code used as a bearer credential for the resource. (optional)

// Get lyrics relationship (\"to-many\").
do {
    let response = try await TracksAPI.tracksIdRelationshipsLyricsGet(id: id, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia, shareCode: shareCode)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Track id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: lyrics | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: lyrics.track | [optional] 
 **shareCode** | **String** | Share code used as a bearer credential for the resource. | [optional] 

### Return type

[**TracksLyricsMultiRelationshipDataDocument**](TracksLyricsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tracksIdRelationshipsMetadataStatusGet**
```swift
    open class func tracksIdRelationshipsMetadataStatusGet(id: String, include: [String]? = nil, shareCode: String? = nil) async throws -> TracksMetadataStatusSingleRelationshipDataDocument
```

Get metadataStatus relationship (\"to-one\").

Retrieves metadataStatus relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Track id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: metadataStatus (optional)
let shareCode = "shareCode_example" // String | Share code used as a bearer credential for the resource. (optional)

// Get metadataStatus relationship (\"to-one\").
do {
    let response = try await TracksAPI.tracksIdRelationshipsMetadataStatusGet(id: id, include: include, shareCode: shareCode)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Track id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: metadataStatus | [optional] 
 **shareCode** | **String** | Share code used as a bearer credential for the resource. | [optional] 

### Return type

[**TracksMetadataStatusSingleRelationshipDataDocument**](TracksMetadataStatusSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tracksIdRelationshipsOwnersGet**
```swift
    open class func tracksIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil, shareCode: String? = nil) async throws -> TracksOwnersMultiRelationshipDataDocument
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Track id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let shareCode = "shareCode_example" // String | Share code used as a bearer credential for the resource. (optional)

// Get owners relationship (\"to-many\").
do {
    let response = try await TracksAPI.tracksIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor, shareCode: shareCode)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Track id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **shareCode** | **String** | Share code used as a bearer credential for the resource. | [optional] 

### Return type

[**TracksOwnersMultiRelationshipDataDocument**](TracksOwnersMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tracksIdRelationshipsPriceConfigGet**
```swift
    open class func tracksIdRelationshipsPriceConfigGet(id: String, countryCode: String? = nil, include: [String]? = nil, shareCode: String? = nil) async throws -> TracksPriceConfigSingleRelationshipDataDocument
```

Get priceConfig relationship (\"to-one\").

Retrieves priceConfig relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Track id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: priceConfig (optional)
let shareCode = "shareCode_example" // String | Share code used as a bearer credential for the resource. (optional)

// Get priceConfig relationship (\"to-one\").
do {
    let response = try await TracksAPI.tracksIdRelationshipsPriceConfigGet(id: id, countryCode: countryCode, include: include, shareCode: shareCode)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Track id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: priceConfig | [optional] 
 **shareCode** | **String** | Share code used as a bearer credential for the resource. | [optional] 

### Return type

[**TracksPriceConfigSingleRelationshipDataDocument**](TracksPriceConfigSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tracksIdRelationshipsProvidersGet**
```swift
    open class func tracksIdRelationshipsProvidersGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil, shareCode: String? = nil) async throws -> TracksProvidersMultiRelationshipDataDocument
```

Get providers relationship (\"to-many\").

Retrieves providers relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Track id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: providers (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let shareCode = "shareCode_example" // String | Share code used as a bearer credential for the resource. (optional)

// Get providers relationship (\"to-many\").
do {
    let response = try await TracksAPI.tracksIdRelationshipsProvidersGet(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor, shareCode: shareCode)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Track id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: providers | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **shareCode** | **String** | Share code used as a bearer credential for the resource. | [optional] 

### Return type

[**TracksProvidersMultiRelationshipDataDocument**](TracksProvidersMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tracksIdRelationshipsRadioGet**
```swift
    open class func tracksIdRelationshipsRadioGet(id: String, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil, shareCode: String? = nil) async throws -> TracksRadioMultiRelationshipDataDocument
```

Get radio relationship (\"to-many\").

Retrieves radio relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Track id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: radio (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: radio.items (optional)
let shareCode = "shareCode_example" // String | Share code used as a bearer credential for the resource. (optional)

// Get radio relationship (\"to-many\").
do {
    let response = try await TracksAPI.tracksIdRelationshipsRadioGet(id: id, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia, shareCode: shareCode)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Track id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: radio | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: radio.items | [optional] 
 **shareCode** | **String** | Share code used as a bearer credential for the resource. | [optional] 

### Return type

[**TracksRadioMultiRelationshipDataDocument**](TracksRadioMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tracksIdRelationshipsReplacementGet**
```swift
    open class func tracksIdRelationshipsReplacementGet(id: String, countryCode: String? = nil, include: [String]? = nil, replaceMedia: String? = nil, shareCode: String? = nil) async throws -> TracksReplacementSingleRelationshipDataDocument
```

Get replacement relationship (\"to-one\").

Retrieves replacement relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Track id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: replacement (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: replacement (optional)
let shareCode = "shareCode_example" // String | Share code used as a bearer credential for the resource. (optional)

// Get replacement relationship (\"to-one\").
do {
    let response = try await TracksAPI.tracksIdRelationshipsReplacementGet(id: id, countryCode: countryCode, include: include, replaceMedia: replaceMedia, shareCode: shareCode)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Track id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: replacement | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: replacement | [optional] 
 **shareCode** | **String** | Share code used as a bearer credential for the resource. | [optional] 

### Return type

[**TracksReplacementSingleRelationshipDataDocument**](TracksReplacementSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tracksIdRelationshipsSharesGet**
```swift
    open class func tracksIdRelationshipsSharesGet(id: String, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil, shareCode: String? = nil) async throws -> TracksSharesMultiRelationshipDataDocument
```

Get shares relationship (\"to-many\").

The track's share links, active and expired, newest first.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Track id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: shares (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: shares.sharedResources (optional)
let shareCode = "shareCode_example" // String | Share code used as a bearer credential for the resource. (optional)

// Get shares relationship (\"to-many\").
do {
    let response = try await TracksAPI.tracksIdRelationshipsSharesGet(id: id, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia, shareCode: shareCode)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Track id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: shares | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: shares.sharedResources | [optional] 
 **shareCode** | **String** | Share code used as a bearer credential for the resource. | [optional] 

### Return type

[**TracksSharesMultiRelationshipDataDocument**](TracksSharesMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tracksIdRelationshipsSimilarTracksGet**
```swift
    open class func tracksIdRelationshipsSimilarTracksGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil, shareCode: String? = nil) async throws -> TracksSimilarTracksMultiRelationshipDataDocument
```

Get similarTracks relationship (\"to-many\").

Retrieves similarTracks relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Track id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: similarTracks (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: similarTracks (optional)
let shareCode = "shareCode_example" // String | Share code used as a bearer credential for the resource. (optional)

// Get similarTracks relationship (\"to-many\").
do {
    let response = try await TracksAPI.tracksIdRelationshipsSimilarTracksGet(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia, shareCode: shareCode)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Track id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: similarTracks | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: similarTracks | [optional] 
 **shareCode** | **String** | Share code used as a bearer credential for the resource. | [optional] 

### Return type

[**TracksSimilarTracksMultiRelationshipDataDocument**](TracksSimilarTracksMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tracksIdRelationshipsSourceFileGet**
```swift
    open class func tracksIdRelationshipsSourceFileGet(id: String, include: [String]? = nil, shareCode: String? = nil) async throws -> TracksSourceFileSingleRelationshipDataDocument
```

Get sourceFile relationship (\"to-one\").

Retrieves sourceFile relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Track id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: sourceFile (optional)
let shareCode = "shareCode_example" // String | Share code used as a bearer credential for the resource. (optional)

// Get sourceFile relationship (\"to-one\").
do {
    let response = try await TracksAPI.tracksIdRelationshipsSourceFileGet(id: id, include: include, shareCode: shareCode)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Track id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: sourceFile | [optional] 
 **shareCode** | **String** | Share code used as a bearer credential for the resource. | [optional] 

### Return type

[**TracksSourceFileSingleRelationshipDataDocument**](TracksSourceFileSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tracksIdRelationshipsSuggestedTracksGet**
```swift
    open class func tracksIdRelationshipsSuggestedTracksGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil, shareCode: String? = nil) async throws -> TracksSuggestedTracksMultiRelationshipDataDocument
```

Get suggestedTracks relationship (\"to-many\").

Retrieves suggestedTracks relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Track id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: suggestedTracks (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: suggestedTracks (optional)
let shareCode = "shareCode_example" // String | Share code used as a bearer credential for the resource. (optional)

// Get suggestedTracks relationship (\"to-many\").
do {
    let response = try await TracksAPI.tracksIdRelationshipsSuggestedTracksGet(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia, shareCode: shareCode)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Track id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: suggestedTracks | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: suggestedTracks | [optional] 
 **shareCode** | **String** | Share code used as a bearer credential for the resource. | [optional] 

### Return type

[**TracksSuggestedTracksMultiRelationshipDataDocument**](TracksSuggestedTracksMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tracksIdRelationshipsTrackStatisticsGet**
```swift
    open class func tracksIdRelationshipsTrackStatisticsGet(id: String, include: [String]? = nil, shareCode: String? = nil) async throws -> TracksTrackStatisticsSingleRelationshipDataDocument
```

Get trackStatistics relationship (\"to-one\").

Retrieves trackStatistics relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Track id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: trackStatistics (optional)
let shareCode = "shareCode_example" // String | Share code used as a bearer credential for the resource. (optional)

// Get trackStatistics relationship (\"to-one\").
do {
    let response = try await TracksAPI.tracksIdRelationshipsTrackStatisticsGet(id: id, include: include, shareCode: shareCode)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Track id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: trackStatistics | [optional] 
 **shareCode** | **String** | Share code used as a bearer credential for the resource. | [optional] 

### Return type

[**TracksTrackStatisticsSingleRelationshipDataDocument**](TracksTrackStatisticsSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tracksIdRelationshipsUsageRulesGet**
```swift
    open class func tracksIdRelationshipsUsageRulesGet(id: String, countryCode: String? = nil, include: [String]? = nil, shareCode: String? = nil) async throws -> TracksUsageRulesSingleRelationshipDataDocument
```

Get usageRules relationship (\"to-one\").

Retrieves usageRules relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Track id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: usageRules (optional)
let shareCode = "shareCode_example" // String | Share code used as a bearer credential for the resource. (optional)

// Get usageRules relationship (\"to-one\").
do {
    let response = try await TracksAPI.tracksIdRelationshipsUsageRulesGet(id: id, countryCode: countryCode, include: include, shareCode: shareCode)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Track id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: usageRules | [optional] 
 **shareCode** | **String** | Share code used as a bearer credential for the resource. | [optional] 

### Return type

[**TracksUsageRulesSingleRelationshipDataDocument**](TracksUsageRulesSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tracksPost**
```swift
    open class func tracksPost(idempotencyKey: String? = nil, tracksCreateOperationPayload: TracksCreateOperationPayload? = nil) async throws -> TracksCreateSingleResourceDataDocument
```

Create single track.

Creates a new track.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let tracksCreateOperationPayload = TracksCreateOperation_Payload(data: TracksCreateOperation_Payload_Data(attributes: TracksCreateOperation_Payload_Data_Attributes(accessType: "accessType_example", explicit: false, title: "title_example"), relationships: TracksCreateOperation_Payload_Data_Relationships(albums: TracksCreateOperation_Payload_Data_Relationships_Albums(data: [TracksCreateOperation_Payload_Data_Relationships_Albums_Data(id: "id_example", type: "type_example")]), artists: TracksCreateOperation_Payload_Data_Relationships_Artists(data: [TracksCreateOperation_Payload_Data_Relationships_Artists_Data(id: "id_example", type: "type_example")]), genres: TracksCreateOperation_Payload_Data_Relationships_Genres(data: [TracksCreateOperation_Payload_Data_Relationships_Genres_Data(id: "id_example", type: "type_example")])), type: "type_example")) // TracksCreateOperationPayload |  (optional)

// Create single track.
do {
    let response = try await TracksAPI.tracksPost(idempotencyKey: idempotencyKey, tracksCreateOperationPayload: tracksCreateOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **tracksCreateOperationPayload** | [**TracksCreateOperationPayload**](TracksCreateOperationPayload.md) |  | [optional] 

### Return type

[**TracksCreateSingleResourceDataDocument**](TracksCreateSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

