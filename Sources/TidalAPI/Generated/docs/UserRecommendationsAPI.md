# UserRecommendationsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**userRecommendationsIdGet**](UserRecommendationsAPI.md#userrecommendationsidget) | **GET** /userRecommendations/{id} | Get single userRecommendation.
[**userRecommendationsIdRelationshipsDiscoveryMixesGet**](UserRecommendationsAPI.md#userrecommendationsidrelationshipsdiscoverymixesget) | **GET** /userRecommendations/{id}/relationships/discoveryMixes | Get discoveryMixes relationship (\&quot;to-many\&quot;).
[**userRecommendationsIdRelationshipsMyMixesGet**](UserRecommendationsAPI.md#userrecommendationsidrelationshipsmymixesget) | **GET** /userRecommendations/{id}/relationships/myMixes | Get myMixes relationship (\&quot;to-many\&quot;).
[**userRecommendationsIdRelationshipsNewArrivalMixesGet**](UserRecommendationsAPI.md#userrecommendationsidrelationshipsnewarrivalmixesget) | **GET** /userRecommendations/{id}/relationships/newArrivalMixes | Get newArrivalMixes relationship (\&quot;to-many\&quot;).


# **userRecommendationsIdGet**
```swift
    open class func userRecommendationsIdGet(id: String, countryCode: String, locale: String? = nil, include: [String]? = nil, completion: @escaping (_ data: UserRecommendationsSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single userRecommendation.

Retrieves single userRecommendation by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User recommendations id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let locale = "locale_example" // String | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. (optional) (default to "en-US")
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: discoveryMixes, myMixes, newArrivalMixes (optional)

// Get single userRecommendation.
UserRecommendationsAPI.userRecommendationsIdGet(id: id, countryCode: countryCode, locale: locale, include: include) { (response, error) in
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
 **locale** | **String** | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. | [optional] [default to &quot;en-US&quot;]
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: discoveryMixes, myMixes, newArrivalMixes | [optional] 

### Return type

[**UserRecommendationsSingleResourceDataDocument**](UserRecommendationsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userRecommendationsIdRelationshipsDiscoveryMixesGet**
```swift
    open class func userRecommendationsIdRelationshipsDiscoveryMixesGet(id: String, countryCode: String, pageCursor: String? = nil, locale: String? = nil, include: [String]? = nil, completion: @escaping (_ data: UserRecommendationsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get discoveryMixes relationship (\"to-many\").

Retrieves discoveryMixes relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User recommendations id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let locale = "locale_example" // String | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. (optional) (default to "en-US")
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: discoveryMixes (optional)

// Get discoveryMixes relationship (\"to-many\").
UserRecommendationsAPI.userRecommendationsIdRelationshipsDiscoveryMixesGet(id: id, countryCode: countryCode, pageCursor: pageCursor, locale: locale, include: include) { (response, error) in
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
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **locale** | **String** | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. | [optional] [default to &quot;en-US&quot;]
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: discoveryMixes | [optional] 

### Return type

[**UserRecommendationsMultiRelationshipDataDocument**](UserRecommendationsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userRecommendationsIdRelationshipsMyMixesGet**
```swift
    open class func userRecommendationsIdRelationshipsMyMixesGet(id: String, countryCode: String, pageCursor: String? = nil, locale: String? = nil, include: [String]? = nil, completion: @escaping (_ data: UserRecommendationsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get myMixes relationship (\"to-many\").

Retrieves myMixes relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User recommendations id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let locale = "locale_example" // String | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. (optional) (default to "en-US")
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: myMixes (optional)

// Get myMixes relationship (\"to-many\").
UserRecommendationsAPI.userRecommendationsIdRelationshipsMyMixesGet(id: id, countryCode: countryCode, pageCursor: pageCursor, locale: locale, include: include) { (response, error) in
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
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **locale** | **String** | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. | [optional] [default to &quot;en-US&quot;]
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: myMixes | [optional] 

### Return type

[**UserRecommendationsMultiRelationshipDataDocument**](UserRecommendationsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userRecommendationsIdRelationshipsNewArrivalMixesGet**
```swift
    open class func userRecommendationsIdRelationshipsNewArrivalMixesGet(id: String, countryCode: String, pageCursor: String? = nil, locale: String? = nil, include: [String]? = nil, completion: @escaping (_ data: UserRecommendationsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get newArrivalMixes relationship (\"to-many\").

Retrieves newArrivalMixes relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User recommendations id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let locale = "locale_example" // String | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. (optional) (default to "en-US")
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: newArrivalMixes (optional)

// Get newArrivalMixes relationship (\"to-many\").
UserRecommendationsAPI.userRecommendationsIdRelationshipsNewArrivalMixesGet(id: id, countryCode: countryCode, pageCursor: pageCursor, locale: locale, include: include) { (response, error) in
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
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **locale** | **String** | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. | [optional] [default to &quot;en-US&quot;]
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: newArrivalMixes | [optional] 

### Return type

[**UserRecommendationsMultiRelationshipDataDocument**](UserRecommendationsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

