# ViewerContextsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**viewerContextsGet**](ViewerContextsAPI.md#viewercontextsget) | **GET** /viewerContexts | Get multiple viewerContexts.
[**viewerContextsIdGet**](ViewerContextsAPI.md#viewercontextsidget) | **GET** /viewerContexts/{id} | Get single viewerContext.
[**viewerContextsIdRelationshipsCommentsGet**](ViewerContextsAPI.md#viewercontextsidrelationshipscommentsget) | **GET** /viewerContexts/{id}/relationships/comments | Get comments relationship (\&quot;to-many\&quot;).
[**viewerContextsIdRelationshipsReactionsGet**](ViewerContextsAPI.md#viewercontextsidrelationshipsreactionsget) | **GET** /viewerContexts/{id}/relationships/reactions | Get reactions relationship (\&quot;to-many\&quot;).
[**viewerContextsIdRelationshipsSubjectGet**](ViewerContextsAPI.md#viewercontextsidrelationshipssubjectget) | **GET** /viewerContexts/{id}/relationships/subject | Get subject relationship (\&quot;to-one\&quot;).
[**viewerContextsIdRelationshipsViewerGet**](ViewerContextsAPI.md#viewercontextsidrelationshipsviewerget) | **GET** /viewerContexts/{id}/relationships/viewer | Get viewer relationship (\&quot;to-one\&quot;).


# **viewerContextsGet**
```swift
    open class func viewerContextsGet(filterSubject: [String], include: [String]? = nil, includeLinkage: [IncludeLinkage_viewerContextsGet]? = nil, replaceMedia: String? = nil) async throws -> ViewerContextsMultiResourceDataDocument
```

Get multiple viewerContexts.

Returns viewer contexts for up to 20 original subjects. Duplicate subjects are returned once.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let filterSubject = ["inner_example"] // [String] | Original subjects to look up. Also accepts `folders:me`.
let include = ["inner_example"] // [String] | Include related resources. Available relationships: comments, reactions, subject, viewer (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: comments.author.albums (optional)

// Get multiple viewerContexts.
do {
    let response = try await ViewerContextsAPI.viewerContextsGet(filterSubject: filterSubject, include: include, includeLinkage: includeLinkage, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **filterSubject** | [**[String]**](String.md) | Original subjects to look up. Also accepts &#x60;folders:me&#x60;. | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: comments, reactions, subject, viewer | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: comments.author.albums | [optional] 

### Return type

[**ViewerContextsMultiResourceDataDocument**](ViewerContextsMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **viewerContextsIdGet**
```swift
    open class func viewerContextsIdGet(id: String, include: [String]? = nil, includeLinkage: [IncludeLinkage_viewerContextsIdGet]? = nil, replaceMedia: String? = nil) async throws -> ViewerContextsSingleResourceDataDocument
```

Get single viewerContext.

Retrieves single viewerContext by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Opaque identifier of one authenticated viewer and original subject pair
let include = ["inner_example"] // [String] | Include related resources. Available relationships: comments, reactions, subject, viewer (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: comments.author.albums (optional)

// Get single viewerContext.
do {
    let response = try await ViewerContextsAPI.viewerContextsIdGet(id: id, include: include, includeLinkage: includeLinkage, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Opaque identifier of one authenticated viewer and original subject pair | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: comments, reactions, subject, viewer | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: comments.author.albums | [optional] 

### Return type

[**ViewerContextsSingleResourceDataDocument**](ViewerContextsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **viewerContextsIdRelationshipsCommentsGet**
```swift
    open class func viewerContextsIdRelationshipsCommentsGet(id: String, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil) async throws -> ViewerContextsCommentsMultiRelationshipDataDocument
```

Get comments relationship (\"to-many\").

Returns the viewer's comments on the subject.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Opaque identifier of one authenticated viewer and original subject pair
let include = ["inner_example"] // [String] | Include related resources. Available relationships: comments (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: comments.author.albums (optional)

// Get comments relationship (\"to-many\").
do {
    let response = try await ViewerContextsAPI.viewerContextsIdRelationshipsCommentsGet(id: id, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Opaque identifier of one authenticated viewer and original subject pair | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: comments | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: comments.author.albums | [optional] 

### Return type

[**ViewerContextsCommentsMultiRelationshipDataDocument**](ViewerContextsCommentsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **viewerContextsIdRelationshipsReactionsGet**
```swift
    open class func viewerContextsIdRelationshipsReactionsGet(id: String, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil) async throws -> ViewerContextsReactionsMultiRelationshipDataDocument
```

Get reactions relationship (\"to-many\").

Returns the viewer's reactions on the subject.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Opaque identifier of one authenticated viewer and original subject pair
let include = ["inner_example"] // [String] | Include related resources. Available relationships: reactions (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: reactions.author.albums (optional)

// Get reactions relationship (\"to-many\").
do {
    let response = try await ViewerContextsAPI.viewerContextsIdRelationshipsReactionsGet(id: id, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Opaque identifier of one authenticated viewer and original subject pair | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: reactions | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: reactions.author.albums | [optional] 

### Return type

[**ViewerContextsReactionsMultiRelationshipDataDocument**](ViewerContextsReactionsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **viewerContextsIdRelationshipsSubjectGet**
```swift
    open class func viewerContextsIdRelationshipsSubjectGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> ViewerContextsSubjectSingleRelationshipDataDocument
```

Get subject relationship (\"to-one\").

Returns the subject of this viewer context.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Opaque identifier of one authenticated viewer and original subject pair
let include = ["inner_example"] // [String] | Include related resources. Available relationships: subject (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: subject (optional)

// Get subject relationship (\"to-one\").
do {
    let response = try await ViewerContextsAPI.viewerContextsIdRelationshipsSubjectGet(id: id, include: include, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Opaque identifier of one authenticated viewer and original subject pair | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: subject | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: subject | [optional] 

### Return type

[**ViewerContextsSubjectSingleRelationshipDataDocument**](ViewerContextsSubjectSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **viewerContextsIdRelationshipsViewerGet**
```swift
    open class func viewerContextsIdRelationshipsViewerGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> ViewerContextsViewerSingleRelationshipDataDocument
```

Get viewer relationship (\"to-one\").

Returns the authenticated viewer of this context.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Opaque identifier of one authenticated viewer and original subject pair
let include = ["inner_example"] // [String] | Include related resources. Available relationships: viewer (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: viewer.artist.albums (optional)

// Get viewer relationship (\"to-one\").
do {
    let response = try await ViewerContextsAPI.viewerContextsIdRelationshipsViewerGet(id: id, include: include, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Opaque identifier of one authenticated viewer and original subject pair | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: viewer | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: viewer.artist.albums | [optional] 

### Return type

[**ViewerContextsViewerSingleRelationshipDataDocument**](ViewerContextsViewerSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

