# ClientsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**clientsGet**](ClientsAPI.md#clientsget) | **GET** /clients | Get multiple clients.
[**clientsIdDelete**](ClientsAPI.md#clientsiddelete) | **DELETE** /clients/{id} | Delete single client.
[**clientsIdGet**](ClientsAPI.md#clientsidget) | **GET** /clients/{id} | Get single client.
[**clientsIdPatch**](ClientsAPI.md#clientsidpatch) | **PATCH** /clients/{id} | Update single client.
[**clientsIdRelationshipsOwnersGet**](ClientsAPI.md#clientsidrelationshipsownersget) | **GET** /clients/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
[**clientsPost**](ClientsAPI.md#clientspost) | **POST** /clients | Create single client.


# **clientsGet**
```swift
    open class func clientsGet(include: [String]? = nil, filterOwnersId: [String]? = nil, completion: @escaping (_ data: ClientsMultiResourceDataDocument?, _ error: Error?) -> Void)
```

Get multiple clients.

Retrieves multiple clients by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners (optional)
let filterOwnersId = ["inner_example"] // [String] | User id. Use `me` for the authenticated user (optional)

// Get multiple clients.
ClientsAPI.clientsGet(include: include, filterOwnersId: filterOwnersId) { (response, error) in
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
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners | [optional] 
 **filterOwnersId** | [**[String]**](String.md) | User id. Use &#x60;me&#x60; for the authenticated user | [optional] 

### Return type

[**ClientsMultiResourceDataDocument**](ClientsMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **clientsIdDelete**
```swift
    open class func clientsIdDelete(id: String, idempotencyKey: String? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Delete single client.

Deletes existing client.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | OAuth client identifier
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. (optional)

// Delete single client.
ClientsAPI.clientsIdDelete(id: id, idempotencyKey: idempotencyKey) { (response, error) in
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
 **id** | **String** | OAuth client identifier | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **clientsIdGet**
```swift
    open class func clientsIdGet(id: String, include: [String]? = nil, completion: @escaping (_ data: ClientsSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single client.

Retrieves single client by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | OAuth client identifier
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners (optional)

// Get single client.
ClientsAPI.clientsIdGet(id: id, include: include) { (response, error) in
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
 **id** | **String** | OAuth client identifier | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners | [optional] 

### Return type

[**ClientsSingleResourceDataDocument**](ClientsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **clientsIdPatch**
```swift
    open class func clientsIdPatch(id: String, idempotencyKey: String? = nil, clientsUpdateOperationPayload: ClientsUpdateOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Update single client.

Updates existing client.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | OAuth client identifier
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. (optional)
let clientsUpdateOperationPayload = ClientsUpdateOperation_Payload(data: ClientsUpdateOperation_Payload_Data(attributes: ClientsUpdateOperation_Payload_Data_Attributes(description: "description_example", enabled: false, name: "name_example", platformPreset: "platformPreset_example", redirectUris: ["redirectUris_example"], scopes: ["scopes_example"]), id: "id_example", type: "type_example")) // ClientsUpdateOperationPayload |  (optional)

// Update single client.
ClientsAPI.clientsIdPatch(id: id, idempotencyKey: idempotencyKey, clientsUpdateOperationPayload: clientsUpdateOperationPayload) { (response, error) in
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
 **id** | **String** | OAuth client identifier | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. | [optional] 
 **clientsUpdateOperationPayload** | [**ClientsUpdateOperationPayload**](ClientsUpdateOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **clientsIdRelationshipsOwnersGet**
```swift
    open class func clientsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: ClientsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | OAuth client identifier
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get owners relationship (\"to-many\").
ClientsAPI.clientsIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | OAuth client identifier | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**ClientsMultiRelationshipDataDocument**](ClientsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **clientsPost**
```swift
    open class func clientsPost(idempotencyKey: String? = nil, clientsCreateOperationPayload: ClientsCreateOperationPayload? = nil, completion: @escaping (_ data: ClientsSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Create single client.

Creates a new client.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. (optional)
let clientsCreateOperationPayload = ClientsCreateOperation_Payload(data: ClientsCreateOperation_Payload_Data(attributes: ClientsCreateOperation_Payload_Data_Attributes(description: "description_example", name: "name_example"), type: "type_example")) // ClientsCreateOperationPayload |  (optional)

// Create single client.
ClientsAPI.clientsPost(idempotencyKey: idempotencyKey, clientsCreateOperationPayload: clientsCreateOperationPayload) { (response, error) in
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
 **clientsCreateOperationPayload** | [**ClientsCreateOperationPayload**](ClientsCreateOperationPayload.md) |  | [optional] 

### Return type

[**ClientsSingleResourceDataDocument**](ClientsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

