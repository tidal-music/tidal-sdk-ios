# UserEntitlementsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**userEntitlementsIdGet**](UserEntitlementsAPI.md#userentitlementsidget) | **GET** /userEntitlements/{id} | Get single userEntitlement.


# **userEntitlementsIdGet**
```swift
    open class func userEntitlementsIdGet(id: String, completion: @escaping (_ data: UserEntitlementsSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single userEntitlement.

Retrieves single userEntitlement by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User id

// Get single userEntitlement.
UserEntitlementsAPI.userEntitlementsIdGet(id: id) { (response, error) in
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
 **id** | **String** | User id | 

### Return type

[**UserEntitlementsSingleResourceDataDocument**](UserEntitlementsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

