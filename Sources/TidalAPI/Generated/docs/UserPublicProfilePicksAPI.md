# UserPublicProfilePicksAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**userPublicProfilePicksGet**](UserPublicProfilePicksAPI.md#userpublicprofilepicksget) | **GET** /userPublicProfilePicks | Get all userPublicProfilePicks
[**userPublicProfilePicksIdRelationshipsItemGet**](UserPublicProfilePicksAPI.md#userpublicprofilepicksidrelationshipsitemget) | **GET** /userPublicProfilePicks/{id}/relationships/item | Relationship: item(read)
[**userPublicProfilePicksIdRelationshipsItemPatch**](UserPublicProfilePicksAPI.md#userpublicprofilepicksidrelationshipsitempatch) | **PATCH** /userPublicProfilePicks/{id}/relationships/item | Relationship: item (create/update/delete)
[**userPublicProfilePicksIdRelationshipsUserPublicProfileGet**](UserPublicProfilePicksAPI.md#userpublicprofilepicksidrelationshipsuserpublicprofileget) | **GET** /userPublicProfilePicks/{id}/relationships/userPublicProfile | Relationship: userPublicProfile(read)
[**userPublicProfilePicksMeGet**](UserPublicProfilePicksAPI.md#userpublicprofilepicksmeget) | **GET** /userPublicProfilePicks/me | Get current user&#39;s userPublicProfilePick data


# **userPublicProfilePicksGet**
```swift
    open class func userPublicProfilePicksGet(countryCode: String, locale: String, include: [String]? = nil, filterUserPublicProfileId: [String]? = nil, filterId: [String]? = nil, completion: @escaping (_ data: UserPublicProfilePicksMultiDataDocument?, _ error: Error?) -> Void)
```

Get all userPublicProfilePicks

Retrieves all userPublicProfilePick details by available filters or without (if applicable).

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let locale = "locale_example" // String | BCP47 locale code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: item, userPublicProfile (optional)
let filterUserPublicProfileId = ["inner_example"] // [String] | Allows to filter the collection of resources based on userPublicProfile.id attribute value (optional)
let filterId = ["inner_example"] // [String] | Allows to filter the collection of resources based on id attribute value (optional)

// Get all userPublicProfilePicks
UserPublicProfilePicksAPI.userPublicProfilePicksGet(countryCode: countryCode, locale: locale, include: include, filterUserPublicProfileId: filterUserPublicProfileId, filterId: filterId) { (response, error) in
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
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **locale** | **String** | BCP47 locale code | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: item, userPublicProfile | [optional] 
 **filterUserPublicProfileId** | [**[String]**](String.md) | Allows to filter the collection of resources based on userPublicProfile.id attribute value | [optional] 
 **filterId** | [**[String]**](String.md) | Allows to filter the collection of resources based on id attribute value | [optional] 

### Return type

[**UserPublicProfilePicksMultiDataDocument**](UserPublicProfilePicksMultiDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userPublicProfilePicksIdRelationshipsItemGet**
```swift
    open class func userPublicProfilePicksIdRelationshipsItemGet(id: String, countryCode: String, locale: String, include: [String]? = nil, completion: @escaping (_ data: UserPublicProfilePicksSingletonDataRelationshipDocument?, _ error: Error?) -> Void)
```

Relationship: item(read)

Retrieves item relationship details of the related userPublicProfilePick resource.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User profile id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let locale = "locale_example" // String | BCP47 locale code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: item (optional)

// Relationship: item(read)
UserPublicProfilePicksAPI.userPublicProfilePicksIdRelationshipsItemGet(id: id, countryCode: countryCode, locale: locale, include: include) { (response, error) in
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
 **id** | **String** | User profile id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **locale** | **String** | BCP47 locale code | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: item | [optional] 

### Return type

[**UserPublicProfilePicksSingletonDataRelationshipDocument**](UserPublicProfilePicksSingletonDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userPublicProfilePicksIdRelationshipsItemPatch**
```swift
    open class func userPublicProfilePicksIdRelationshipsItemPatch(updatePickRelationshipBody: UpdatePickRelationshipBody? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Relationship: item (create/update/delete)

Manages item relationship details of the related userPublicProfilePick resource. Use this operation if you need to create, update or delete relationship's linkage.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let updatePickRelationshipBody = UpdatePickRelationshipBody(data: UpdatePickRelationshipBody_Data(type: "type_example", id: "id_example")) // UpdatePickRelationshipBody |  (optional)

// Relationship: item (create/update/delete)
UserPublicProfilePicksAPI.userPublicProfilePicksIdRelationshipsItemPatch(updatePickRelationshipBody: updatePickRelationshipBody) { (response, error) in
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
 **updatePickRelationshipBody** | [**UpdatePickRelationshipBody**](UpdatePickRelationshipBody.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userPublicProfilePicksIdRelationshipsUserPublicProfileGet**
```swift
    open class func userPublicProfilePicksIdRelationshipsUserPublicProfileGet(id: String, include: [String]? = nil, completion: @escaping (_ data: UserPublicProfilePicksSingletonDataRelationshipDocument?, _ error: Error?) -> Void)
```

Relationship: userPublicProfile(read)

Retrieves userPublicProfile relationship details of the related userPublicProfilePick resource.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User picks id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: userPublicProfile (optional)

// Relationship: userPublicProfile(read)
UserPublicProfilePicksAPI.userPublicProfilePicksIdRelationshipsUserPublicProfileGet(id: id, include: include) { (response, error) in
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
 **id** | **String** | User picks id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: userPublicProfile | [optional] 

### Return type

[**UserPublicProfilePicksSingletonDataRelationshipDocument**](UserPublicProfilePicksSingletonDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userPublicProfilePicksMeGet**
```swift
    open class func userPublicProfilePicksMeGet(id: String, countryCode: String, locale: String, include: [String]? = nil, completion: @escaping (_ data: UserPublicProfilePicksMultiDataDocument?, _ error: Error?) -> Void)
```

Get current user's userPublicProfilePick data

Retrieves current user's userPublicProfilePick details.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User picks id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let locale = "locale_example" // String | BCP47 locale code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: item, userPublicProfile (optional)

// Get current user's userPublicProfilePick data
UserPublicProfilePicksAPI.userPublicProfilePicksMeGet(id: id, countryCode: countryCode, locale: locale, include: include) { (response, error) in
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
 **id** | **String** | User picks id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **locale** | **String** | BCP47 locale code | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: item, userPublicProfile | [optional] 

### Return type

[**UserPublicProfilePicksMultiDataDocument**](UserPublicProfilePicksMultiDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

