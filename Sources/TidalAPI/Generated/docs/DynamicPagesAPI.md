# DynamicPagesAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**dynamicPagesGet**](DynamicPagesAPI.md#dynamicpagesget) | **GET** /dynamicPages | Get multiple dynamicPages.
[**dynamicPagesIdRelationshipsModulesGet**](DynamicPagesAPI.md#dynamicpagesidrelationshipsmodulesget) | **GET** /dynamicPages/{id}/relationships/modules | Get modules relationship (\&quot;to-many\&quot;).
[**dynamicPagesIdRelationshipsSubjectGet**](DynamicPagesAPI.md#dynamicpagesidrelationshipssubjectget) | **GET** /dynamicPages/{id}/relationships/subject | Get subject relationship (\&quot;to-one\&quot;).


# **dynamicPagesGet**
```swift
    open class func dynamicPagesGet(clientVersion: String, deviceType: DeviceType_dynamicPagesGet, filterPageType: [FilterPageType_dynamicPagesGet], systemType: SystemType_dynamicPagesGet, countryCode: String? = nil, filterSubject: String? = nil, include: [String]? = nil, includeLinkage: [IncludeLinkage_dynamicPagesGet]? = nil, locale: String? = nil, refreshSeed: String? = nil, replaceMedia: String? = nil) async throws -> DynamicPagesMultiResourceDataDocument
```

Get multiple dynamicPages.

Retrieves multiple dynamicPages by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let clientVersion = "clientVersion_example" // String | Client version number
let deviceType = "deviceType_example" // String | The type of device making the request
let filterPageType = ["filterPageType_example"] // [String] | Type of the page (e.g. `ARTIST`)
let systemType = "systemType_example" // String | The system type of the device making the request
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let filterSubject = "filterSubject_example" // String | The page subject. Its type must match pageType. Required except for HOME_FREE, where it must be omitted. Also accepts `users:me`. (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: modules, subject (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let locale = "locale_example" // String | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. (optional) (default to "en-US")
let refreshSeed = "refreshSeed_example" // String | Stable seed used to keep dynamic page and module results consistent across a client session. (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: modules.items (optional)

// Get multiple dynamicPages.
do {
    let response = try await DynamicPagesAPI.dynamicPagesGet(clientVersion: clientVersion, deviceType: deviceType, filterPageType: filterPageType, systemType: systemType, countryCode: countryCode, filterSubject: filterSubject, include: include, includeLinkage: includeLinkage, locale: locale, refreshSeed: refreshSeed, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **clientVersion** | **String** | Client version number | 
 **deviceType** | **String** | The type of device making the request | 
 **filterPageType** | [**[String]**](String.md) | Type of the page (e.g. &#x60;ARTIST&#x60;) | 
 **systemType** | **String** | The system type of the device making the request | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **filterSubject** | **String** | The page subject. Its type must match pageType. Required except for HOME_FREE, where it must be omitted. Also accepts &#x60;users:me&#x60;. | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: modules, subject | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **locale** | **String** | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. | [optional] [default to &quot;en-US&quot;]
 **refreshSeed** | **String** | Stable seed used to keep dynamic page and module results consistent across a client session. | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: modules.items | [optional] 

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
    open class func dynamicPagesIdRelationshipsModulesGet(clientVersion: String, deviceType: DeviceType_dynamicPagesIdRelationshipsModulesGet, id: String, systemType: SystemType_dynamicPagesIdRelationshipsModulesGet, countryCode: String? = nil, include: [String]? = nil, locale: String? = nil, pageCursor: String? = nil, refreshSeed: String? = nil, replaceMedia: String? = nil) async throws -> DynamicPagesModulesMultiRelationshipDataDocument
```

Get modules relationship (\"to-many\").

The page's modules, in display order.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let clientVersion = "clientVersion_example" // String | Client version number
let deviceType = "deviceType_example" // String | The type of device making the request
let id = "id_example" // String | DynamicPages Id
let systemType = "systemType_example" // String | The system type of the device making the request
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: modules (optional)
let locale = "locale_example" // String | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. (optional) (default to "en-US")
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let refreshSeed = "refreshSeed_example" // String | Stable seed used to keep dynamic page and module results consistent across a client session. (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: modules.items (optional)

// Get modules relationship (\"to-many\").
do {
    let response = try await DynamicPagesAPI.dynamicPagesIdRelationshipsModulesGet(clientVersion: clientVersion, deviceType: deviceType, id: id, systemType: systemType, countryCode: countryCode, include: include, locale: locale, pageCursor: pageCursor, refreshSeed: refreshSeed, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **clientVersion** | **String** | Client version number | 
 **deviceType** | **String** | The type of device making the request | 
 **id** | **String** | DynamicPages Id | 
 **systemType** | **String** | The system type of the device making the request | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: modules | [optional] 
 **locale** | **String** | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. | [optional] [default to &quot;en-US&quot;]
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **refreshSeed** | **String** | Stable seed used to keep dynamic page and module results consistent across a client session. | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: modules.items | [optional] 

### Return type

[**DynamicPagesModulesMultiRelationshipDataDocument**](DynamicPagesModulesMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **dynamicPagesIdRelationshipsSubjectGet**
```swift
    open class func dynamicPagesIdRelationshipsSubjectGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> DynamicPagesSubjectSingleRelationshipDataDocument
```

Get subject relationship (\"to-one\").

Retrieves subject relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | DynamicPages Id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: subject (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: subject (optional)

// Get subject relationship (\"to-one\").
do {
    let response = try await DynamicPagesAPI.dynamicPagesIdRelationshipsSubjectGet(id: id, include: include, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | DynamicPages Id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: subject | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: subject | [optional] 

### Return type

[**DynamicPagesSubjectSingleRelationshipDataDocument**](DynamicPagesSubjectSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

