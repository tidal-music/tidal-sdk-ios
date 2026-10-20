# SquareItemsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**squareItemsGet**](SquareItemsAPI.md#squareitemsget) | **GET** /squareItems | Get multiple squareItems.
[**squareItemsIdDelete**](SquareItemsAPI.md#squareitemsiddelete) | **DELETE** /squareItems/{id} | Delete single squareItem.
[**squareItemsIdGet**](SquareItemsAPI.md#squareitemsidget) | **GET** /squareItems/{id} | Get single squareItem.
[**squareItemsIdPatch**](SquareItemsAPI.md#squareitemsidpatch) | **PATCH** /squareItems/{id} | Update single squareItem.
[**squareItemsIdRelationshipsOwnersGet**](SquareItemsAPI.md#squareitemsidrelationshipsownersget) | **GET** /squareItems/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
[**squareItemsPost**](SquareItemsAPI.md#squareitemspost) | **POST** /squareItems | Create single squareItem.


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
let include = ["inner_example"] // [String] | Include related resources. Available relationships: owners (optional)
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
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: owners | [optional] 
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
let include = ["inner_example"] // [String] | Include related resources. Available relationships: owners (optional)
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
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: owners | [optional] 
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
let squareItemsUpdateOperationPayload = SquareItemsUpdateOperation_Payload(data: SquareItemsUpdateOperation_Payload_Data(attributes: SquareItemsUpdateOperation_Payload_Data_Attributes(description: "description_example", title: "title_example", variations: [SquareItemsUpdateOperation_Payload_Data_Attributes_Variation(name: "name_example", price: "price_example", stockQuantity: 123, stockTracked: false, variationId: "variationId_example")]), id: "id_example", type: "type_example"), meta: SquareItemsUpdateOperation_Payload_Meta(expectedRevision: 123)) // SquareItemsUpdateOperationPayload |  (optional)

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

# **squareItemsPost**
```swift
    open class func squareItemsPost(idempotencyKey: String, squareItemsCreateOperationPayload: SquareItemsCreateOperationPayload? = nil) async throws -> SquareItemsCreateSingleResourceDataDocument
```

Create single squareItem.

Creates a new squareItem.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned.
let squareItemsCreateOperationPayload = SquareItemsCreateOperation_Payload(data: SquareItemsCreateOperation_Payload_Data(attributes: SquareItemsCreateOperation_Payload_Data_Attributes(description: "description_example", title: "title_example", variations: [SquareItemsCreateOperation_Payload_Data_Attributes_Variation(name: "name_example", price: "price_example", stockQuantity: 123, stockTracked: false)]), type: "type_example")) // SquareItemsCreateOperationPayload |  (optional)

// Create single squareItem.
do {
    let response = try await SquareItemsAPI.squareItemsPost(idempotencyKey: idempotencyKey, squareItemsCreateOperationPayload: squareItemsCreateOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | 
 **squareItemsCreateOperationPayload** | [**SquareItemsCreateOperationPayload**](SquareItemsCreateOperationPayload.md) |  | [optional] 

### Return type

[**SquareItemsCreateSingleResourceDataDocument**](SquareItemsCreateSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

