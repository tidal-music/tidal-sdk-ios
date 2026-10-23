# PlaylistGenerationsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**playlistGenerationsGet**](PlaylistGenerationsAPI.md#playlistgenerationsget) | **GET** /playlistGenerations | Get multiple playlistGenerations.
[**playlistGenerationsIdGet**](PlaylistGenerationsAPI.md#playlistgenerationsidget) | **GET** /playlistGenerations/{id} | Get single playlistGeneration.
[**playlistGenerationsIdRelationshipsBaseGenerationGet**](PlaylistGenerationsAPI.md#playlistgenerationsidrelationshipsbasegenerationget) | **GET** /playlistGenerations/{id}/relationships/baseGeneration | Get baseGeneration relationship (\&quot;to-one\&quot;).
[**playlistGenerationsIdRelationshipsPlaylistGet**](PlaylistGenerationsAPI.md#playlistgenerationsidrelationshipsplaylistget) | **GET** /playlistGenerations/{id}/relationships/playlist | Get playlist relationship (\&quot;to-one\&quot;).
[**playlistGenerationsIdRelationshipsTrackPreferencesDelete**](PlaylistGenerationsAPI.md#playlistgenerationsidrelationshipstrackpreferencesdelete) | **DELETE** /playlistGenerations/{id}/relationships/trackPreferences | Delete from trackPreferences relationship (\&quot;to-many\&quot;).
[**playlistGenerationsIdRelationshipsTrackPreferencesGet**](PlaylistGenerationsAPI.md#playlistgenerationsidrelationshipstrackpreferencesget) | **GET** /playlistGenerations/{id}/relationships/trackPreferences | Get trackPreferences relationship (\&quot;to-many\&quot;).
[**playlistGenerationsIdRelationshipsTrackPreferencesPatch**](PlaylistGenerationsAPI.md#playlistgenerationsidrelationshipstrackpreferencespatch) | **PATCH** /playlistGenerations/{id}/relationships/trackPreferences | Update trackPreferences relationship (\&quot;to-many\&quot;).
[**playlistGenerationsIdRelationshipsTrackPreferencesPost**](PlaylistGenerationsAPI.md#playlistgenerationsidrelationshipstrackpreferencespost) | **POST** /playlistGenerations/{id}/relationships/trackPreferences | Add to trackPreferences relationship (\&quot;to-many\&quot;).
[**playlistGenerationsPost**](PlaylistGenerationsAPI.md#playlistgenerationspost) | **POST** /playlistGenerations | Create single playlistGeneration.


# **playlistGenerationsGet**
```swift
    open class func playlistGenerationsGet(filterPlaylistId: [String], generationView: GenerationView_playlistGenerationsGet? = nil, include: [String]? = nil, includeLinkage: [IncludeLinkage_playlistGenerationsGet]? = nil, replaceMedia: String? = nil) async throws -> PlaylistGenerationsMultiResourceDataDocument
```

Get multiple playlistGenerations.

Retrieves multiple playlistGenerations by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let filterPlaylistId = ["inner_example"] // [String] | Playlist id (e.g. `550e8400-e29b-41d4-a716-446655440000`)
let generationView = "generationView_example" // String | CURRENT selects the committed generation. LATEST selects the newest accepted attempt, regardless of status. New values may be added at any time. (optional) (default to .current)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: baseGeneration, playlist, trackPreferences (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: baseGeneration.trackPreferences (optional)

// Get multiple playlistGenerations.
do {
    let response = try await PlaylistGenerationsAPI.playlistGenerationsGet(filterPlaylistId: filterPlaylistId, generationView: generationView, include: include, includeLinkage: includeLinkage, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **filterPlaylistId** | [**[String]**](String.md) | Playlist id (e.g. &#x60;550e8400-e29b-41d4-a716-446655440000&#x60;) | 
 **generationView** | **String** | CURRENT selects the committed generation. LATEST selects the newest accepted attempt, regardless of status. New values may be added at any time. | [optional] [default to .current]
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: baseGeneration, playlist, trackPreferences | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: baseGeneration.trackPreferences | [optional] 

### Return type

[**PlaylistGenerationsMultiResourceDataDocument**](PlaylistGenerationsMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistGenerationsIdGet**
```swift
    open class func playlistGenerationsIdGet(id: String, include: [String]? = nil, includeLinkage: [IncludeLinkage_playlistGenerationsIdGet]? = nil, replaceMedia: String? = nil) async throws -> PlaylistGenerationsSingleResourceDataDocument
```

Get single playlistGeneration.

Retrieves single playlistGeneration by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Playlist generation id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: baseGeneration, playlist, trackPreferences (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: baseGeneration.trackPreferences (optional)

// Get single playlistGeneration.
do {
    let response = try await PlaylistGenerationsAPI.playlistGenerationsIdGet(id: id, include: include, includeLinkage: includeLinkage, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Playlist generation id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: baseGeneration, playlist, trackPreferences | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: baseGeneration.trackPreferences | [optional] 

### Return type

[**PlaylistGenerationsSingleResourceDataDocument**](PlaylistGenerationsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistGenerationsIdRelationshipsBaseGenerationGet**
```swift
    open class func playlistGenerationsIdRelationshipsBaseGenerationGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> PlaylistGenerationsBaseGenerationSingleRelationshipDataDocument
```

Get baseGeneration relationship (\"to-one\").

Retrieves baseGeneration relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Playlist generation id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: baseGeneration (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: baseGeneration.trackPreferences (optional)

// Get baseGeneration relationship (\"to-one\").
do {
    let response = try await PlaylistGenerationsAPI.playlistGenerationsIdRelationshipsBaseGenerationGet(id: id, include: include, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Playlist generation id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: baseGeneration | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: baseGeneration.trackPreferences | [optional] 

### Return type

[**PlaylistGenerationsBaseGenerationSingleRelationshipDataDocument**](PlaylistGenerationsBaseGenerationSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistGenerationsIdRelationshipsPlaylistGet**
```swift
    open class func playlistGenerationsIdRelationshipsPlaylistGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> PlaylistGenerationsPlaylistSingleRelationshipDataDocument
```

Get playlist relationship (\"to-one\").

Retrieves playlist relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Playlist generation id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: playlist (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: playlist.items (optional)

// Get playlist relationship (\"to-one\").
do {
    let response = try await PlaylistGenerationsAPI.playlistGenerationsIdRelationshipsPlaylistGet(id: id, include: include, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Playlist generation id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: playlist | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: playlist.items | [optional] 

### Return type

[**PlaylistGenerationsPlaylistSingleRelationshipDataDocument**](PlaylistGenerationsPlaylistSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistGenerationsIdRelationshipsTrackPreferencesDelete**
```swift
    open class func playlistGenerationsIdRelationshipsTrackPreferencesDelete(id: String, idempotencyKey: String? = nil, playlistGenerationsTrackPreferencesRelationshipRemoveOperationPayload: PlaylistGenerationsTrackPreferencesRelationshipRemoveOperationPayload? = nil) async throws -> MutationResponseDocument
```

Delete from trackPreferences relationship (\"to-many\").

Removes feedback for one track without removing the track from the playlist. An absent entry is unchanged. Returns an acknowledgement; read the relationship again for its current preference version. Requires the current meta.preferenceVersion as meta.expectedPreferenceVersion; stale versions return 409.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Playlist generation id
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let playlistGenerationsTrackPreferencesRelationshipRemoveOperationPayload = PlaylistGenerationsTrackPreferencesRelationshipRemoveOperation_Payload(data: [PlaylistGenerationsTrackPreferencesRelationshipRemoveOperation_Payload_Data(id: "id_example", type: "type_example")], meta: PlaylistGenerationsTrackPreferencesRelationship_Payload_Meta(expectedPreferenceVersion: 123)) // PlaylistGenerationsTrackPreferencesRelationshipRemoveOperationPayload |  (optional)

// Delete from trackPreferences relationship (\"to-many\").
do {
    let response = try await PlaylistGenerationsAPI.playlistGenerationsIdRelationshipsTrackPreferencesDelete(id: id, idempotencyKey: idempotencyKey, playlistGenerationsTrackPreferencesRelationshipRemoveOperationPayload: playlistGenerationsTrackPreferencesRelationshipRemoveOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Playlist generation id | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **playlistGenerationsTrackPreferencesRelationshipRemoveOperationPayload** | [**PlaylistGenerationsTrackPreferencesRelationshipRemoveOperationPayload**](PlaylistGenerationsTrackPreferencesRelationshipRemoveOperationPayload.md) |  | [optional] 

### Return type

[**MutationResponseDocument**](MutationResponseDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistGenerationsIdRelationshipsTrackPreferencesGet**
```swift
    open class func playlistGenerationsIdRelationshipsTrackPreferencesGet(id: String, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil) async throws -> PlaylistGenerationsTrackPreferencesMultiRelationshipDataDocument
```

Get trackPreferences relationship (\"to-many\").

Retrieves trackPreferences relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Playlist generation id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: trackPreferences (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: trackPreferences (optional)

// Get trackPreferences relationship (\"to-many\").
do {
    let response = try await PlaylistGenerationsAPI.playlistGenerationsIdRelationshipsTrackPreferencesGet(id: id, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Playlist generation id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: trackPreferences | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: trackPreferences | [optional] 

### Return type

[**PlaylistGenerationsTrackPreferencesMultiRelationshipDataDocument**](PlaylistGenerationsTrackPreferencesMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistGenerationsIdRelationshipsTrackPreferencesPatch**
```swift
    open class func playlistGenerationsIdRelationshipsTrackPreferencesPatch(id: String, idempotencyKey: String? = nil, playlistGenerationsTrackPreferencesRelationshipUpdateOperationPayload: PlaylistGenerationsTrackPreferencesRelationshipUpdateOperationPayload? = nil) async throws -> PlaylistGenerationsTrackPreferencesUpdateMultiRelationshipDataDocument
```

Update trackPreferences relationship (\"to-many\").

Incrementally updates feedback for one existing track preference, leaving other entries unchanged. Empty data is rejected; a missing entry returns 409. Returns the complete preference snapshot. Requires the current meta.preferenceVersion as meta.expectedPreferenceVersion; stale versions return 409.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Playlist generation id
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let playlistGenerationsTrackPreferencesRelationshipUpdateOperationPayload = PlaylistGenerationsTrackPreferencesRelationshipUpdateOperation_Payload(data: [PlaylistGenerationsTrackPreferencesRelationship_Payload_Data(id: "id_example", meta: PlaylistGenerationsTrackPreferencesRelationship_Payload_Data_Meta(preference: "preference_example"), type: "type_example")], meta: PlaylistGenerationsTrackPreferencesRelationship_Payload_Meta(expectedPreferenceVersion: 123)) // PlaylistGenerationsTrackPreferencesRelationshipUpdateOperationPayload |  (optional)

// Update trackPreferences relationship (\"to-many\").
do {
    let response = try await PlaylistGenerationsAPI.playlistGenerationsIdRelationshipsTrackPreferencesPatch(id: id, idempotencyKey: idempotencyKey, playlistGenerationsTrackPreferencesRelationshipUpdateOperationPayload: playlistGenerationsTrackPreferencesRelationshipUpdateOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Playlist generation id | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **playlistGenerationsTrackPreferencesRelationshipUpdateOperationPayload** | [**PlaylistGenerationsTrackPreferencesRelationshipUpdateOperationPayload**](PlaylistGenerationsTrackPreferencesRelationshipUpdateOperationPayload.md) |  | [optional] 

### Return type

[**PlaylistGenerationsTrackPreferencesUpdateMultiRelationshipDataDocument**](PlaylistGenerationsTrackPreferencesUpdateMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistGenerationsIdRelationshipsTrackPreferencesPost**
```swift
    open class func playlistGenerationsIdRelationshipsTrackPreferencesPost(id: String, idempotencyKey: String? = nil, playlistGenerationsTrackPreferencesRelationshipAddOperationPayload: PlaylistGenerationsTrackPreferencesRelationshipAddOperationPayload? = nil) async throws -> PlaylistGenerationsTrackPreferencesAddMultiRelationshipDataDocument
```

Add to trackPreferences relationship (\"to-many\").

Adds feedback for one track. An existing entry is unchanged, including its preference. Returns the complete preference snapshot. All writes require the current meta.preferenceVersion as meta.expectedPreferenceVersion; stale versions return 409.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Playlist generation id
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let playlistGenerationsTrackPreferencesRelationshipAddOperationPayload = PlaylistGenerationsTrackPreferencesRelationshipAddOperation_Payload(data: [PlaylistGenerationsTrackPreferencesRelationship_Payload_Data(id: "id_example", meta: PlaylistGenerationsTrackPreferencesRelationship_Payload_Data_Meta(preference: "preference_example"), type: "type_example")], meta: PlaylistGenerationsTrackPreferencesRelationship_Payload_Meta(expectedPreferenceVersion: 123)) // PlaylistGenerationsTrackPreferencesRelationshipAddOperationPayload |  (optional)

// Add to trackPreferences relationship (\"to-many\").
do {
    let response = try await PlaylistGenerationsAPI.playlistGenerationsIdRelationshipsTrackPreferencesPost(id: id, idempotencyKey: idempotencyKey, playlistGenerationsTrackPreferencesRelationshipAddOperationPayload: playlistGenerationsTrackPreferencesRelationshipAddOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Playlist generation id | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **playlistGenerationsTrackPreferencesRelationshipAddOperationPayload** | [**PlaylistGenerationsTrackPreferencesRelationshipAddOperationPayload**](PlaylistGenerationsTrackPreferencesRelationshipAddOperationPayload.md) |  | [optional] 

### Return type

[**PlaylistGenerationsTrackPreferencesAddMultiRelationshipDataDocument**](PlaylistGenerationsTrackPreferencesAddMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistGenerationsPost**
```swift
    open class func playlistGenerationsPost(idempotencyKey: String? = nil, playlistGenerationsCreateOperationPayload: PlaylistGenerationsCreateOperationPayload? = nil) async throws -> PlaylistGenerationsCreateSingleResourceDataDocument
```

Create single playlistGeneration.

Creates a new playlistGeneration.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let playlistGenerationsCreateOperationPayload = PlaylistGenerationsCreateOperation_Payload(data: PlaylistGenerationsCreateOperation_Payload_Data(attributes: PlaylistGenerationsCreateOperation_Payload_Data_Attributes(preferenceVersion: 123, prompt: "prompt_example"), relationships: PlaylistGenerationsCreateOperation_Payload_Data_Relationships(baseGeneration: PlaylistGenerationsCreateOperation_Payload_Data_Relationships_BaseGeneration(data: PlaylistGenerationsCreateOperation_Payload_Data_Relationships_BaseGeneration_Data(id: "id_example", type: "type_example")), playlist: PlaylistGenerationsCreateOperation_Payload_Data_Relationships_Playlist(data: PlaylistGenerationsCreateOperation_Payload_Data_Relationships_Playlist_Data(id: "id_example", type: "type_example"))), type: "type_example")) // PlaylistGenerationsCreateOperationPayload |  (optional)

// Create single playlistGeneration.
do {
    let response = try await PlaylistGenerationsAPI.playlistGenerationsPost(idempotencyKey: idempotencyKey, playlistGenerationsCreateOperationPayload: playlistGenerationsCreateOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **playlistGenerationsCreateOperationPayload** | [**PlaylistGenerationsCreateOperationPayload**](PlaylistGenerationsCreateOperationPayload.md) |  | [optional] 

### Return type

[**PlaylistGenerationsCreateSingleResourceDataDocument**](PlaylistGenerationsCreateSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

