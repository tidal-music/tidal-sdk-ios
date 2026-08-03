# SubscriptionPriceChangeDecisionsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**subscriptionPriceChangeDecisionsGet**](SubscriptionPriceChangeDecisionsAPI.md#subscriptionpricechangedecisionsget) | **GET** /subscriptionPriceChangeDecisions | Get multiple subscriptionPriceChangeDecisions.
[**subscriptionPriceChangeDecisionsIdPatch**](SubscriptionPriceChangeDecisionsAPI.md#subscriptionpricechangedecisionsidpatch) | **PATCH** /subscriptionPriceChangeDecisions/{id} | Update single subscriptionPriceChangeDecision.
[**subscriptionPriceChangeDecisionsIdRelationshipsPriceChangeGet**](SubscriptionPriceChangeDecisionsAPI.md#subscriptionpricechangedecisionsidrelationshipspricechangeget) | **GET** /subscriptionPriceChangeDecisions/{id}/relationships/priceChange | Get priceChange relationship (\&quot;to-one\&quot;).
[**subscriptionPriceChangeDecisionsPost**](SubscriptionPriceChangeDecisionsAPI.md#subscriptionpricechangedecisionspost) | **POST** /subscriptionPriceChangeDecisions | Create single subscriptionPriceChangeDecision.


# **subscriptionPriceChangeDecisionsGet**
```swift
    open class func subscriptionPriceChangeDecisionsGet(filterOwnersId: [String], include: [String]? = nil, completion: @escaping (_ data: SubscriptionPriceChangeDecisionsMultiResourceDataDocument?, _ error: Error?) -> Void)
```

Get multiple subscriptionPriceChangeDecisions.

Retrieves multiple subscriptionPriceChangeDecisions by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let filterOwnersId = ["inner_example"] // [String] | User id. Use `me` for the authenticated user
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: priceChange (optional)

// Get multiple subscriptionPriceChangeDecisions.
SubscriptionPriceChangeDecisionsAPI.subscriptionPriceChangeDecisionsGet(filterOwnersId: filterOwnersId, include: include) { (response, error) in
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
 **filterOwnersId** | [**[String]**](String.md) | User id. Use &#x60;me&#x60; for the authenticated user | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: priceChange | [optional] 

### Return type

[**SubscriptionPriceChangeDecisionsMultiResourceDataDocument**](SubscriptionPriceChangeDecisionsMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **subscriptionPriceChangeDecisionsIdPatch**
```swift
    open class func subscriptionPriceChangeDecisionsIdPatch(id: String, idempotencyKey: String? = nil, subscriptionPriceChangeDecisionsUpdateOperationPayload: SubscriptionPriceChangeDecisionsUpdateOperationPayload? = nil, completion: @escaping (_ data: SubscriptionPriceChangeDecisionsSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Update single subscriptionPriceChangeDecision.

Updates existing subscriptionPriceChangeDecision.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Price change decision id
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. (optional)
let subscriptionPriceChangeDecisionsUpdateOperationPayload = SubscriptionPriceChangeDecisionsUpdateOperation_Payload(data: SubscriptionPriceChangeDecisionsUpdateOperation_Payload_Data(attributes: SubscriptionPriceChangeDecisionsUpdateOperation_Payload_Data_Attributes(status: "status_example"), id: "id_example", type: "type_example")) // SubscriptionPriceChangeDecisionsUpdateOperationPayload |  (optional)

// Update single subscriptionPriceChangeDecision.
SubscriptionPriceChangeDecisionsAPI.subscriptionPriceChangeDecisionsIdPatch(id: id, idempotencyKey: idempotencyKey, subscriptionPriceChangeDecisionsUpdateOperationPayload: subscriptionPriceChangeDecisionsUpdateOperationPayload) { (response, error) in
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
 **id** | **String** | Price change decision id | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. | [optional] 
 **subscriptionPriceChangeDecisionsUpdateOperationPayload** | [**SubscriptionPriceChangeDecisionsUpdateOperationPayload**](SubscriptionPriceChangeDecisionsUpdateOperationPayload.md) |  | [optional] 

### Return type

[**SubscriptionPriceChangeDecisionsSingleResourceDataDocument**](SubscriptionPriceChangeDecisionsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **subscriptionPriceChangeDecisionsIdRelationshipsPriceChangeGet**
```swift
    open class func subscriptionPriceChangeDecisionsIdRelationshipsPriceChangeGet(id: String, include: [String]? = nil, completion: @escaping (_ data: SubscriptionPriceChangeDecisionsSingleRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get priceChange relationship (\"to-one\").

Retrieves priceChange relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Price change decision id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: priceChange (optional)

// Get priceChange relationship (\"to-one\").
SubscriptionPriceChangeDecisionsAPI.subscriptionPriceChangeDecisionsIdRelationshipsPriceChangeGet(id: id, include: include) { (response, error) in
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
 **id** | **String** | Price change decision id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: priceChange | [optional] 

### Return type

[**SubscriptionPriceChangeDecisionsSingleRelationshipDataDocument**](SubscriptionPriceChangeDecisionsSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **subscriptionPriceChangeDecisionsPost**
```swift
    open class func subscriptionPriceChangeDecisionsPost(idempotencyKey: String? = nil, subscriptionPriceChangeDecisionsCreateOperationPayload: SubscriptionPriceChangeDecisionsCreateOperationPayload? = nil, completion: @escaping (_ data: SubscriptionPriceChangeDecisionsSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Create single subscriptionPriceChangeDecision.

Creates a new subscriptionPriceChangeDecision.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. (optional)
let subscriptionPriceChangeDecisionsCreateOperationPayload = SubscriptionPriceChangeDecisionsCreateOperation_Payload(data: SubscriptionPriceChangeDecisionsCreateOperation_Payload_Data(attributes: SubscriptionPriceChangeDecisionsCreateOperation_Payload_Data_Attributes(status: "status_example"), relationships: SubscriptionPriceChangeDecisionsCreateOperation_Payload_Data_Relationships(priceChange: SubscriptionPriceChangeDecisionsCreateOperation_Payload_Data_Relationships_PriceChange(data: SubscriptionPriceChangeDecisionsCreateOperation_Payload_Data_Relationships_PriceChange_Data(id: "id_example", type: "type_example"))), type: "type_example")) // SubscriptionPriceChangeDecisionsCreateOperationPayload |  (optional)

// Create single subscriptionPriceChangeDecision.
SubscriptionPriceChangeDecisionsAPI.subscriptionPriceChangeDecisionsPost(idempotencyKey: idempotencyKey, subscriptionPriceChangeDecisionsCreateOperationPayload: subscriptionPriceChangeDecisionsCreateOperationPayload) { (response, error) in
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
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. | [optional] 
 **subscriptionPriceChangeDecisionsCreateOperationPayload** | [**SubscriptionPriceChangeDecisionsCreateOperationPayload**](SubscriptionPriceChangeDecisionsCreateOperationPayload.md) |  | [optional] 

### Return type

[**SubscriptionPriceChangeDecisionsSingleResourceDataDocument**](SubscriptionPriceChangeDecisionsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

