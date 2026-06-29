# TemporaryUserTokensAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**temporaryUserTokensIdGet**](TemporaryUserTokensAPI.md#temporaryusertokensidget) | **GET** /temporaryUserTokens/{id} | Get single temporaryUserToken.
[**temporaryUserTokensIdRelationshipsOwnersGet**](TemporaryUserTokensAPI.md#temporaryusertokensidrelationshipsownersget) | **GET** /temporaryUserTokens/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
[**temporaryUserTokensPost**](TemporaryUserTokensAPI.md#temporaryusertokenspost) | **POST** /temporaryUserTokens | Create single temporaryUserToken.


# **temporaryUserTokensIdGet**
```swift
    open class func temporaryUserTokensIdGet(id: String, include: [String]? = nil, completion: @escaping (_ data: TemporaryUserTokensSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single temporaryUserToken.

Retrieves single temporaryUserToken by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Temporary user token id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners (optional)

// Get single temporaryUserToken.
TemporaryUserTokensAPI.temporaryUserTokensIdGet(id: id, include: include) { (response, error) in
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
 **id** | **String** | Temporary user token id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners | [optional] 

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
    open class func temporaryUserTokensIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: TemporaryUserTokensMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Temporary user token id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get owners relationship (\"to-many\").
TemporaryUserTokensAPI.temporaryUserTokensIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | Temporary user token id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**TemporaryUserTokensMultiRelationshipDataDocument**](TemporaryUserTokensMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **temporaryUserTokensPost**
```swift
    open class func temporaryUserTokensPost(idempotencyKey: String? = nil, temporaryUserTokensCreateOperationPayload: TemporaryUserTokensCreateOperationPayload? = nil, completion: @escaping (_ data: TemporaryUserTokensSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Create single temporaryUserToken.

Creates a new temporaryUserToken.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. (optional)
let temporaryUserTokensCreateOperationPayload = TemporaryUserTokensCreateOperation_Payload(data: TemporaryUserTokensCreateOperation_Payload_Data(type: "type_example")) // TemporaryUserTokensCreateOperationPayload |  (optional)

// Create single temporaryUserToken.
TemporaryUserTokensAPI.temporaryUserTokensPost(idempotencyKey: idempotencyKey, temporaryUserTokensCreateOperationPayload: temporaryUserTokensCreateOperationPayload) { (response, error) in
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
 **temporaryUserTokensCreateOperationPayload** | [**TemporaryUserTokensCreateOperationPayload**](TemporaryUserTokensCreateOperationPayload.md) |  | [optional] 

### Return type

[**TemporaryUserTokensSingleResourceDataDocument**](TemporaryUserTokensSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

