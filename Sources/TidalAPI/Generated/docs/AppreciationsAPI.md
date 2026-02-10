# AppreciationsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**appreciationsPost**](AppreciationsAPI.md#appreciationspost) | **POST** /appreciations | Create single appreciation.


# **appreciationsPost**
```swift
    open class func appreciationsPost(appreciationsCreateOperationPayload: AppreciationsCreateOperationPayload? = nil, completion: @escaping (_ data: AppreciationsSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Create single appreciation.

Creates a new appreciation.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let appreciationsCreateOperationPayload = AppreciationsCreateOperation_Payload(data: AppreciationsCreateOperation_Payload_Data(relationships: AppreciationsCreateOperation_Payload_Data_Relationships(appreciatedItems: AppreciationsCreateOperation_Payload_Data_Relationships_AppreciatedItem(data: [AppreciationsCreateOperation_Payload_Data_Relationships_AppreciatedItem_Data(id: "id_example", type: "type_example")])), type: "type_example"), meta: AppreciationsCreateOperation_Payload_Meta(dryRun: false)) // AppreciationsCreateOperationPayload |  (optional)

// Create single appreciation.
AppreciationsAPI.appreciationsPost(appreciationsCreateOperationPayload: appreciationsCreateOperationPayload) { (response, error) in
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
 **appreciationsCreateOperationPayload** | [**AppreciationsCreateOperationPayload**](AppreciationsCreateOperationPayload.md) |  | [optional] 

### Return type

[**AppreciationsSingleResourceDataDocument**](AppreciationsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

