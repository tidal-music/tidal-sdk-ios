# CommentsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**commentsGet**](CommentsAPI.md#commentsget) | **GET** /comments | Get multiple comments.
[**commentsIdDelete**](CommentsAPI.md#commentsiddelete) | **DELETE** /comments/{id} | Delete single comment.
[**commentsIdGet**](CommentsAPI.md#commentsidget) | **GET** /comments/{id} | Get single comment.
[**commentsIdPatch**](CommentsAPI.md#commentsidpatch) | **PATCH** /comments/{id} | Update single comment.
[**commentsIdRelationshipsAuthorGet**](CommentsAPI.md#commentsidrelationshipsauthorget) | **GET** /comments/{id}/relationships/author | Get author relationship (\&quot;to-one\&quot;).
[**commentsIdRelationshipsCommentSummaryGet**](CommentsAPI.md#commentsidrelationshipscommentsummaryget) | **GET** /comments/{id}/relationships/commentSummary | Get commentSummary relationship (\&quot;to-one\&quot;).
[**commentsIdRelationshipsOwnersGet**](CommentsAPI.md#commentsidrelationshipsownersget) | **GET** /comments/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
[**commentsIdRelationshipsReactionSummaryGet**](CommentsAPI.md#commentsidrelationshipsreactionsummaryget) | **GET** /comments/{id}/relationships/reactionSummary | Get reactionSummary relationship (\&quot;to-one\&quot;).
[**commentsIdRelationshipsRootSubjectGet**](CommentsAPI.md#commentsidrelationshipsrootsubjectget) | **GET** /comments/{id}/relationships/rootSubject | Get rootSubject relationship (\&quot;to-one\&quot;).
[**commentsIdRelationshipsSubjectGet**](CommentsAPI.md#commentsidrelationshipssubjectget) | **GET** /comments/{id}/relationships/subject | Get subject relationship (\&quot;to-one\&quot;).
[**commentsPost**](CommentsAPI.md#commentspost) | **POST** /comments | Create single comment.


# **commentsGet**
```swift
    open class func commentsGet(filterSubject: String, include: [String]? = nil, includeLinkage: [IncludeLinkage_commentsGet]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil, sort: [Sort_commentsGet]? = nil) async throws -> CommentsMultiResourceDataDocument
```

Get multiple comments.

Returns root comments on a resource, or replies to a comment. Root comments support createdAt in either direction, newest first by default. Replies require sort=createdAt (oldest first); other sort values return 400.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let filterSubject = "filterSubject_example" // String | The immediate subject whose comments to return.
let include = ["inner_example"] // [String] | Include related resources. Available relationships: author, commentSummary, owners, reactionSummary, rootSubject, subject (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: author.albums (optional)
let sort = ["sort_example"] // [String] | Values prefixed with \"-\" are sorted descending; values without it are sorted ascending. (optional)

// Get multiple comments.
do {
    let response = try await CommentsAPI.commentsGet(filterSubject: filterSubject, include: include, includeLinkage: includeLinkage, pageCursor: pageCursor, replaceMedia: replaceMedia, sort: sort)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **filterSubject** | **String** | The immediate subject whose comments to return. | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: author, commentSummary, owners, reactionSummary, rootSubject, subject | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: author.albums | [optional] 
 **sort** | [**[String]**](String.md) | Values prefixed with \&quot;-\&quot; are sorted descending; values without it are sorted ascending. | [optional] 

### Return type

[**CommentsMultiResourceDataDocument**](CommentsMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **commentsIdDelete**
```swift
    open class func commentsIdDelete(id: String, idempotencyKey: String? = nil) async throws -> MutationResponseDocument
```

Delete single comment.

Deletes existing comment.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Comment Id
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)

// Delete single comment.
do {
    let response = try await CommentsAPI.commentsIdDelete(id: id, idempotencyKey: idempotencyKey)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Comment Id | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 

### Return type

[**MutationResponseDocument**](MutationResponseDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **commentsIdGet**
```swift
    open class func commentsIdGet(id: String, include: [String]? = nil, includeLinkage: [IncludeLinkage_commentsIdGet]? = nil, replaceMedia: String? = nil) async throws -> CommentsSingleResourceDataDocument
```

Get single comment.

Retrieves single comment by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Comment Id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: author, commentSummary, owners, reactionSummary, rootSubject, subject (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: author.albums (optional)

// Get single comment.
do {
    let response = try await CommentsAPI.commentsIdGet(id: id, include: include, includeLinkage: includeLinkage, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Comment Id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: author, commentSummary, owners, reactionSummary, rootSubject, subject | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: author.albums | [optional] 

### Return type

[**CommentsSingleResourceDataDocument**](CommentsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **commentsIdPatch**
```swift
    open class func commentsIdPatch(id: String, idempotencyKey: String? = nil, commentsUpdateOperationPayload: CommentsUpdateOperationPayload? = nil) async throws -> MutationResponseDocument
```

Update single comment.

Updates existing comment.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Comment Id
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let commentsUpdateOperationPayload = CommentsUpdateOperation_Payload(data: CommentsUpdateOperation_Payload_Data(attributes: CommentsUpdateOperation_Payload_Data_Attributes(endTime: "endTime_example", message: "message_example", startTime: "startTime_example"), id: "id_example", type: "type_example")) // CommentsUpdateOperationPayload |  (optional)

// Update single comment.
do {
    let response = try await CommentsAPI.commentsIdPatch(id: id, idempotencyKey: idempotencyKey, commentsUpdateOperationPayload: commentsUpdateOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Comment Id | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **commentsUpdateOperationPayload** | [**CommentsUpdateOperationPayload**](CommentsUpdateOperationPayload.md) |  | [optional] 

### Return type

[**MutationResponseDocument**](MutationResponseDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **commentsIdRelationshipsAuthorGet**
```swift
    open class func commentsIdRelationshipsAuthorGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> CommentsAuthorSingleRelationshipDataDocument
```

Get author relationship (\"to-one\").

The artist who wrote the comment.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Comment Id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: author (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: author.albums (optional)

// Get author relationship (\"to-one\").
do {
    let response = try await CommentsAPI.commentsIdRelationshipsAuthorGet(id: id, include: include, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Comment Id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: author | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: author.albums | [optional] 

### Return type

[**CommentsAuthorSingleRelationshipDataDocument**](CommentsAuthorSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **commentsIdRelationshipsCommentSummaryGet**
```swift
    open class func commentsIdRelationshipsCommentSummaryGet(id: String, include: [String]? = nil) async throws -> CommentsCommentSummarySingleRelationshipDataDocument
```

Get commentSummary relationship (\"to-one\").

Retrieves commentSummary relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Comment Id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: commentSummary (optional)

// Get commentSummary relationship (\"to-one\").
do {
    let response = try await CommentsAPI.commentsIdRelationshipsCommentSummaryGet(id: id, include: include)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Comment Id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: commentSummary | [optional] 

### Return type

[**CommentsCommentSummarySingleRelationshipDataDocument**](CommentsCommentSummarySingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **commentsIdRelationshipsOwnersGet**
```swift
    open class func commentsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> CommentsOwnersMultiRelationshipDataDocument
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Comment Id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get owners relationship (\"to-many\").
do {
    let response = try await CommentsAPI.commentsIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Comment Id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**CommentsOwnersMultiRelationshipDataDocument**](CommentsOwnersMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **commentsIdRelationshipsReactionSummaryGet**
```swift
    open class func commentsIdRelationshipsReactionSummaryGet(id: String, include: [String]? = nil) async throws -> CommentsReactionSummarySingleRelationshipDataDocument
```

Get reactionSummary relationship (\"to-one\").

Retrieves reactionSummary relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Comment Id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: reactionSummary (optional)

// Get reactionSummary relationship (\"to-one\").
do {
    let response = try await CommentsAPI.commentsIdRelationshipsReactionSummaryGet(id: id, include: include)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Comment Id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: reactionSummary | [optional] 

### Return type

[**CommentsReactionSummarySingleRelationshipDataDocument**](CommentsReactionSummarySingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **commentsIdRelationshipsRootSubjectGet**
```swift
    open class func commentsIdRelationshipsRootSubjectGet(id: String, include: [String]? = nil) async throws -> CommentsRootSubjectSingleRelationshipDataDocument
```

Get rootSubject relationship (\"to-one\").

Retrieves rootSubject relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Comment Id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: rootSubject (optional)

// Get rootSubject relationship (\"to-one\").
do {
    let response = try await CommentsAPI.commentsIdRelationshipsRootSubjectGet(id: id, include: include)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Comment Id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: rootSubject | [optional] 

### Return type

[**CommentsRootSubjectSingleRelationshipDataDocument**](CommentsRootSubjectSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **commentsIdRelationshipsSubjectGet**
```swift
    open class func commentsIdRelationshipsSubjectGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> CommentsSubjectSingleRelationshipDataDocument
```

Get subject relationship (\"to-one\").

Retrieves subject relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Comment Id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: subject (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: subject.author.albums (optional)

// Get subject relationship (\"to-one\").
do {
    let response = try await CommentsAPI.commentsIdRelationshipsSubjectGet(id: id, include: include, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Comment Id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: subject | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: subject.author.albums | [optional] 

### Return type

[**CommentsSubjectSingleRelationshipDataDocument**](CommentsSubjectSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **commentsPost**
```swift
    open class func commentsPost(idempotencyKey: String? = nil, commentsCreateOperationPayload: CommentsCreateOperationPayload? = nil) async throws -> CommentsCreateSingleResourceDataDocument
```

Create single comment.

Creates a root comment on a resource or a reply whose subject is a root comment. Replies to replies are rejected.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let commentsCreateOperationPayload = CommentsCreateOperation_Payload(data: CommentsCreateOperation_Payload_Data(attributes: CommentsCreateOperation_Payload_Data_Attributes(endTime: "endTime_example", message: "message_example", startTime: "startTime_example"), relationships: CommentsCreateOperation_Payload_Data_Relationships(subject: CommentsCreateOperation_Payload_Data_Relationships_Subject(data: CommentsCreateOperation_Payload_Data_Relationships_Subject_Data(id: "id_example", type: "type_example"))), type: "type_example")) // CommentsCreateOperationPayload |  (optional)

// Create single comment.
do {
    let response = try await CommentsAPI.commentsPost(idempotencyKey: idempotencyKey, commentsCreateOperationPayload: commentsCreateOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **commentsCreateOperationPayload** | [**CommentsCreateOperationPayload**](CommentsCreateOperationPayload.md) |  | [optional] 

### Return type

[**CommentsCreateSingleResourceDataDocument**](CommentsCreateSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

