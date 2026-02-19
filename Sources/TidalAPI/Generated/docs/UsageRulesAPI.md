# UsageRulesAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**usageRulesGet**](UsageRulesAPI.md#usagerulesget) | **GET** /usageRules | Get multiple usageRules.
[**usageRulesIdGet**](UsageRulesAPI.md#usagerulesidget) | **GET** /usageRules/{id} | Get single usageRule.
[**usageRulesPost**](UsageRulesAPI.md#usagerulespost) | **POST** /usageRules | Create single usageRule.


# **usageRulesGet**
```swift
    open class func usageRulesGet(filterId: [String]? = nil, completion: @escaping (_ data: UsageRulesMultiResourceDataDocument?, _ error: Error?) -> Void)
```

Get multiple usageRules.

Retrieves multiple usageRules by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let filterId = ["inner_example"] // [String] | List of usage rules IDs (e.g. `VFJBQ0tTOjEyMzpOTw`) (optional)

// Get multiple usageRules.
UsageRulesAPI.usageRulesGet(filterId: filterId) { (response, error) in
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
 **filterId** | [**[String]**](String.md) | List of usage rules IDs (e.g. &#x60;VFJBQ0tTOjEyMzpOTw&#x60;) | [optional] 

### Return type

[**UsageRulesMultiResourceDataDocument**](UsageRulesMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **usageRulesIdGet**
```swift
    open class func usageRulesIdGet(id: String, completion: @escaping (_ data: UsageRulesSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single usageRule.

Retrieves single usageRule by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Usage rules id

// Get single usageRule.
UsageRulesAPI.usageRulesIdGet(id: id) { (response, error) in
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
    open class func usageRulesPost(usageRulesCreateOperationPayload: UsageRulesCreateOperationPayload? = nil, completion: @escaping (_ data: UsageRulesSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Create single usageRule.

Creates a new usageRule.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let usageRulesCreateOperationPayload = UsageRulesCreateOperation_Payload(data: UsageRulesCreateOperation_Payload_Data(attributes: UsageRulesCreateOperation_Payload_Data_Attributes(countryCode: "countryCode_example", free: ["free_example"], paid: ["paid_example"], subscription: ["subscription_example"]), relationships: UsageRulesCreateOperation_Payload_Data_Relationships(subject: UsageRulesCreateOperation_Payload_Data_Relationships_Subject(data: UsageRulesCreateOperation_Payload_Subject(id: "id_example", type: "type_example"))), type: "type_example")) // UsageRulesCreateOperationPayload |  (optional)

// Create single usageRule.
UsageRulesAPI.usageRulesPost(usageRulesCreateOperationPayload: usageRulesCreateOperationPayload) { (response, error) in
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
 **usageRulesCreateOperationPayload** | [**UsageRulesCreateOperationPayload**](UsageRulesCreateOperationPayload.md) |  | [optional] 

### Return type

[**UsageRulesSingleResourceDataDocument**](UsageRulesSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

