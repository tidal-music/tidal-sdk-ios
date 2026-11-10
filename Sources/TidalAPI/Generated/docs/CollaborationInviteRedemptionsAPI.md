# CollaborationInviteRedemptionsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**collaborationInviteRedemptionsPost**](CollaborationInviteRedemptionsAPI.md#collaborationinviteredemptionspost) | **POST** /collaborationInviteRedemptions | Create single collaborationInviteRedemption.


# **collaborationInviteRedemptionsPost**
```swift
    open class func collaborationInviteRedemptionsPost(idempotencyKey: String? = nil, collaborationInviteRedemptionsCreateOperationPayload: CollaborationInviteRedemptionsCreateOperationPayload? = nil) async throws -> CollaborationInviteRedemptionsCreateSingleResourceDataDocument
```

Create single collaborationInviteRedemption.

Creates a new collaborationInviteRedemption.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let collaborationInviteRedemptionsCreateOperationPayload = CollaborationInviteRedemptionsCreateOperation_Payload(data: CollaborationInviteRedemptionsCreateOperation_Payload_Data(relationships: CollaborationInviteRedemptionsCreateOperation_Payload_Data_Relationships(invite: CollaborationInviteRedemptionsCreateOperation_Payload_Data_Relationships_Invite(data: CollaborationInviteRedemptionsCreateOperation_Payload_Data_Relationships_Invite_Data(id: "id_example", type: "type_example"))), type: "type_example")) // CollaborationInviteRedemptionsCreateOperationPayload |  (optional)

// Create single collaborationInviteRedemption.
do {
    let response = try await CollaborationInviteRedemptionsAPI.collaborationInviteRedemptionsPost(idempotencyKey: idempotencyKey, collaborationInviteRedemptionsCreateOperationPayload: collaborationInviteRedemptionsCreateOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **collaborationInviteRedemptionsCreateOperationPayload** | [**CollaborationInviteRedemptionsCreateOperationPayload**](CollaborationInviteRedemptionsCreateOperationPayload.md) |  | [optional] 

### Return type

[**CollaborationInviteRedemptionsCreateSingleResourceDataDocument**](CollaborationInviteRedemptionsCreateSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

