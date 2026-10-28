# ResourceSharingSettingsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**resourceSharingSettingsGet**](ResourceSharingSettingsAPI.md#resourcesharingsettingsget) | **GET** /resourceSharingSettings | Get multiple resourceSharingSettings.
[**resourceSharingSettingsIdGet**](ResourceSharingSettingsAPI.md#resourcesharingsettingsidget) | **GET** /resourceSharingSettings/{id} | Get single resourceSharingSetting.
[**resourceSharingSettingsIdRelationshipsGrantsGet**](ResourceSharingSettingsAPI.md#resourcesharingsettingsidrelationshipsgrantsget) | **GET** /resourceSharingSettings/{id}/relationships/grants | Get grants relationship (\&quot;to-many\&quot;).
[**resourceSharingSettingsIdRelationshipsSharesGet**](ResourceSharingSettingsAPI.md#resourcesharingsettingsidrelationshipssharesget) | **GET** /resourceSharingSettings/{id}/relationships/shares | Get shares relationship (\&quot;to-many\&quot;).
[**resourceSharingSettingsIdRelationshipsSubjectGet**](ResourceSharingSettingsAPI.md#resourcesharingsettingsidrelationshipssubjectget) | **GET** /resourceSharingSettings/{id}/relationships/subject | Get subject relationship (\&quot;to-one\&quot;).


# **resourceSharingSettingsGet**
```swift
    open class func resourceSharingSettingsGet(filterSubject: [String], include: [String]? = nil, includeLinkage: [IncludeLinkage_resourceSharingSettingsGet]? = nil, replaceMedia: String? = nil) async throws -> ResourceSharingSettingsMultiResourceDataDocument
```

Get multiple resourceSharingSettings.

Returns the sharing settings of up to 20 live access-core subjects. Subjects without a node, or that the caller does not own, return none.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let filterSubject = ["inner_example"] // [String] | Filter by subject. Also accepts `folders:me`.
let include = ["inner_example"] // [String] | Include related resources. Available relationships: grants, shares, subject (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: grants.subject (optional)

// Get multiple resourceSharingSettings.
do {
    let response = try await ResourceSharingSettingsAPI.resourceSharingSettingsGet(filterSubject: filterSubject, include: include, includeLinkage: includeLinkage, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **filterSubject** | [**[String]**](String.md) | Filter by subject. Also accepts &#x60;folders:me&#x60;. | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: grants, shares, subject | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: grants.subject | [optional] 

### Return type

[**ResourceSharingSettingsMultiResourceDataDocument**](ResourceSharingSettingsMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **resourceSharingSettingsIdGet**
```swift
    open class func resourceSharingSettingsIdGet(id: String, include: [String]? = nil, includeLinkage: [IncludeLinkage_resourceSharingSettingsIdGet]? = nil, replaceMedia: String? = nil) async throws -> ResourceSharingSettingsSingleResourceDataDocument
```

Get single resourceSharingSetting.

Retrieves single resourceSharingSetting by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Opaque resource sharing settings ID
let include = ["inner_example"] // [String] | Include related resources. Available relationships: grants, shares, subject (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: grants.subject (optional)

// Get single resourceSharingSetting.
do {
    let response = try await ResourceSharingSettingsAPI.resourceSharingSettingsIdGet(id: id, include: include, includeLinkage: includeLinkage, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Opaque resource sharing settings ID | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: grants, shares, subject | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: grants.subject | [optional] 

### Return type

[**ResourceSharingSettingsSingleResourceDataDocument**](ResourceSharingSettingsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **resourceSharingSettingsIdRelationshipsGrantsGet**
```swift
    open class func resourceSharingSettingsIdRelationshipsGrantsGet(id: String, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil) async throws -> ResourceSharingSettingsGrantsMultiRelationshipDataDocument
```

Get grants relationship (\"to-many\").

Each grantee's strongest grant on the subject or a folder or album above it: the strongest role, then the nearest grant, then a direct grant over a saved link's, then the oldest. The owner comes first, then groups, then users. A grant's subject is the node it is on.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Opaque resource sharing settings ID
let include = ["inner_example"] // [String] | Include related resources. Available relationships: grants (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: grants.subject (optional)

// Get grants relationship (\"to-many\").
do {
    let response = try await ResourceSharingSettingsAPI.resourceSharingSettingsIdRelationshipsGrantsGet(id: id, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Opaque resource sharing settings ID | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: grants | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: grants.subject | [optional] 

### Return type

[**ResourceSharingSettingsGrantsMultiRelationshipDataDocument**](ResourceSharingSettingsGrantsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **resourceSharingSettingsIdRelationshipsSharesGet**
```swift
    open class func resourceSharingSettingsIdRelationshipsSharesGet(id: String, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil) async throws -> ResourceSharingSettingsSharesMultiRelationshipDataDocument
```

Get shares relationship (\"to-many\").

The active share links on the subject or an album above it, or a folder above it whose link can be saved, next to expire first.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Opaque resource sharing settings ID
let include = ["inner_example"] // [String] | Include related resources. Available relationships: shares (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: shares.sharedResources (optional)

// Get shares relationship (\"to-many\").
do {
    let response = try await ResourceSharingSettingsAPI.resourceSharingSettingsIdRelationshipsSharesGet(id: id, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Opaque resource sharing settings ID | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: shares | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: shares.sharedResources | [optional] 

### Return type

[**ResourceSharingSettingsSharesMultiRelationshipDataDocument**](ResourceSharingSettingsSharesMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **resourceSharingSettingsIdRelationshipsSubjectGet**
```swift
    open class func resourceSharingSettingsIdRelationshipsSubjectGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> ResourceSharingSettingsSubjectSingleRelationshipDataDocument
```

Get subject relationship (\"to-one\").

Retrieves subject relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Opaque resource sharing settings ID
let include = ["inner_example"] // [String] | Include related resources. Available relationships: subject (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: subject (optional)

// Get subject relationship (\"to-one\").
do {
    let response = try await ResourceSharingSettingsAPI.resourceSharingSettingsIdRelationshipsSubjectGet(id: id, include: include, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Opaque resource sharing settings ID | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: subject | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: subject | [optional] 

### Return type

[**ResourceSharingSettingsSubjectSingleRelationshipDataDocument**](ResourceSharingSettingsSubjectSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

