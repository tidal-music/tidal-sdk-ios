# UserDataExportRequestsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**userDataExportRequestsPost**](UserDataExportRequestsAPI.md#userdataexportrequestspost) | **POST** /userDataExportRequests | Create single userDataExportRequest.


# **userDataExportRequestsPost**
```swift
    open class func userDataExportRequestsPost(idempotencyKey: String? = nil, userDataExportRequestsCreateOperationPayload: UserDataExportRequestsCreateOperationPayload? = nil, completion: @escaping (_ data: UserDataExportRequestsSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Create single userDataExportRequest.

Creates a new userDataExportRequest.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. (optional)
let userDataExportRequestsCreateOperationPayload = UserDataExportRequestsCreateOperation_Payload(data: UserDataExportRequestsCreateOperation_Payload_Data(attributes: UserDataExportRequestsCreateOperation_Payload_Data_Attributes(flowType: "flowType_example"), type: "type_example")) // UserDataExportRequestsCreateOperationPayload |  (optional)

// Create single userDataExportRequest.
UserDataExportRequestsAPI.userDataExportRequestsPost(idempotencyKey: idempotencyKey, userDataExportRequestsCreateOperationPayload: userDataExportRequestsCreateOperationPayload) { (response, error) in
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
 **userDataExportRequestsCreateOperationPayload** | [**UserDataExportRequestsCreateOperationPayload**](UserDataExportRequestsCreateOperationPayload.md) |  | [optional] 

### Return type

[**UserDataExportRequestsSingleResourceDataDocument**](UserDataExportRequestsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

