# UserPublicProfilesAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**userPublicProfilesGet**](UserPublicProfilesAPI.md#userpublicprofilesget) | **GET** /userPublicProfiles | Get all userPublicProfiles
[**userPublicProfilesIdGet**](UserPublicProfilesAPI.md#userpublicprofilesidget) | **GET** /userPublicProfiles/{id} | Get single userPublicProfile
[**userPublicProfilesIdPatch**](UserPublicProfilesAPI.md#userpublicprofilesidpatch) | **PATCH** /userPublicProfiles/{id} | Update single userPublicProfile
[**userPublicProfilesIdRelationshipsFollowersGet**](UserPublicProfilesAPI.md#userpublicprofilesidrelationshipsfollowersget) | **GET** /userPublicProfiles/{id}/relationships/followers | Relationship: followers
[**userPublicProfilesIdRelationshipsFollowingGet**](UserPublicProfilesAPI.md#userpublicprofilesidrelationshipsfollowingget) | **GET** /userPublicProfiles/{id}/relationships/following | Relationship: following
[**userPublicProfilesIdRelationshipsPublicPicksGet**](UserPublicProfilesAPI.md#userpublicprofilesidrelationshipspublicpicksget) | **GET** /userPublicProfiles/{id}/relationships/publicPicks | Relationship: publicPicks
[**userPublicProfilesIdRelationshipsPublicPlaylistsGet**](UserPublicProfilesAPI.md#userpublicprofilesidrelationshipspublicplaylistsget) | **GET** /userPublicProfiles/{id}/relationships/publicPlaylists | Relationship: publicPlaylists
[**userPublicProfilesMeGet**](UserPublicProfilesAPI.md#userpublicprofilesmeget) | **GET** /userPublicProfiles/me | Get current user&#39;s userPublicProfile data


# **userPublicProfilesGet**
```swift
    open class func userPublicProfilesGet(countryCode: String, include: [String]? = nil, filterId: [String]? = nil, completion: @escaping (_ data: UserPublicProfilesMultiDataDocument?, _ error: Error?) -> Void)
```

Get all userPublicProfiles

Retrieves all userPublicProfile details by available filters or without (if applicable).

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: followers, following, publicPicks, publicPlaylists (optional)
let filterId = ["inner_example"] // [String] | Allows to filter the collection of resources based on id attribute value (optional)

// Get all userPublicProfiles
UserPublicProfilesAPI.userPublicProfilesGet(countryCode: countryCode, include: include, filterId: filterId) { (response, error) in
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
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: followers, following, publicPicks, publicPlaylists | [optional] 
 **filterId** | [**[String]**](String.md) | Allows to filter the collection of resources based on id attribute value | [optional] 

### Return type

[**UserPublicProfilesMultiDataDocument**](UserPublicProfilesMultiDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userPublicProfilesIdGet**
```swift
    open class func userPublicProfilesIdGet(id: String, countryCode: String, include: [String]? = nil, completion: @escaping (_ data: UserPublicProfilesSingleDataDocument?, _ error: Error?) -> Void)
```

Get single userPublicProfile

Retrieves userPublicProfile details by an unique id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User profile id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: followers, following, publicPicks, publicPlaylists (optional)

// Get single userPublicProfile
UserPublicProfilesAPI.userPublicProfilesIdGet(id: id, countryCode: countryCode, include: include) { (response, error) in
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
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: followers, following, publicPicks, publicPlaylists | [optional] 

### Return type

[**UserPublicProfilesSingleDataDocument**](UserPublicProfilesSingleDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userPublicProfilesIdPatch**
```swift
    open class func userPublicProfilesIdPatch(updateUserProfileBody: UpdateUserProfileBody? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Update single userPublicProfile

Updates the existing instance of userPublicProfile's resource.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let updateUserProfileBody = UpdateUserProfileBody(data: UpdateUserProfileBody_Data(id: "id_example", type: "type_example", attributes: UpdateUserProfileBody_Data_Attributes(handle: "handle_example", profileName: "profileName_example", externalLinks: [User_Public_Profiles_External_Link(href: "href_example", meta: User_Public_Profiles_External_Link_Meta(type: "type_example", handle: "handle_example"))]))) // UpdateUserProfileBody |  (optional)

// Update single userPublicProfile
UserPublicProfilesAPI.userPublicProfilesIdPatch(updateUserProfileBody: updateUserProfileBody) { (response, error) in
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
 **updateUserProfileBody** | [**UpdateUserProfileBody**](UpdateUserProfileBody.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userPublicProfilesIdRelationshipsFollowersGet**
```swift
    open class func userPublicProfilesIdRelationshipsFollowersGet(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: UserPublicProfilesMultiDataRelationshipDocument?, _ error: Error?) -> Void)
```

Relationship: followers

Retrieves followers relationship details of the related userPublicProfile resource.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User profile id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: followers (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Relationship: followers
UserPublicProfilesAPI.userPublicProfilesIdRelationshipsFollowersGet(id: id, include: include, pageCursor: pageCursor) { (response, error) in
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
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: followers | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**UserPublicProfilesMultiDataRelationshipDocument**](UserPublicProfilesMultiDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userPublicProfilesIdRelationshipsFollowingGet**
```swift
    open class func userPublicProfilesIdRelationshipsFollowingGet(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: UserPublicProfilesMultiDataRelationshipDocument?, _ error: Error?) -> Void)
```

Relationship: following

Retrieves following relationship details of the related userPublicProfile resource.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User profile id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: following (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Relationship: following
UserPublicProfilesAPI.userPublicProfilesIdRelationshipsFollowingGet(id: id, include: include, pageCursor: pageCursor) { (response, error) in
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
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: following | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**UserPublicProfilesMultiDataRelationshipDocument**](UserPublicProfilesMultiDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userPublicProfilesIdRelationshipsPublicPicksGet**
```swift
    open class func userPublicProfilesIdRelationshipsPublicPicksGet(id: String, countryCode: String, locale: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: UserPublicProfilesMultiDataRelationshipDocument?, _ error: Error?) -> Void)
```

Relationship: publicPicks

Retrieves publicPicks relationship details of the related userPublicProfile resource.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User profile id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let locale = "locale_example" // String | BCP47 locale code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: publicPicks (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Relationship: publicPicks
UserPublicProfilesAPI.userPublicProfilesIdRelationshipsPublicPicksGet(id: id, countryCode: countryCode, locale: locale, include: include, pageCursor: pageCursor) { (response, error) in
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
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: publicPicks | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**UserPublicProfilesMultiDataRelationshipDocument**](UserPublicProfilesMultiDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userPublicProfilesIdRelationshipsPublicPlaylistsGet**
```swift
    open class func userPublicProfilesIdRelationshipsPublicPlaylistsGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: UserPublicProfilesMultiDataRelationshipDocument?, _ error: Error?) -> Void)
```

Relationship: publicPlaylists

Retrieves publicPlaylists relationship details of the related userPublicProfile resource.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User profile id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: publicPlaylists (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Relationship: publicPlaylists
UserPublicProfilesAPI.userPublicProfilesIdRelationshipsPublicPlaylistsGet(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor) { (response, error) in
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
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: publicPlaylists | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**UserPublicProfilesMultiDataRelationshipDocument**](UserPublicProfilesMultiDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userPublicProfilesMeGet**
```swift
    open class func userPublicProfilesMeGet(countryCode: String, include: [String]? = nil, completion: @escaping (_ data: UserPublicProfilesSingleDataDocument?, _ error: Error?) -> Void)
```

Get current user's userPublicProfile data

Retrieves current user's userPublicProfile details.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: followers, following, publicPicks, publicPlaylists (optional)

// Get current user's userPublicProfile data
UserPublicProfilesAPI.userPublicProfilesMeGet(countryCode: countryCode, include: include) { (response, error) in
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
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: followers, following, publicPicks, publicPlaylists | [optional] 

### Return type

[**UserPublicProfilesSingleDataDocument**](UserPublicProfilesSingleDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

