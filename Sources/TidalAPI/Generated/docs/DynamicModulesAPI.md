# DynamicModulesAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**dynamicModulesGet**](DynamicModulesAPI.md#dynamicmodulesget) | **GET** /dynamicModules | Get multiple dynamicModules.
[**dynamicModulesIdGet**](DynamicModulesAPI.md#dynamicmodulesidget) | **GET** /dynamicModules/{id} | Get single dynamicModule.
[**dynamicModulesIdRelationshipsItemsGet**](DynamicModulesAPI.md#dynamicmodulesidrelationshipsitemsget) | **GET** /dynamicModules/{id}/relationships/items | Get items relationship (\&quot;to-many\&quot;).
[**dynamicModulesIdRelationshipsSeedItemGet**](DynamicModulesAPI.md#dynamicmodulesidrelationshipsseeditemget) | **GET** /dynamicModules/{id}/relationships/seedItem | Get seedItem relationship (\&quot;to-one\&quot;).


# **dynamicModulesGet**
```swift
    open class func dynamicModulesGet(clientVersion: String, deviceType: DeviceType_dynamicModulesGet, filterId: [String], systemType: SystemType_dynamicModulesGet, countryCode: String? = nil, include: [String]? = nil, includeLinkage: [IncludeLinkage_dynamicModulesGet]? = nil, locale: String? = nil, refreshSeed: String? = nil, replaceMedia: String? = nil) async throws -> DynamicModulesMultiResourceDataDocument
```

Get multiple dynamicModules.

Retrieves multiple dynamicModules by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let clientVersion = "clientVersion_example" // String | Client version number
let deviceType = "deviceType_example" // String | The type of device making the request
let filterId = ["inner_example"] // [String] | DynamicModules Id (e.g. `nejMcAhh5N8S3EQ4LaqysVdI0cZZ`)
let systemType = "systemType_example" // String | The system type of the device making the request
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: items, seedItem (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let locale = "locale_example" // String | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. (optional) (default to "en-US")
let refreshSeed = "refreshSeed_example" // String | Stable seed used to keep dynamic page and module results consistent across a client session. (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: items (optional)

// Get multiple dynamicModules.
do {
    let response = try await DynamicModulesAPI.dynamicModulesGet(clientVersion: clientVersion, deviceType: deviceType, filterId: filterId, systemType: systemType, countryCode: countryCode, include: include, includeLinkage: includeLinkage, locale: locale, refreshSeed: refreshSeed, replaceMedia: replaceMedia)
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
 **filterId** | [**[String]**](String.md) | DynamicModules Id (e.g. &#x60;nejMcAhh5N8S3EQ4LaqysVdI0cZZ&#x60;) | 
 **systemType** | **String** | The system type of the device making the request | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: items, seedItem | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **locale** | **String** | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. | [optional] [default to &quot;en-US&quot;]
 **refreshSeed** | **String** | Stable seed used to keep dynamic page and module results consistent across a client session. | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: items | [optional] 

### Return type

[**DynamicModulesMultiResourceDataDocument**](DynamicModulesMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **dynamicModulesIdGet**
```swift
    open class func dynamicModulesIdGet(clientVersion: String, deviceType: DeviceType_dynamicModulesIdGet, id: String, systemType: SystemType_dynamicModulesIdGet, countryCode: String? = nil, include: [String]? = nil, includeLinkage: [IncludeLinkage_dynamicModulesIdGet]? = nil, locale: String? = nil, refreshSeed: String? = nil, replaceMedia: String? = nil) async throws -> DynamicModulesSingleResourceDataDocument
```

Get single dynamicModule.

Retrieves single dynamicModule by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let clientVersion = "clientVersion_example" // String | Client version number
let deviceType = "deviceType_example" // String | The type of device making the request
let id = "id_example" // String | DynamicModules Id
let systemType = "systemType_example" // String | The system type of the device making the request
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: items, seedItem (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let locale = "locale_example" // String | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. (optional) (default to "en-US")
let refreshSeed = "refreshSeed_example" // String | Stable seed used to keep dynamic page and module results consistent across a client session. (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: items (optional)

// Get single dynamicModule.
do {
    let response = try await DynamicModulesAPI.dynamicModulesIdGet(clientVersion: clientVersion, deviceType: deviceType, id: id, systemType: systemType, countryCode: countryCode, include: include, includeLinkage: includeLinkage, locale: locale, refreshSeed: refreshSeed, replaceMedia: replaceMedia)
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
 **id** | **String** | DynamicModules Id | 
 **systemType** | **String** | The system type of the device making the request | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: items, seedItem | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **locale** | **String** | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. | [optional] [default to &quot;en-US&quot;]
 **refreshSeed** | **String** | Stable seed used to keep dynamic page and module results consistent across a client session. | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: items | [optional] 

### Return type

[**DynamicModulesSingleResourceDataDocument**](DynamicModulesSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **dynamicModulesIdRelationshipsItemsGet**
```swift
    open class func dynamicModulesIdRelationshipsItemsGet(clientVersion: String, deviceType: DeviceType_dynamicModulesIdRelationshipsItemsGet, id: String, systemType: SystemType_dynamicModulesIdRelationshipsItemsGet, countryCode: String? = nil, include: [String]? = nil, locale: String? = nil, pageCursor: String? = nil, refreshSeed: String? = nil, replaceMedia: String? = nil) async throws -> DynamicModulesItemsMultiRelationshipDataDocument
```

Get items relationship (\"to-many\").

The module's items, in order — one stable collection per module, consistent for a given refreshSeed. Reads without a cursor return the first page (the slice a page shelf renders, sized for the module's previewLayout and device) with a continuation cursor; passing the cursor returns subsequent pages.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let clientVersion = "clientVersion_example" // String | Client version number
let deviceType = "deviceType_example" // String | The type of device making the request
let id = "id_example" // String | DynamicModules Id
let systemType = "systemType_example" // String | The system type of the device making the request
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: items (optional)
let locale = "locale_example" // String | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. (optional) (default to "en-US")
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let refreshSeed = "refreshSeed_example" // String | Stable seed used to keep dynamic page and module results consistent across a client session. (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: items (optional)

// Get items relationship (\"to-many\").
do {
    let response = try await DynamicModulesAPI.dynamicModulesIdRelationshipsItemsGet(clientVersion: clientVersion, deviceType: deviceType, id: id, systemType: systemType, countryCode: countryCode, include: include, locale: locale, pageCursor: pageCursor, refreshSeed: refreshSeed, replaceMedia: replaceMedia)
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
 **id** | **String** | DynamicModules Id | 
 **systemType** | **String** | The system type of the device making the request | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: items | [optional] 
 **locale** | **String** | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. | [optional] [default to &quot;en-US&quot;]
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **refreshSeed** | **String** | Stable seed used to keep dynamic page and module results consistent across a client session. | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: items | [optional] 

### Return type

[**DynamicModulesItemsMultiRelationshipDataDocument**](DynamicModulesItemsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **dynamicModulesIdRelationshipsSeedItemGet**
```swift
    open class func dynamicModulesIdRelationshipsSeedItemGet(clientVersion: String, deviceType: DeviceType_dynamicModulesIdRelationshipsSeedItemGet, id: String, systemType: SystemType_dynamicModulesIdRelationshipsSeedItemGet, countryCode: String? = nil, include: [String]? = nil, locale: String? = nil, refreshSeed: String? = nil, replaceMedia: String? = nil) async throws -> DynamicModulesSeedItemSingleRelationshipDataDocument
```

Get seedItem relationship (\"to-one\").

The item whose listen or add event seeded this module's collection (e.g. the album a BECAUSE_YOU_* module is based on); null for modules that are not seeded by an item.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let clientVersion = "clientVersion_example" // String | Client version number
let deviceType = "deviceType_example" // String | The type of device making the request
let id = "id_example" // String | DynamicModules Id
let systemType = "systemType_example" // String | The system type of the device making the request
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: seedItem (optional)
let locale = "locale_example" // String | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. (optional) (default to "en-US")
let refreshSeed = "refreshSeed_example" // String | Stable seed used to keep dynamic page and module results consistent across a client session. (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: seedItem (optional)

// Get seedItem relationship (\"to-one\").
do {
    let response = try await DynamicModulesAPI.dynamicModulesIdRelationshipsSeedItemGet(clientVersion: clientVersion, deviceType: deviceType, id: id, systemType: systemType, countryCode: countryCode, include: include, locale: locale, refreshSeed: refreshSeed, replaceMedia: replaceMedia)
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
 **id** | **String** | DynamicModules Id | 
 **systemType** | **String** | The system type of the device making the request | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: seedItem | [optional] 
 **locale** | **String** | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. | [optional] [default to &quot;en-US&quot;]
 **refreshSeed** | **String** | Stable seed used to keep dynamic page and module results consistent across a client session. | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: seedItem | [optional] 

### Return type

[**DynamicModulesSeedItemSingleRelationshipDataDocument**](DynamicModulesSeedItemSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

