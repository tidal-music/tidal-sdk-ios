# CommentsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**commentsGet**](CommentsAPI.md#commentsget) | **GET** /comments | Get multiple comments.
[**commentsIdDelete**](CommentsAPI.md#commentsiddelete) | **DELETE** /comments/{id} | Delete single comment.
[**commentsIdGet**](CommentsAPI.md#commentsidget) | **GET** /comments/{id} | Get single comment.
[**commentsIdPatch**](CommentsAPI.md#commentsidpatch) | **PATCH** /comments/{id} | Update single comment.
[**commentsIdRelationshipsAuthorGet**](CommentsAPI.md#commentsidrelationshipsauthorget) | **GET** /comments/{id}/relationships/author | Get author relationship (\&quot;to-one\&quot;).
[**commentsIdRelationshipsOwnersGet**](CommentsAPI.md#commentsidrelationshipsownersget) | **GET** /comments/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
[**commentsIdRelationshipsParentCommentGet**](CommentsAPI.md#commentsidrelationshipsparentcommentget) | **GET** /comments/{id}/relationships/parentComment | Get parentComment relationship (\&quot;to-one\&quot;).
[**commentsPost**](CommentsAPI.md#commentspost) | **POST** /comments | Create single comment.


# **commentsGet**
```swift
    open class func commentsGet(pageCursor: String? = nil, sort: [Sort_commentsGet]? = nil, include: [String]? = nil, filterParentCommentId: [String]? = nil, filterSubject: String? = nil, filterSubjectId: [String]? = nil, filterSubjectType: [FilterSubjectType_commentsGet]? = nil, includeLinkage: [IncludeLinkage_commentsGet]? = nil, replaceMedia: String? = nil, completion: @escaping (_ data: CommentsMultiResourceDataDocument?, _ error: Error?) -> Void)
```

Get multiple comments.

Retrieves multiple comments by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let sort = ["sort_example"] // [String] | Values prefixed with \"-\" are sorted descending; values without it are sorted ascending. (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: author, owners, parentComment (optional)
let filterParentCommentId = ["inner_example"] // [String] | Filter by parent comment ID to get replies (e.g. `550e8400-e29b-41d4-a716-446655440000`) (optional)
let filterSubject = "filterSubject_example" // String | The subject whose comments to return. Use either subject or the deprecated subject.id and subject.type pair. (optional)
let filterSubjectId = ["inner_example"] // [String] | Deprecated: use filter[subject]. Filter by subject resource ID (e.g. `12345`) (optional)
let filterSubjectType = ["filterSubjectType_example"] // [String] | Deprecated: use filter[subject]. Filter by subject resource type (e.g. `albums`) (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: author.albums (optional)

// Get multiple comments.
CommentsAPI.commentsGet(pageCursor: pageCursor, sort: sort, include: include, filterParentCommentId: filterParentCommentId, filterSubject: filterSubject, filterSubjectId: filterSubjectId, filterSubjectType: filterSubjectType, includeLinkage: includeLinkage, replaceMedia: replaceMedia) { (response, error) in
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
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **sort** | [**[String]**](String.md) | Values prefixed with \&quot;-\&quot; are sorted descending; values without it are sorted ascending. | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: author, owners, parentComment | [optional] 
 **filterParentCommentId** | [**[String]**](String.md) | Filter by parent comment ID to get replies (e.g. &#x60;550e8400-e29b-41d4-a716-446655440000&#x60;) | [optional] 
 **filterSubject** | **String** | The subject whose comments to return. Use either subject or the deprecated subject.id and subject.type pair. | [optional] 
 **filterSubjectId** | [**[String]**](String.md) | Deprecated: use filter[subject]. Filter by subject resource ID (e.g. &#x60;12345&#x60;) | [optional] 
 **filterSubjectType** | [**[String]**](String.md) | Deprecated: use filter[subject]. Filter by subject resource type (e.g. &#x60;albums&#x60;) | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: author.albums | [optional] 

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
    open class func commentsIdDelete(id: String, idempotencyKey: String? = nil, completion: @escaping (_ data: MutationResponseDocument?, _ error: Error?) -> Void)
```

Delete single comment.

Deletes existing comment.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Comment Id
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. (optional)

// Delete single comment.
CommentsAPI.commentsIdDelete(id: id, idempotencyKey: idempotencyKey) { (response, error) in
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
 **id** | **String** | Comment Id | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. | [optional] 

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
    open class func commentsIdGet(id: String, include: [String]? = nil, includeLinkage: [IncludeLinkage_commentsIdGet]? = nil, replaceMedia: String? = nil, completion: @escaping (_ data: CommentsSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single comment.

Retrieves single comment by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Comment Id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: author, owners, parentComment (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: author.albums (optional)

// Get single comment.
CommentsAPI.commentsIdGet(id: id, include: include, includeLinkage: includeLinkage, replaceMedia: replaceMedia) { (response, error) in
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
 **id** | **String** | Comment Id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: author, owners, parentComment | [optional] 
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
    open class func commentsIdPatch(id: String, idempotencyKey: String? = nil, commentsUpdateOperationPayload: CommentsUpdateOperationPayload? = nil, completion: @escaping (_ data: MutationResponseDocument?, _ error: Error?) -> Void)
```

Update single comment.

Updates existing comment.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Comment Id
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. (optional)
let commentsUpdateOperationPayload = CommentsUpdateOperation_Payload(data: CommentsUpdateOperation_Payload_Data(attributes: CommentsUpdateOperation_Payload_Data_Attributes(endTime: "endTime_example", message: "message_example", startTime: "startTime_example"), id: "id_example", type: "type_example")) // CommentsUpdateOperationPayload |  (optional)

// Update single comment.
CommentsAPI.commentsIdPatch(id: id, idempotencyKey: idempotencyKey, commentsUpdateOperationPayload: commentsUpdateOperationPayload) { (response, error) in
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
 **id** | **String** | Comment Id | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. | [optional] 
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
    open class func commentsIdRelationshipsAuthorGet(id: String, include: [String]? = nil, replaceMedia: String? = nil, completion: @escaping (_ data: CommentsAuthorSingleRelationshipDataDocument?, _ error: Error?) -> Void)
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
CommentsAPI.commentsIdRelationshipsAuthorGet(id: id, include: include, replaceMedia: replaceMedia) { (response, error) in
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

# **commentsIdRelationshipsOwnersGet**
```swift
    open class func commentsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: CommentsOwnersMultiRelationshipDataDocument?, _ error: Error?) -> Void)
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
CommentsAPI.commentsIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor) { (response, error) in
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

# **commentsIdRelationshipsParentCommentGet**
```swift
    open class func commentsIdRelationshipsParentCommentGet(id: String, include: [String]? = nil, replaceMedia: String? = nil, completion: @escaping (_ data: CommentsParentCommentSingleRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get parentComment relationship (\"to-one\").

Retrieves parentComment relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Comment Id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: parentComment (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: parentComment.author.albums (optional)

// Get parentComment relationship (\"to-one\").
CommentsAPI.commentsIdRelationshipsParentCommentGet(id: id, include: include, replaceMedia: replaceMedia) { (response, error) in
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
 **id** | **String** | Comment Id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: parentComment | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: parentComment.author.albums | [optional] 

### Return type

[**CommentsParentCommentSingleRelationshipDataDocument**](CommentsParentCommentSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **commentsPost**
```swift
    open class func commentsPost(idempotencyKey: String? = nil, commentsCreateOperationPayload: CommentsCreateOperationPayload? = nil, completion: @escaping (_ data: CommentsCreateSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Create single comment.

Creates a new comment.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. (optional)
let commentsCreateOperationPayload = CommentsCreateOperation_Payload(data: CommentsCreateOperation_Payload_Data(attributes: CommentsCreateOperation_Payload_Data_Attributes(endTime: "endTime_example", message: "message_example", startTime: "startTime_example"), relationships: CommentsCreateOperation_Payload_Data_Relationships(parentComment: CommentsCreateOperation_Payload_Data_Relationships_ParentComment(data: CommentsCreateOperation_Payload_Data_Relationships_ParentComment_Data(id: "id_example", type: "type_example")), subject: CommentsCreateOperation_Payload_Data_Relationships_Subject(data: CommentsCreateOperation_Payload_Data_Relationships_Subject_Data(id: "id_example", type: "type_example"))), type: "type_example")) // CommentsCreateOperationPayload |  (optional)

// Create single comment.
CommentsAPI.commentsPost(idempotencyKey: idempotencyKey, commentsCreateOperationPayload: commentsCreateOperationPayload) { (response, error) in
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
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. | [optional] 
 **commentsCreateOperationPayload** | [**CommentsCreateOperationPayload**](CommentsCreateOperationPayload.md) |  | [optional] 

### Return type

[**CommentsCreateSingleResourceDataDocument**](CommentsCreateSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

