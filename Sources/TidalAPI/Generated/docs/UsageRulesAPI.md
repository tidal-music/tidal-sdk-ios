# UsageRulesAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**usageRulesIdGet**](UsageRulesAPI.md#usagerulesidget) | **GET** /usageRules/{id} | Get single usageRule.
[**usageRulesPost**](UsageRulesAPI.md#usagerulespost) | **POST** /usageRules | Create single usageRule.


# **usageRulesIdGet**
```swift
    open class func usageRulesIdGet(id: String) async throws -> UsageRulesSingleResourceDataDocument
```

Get single usageRule.

Retrieves single usageRule by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Usage rules id

// Get single usageRule.
do {
    let response = try await UsageRulesAPI.usageRulesIdGet(id: id)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Usage rules id | 

### Return type

[**UsageRulesSingleResourceDataDocument**](UsageRulesSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **usageRulesPost**
```swift
    open class func usageRulesPost(idempotencyKey: String? = nil, usageRulesCreateOperationPayload: UsageRulesCreateOperationPayload? = nil) async throws -> UsageRulesCreateSingleResourceDataDocument
```

Create single usageRule.

Creates a new usageRule.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let usageRulesCreateOperationPayload = UsageRulesCreateOperation_Payload(data: UsageRulesCreateOperation_Payload_Data(attributes: UsageRulesCreateOperation_Payload_Data_Attributes(countryCode: "countryCode_example", free: ["free_example"], inherited: false, paid: ["paid_example"], subscription: ["subscription_example"], validFrom: Date()), relationships: UsageRulesCreateOperation_Payload_Data_Relationships(subject: UsageRulesCreateOperation_Payload_Data_Relationships_Subject(data: UsageRulesCreateOperation_Payload_Subject(id: "id_example", type: "type_example"))), type: "type_example")) // UsageRulesCreateOperationPayload |  (optional)

// Create single usageRule.
do {
    let response = try await UsageRulesAPI.usageRulesPost(idempotencyKey: idempotencyKey, usageRulesCreateOperationPayload: usageRulesCreateOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **usageRulesCreateOperationPayload** | [**UsageRulesCreateOperationPayload**](UsageRulesCreateOperationPayload.md) |  | [optional] 

### Return type

[**UsageRulesCreateSingleResourceDataDocument**](UsageRulesCreateSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

