# UserDiscoveryMixesAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**userDiscoveryMixesIdGet**](UserDiscoveryMixesAPI.md#userdiscoverymixesidget) | **GET** /userDiscoveryMixes/{id} | Get single userDiscoveryMixe.
[**userDiscoveryMixesIdRelationshipsItemsGet**](UserDiscoveryMixesAPI.md#userdiscoverymixesidrelationshipsitemsget) | **GET** /userDiscoveryMixes/{id}/relationships/items | Get items relationship (\&quot;to-many\&quot;).


# **userDiscoveryMixesIdGet**
```swift
    open class func userDiscoveryMixesIdGet(id: String, include: [String]? = nil, includeLinkage: [IncludeLinkage_userDiscoveryMixesIdGet]? = nil, locale: String? = nil, replaceMedia: String? = nil) async throws -> UserDiscoveryMixesSingleResourceDataDocument
```

Get single userDiscoveryMixe.

Retrieves single userDiscoveryMixe by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User discovery mixes id. Use `me` for the authenticated user's resource
let include = ["inner_example"] // [String] | Include related resources. Available relationships: items (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let locale = "locale_example" // String | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. (optional) (default to "en-US")
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: items.items (optional)

// Get single userDiscoveryMixe.
do {
    let response = try await UserDiscoveryMixesAPI.userDiscoveryMixesIdGet(id: id, include: include, includeLinkage: includeLinkage, locale: locale, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | User discovery mixes id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: items | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **locale** | **String** | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. | [optional] [default to &quot;en-US&quot;]
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: items.items | [optional] 

### Return type

[**UserDiscoveryMixesSingleResourceDataDocument**](UserDiscoveryMixesSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userDiscoveryMixesIdRelationshipsItemsGet**
```swift
    open class func userDiscoveryMixesIdRelationshipsItemsGet(id: String, include: [String]? = nil, locale: String? = nil, pageCursor: String? = nil, replaceMedia: String? = nil) async throws -> UserDiscoveryMixesItemsMultiRelationshipDataDocument
```

Get items relationship (\"to-many\").

Retrieves items relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User discovery mixes id. Use `me` for the authenticated user's resource
let include = ["inner_example"] // [String] | Include related resources. Available relationships: items (optional)
let locale = "locale_example" // String | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. (optional) (default to "en-US")
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: items.items (optional)

// Get items relationship (\"to-many\").
do {
    let response = try await UserDiscoveryMixesAPI.userDiscoveryMixesIdRelationshipsItemsGet(id: id, include: include, locale: locale, pageCursor: pageCursor, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | User discovery mixes id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: items | [optional] 
 **locale** | **String** | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. | [optional] [default to &quot;en-US&quot;]
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: items.items | [optional] 

### Return type

[**UserDiscoveryMixesItemsMultiRelationshipDataDocument**](UserDiscoveryMixesItemsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

