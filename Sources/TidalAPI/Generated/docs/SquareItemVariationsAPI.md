# SquareItemVariationsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**operationsPost**](SquareItemVariationsAPI.md#operationspost) | **POST** /operations | Commit atomic resource operations
[**squareItemVariationsIdDelete**](SquareItemVariationsAPI.md#squareitemvariationsiddelete) | **DELETE** /squareItemVariations/{id} | Delete single squareItemVariation.
[**squareItemVariationsIdGet**](SquareItemVariationsAPI.md#squareitemvariationsidget) | **GET** /squareItemVariations/{id} | Get single squareItemVariation.
[**squareItemVariationsIdPatch**](SquareItemVariationsAPI.md#squareitemvariationsidpatch) | **PATCH** /squareItemVariations/{id} | Update single squareItemVariation.
[**squareItemVariationsIdRelationshipsOwnersGet**](SquareItemVariationsAPI.md#squareitemvariationsidrelationshipsownersget) | **GET** /squareItemVariations/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
[**squareItemVariationsPost**](SquareItemVariationsAPI.md#squareitemvariationspost) | **POST** /squareItemVariations | Create single squareItemVariation.


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
let atomicOperationsRequest = Atomic_Operations_Request(atomicOperations: [Atomic_Operations_Request_atomic_operations_inner(data: SquareItemsCreateOperation_Payload_Data(attributes: SquareItemsCreateOperation_Payload_Data_Attributes(description: "description_example", title: "title_example"), lid: "lid_example", type: "type_example"), op: "op_example")]) // AtomicOperationsRequest | 

// Commit atomic resource operations
do {
    let response = try await SquareItemVariationsAPI.operationsPost(idempotencyKey: idempotencyKey, atomicOperationsRequest: atomicOperationsRequest)
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

# **squareItemVariationsIdDelete**
```swift
    open class func squareItemVariationsIdDelete(id: String, idempotencyKey: String) async throws -> MutationResponseDocument
```

Delete single squareItemVariation.

Deletes this variation by ID without a revision precondition, preserving its siblings. The last variation cannot be deleted; delete the item instead. Returns an acknowledgement; read the parent item for its current revision. After a timeout or `5xx`, retry unchanged with the original Idempotency-Key. Replay protection is bounded by receipt availability and Square's idempotency retention.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Square variation id
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned.

// Delete single squareItemVariation.
do {
    let response = try await SquareItemVariationsAPI.squareItemVariationsIdDelete(id: id, idempotencyKey: idempotencyKey)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Square variation id | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | 

### Return type

[**MutationResponseDocument**](MutationResponseDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **squareItemVariationsIdGet**
```swift
    open class func squareItemVariationsIdGet(id: String, include: [String]? = nil, includeLinkage: [IncludeLinkage_squareItemVariationsIdGet]? = nil) async throws -> SquareItemVariationsSingleResourceDataDocument
```

Get single squareItemVariation.

Retrieves single squareItemVariation by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Square variation id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: owners (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)

// Get single squareItemVariation.
do {
    let response = try await SquareItemVariationsAPI.squareItemVariationsIdGet(id: id, include: include, includeLinkage: includeLinkage)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Square variation id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: owners | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 

### Return type

[**SquareItemVariationsSingleResourceDataDocument**](SquareItemVariationsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **squareItemVariationsIdPatch**
```swift
    open class func squareItemVariationsIdPatch(id: String, idempotencyKey: String, squareItemVariationsUpdateOperationPayload: SquareItemVariationsUpdateOperationPayload? = nil) async throws -> SquareItemVariationsUpdateSingleResourceDataDocument
```

Update single squareItemVariation.

Updates the variation's global name or its price and stock tracking at the selected site's shipping location, with merchant-main fallback. Stock quantity is changed through physical-count submissions. Price changes require existing positive fixed pricing at that location; name and stock tracking preserve other pricing modes. After a timeout or `5xx`, retry unchanged with the original Idempotency-Key. Replay protection is bounded by receipt availability and Square's idempotency retention.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Square variation id
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned.
let squareItemVariationsUpdateOperationPayload = SquareItemVariationsUpdateOperation_Payload(data: SquareItemVariationsUpdateOperation_Payload_Data(attributes: SquareItemVariationsUpdateOperation_Payload_Data_Attributes(name: "name_example", price: "price_example", stockTracked: false), id: "id_example", type: "type_example"), meta: SquareItemVariationsUpdateOperation_Payload_Meta(expectedRevision: 123)) // SquareItemVariationsUpdateOperationPayload |  (optional)

// Update single squareItemVariation.
do {
    let response = try await SquareItemVariationsAPI.squareItemVariationsIdPatch(id: id, idempotencyKey: idempotencyKey, squareItemVariationsUpdateOperationPayload: squareItemVariationsUpdateOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Square variation id | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | 
 **squareItemVariationsUpdateOperationPayload** | [**SquareItemVariationsUpdateOperationPayload**](SquareItemVariationsUpdateOperationPayload.md) |  | [optional] 

### Return type

[**SquareItemVariationsUpdateSingleResourceDataDocument**](SquareItemVariationsUpdateSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **squareItemVariationsIdRelationshipsOwnersGet**
```swift
    open class func squareItemVariationsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> SquareItemVariationsOwnersMultiRelationshipDataDocument
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Square variation id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get owners relationship (\"to-many\").
do {
    let response = try await SquareItemVariationsAPI.squareItemVariationsIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Square variation id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**SquareItemVariationsOwnersMultiRelationshipDataDocument**](SquareItemVariationsOwnersMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **squareItemVariationsPost**
```swift
    open class func squareItemVariationsPost(idempotencyKey: String, squareItemVariationsCreateOperationPayload: SquareItemVariationsCreateOperationPayload? = nil) async throws -> SquareItemVariationsCreateSingleResourceDataDocument
```

Create single squareItemVariation.

Adds a fixed-price variation at the end of the item's display order, preserving all existing variations and their pricing modes. After a timeout or `5xx`, retry unchanged with the original Idempotency-Key. Replay protection is bounded by receipt availability and Square's idempotency retention.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned.
let squareItemVariationsCreateOperationPayload = SquareItemVariationsCreateOperation_Payload(data: SquareItemVariationsCreateOperation_Payload_Data(attributes: SquareItemVariationsCreateOperation_Payload_Data_Attributes(name: "name_example", price: "price_example", stockTracked: false), relationships: SquareItemVariationsCreateOperation_Payload_Data_Relationships(items: SquareItemVariationsCreateOperation_Payload_Data_Relationships_Items(data: [Item(id: "id_example", type: "type_example")])), type: "type_example"), meta: SquareItemVariations_ExpectedItemRevision(expectedItemRevision: 123)) // SquareItemVariationsCreateOperationPayload |  (optional)

// Create single squareItemVariation.
do {
    let response = try await SquareItemVariationsAPI.squareItemVariationsPost(idempotencyKey: idempotencyKey, squareItemVariationsCreateOperationPayload: squareItemVariationsCreateOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | 
 **squareItemVariationsCreateOperationPayload** | [**SquareItemVariationsCreateOperationPayload**](SquareItemVariationsCreateOperationPayload.md) |  | [optional] 

### Return type

[**SquareItemVariationsCreateSingleResourceDataDocument**](SquareItemVariationsCreateSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

