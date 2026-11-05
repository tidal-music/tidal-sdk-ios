# ReactionsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**reactionsGet**](ReactionsAPI.md#reactionsget) | **GET** /reactions | Get multiple reactions.
[**reactionsIdDelete**](ReactionsAPI.md#reactionsiddelete) | **DELETE** /reactions/{id} | Delete single reaction.
[**reactionsIdRelationshipsAuthorGet**](ReactionsAPI.md#reactionsidrelationshipsauthorget) | **GET** /reactions/{id}/relationships/author | Get author relationship (\&quot;to-one\&quot;).
[**reactionsIdRelationshipsOwnersGet**](ReactionsAPI.md#reactionsidrelationshipsownersget) | **GET** /reactions/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
[**reactionsIdRelationshipsSubjectGet**](ReactionsAPI.md#reactionsidrelationshipssubjectget) | **GET** /reactions/{id}/relationships/subject | Get subject relationship (\&quot;to-one\&quot;).
[**reactionsPost**](ReactionsAPI.md#reactionspost) | **POST** /reactions | Create single reaction.


# **reactionsGet**
```swift
    open class func reactionsGet(filterSubject: String, filterEmoji: [String]? = nil, include: [String]? = nil, includeLinkage: [IncludeLinkage_reactionsGet]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil) async throws -> ReactionsMultiResourceDataDocument
```

Get multiple reactions.

Lists reactions on a subject. Comment subjects are not supported.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let filterSubject = "filterSubject_example" // String | The subject whose reactions to return.
let filterEmoji = ["inner_example"] // [String] | Filter by emoji (e.g. `👍`) (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: author, owners, subject (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: author.albums (optional)

// Get multiple reactions.
do {
    let response = try await ReactionsAPI.reactionsGet(filterSubject: filterSubject, filterEmoji: filterEmoji, include: include, includeLinkage: includeLinkage, pageCursor: pageCursor, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **filterSubject** | **String** | The subject whose reactions to return. | 
 **filterEmoji** | [**[String]**](String.md) | Filter by emoji (e.g. &#x60;👍&#x60;) | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: author, owners, subject | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: author.albums | [optional] 

### Return type

[**ReactionsMultiResourceDataDocument**](ReactionsMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **reactionsIdDelete**
```swift
    open class func reactionsIdDelete(id: String, idempotencyKey: String? = nil) async throws -> MutationResponseDocument
```

Delete single reaction.

Deletes existing reaction.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Reaction Id
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)

// Delete single reaction.
do {
    let response = try await ReactionsAPI.reactionsIdDelete(id: id, idempotencyKey: idempotencyKey)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Reaction Id | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 

### Return type

[**MutationResponseDocument**](MutationResponseDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **reactionsIdRelationshipsAuthorGet**
```swift
    open class func reactionsIdRelationshipsAuthorGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> ReactionsAuthorSingleRelationshipDataDocument
```

Get author relationship (\"to-one\").

The artist who left the reaction.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Reaction Id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: author (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: author.albums (optional)

// Get author relationship (\"to-one\").
do {
    let response = try await ReactionsAPI.reactionsIdRelationshipsAuthorGet(id: id, include: include, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Reaction Id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: author | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: author.albums | [optional] 

### Return type

[**ReactionsAuthorSingleRelationshipDataDocument**](ReactionsAuthorSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **reactionsIdRelationshipsOwnersGet**
```swift
    open class func reactionsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> ReactionsOwnersMultiRelationshipDataDocument
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Reaction Id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get owners relationship (\"to-many\").
do {
    let response = try await ReactionsAPI.reactionsIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Reaction Id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**ReactionsOwnersMultiRelationshipDataDocument**](ReactionsOwnersMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **reactionsIdRelationshipsSubjectGet**
```swift
    open class func reactionsIdRelationshipsSubjectGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> ReactionsSubjectSingleRelationshipDataDocument
```

Get subject relationship (\"to-one\").

Retrieves subject relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Reaction Id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: subject (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: subject.author.albums (optional)

// Get subject relationship (\"to-one\").
do {
    let response = try await ReactionsAPI.reactionsIdRelationshipsSubjectGet(id: id, include: include, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Reaction Id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: subject | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: subject.author.albums | [optional] 

### Return type

[**ReactionsSubjectSingleRelationshipDataDocument**](ReactionsSubjectSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **reactionsPost**
```swift
    open class func reactionsPost(idempotencyKey: String? = nil, reactionsCreateOperationPayload: ReactionsCreateOperationPayload? = nil) async throws -> ReactionsCreateSingleResourceDataDocument
```

Create single reaction.

Adds or replaces the caller's reaction on a subject. Each user has at most one reaction per subject. Comments accept only 👍. Replacing a reaction keeps its ID.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let reactionsCreateOperationPayload = ReactionsCreateOperation_Payload(data: ReactionsCreateOperation_Payload_Data(attributes: ReactionsCreateOperation_Payload_Data_Attributes(emoji: "emoji_example"), relationships: ReactionsCreateOperation_Payload_Data_Relationships(subject: ReactionsCreateOperation_Payload_Data_Relationships_Subject(data: ReactionsCreateOperation_Payload_Data_Relationships_Subject_Data(id: "id_example", type: "type_example"))), type: "type_example")) // ReactionsCreateOperationPayload |  (optional)

// Create single reaction.
do {
    let response = try await ReactionsAPI.reactionsPost(idempotencyKey: idempotencyKey, reactionsCreateOperationPayload: reactionsCreateOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **reactionsCreateOperationPayload** | [**ReactionsCreateOperationPayload**](ReactionsCreateOperationPayload.md) |  | [optional] 

### Return type

[**ReactionsCreateSingleResourceDataDocument**](ReactionsCreateSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

