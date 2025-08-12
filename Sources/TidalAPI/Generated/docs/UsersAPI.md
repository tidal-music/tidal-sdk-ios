# UsersAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**usersMeGet**](UsersAPI.md#usersmeget) | **GET** /users/me | Get current user&#39;s user(s).


# **usersMeGet**
```swift
    open class func usersMeGet(completion: @escaping (_ data: UsersSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get current user's user(s).

Retrieves current user's user(s).

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient


// Get current user's user(s).
UsersAPI.usersMeGet() { (response, error) in
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

[**UsersSingleResourceDataDocument**](UsersSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

