# UserRecommendationsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**userRecommendationsGet**](UserRecommendationsAPI.md#userrecommendationsget) | **GET** /userRecommendations | Get all userRecommendations
[**userRecommendationsIdGet**](UserRecommendationsAPI.md#userrecommendationsidget) | **GET** /userRecommendations/{id} | Get single userRecommendation
[**userRecommendationsIdRelationshipsDiscoveryMixesGet**](UserRecommendationsAPI.md#userrecommendationsidrelationshipsdiscoverymixesget) | **GET** /userRecommendations/{id}/relationships/discoveryMixes | Relationship: discoveryMixes
[**userRecommendationsIdRelationshipsMyMixesGet**](UserRecommendationsAPI.md#userrecommendationsidrelationshipsmymixesget) | **GET** /userRecommendations/{id}/relationships/myMixes | Relationship: myMixes
[**userRecommendationsIdRelationshipsNewArrivalMixesGet**](UserRecommendationsAPI.md#userrecommendationsidrelationshipsnewarrivalmixesget) | **GET** /userRecommendations/{id}/relationships/newArrivalMixes | Relationship: newArrivalMixes
[**userRecommendationsMeGet**](UserRecommendationsAPI.md#userrecommendationsmeget) | **GET** /userRecommendations/me | Get current user&#39;s userRecommendation data


# **userRecommendationsGet**
```swift
    open class func userRecommendationsGet(include: [String]? = nil, filterId: [String]? = nil, completion: @escaping (_ data: UserRecommendationsMultiDataDocument?, _ error: Error?) -> Void)
```

Get all userRecommendations

Retrieves all userRecommendation details by available filters or without (if applicable).

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: discoveryMixes, myMixes, newArrivalMixes (optional)
let filterId = ["inner_example"] // [String] | Allows to filter the collection of resources based on id attribute value (optional)

// Get all userRecommendations
UserRecommendationsAPI.userRecommendationsGet(include: include, filterId: filterId) { (response, error) in
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
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: discoveryMixes, myMixes, newArrivalMixes | [optional] 
 **filterId** | [**[String]**](String.md) | Allows to filter the collection of resources based on id attribute value | [optional] 

### Return type

[**UserRecommendationsMultiDataDocument**](UserRecommendationsMultiDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userRecommendationsIdGet**
```swift
    open class func userRecommendationsIdGet(id: String, include: [String]? = nil, completion: @escaping (_ data: UserRecommendationsSingleDataDocument?, _ error: Error?) -> Void)
```

Get single userRecommendation

Retrieves userRecommendation details by an unique id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User recommendations id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: discoveryMixes, myMixes, newArrivalMixes (optional)

// Get single userRecommendation
UserRecommendationsAPI.userRecommendationsIdGet(id: id, include: include) { (response, error) in
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
 **id** | **String** | User recommendations id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: discoveryMixes, myMixes, newArrivalMixes | [optional] 

### Return type

[**UserRecommendationsSingleDataDocument**](UserRecommendationsSingleDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userRecommendationsIdRelationshipsDiscoveryMixesGet**
```swift
    open class func userRecommendationsIdRelationshipsDiscoveryMixesGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: UserRecommendationsMultiDataRelationshipDocument?, _ error: Error?) -> Void)
```

Relationship: discoveryMixes

Retrieves discoveryMixes relationship details of the related userRecommendation resource.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User recommendations id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: discoveryMixes (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Relationship: discoveryMixes
UserRecommendationsAPI.userRecommendationsIdRelationshipsDiscoveryMixesGet(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | User recommendations id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: discoveryMixes | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**UserRecommendationsMultiDataRelationshipDocument**](UserRecommendationsMultiDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userRecommendationsIdRelationshipsMyMixesGet**
```swift
    open class func userRecommendationsIdRelationshipsMyMixesGet(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: UserRecommendationsMultiDataRelationshipDocument?, _ error: Error?) -> Void)
```

Relationship: myMixes

Retrieves myMixes relationship details of the related userRecommendation resource.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User recommendations id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: myMixes (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Relationship: myMixes
UserRecommendationsAPI.userRecommendationsIdRelationshipsMyMixesGet(id: id, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | User recommendations id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: myMixes | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**UserRecommendationsMultiDataRelationshipDocument**](UserRecommendationsMultiDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userRecommendationsIdRelationshipsNewArrivalMixesGet**
```swift
    open class func userRecommendationsIdRelationshipsNewArrivalMixesGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: UserRecommendationsMultiDataRelationshipDocument?, _ error: Error?) -> Void)
```

Relationship: newArrivalMixes

Retrieves newArrivalMixes relationship details of the related userRecommendation resource.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User recommendations id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: newArrivalMixes (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Relationship: newArrivalMixes
UserRecommendationsAPI.userRecommendationsIdRelationshipsNewArrivalMixesGet(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | User recommendations id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: newArrivalMixes | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**UserRecommendationsMultiDataRelationshipDocument**](UserRecommendationsMultiDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userRecommendationsMeGet**
```swift
    open class func userRecommendationsMeGet(include: [String]? = nil, completion: @escaping (_ data: UserRecommendationsSingleDataDocument?, _ error: Error?) -> Void)
```

Get current user's userRecommendation data

Retrieves current user's userRecommendation details.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: discoveryMixes, myMixes, newArrivalMixes (optional)

// Get current user's userRecommendation data
UserRecommendationsAPI.userRecommendationsMeGet(include: include) { (response, error) in
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
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: discoveryMixes, myMixes, newArrivalMixes | [optional] 

### Return type

[**UserRecommendationsSingleDataDocument**](UserRecommendationsSingleDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

