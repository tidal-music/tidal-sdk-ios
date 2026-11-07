# SharingSummariesAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**sharingSummariesGet**](SharingSummariesAPI.md#sharingsummariesget) | **GET** /sharingSummaries | Get multiple sharingSummaries.
[**sharingSummariesIdRelationshipsSubjectGet**](SharingSummariesAPI.md#sharingsummariesidrelationshipssubjectget) | **GET** /sharingSummaries/{id}/relationships/subject | Get subject relationship (\&quot;to-one\&quot;).


# **sharingSummariesGet**
```swift
    open class func sharingSummariesGet(filterSubject: [String], include: [String]? = nil, includeLinkage: [IncludeLinkage_sharingSummariesGet]? = nil, replaceMedia: String? = nil) async throws -> SharingSummariesMultiResourceDataDocument
```

Get multiple sharingSummaries.

Returns one current summary per distinct owned subject, for up to 20 subjects. Live subjects with no sharing return false flags. Missing or inaccessible subjects are omitted. IDs remain stable as sharing changes.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let filterSubject = ["inner_example"] // [String] | Filter by subject. Also accepts `folders:me`.
let include = ["inner_example"] // [String] | Include related resources. Available relationships: subject (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: subject (optional)

// Get multiple sharingSummaries.
do {
    let response = try await SharingSummariesAPI.sharingSummariesGet(filterSubject: filterSubject, include: include, includeLinkage: includeLinkage, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **filterSubject** | [**[String]**](String.md) | Filter by subject. Also accepts &#x60;folders:me&#x60;. | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: subject | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: subject | [optional] 

### Return type

[**SharingSummariesMultiResourceDataDocument**](SharingSummariesMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **sharingSummariesIdRelationshipsSubjectGet**
```swift
    open class func sharingSummariesIdRelationshipsSubjectGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> SharingSummariesSubjectSingleRelationshipDataDocument
```

Get subject relationship (\"to-one\").

Retrieves subject relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Opaque sharing summary ID
let include = ["inner_example"] // [String] | Include related resources. Available relationships: subject (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: subject (optional)

// Get subject relationship (\"to-one\").
do {
    let response = try await SharingSummariesAPI.sharingSummariesIdRelationshipsSubjectGet(id: id, include: include, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Opaque sharing summary ID | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: subject | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: subject | [optional] 

### Return type

[**SharingSummariesSubjectSingleRelationshipDataDocument**](SharingSummariesSubjectSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

