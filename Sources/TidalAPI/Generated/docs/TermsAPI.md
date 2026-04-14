# TermsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**termsGet**](TermsAPI.md#termsget) | **GET** /terms | Get multiple terms.
[**termsIdGet**](TermsAPI.md#termsidget) | **GET** /terms/{id} | Get single term.


# **termsGet**
```swift
    open class func termsGet(filterCountryCode: [String]? = nil, filterId: [String]? = nil, filterIsLatestVersion: [String]? = nil, filterTermsType: [FilterTermsType_termsGet]? = nil, completion: @escaping (_ data: TermsMultiResourceDataDocument?, _ error: Error?) -> Void)
```

Get multiple terms.

Retrieves multiple terms by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let filterCountryCode = ["inner_example"] // [String] | Filter by countryCode (optional)
let filterId = ["inner_example"] // [String] | Terms id (e.g. `a468bee88def`) (optional)
let filterIsLatestVersion = ["inner_example"] // [String] | Filter by isLatestVersion (optional)
let filterTermsType = ["filterTermsType_example"] // [String] | One of: DEVELOPER, UPLOAD_MARKETPLACE (e.g. `DEVELOPER`) (optional)

// Get multiple terms.
TermsAPI.termsGet(filterCountryCode: filterCountryCode, filterId: filterId, filterIsLatestVersion: filterIsLatestVersion, filterTermsType: filterTermsType) { (response, error) in
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
 **filterCountryCode** | [**[String]**](String.md) | Filter by countryCode | [optional] 
 **filterId** | [**[String]**](String.md) | Terms id (e.g. &#x60;a468bee88def&#x60;) | [optional] 
 **filterIsLatestVersion** | [**[String]**](String.md) | Filter by isLatestVersion | [optional] 
 **filterTermsType** | [**[String]**](String.md) | One of: DEVELOPER, UPLOAD_MARKETPLACE (e.g. &#x60;DEVELOPER&#x60;) | [optional] 

### Return type

[**TermsMultiResourceDataDocument**](TermsMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **termsIdGet**
```swift
    open class func termsIdGet(id: String, completion: @escaping (_ data: TermsSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single term.

Retrieves single term by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Terms id

// Get single term.
TermsAPI.termsIdGet(id: id) { (response, error) in
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
 **id** | **String** | Terms id | 

### Return type

[**TermsSingleResourceDataDocument**](TermsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

