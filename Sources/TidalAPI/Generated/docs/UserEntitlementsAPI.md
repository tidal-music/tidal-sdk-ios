# UserEntitlementsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**userEntitlementsGet**](UserEntitlementsAPI.md#userentitlementsget) | **GET** /userEntitlements | Get all userEntitlements
[**userEntitlementsIdGet**](UserEntitlementsAPI.md#userentitlementsidget) | **GET** /userEntitlements/{id} | Get single userEntitlement
[**userEntitlementsMeGet**](UserEntitlementsAPI.md#userentitlementsmeget) | **GET** /userEntitlements/me | Get current user&#39;s userEntitlement data


# **userEntitlementsGet**
```swift
    open class func userEntitlementsGet(filterId: [String]? = nil, completion: @escaping (_ data: UserEntitlementsMultiDataDocument?, _ error: Error?) -> Void)
```

Get all userEntitlements

Retrieves all userEntitlement details by available filters or without (if applicable).

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let filterId = ["inner_example"] // [String] | Allows to filter the collection of resources based on id attribute value (optional)

// Get all userEntitlements
UserEntitlementsAPI.userEntitlementsGet(filterId: filterId) { (response, error) in
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
 **filterId** | [**[String]**](String.md) | Allows to filter the collection of resources based on id attribute value | [optional] 

### Return type

[**UserEntitlementsMultiDataDocument**](UserEntitlementsMultiDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userEntitlementsIdGet**
```swift
    open class func userEntitlementsIdGet(id: String, completion: @escaping (_ data: UserEntitlementsSingleDataDocument?, _ error: Error?) -> Void)
```

Get single userEntitlement

Retrieves userEntitlement details by an unique id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User entitlements id

// Get single userEntitlement
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
 **id** | **String** | User entitlements id | 

### Return type

[**UserEntitlementsSingleDataDocument**](UserEntitlementsSingleDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userEntitlementsMeGet**
```swift
    open class func userEntitlementsMeGet(completion: @escaping (_ data: UserEntitlementsSingleDataDocument?, _ error: Error?) -> Void)
```

Get current user's userEntitlement data

Retrieves current user's userEntitlement details.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient


// Get current user's userEntitlement data
UserEntitlementsAPI.userEntitlementsMeGet() { (response, error) in
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
This endpoint does not need any parameter.

### Return type

[**UserEntitlementsSingleDataDocument**](UserEntitlementsSingleDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

