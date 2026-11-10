# StripeConnectionsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**stripeConnectionsGet**](StripeConnectionsAPI.md#stripeconnectionsget) | **GET** /stripeConnections | Get multiple stripeConnections.
[**stripeConnectionsIdRelationshipsOwnersGet**](StripeConnectionsAPI.md#stripeconnectionsidrelationshipsownersget) | **GET** /stripeConnections/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
[**stripeConnectionsPost**](StripeConnectionsAPI.md#stripeconnectionspost) | **POST** /stripeConnections | Create single stripeConnection.


# **stripeConnectionsGet**
```swift
    open class func stripeConnectionsGet(filterOwnersId: [String], include: [String]? = nil, includeLinkage: [IncludeLinkage_stripeConnectionsGet]? = nil) async throws -> StripeConnectionsMultiResourceDataDocument
```

Get multiple stripeConnections.

Retrieves multiple stripeConnections by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let filterOwnersId = ["inner_example"] // [String] | User id. Also accepts `me`.
let include = ["inner_example"] // [String] | Include related resources. Available relationships: owners (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)

// Get multiple stripeConnections.
do {
    let response = try await StripeConnectionsAPI.stripeConnectionsGet(filterOwnersId: filterOwnersId, include: include, includeLinkage: includeLinkage)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **filterOwnersId** | [**[String]**](String.md) | User id. Also accepts &#x60;me&#x60;. | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: owners | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 

### Return type

[**StripeConnectionsMultiResourceDataDocument**](StripeConnectionsMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **stripeConnectionsIdRelationshipsOwnersGet**
```swift
    open class func stripeConnectionsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> StripeConnectionsOwnersMultiRelationshipDataDocument
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Stripe connection id. Use `me` for the authenticated user's resource
let include = ["inner_example"] // [String] | Include related resources. Available relationships: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get owners relationship (\"to-many\").
do {
    let response = try await StripeConnectionsAPI.stripeConnectionsIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Stripe connection id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**StripeConnectionsOwnersMultiRelationshipDataDocument**](StripeConnectionsOwnersMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **stripeConnectionsPost**
```swift
    open class func stripeConnectionsPost(idempotencyKey: String? = nil, stripeConnectionsCreateOperationPayload: StripeConnectionsCreateOperationPayload? = nil) async throws -> StripeConnectionsCreateSingleResourceDataDocument
```

Create single stripeConnection.

Creates a new stripeConnection.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let stripeConnectionsCreateOperationPayload = StripeConnectionsCreateOperation_Payload(data: StripeConnectionsCreateOperation_Payload_Data(attributes: StripeConnectionsCreateOperation_Payload_Data_Attributes(integrationType: "integrationType_example", refreshUrl: "refreshUrl_example", returnUrl: "returnUrl_example"), type: "type_example"), meta: StripeConnectionsCreateOperation_Payload_Meta(integrationType: "integrationType_example", refreshUrl: "refreshUrl_example", returnUrl: "returnUrl_example")) // StripeConnectionsCreateOperationPayload |  (optional)

// Create single stripeConnection.
do {
    let response = try await StripeConnectionsAPI.stripeConnectionsPost(idempotencyKey: idempotencyKey, stripeConnectionsCreateOperationPayload: stripeConnectionsCreateOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **stripeConnectionsCreateOperationPayload** | [**StripeConnectionsCreateOperationPayload**](StripeConnectionsCreateOperationPayload.md) |  | [optional] 

### Return type

[**StripeConnectionsCreateSingleResourceDataDocument**](StripeConnectionsCreateSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

