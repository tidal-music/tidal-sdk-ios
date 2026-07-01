# DynamicPagesAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**dynamicPagesGet**](DynamicPagesAPI.md#dynamicpagesget) | **GET** /dynamicPages | Get multiple dynamicPages.
[**dynamicPagesIdRelationshipsModulesGet**](DynamicPagesAPI.md#dynamicpagesidrelationshipsmodulesget) | **GET** /dynamicPages/{id}/relationships/modules | Get modules relationship (\&quot;to-many\&quot;).
[**dynamicPagesIdRelationshipsSubjectGet**](DynamicPagesAPI.md#dynamicpagesidrelationshipssubjectget) | **GET** /dynamicPages/{id}/relationships/subject | Get subject relationship (\&quot;to-one\&quot;).


# **dynamicPagesGet**
```swift
    open class func dynamicPagesGet(deviceType: DeviceType_dynamicPagesGet, systemType: SystemType_dynamicPagesGet, clientVersion: String, filterPageType: [String], filterSubjectId: [String], refreshSeed: String? = nil, countryCode: String? = nil, locale: String? = nil, include: [String]? = nil, completion: @escaping (_ data: DynamicPagesMultiResourceDataDocument?, _ error: Error?) -> Void)
```

Get multiple dynamicPages.

Retrieves multiple dynamicPages by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let deviceType = "deviceType_example" // String | The type of device making the request
let systemType = "systemType_example" // String | The system type of the device making the request
let clientVersion = "clientVersion_example" // String | Client version number
let filterPageType = ["inner_example"] // [String] | type of the page (e.g. `ARTIST`)
let filterSubjectId = ["inner_example"] // [String] | the subject id, eg. artistId (e.g. `67890`)
let refreshSeed = "refreshSeed_example" // String | Stable seed used to keep dynamic page and module results consistent across a client session. (optional)
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let locale = "locale_example" // String | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. (optional) (default to "en-US")
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: modules, subject (optional)

// Get multiple dynamicPages.
DynamicPagesAPI.dynamicPagesGet(deviceType: deviceType, systemType: systemType, clientVersion: clientVersion, filterPageType: filterPageType, filterSubjectId: filterSubjectId, refreshSeed: refreshSeed, countryCode: countryCode, locale: locale, include: include) { (response, error) in
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
 **deviceType** | **String** | The type of device making the request | 
 **systemType** | **String** | The system type of the device making the request | 
 **clientVersion** | **String** | Client version number | 
 **filterPageType** | [**[String]**](String.md) | type of the page (e.g. &#x60;ARTIST&#x60;) | 
 **filterSubjectId** | [**[String]**](String.md) | the subject id, eg. artistId (e.g. &#x60;67890&#x60;) | 
 **refreshSeed** | **String** | Stable seed used to keep dynamic page and module results consistent across a client session. | [optional] 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **locale** | **String** | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. | [optional] [default to &quot;en-US&quot;]
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: modules, subject | [optional] 

### Return type

[**DynamicPagesMultiResourceDataDocument**](DynamicPagesMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **dynamicPagesIdRelationshipsModulesGet**
```swift
    open class func dynamicPagesIdRelationshipsModulesGet(id: String, deviceType: DeviceType_dynamicPagesIdRelationshipsModulesGet, systemType: SystemType_dynamicPagesIdRelationshipsModulesGet, clientVersion: String, refreshSeed: String? = nil, pageCursor: String? = nil, countryCode: String? = nil, locale: String? = nil, include: [String]? = nil, completion: @escaping (_ data: DynamicPagesMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get modules relationship (\"to-many\").

Retrieves modules relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | DynamicPages Id
let deviceType = "deviceType_example" // String | The type of device making the request
let systemType = "systemType_example" // String | The system type of the device making the request
let clientVersion = "clientVersion_example" // String | Client version number
let refreshSeed = "refreshSeed_example" // String | Stable seed used to keep dynamic page and module results consistent across a client session. (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let locale = "locale_example" // String | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. (optional) (default to "en-US")
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: modules (optional)

// Get modules relationship (\"to-many\").
DynamicPagesAPI.dynamicPagesIdRelationshipsModulesGet(id: id, deviceType: deviceType, systemType: systemType, clientVersion: clientVersion, refreshSeed: refreshSeed, pageCursor: pageCursor, countryCode: countryCode, locale: locale, include: include) { (response, error) in
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
 **deviceType** | **String** | The type of device making the request | 
 **systemType** | **String** | The system type of the device making the request | 
 **clientVersion** | **String** | Client version number | 
 **refreshSeed** | **String** | Stable seed used to keep dynamic page and module results consistent across a client session. | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **locale** | **String** | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. | [optional] [default to &quot;en-US&quot;]
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: modules | [optional] 

### Return type

[**DynamicPagesMultiRelationshipDataDocument**](DynamicPagesMultiRelationshipDataDocument.md)

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

