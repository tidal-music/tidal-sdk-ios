# UserFeedsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**userFeedsIdGet**](UserFeedsAPI.md#userfeedsidget) | **GET** /userFeeds/{id} | Get single userFeed.
[**userFeedsIdPatch**](UserFeedsAPI.md#userfeedsidpatch) | **PATCH** /userFeeds/{id} | Update single userFeed.


# **userFeedsIdGet**
```swift
    open class func userFeedsIdGet(id: String, completion: @escaping (_ data: UserFeedsSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single userFeed.

Retrieves single userFeed by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Opaque identifier of a user's feed state. Use `me` for the authenticated user's resource

// Get single userFeed.
UserFeedsAPI.userFeedsIdGet(id: id) { (response, error) in
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
 **id** | **String** | Opaque identifier of a user&#39;s feed state. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 

### Return type

[**UserFeedsSingleResourceDataDocument**](UserFeedsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userFeedsIdPatch**
```swift
    open class func userFeedsIdPatch(id: String, idempotencyKey: String? = nil, userFeedsUpdateOperationPayload: UserFeedsUpdateOperationPayload? = nil, completion: @escaping (_ data: UserFeedsUpdateSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Update single userFeed.

Advances the supplied seen positions and returns the updated feed state.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Opaque identifier of a user's feed state. Use `me` for the authenticated user's resource
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. (optional)
let userFeedsUpdateOperationPayload = UserFeedsUpdateOperation_Payload(data: UserFeedsUpdateOperation_Payload_Data(attributes: UserFeedsUpdateOperation_Payload_Data_Attributes(feed: UserFeedsUpdateOperation_Payload_Data_Attributes_Feed(seenThroughToken: "seenThroughToken_example"), inbox: UserFeedsUpdateOperation_Payload_Data_Attributes_Inbox(seenThroughToken: "seenThroughToken_example")), id: "id_example", type: "type_example")) // UserFeedsUpdateOperationPayload |  (optional)

// Update single userFeed.
UserFeedsAPI.userFeedsIdPatch(id: id, idempotencyKey: idempotencyKey, userFeedsUpdateOperationPayload: userFeedsUpdateOperationPayload) { (response, error) in
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
 **id** | **String** | Opaque identifier of a user&#39;s feed state. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. | [optional] 
 **userFeedsUpdateOperationPayload** | [**UserFeedsUpdateOperationPayload**](UserFeedsUpdateOperationPayload.md) |  | [optional] 

### Return type

[**UserFeedsUpdateSingleResourceDataDocument**](UserFeedsUpdateSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

