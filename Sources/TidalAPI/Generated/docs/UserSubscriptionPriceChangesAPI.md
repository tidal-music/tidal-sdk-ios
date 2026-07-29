# UserSubscriptionPriceChangesAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**userSubscriptionPriceChangesGet**](UserSubscriptionPriceChangesAPI.md#usersubscriptionpricechangesget) | **GET** /userSubscriptionPriceChanges | Get multiple userSubscriptionPriceChanges.
[**userSubscriptionPriceChangesIdRelationshipsDecisionGet**](UserSubscriptionPriceChangesAPI.md#usersubscriptionpricechangesidrelationshipsdecisionget) | **GET** /userSubscriptionPriceChanges/{id}/relationships/decision | Get decision relationship (\&quot;to-one\&quot;).


# **userSubscriptionPriceChangesGet**
```swift
    open class func userSubscriptionPriceChangesGet(filterOwnersId: [String], include: [String]? = nil, completion: @escaping (_ data: UserSubscriptionPriceChangesMultiResourceDataDocument?, _ error: Error?) -> Void)
```

Get multiple userSubscriptionPriceChanges.

Retrieves multiple userSubscriptionPriceChanges by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let filterOwnersId = ["inner_example"] // [String] | User id. Use `me` for the authenticated user
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: decision (optional)

// Get multiple userSubscriptionPriceChanges.
UserSubscriptionPriceChangesAPI.userSubscriptionPriceChangesGet(filterOwnersId: filterOwnersId, include: include) { (response, error) in
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
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: decision | [optional] 

### Return type

[**UserSubscriptionPriceChangesMultiResourceDataDocument**](UserSubscriptionPriceChangesMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userSubscriptionPriceChangesIdRelationshipsDecisionGet**
```swift
    open class func userSubscriptionPriceChangesIdRelationshipsDecisionGet(id: String, include: [String]? = nil, completion: @escaping (_ data: UserSubscriptionPriceChangesSingleRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get decision relationship (\"to-one\").

Retrieves decision relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Price change id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: decision (optional)

// Get decision relationship (\"to-one\").
UserSubscriptionPriceChangesAPI.userSubscriptionPriceChangesIdRelationshipsDecisionGet(id: id, include: include) { (response, error) in
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
 **id** | **String** | Price change id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: decision | [optional] 

### Return type

[**UserSubscriptionPriceChangesSingleRelationshipDataDocument**](UserSubscriptionPriceChangesSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

