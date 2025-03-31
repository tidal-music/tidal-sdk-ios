# UsersAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**usersGet**](UsersAPI.md#usersget) | **GET** /users | Get all users
[**usersIdGet**](UsersAPI.md#usersidget) | **GET** /users/{id} | Get single user
[**usersIdRelationshipsEntitlementsGet**](UsersAPI.md#usersidrelationshipsentitlementsget) | **GET** /users/{id}/relationships/entitlements | Relationship: entitlements(read)
[**usersIdRelationshipsPublicProfileGet**](UsersAPI.md#usersidrelationshipspublicprofileget) | **GET** /users/{id}/relationships/publicProfile | Relationship: publicProfile(read)
[**usersIdRelationshipsRecommendationsGet**](UsersAPI.md#usersidrelationshipsrecommendationsget) | **GET** /users/{id}/relationships/recommendations | Relationship: recommendations(read)
[**usersMeGet**](UsersAPI.md#usersmeget) | **GET** /users/me | Get current user&#39;s user data


# **usersGet**
```swift
    open class func usersGet(include: [String]? = nil, filterId: [String]? = nil, completion: @escaping (_ data: UsersMultiDataDocument?, _ error: Error?) -> Void)
```

Get all users

Retrieves all user details by available filters or without (if applicable).

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: entitlements, publicProfile, recommendations (optional)
let filterId = ["inner_example"] // [String] | Allows to filter the collection of resources based on id attribute value (optional)

// Get all users
UsersAPI.usersGet(include: include, filterId: filterId) { (response, error) in
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
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: entitlements, publicProfile, recommendations | [optional] 
 **filterId** | [**[String]**](String.md) | Allows to filter the collection of resources based on id attribute value | [optional] 

### Return type

[**UsersMultiDataDocument**](UsersMultiDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **usersIdGet**
```swift
    open class func usersIdGet(id: String, include: [String]? = nil, completion: @escaping (_ data: UsersSingleDataDocument?, _ error: Error?) -> Void)
```

Get single user

Retrieves user details by an unique id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: entitlements, publicProfile, recommendations (optional)

// Get single user
UsersAPI.usersIdGet(id: id, include: include) { (response, error) in
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
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: entitlements, publicProfile, recommendations | [optional] 

### Return type

[**UsersSingleDataDocument**](UsersSingleDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **usersIdRelationshipsEntitlementsGet**
```swift
    open class func usersIdRelationshipsEntitlementsGet(id: String, include: [String]? = nil, completion: @escaping (_ data: UsersSingletonDataRelationshipDocument?, _ error: Error?) -> Void)
```

Relationship: entitlements(read)

Retrieves entitlements relationship details of the related user resource.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: entitlements (optional)

// Relationship: entitlements(read)
UsersAPI.usersIdRelationshipsEntitlementsGet(id: id, include: include) { (response, error) in
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
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: entitlements | [optional] 

### Return type

[**UsersSingletonDataRelationshipDocument**](UsersSingletonDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **usersIdRelationshipsPublicProfileGet**
```swift
    open class func usersIdRelationshipsPublicProfileGet(id: String, locale: String, include: [String]? = nil, completion: @escaping (_ data: UsersSingletonDataRelationshipDocument?, _ error: Error?) -> Void)
```

Relationship: publicProfile(read)

Retrieves publicProfile relationship details of the related user resource.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User id
let locale = "locale_example" // String | BCP47 locale code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: publicProfile (optional)

// Relationship: publicProfile(read)
UsersAPI.usersIdRelationshipsPublicProfileGet(id: id, locale: locale, include: include) { (response, error) in
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
 **locale** | **String** | BCP47 locale code | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: publicProfile | [optional] 

### Return type

[**UsersSingletonDataRelationshipDocument**](UsersSingletonDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **usersIdRelationshipsRecommendationsGet**
```swift
    open class func usersIdRelationshipsRecommendationsGet(id: String, include: [String]? = nil, completion: @escaping (_ data: UsersSingletonDataRelationshipDocument?, _ error: Error?) -> Void)
```

Relationship: recommendations(read)

Retrieves recommendations relationship details of the related user resource.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: recommendations (optional)

// Relationship: recommendations(read)
UsersAPI.usersIdRelationshipsRecommendationsGet(id: id, include: include) { (response, error) in
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
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: recommendations | [optional] 

### Return type

[**UsersSingletonDataRelationshipDocument**](UsersSingletonDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **usersMeGet**
```swift
    open class func usersMeGet(include: [String]? = nil, completion: @escaping (_ data: UsersSingleDataDocument?, _ error: Error?) -> Void)
```

Get current user's user data

Retrieves current user's user details.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: entitlements, publicProfile, recommendations (optional)

// Get current user's user data
UsersAPI.usersMeGet(include: include) { (response, error) in
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
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: entitlements, publicProfile, recommendations | [optional] 

### Return type

[**UsersSingleDataDocument**](UsersSingleDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

