# DynamicModulesAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**dynamicModulesGet**](DynamicModulesAPI.md#dynamicmodulesget) | **GET** /dynamicModules | Get multiple dynamicModules.
[**dynamicModulesIdRelationshipsItemsGet**](DynamicModulesAPI.md#dynamicmodulesidrelationshipsitemsget) | **GET** /dynamicModules/{id}/relationships/items | Get items relationship (\&quot;to-many\&quot;).


# **dynamicModulesGet**
```swift
    open class func dynamicModulesGet(deviceType: DeviceType_dynamicModulesGet, systemType: SystemType_dynamicModulesGet, clientVersion: String, refreshId: String? = nil, countryCode: String? = nil, locale: String? = nil, include: [String]? = nil, filterId: [String]? = nil, completion: @escaping (_ data: DynamicModulesMultiResourceDataDocument?, _ error: Error?) -> Void)
```

Get multiple dynamicModules.

Retrieves multiple dynamicModules by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let deviceType = "deviceType_example" // String | The type of device making the request
let systemType = "systemType_example" // String | The system type of the device making the request
let clientVersion = "clientVersion_example" // String | Client version number
let refreshId = "refreshId_example" // String |  (optional)
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let locale = "locale_example" // String | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. (optional) (default to "en-US")
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: items (optional)
let filterId = ["inner_example"] // [String] | DynamicModules Id (e.g. `nejMcAhh5N8S3EQ4LaqysVdI0cZZ`) (optional)

// Get multiple dynamicModules.
DynamicModulesAPI.dynamicModulesGet(deviceType: deviceType, systemType: systemType, clientVersion: clientVersion, refreshId: refreshId, countryCode: countryCode, locale: locale, include: include, filterId: filterId) { (response, error) in
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
 **refreshId** | **String** |  | [optional] 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **locale** | **String** | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. | [optional] [default to &quot;en-US&quot;]
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: items | [optional] 
 **filterId** | [**[String]**](String.md) | DynamicModules Id (e.g. &#x60;nejMcAhh5N8S3EQ4LaqysVdI0cZZ&#x60;) | [optional] 

### Return type

[**DynamicModulesMultiResourceDataDocument**](DynamicModulesMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **dynamicModulesIdRelationshipsItemsGet**
```swift
    open class func dynamicModulesIdRelationshipsItemsGet(id: String, deviceType: DeviceType_dynamicModulesIdRelationshipsItemsGet, systemType: SystemType_dynamicModulesIdRelationshipsItemsGet, clientVersion: String, refreshId: Int64? = nil, pageCursor: String? = nil, countryCode: String? = nil, locale: String? = nil, include: [String]? = nil, completion: @escaping (_ data: DynamicModulesMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get items relationship (\"to-many\").

Retrieves items relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | DynamicModules Id
let deviceType = "deviceType_example" // String | The type of device making the request
let systemType = "systemType_example" // String | The system type of the device making the request
let clientVersion = "clientVersion_example" // String | Client version number
let refreshId = 987 // Int64 |  (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let locale = "locale_example" // String | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. (optional) (default to "en-US")
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: items (optional)

// Get items relationship (\"to-many\").
DynamicModulesAPI.dynamicModulesIdRelationshipsItemsGet(id: id, deviceType: deviceType, systemType: systemType, clientVersion: clientVersion, refreshId: refreshId, pageCursor: pageCursor, countryCode: countryCode, locale: locale, include: include) { (response, error) in
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
 **id** | **String** | DynamicModules Id | 
 **deviceType** | **String** | The type of device making the request | 
 **systemType** | **String** | The system type of the device making the request | 
 **clientVersion** | **String** | Client version number | 
 **refreshId** | **Int64** |  | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **locale** | **String** | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. | [optional] [default to &quot;en-US&quot;]
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: items | [optional] 

### Return type

[**DynamicModulesMultiRelationshipDataDocument**](DynamicModulesMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

