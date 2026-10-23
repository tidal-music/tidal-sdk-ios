# OfflineTasksAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**offlineTasksGet**](OfflineTasksAPI.md#offlinetasksget) | **GET** /offlineTasks | Get multiple offlineTasks.
[**offlineTasksIdGet**](OfflineTasksAPI.md#offlinetasksidget) | **GET** /offlineTasks/{id} | Get single offlineTask.
[**offlineTasksIdPatch**](OfflineTasksAPI.md#offlinetasksidpatch) | **PATCH** /offlineTasks/{id} | Update single offlineTask.
[**offlineTasksIdRelationshipsCollectionGet**](OfflineTasksAPI.md#offlinetasksidrelationshipscollectionget) | **GET** /offlineTasks/{id}/relationships/collection | Get collection relationship (\&quot;to-one\&quot;).
[**offlineTasksIdRelationshipsItemGet**](OfflineTasksAPI.md#offlinetasksidrelationshipsitemget) | **GET** /offlineTasks/{id}/relationships/item | Get item relationship (\&quot;to-one\&quot;).
[**offlineTasksIdRelationshipsOwnersGet**](OfflineTasksAPI.md#offlinetasksidrelationshipsownersget) | **GET** /offlineTasks/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).


# **offlineTasksGet**
```swift
    open class func offlineTasksGet(filterInstallationId: [String], include: [String]? = nil, includeLinkage: [IncludeLinkage_offlineTasksGet]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil) async throws -> OfflineTasksMultiResourceDataDocument
```

Get multiple offlineTasks.

Retrieves multiple offlineTasks by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let filterInstallationId = ["inner_example"] // [String] | List of offline task IDs (e.g. `a468bee88def`)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: collection, item, owners (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: collection (optional)

// Get multiple offlineTasks.
do {
    let response = try await OfflineTasksAPI.offlineTasksGet(filterInstallationId: filterInstallationId, include: include, includeLinkage: includeLinkage, pageCursor: pageCursor, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **filterInstallationId** | [**[String]**](String.md) | List of offline task IDs (e.g. &#x60;a468bee88def&#x60;) | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: collection, item, owners | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: collection | [optional] 

### Return type

[**OfflineTasksMultiResourceDataDocument**](OfflineTasksMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **offlineTasksIdGet**
```swift
    open class func offlineTasksIdGet(id: String, include: [String]? = nil, includeLinkage: [IncludeLinkage_offlineTasksIdGet]? = nil, replaceMedia: String? = nil) async throws -> OfflineTasksSingleResourceDataDocument
```

Get single offlineTask.

Retrieves single offlineTask by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Offline task id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: collection, item, owners (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: collection (optional)

// Get single offlineTask.
do {
    let response = try await OfflineTasksAPI.offlineTasksIdGet(id: id, include: include, includeLinkage: includeLinkage, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Offline task id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: collection, item, owners | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: collection | [optional] 

### Return type

[**OfflineTasksSingleResourceDataDocument**](OfflineTasksSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **offlineTasksIdPatch**
```swift
    open class func offlineTasksIdPatch(id: String, idempotencyKey: String? = nil, offlineTasksUpdateOperationPayload: OfflineTasksUpdateOperationPayload? = nil) async throws -> MutationResponseDocument
```

Update single offlineTask.

Updates existing offlineTask.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Offline task id
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let offlineTasksUpdateOperationPayload = OfflineTasksUpdateOperation_Payload(data: OfflineTasksUpdateOperation_Payload_Data(attributes: OfflineTasksUpdateOperation_Payload_Data_Attributes(state: "state_example"), id: "id_example", type: "type_example")) // OfflineTasksUpdateOperationPayload |  (optional)

// Update single offlineTask.
do {
    let response = try await OfflineTasksAPI.offlineTasksIdPatch(id: id, idempotencyKey: idempotencyKey, offlineTasksUpdateOperationPayload: offlineTasksUpdateOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Offline task id | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **offlineTasksUpdateOperationPayload** | [**OfflineTasksUpdateOperationPayload**](OfflineTasksUpdateOperationPayload.md) |  | [optional] 

### Return type

[**MutationResponseDocument**](MutationResponseDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **offlineTasksIdRelationshipsCollectionGet**
```swift
    open class func offlineTasksIdRelationshipsCollectionGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> OfflineTasksCollectionSingleRelationshipDataDocument
```

Get collection relationship (\"to-one\").

Retrieves collection relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Offline task id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: collection (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: collection (optional)

// Get collection relationship (\"to-one\").
do {
    let response = try await OfflineTasksAPI.offlineTasksIdRelationshipsCollectionGet(id: id, include: include, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Offline task id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: collection | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: collection | [optional] 

### Return type

[**OfflineTasksCollectionSingleRelationshipDataDocument**](OfflineTasksCollectionSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **offlineTasksIdRelationshipsItemGet**
```swift
    open class func offlineTasksIdRelationshipsItemGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> OfflineTasksItemSingleRelationshipDataDocument
```

Get item relationship (\"to-one\").

Retrieves item relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Offline task id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: item (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: item (optional)

// Get item relationship (\"to-one\").
do {
    let response = try await OfflineTasksAPI.offlineTasksIdRelationshipsItemGet(id: id, include: include, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Offline task id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: item | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: item | [optional] 

### Return type

[**OfflineTasksItemSingleRelationshipDataDocument**](OfflineTasksItemSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **offlineTasksIdRelationshipsOwnersGet**
```swift
    open class func offlineTasksIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> OfflineTasksOwnersMultiRelationshipDataDocument
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Offline task id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get owners relationship (\"to-many\").
do {
    let response = try await OfflineTasksAPI.offlineTasksIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Offline task id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**OfflineTasksOwnersMultiRelationshipDataDocument**](OfflineTasksOwnersMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

