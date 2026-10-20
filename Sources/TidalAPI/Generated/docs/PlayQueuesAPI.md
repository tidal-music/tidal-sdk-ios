# PlayQueuesAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**playQueuesGet**](PlayQueuesAPI.md#playqueuesget) | **GET** /playQueues | Get multiple playQueues.
[**playQueuesIdDelete**](PlayQueuesAPI.md#playqueuesiddelete) | **DELETE** /playQueues/{id} | Delete single playQueue.
[**playQueuesIdGet**](PlayQueuesAPI.md#playqueuesidget) | **GET** /playQueues/{id} | Get single playQueue.
[**playQueuesIdPatch**](PlayQueuesAPI.md#playqueuesidpatch) | **PATCH** /playQueues/{id} | Update single playQueue.
[**playQueuesIdRelationshipsChangeEventStreamGet**](PlayQueuesAPI.md#playqueuesidrelationshipschangeeventstreamget) | **GET** /playQueues/{id}/relationships/changeEventStream | Get changeEventStream relationship (\&quot;to-one\&quot;).
[**playQueuesIdRelationshipsCurrentGet**](PlayQueuesAPI.md#playqueuesidrelationshipscurrentget) | **GET** /playQueues/{id}/relationships/current | Get current relationship (\&quot;to-one\&quot;).
[**playQueuesIdRelationshipsCurrentPatch**](PlayQueuesAPI.md#playqueuesidrelationshipscurrentpatch) | **PATCH** /playQueues/{id}/relationships/current | Update current relationship (\&quot;to-one\&quot;).
[**playQueuesIdRelationshipsFutureDelete**](PlayQueuesAPI.md#playqueuesidrelationshipsfuturedelete) | **DELETE** /playQueues/{id}/relationships/future | Delete from future relationship (\&quot;to-many\&quot;).
[**playQueuesIdRelationshipsFutureGet**](PlayQueuesAPI.md#playqueuesidrelationshipsfutureget) | **GET** /playQueues/{id}/relationships/future | Get future relationship (\&quot;to-many\&quot;).
[**playQueuesIdRelationshipsFuturePatch**](PlayQueuesAPI.md#playqueuesidrelationshipsfuturepatch) | **PATCH** /playQueues/{id}/relationships/future | Update future relationship (\&quot;to-many\&quot;).
[**playQueuesIdRelationshipsFuturePost**](PlayQueuesAPI.md#playqueuesidrelationshipsfuturepost) | **POST** /playQueues/{id}/relationships/future | Add to future relationship (\&quot;to-many\&quot;).
[**playQueuesIdRelationshipsOwnersGet**](PlayQueuesAPI.md#playqueuesidrelationshipsownersget) | **GET** /playQueues/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
[**playQueuesIdRelationshipsPastGet**](PlayQueuesAPI.md#playqueuesidrelationshipspastget) | **GET** /playQueues/{id}/relationships/past | Get past relationship (\&quot;to-many\&quot;).
[**playQueuesPost**](PlayQueuesAPI.md#playqueuespost) | **POST** /playQueues | Create single playQueue.


# **playQueuesGet**
```swift
    open class func playQueuesGet(filterOwnersId: [String], include: [String]? = nil, includeLinkage: [IncludeLinkage_playQueuesGet]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil) async throws -> PlayQueuesMultiResourceDataDocument
```

Get multiple playQueues.

Retrieves multiple playQueues by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let filterOwnersId = ["inner_example"] // [String] | User id. Also accepts `me`.
let include = ["inner_example"] // [String] | Include related resources. Available relationships: changeEventStream, current, future, owners, past (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: current (optional)

// Get multiple playQueues.
do {
    let response = try await PlayQueuesAPI.playQueuesGet(filterOwnersId: filterOwnersId, include: include, includeLinkage: includeLinkage, pageCursor: pageCursor, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **filterOwnersId** | [**[String]**](String.md) | User id. Also accepts &#x60;me&#x60;. | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: changeEventStream, current, future, owners, past | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: current | [optional] 

### Return type

[**PlayQueuesMultiResourceDataDocument**](PlayQueuesMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playQueuesIdDelete**
```swift
    open class func playQueuesIdDelete(id: String, idempotencyKey: String? = nil) async throws -> MutationResponseDocument
```

Delete single playQueue.

Deletes existing playQueue.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Play queue id
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)

// Delete single playQueue.
do {
    let response = try await PlayQueuesAPI.playQueuesIdDelete(id: id, idempotencyKey: idempotencyKey)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Play queue id | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 

### Return type

[**MutationResponseDocument**](MutationResponseDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playQueuesIdGet**
```swift
    open class func playQueuesIdGet(id: String, include: [String]? = nil, includeLinkage: [IncludeLinkage_playQueuesIdGet]? = nil, replaceMedia: String? = nil) async throws -> PlayQueuesSingleResourceDataDocument
```

Get single playQueue.

Retrieves single playQueue by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Play queue id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: changeEventStream, current, future, owners, past (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: current (optional)

// Get single playQueue.
do {
    let response = try await PlayQueuesAPI.playQueuesIdGet(id: id, include: include, includeLinkage: includeLinkage, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Play queue id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: changeEventStream, current, future, owners, past | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: current | [optional] 

### Return type

[**PlayQueuesSingleResourceDataDocument**](PlayQueuesSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playQueuesIdPatch**
```swift
    open class func playQueuesIdPatch(id: String, idempotencyKey: String? = nil, playQueuesUpdateOperationPayload: PlayQueuesUpdateOperationPayload? = nil) async throws -> PlayQueuesUpdateSingleResourceDataDocument
```

Update single playQueue.

Atomically applies attributes, future items, then current selection.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Play queue id
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let playQueuesUpdateOperationPayload = PlayQueuesUpdateOperation_Payload(data: PlayQueuesUpdateOperation_Payload_Data(attributes: PlayQueuesUpdateOperation_Payload_Data_Attributes(_repeat: "_repeat_example", shuffle: "shuffle_example", shuffled: false), id: "id_example", relationships: PlayQueuesUpdateOperation_Payload_Data_Relationships(current: PlayQueuesUpdateOperation_Current(meta: PlayQueuesUpdateOperation_Current_Meta(itemId: "itemId_example", mode: "mode_example")), future: PlayQueuesUpdateOperation_Future(data: [PlayQueuesUpdateOperation_Future_Data(id: "id_example", type: "type_example")], meta: PlayQueuesUpdateOperation_Future_Meta(mode: "mode_example", positionBefore: "positionBefore_example", source: PlayQueuesFutureRelationshipSource(href: "href_example", startIndex: 123)))), type: "type_example")) // PlayQueuesUpdateOperationPayload |  (optional)

// Update single playQueue.
do {
    let response = try await PlayQueuesAPI.playQueuesIdPatch(id: id, idempotencyKey: idempotencyKey, playQueuesUpdateOperationPayload: playQueuesUpdateOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Play queue id | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **playQueuesUpdateOperationPayload** | [**PlayQueuesUpdateOperationPayload**](PlayQueuesUpdateOperationPayload.md) |  | [optional] 

### Return type

[**PlayQueuesUpdateSingleResourceDataDocument**](PlayQueuesUpdateSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playQueuesIdRelationshipsChangeEventStreamGet**
```swift
    open class func playQueuesIdRelationshipsChangeEventStreamGet(id: String, include: [String]? = nil) async throws -> PlayQueuesChangeEventStreamSingleRelationshipDataDocument
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
    let response = try await PlayQueuesAPI.playQueuesIdRelationshipsChangeEventStreamGet(id: id, include: include)
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

[**PlayQueuesChangeEventStreamSingleRelationshipDataDocument**](PlayQueuesChangeEventStreamSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playQueuesIdRelationshipsCurrentGet**
```swift
    open class func playQueuesIdRelationshipsCurrentGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> PlayQueuesCurrentSingleRelationshipDataDocument
```

Get current relationship (\"to-one\").

Retrieves current relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Play queue id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: current (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: current (optional)

// Get current relationship (\"to-one\").
do {
    let response = try await PlayQueuesAPI.playQueuesIdRelationshipsCurrentGet(id: id, include: include, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Play queue id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: current | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: current | [optional] 

### Return type

[**PlayQueuesCurrentSingleRelationshipDataDocument**](PlayQueuesCurrentSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playQueuesIdRelationshipsCurrentPatch**
```swift
    open class func playQueuesIdRelationshipsCurrentPatch(id: String, idempotencyKey: String? = nil, playQueuesCurrentRelationshipUpdateOperationPayload: PlayQueuesCurrentRelationshipUpdateOperationPayload? = nil) async throws -> PlayQueuesCurrentUpdateSingleRelationshipDataDocument
```

Update current relationship (\"to-one\").

Updates current relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Play queue id
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let playQueuesCurrentRelationshipUpdateOperationPayload = PlayQueuesCurrentRelationshipUpdateOperation_Payload(data: PlayQueuesCurrentRelationshipUpdateOperation_Payload_Data(id: "id_example", meta: PlayQueuesCurrentRelationshipUpdateOperation_Payload_Data_Meta(itemId: "itemId_example", position: "position_example", updatedByInstallationId: "updatedByInstallationId_example"), type: "type_example")) // PlayQueuesCurrentRelationshipUpdateOperationPayload |  (optional)

// Update current relationship (\"to-one\").
do {
    let response = try await PlayQueuesAPI.playQueuesIdRelationshipsCurrentPatch(id: id, idempotencyKey: idempotencyKey, playQueuesCurrentRelationshipUpdateOperationPayload: playQueuesCurrentRelationshipUpdateOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Play queue id | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **playQueuesCurrentRelationshipUpdateOperationPayload** | [**PlayQueuesCurrentRelationshipUpdateOperationPayload**](PlayQueuesCurrentRelationshipUpdateOperationPayload.md) |  | [optional] 

### Return type

[**PlayQueuesCurrentUpdateSingleRelationshipDataDocument**](PlayQueuesCurrentUpdateSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playQueuesIdRelationshipsFutureDelete**
```swift
    open class func playQueuesIdRelationshipsFutureDelete(id: String, idempotencyKey: String? = nil, playQueuesFutureRelationshipRemoveOperationPayload: PlayQueuesFutureRelationshipRemoveOperationPayload? = nil) async throws -> MutationResponseDocument
```

Delete from future relationship (\"to-many\").

Deletes item(s) from future relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Play queue id
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let playQueuesFutureRelationshipRemoveOperationPayload = PlayQueuesFutureRelationshipRemoveOperation_Payload(data: [PlayQueuesFutureRelationshipRemoveOperation_Payload_Data(id: "id_example", meta: PlayQueuesFutureRelationshipRemoveOperation_Payload_Data_Meta(itemId: "itemId_example"), type: "type_example")]) // PlayQueuesFutureRelationshipRemoveOperationPayload |  (optional)

// Delete from future relationship (\"to-many\").
do {
    let response = try await PlayQueuesAPI.playQueuesIdRelationshipsFutureDelete(id: id, idempotencyKey: idempotencyKey, playQueuesFutureRelationshipRemoveOperationPayload: playQueuesFutureRelationshipRemoveOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Play queue id | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **playQueuesFutureRelationshipRemoveOperationPayload** | [**PlayQueuesFutureRelationshipRemoveOperationPayload**](PlayQueuesFutureRelationshipRemoveOperationPayload.md) |  | [optional] 

### Return type

[**MutationResponseDocument**](MutationResponseDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playQueuesIdRelationshipsFutureGet**
```swift
    open class func playQueuesIdRelationshipsFutureGet(id: String, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil) async throws -> PlayQueuesFutureMultiRelationshipDataDocument
```

Get future relationship (\"to-many\").

Retrieves future relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Play queue id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: future (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: future (optional)

// Get future relationship (\"to-many\").
do {
    let response = try await PlayQueuesAPI.playQueuesIdRelationshipsFutureGet(id: id, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Play queue id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: future | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: future | [optional] 

### Return type

[**PlayQueuesFutureMultiRelationshipDataDocument**](PlayQueuesFutureMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playQueuesIdRelationshipsFuturePatch**
```swift
    open class func playQueuesIdRelationshipsFuturePatch(id: String, idempotencyKey: String? = nil, playQueuesFutureRelationshipUpdateOperationPayload: PlayQueuesFutureRelationshipUpdateOperationPayload? = nil) async throws -> PlayQueuesFutureUpdateMultiRelationshipDataDocument
```

Update future relationship (\"to-many\").

Returns empty data and meta.revision as an acknowledgement.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Play queue id
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let playQueuesFutureRelationshipUpdateOperationPayload = PlayQueuesFutureRelationshipUpdateOperation_Payload(data: [PlayQueuesFutureRelationshipUpdateOperation_Payload_Data(id: "id_example", meta: PlayQueuesFutureRelationshipUpdateOperation_Payload_Data_Meta(itemId: "itemId_example"), type: "type_example")], meta: PlayQueuesFutureRelationshipUpdateOperation_Payload_Meta(positionBefore: "positionBefore_example")) // PlayQueuesFutureRelationshipUpdateOperationPayload |  (optional)

// Update future relationship (\"to-many\").
do {
    let response = try await PlayQueuesAPI.playQueuesIdRelationshipsFuturePatch(id: id, idempotencyKey: idempotencyKey, playQueuesFutureRelationshipUpdateOperationPayload: playQueuesFutureRelationshipUpdateOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Play queue id | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **playQueuesFutureRelationshipUpdateOperationPayload** | [**PlayQueuesFutureRelationshipUpdateOperationPayload**](PlayQueuesFutureRelationshipUpdateOperationPayload.md) |  | [optional] 

### Return type

[**PlayQueuesFutureUpdateMultiRelationshipDataDocument**](PlayQueuesFutureUpdateMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playQueuesIdRelationshipsFuturePost**
```swift
    open class func playQueuesIdRelationshipsFuturePost(id: String, idempotencyKey: String? = nil, playQueuesFutureRelationshipAddOperationPayload: PlayQueuesFutureRelationshipAddOperationPayload? = nil) async throws -> PlayQueuesFutureAddMultiRelationshipDataDocument
```

Add to future relationship (\"to-many\").

With meta.source, startIndex selects an entry in the first page's data before unsupported types are skipped. Tracks and videos are added in page order, retaining duplicates; other types are skipped without expansion. Reaching 1000 added items or 100 pages queues the collected prefix. Invalid sources or indexes, a suffix with no playable items, repeated pages, and read failures encountered before a cap leave the queue unchanged. Returns empty data and meta.revision as an acknowledgement.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Play queue id
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let playQueuesFutureRelationshipAddOperationPayload = PlayQueuesFutureRelationshipAddOperation_Payload(data: [PlayQueuesFutureRelationshipAddOperation_Payload_Data(id: "id_example", type: "type_example")], meta: PlayQueuesFutureRelationshipAddOperation_Payload_Meta(batchId: 123, legacySource: LegacySource(id: "id_example", type: "type_example"), mode: "mode_example", positionBefore: "positionBefore_example", source: PlayQueuesFutureRelationshipSource(href: "href_example", startIndex: 123))) // PlayQueuesFutureRelationshipAddOperationPayload |  (optional)

// Add to future relationship (\"to-many\").
do {
    let response = try await PlayQueuesAPI.playQueuesIdRelationshipsFuturePost(id: id, idempotencyKey: idempotencyKey, playQueuesFutureRelationshipAddOperationPayload: playQueuesFutureRelationshipAddOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Play queue id | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **playQueuesFutureRelationshipAddOperationPayload** | [**PlayQueuesFutureRelationshipAddOperationPayload**](PlayQueuesFutureRelationshipAddOperationPayload.md) |  | [optional] 

### Return type

[**PlayQueuesFutureAddMultiRelationshipDataDocument**](PlayQueuesFutureAddMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playQueuesIdRelationshipsOwnersGet**
```swift
    open class func playQueuesIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> PlayQueuesOwnersMultiRelationshipDataDocument
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Play queue id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get owners relationship (\"to-many\").
do {
    let response = try await PlayQueuesAPI.playQueuesIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Play queue id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**PlayQueuesOwnersMultiRelationshipDataDocument**](PlayQueuesOwnersMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playQueuesIdRelationshipsPastGet**
```swift
    open class func playQueuesIdRelationshipsPastGet(id: String, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil) async throws -> PlayQueuesPastMultiRelationshipDataDocument
```

Get past relationship (\"to-many\").

Retrieves past relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Play queue id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: past (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: past (optional)

// Get past relationship (\"to-many\").
do {
    let response = try await PlayQueuesAPI.playQueuesIdRelationshipsPastGet(id: id, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Play queue id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: past | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: past | [optional] 

### Return type

[**PlayQueuesPastMultiRelationshipDataDocument**](PlayQueuesPastMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playQueuesPost**
```swift
    open class func playQueuesPost(idempotencyKey: String? = nil, playQueuesCreateOperationPayload: PlayQueuesCreateOperationPayload? = nil) async throws -> PlayQueuesCreateSingleResourceDataDocument
```

Create single playQueue.

Creates a new playQueue.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let playQueuesCreateOperationPayload = PlayQueuesCreateOperation_Payload(data: PlayQueuesCreateOperation_Payload_Data(type: "type_example")) // PlayQueuesCreateOperationPayload |  (optional)

// Create single playQueue.
do {
    let response = try await PlayQueuesAPI.playQueuesPost(idempotencyKey: idempotencyKey, playQueuesCreateOperationPayload: playQueuesCreateOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **playQueuesCreateOperationPayload** | [**PlayQueuesCreateOperationPayload**](PlayQueuesCreateOperationPayload.md) |  | [optional] 

### Return type

[**PlayQueuesCreateSingleResourceDataDocument**](PlayQueuesCreateSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

