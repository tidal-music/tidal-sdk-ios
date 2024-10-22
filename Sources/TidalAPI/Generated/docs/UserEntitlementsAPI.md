# UserEntitlementsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getMyUserEntitlements**](UserEntitlementsAPI.md#getmyuserentitlements) | **GET** /userEntitlements/me | Get the current users entitlements
[**getUserEntitlementsById**](UserEntitlementsAPI.md#getuserentitlementsbyid) | **GET** /userEntitlements/{id} | Get user entitlements for user


# **getMyUserEntitlements**
```swift
    open class func getMyUserEntitlements(include: [String]? = nil, completion: @escaping (_ data: UserEntitlementsSingleDataDocument?, _ error: Error?) -> Void)
```

Get the current users entitlements

Get the current users entitlements

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned (optional)

// Get the current users entitlements
UserEntitlementsAPI.getMyUserEntitlements(include: include) { (response, error) in
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
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned | [optional] 

### Return type

[**UserEntitlementsSingleDataDocument**](UserEntitlementsSingleDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getUserEntitlementsById**
```swift
    open class func getUserEntitlementsById(id: String, include: [String]? = nil, completion: @escaping (_ data: UserEntitlementsSingleDataDocument?, _ error: Error?) -> Void)
```

Get user entitlements for user

Get user entitlements for user

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User entitlements id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned (optional)

// Get user entitlements for user
UserEntitlementsAPI.getUserEntitlementsById(id: id, include: include) { (response, error) in
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
 **id** | **String** | User entitlements id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned | [optional] 

### Return type

[**UserEntitlementsSingleDataDocument**](UserEntitlementsSingleDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

