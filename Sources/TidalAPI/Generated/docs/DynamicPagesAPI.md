# DynamicPagesAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**dynamicPagesGet**](DynamicPagesAPI.md#dynamicpagesget) | **GET** /dynamicPages | Get multiple dynamicPages.
[**dynamicPagesIdRelationshipsSubjectGet**](DynamicPagesAPI.md#dynamicpagesidrelationshipssubjectget) | **GET** /dynamicPages/{id}/relationships/subject | Get subject relationship (\&quot;to-one\&quot;).


# **dynamicPagesGet**
```swift
    open class func dynamicPagesGet(clientVersion: String, deviceType: DeviceType_dynamicPagesGet, platform: Platform_dynamicPagesGet, refreshId: Int64? = nil, countryCode: String? = nil, locale: String? = nil, include: [String]? = nil, filterPageType: [String]? = nil, filterSubjectId: [String]? = nil, completion: @escaping (_ data: DynamicPagesMultiResourceDataDocument?, _ error: Error?) -> Void)
```

Get multiple dynamicPages.

Retrieves multiple dynamicPages by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let clientVersion = "clientVersion_example" // String | 
let deviceType = "deviceType_example" // String | The type of device making the request
let platform = "platform_example" // String | The platform of the device making the request
let refreshId = 987 // Int64 |  (optional)
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let locale = "locale_example" // String | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. (optional) (default to "en-US")
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: subject (optional)
let filterPageType = ["inner_example"] // [String] | Filter by page type (optional)
let filterSubjectId = ["inner_example"] // [String] | Filter by subject id (optional)

// Get multiple dynamicPages.
DynamicPagesAPI.dynamicPagesGet(clientVersion: clientVersion, deviceType: deviceType, platform: platform, refreshId: refreshId, countryCode: countryCode, locale: locale, include: include, filterPageType: filterPageType, filterSubjectId: filterSubjectId) { (response, error) in
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
 **clientVersion** | **String** |  | 
 **deviceType** | **String** | The type of device making the request | 
 **platform** | **String** | The platform of the device making the request | 
 **refreshId** | **Int64** |  | [optional] 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **locale** | **String** | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. | [optional] [default to &quot;en-US&quot;]
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: subject | [optional] 
 **filterPageType** | [**[String]**](String.md) | Filter by page type | [optional] 
 **filterSubjectId** | [**[String]**](String.md) | Filter by subject id | [optional] 

### Return type

[**DynamicPagesMultiResourceDataDocument**](DynamicPagesMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **dynamicPagesIdRelationshipsSubjectGet**
```swift
    open class func dynamicPagesIdRelationshipsSubjectGet(id: String, include: [String]? = nil, completion: @escaping (_ data: DynamicPagesSingleRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get subject relationship (\"to-one\").

Retrieves subject relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | DynamicPages Id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: subject (optional)

// Get subject relationship (\"to-one\").
DynamicPagesAPI.dynamicPagesIdRelationshipsSubjectGet(id: id, include: include) { (response, error) in
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
 **id** | **String** | DynamicPages Id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: subject | [optional] 

### Return type

[**DynamicPagesSingleRelationshipDataDocument**](DynamicPagesSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

