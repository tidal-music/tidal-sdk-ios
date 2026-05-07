# UserReportsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**userReportsPost**](UserReportsAPI.md#userreportspost) | **POST** /userReports | Create single userReport.


# **userReportsPost**
```swift
    open class func userReportsPost(idempotencyKey: String? = nil, userReportsCreateOperationPayload: UserReportsCreateOperationPayload? = nil, completion: @escaping (_ data: UserReportsSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Create single userReport.

Creates a new userReport.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. (optional)
let userReportsCreateOperationPayload = UserReportsCreateOperation_Payload(data: UserReportsCreateOperation_Payload_Data(attributes: UserReportsCreateOperation_Payload_Data_Attributes(description: "description_example", reason: "reason_example"), relationships: UserReportsCreateOperation_Payload_Data_Relationships(reportedResources: UserReportsCreateOperation_Payload_Data_Relationships_ReportedResources(data: [UserReportsCreateOperation_Payload_Data_Relationships_ReportedResources_Data(id: "id_example", type: "type_example")])), type: "type_example")) // UserReportsCreateOperationPayload |  (optional)

// Create single userReport.
UserReportsAPI.userReportsPost(idempotencyKey: idempotencyKey, userReportsCreateOperationPayload: userReportsCreateOperationPayload) { (response, error) in
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
 **userReportsCreateOperationPayload** | [**UserReportsCreateOperationPayload**](UserReportsCreateOperationPayload.md) |  | [optional] 

### Return type

[**UserReportsSingleResourceDataDocument**](UserReportsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

