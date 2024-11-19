# UserRecommendationsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getMyUserRecommendations**](UserRecommendationsAPI.md#getmyuserrecommendations) | **GET** /userRecommendations/me | Get the current users recommendations
[**getUserRecommendationsByFilters**](UserRecommendationsAPI.md#getuserrecommendationsbyfilters) | **GET** /userRecommendations | Get recommendations for users in batch
[**getUserRecommendationsById**](UserRecommendationsAPI.md#getuserrecommendationsbyid) | **GET** /userRecommendations/{id} | Get user recommendations for user
[**getUserRecommendationsDiscoveryMixesRelationship**](UserRecommendationsAPI.md#getuserrecommendationsdiscoverymixesrelationship) | **GET** /userRecommendations/{id}/relationships/discoveryMixes | Relationship: discovery mixes
[**getUserRecommendationsMyMixesRelationship**](UserRecommendationsAPI.md#getuserrecommendationsmymixesrelationship) | **GET** /userRecommendations/{id}/relationships/myMixes | Relationship: my mixes
[**getUserRecommendationsNewArrivalMixesRelationship**](UserRecommendationsAPI.md#getuserrecommendationsnewarrivalmixesrelationship) | **GET** /userRecommendations/{id}/relationships/newArrivalMixes | Relationship: new arrivals mixes


# **getMyUserRecommendations**
```swift
    open class func getMyUserRecommendations(include: [String]? = nil, completion: @escaping (_ data: UserRecommendationsSingleDataDocument?, _ error: Error?) -> Void)
```

Get the current users recommendations

Get the current users recommendations

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: myMixes, discoveryMixes, newArrivalMixes (optional)

// Get the current users recommendations
UserRecommendationsAPI.getMyUserRecommendations(include: include) { (response, error) in
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
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: myMixes, discoveryMixes, newArrivalMixes | [optional] 

### Return type

[**UserRecommendationsSingleDataDocument**](UserRecommendationsSingleDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getUserRecommendationsByFilters**
```swift
    open class func getUserRecommendationsByFilters(include: [String]? = nil, filterId: [String]? = nil, completion: @escaping (_ data: UserRecommendationsMultiDataDocument?, _ error: Error?) -> Void)
```

Get recommendations for users in batch

Get recommendations for users in batch

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: myMixes, discoveryMixes, newArrivalMixes (optional)
let filterId = ["inner_example"] // [String] | User recommendations id (optional)

// Get recommendations for users in batch
UserRecommendationsAPI.getUserRecommendationsByFilters(include: include, filterId: filterId) { (response, error) in
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
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: myMixes, discoveryMixes, newArrivalMixes | [optional] 
 **filterId** | [**[String]**](String.md) | User recommendations id | [optional] 

### Return type

[**UserRecommendationsMultiDataDocument**](UserRecommendationsMultiDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getUserRecommendationsById**
```swift
    open class func getUserRecommendationsById(id: String, include: [String]? = nil, completion: @escaping (_ data: UserRecommendationsSingleDataDocument?, _ error: Error?) -> Void)
```

Get user recommendations for user

Get user recommendations for user

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User recommendations id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: myMixes, discoveryMixes, newArrivalMixes (optional)

// Get user recommendations for user
UserRecommendationsAPI.getUserRecommendationsById(id: id, include: include) { (response, error) in
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
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: myMixes, discoveryMixes, newArrivalMixes | [optional] 

### Return type

[**UserRecommendationsSingleDataDocument**](UserRecommendationsSingleDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getUserRecommendationsDiscoveryMixesRelationship**
```swift
    open class func getUserRecommendationsDiscoveryMixesRelationship(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: UserRecommendationsMultiDataRelationshipDocument?, _ error: Error?) -> Void)
```

Relationship: discovery mixes

Get discovery mixes relationship

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User recommendations id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: discoveryMixes (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Relationship: discovery mixes
UserRecommendationsAPI.getUserRecommendationsDiscoveryMixesRelationship(id: id, include: include, pageCursor: pageCursor) { (response, error) in
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

# **getUserRecommendationsMyMixesRelationship**
```swift
    open class func getUserRecommendationsMyMixesRelationship(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: UserRecommendationsMultiDataRelationshipDocument?, _ error: Error?) -> Void)
```

Relationship: my mixes

Get my mixes relationship

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User recommendations id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: myMixes (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Relationship: my mixes
UserRecommendationsAPI.getUserRecommendationsMyMixesRelationship(id: id, include: include, pageCursor: pageCursor) { (response, error) in
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

# **getUserRecommendationsNewArrivalMixesRelationship**
```swift
    open class func getUserRecommendationsNewArrivalMixesRelationship(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: UserRecommendationsMultiDataRelationshipDocument?, _ error: Error?) -> Void)
```

Relationship: new arrivals mixes

Get new arrival mixes relationship

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User recommendations id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: newArrivalMixes (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Relationship: new arrivals mixes
UserRecommendationsAPI.getUserRecommendationsNewArrivalMixesRelationship(id: id, include: include, pageCursor: pageCursor) { (response, error) in
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

