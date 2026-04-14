# AcceptedTermsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**acceptedTermsGet**](AcceptedTermsAPI.md#acceptedtermsget) | **GET** /acceptedTerms | Get multiple acceptedTerms.
[**acceptedTermsIdRelationshipsOwnersGet**](AcceptedTermsAPI.md#acceptedtermsidrelationshipsownersget) | **GET** /acceptedTerms/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
[**acceptedTermsIdRelationshipsTermsGet**](AcceptedTermsAPI.md#acceptedtermsidrelationshipstermsget) | **GET** /acceptedTerms/{id}/relationships/terms | Get terms relationship (\&quot;to-one\&quot;).
[**acceptedTermsPost**](AcceptedTermsAPI.md#acceptedtermspost) | **POST** /acceptedTerms | Create single acceptedTerm.


# **acceptedTermsGet**
```swift
    open class func acceptedTermsGet(include: [String]? = nil, filterOwnersId: [String]? = nil, filterTermsIsLatestVersion: [String]? = nil, filterTermsTermsType: [FilterTermsTermsType_acceptedTermsGet]? = nil, completion: @escaping (_ data: AcceptedTermsMultiResourceDataDocument?, _ error: Error?) -> Void)
```

Get multiple acceptedTerms.

Retrieves multiple acceptedTerms by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners, terms (optional)
let filterOwnersId = ["inner_example"] // [String] | User id. Use `me` for the authenticated user (optional)
let filterTermsIsLatestVersion = ["inner_example"] // [String] | Filter by terms.isLatestVersion (optional)
let filterTermsTermsType = ["filterTermsTermsType_example"] // [String] | One of: DEVELOPER, UPLOAD_MARKETPLACE (e.g. `DEVELOPER`) (optional)

// Get multiple acceptedTerms.
AcceptedTermsAPI.acceptedTermsGet(include: include, filterOwnersId: filterOwnersId, filterTermsIsLatestVersion: filterTermsIsLatestVersion, filterTermsTermsType: filterTermsTermsType) { (response, error) in
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
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners, terms | [optional] 
 **filterOwnersId** | [**[String]**](String.md) | User id. Use &#x60;me&#x60; for the authenticated user | [optional] 
 **filterTermsIsLatestVersion** | [**[String]**](String.md) | Filter by terms.isLatestVersion | [optional] 
 **filterTermsTermsType** | [**[String]**](String.md) | One of: DEVELOPER, UPLOAD_MARKETPLACE (e.g. &#x60;DEVELOPER&#x60;) | [optional] 

### Return type

[**AcceptedTermsMultiResourceDataDocument**](AcceptedTermsMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **acceptedTermsIdRelationshipsOwnersGet**
```swift
    open class func acceptedTermsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: AcceptedTermsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Accepted terms id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get owners relationship (\"to-many\").
AcceptedTermsAPI.acceptedTermsIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | Accepted terms id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**AcceptedTermsMultiRelationshipDataDocument**](AcceptedTermsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **acceptedTermsIdRelationshipsTermsGet**
```swift
    open class func acceptedTermsIdRelationshipsTermsGet(id: String, include: [String]? = nil, completion: @escaping (_ data: AcceptedTermsSingleRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get terms relationship (\"to-one\").

Retrieves terms relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Accepted terms id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: terms (optional)

// Get terms relationship (\"to-one\").
AcceptedTermsAPI.acceptedTermsIdRelationshipsTermsGet(id: id, include: include) { (response, error) in
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
 **id** | **String** | Accepted terms id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: terms | [optional] 

### Return type

[**AcceptedTermsSingleRelationshipDataDocument**](AcceptedTermsSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **acceptedTermsPost**
```swift
    open class func acceptedTermsPost(idempotencyKey: String? = nil, acceptedTermsCreateOperationPayload: AcceptedTermsCreateOperationPayload? = nil, completion: @escaping (_ data: AcceptedTermsSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Create single acceptedTerm.

Creates a new acceptedTerm.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. (optional)
let acceptedTermsCreateOperationPayload = AcceptedTermsCreateOperation_Payload(data: AcceptedTermsCreateOperation_Payload_Data(relationships: AcceptedTermsCreateOperation_Payload_Data_Relationships(terms: AcceptedTermsCreateOperation_Payload_Data_Relationships_Terms(data: AcceptedTermsCreateOperation_Payload_Data_Relationships_Terms_Data(id: "id_example", type: "type_example"))), type: "type_example")) // AcceptedTermsCreateOperationPayload |  (optional)

// Create single acceptedTerm.
AcceptedTermsAPI.acceptedTermsPost(idempotencyKey: idempotencyKey, acceptedTermsCreateOperationPayload: acceptedTermsCreateOperationPayload) { (response, error) in
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
 **acceptedTermsCreateOperationPayload** | [**AcceptedTermsCreateOperationPayload**](AcceptedTermsCreateOperationPayload.md) |  | [optional] 

### Return type

[**AcceptedTermsSingleResourceDataDocument**](AcceptedTermsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

