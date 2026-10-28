# SharesAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**sharesGet**](SharesAPI.md#sharesget) | **GET** /shares | Get multiple shares.
[**sharesIdDelete**](SharesAPI.md#sharesiddelete) | **DELETE** /shares/{id} | Delete single share.
[**sharesIdGet**](SharesAPI.md#sharesidget) | **GET** /shares/{id} | Get single share.
[**sharesIdRelationshipsOwnersGet**](SharesAPI.md#sharesidrelationshipsownersget) | **GET** /shares/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
[**sharesIdRelationshipsSharedResourcesGet**](SharesAPI.md#sharesidrelationshipssharedresourcesget) | **GET** /shares/{id}/relationships/sharedResources | Get sharedResources relationship (\&quot;to-many\&quot;).
[**sharesPost**](SharesAPI.md#sharespost) | **POST** /shares | Create single share.


# **sharesGet**
```swift
    open class func sharesGet(filterCode: [String], include: [String]? = nil, includeLinkage: [IncludeLinkage_sharesGet]? = nil, replaceMedia: String? = nil) async throws -> SharesMultiResourceDataDocument
```

Get multiple shares.

Retrieves multiple shares by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let filterCode = ["inner_example"] // [String] | A share code (e.g. `xyz`)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: owners, sharedResources (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: sharedResources (optional)

// Get multiple shares.
do {
    let response = try await SharesAPI.sharesGet(filterCode: filterCode, include: include, includeLinkage: includeLinkage, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **filterCode** | [**[String]**](String.md) | A share code (e.g. &#x60;xyz&#x60;) | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: owners, sharedResources | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: sharedResources | [optional] 

### Return type

[**SharesMultiResourceDataDocument**](SharesMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **sharesIdDelete**
```swift
    open class func sharesIdDelete(id: String, idempotencyKey: String? = nil, revokeGrants: Bool? = nil) async throws -> MutationResponseDocument
```

Delete single share.

Delete share. Effectively revokes bearer access and acceptance.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Share id
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let revokeGrants = true // Bool | Also revoke the access granted to everyone who saved this share; access from other sources stays. Defaults to false. Not supported for playlist shares or for owners not yet on the access store; there true is rejected with 400. (optional)

// Delete single share.
do {
    let response = try await SharesAPI.sharesIdDelete(id: id, idempotencyKey: idempotencyKey, revokeGrants: revokeGrants)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Share id | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **revokeGrants** | **Bool** | Also revoke the access granted to everyone who saved this share; access from other sources stays. Defaults to false. Not supported for playlist shares or for owners not yet on the access store; there true is rejected with 400. | [optional] 

### Return type

[**MutationResponseDocument**](MutationResponseDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **sharesIdGet**
```swift
    open class func sharesIdGet(id: String, include: [String]? = nil, includeLinkage: [IncludeLinkage_sharesIdGet]? = nil, replaceMedia: String? = nil) async throws -> SharesSingleResourceDataDocument
```

Get single share.

Retrieves single share by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Share id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: owners, sharedResources (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: sharedResources (optional)

// Get single share.
do {
    let response = try await SharesAPI.sharesIdGet(id: id, include: include, includeLinkage: includeLinkage, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Share id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: owners, sharedResources | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: sharedResources | [optional] 

### Return type

[**SharesSingleResourceDataDocument**](SharesSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **sharesIdRelationshipsOwnersGet**
```swift
    open class func sharesIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> SharesOwnersMultiRelationshipDataDocument
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Share id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get owners relationship (\"to-many\").
do {
    let response = try await SharesAPI.sharesIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Share id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**SharesOwnersMultiRelationshipDataDocument**](SharesOwnersMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **sharesIdRelationshipsSharedResourcesGet**
```swift
    open class func sharesIdRelationshipsSharedResourcesGet(id: String, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil) async throws -> SharesSharedResourcesMultiRelationshipDataDocument
```

Get sharedResources relationship (\"to-many\").

Retrieves sharedResources relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Share id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: sharedResources (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: sharedResources (optional)

// Get sharedResources relationship (\"to-many\").
do {
    let response = try await SharesAPI.sharesIdRelationshipsSharedResourcesGet(id: id, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Share id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: sharedResources | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: sharedResources | [optional] 

### Return type

[**SharesSharedResourcesMultiRelationshipDataDocument**](SharesSharedResourcesMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **sharesPost**
```swift
    open class func sharesPost(idempotencyKey: String? = nil, sharesCreateOperationPayload: SharesCreateOperationPayload? = nil) async throws -> SharesCreateSingleResourceDataDocument
```

Create single share.

Creates a new share.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let sharesCreateOperationPayload = SharesCreateOperation_Payload(data: SharesCreateOperation_Payload_Data(attributes: SharesCreateOperation_Payload_Data_Attributes(accessModes: ["accessModes_example"], expiresAt: Date(), maxUses: 123, role: "role_example"), relationships: SharesCreateOperation_Payload_Data_Relationships(sharedResources: SharesCreateOperation_Payload_Data_Relationships_SharedResources(data: [SharesCreateOperation_Payload_Data_Relationships_SharedResources_Data(id: "id_example", type: "type_example")])), type: "type_example")) // SharesCreateOperationPayload |  (optional)

// Create single share.
do {
    let response = try await SharesAPI.sharesPost(idempotencyKey: idempotencyKey, sharesCreateOperationPayload: sharesCreateOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **sharesCreateOperationPayload** | [**SharesCreateOperationPayload**](SharesCreateOperationPayload.md) |  | [optional] 

### Return type

[**SharesCreateSingleResourceDataDocument**](SharesCreateSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

