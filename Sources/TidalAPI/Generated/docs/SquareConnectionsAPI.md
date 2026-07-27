# SquareConnectionsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**squareConnectionsIdGet**](SquareConnectionsAPI.md#squareconnectionsidget) | **GET** /squareConnections/{id} | Get single squareConnection.
[**squareConnectionsIdRelationshipsSelectedSiteGet**](SquareConnectionsAPI.md#squareconnectionsidrelationshipsselectedsiteget) | **GET** /squareConnections/{id}/relationships/selectedSite | Get selectedSite relationship (\&quot;to-one\&quot;).
[**squareConnectionsIdRelationshipsSelectedSitePatch**](SquareConnectionsAPI.md#squareconnectionsidrelationshipsselectedsitepatch) | **PATCH** /squareConnections/{id}/relationships/selectedSite | Update selectedSite relationship (\&quot;to-one\&quot;).
[**squareConnectionsIdRelationshipsSitesGet**](SquareConnectionsAPI.md#squareconnectionsidrelationshipssitesget) | **GET** /squareConnections/{id}/relationships/sites | Get sites relationship (\&quot;to-many\&quot;).
[**squareConnectionsPost**](SquareConnectionsAPI.md#squareconnectionspost) | **POST** /squareConnections | Create single squareConnection.


# **squareConnectionsIdGet**
```swift
    open class func squareConnectionsIdGet(id: String, include: [String]? = nil, completion: @escaping (_ data: SquareConnectionsSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single squareConnection.

Retrieves single squareConnection by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Square connection id. Use `me` for the authenticated user's resource
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: selectedSite, sites (optional)

// Get single squareConnection.
SquareConnectionsAPI.squareConnectionsIdGet(id: id, include: include) { (response, error) in
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
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: selectedSite, sites | [optional] 

### Return type

[**SquareConnectionsSingleResourceDataDocument**](SquareConnectionsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **squareConnectionsIdRelationshipsSelectedSiteGet**
```swift
    open class func squareConnectionsIdRelationshipsSelectedSiteGet(id: String, include: [String]? = nil, completion: @escaping (_ data: SquareConnectionsSingleRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get selectedSite relationship (\"to-one\").

Retrieves selectedSite relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Square connection id. Use `me` for the authenticated user's resource
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: selectedSite (optional)

// Get selectedSite relationship (\"to-one\").
SquareConnectionsAPI.squareConnectionsIdRelationshipsSelectedSiteGet(id: id, include: include) { (response, error) in
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
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: selectedSite | [optional] 

### Return type

[**SquareConnectionsSingleRelationshipDataDocument**](SquareConnectionsSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **squareConnectionsIdRelationshipsSelectedSitePatch**
```swift
    open class func squareConnectionsIdRelationshipsSelectedSitePatch(id: String, idempotencyKey: String? = nil, squareConnectionsSelectedSiteRelationshipUpdateOperationPayload: SquareConnectionsSelectedSiteRelationshipUpdateOperationPayload? = nil, completion: @escaping (_ data: SquareConnectionsSingleRelationshipDataDocument?, _ error: Error?) -> Void)
```

Update selectedSite relationship (\"to-one\").

Updates selectedSite relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Square connection id. Use `me` for the authenticated user's resource
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. (optional)
let squareConnectionsSelectedSiteRelationshipUpdateOperationPayload = SquareConnectionsSelectedSiteRelationshipUpdateOperation_Payload(data: SquareConnectionsSelectedSiteRelationshipUpdateOperation_Payload_Data(id: "id_example", type: "type_example")) // SquareConnectionsSelectedSiteRelationshipUpdateOperationPayload |  (optional)

// Update selectedSite relationship (\"to-one\").
SquareConnectionsAPI.squareConnectionsIdRelationshipsSelectedSitePatch(id: id, idempotencyKey: idempotencyKey, squareConnectionsSelectedSiteRelationshipUpdateOperationPayload: squareConnectionsSelectedSiteRelationshipUpdateOperationPayload) { (response, error) in
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
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. | [optional] 
 **squareConnectionsSelectedSiteRelationshipUpdateOperationPayload** | [**SquareConnectionsSelectedSiteRelationshipUpdateOperationPayload**](SquareConnectionsSelectedSiteRelationshipUpdateOperationPayload.md) |  | [optional] 

### Return type

[**SquareConnectionsSingleRelationshipDataDocument**](SquareConnectionsSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **squareConnectionsIdRelationshipsSitesGet**
```swift
    open class func squareConnectionsIdRelationshipsSitesGet(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: SquareConnectionsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get sites relationship (\"to-many\").

Retrieves sites relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Square connection id. Use `me` for the authenticated user's resource
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: sites (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get sites relationship (\"to-many\").
SquareConnectionsAPI.squareConnectionsIdRelationshipsSitesGet(id: id, include: include, pageCursor: pageCursor) { (response, error) in
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
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: sites | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**SquareConnectionsMultiRelationshipDataDocument**](SquareConnectionsMultiRelationshipDataDocument.md)

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
let squareConnectionsCreateOperationPayload = SquareConnectionsCreateOperation_Payload(data: SquareConnectionsCreateOperation_Payload_Data(type: "type_example"), meta: SquareConnectionsCreateOperation_Payload_Meta(platform: "platform_example", redirectUrl: "redirectUrl_example")) // SquareConnectionsCreateOperationPayload |  (optional)

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

