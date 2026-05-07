# CommentsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**commentsGet**](CommentsAPI.md#commentsget) | **GET** /comments | Get multiple comments.
[**commentsIdDelete**](CommentsAPI.md#commentsiddelete) | **DELETE** /comments/{id} | Delete single comment.
[**commentsIdGet**](CommentsAPI.md#commentsidget) | **GET** /comments/{id} | Get single comment.
[**commentsIdPatch**](CommentsAPI.md#commentsidpatch) | **PATCH** /comments/{id} | Update single comment.
[**commentsIdRelationshipsOwnerProfilesGet**](CommentsAPI.md#commentsidrelationshipsownerprofilesget) | **GET** /comments/{id}/relationships/ownerProfiles | Get ownerProfiles relationship (\&quot;to-many\&quot;).
[**commentsIdRelationshipsOwnersGet**](CommentsAPI.md#commentsidrelationshipsownersget) | **GET** /comments/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
[**commentsIdRelationshipsParentCommentGet**](CommentsAPI.md#commentsidrelationshipsparentcommentget) | **GET** /comments/{id}/relationships/parentComment | Get parentComment relationship (\&quot;to-one\&quot;).
[**commentsPost**](CommentsAPI.md#commentspost) | **POST** /comments | Create single comment.


# **commentsGet**
```swift
    open class func commentsGet(pageCursor: String? = nil, sort: [Sort_commentsGet]? = nil, include: [String]? = nil, filterParentCommentId: [String]? = nil, filterSubjectId: [String]? = nil, filterSubjectType: [FilterSubjectType_commentsGet]? = nil, completion: @escaping (_ data: CommentsMultiResourceDataDocument?, _ error: Error?) -> Void)
```

Get multiple comments.

Retrieves multiple comments by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let sort = ["sort_example"] // [String] | Values prefixed with \"-\" are sorted descending; values without it are sorted ascending. (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: ownerProfiles, owners, parentComment (optional)
let filterParentCommentId = ["inner_example"] // [String] | Filter by parent comment ID to get replies (e.g. `550e8400-e29b-41d4-a716-446655440000`) (optional)
let filterSubjectId = ["inner_example"] // [String] | Filter by subject resource ID (e.g. `12345`) (optional)
let filterSubjectType = ["filterSubjectType_example"] // [String] | Filter by subject resource type (e.g. `albums`) (optional)

// Get multiple comments.
CommentsAPI.commentsGet(pageCursor: pageCursor, sort: sort, include: include, filterParentCommentId: filterParentCommentId, filterSubjectId: filterSubjectId, filterSubjectType: filterSubjectType) { (response, error) in
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
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: ownerProfiles, owners, parentComment | [optional] 
 **filterParentCommentId** | [**[String]**](String.md) | Filter by parent comment ID to get replies (e.g. &#x60;550e8400-e29b-41d4-a716-446655440000&#x60;) | [optional] 
 **filterSubjectId** | [**[String]**](String.md) | Filter by subject resource ID (e.g. &#x60;12345&#x60;) | [optional] 
 **filterSubjectType** | [**[String]**](String.md) | Filter by subject resource type (e.g. &#x60;albums&#x60;) | [optional] 

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
    open class func commentsIdDelete(id: String, idempotencyKey: String? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
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

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **commentsIdGet**
```swift
    open class func commentsIdGet(id: String, include: [String]? = nil, completion: @escaping (_ data: CommentsSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single comment.

Retrieves single comment by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Comment Id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: ownerProfiles, owners, parentComment (optional)

// Get single comment.
CommentsAPI.commentsIdGet(id: id, include: include) { (response, error) in
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
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: ownerProfiles, owners, parentComment | [optional] 

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
    open class func commentsIdPatch(id: String, idempotencyKey: String? = nil, commentsUpdateOperationPayload: CommentsUpdateOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
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

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **commentsIdRelationshipsOwnerProfilesGet**
```swift
    open class func commentsIdRelationshipsOwnerProfilesGet(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: CommentsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get ownerProfiles relationship (\"to-many\").

Retrieves ownerProfiles relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Comment Id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: ownerProfiles (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get ownerProfiles relationship (\"to-many\").
CommentsAPI.commentsIdRelationshipsOwnerProfilesGet(id: id, include: include, pageCursor: pageCursor) { (response, error) in
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
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: ownerProfiles | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**CommentsMultiRelationshipDataDocument**](CommentsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **commentsIdRelationshipsOwnersGet**
```swift
    open class func commentsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: CommentsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Comment Id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners (optional)
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
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**CommentsMultiRelationshipDataDocument**](CommentsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **commentsIdRelationshipsParentCommentGet**
```swift
    open class func commentsIdRelationshipsParentCommentGet(id: String, include: [String]? = nil, completion: @escaping (_ data: CommentsSingleRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get parentComment relationship (\"to-one\").

Retrieves parentComment relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Comment Id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: parentComment (optional)

// Get parentComment relationship (\"to-one\").
CommentsAPI.commentsIdRelationshipsParentCommentGet(id: id, include: include) { (response, error) in
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
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: parentComment | [optional] 

### Return type

[**CommentsSingleRelationshipDataDocument**](CommentsSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **commentsPost**
```swift
    open class func commentsPost(idempotencyKey: String? = nil, commentsCreateOperationPayload: CommentsCreateOperationPayload? = nil, completion: @escaping (_ data: CommentsSingleResourceDataDocument?, _ error: Error?) -> Void)
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

[**CommentsSingleResourceDataDocument**](CommentsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

