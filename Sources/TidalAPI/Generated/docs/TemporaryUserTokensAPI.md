# TemporaryUserTokensAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**temporaryUserTokensIdGet**](TemporaryUserTokensAPI.md#temporaryusertokensidget) | **GET** /temporaryUserTokens/{id} | Get single temporaryUserToken.
[**temporaryUserTokensIdRelationshipsOwnersGet**](TemporaryUserTokensAPI.md#temporaryusertokensidrelationshipsownersget) | **GET** /temporaryUserTokens/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
[**temporaryUserTokensPost**](TemporaryUserTokensAPI.md#temporaryusertokenspost) | **POST** /temporaryUserTokens | Create single temporaryUserToken.


# **temporaryUserTokensIdGet**
```swift
    open class func temporaryUserTokensIdGet(id: String, include: [String]? = nil, includeLinkage: [IncludeLinkage_temporaryUserTokensIdGet]? = nil) async throws -> TemporaryUserTokensSingleResourceDataDocument
```

Get single temporaryUserToken.

Retrieves single temporaryUserToken by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Temporary user token id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: owners (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)

// Get single temporaryUserToken.
do {
    let response = try await TemporaryUserTokensAPI.temporaryUserTokensIdGet(id: id, include: include, includeLinkage: includeLinkage)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Temporary user token id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: owners | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 

### Return type

[**TemporaryUserTokensSingleResourceDataDocument**](TemporaryUserTokensSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **temporaryUserTokensIdRelationshipsOwnersGet**
```swift
    open class func temporaryUserTokensIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> TemporaryUserTokensOwnersMultiRelationshipDataDocument
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Temporary user token id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get owners relationship (\"to-many\").
do {
    let response = try await TemporaryUserTokensAPI.temporaryUserTokensIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Temporary user token id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**TemporaryUserTokensOwnersMultiRelationshipDataDocument**](TemporaryUserTokensOwnersMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **temporaryUserTokensPost**
```swift
    open class func temporaryUserTokensPost(idempotencyKey: String? = nil, temporaryUserTokensCreateOperationPayload: TemporaryUserTokensCreateOperationPayload? = nil) async throws -> TemporaryUserTokensCreateSingleResourceDataDocument
```

Create single temporaryUserToken.

Creates a new temporaryUserToken.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let temporaryUserTokensCreateOperationPayload = TemporaryUserTokensCreateOperation_Payload(data: TemporaryUserTokensCreateOperation_Payload_Data(type: "type_example")) // TemporaryUserTokensCreateOperationPayload |  (optional)

// Create single temporaryUserToken.
do {
    let response = try await TemporaryUserTokensAPI.temporaryUserTokensPost(idempotencyKey: idempotencyKey, temporaryUserTokensCreateOperationPayload: temporaryUserTokensCreateOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **temporaryUserTokensCreateOperationPayload** | [**TemporaryUserTokensCreateOperationPayload**](TemporaryUserTokensCreateOperationPayload.md) |  | [optional] 

### Return type

[**TemporaryUserTokensCreateSingleResourceDataDocument**](TemporaryUserTokensCreateSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

