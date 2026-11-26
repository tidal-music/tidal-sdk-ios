# ResourceGrantInvitationsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**resourceGrantInvitationsGet**](ResourceGrantInvitationsAPI.md#resourcegrantinvitationsget) | **GET** /resourceGrantInvitations | Get multiple resourceGrantInvitations.
[**resourceGrantInvitationsIdDelete**](ResourceGrantInvitationsAPI.md#resourcegrantinvitationsiddelete) | **DELETE** /resourceGrantInvitations/{id} | Delete single resourceGrantInvitation.
[**resourceGrantInvitationsIdGet**](ResourceGrantInvitationsAPI.md#resourcegrantinvitationsidget) | **GET** /resourceGrantInvitations/{id} | Get single resourceGrantInvitation.
[**resourceGrantInvitationsIdPatch**](ResourceGrantInvitationsAPI.md#resourcegrantinvitationsidpatch) | **PATCH** /resourceGrantInvitations/{id} | Update single resourceGrantInvitation.
[**resourceGrantInvitationsIdRelationshipsOwnersGet**](ResourceGrantInvitationsAPI.md#resourcegrantinvitationsidrelationshipsownersget) | **GET** /resourceGrantInvitations/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
[**resourceGrantInvitationsIdRelationshipsPreviewGrantGet**](ResourceGrantInvitationsAPI.md#resourcegrantinvitationsidrelationshipspreviewgrantget) | **GET** /resourceGrantInvitations/{id}/relationships/previewGrant | Get previewGrant relationship (\&quot;to-one\&quot;).
[**resourceGrantInvitationsIdRelationshipsSubjectGet**](ResourceGrantInvitationsAPI.md#resourcegrantinvitationsidrelationshipssubjectget) | **GET** /resourceGrantInvitations/{id}/relationships/subject | Get subject relationship (\&quot;to-one\&quot;).
[**resourceGrantInvitationsPost**](ResourceGrantInvitationsAPI.md#resourcegrantinvitationspost) | **POST** /resourceGrantInvitations | Create single resourceGrantInvitation.


# **resourceGrantInvitationsGet**
```swift
    open class func resourceGrantInvitationsGet(filterCode: String? = nil, filterSelfAppliesTo: String? = nil, include: [String]? = nil, includeLinkage: [IncludeLinkage_resourceGrantInvitationsGet]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil) async throws -> ResourceGrantInvitationsMultiResourceDataDocument
```

Get multiple resourceGrantInvitations.

Retrieves multiple resourceGrantInvitations by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let filterCode = "filterCode_example" // String | Invitation code (e.g. `42179b73-6f0c-405c-b926-2fdb45363c44`) (optional)
let filterSelfAppliesTo = "filterSelfAppliesTo_example" // String | Album, track or folder owned by the caller. Selects undeleted, unexpired invitations on the resource or its ancestors; used-up ones are included. Each keeps its own subject. Cannot be combined with other filters. Missing or non-owned resources and subjects without a live access node return no records. Ordered by expiry then ID; at most 20 invitations per page. Also accepts `folders:me`. (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: owners, previewGrant, subject (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: previewGrant.subject (optional)

// Get multiple resourceGrantInvitations.
do {
    let response = try await ResourceGrantInvitationsAPI.resourceGrantInvitationsGet(filterCode: filterCode, filterSelfAppliesTo: filterSelfAppliesTo, include: include, includeLinkage: includeLinkage, pageCursor: pageCursor, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **filterCode** | **String** | Invitation code (e.g. &#x60;42179b73-6f0c-405c-b926-2fdb45363c44&#x60;) | [optional] 
 **filterSelfAppliesTo** | **String** | Album, track or folder owned by the caller. Selects undeleted, unexpired invitations on the resource or its ancestors; used-up ones are included. Each keeps its own subject. Cannot be combined with other filters. Missing or non-owned resources and subjects without a live access node return no records. Ordered by expiry then ID; at most 20 invitations per page. Also accepts &#x60;folders:me&#x60;. | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: owners, previewGrant, subject | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: previewGrant.subject | [optional] 

### Return type

[**ResourceGrantInvitationsMultiResourceDataDocument**](ResourceGrantInvitationsMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **resourceGrantInvitationsIdDelete**
```swift
    open class func resourceGrantInvitationsIdDelete(id: String, idempotencyKey: String? = nil, revokeGrants: Bool? = nil) async throws -> MutationResponseDocument
```

Delete single resourceGrantInvitation.

Delete the invitation, ending redemption and its preview.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Invitation id
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let revokeGrants = true // Bool | Also revoke the grants redemptions issued; access from other sources stays. Defaults to false. (optional)

// Delete single resourceGrantInvitation.
do {
    let response = try await ResourceGrantInvitationsAPI.resourceGrantInvitationsIdDelete(id: id, idempotencyKey: idempotencyKey, revokeGrants: revokeGrants)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Invitation id | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **revokeGrants** | **Bool** | Also revoke the grants redemptions issued; access from other sources stays. Defaults to false. | [optional] 

### Return type

[**MutationResponseDocument**](MutationResponseDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **resourceGrantInvitationsIdGet**
```swift
    open class func resourceGrantInvitationsIdGet(id: String, include: [String]? = nil, includeLinkage: [IncludeLinkage_resourceGrantInvitationsIdGet]? = nil, replaceMedia: String? = nil) async throws -> ResourceGrantInvitationsSingleResourceDataDocument
```

Get single resourceGrantInvitation.

Retrieves single resourceGrantInvitation by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Invitation id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: owners, previewGrant, subject (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: previewGrant.subject (optional)

// Get single resourceGrantInvitation.
do {
    let response = try await ResourceGrantInvitationsAPI.resourceGrantInvitationsIdGet(id: id, include: include, includeLinkage: includeLinkage, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Invitation id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: owners, previewGrant, subject | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: previewGrant.subject | [optional] 

### Return type

[**ResourceGrantInvitationsSingleResourceDataDocument**](ResourceGrantInvitationsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **resourceGrantInvitationsIdPatch**
```swift
    open class func resourceGrantInvitationsIdPatch(id: String, idempotencyKey: String? = nil, resourceGrantInvitationsUpdateOperationPayload: ResourceGrantInvitationsUpdateOperationPayload? = nil) async throws -> ResourceGrantInvitationsUpdateSingleResourceDataDocument
```

Update single resourceGrantInvitation.

Set, change or remove the password, or turn the preview on or off. Users who redeemed keep their grants.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Invitation id
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let resourceGrantInvitationsUpdateOperationPayload = ResourceGrantInvitationsUpdateOperation_Payload(data: ResourceGrantInvitationsUpdateOperation_Payload_Data(attributes: ResourceGrantInvitationsUpdateOperation_Payload_Data_Attributes(password: "password_example", preview: false), id: "id_example", type: "type_example")) // ResourceGrantInvitationsUpdateOperationPayload |  (optional)

// Update single resourceGrantInvitation.
do {
    let response = try await ResourceGrantInvitationsAPI.resourceGrantInvitationsIdPatch(id: id, idempotencyKey: idempotencyKey, resourceGrantInvitationsUpdateOperationPayload: resourceGrantInvitationsUpdateOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Invitation id | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **resourceGrantInvitationsUpdateOperationPayload** | [**ResourceGrantInvitationsUpdateOperationPayload**](ResourceGrantInvitationsUpdateOperationPayload.md) |  | [optional] 

### Return type

[**ResourceGrantInvitationsUpdateSingleResourceDataDocument**](ResourceGrantInvitationsUpdateSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **resourceGrantInvitationsIdRelationshipsOwnersGet**
```swift
    open class func resourceGrantInvitationsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> ResourceGrantInvitationsOwnersMultiRelationshipDataDocument
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Invitation id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get owners relationship (\"to-many\").
do {
    let response = try await ResourceGrantInvitationsAPI.resourceGrantInvitationsIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Invitation id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**ResourceGrantInvitationsOwnersMultiRelationshipDataDocument**](ResourceGrantInvitationsOwnersMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **resourceGrantInvitationsIdRelationshipsPreviewGrantGet**
```swift
    open class func resourceGrantInvitationsIdRelationshipsPreviewGrantGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> ResourceGrantInvitationsPreviewGrantSingleRelationshipDataDocument
```

Get previewGrant relationship (\"to-one\").

Retrieves previewGrant relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Invitation id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: previewGrant (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: previewGrant.subject (optional)

// Get previewGrant relationship (\"to-one\").
do {
    let response = try await ResourceGrantInvitationsAPI.resourceGrantInvitationsIdRelationshipsPreviewGrantGet(id: id, include: include, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Invitation id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: previewGrant | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: previewGrant.subject | [optional] 

### Return type

[**ResourceGrantInvitationsPreviewGrantSingleRelationshipDataDocument**](ResourceGrantInvitationsPreviewGrantSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **resourceGrantInvitationsIdRelationshipsSubjectGet**
```swift
    open class func resourceGrantInvitationsIdRelationshipsSubjectGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> ResourceGrantInvitationsSubjectSingleRelationshipDataDocument
```

Get subject relationship (\"to-one\").

Retrieves subject relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Invitation id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: subject (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: subject (optional)

// Get subject relationship (\"to-one\").
do {
    let response = try await ResourceGrantInvitationsAPI.resourceGrantInvitationsIdRelationshipsSubjectGet(id: id, include: include, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Invitation id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: subject | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: subject | [optional] 

### Return type

[**ResourceGrantInvitationsSubjectSingleRelationshipDataDocument**](ResourceGrantInvitationsSubjectSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **resourceGrantInvitationsPost**
```swift
    open class func resourceGrantInvitationsPost(idempotencyKey: String? = nil, resourceGrantInvitationsCreateOperationPayload: ResourceGrantInvitationsCreateOperationPayload? = nil) async throws -> ResourceGrantInvitationsCreateSingleResourceDataDocument
```

Create single resourceGrantInvitation.

Creates a new resourceGrantInvitation.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let resourceGrantInvitationsCreateOperationPayload = ResourceGrantInvitationsCreateOperation_Payload(data: ResourceGrantInvitationsCreateOperation_Payload_Data(attributes: ResourceGrantInvitationsCreateOperation_Payload_Data_Attributes(expiresAt: Date(), maxUses: 123, password: "password_example", preview: false, role: "role_example"), relationships: ResourceGrantInvitationsCreateOperation_Payload_Data_Relationships(subject: ResourceGrantInvitationsCreateOperation_Payload_Data_Relationships_Subject(data: ResourceGrantInvitationsCreateOperation_Payload_Data_Relationships_Subject_Data(id: "id_example", type: "type_example"))), type: "type_example")) // ResourceGrantInvitationsCreateOperationPayload |  (optional)

// Create single resourceGrantInvitation.
do {
    let response = try await ResourceGrantInvitationsAPI.resourceGrantInvitationsPost(idempotencyKey: idempotencyKey, resourceGrantInvitationsCreateOperationPayload: resourceGrantInvitationsCreateOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **resourceGrantInvitationsCreateOperationPayload** | [**ResourceGrantInvitationsCreateOperationPayload**](ResourceGrantInvitationsCreateOperationPayload.md) |  | [optional] 

### Return type

[**ResourceGrantInvitationsCreateSingleResourceDataDocument**](ResourceGrantInvitationsCreateSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

