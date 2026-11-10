# CommentSummariesAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**commentSummariesGet**](CommentSummariesAPI.md#commentsummariesget) | **GET** /commentSummaries | Get multiple commentSummaries.
[**commentSummariesIdRelationshipsSubjectGet**](CommentSummariesAPI.md#commentsummariesidrelationshipssubjectget) | **GET** /commentSummaries/{id}/relationships/subject | Get subject relationship (\&quot;to-one\&quot;).


# **commentSummariesGet**
```swift
    open class func commentSummariesGet(filterSubject: [String], countryCode: String? = nil, include: [String]? = nil, includeLinkage: [IncludeLinkage_commentSummariesGet]? = nil, replaceMedia: String? = nil, shareCode: String? = nil) async throws -> CommentSummariesMultiResourceDataDocument
```

Get multiple commentSummaries.

Returns one current summary per accessible subject, for up to 20 subjects. Duplicates are returned once. Inaccessible or missing subjects are omitted. Empty supported subjects still have a summary. IDs remain stable as counts change. Counts include root comments on source files and direct replies on comments.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let filterSubject = ["inner_example"] // [String] | Subjects whose counts to return.
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: subject (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: subject.author.albums (optional)
let shareCode = "shareCode_example" // String | Share code used as a bearer credential for the resource. (optional)

// Get multiple commentSummaries.
do {
    let response = try await CommentSummariesAPI.commentSummariesGet(filterSubject: filterSubject, countryCode: countryCode, include: include, includeLinkage: includeLinkage, replaceMedia: replaceMedia, shareCode: shareCode)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **filterSubject** | [**[String]**](String.md) | Subjects whose counts to return. | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: subject | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: subject.author.albums | [optional] 
 **shareCode** | **String** | Share code used as a bearer credential for the resource. | [optional] 

### Return type

[**CommentSummariesMultiResourceDataDocument**](CommentSummariesMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **commentSummariesIdRelationshipsSubjectGet**
```swift
    open class func commentSummariesIdRelationshipsSubjectGet(id: String, include: [String]? = nil, replaceMedia: String? = nil, shareCode: String? = nil) async throws -> CommentSummariesSubjectSingleRelationshipDataDocument
```

Get subject relationship (\"to-one\").

Retrieves subject relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Opaque identifier of one subject's current summary
let include = ["inner_example"] // [String] | Include related resources. Available relationships: subject (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: subject.author.albums (optional)
let shareCode = "shareCode_example" // String | Share code used as a bearer credential for the resource. (optional)

// Get subject relationship (\"to-one\").
do {
    let response = try await CommentSummariesAPI.commentSummariesIdRelationshipsSubjectGet(id: id, include: include, replaceMedia: replaceMedia, shareCode: shareCode)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Opaque identifier of one subject&#39;s current summary | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: subject | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: subject.author.albums | [optional] 
 **shareCode** | **String** | Share code used as a bearer credential for the resource. | [optional] 

### Return type

[**CommentSummariesSubjectSingleRelationshipDataDocument**](CommentSummariesSubjectSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

