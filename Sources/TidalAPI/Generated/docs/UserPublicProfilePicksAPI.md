# UserPublicProfilePicksAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getMyUserPublicProfilePicks**](UserPublicProfilePicksAPI.md#getmyuserpublicprofilepicks) | **GET** /userPublicProfilePicks/me | Get my picks
[**getUserPublicProfilePickItemRelationship**](UserPublicProfilePicksAPI.md#getuserpublicprofilepickitemrelationship) | **GET** /userPublicProfilePicks/{id}/relationships/item | Relationship: item (read)
[**getUserPublicProfilePickUserPublicProfileRelationship**](UserPublicProfilePicksAPI.md#getuserpublicprofilepickuserpublicprofilerelationship) | **GET** /userPublicProfilePicks/{id}/relationships/userPublicProfile | Relationship: user public profile
[**getUserPublicProfilePicksByFilters**](UserPublicProfilePicksAPI.md#getuserpublicprofilepicksbyfilters) | **GET** /userPublicProfilePicks | Get picks
[**setUserPublicProfilePickItemRelationship**](UserPublicProfilePicksAPI.md#setuserpublicprofilepickitemrelationship) | **PATCH** /userPublicProfilePicks/{id}/relationships/item | Relationship: item (update)


# **getMyUserPublicProfilePicks**
```swift
    open class func getMyUserPublicProfilePicks(locale: String, include: [String]? = nil, completion: @escaping (_ data: UserPublicProfilePicksMultiDataDocument?, _ error: Error?) -> Void)
```

Get my picks

Retrieves picks for the logged-in user.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let locale = "locale_example" // String | Locale language tag (IETF BCP 47 Language Tag)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: item, userPublicProfile (optional)

// Get my picks
UserPublicProfilePicksAPI.getMyUserPublicProfilePicks(locale: locale, include: include) { (response, error) in
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
 **locale** | **String** | Locale language tag (IETF BCP 47 Language Tag) | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: item, userPublicProfile | [optional] 

### Return type

[**UserPublicProfilePicksMultiDataDocument**](UserPublicProfilePicksMultiDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getUserPublicProfilePickItemRelationship**
```swift
    open class func getUserPublicProfilePickItemRelationship(id: String, locale: String, include: [String]? = nil, completion: @escaping (_ data: UserPublicProfilePicksSingletonDataRelationshipDocument?, _ error: Error?) -> Void)
```

Relationship: item (read)

Retrieves a picks item relationship

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | TIDAL pick id
let locale = "locale_example" // String | Locale language tag (IETF BCP 47 Language Tag)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: item (optional)

// Relationship: item (read)
UserPublicProfilePicksAPI.getUserPublicProfilePickItemRelationship(id: id, locale: locale, include: include) { (response, error) in
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
 **id** | **String** | TIDAL pick id | 
 **locale** | **String** | Locale language tag (IETF BCP 47 Language Tag) | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: item | [optional] 

### Return type

[**UserPublicProfilePicksSingletonDataRelationshipDocument**](UserPublicProfilePicksSingletonDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getUserPublicProfilePickUserPublicProfileRelationship**
```swift
    open class func getUserPublicProfilePickUserPublicProfileRelationship(id: String, include: [String]? = nil, completion: @escaping (_ data: UserPublicProfilePicksSingletonDataRelationshipDocument?, _ error: Error?) -> Void)
```

Relationship: user public profile

Retrieves a picks owner public profile

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | TIDAL pick id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: userPublicProfile (optional)

// Relationship: user public profile
UserPublicProfilePicksAPI.getUserPublicProfilePickUserPublicProfileRelationship(id: id, include: include) { (response, error) in
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
 **id** | **String** | TIDAL pick id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: userPublicProfile | [optional] 

### Return type

[**UserPublicProfilePicksSingletonDataRelationshipDocument**](UserPublicProfilePicksSingletonDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getUserPublicProfilePicksByFilters**
```swift
    open class func getUserPublicProfilePicksByFilters(locale: String, include: [String]? = nil, filterId: [String]? = nil, filterUserPublicProfileId: [String]? = nil, completion: @escaping (_ data: UserPublicProfilePicksMultiDataDocument?, _ error: Error?) -> Void)
```

Get picks

Retrieves a filtered collection of user's public picks.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let locale = "locale_example" // String | Locale language tag (IETF BCP 47 Language Tag)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: item, userPublicProfile (optional)
let filterId = ["inner_example"] // [String] | Allows to filter the collection of resources based on id attribute value (optional)
let filterUserPublicProfileId = ["inner_example"] // [String] | Allows to filter the collection of resources based on userPublicProfile.id attribute value (optional)

// Get picks
UserPublicProfilePicksAPI.getUserPublicProfilePicksByFilters(locale: locale, include: include, filterId: filterId, filterUserPublicProfileId: filterUserPublicProfileId) { (response, error) in
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
 **locale** | **String** | Locale language tag (IETF BCP 47 Language Tag) | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: item, userPublicProfile | [optional] 
 **filterId** | [**[String]**](String.md) | Allows to filter the collection of resources based on id attribute value | [optional] 
 **filterUserPublicProfileId** | [**[String]**](String.md) | Allows to filter the collection of resources based on userPublicProfile.id attribute value | [optional] 

### Return type

[**UserPublicProfilePicksMultiDataDocument**](UserPublicProfilePicksMultiDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **setUserPublicProfilePickItemRelationship**
```swift
    open class func setUserPublicProfilePickItemRelationship(id: String, updatePickRelationshipBody: UpdatePickRelationshipBody, include: [String]? = nil, completion: @escaping (_ data: AnyCodable?, _ error: Error?) -> Void)
```

Relationship: item (update)

Updates a picks item relationship, e.g. sets a 'track', 'album' or 'artist' reference.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | TIDAL pick id
let updatePickRelationshipBody = UpdatePickRelationshipBody(data: UpdatePickRelationshipBody_Data(type: "type_example", id: "id_example")) // UpdatePickRelationshipBody | 
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned (optional)

// Relationship: item (update)
UserPublicProfilePicksAPI.setUserPublicProfilePickItemRelationship(id: id, updatePickRelationshipBody: updatePickRelationshipBody, include: include) { (response, error) in
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
 **id** | **String** | TIDAL pick id | 
 **updatePickRelationshipBody** | [**UpdatePickRelationshipBody**](UpdatePickRelationshipBody.md) |  | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned | [optional] 

### Return type

**AnyCodable**

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json, */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

