# ClientCertificatesAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**clientCertificatesIdGet**](ClientCertificatesAPI.md#clientcertificatesidget) | **GET** /clientCertificates/{id} | Get single clientCertificate.
[**clientCertificatesIdRelationshipsOwnersGet**](ClientCertificatesAPI.md#clientcertificatesidrelationshipsownersget) | **GET** /clientCertificates/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
[**clientCertificatesPost**](ClientCertificatesAPI.md#clientcertificatespost) | **POST** /clientCertificates | Create single clientCertificate.


# **clientCertificatesIdGet**
```swift
    open class func clientCertificatesIdGet(id: String, include: [String]? = nil, includeLinkage: [IncludeLinkage_clientCertificatesIdGet]? = nil, completion: @escaping (_ data: ClientCertificatesSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single clientCertificate.

Retrieves single clientCertificate by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | TIDAL Connect client certificate identifier
let include = ["inner_example"] // [String] | Include related resources. Available relationships: owners (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)

// Get single clientCertificate.
ClientCertificatesAPI.clientCertificatesIdGet(id: id, include: include, includeLinkage: includeLinkage) { (response, error) in
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
 **id** | **String** | TIDAL Connect client certificate identifier | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: owners | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 

### Return type

[**ClientCertificatesSingleResourceDataDocument**](ClientCertificatesSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **clientCertificatesIdRelationshipsOwnersGet**
```swift
    open class func clientCertificatesIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: ClientCertificatesOwnersMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | TIDAL Connect client certificate identifier
let include = ["inner_example"] // [String] | Include related resources. Available relationships: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get owners relationship (\"to-many\").
ClientCertificatesAPI.clientCertificatesIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | TIDAL Connect client certificate identifier | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**ClientCertificatesOwnersMultiRelationshipDataDocument**](ClientCertificatesOwnersMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **clientCertificatesPost**
```swift
    open class func clientCertificatesPost(idempotencyKey: String? = nil, clientCertificatesCreateOperationPayload: ClientCertificatesCreateOperationPayload? = nil, completion: @escaping (_ data: ClientCertificatesCreateSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Create single clientCertificate.

Creates a new clientCertificate.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. (optional)
let clientCertificatesCreateOperationPayload = ClientCertificatesCreateOperation_Payload(data: ClientCertificatesCreateOperation_Payload_Data(relationships: ClientCertificatesCreateOperation_Payload_Data_Relationships(client: ClientCertificatesCreateOperation_Payload_Data_Relationships_Client(data: ClientCertificatesCreateOperation_Payload_Data_Relationships_Client_Data(id: "id_example", type: "type_example"))), type: "type_example")) // ClientCertificatesCreateOperationPayload |  (optional)

// Create single clientCertificate.
ClientCertificatesAPI.clientCertificatesPost(idempotencyKey: idempotencyKey, clientCertificatesCreateOperationPayload: clientCertificatesCreateOperationPayload) { (response, error) in
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
 **clientCertificatesCreateOperationPayload** | [**ClientCertificatesCreateOperationPayload**](ClientCertificatesCreateOperationPayload.md) |  | [optional] 

### Return type

[**ClientCertificatesCreateSingleResourceDataDocument**](ClientCertificatesCreateSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

