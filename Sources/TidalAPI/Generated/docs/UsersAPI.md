# UsersAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**usersIdGet**](UsersAPI.md#usersidget) | **GET** /users/{id} | Get single user.


# **usersIdGet**
```swift
    open class func usersIdGet(id: String, completion: @escaping (_ data: UsersSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single user.

Retrieves single user by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User id. Use `me` for the authenticated user's resource

// Get single user.
UsersAPI.usersIdGet(id: id) { (response, error) in
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
 **id** | **String** | User id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 

### Return type

[**UsersSingleResourceDataDocument**](UsersSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

