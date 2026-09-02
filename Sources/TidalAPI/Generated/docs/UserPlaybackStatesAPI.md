# UserPlaybackStatesAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**userPlaybackStatesIdGet**](UserPlaybackStatesAPI.md#userplaybackstatesidget) | **GET** /userPlaybackStates/{id} | Get single userPlaybackState.
[**userPlaybackStatesIdPatch**](UserPlaybackStatesAPI.md#userplaybackstatesidpatch) | **PATCH** /userPlaybackStates/{id} | Update single userPlaybackState.
[**userPlaybackStatesIdRelationshipsInstallationsDelete**](UserPlaybackStatesAPI.md#userplaybackstatesidrelationshipsinstallationsdelete) | **DELETE** /userPlaybackStates/{id}/relationships/installations | Delete from installations relationship (\&quot;to-many\&quot;).
[**userPlaybackStatesIdRelationshipsInstallationsGet**](UserPlaybackStatesAPI.md#userplaybackstatesidrelationshipsinstallationsget) | **GET** /userPlaybackStates/{id}/relationships/installations | Get installations relationship (\&quot;to-many\&quot;).
[**userPlaybackStatesIdRelationshipsInstallationsPost**](UserPlaybackStatesAPI.md#userplaybackstatesidrelationshipsinstallationspost) | **POST** /userPlaybackStates/{id}/relationships/installations | Add to installations relationship (\&quot;to-many\&quot;).
[**userPlaybackStatesIdRelationshipsPlayQueueGet**](UserPlaybackStatesAPI.md#userplaybackstatesidrelationshipsplayqueueget) | **GET** /userPlaybackStates/{id}/relationships/playQueue | Get playQueue relationship (\&quot;to-one\&quot;).
[**userPlaybackStatesIdRelationshipsPlayQueuePatch**](UserPlaybackStatesAPI.md#userplaybackstatesidrelationshipsplayqueuepatch) | **PATCH** /userPlaybackStates/{id}/relationships/playQueue | Update playQueue relationship (\&quot;to-one\&quot;).
[**userPlaybackStatesIdRelationshipsPlayerGet**](UserPlaybackStatesAPI.md#userplaybackstatesidrelationshipsplayerget) | **GET** /userPlaybackStates/{id}/relationships/player | Get player relationship (\&quot;to-one\&quot;).
[**userPlaybackStatesIdRelationshipsPlayerPatch**](UserPlaybackStatesAPI.md#userplaybackstatesidrelationshipsplayerpatch) | **PATCH** /userPlaybackStates/{id}/relationships/player | Update player relationship (\&quot;to-one\&quot;).


# **userPlaybackStatesIdGet**
```swift
    open class func userPlaybackStatesIdGet(id: String, include: [String]? = nil, replaceMedia: String? = nil, completion: @escaping (_ data: UserPlaybackStatesSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single userPlaybackState.

Retrieves single userPlaybackState by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User playback session id. Use `me` for the authenticated user's resource
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: installations, playQueue, player (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: installations.offlineInventory (optional)

// Get single userPlaybackState.
UserPlaybackStatesAPI.userPlaybackStatesIdGet(id: id, include: include, replaceMedia: replaceMedia) { (response, error) in
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
 **id** | **String** | User playback session id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: installations, playQueue, player | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: installations.offlineInventory | [optional] 

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
    open class func userPlaybackStatesIdPatch(id: String, idempotencyKey: String? = nil, userPlaybackStatesUpdateOperationPayload: UserPlaybackStatesUpdateOperationPayload? = nil, completion: @escaping (_ data: UserPlaybackStatesUpdateSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Update single userPlaybackState.

Updates existing userPlaybackState.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User playback session id. Use `me` for the authenticated user's resource
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. (optional)
let userPlaybackStatesUpdateOperationPayload = UserPlaybackStatesUpdateOperation_Payload(data: UserPlaybackStatesUpdateOperation_Payload_Data(attributes: UserPlaybackStatesUpdateOperation_Payload_Data_Attributes(playbackStatus: "playbackStatus_example"), id: "id_example", type: "type_example")) // UserPlaybackStatesUpdateOperationPayload |  (optional)

// Update single userPlaybackState.
UserPlaybackStatesAPI.userPlaybackStatesIdPatch(id: id, idempotencyKey: idempotencyKey, userPlaybackStatesUpdateOperationPayload: userPlaybackStatesUpdateOperationPayload) { (response, error) in
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
 **id** | **String** | User playback session id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. | [optional] 
 **userPlaybackStatesUpdateOperationPayload** | [**UserPlaybackStatesUpdateOperationPayload**](UserPlaybackStatesUpdateOperationPayload.md) |  | [optional] 

### Return type

[**UserPlaybackStatesUpdateSingleResourceDataDocument**](UserPlaybackStatesUpdateSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userPlaybackStatesIdRelationshipsInstallationsDelete**
```swift
    open class func userPlaybackStatesIdRelationshipsInstallationsDelete(id: String, idempotencyKey: String? = nil, userPlaybackStatesInstallationsRelationshipRemoveOperationPayload: UserPlaybackStatesInstallationsRelationshipRemoveOperationPayload? = nil, completion: @escaping (_ data: MutationResponseDocument?, _ error: Error?) -> Void)
```

Delete from installations relationship (\"to-many\").

Deletes item(s) from installations relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User playback session id. Use `me` for the authenticated user's resource
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. (optional)
let userPlaybackStatesInstallationsRelationshipRemoveOperationPayload = UserPlaybackStatesInstallationsRelationshipRemoveOperation_Payload(data: [UserPlaybackStatesInstallationsRelationshipOperation_Payload_Data(id: "id_example", type: "type_example")]) // UserPlaybackStatesInstallationsRelationshipRemoveOperationPayload |  (optional)

// Delete from installations relationship (\"to-many\").
UserPlaybackStatesAPI.userPlaybackStatesIdRelationshipsInstallationsDelete(id: id, idempotencyKey: idempotencyKey, userPlaybackStatesInstallationsRelationshipRemoveOperationPayload: userPlaybackStatesInstallationsRelationshipRemoveOperationPayload) { (response, error) in
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
 **id** | **String** | User playback session id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. | [optional] 
 **userPlaybackStatesInstallationsRelationshipRemoveOperationPayload** | [**UserPlaybackStatesInstallationsRelationshipRemoveOperationPayload**](UserPlaybackStatesInstallationsRelationshipRemoveOperationPayload.md) |  | [optional] 

### Return type

[**MutationResponseDocument**](MutationResponseDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userPlaybackStatesIdRelationshipsInstallationsGet**
```swift
    open class func userPlaybackStatesIdRelationshipsInstallationsGet(id: String, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil, completion: @escaping (_ data: UserPlaybackStatesInstallationsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get installations relationship (\"to-many\").

Retrieves installations relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User playback session id. Use `me` for the authenticated user's resource
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: installations (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: installations.offlineInventory (optional)

// Get installations relationship (\"to-many\").
UserPlaybackStatesAPI.userPlaybackStatesIdRelationshipsInstallationsGet(id: id, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia) { (response, error) in
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
 **id** | **String** | User playback session id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: installations | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: installations.offlineInventory | [optional] 

### Return type

[**UserPlaybackStatesInstallationsMultiRelationshipDataDocument**](UserPlaybackStatesInstallationsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userPlaybackStatesIdRelationshipsInstallationsPost**
```swift
    open class func userPlaybackStatesIdRelationshipsInstallationsPost(id: String, idempotencyKey: String? = nil, userPlaybackStatesInstallationsRelationshipAddOperationPayload: UserPlaybackStatesInstallationsRelationshipAddOperationPayload? = nil, completion: @escaping (_ data: UserPlaybackStatesInstallationsAddMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Add to installations relationship (\"to-many\").

Adds item(s) to installations relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User playback session id. Use `me` for the authenticated user's resource
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. (optional)
let userPlaybackStatesInstallationsRelationshipAddOperationPayload = UserPlaybackStatesInstallationsRelationshipAddOperation_Payload(data: [UserPlaybackStatesInstallationsRelationshipOperation_Payload_Data(id: "id_example", type: "type_example")]) // UserPlaybackStatesInstallationsRelationshipAddOperationPayload |  (optional)

// Add to installations relationship (\"to-many\").
UserPlaybackStatesAPI.userPlaybackStatesIdRelationshipsInstallationsPost(id: id, idempotencyKey: idempotencyKey, userPlaybackStatesInstallationsRelationshipAddOperationPayload: userPlaybackStatesInstallationsRelationshipAddOperationPayload) { (response, error) in
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
 **id** | **String** | User playback session id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. | [optional] 
 **userPlaybackStatesInstallationsRelationshipAddOperationPayload** | [**UserPlaybackStatesInstallationsRelationshipAddOperationPayload**](UserPlaybackStatesInstallationsRelationshipAddOperationPayload.md) |  | [optional] 

### Return type

[**UserPlaybackStatesInstallationsAddMultiRelationshipDataDocument**](UserPlaybackStatesInstallationsAddMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userPlaybackStatesIdRelationshipsPlayQueueGet**
```swift
    open class func userPlaybackStatesIdRelationshipsPlayQueueGet(id: String, include: [String]? = nil, replaceMedia: String? = nil, completion: @escaping (_ data: UserPlaybackStatesPlayQueueSingleRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get playQueue relationship (\"to-one\").

Retrieves playQueue relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User playback session id. Use `me` for the authenticated user's resource
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: playQueue (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: playQueue.current (optional)

// Get playQueue relationship (\"to-one\").
UserPlaybackStatesAPI.userPlaybackStatesIdRelationshipsPlayQueueGet(id: id, include: include, replaceMedia: replaceMedia) { (response, error) in
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
 **id** | **String** | User playback session id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: playQueue | [optional] 
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
    open class func userPlaybackStatesIdRelationshipsPlayQueuePatch(id: String, idempotencyKey: String? = nil, userPlaybackStatesPlayQueueRelationshipUpdateOperationPayload: UserPlaybackStatesPlayQueueRelationshipUpdateOperationPayload? = nil, completion: @escaping (_ data: UserPlaybackStatesPlayQueueUpdateSingleRelationshipDataDocument?, _ error: Error?) -> Void)
```

Update playQueue relationship (\"to-one\").

Updates playQueue relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User playback session id. Use `me` for the authenticated user's resource
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. (optional)
let userPlaybackStatesPlayQueueRelationshipUpdateOperationPayload = UserPlaybackStatesPlayQueueRelationshipUpdateOperation_Payload(data: UserPlaybackStatesPlayQueueRelationshipUpdateOperation_Payload_Data(id: "id_example", type: "type_example")) // UserPlaybackStatesPlayQueueRelationshipUpdateOperationPayload |  (optional)

// Update playQueue relationship (\"to-one\").
UserPlaybackStatesAPI.userPlaybackStatesIdRelationshipsPlayQueuePatch(id: id, idempotencyKey: idempotencyKey, userPlaybackStatesPlayQueueRelationshipUpdateOperationPayload: userPlaybackStatesPlayQueueRelationshipUpdateOperationPayload) { (response, error) in
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
 **id** | **String** | User playback session id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. | [optional] 
 **userPlaybackStatesPlayQueueRelationshipUpdateOperationPayload** | [**UserPlaybackStatesPlayQueueRelationshipUpdateOperationPayload**](UserPlaybackStatesPlayQueueRelationshipUpdateOperationPayload.md) |  | [optional] 

### Return type

[**UserPlaybackStatesPlayQueueUpdateSingleRelationshipDataDocument**](UserPlaybackStatesPlayQueueUpdateSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userPlaybackStatesIdRelationshipsPlayerGet**
```swift
    open class func userPlaybackStatesIdRelationshipsPlayerGet(id: String, include: [String]? = nil, replaceMedia: String? = nil, completion: @escaping (_ data: UserPlaybackStatesPlayerSingleRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get player relationship (\"to-one\").

Retrieves player relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User playback session id. Use `me` for the authenticated user's resource
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: player (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: player.offlineInventory (optional)

// Get player relationship (\"to-one\").
UserPlaybackStatesAPI.userPlaybackStatesIdRelationshipsPlayerGet(id: id, include: include, replaceMedia: replaceMedia) { (response, error) in
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
 **id** | **String** | User playback session id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: player | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: player.offlineInventory | [optional] 

### Return type

[**UserPlaybackStatesPlayerSingleRelationshipDataDocument**](UserPlaybackStatesPlayerSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userPlaybackStatesIdRelationshipsPlayerPatch**
```swift
    open class func userPlaybackStatesIdRelationshipsPlayerPatch(id: String, idempotencyKey: String? = nil, userPlaybackStatesPlayerRelationshipUpdateOperationPayload: UserPlaybackStatesPlayerRelationshipUpdateOperationPayload? = nil, completion: @escaping (_ data: UserPlaybackStatesPlayerUpdateSingleRelationshipDataDocument?, _ error: Error?) -> Void)
```

Update player relationship (\"to-one\").

Updates player relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User playback session id. Use `me` for the authenticated user's resource
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. (optional)
let userPlaybackStatesPlayerRelationshipUpdateOperationPayload = UserPlaybackStatesPlayerRelationshipUpdateOperation_Payload(data: UserPlaybackStatesPlayerRelationshipUpdateOperation_Payload_Data(id: "id_example", type: "type_example")) // UserPlaybackStatesPlayerRelationshipUpdateOperationPayload |  (optional)

// Update player relationship (\"to-one\").
UserPlaybackStatesAPI.userPlaybackStatesIdRelationshipsPlayerPatch(id: id, idempotencyKey: idempotencyKey, userPlaybackStatesPlayerRelationshipUpdateOperationPayload: userPlaybackStatesPlayerRelationshipUpdateOperationPayload) { (response, error) in
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
 **id** | **String** | User playback session id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. | [optional] 
 **userPlaybackStatesPlayerRelationshipUpdateOperationPayload** | [**UserPlaybackStatesPlayerRelationshipUpdateOperationPayload**](UserPlaybackStatesPlayerRelationshipUpdateOperationPayload.md) |  | [optional] 

### Return type

[**UserPlaybackStatesPlayerUpdateSingleRelationshipDataDocument**](UserPlaybackStatesPlayerUpdateSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

