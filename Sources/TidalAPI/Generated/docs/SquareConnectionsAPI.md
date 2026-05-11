# SquareConnectionsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**squareConnectionsIdGet**](SquareConnectionsAPI.md#squareconnectionsidget) | **GET** /squareConnections/{id} | Get single squareConnection.
[**squareConnectionsPost**](SquareConnectionsAPI.md#squareconnectionspost) | **POST** /squareConnections | Create single squareConnection.


# **squareConnectionsIdGet**
```swift
    open class func squareConnectionsIdGet(id: String, completion: @escaping (_ data: SquareConnectionsSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single squareConnection.

Retrieves single squareConnection by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Square connection id. Use `me` for the authenticated user's resource

// Get single squareConnection.
SquareConnectionsAPI.squareConnectionsIdGet(id: id) { (response, error) in
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
 **id** | **String** | Square connection id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 

### Return type

[**SquareConnectionsSingleResourceDataDocument**](SquareConnectionsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **squareConnectionsPost**
```swift
    open class func squareConnectionsPost(countryCode: String? = nil, idempotencyKey: String? = nil, squareConnectionsCreateOperationPayload: SquareConnectionsCreateOperationPayload? = nil, completion: @escaping (_ data: SquareConnectionsSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Create single squareConnection.

Creates a new squareConnection.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. (optional)
let squareConnectionsCreateOperationPayload = SquareConnectionsCreateOperation_Payload(data: SquareConnectionsCreateOperation_Payload_Data(type: "type_example"), meta: SquareConnectionsCreateOperation_Payload_Meta(platform: "platform_example")) // SquareConnectionsCreateOperationPayload |  (optional)

// Create single squareConnection.
SquareConnectionsAPI.squareConnectionsPost(countryCode: countryCode, idempotencyKey: idempotencyKey, squareConnectionsCreateOperationPayload: squareConnectionsCreateOperationPayload) { (response, error) in
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
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. | [optional] 
 **squareConnectionsCreateOperationPayload** | [**SquareConnectionsCreateOperationPayload**](SquareConnectionsCreateOperationPayload.md) |  | [optional] 

### Return type

[**SquareConnectionsSingleResourceDataDocument**](SquareConnectionsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

