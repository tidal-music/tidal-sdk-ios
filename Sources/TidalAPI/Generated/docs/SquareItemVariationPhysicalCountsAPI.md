# SquareItemVariationPhysicalCountsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**squareItemVariationPhysicalCountsPost**](SquareItemVariationPhysicalCountsAPI.md#squareitemvariationphysicalcountspost) | **POST** /squareItemVariationPhysicalCounts | Create single squareItemVariationPhysicalCount.


# **squareItemVariationPhysicalCountsPost**
```swift
    open class func squareItemVariationPhysicalCountsPost(idempotencyKey: String, squareItemVariationPhysicalCountsCreateOperationPayload: SquareItemVariationPhysicalCountsCreateOperationPayload? = nil) async throws -> SquareItemVariationPhysicalCountsCreateSingleResourceDataDocument
```

Create single squareItemVariationPhysicalCount.

Records a whole-unit physical stock count at occurredAt. Requires stock tracking at the selected site's shipping location (merchant-main fallback). While its replay receipt remains available, exact retries retain the original location and event time. Catalog revisions do not guard inventory counts.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned.
let squareItemVariationPhysicalCountsCreateOperationPayload = SquareItemVariationPhysicalCountsCreateOperation_Payload(data: SquareItemVariationPhysicalCountsCreateOperation_Payload_Data(attributes: SquareItemVariationPhysicalCountsCreateOperation_Payload_Data_Attributes(occurredAt: Date(), quantity: 123), relationships: SquareItemVariationPhysicalCountsCreateOperation_Payload_Data_Relationships(variations: SquareItemVariationPhysicalCountsCreateOperation_Payload_Data_Relationships_Variations(data: [Variation(id: "id_example", type: "type_example")])), type: "type_example")) // SquareItemVariationPhysicalCountsCreateOperationPayload |  (optional)

// Create single squareItemVariationPhysicalCount.
do {
    let response = try await SquareItemVariationPhysicalCountsAPI.squareItemVariationPhysicalCountsPost(idempotencyKey: idempotencyKey, squareItemVariationPhysicalCountsCreateOperationPayload: squareItemVariationPhysicalCountsCreateOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | 
 **squareItemVariationPhysicalCountsCreateOperationPayload** | [**SquareItemVariationPhysicalCountsCreateOperationPayload**](SquareItemVariationPhysicalCountsCreateOperationPayload.md) |  | [optional] 

### Return type

[**SquareItemVariationPhysicalCountsCreateSingleResourceDataDocument**](SquareItemVariationPhysicalCountsCreateSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

