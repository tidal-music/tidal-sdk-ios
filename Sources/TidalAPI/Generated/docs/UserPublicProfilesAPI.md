# UserPublicProfilesAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getMyUserPublicProfile**](UserPublicProfilesAPI.md#getmyuserpublicprofile) | **GET** /userPublicProfiles/me | Get my user profile
[**getUserPublicProfileById**](UserPublicProfilesAPI.md#getuserpublicprofilebyid) | **GET** /userPublicProfiles/{id} | Get user public profile by id
[**getUserPublicProfileFollowersRelationship**](UserPublicProfilesAPI.md#getuserpublicprofilefollowersrelationship) | **GET** /userPublicProfiles/{id}/relationships/followers | Relationship: followers
[**getUserPublicProfileFollowingRelationship**](UserPublicProfilesAPI.md#getuserpublicprofilefollowingrelationship) | **GET** /userPublicProfiles/{id}/relationships/following | Relationship: following
[**getUserPublicProfilePublicPicksRelationship**](UserPublicProfilesAPI.md#getuserpublicprofilepublicpicksrelationship) | **GET** /userPublicProfiles/{id}/relationships/publicPicks | Relationship: picks
[**getUserPublicProfilePublicPlaylistsRelationship**](UserPublicProfilesAPI.md#getuserpublicprofilepublicplaylistsrelationship) | **GET** /userPublicProfiles/{id}/relationships/publicPlaylists | Relationship: playlists
[**getUserPublicProfilesByFilters**](UserPublicProfilesAPI.md#getuserpublicprofilesbyfilters) | **GET** /userPublicProfiles | Get user public profiles
[**updateMyUserProfile**](UserPublicProfilesAPI.md#updatemyuserprofile) | **PATCH** /userPublicProfiles/{id} | Update user public profile


# **getMyUserPublicProfile**
```swift
    open class func getMyUserPublicProfile(locale: String, include: [String]? = nil, completion: @escaping (_ data: UserPublicProfilesSingleDataDocument?, _ error: Error?) -> Void)
```

Get my user profile

Retrieve the logged-in user's public profile details.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let locale = "locale_example" // String | Locale language tag (IETF BCP 47 Language Tag)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: publicPlaylists, publicPicks, followers, following (optional)

// Get my user profile
UserPublicProfilesAPI.getMyUserPublicProfile(locale: locale, include: include) { (response, error) in
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
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: publicPlaylists, publicPicks, followers, following | [optional] 

### Return type

[**UserPublicProfilesSingleDataDocument**](UserPublicProfilesSingleDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getUserPublicProfileById**
```swift
    open class func getUserPublicProfileById(id: String, locale: String, include: [String]? = nil, completion: @escaping (_ data: UserPublicProfilesSingleDataDocument?, _ error: Error?) -> Void)
```

Get user public profile by id

Retrieve user public profile details by TIDAL user id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | TIDAL user id
let locale = "locale_example" // String | Locale language tag (IETF BCP 47 Language Tag)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: publicPlaylists, publicPicks, followers, following (optional)

// Get user public profile by id
UserPublicProfilesAPI.getUserPublicProfileById(id: id, locale: locale, include: include) { (response, error) in
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
 **id** | **String** | TIDAL user id | 
 **locale** | **String** | Locale language tag (IETF BCP 47 Language Tag) | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: publicPlaylists, publicPicks, followers, following | [optional] 

### Return type

[**UserPublicProfilesSingleDataDocument**](UserPublicProfilesSingleDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getUserPublicProfileFollowersRelationship**
```swift
    open class func getUserPublicProfileFollowersRelationship(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: UserPublicProfilesMultiDataRelationshipDocument?, _ error: Error?) -> Void)
```

Relationship: followers

Retrieve user's public followers

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | TIDAL user id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: followers (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Relationship: followers
UserPublicProfilesAPI.getUserPublicProfileFollowersRelationship(id: id, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | TIDAL user id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: followers | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**UserPublicProfilesMultiDataRelationshipDocument**](UserPublicProfilesMultiDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getUserPublicProfileFollowingRelationship**
```swift
    open class func getUserPublicProfileFollowingRelationship(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: UserPublicProfilesMultiDataRelationshipDocument?, _ error: Error?) -> Void)
```

Relationship: following

Retrieve user's public followings

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | TIDAL user id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: following (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Relationship: following
UserPublicProfilesAPI.getUserPublicProfileFollowingRelationship(id: id, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | TIDAL user id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: following | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**UserPublicProfilesMultiDataRelationshipDocument**](UserPublicProfilesMultiDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getUserPublicProfilePublicPicksRelationship**
```swift
    open class func getUserPublicProfilePublicPicksRelationship(id: String, locale: String, include: [String]? = nil, completion: @escaping (_ data: UserPublicProfilesMultiDataRelationshipDocument?, _ error: Error?) -> Void)
```

Relationship: picks

Retrieve user's public picks.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | TIDAL user id
let locale = "locale_example" // String | Locale language tag (IETF BCP 47 Language Tag)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: publicPicks (optional)

// Relationship: picks
UserPublicProfilesAPI.getUserPublicProfilePublicPicksRelationship(id: id, locale: locale, include: include) { (response, error) in
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
 **id** | **String** | TIDAL user id | 
 **locale** | **String** | Locale language tag (IETF BCP 47 Language Tag) | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: publicPicks | [optional] 

### Return type

[**UserPublicProfilesMultiDataRelationshipDocument**](UserPublicProfilesMultiDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getUserPublicProfilePublicPlaylistsRelationship**
```swift
    open class func getUserPublicProfilePublicPlaylistsRelationship(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: UserPublicProfilesMultiDataRelationshipDocument?, _ error: Error?) -> Void)
```

Relationship: playlists

Retrieves user's public playlists.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | TIDAL user id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: publicPlaylists (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Relationship: playlists
UserPublicProfilesAPI.getUserPublicProfilePublicPlaylistsRelationship(id: id, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | TIDAL user id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: publicPlaylists | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**UserPublicProfilesMultiDataRelationshipDocument**](UserPublicProfilesMultiDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getUserPublicProfilesByFilters**
```swift
    open class func getUserPublicProfilesByFilters(locale: String, include: [String]? = nil, filterId: [String]? = nil, completion: @escaping (_ data: UserPublicProfilesMultiDataDocument?, _ error: Error?) -> Void)
```

Get user public profiles

Reads user public profile details by TIDAL user ids.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let locale = "locale_example" // String | Locale language tag (IETF BCP 47 Language Tag)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: publicPlaylists, publicPicks, followers, following (optional)
let filterId = ["inner_example"] // [String] | TIDAL user id (optional)

// Get user public profiles
UserPublicProfilesAPI.getUserPublicProfilesByFilters(locale: locale, include: include, filterId: filterId) { (response, error) in
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
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: publicPlaylists, publicPicks, followers, following | [optional] 
 **filterId** | [**[String]**](String.md) | TIDAL user id | [optional] 

### Return type

[**UserPublicProfilesMultiDataDocument**](UserPublicProfilesMultiDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateMyUserProfile**
```swift
    open class func updateMyUserProfile(id: String, updateUserProfileBody: UpdateUserProfileBody, include: [String]? = nil, completion: @escaping (_ data: AnyCodable?, _ error: Error?) -> Void)
```

Update user public profile

Update user public profile

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | ${public.usercontent.updateProfile.id.descr}
let updateUserProfileBody = UpdateUserProfileBody(data: UpdateUserProfileBody_Data(attributes: UpdateUserProfileBody_Data_Attributes(handle: "handle_example", profileName: "profileName_example", externalLinks: [User_Public_Profiles_External_Link(href: "href_example", meta: User_Public_Profiles_External_Link_Meta(type: "type_example", handle: "handle_example"))]))) // UpdateUserProfileBody | 
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned (optional)

// Update user public profile
UserPublicProfilesAPI.updateMyUserProfile(id: id, updateUserProfileBody: updateUserProfileBody, include: include) { (response, error) in
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
 **id** | **String** | ${public.usercontent.updateProfile.id.descr} | 
 **updateUserProfileBody** | [**UpdateUserProfileBody**](UpdateUserProfileBody.md) |  | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned | [optional] 

### Return type

**AnyCodable**

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json, */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

