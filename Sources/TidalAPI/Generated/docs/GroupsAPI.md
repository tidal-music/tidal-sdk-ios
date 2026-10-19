# GroupsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**groupsGet**](GroupsAPI.md#groupsget) | **GET** /groups | Get multiple groups.
[**groupsIdGet**](GroupsAPI.md#groupsidget) | **GET** /groups/{id} | Get single group.


# **groupsGet**
```swift
    open class func groupsGet(filterName: String) async throws -> GroupsMultiResourceDataDocument
```

Get multiple groups.

Retrieves multiple groups by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let filterName = "filterName_example" // String | Exact group name (case-sensitive) (e.g. `Everyone`)

// Get multiple groups.
do {
    let response = try await GroupsAPI.groupsGet(filterName: filterName)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **filterName** | **String** | Exact group name (case-sensitive) (e.g. &#x60;Everyone&#x60;) | 

### Return type

[**GroupsMultiResourceDataDocument**](GroupsMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **groupsIdGet**
```swift
    open class func groupsIdGet(id: String) async throws -> GroupsSingleResourceDataDocument
```

Get single group.

Retrieves single group by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Group ID

// Get single group.
do {
    let response = try await GroupsAPI.groupsIdGet(id: id)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Group ID | 

### Return type

[**GroupsSingleResourceDataDocument**](GroupsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

