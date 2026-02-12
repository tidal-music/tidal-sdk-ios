# CreditsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**creditsGet**](CreditsAPI.md#creditsget) | **GET** /credits | Get multiple credits.
[**creditsIdGet**](CreditsAPI.md#creditsidget) | **GET** /credits/{id} | Get single credit.
[**creditsIdRelationshipsArtistGet**](CreditsAPI.md#creditsidrelationshipsartistget) | **GET** /credits/{id}/relationships/artist | Get artist relationship (\&quot;to-one\&quot;).
[**creditsIdRelationshipsCategoryGet**](CreditsAPI.md#creditsidrelationshipscategoryget) | **GET** /credits/{id}/relationships/category | Get category relationship (\&quot;to-one\&quot;).


# **creditsGet**
```swift
    open class func creditsGet(include: [String]? = nil, filterId: [String]? = nil, completion: @escaping (_ data: CreditsMultiResourceDataDocument?, _ error: Error?) -> Void)
```

Get multiple credits.

Retrieves multiple credits by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: artist, category (optional)
let filterId = ["inner_example"] // [String] | Credit id (e.g. `3fG7kLmN2pQrStUv`) (optional)

// Get multiple credits.
CreditsAPI.creditsGet(include: include, filterId: filterId) { (response, error) in
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
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: artist, category | [optional] 
 **filterId** | [**[String]**](String.md) | Credit id (e.g. &#x60;3fG7kLmN2pQrStUv&#x60;) | [optional] 

### Return type

[**CreditsMultiResourceDataDocument**](CreditsMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **creditsIdGet**
```swift
    open class func creditsIdGet(id: String, include: [String]? = nil, completion: @escaping (_ data: CreditsSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single credit.

Retrieves single credit by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Credit id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: artist, category (optional)

// Get single credit.
CreditsAPI.creditsIdGet(id: id, include: include) { (response, error) in
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
 **id** | **String** | Credit id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: artist, category | [optional] 

### Return type

[**CreditsSingleResourceDataDocument**](CreditsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **creditsIdRelationshipsArtistGet**
```swift
    open class func creditsIdRelationshipsArtistGet(id: String, include: [String]? = nil, completion: @escaping (_ data: CreditsSingleRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get artist relationship (\"to-one\").

Retrieves artist relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Credit id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: artist (optional)

// Get artist relationship (\"to-one\").
CreditsAPI.creditsIdRelationshipsArtistGet(id: id, include: include) { (response, error) in
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
 **id** | **String** | Credit id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: artist | [optional] 

### Return type

[**CreditsSingleRelationshipDataDocument**](CreditsSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **creditsIdRelationshipsCategoryGet**
```swift
    open class func creditsIdRelationshipsCategoryGet(id: String, include: [String]? = nil, completion: @escaping (_ data: CreditsSingleRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get category relationship (\"to-one\").

Retrieves category relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Credit id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: category (optional)

// Get category relationship (\"to-one\").
CreditsAPI.creditsIdRelationshipsCategoryGet(id: id, include: include) { (response, error) in
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
 **id** | **String** | Credit id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: category | [optional] 

### Return type

[**CreditsSingleRelationshipDataDocument**](CreditsSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

