# StripeConnectionsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**stripeConnectionsGet**](StripeConnectionsAPI.md#stripeconnectionsget) | **GET** /stripeConnections | Get multiple stripeConnections.
[**stripeConnectionsIdRelationshipsOwnersGet**](StripeConnectionsAPI.md#stripeconnectionsidrelationshipsownersget) | **GET** /stripeConnections/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
[**stripeConnectionsPost**](StripeConnectionsAPI.md#stripeconnectionspost) | **POST** /stripeConnections | Create single stripeConnection.


# **stripeConnectionsGet**
```swift
    open class func stripeConnectionsGet(include: [String]? = nil, filterOwnersId: [String]? = nil, completion: @escaping (_ data: StripeConnectionsMultiResourceDataDocument?, _ error: Error?) -> Void)
```

Get multiple stripeConnections.

Retrieves multiple stripeConnections by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners (optional)
let filterOwnersId = ["inner_example"] // [String] | User id (optional)

// Get multiple stripeConnections.
StripeConnectionsAPI.stripeConnectionsGet(include: include, filterOwnersId: filterOwnersId) { (response, error) in
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
 **filterOwnersId** | [**[String]**](String.md) | User id | [optional] 

### Return type

[**StripeConnectionsMultiResourceDataDocument**](StripeConnectionsMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **stripeConnectionsIdRelationshipsOwnersGet**
```swift
    open class func stripeConnectionsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: StripeConnectionsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Stripe connection id (same as user id)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get owners relationship (\"to-many\").
StripeConnectionsAPI.stripeConnectionsIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | Stripe connection id (same as user id) | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**StripeConnectionsMultiRelationshipDataDocument**](StripeConnectionsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **stripeConnectionsPost**
```swift
    open class func stripeConnectionsPost(countryCode: String, stripeConnectionsCreateOperationPayload: StripeConnectionsCreateOperationPayload? = nil, completion: @escaping (_ data: StripeConnectionsSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Create single stripeConnection.

Creates a new stripeConnection.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let stripeConnectionsCreateOperationPayload = StripeConnectionsCreateOperation_Payload(data: StripeConnectionsCreateOperation_Payload_Data(attributes: StripeConnectionsCreateOperation_Payload_Data_Attributes(integrationType: "integrationType_example", refreshUrl: "refreshUrl_example", returnUrl: "returnUrl_example"), type: "type_example")) // StripeConnectionsCreateOperationPayload |  (optional)

// Create single stripeConnection.
StripeConnectionsAPI.stripeConnectionsPost(countryCode: countryCode, stripeConnectionsCreateOperationPayload: stripeConnectionsCreateOperationPayload) { (response, error) in
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
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **stripeConnectionsCreateOperationPayload** | [**StripeConnectionsCreateOperationPayload**](StripeConnectionsCreateOperationPayload.md) |  | [optional] 

### Return type

[**StripeConnectionsSingleResourceDataDocument**](StripeConnectionsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

