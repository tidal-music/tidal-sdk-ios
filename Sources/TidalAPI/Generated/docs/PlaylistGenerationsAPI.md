# PlaylistGenerationsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**playlistGenerationsGet**](PlaylistGenerationsAPI.md#playlistgenerationsget) | **GET** /playlistGenerations | Get multiple playlistGenerations.
[**playlistGenerationsIdGet**](PlaylistGenerationsAPI.md#playlistgenerationsidget) | **GET** /playlistGenerations/{id} | Get single playlistGeneration.
[**playlistGenerationsIdRelationshipsPlaylistGet**](PlaylistGenerationsAPI.md#playlistgenerationsidrelationshipsplaylistget) | **GET** /playlistGenerations/{id}/relationships/playlist | Get playlist relationship (\&quot;to-one\&quot;).
[**playlistGenerationsPost**](PlaylistGenerationsAPI.md#playlistgenerationspost) | **POST** /playlistGenerations | Create single playlistGeneration.


# **playlistGenerationsGet**
```swift
    open class func playlistGenerationsGet(filterPlaylistId: [String], include: [String]? = nil, replaceMedia: String? = nil, completion: @escaping (_ data: PlaylistGenerationsMultiResourceDataDocument?, _ error: Error?) -> Void)
```

Get multiple playlistGenerations.

Retrieves multiple playlistGenerations by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let filterPlaylistId = ["inner_example"] // [String] | Playlist id (e.g. `550e8400-e29b-41d4-a716-446655440000`)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: playlist (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: playlist.items (optional)

// Get multiple playlistGenerations.
PlaylistGenerationsAPI.playlistGenerationsGet(filterPlaylistId: filterPlaylistId, include: include, replaceMedia: replaceMedia) { (response, error) in
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
 **filterPlaylistId** | [**[String]**](String.md) | Playlist id (e.g. &#x60;550e8400-e29b-41d4-a716-446655440000&#x60;) | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: playlist | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: playlist.items | [optional] 

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
    open class func playlistGenerationsIdGet(id: String, include: [String]? = nil, replaceMedia: String? = nil, completion: @escaping (_ data: PlaylistGenerationsSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single playlistGeneration.

Retrieves single playlistGeneration by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Playlist generation id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: playlist (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: playlist.items (optional)

// Get single playlistGeneration.
PlaylistGenerationsAPI.playlistGenerationsIdGet(id: id, include: include, replaceMedia: replaceMedia) { (response, error) in
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
 **id** | **String** | Playlist generation id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: playlist | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: playlist.items | [optional] 

### Return type

[**PlaylistGenerationsSingleResourceDataDocument**](PlaylistGenerationsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistGenerationsIdRelationshipsPlaylistGet**
```swift
    open class func playlistGenerationsIdRelationshipsPlaylistGet(id: String, include: [String]? = nil, replaceMedia: String? = nil, completion: @escaping (_ data: PlaylistGenerationsPlaylistSingleRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get playlist relationship (\"to-one\").

Retrieves playlist relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Playlist generation id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: playlist (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: playlist.items (optional)

// Get playlist relationship (\"to-one\").
PlaylistGenerationsAPI.playlistGenerationsIdRelationshipsPlaylistGet(id: id, include: include, replaceMedia: replaceMedia) { (response, error) in
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
 **id** | **String** | Playlist generation id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: playlist | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: playlist.items | [optional] 

### Return type

[**PlaylistGenerationsPlaylistSingleRelationshipDataDocument**](PlaylistGenerationsPlaylistSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistGenerationsPost**
```swift
    open class func playlistGenerationsPost(idempotencyKey: String? = nil, playlistGenerationsCreateOperationPayload: PlaylistGenerationsCreateOperationPayload? = nil, completion: @escaping (_ data: PlaylistGenerationsCreateSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Create single playlistGeneration.

Creates a new playlistGeneration.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. (optional)
let playlistGenerationsCreateOperationPayload = PlaylistGenerationsCreateOperation_Payload(data: PlaylistGenerationsCreateOperation_Payload_Data(attributes: PlaylistGenerationsCreateOperation_Payload_Data_Attributes(prompt: "prompt_example"), relationships: PlaylistGenerationsCreateOperation_Payload_Data_Relationships(playlist: PlaylistGenerationsCreateOperation_Payload_Data_Relationships_Playlist(data: PlaylistGenerationsCreateOperation_Payload_Data_Relationships_Playlist_Data(id: "id_example", type: "type_example"))), type: "type_example")) // PlaylistGenerationsCreateOperationPayload |  (optional)

// Create single playlistGeneration.
PlaylistGenerationsAPI.playlistGenerationsPost(idempotencyKey: idempotencyKey, playlistGenerationsCreateOperationPayload: playlistGenerationsCreateOperationPayload) { (response, error) in
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
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. | [optional] 
 **playlistGenerationsCreateOperationPayload** | [**PlaylistGenerationsCreateOperationPayload**](PlaylistGenerationsCreateOperationPayload.md) |  | [optional] 

### Return type

[**PlaylistGenerationsCreateSingleResourceDataDocument**](PlaylistGenerationsCreateSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

