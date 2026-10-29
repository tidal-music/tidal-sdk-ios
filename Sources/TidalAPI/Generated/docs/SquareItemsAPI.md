# SquareItemsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**operationsPost**](SquareItemsAPI.md#operationspost) | **POST** /operations | Commit atomic resource operations
[**squareItemsGet**](SquareItemsAPI.md#squareitemsget) | **GET** /squareItems | Get multiple squareItems.
[**squareItemsIdDelete**](SquareItemsAPI.md#squareitemsiddelete) | **DELETE** /squareItems/{id} | Delete single squareItem.
[**squareItemsIdGet**](SquareItemsAPI.md#squareitemsidget) | **GET** /squareItems/{id} | Get single squareItem.
[**squareItemsIdPatch**](SquareItemsAPI.md#squareitemsidpatch) | **PATCH** /squareItems/{id} | Update single squareItem.
[**squareItemsIdRelationshipsArtworksGet**](SquareItemsAPI.md#squareitemsidrelationshipsartworksget) | **GET** /squareItems/{id}/relationships/artworks | Get artworks relationship (\&quot;to-many\&quot;).
[**squareItemsIdRelationshipsArtworksPatch**](SquareItemsAPI.md#squareitemsidrelationshipsartworkspatch) | **PATCH** /squareItems/{id}/relationships/artworks | Update artworks relationship (\&quot;to-many\&quot;).
[**squareItemsIdRelationshipsOwnersGet**](SquareItemsAPI.md#squareitemsidrelationshipsownersget) | **GET** /squareItems/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
[**squareItemsIdRelationshipsVariationsGet**](SquareItemsAPI.md#squareitemsidrelationshipsvariationsget) | **GET** /squareItems/{id}/relationships/variations | Get variations relationship (\&quot;to-many\&quot;).
[**squareItemsIdRelationshipsVariationsPatch**](SquareItemsAPI.md#squareitemsidrelationshipsvariationspatch) | **PATCH** /squareItems/{id}/relationships/variations | Update variations relationship (\&quot;to-many\&quot;).


# **operationsPost**
```swift
    open class func operationsPost(idempotencyKey: String, atomicOperationsRequest: AtomicOperationsRequest) async throws -> AtomicOperationsResponse
```

Commit atomic resource operations

Commits a supported group of resource creations together. Only add operations without ref or href are supported. Local linkage must reference an earlier creation. Each resource's mutation policy applies. After a timeout or server error, retry unchanged with the original Idempotency-Key. Replay is bounded by downstream receipt and idempotency retention.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let idempotencyKey = "idempotencyKey_example" // String | Retry an unchanged request with the original key after a timeout or server error. Replay is bounded by downstream receipt and idempotency retention.
let atomicOperationsRequest = Atomic_Operations_Request(atomicOperations: [Atomic_Operations_Request_atomic_operations_inner(data: SquareItemsCreateOperation_Payload_Data(attributes: SquareItemsCreateOperation_Payload_Data_Attributes(description: "description_example", title: "title_example"), lid: "lid_example", relationships: SquareItemsCreateOperation_Payload_Data_Relationships(sites: SquareItemsCreateOperation_Payload_Data_Relationships_Sites(data: [Site(id: "id_example", type: "type_example")])), type: "type_example"), op: "op_example")]) // AtomicOperationsRequest | 

// Commit atomic resource operations
do {
    let response = try await SquareItemsAPI.operationsPost(idempotencyKey: idempotencyKey, atomicOperationsRequest: atomicOperationsRequest)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idempotencyKey** | **String** | Retry an unchanged request with the original key after a timeout or server error. Replay is bounded by downstream receipt and idempotency retention. | 
 **atomicOperationsRequest** | [**AtomicOperationsRequest**](AtomicOperationsRequest.md) |  | 

### Return type

[**AtomicOperationsResponse**](AtomicOperationsResponse.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json;ext=https://jsonapi.org/ext/atomic
 - **Accept**: application/vnd.api+json;ext=https://jsonapi.org/ext/atomic

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **squareItemsGet**
```swift
    open class func squareItemsGet(filterOwnersId: [String], filterOrigin: FilterOrigin_squareItemsGet? = nil, filterQuery: String? = nil, include: [String]? = nil, includeLinkage: [IncludeLinkage_squareItemsGet]? = nil, pageCursor: String? = nil) async throws -> SquareItemsMultiResourceDataDocument
```

Get multiple squareItems.

Retrieves multiple squareItems by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let filterOwnersId = ["inner_example"] // [String] | User id. Also accepts `me`.
let filterOrigin = "filterOrigin_example" // String | Only items with this origin (e.g. `TIDAL`) (optional)
let filterQuery = "filterQuery_example" // String | Word-prefix match on item titles, descriptions and abbreviations, and on variation names, SKUs and UPCs (e.g. `tee`) (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: artworks, owners, variations (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get multiple squareItems.
do {
    let response = try await SquareItemsAPI.squareItemsGet(filterOwnersId: filterOwnersId, filterOrigin: filterOrigin, filterQuery: filterQuery, include: include, includeLinkage: includeLinkage, pageCursor: pageCursor)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **filterOwnersId** | [**[String]**](String.md) | User id. Also accepts &#x60;me&#x60;. | 
 **filterOrigin** | **String** | Only items with this origin (e.g. &#x60;TIDAL&#x60;) | [optional] 
 **filterQuery** | **String** | Word-prefix match on item titles, descriptions and abbreviations, and on variation names, SKUs and UPCs (e.g. &#x60;tee&#x60;) | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: artworks, owners, variations | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**SquareItemsMultiResourceDataDocument**](SquareItemsMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **squareItemsIdDelete**
```swift
    open class func squareItemsIdDelete(id: String, idempotencyKey: String? = nil) async throws -> MutationResponseDocument
```

Delete single squareItem.

Deletes existing squareItem.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Square item id
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)

// Delete single squareItem.
do {
    let response = try await SquareItemsAPI.squareItemsIdDelete(id: id, idempotencyKey: idempotencyKey)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Square item id | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 

### Return type

[**MutationResponseDocument**](MutationResponseDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **squareItemsIdGet**
```swift
    open class func squareItemsIdGet(id: String, include: [String]? = nil, includeLinkage: [IncludeLinkage_squareItemsIdGet]? = nil) async throws -> SquareItemsSingleResourceDataDocument
```

Get single squareItem.

Retrieves single squareItem by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Square item id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: artworks, owners, variations (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)

// Get single squareItem.
do {
    let response = try await SquareItemsAPI.squareItemsIdGet(id: id, include: include, includeLinkage: includeLinkage)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Square item id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: artworks, owners, variations | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 

### Return type

[**SquareItemsSingleResourceDataDocument**](SquareItemsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **squareItemsIdPatch**
```swift
    open class func squareItemsIdPatch(id: String, idempotencyKey: String, squareItemsUpdateOperationPayload: SquareItemsUpdateOperationPayload? = nil) async throws -> SquareItemsUpdateSingleResourceDataDocument
```

Update single squareItem.

Updates existing squareItem.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Square item id
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned.
let squareItemsUpdateOperationPayload = SquareItemsUpdateOperation_Payload(data: SquareItemsUpdateOperation_Payload_Data(attributes: SquareItemsUpdateOperation_Payload_Data_Attributes(description: "description_example", title: "title_example"), id: "id_example", type: "type_example"), meta: SquareItemsUpdateOperation_Payload_Meta(expectedRevision: 123)) // SquareItemsUpdateOperationPayload |  (optional)

// Update single squareItem.
do {
    let response = try await SquareItemsAPI.squareItemsIdPatch(id: id, idempotencyKey: idempotencyKey, squareItemsUpdateOperationPayload: squareItemsUpdateOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Square item id | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | 
 **squareItemsUpdateOperationPayload** | [**SquareItemsUpdateOperationPayload**](SquareItemsUpdateOperationPayload.md) |  | [optional] 

### Return type

[**SquareItemsUpdateSingleResourceDataDocument**](SquareItemsUpdateSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **squareItemsIdRelationshipsArtworksGet**
```swift
    open class func squareItemsIdRelationshipsArtworksGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> SquareItemsArtworksMultiRelationshipDataDocument
```

Get artworks relationship (\"to-many\").

A photo Square has no URL for stays in the list and its artwork has no files.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Square item id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: artworks (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get artworks relationship (\"to-many\").
do {
    let response = try await SquareItemsAPI.squareItemsIdRelationshipsArtworksGet(id: id, include: include, pageCursor: pageCursor)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Square item id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: artworks | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**SquareItemsArtworksMultiRelationshipDataDocument**](SquareItemsArtworksMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **squareItemsIdRelationshipsArtworksPatch**
```swift
    open class func squareItemsIdRelationshipsArtworksPatch(id: String, idempotencyKey: String, squareItemsArtworksRelationshipUpdateOperationPayload: SquareItemsArtworksRelationshipUpdateOperationPayload? = nil) async throws -> SquareItemsArtworksUpdateMultiRelationshipDataDocument
```

Update artworks relationship (\"to-many\").

Replaces the item's photos with the complete ordered list. Omitted photos are detached and stay in the seller's Square catalog; an empty list clears them. The first artwork is the primary photo. Duplicate artwork IDs are rejected. Uploaded TIDAL JPEG artworks, at most 15,000,000 bytes, are copied to Square and attached under new artwork IDs; their originals stay unchanged. Existing Square artworks must belong to this seller and are attached directly. Returns the complete resulting linkage in display order and the committed item revision. Copies may remain in Square if the replacement fails. Retry unchanged with the original Idempotency-Key after a timeout or 5xx. Recovery is bounded by Marketplace receipts and Square's idempotency retention, and can be blocked if the item is deleted or a source becomes unavailable or ineligible. Read the item again to reconcile its current state.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Square item id
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned.
let squareItemsArtworksRelationshipUpdateOperationPayload = SquareItemsArtworksRelationshipUpdateOperation_Payload(data: [ItemArtwork(id: "id_example", type: "type_example")], meta: SquareItemsArtworksRelationshipUpdateOperation_Payload_meta(expectedRevision: 123, mode: "mode_example")) // SquareItemsArtworksRelationshipUpdateOperationPayload |  (optional)

// Update artworks relationship (\"to-many\").
do {
    let response = try await SquareItemsAPI.squareItemsIdRelationshipsArtworksPatch(id: id, idempotencyKey: idempotencyKey, squareItemsArtworksRelationshipUpdateOperationPayload: squareItemsArtworksRelationshipUpdateOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Square item id | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | 
 **squareItemsArtworksRelationshipUpdateOperationPayload** | [**SquareItemsArtworksRelationshipUpdateOperationPayload**](SquareItemsArtworksRelationshipUpdateOperationPayload.md) |  | [optional] 

### Return type

[**SquareItemsArtworksUpdateMultiRelationshipDataDocument**](SquareItemsArtworksUpdateMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **squareItemsIdRelationshipsOwnersGet**
```swift
    open class func squareItemsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> SquareItemsOwnersMultiRelationshipDataDocument
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Square item id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get owners relationship (\"to-many\").
do {
    let response = try await SquareItemsAPI.squareItemsIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Square item id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**SquareItemsOwnersMultiRelationshipDataDocument**](SquareItemsOwnersMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **squareItemsIdRelationshipsVariationsGet**
```swift
    open class func squareItemsIdRelationshipsVariationsGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> SquareItemsVariationsMultiRelationshipDataDocument
```

Get variations relationship (\"to-many\").

Variations in Square's display order.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Square item id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: variations (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get variations relationship (\"to-many\").
do {
    let response = try await SquareItemsAPI.squareItemsIdRelationshipsVariationsGet(id: id, include: include, pageCursor: pageCursor)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Square item id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: variations | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**SquareItemsVariationsMultiRelationshipDataDocument**](SquareItemsVariationsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **squareItemsIdRelationshipsVariationsPatch**
```swift
    open class func squareItemsIdRelationshipsVariationsPatch(id: String, idempotencyKey: String, squareItemsVariationsRelationshipUpdateOperationPayload: SquareItemsVariationsRelationshipUpdateOperationPayload? = nil) async throws -> SquareItemsVariationsUpdateMultiRelationshipDataDocument
```

Update variations relationship (\"to-many\").

Incrementally moves the selected variations as an ordered block before positionBefore, or to the end when omitted. Memberships are preserved; unselected variations retain their metadata and relative order. Empty data is rejected. Returns the affected linkage only and the updated item revision. After a timeout or `5xx`, retry unchanged with the original Idempotency-Key. Replay protection is bounded by receipt availability and Square's idempotency retention.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Square item id
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned.
let squareItemsVariationsRelationshipUpdateOperationPayload = SquareItemsVariationsRelationshipUpdateOperation_Payload(data: [ItemVariation(id: "id_example", type: "type_example")], meta: SquareItemsVariationsRelationshipUpdateOperation_Payload_meta(expectedRevision: 123, mode: "mode_example", positionBefore: "positionBefore_example")) // SquareItemsVariationsRelationshipUpdateOperationPayload |  (optional)

// Update variations relationship (\"to-many\").
do {
    let response = try await SquareItemsAPI.squareItemsIdRelationshipsVariationsPatch(id: id, idempotencyKey: idempotencyKey, squareItemsVariationsRelationshipUpdateOperationPayload: squareItemsVariationsRelationshipUpdateOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Square item id | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | 
 **squareItemsVariationsRelationshipUpdateOperationPayload** | [**SquareItemsVariationsRelationshipUpdateOperationPayload**](SquareItemsVariationsRelationshipUpdateOperationPayload.md) |  | [optional] 

### Return type

[**SquareItemsVariationsUpdateMultiRelationshipDataDocument**](SquareItemsVariationsUpdateMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

