# ArtistRolesAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**artistRolesGet**](ArtistRolesAPI.md#artistrolesget) | **GET** /artistRoles | Get multiple artistRoles.
[**artistRolesIdGet**](ArtistRolesAPI.md#artistrolesidget) | **GET** /artistRoles/{id} | Get single artistRole.


# **artistRolesGet**
```swift
    open class func artistRolesGet(filterId: [String]? = nil, completion: @escaping (_ data: ArtistRolesMultiResourceDataDocument?, _ error: Error?) -> Void)
```

Get multiple artistRoles.

Retrieves multiple artistRoles by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let filterId = ["inner_example"] // [String] | Allows to filter the collection of resources based on id attribute value (optional)

// Get multiple artistRoles.
ArtistRolesAPI.artistRolesGet(filterId: filterId) { (response, error) in
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

[**ArtistRolesMultiResourceDataDocument**](ArtistRolesMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artistRolesIdGet**
```swift
    open class func artistRolesIdGet(id: String, completion: @escaping (_ data: ArtistRolesSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single artistRole.

Retrieves single artistRole by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist role id

// Get single artistRole.
ArtistRolesAPI.artistRolesIdGet(id: id) { (response, error) in
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
 **id** | **String** | Artist role id | 

### Return type

[**ArtistRolesSingleResourceDataDocument**](ArtistRolesSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

