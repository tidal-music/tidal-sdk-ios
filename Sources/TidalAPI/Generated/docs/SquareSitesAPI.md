# SquareSitesAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**squareSitesIdRelationshipsItemsDelete**](SquareSitesAPI.md#squaresitesidrelationshipsitemsdelete) | **DELETE** /squareSites/{id}/relationships/items | Delete from items relationship (\&quot;to-many\&quot;).
[**squareSitesIdRelationshipsItemsGet**](SquareSitesAPI.md#squaresitesidrelationshipsitemsget) | **GET** /squareSites/{id}/relationships/items | Get items relationship (\&quot;to-many\&quot;).
[**squareSitesIdRelationshipsItemsPost**](SquareSitesAPI.md#squaresitesidrelationshipsitemspost) | **POST** /squareSites/{id}/relationships/items | Add to items relationship (\&quot;to-many\&quot;).


# **squareSitesIdRelationshipsItemsDelete**
```swift
    open class func squareSitesIdRelationshipsItemsDelete(id: String, idempotencyKey: String? = nil, squareSitesItemsRelationshipRemoveOperationPayload: SquareSitesItemsRelationshipRemoveOperationPayload? = nil) async throws -> MutationResponseDocument
```

Delete from items relationship (\"to-many\").

Removes the items from the site; they stay in the catalog. Items not published and repeated items are left alone. An item missing from the catalog fails the request before anything changes.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Square Online site id
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let squareSitesItemsRelationshipRemoveOperationPayload = SquareSitesItemsRelationshipRemoveOperation_Payload(data: [SquareSitesItemsRelationshipRemoveOperation_Payload_Data(id: "id_example", type: "type_example")]) // SquareSitesItemsRelationshipRemoveOperationPayload |  (optional)

// Delete from items relationship (\"to-many\").
do {
    let response = try await SquareSitesAPI.squareSitesIdRelationshipsItemsDelete(id: id, idempotencyKey: idempotencyKey, squareSitesItemsRelationshipRemoveOperationPayload: squareSitesItemsRelationshipRemoveOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Square Online site id | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **squareSitesItemsRelationshipRemoveOperationPayload** | [**SquareSitesItemsRelationshipRemoveOperationPayload**](SquareSitesItemsRelationshipRemoveOperationPayload.md) |  | [optional] 

### Return type

[**MutationResponseDocument**](MutationResponseDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **squareSitesIdRelationshipsItemsGet**
```swift
    open class func squareSitesIdRelationshipsItemsGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> SquareSitesItemsMultiRelationshipDataDocument
```

Get items relationship (\"to-many\").

Items published in the site, in title order. Missing catalog scopes return MISSING_ITEMS_SCOPE. A page can be short or empty and still have a next cursor.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Square Online site id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: items (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get items relationship (\"to-many\").
do {
    let response = try await SquareSitesAPI.squareSitesIdRelationshipsItemsGet(id: id, include: include, pageCursor: pageCursor)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Square Online site id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: items | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**SquareSitesItemsMultiRelationshipDataDocument**](SquareSitesItemsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **squareSitesIdRelationshipsItemsPost**
```swift
    open class func squareSitesIdRelationshipsItemsPost(id: String, idempotencyKey: String? = nil, squareSitesItemsRelationshipAddOperationPayload: SquareSitesItemsRelationshipAddOperationPayload? = nil) async throws -> MutationResponseDocument
```

Add to items relationship (\"to-many\").

Publishes the items in the site. Items already published and repeated items are left alone. An item missing from the catalog fails the request before anything changes.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Square Online site id
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let squareSitesItemsRelationshipAddOperationPayload = SquareSitesItemsRelationshipAddOperation_Payload(data: [SquareSitesItemsRelationshipAddOperation_Payload_Data(id: "id_example", type: "type_example")]) // SquareSitesItemsRelationshipAddOperationPayload |  (optional)

// Add to items relationship (\"to-many\").
do {
    let response = try await SquareSitesAPI.squareSitesIdRelationshipsItemsPost(id: id, idempotencyKey: idempotencyKey, squareSitesItemsRelationshipAddOperationPayload: squareSitesItemsRelationshipAddOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Square Online site id | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **squareSitesItemsRelationshipAddOperationPayload** | [**SquareSitesItemsRelationshipAddOperationPayload**](SquareSitesItemsRelationshipAddOperationPayload.md) |  | [optional] 

### Return type

[**MutationResponseDocument**](MutationResponseDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

