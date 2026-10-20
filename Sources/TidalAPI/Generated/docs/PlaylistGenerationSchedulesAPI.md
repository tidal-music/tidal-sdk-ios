# PlaylistGenerationSchedulesAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**playlistGenerationSchedulesGet**](PlaylistGenerationSchedulesAPI.md#playlistgenerationschedulesget) | **GET** /playlistGenerationSchedules | Get multiple playlistGenerationSchedules.
[**playlistGenerationSchedulesIdDelete**](PlaylistGenerationSchedulesAPI.md#playlistgenerationschedulesiddelete) | **DELETE** /playlistGenerationSchedules/{id} | Delete single playlistGenerationSchedule.
[**playlistGenerationSchedulesIdGet**](PlaylistGenerationSchedulesAPI.md#playlistgenerationschedulesidget) | **GET** /playlistGenerationSchedules/{id} | Get single playlistGenerationSchedule.
[**playlistGenerationSchedulesIdPatch**](PlaylistGenerationSchedulesAPI.md#playlistgenerationschedulesidpatch) | **PATCH** /playlistGenerationSchedules/{id} | Update single playlistGenerationSchedule.
[**playlistGenerationSchedulesIdRelationshipsPlaylistGet**](PlaylistGenerationSchedulesAPI.md#playlistgenerationschedulesidrelationshipsplaylistget) | **GET** /playlistGenerationSchedules/{id}/relationships/playlist | Get playlist relationship (\&quot;to-one\&quot;).
[**playlistGenerationSchedulesPost**](PlaylistGenerationSchedulesAPI.md#playlistgenerationschedulespost) | **POST** /playlistGenerationSchedules | Create single playlistGenerationSchedule.


# **playlistGenerationSchedulesGet**
```swift
    open class func playlistGenerationSchedulesGet(filterPlaylistId: [String], include: [String]? = nil, includeLinkage: [IncludeLinkage_playlistGenerationSchedulesGet]? = nil, replaceMedia: String? = nil) async throws -> PlaylistGenerationSchedulesMultiResourceDataDocument
```

Get multiple playlistGenerationSchedules.

Retrieves multiple playlistGenerationSchedules by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let filterPlaylistId = ["inner_example"] // [String] | Playlist id (e.g. `550e8400-e29b-41d4-a716-446655440000`)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: playlist (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: playlist.items (optional)

// Get multiple playlistGenerationSchedules.
do {
    let response = try await PlaylistGenerationSchedulesAPI.playlistGenerationSchedulesGet(filterPlaylistId: filterPlaylistId, include: include, includeLinkage: includeLinkage, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **filterPlaylistId** | [**[String]**](String.md) | Playlist id (e.g. &#x60;550e8400-e29b-41d4-a716-446655440000&#x60;) | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: playlist | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: playlist.items | [optional] 

### Return type

[**PlaylistGenerationSchedulesMultiResourceDataDocument**](PlaylistGenerationSchedulesMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistGenerationSchedulesIdDelete**
```swift
    open class func playlistGenerationSchedulesIdDelete(id: String, idempotencyKey: String? = nil) async throws -> MutationResponseDocument
```

Delete single playlistGenerationSchedule.

Deletes existing playlistGenerationSchedule.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | 
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)

// Delete single playlistGenerationSchedule.
do {
    let response = try await PlaylistGenerationSchedulesAPI.playlistGenerationSchedulesIdDelete(id: id, idempotencyKey: idempotencyKey)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** |  | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 

### Return type

[**MutationResponseDocument**](MutationResponseDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistGenerationSchedulesIdGet**
```swift
    open class func playlistGenerationSchedulesIdGet(id: String, include: [String]? = nil, includeLinkage: [IncludeLinkage_playlistGenerationSchedulesIdGet]? = nil, replaceMedia: String? = nil) async throws -> PlaylistGenerationSchedulesSingleResourceDataDocument
```

Get single playlistGenerationSchedule.

Retrieves single playlistGenerationSchedule by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | 
let include = ["inner_example"] // [String] | Include related resources. Available relationships: playlist (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: playlist.items (optional)

// Get single playlistGenerationSchedule.
do {
    let response = try await PlaylistGenerationSchedulesAPI.playlistGenerationSchedulesIdGet(id: id, include: include, includeLinkage: includeLinkage, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** |  | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: playlist | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: playlist.items | [optional] 

### Return type

[**PlaylistGenerationSchedulesSingleResourceDataDocument**](PlaylistGenerationSchedulesSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistGenerationSchedulesIdPatch**
```swift
    open class func playlistGenerationSchedulesIdPatch(id: String, idempotencyKey: String? = nil, playlistGenerationSchedulesUpdateOperationPayload: PlaylistGenerationSchedulesUpdateOperationPayload? = nil) async throws -> PlaylistGenerationSchedulesUpdateSingleResourceDataDocument
```

Update single playlistGenerationSchedule.

Updates existing playlistGenerationSchedule.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | 
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let playlistGenerationSchedulesUpdateOperationPayload = PlaylistGenerationSchedulesUpdateOperation_Payload(data: PlaylistGenerationSchedulesUpdateOperation_Payload_Data(attributes: PlaylistGenerationSchedulesUpdateOperation_Payload_Data_Attributes(timeZone: "timeZone_example", weekday: "weekday_example"), id: "id_example", type: "type_example")) // PlaylistGenerationSchedulesUpdateOperationPayload |  (optional)

// Update single playlistGenerationSchedule.
do {
    let response = try await PlaylistGenerationSchedulesAPI.playlistGenerationSchedulesIdPatch(id: id, idempotencyKey: idempotencyKey, playlistGenerationSchedulesUpdateOperationPayload: playlistGenerationSchedulesUpdateOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** |  | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **playlistGenerationSchedulesUpdateOperationPayload** | [**PlaylistGenerationSchedulesUpdateOperationPayload**](PlaylistGenerationSchedulesUpdateOperationPayload.md) |  | [optional] 

### Return type

[**PlaylistGenerationSchedulesUpdateSingleResourceDataDocument**](PlaylistGenerationSchedulesUpdateSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistGenerationSchedulesIdRelationshipsPlaylistGet**
```swift
    open class func playlistGenerationSchedulesIdRelationshipsPlaylistGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> PlaylistGenerationSchedulesPlaylistSingleRelationshipDataDocument
```

Get playlist relationship (\"to-one\").

Retrieves playlist relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | 
let include = ["inner_example"] // [String] | Include related resources. Available relationships: playlist (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: playlist.items (optional)

// Get playlist relationship (\"to-one\").
do {
    let response = try await PlaylistGenerationSchedulesAPI.playlistGenerationSchedulesIdRelationshipsPlaylistGet(id: id, include: include, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** |  | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: playlist | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: playlist.items | [optional] 

### Return type

[**PlaylistGenerationSchedulesPlaylistSingleRelationshipDataDocument**](PlaylistGenerationSchedulesPlaylistSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistGenerationSchedulesPost**
```swift
    open class func playlistGenerationSchedulesPost(idempotencyKey: String? = nil, playlistGenerationSchedulesCreateOperationPayload: PlaylistGenerationSchedulesCreateOperationPayload? = nil) async throws -> PlaylistGenerationSchedulesCreateSingleResourceDataDocument
```

Create single playlistGenerationSchedule.

Creates a new playlistGenerationSchedule.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let playlistGenerationSchedulesCreateOperationPayload = PlaylistGenerationSchedulesCreateOperation_Payload(data: PlaylistGenerationSchedulesCreateOperation_Payload_Data(attributes: PlaylistGenerationSchedulesCreateOperation_Payload_Data_Attributes(timeZone: "timeZone_example", weekday: "weekday_example"), relationships: PlaylistGenerationSchedulesCreateOperation_Payload_Data_Relationships(playlist: PlaylistGenerationSchedulesCreateOperation_Payload_Data_Relationships_Playlist(data: PlaylistGenerationSchedulesCreateOperation_Payload_Data_Relationships_Playlist_Data(id: "id_example", type: "type_example"))), type: "type_example")) // PlaylistGenerationSchedulesCreateOperationPayload |  (optional)

// Create single playlistGenerationSchedule.
do {
    let response = try await PlaylistGenerationSchedulesAPI.playlistGenerationSchedulesPost(idempotencyKey: idempotencyKey, playlistGenerationSchedulesCreateOperationPayload: playlistGenerationSchedulesCreateOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **playlistGenerationSchedulesCreateOperationPayload** | [**PlaylistGenerationSchedulesCreateOperationPayload**](PlaylistGenerationSchedulesCreateOperationPayload.md) |  | [optional] 

### Return type

[**PlaylistGenerationSchedulesCreateSingleResourceDataDocument**](PlaylistGenerationSchedulesCreateSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

