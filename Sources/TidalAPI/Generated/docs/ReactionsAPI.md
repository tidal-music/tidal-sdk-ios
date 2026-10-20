# ReactionsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**reactionsGet**](ReactionsAPI.md#reactionsget) | **GET** /reactions | Get multiple reactions.
[**reactionsIdDelete**](ReactionsAPI.md#reactionsiddelete) | **DELETE** /reactions/{id} | Delete single reaction.
[**reactionsIdRelationshipsAuthorGet**](ReactionsAPI.md#reactionsidrelationshipsauthorget) | **GET** /reactions/{id}/relationships/author | Get author relationship (\&quot;to-one\&quot;).
[**reactionsIdRelationshipsOwnerProfilesGet**](ReactionsAPI.md#reactionsidrelationshipsownerprofilesget) | **GET** /reactions/{id}/relationships/ownerProfiles | Get ownerProfiles relationship (\&quot;to-many\&quot;).
[**reactionsIdRelationshipsOwnersGet**](ReactionsAPI.md#reactionsidrelationshipsownersget) | **GET** /reactions/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
[**reactionsPost**](ReactionsAPI.md#reactionspost) | **POST** /reactions | Create single reaction.


# **reactionsGet**
```swift
    open class func reactionsGet(filterEmoji: [String]? = nil, filterSubjectId: [String]? = nil, filterSubjectType: [FilterSubjectType_reactionsGet]? = nil, filterSubject: String? = nil, include: [String]? = nil, includeLinkage: [IncludeLinkage_reactionsGet]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil, stats: Stats_reactionsGet? = nil, statsOnly: Bool? = nil, viewerContext: String? = nil) async throws -> ReactionsMultiResourceDataDocument
```

Get multiple reactions.

Retrieves multiple reactions by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let filterEmoji = ["inner_example"] // [String] | Filter by emoji (e.g. `👍`) (optional)
let filterSubjectId = ["inner_example"] // [String] | Deprecated: use filter[subject]. Filter by subject resource ID (e.g. `12345`) (optional)
let filterSubjectType = ["filterSubjectType_example"] // [String] | Deprecated: use filter[subject]. Filter by subject resource type (e.g. `albums`) (optional)
let filterSubject = "filterSubject_example" // String | The subject whose reactions to return. Use either subject or the deprecated subject.id and subject.type pair. (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: author, ownerProfiles, owners (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: author.albums (optional)
let stats = "stats_example" // String |  (optional)
let statsOnly = true // Bool |  (optional)
let viewerContext = "viewerContext_example" // String |  (optional)

// Get multiple reactions.
do {
    let response = try await ReactionsAPI.reactionsGet(filterEmoji: filterEmoji, filterSubjectId: filterSubjectId, filterSubjectType: filterSubjectType, filterSubject: filterSubject, include: include, includeLinkage: includeLinkage, pageCursor: pageCursor, replaceMedia: replaceMedia, stats: stats, statsOnly: statsOnly, viewerContext: viewerContext)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **filterEmoji** | [**[String]**](String.md) | Filter by emoji (e.g. &#x60;👍&#x60;) | [optional] 
 **filterSubjectId** | [**[String]**](String.md) | Deprecated: use filter[subject]. Filter by subject resource ID (e.g. &#x60;12345&#x60;) | [optional] 
 **filterSubjectType** | [**[String]**](String.md) | Deprecated: use filter[subject]. Filter by subject resource type (e.g. &#x60;albums&#x60;) | [optional] 
 **filterSubject** | **String** | The subject whose reactions to return. Use either subject or the deprecated subject.id and subject.type pair. | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: author, ownerProfiles, owners | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: author.albums | [optional] 
 **stats** | **String** |  | [optional] 
 **statsOnly** | **Bool** |  | [optional] 
 **viewerContext** | **String** |  | [optional] 

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

# **reactionsIdRelationshipsOwnerProfilesGet**
```swift
    open class func reactionsIdRelationshipsOwnerProfilesGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> ReactionsOwnerProfilesMultiRelationshipDataDocument
```

Get ownerProfiles relationship (\"to-many\").

Deprecated. Use author for attribution.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Reaction Id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: ownerProfiles (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get ownerProfiles relationship (\"to-many\").
do {
    let response = try await ReactionsAPI.reactionsIdRelationshipsOwnerProfilesGet(id: id, include: include, pageCursor: pageCursor)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Reaction Id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: ownerProfiles | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**ReactionsOwnerProfilesMultiRelationshipDataDocument**](ReactionsOwnerProfilesMultiRelationshipDataDocument.md)

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

# **reactionsPost**
```swift
    open class func reactionsPost(idempotencyKey: String? = nil, reactionsCreateOperationPayload: ReactionsCreateOperationPayload? = nil) async throws -> ReactionsCreateSingleResourceDataDocument
```

Create single reaction.

Creates a new reaction.

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

