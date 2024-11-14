# UsersAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getMyUser**](UsersAPI.md#getmyuser) | **GET** /users/me | Get the current user
[**getUserById**](UsersAPI.md#getuserbyid) | **GET** /users/{id} | Get a single user by id
[**getUserEntitlementsRelationship**](UsersAPI.md#getuserentitlementsrelationship) | **GET** /users/{id}/relationships/entitlements | Relationship: entitlements
[**getUserPublicProfileRelationship**](UsersAPI.md#getuserpublicprofilerelationship) | **GET** /users/{id}/relationships/publicProfile | Relationship: public profile
[**getUserRecommendationsRelationship**](UsersAPI.md#getuserrecommendationsrelationship) | **GET** /users/{id}/relationships/recommendations | Relationship: user recommendations
[**getUsersByFilters**](UsersAPI.md#getusersbyfilters) | **GET** /users | Get multiple users by id


# **getMyUser**
```swift
    open class func getMyUser(include: [String]? = nil, completion: @escaping (_ data: UsersSingleDataDocument?, _ error: Error?) -> Void)
```

Get the current user

Get the current user

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: entitlements, publicProfile, recommendations (optional)

// Get the current user
UsersAPI.getMyUser(include: include) { (response, error) in
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

# **getUserById**
```swift
    open class func getUserById(id: String, include: [String]? = nil, completion: @escaping (_ data: UsersSingleDataDocument?, _ error: Error?) -> Void)
```

Get a single user by id

Get a single user by id

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User Id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: entitlements, publicProfile, recommendations (optional)

// Get a single user by id
UsersAPI.getUserById(id: id, include: include) { (response, error) in
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
 **id** | **String** | User Id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: entitlements, publicProfile, recommendations | [optional] 

### Return type

[**UsersSingleDataDocument**](UsersSingleDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getUserEntitlementsRelationship**
```swift
    open class func getUserEntitlementsRelationship(id: String, include: [String]? = nil, completion: @escaping (_ data: UsersSingletonDataRelationshipDocument?, _ error: Error?) -> Void)
```

Relationship: entitlements

Get user entitlements relationship

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User Id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: entitlements (optional)

// Relationship: entitlements
UsersAPI.getUserEntitlementsRelationship(id: id, include: include) { (response, error) in
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
 **id** | **String** | User Id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: entitlements | [optional] 

### Return type

[**UsersSingletonDataRelationshipDocument**](UsersSingletonDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getUserPublicProfileRelationship**
```swift
    open class func getUserPublicProfileRelationship(id: String, locale: String, include: [String]? = nil, completion: @escaping (_ data: UsersSingletonDataRelationshipDocument?, _ error: Error?) -> Void)
```

Relationship: public profile

Get user public profile

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User Id
let locale = "locale_example" // String | Locale language tag (IETF BCP 47 Language Tag)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: publicProfile (optional)

// Relationship: public profile
UsersAPI.getUserPublicProfileRelationship(id: id, locale: locale, include: include) { (response, error) in
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
 **id** | **String** | User Id | 
 **locale** | **String** | Locale language tag (IETF BCP 47 Language Tag) | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: publicProfile | [optional] 

### Return type

[**UsersSingletonDataRelationshipDocument**](UsersSingletonDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getUserRecommendationsRelationship**
```swift
    open class func getUserRecommendationsRelationship(id: String, include: [String]? = nil, completion: @escaping (_ data: UsersSingletonDataRelationshipDocument?, _ error: Error?) -> Void)
```

Relationship: user recommendations

Get user recommendations

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User Id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: recommendations (optional)

// Relationship: user recommendations
UsersAPI.getUserRecommendationsRelationship(id: id, include: include) { (response, error) in
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
 **id** | **String** | User Id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: recommendations | [optional] 

### Return type

[**UsersSingletonDataRelationshipDocument**](UsersSingletonDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getUsersByFilters**
```swift
    open class func getUsersByFilters(include: [String]? = nil, filterId: [String]? = nil, completion: @escaping (_ data: UsersMultiDataDocument?, _ error: Error?) -> Void)
```

Get multiple users by id

Get multiple users by id

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: entitlements, publicProfile, recommendations (optional)
let filterId = ["inner_example"] // [String] | Allows to filter the collection of resources based on id attribute value (optional)

// Get multiple users by id
UsersAPI.getUsersByFilters(include: include, filterId: filterId) { (response, error) in
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

