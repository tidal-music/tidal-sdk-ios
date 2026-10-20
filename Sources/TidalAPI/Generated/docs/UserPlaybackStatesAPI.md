# UserPlaybackStatesAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**userPlaybackStatesIdGet**](UserPlaybackStatesAPI.md#userplaybackstatesidget) | **GET** /userPlaybackStates/{id} | Get single userPlaybackState.
[**userPlaybackStatesIdPatch**](UserPlaybackStatesAPI.md#userplaybackstatesidpatch) | **PATCH** /userPlaybackStates/{id} | Update single userPlaybackState.
[**userPlaybackStatesIdRelationshipsActivePlayerGet**](UserPlaybackStatesAPI.md#userplaybackstatesidrelationshipsactiveplayerget) | **GET** /userPlaybackStates/{id}/relationships/activePlayer | Get activePlayer relationship (\&quot;to-one\&quot;).
[**userPlaybackStatesIdRelationshipsActivePlayerPatch**](UserPlaybackStatesAPI.md#userplaybackstatesidrelationshipsactiveplayerpatch) | **PATCH** /userPlaybackStates/{id}/relationships/activePlayer | Update activePlayer relationship (\&quot;to-one\&quot;).
[**userPlaybackStatesIdRelationshipsAvailablePlayersDelete**](UserPlaybackStatesAPI.md#userplaybackstatesidrelationshipsavailableplayersdelete) | **DELETE** /userPlaybackStates/{id}/relationships/availablePlayers | Delete from availablePlayers relationship (\&quot;to-many\&quot;).
[**userPlaybackStatesIdRelationshipsAvailablePlayersGet**](UserPlaybackStatesAPI.md#userplaybackstatesidrelationshipsavailableplayersget) | **GET** /userPlaybackStates/{id}/relationships/availablePlayers | Get availablePlayers relationship (\&quot;to-many\&quot;).
[**userPlaybackStatesIdRelationshipsAvailablePlayersPost**](UserPlaybackStatesAPI.md#userplaybackstatesidrelationshipsavailableplayerspost) | **POST** /userPlaybackStates/{id}/relationships/availablePlayers | Add to availablePlayers relationship (\&quot;to-many\&quot;).
[**userPlaybackStatesIdRelationshipsChangeEventStreamGet**](UserPlaybackStatesAPI.md#userplaybackstatesidrelationshipschangeeventstreamget) | **GET** /userPlaybackStates/{id}/relationships/changeEventStream | Get changeEventStream relationship (\&quot;to-one\&quot;).
[**userPlaybackStatesIdRelationshipsPlayQueueGet**](UserPlaybackStatesAPI.md#userplaybackstatesidrelationshipsplayqueueget) | **GET** /userPlaybackStates/{id}/relationships/playQueue | Get playQueue relationship (\&quot;to-one\&quot;).
[**userPlaybackStatesIdRelationshipsPlayQueuePatch**](UserPlaybackStatesAPI.md#userplaybackstatesidrelationshipsplayqueuepatch) | **PATCH** /userPlaybackStates/{id}/relationships/playQueue | Update playQueue relationship (\&quot;to-one\&quot;).


# **userPlaybackStatesIdGet**
```swift
    open class func userPlaybackStatesIdGet(id: String, include: [String]? = nil, includeLinkage: [IncludeLinkage_userPlaybackStatesIdGet]? = nil, replaceMedia: String? = nil) async throws -> UserPlaybackStatesSingleResourceDataDocument
```

Get single userPlaybackState.

Retrieves single userPlaybackState by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User playback session id. Use `me` for the authenticated user's resource
let include = ["inner_example"] // [String] | Include related resources. Available relationships: activePlayer, availablePlayers, changeEventStream, playQueue (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: activePlayer.offlineInventory (optional)

// Get single userPlaybackState.
do {
    let response = try await UserPlaybackStatesAPI.userPlaybackStatesIdGet(id: id, include: include, includeLinkage: includeLinkage, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | User playback session id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: activePlayer, availablePlayers, changeEventStream, playQueue | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: activePlayer.offlineInventory | [optional] 

### Return type

[**UserPlaybackStatesSingleResourceDataDocument**](UserPlaybackStatesSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userPlaybackStatesIdPatch**
```swift
    open class func userPlaybackStatesIdPatch(id: String, idempotencyKey: String? = nil, userPlaybackStatesUpdateOperationPayload: UserPlaybackStatesUpdateOperationPayload? = nil) async throws -> UserPlaybackStatesUpdateSingleResourceDataDocument
```

Update single userPlaybackState.

Updates existing userPlaybackState.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User playback session id. Use `me` for the authenticated user's resource
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let userPlaybackStatesUpdateOperationPayload = UserPlaybackStatesUpdateOperation_Payload(data: UserPlaybackStatesUpdateOperation_Payload_Data(attributes: UserPlaybackStatesUpdateOperation_Payload_Data_Attributes(playbackStatus: "playbackStatus_example"), id: "id_example", type: "type_example")) // UserPlaybackStatesUpdateOperationPayload |  (optional)

// Update single userPlaybackState.
do {
    let response = try await UserPlaybackStatesAPI.userPlaybackStatesIdPatch(id: id, idempotencyKey: idempotencyKey, userPlaybackStatesUpdateOperationPayload: userPlaybackStatesUpdateOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | User playback session id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **userPlaybackStatesUpdateOperationPayload** | [**UserPlaybackStatesUpdateOperationPayload**](UserPlaybackStatesUpdateOperationPayload.md) |  | [optional] 

### Return type

[**UserPlaybackStatesUpdateSingleResourceDataDocument**](UserPlaybackStatesUpdateSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userPlaybackStatesIdRelationshipsActivePlayerGet**
```swift
    open class func userPlaybackStatesIdRelationshipsActivePlayerGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> UserPlaybackStatesActivePlayerSingleRelationshipDataDocument
```

Get activePlayer relationship (\"to-one\").

Retrieves activePlayer relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User playback session id. Use `me` for the authenticated user's resource
let include = ["inner_example"] // [String] | Include related resources. Available relationships: activePlayer (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: activePlayer.offlineInventory (optional)

// Get activePlayer relationship (\"to-one\").
do {
    let response = try await UserPlaybackStatesAPI.userPlaybackStatesIdRelationshipsActivePlayerGet(id: id, include: include, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | User playback session id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: activePlayer | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: activePlayer.offlineInventory | [optional] 

### Return type

[**UserPlaybackStatesActivePlayerSingleRelationshipDataDocument**](UserPlaybackStatesActivePlayerSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userPlaybackStatesIdRelationshipsActivePlayerPatch**
```swift
    open class func userPlaybackStatesIdRelationshipsActivePlayerPatch(id: String, idempotencyKey: String? = nil, userPlaybackStatesActivePlayerRelationshipUpdateOperationPayload: UserPlaybackStatesActivePlayerRelationshipUpdateOperationPayload? = nil) async throws -> UserPlaybackStatesActivePlayerUpdateSingleRelationshipDataDocument
```

Update activePlayer relationship (\"to-one\").

Updates activePlayer relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User playback session id. Use `me` for the authenticated user's resource
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let userPlaybackStatesActivePlayerRelationshipUpdateOperationPayload = UserPlaybackStatesActivePlayerRelationshipUpdateOperation_Payload(data: UserPlaybackStatesActivePlayerRelationshipUpdateOperation_Payload_Data(id: "id_example", type: "type_example")) // UserPlaybackStatesActivePlayerRelationshipUpdateOperationPayload |  (optional)

// Update activePlayer relationship (\"to-one\").
do {
    let response = try await UserPlaybackStatesAPI.userPlaybackStatesIdRelationshipsActivePlayerPatch(id: id, idempotencyKey: idempotencyKey, userPlaybackStatesActivePlayerRelationshipUpdateOperationPayload: userPlaybackStatesActivePlayerRelationshipUpdateOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | User playback session id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **userPlaybackStatesActivePlayerRelationshipUpdateOperationPayload** | [**UserPlaybackStatesActivePlayerRelationshipUpdateOperationPayload**](UserPlaybackStatesActivePlayerRelationshipUpdateOperationPayload.md) |  | [optional] 

### Return type

[**UserPlaybackStatesActivePlayerUpdateSingleRelationshipDataDocument**](UserPlaybackStatesActivePlayerUpdateSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userPlaybackStatesIdRelationshipsAvailablePlayersDelete**
```swift
    open class func userPlaybackStatesIdRelationshipsAvailablePlayersDelete(id: String, idempotencyKey: String? = nil, userPlaybackStatesAvailablePlayersRelationshipRemoveOperationPayload: UserPlaybackStatesAvailablePlayersRelationshipRemoveOperationPayload? = nil) async throws -> MutationResponseDocument
```

Delete from availablePlayers relationship (\"to-many\").

Deletes item(s) from availablePlayers relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User playback session id. Use `me` for the authenticated user's resource
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let userPlaybackStatesAvailablePlayersRelationshipRemoveOperationPayload = UserPlaybackStatesAvailablePlayersRelationshipRemoveOperation_Payload(data: [UserPlaybackStatesAvailablePlayersRelationshipOperation_Payload_Data(id: "id_example", type: "type_example")]) // UserPlaybackStatesAvailablePlayersRelationshipRemoveOperationPayload |  (optional)

// Delete from availablePlayers relationship (\"to-many\").
do {
    let response = try await UserPlaybackStatesAPI.userPlaybackStatesIdRelationshipsAvailablePlayersDelete(id: id, idempotencyKey: idempotencyKey, userPlaybackStatesAvailablePlayersRelationshipRemoveOperationPayload: userPlaybackStatesAvailablePlayersRelationshipRemoveOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | User playback session id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **userPlaybackStatesAvailablePlayersRelationshipRemoveOperationPayload** | [**UserPlaybackStatesAvailablePlayersRelationshipRemoveOperationPayload**](UserPlaybackStatesAvailablePlayersRelationshipRemoveOperationPayload.md) |  | [optional] 

### Return type

[**MutationResponseDocument**](MutationResponseDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userPlaybackStatesIdRelationshipsAvailablePlayersGet**
```swift
    open class func userPlaybackStatesIdRelationshipsAvailablePlayersGet(id: String, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil) async throws -> UserPlaybackStatesAvailablePlayersMultiRelationshipDataDocument
```

Get availablePlayers relationship (\"to-many\").

Retrieves availablePlayers relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User playback session id. Use `me` for the authenticated user's resource
let include = ["inner_example"] // [String] | Include related resources. Available relationships: availablePlayers (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: availablePlayers.offlineInventory (optional)

// Get availablePlayers relationship (\"to-many\").
do {
    let response = try await UserPlaybackStatesAPI.userPlaybackStatesIdRelationshipsAvailablePlayersGet(id: id, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | User playback session id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: availablePlayers | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: availablePlayers.offlineInventory | [optional] 

### Return type

[**UserPlaybackStatesAvailablePlayersMultiRelationshipDataDocument**](UserPlaybackStatesAvailablePlayersMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userPlaybackStatesIdRelationshipsAvailablePlayersPost**
```swift
    open class func userPlaybackStatesIdRelationshipsAvailablePlayersPost(id: String, idempotencyKey: String? = nil, userPlaybackStatesAvailablePlayersRelationshipAddOperationPayload: UserPlaybackStatesAvailablePlayersRelationshipAddOperationPayload? = nil) async throws -> UserPlaybackStatesAvailablePlayersAddMultiRelationshipDataDocument
```

Add to availablePlayers relationship (\"to-many\").

Adds item(s) to availablePlayers relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User playback session id. Use `me` for the authenticated user's resource
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let userPlaybackStatesAvailablePlayersRelationshipAddOperationPayload = UserPlaybackStatesAvailablePlayersRelationshipAddOperation_Payload(data: [UserPlaybackStatesAvailablePlayersRelationshipOperation_Payload_Data(id: "id_example", type: "type_example")]) // UserPlaybackStatesAvailablePlayersRelationshipAddOperationPayload |  (optional)

// Add to availablePlayers relationship (\"to-many\").
do {
    let response = try await UserPlaybackStatesAPI.userPlaybackStatesIdRelationshipsAvailablePlayersPost(id: id, idempotencyKey: idempotencyKey, userPlaybackStatesAvailablePlayersRelationshipAddOperationPayload: userPlaybackStatesAvailablePlayersRelationshipAddOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | User playback session id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **userPlaybackStatesAvailablePlayersRelationshipAddOperationPayload** | [**UserPlaybackStatesAvailablePlayersRelationshipAddOperationPayload**](UserPlaybackStatesAvailablePlayersRelationshipAddOperationPayload.md) |  | [optional] 

### Return type

[**UserPlaybackStatesAvailablePlayersAddMultiRelationshipDataDocument**](UserPlaybackStatesAvailablePlayersAddMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userPlaybackStatesIdRelationshipsChangeEventStreamGet**
```swift
    open class func userPlaybackStatesIdRelationshipsChangeEventStreamGet(id: String, include: [String]? = nil) async throws -> UserPlaybackStatesChangeEventStreamSingleRelationshipDataDocument
```

Get changeEventStream relationship (\"to-one\").

Retrieves changeEventStream relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | 
let include = ["inner_example"] // [String] | Include related resources. Available relationships: changeEventStream (optional)

// Get changeEventStream relationship (\"to-one\").
do {
    let response = try await UserPlaybackStatesAPI.userPlaybackStatesIdRelationshipsChangeEventStreamGet(id: id, include: include)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** |  | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: changeEventStream | [optional] 

### Return type

[**UserPlaybackStatesChangeEventStreamSingleRelationshipDataDocument**](UserPlaybackStatesChangeEventStreamSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userPlaybackStatesIdRelationshipsPlayQueueGet**
```swift
    open class func userPlaybackStatesIdRelationshipsPlayQueueGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> UserPlaybackStatesPlayQueueSingleRelationshipDataDocument
```

Get playQueue relationship (\"to-one\").

Retrieves playQueue relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User playback session id. Use `me` for the authenticated user's resource
let include = ["inner_example"] // [String] | Include related resources. Available relationships: playQueue (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: playQueue.current (optional)

// Get playQueue relationship (\"to-one\").
do {
    let response = try await UserPlaybackStatesAPI.userPlaybackStatesIdRelationshipsPlayQueueGet(id: id, include: include, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | User playback session id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: playQueue | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: playQueue.current | [optional] 

### Return type

[**UserPlaybackStatesPlayQueueSingleRelationshipDataDocument**](UserPlaybackStatesPlayQueueSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userPlaybackStatesIdRelationshipsPlayQueuePatch**
```swift
    open class func userPlaybackStatesIdRelationshipsPlayQueuePatch(id: String, idempotencyKey: String? = nil, userPlaybackStatesPlayQueueRelationshipUpdateOperationPayload: UserPlaybackStatesPlayQueueRelationshipUpdateOperationPayload? = nil) async throws -> UserPlaybackStatesPlayQueueUpdateSingleRelationshipDataDocument
```

Update playQueue relationship (\"to-one\").

Updates playQueue relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User playback session id. Use `me` for the authenticated user's resource
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let userPlaybackStatesPlayQueueRelationshipUpdateOperationPayload = UserPlaybackStatesPlayQueueRelationshipUpdateOperation_Payload(data: UserPlaybackStatesPlayQueueRelationshipUpdateOperation_Payload_Data(id: "id_example", type: "type_example")) // UserPlaybackStatesPlayQueueRelationshipUpdateOperationPayload |  (optional)

// Update playQueue relationship (\"to-one\").
do {
    let response = try await UserPlaybackStatesAPI.userPlaybackStatesIdRelationshipsPlayQueuePatch(id: id, idempotencyKey: idempotencyKey, userPlaybackStatesPlayQueueRelationshipUpdateOperationPayload: userPlaybackStatesPlayQueueRelationshipUpdateOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | User playback session id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **userPlaybackStatesPlayQueueRelationshipUpdateOperationPayload** | [**UserPlaybackStatesPlayQueueRelationshipUpdateOperationPayload**](UserPlaybackStatesPlayQueueRelationshipUpdateOperationPayload.md) |  | [optional] 

### Return type

[**UserPlaybackStatesPlayQueueUpdateSingleRelationshipDataDocument**](UserPlaybackStatesPlayQueueUpdateSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

