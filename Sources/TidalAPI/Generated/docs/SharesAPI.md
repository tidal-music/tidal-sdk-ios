# SharesAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**sharesGet**](SharesAPI.md#sharesget) | **GET** /shares | Get multiple shares.
[**sharesIdGet**](SharesAPI.md#sharesidget) | **GET** /shares/{id} | Get single share.
[**sharesIdRelationshipsOwnersGet**](SharesAPI.md#sharesidrelationshipsownersget) | **GET** /shares/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
[**sharesIdRelationshipsSharedResourcesGet**](SharesAPI.md#sharesidrelationshipssharedresourcesget) | **GET** /shares/{id}/relationships/sharedResources | Get sharedResources relationship (\&quot;to-many\&quot;).
[**sharesPost**](SharesAPI.md#sharespost) | **POST** /shares | Create single share.


# **sharesGet**
```swift
    open class func sharesGet(include: [String]? = nil, filterCode: [String]? = nil, filterId: [String]? = nil, completion: @escaping (_ data: SharesMultiResourceDataDocument?, _ error: Error?) -> Void)
```

Get multiple shares.

Retrieves multiple shares by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners, sharedResources (optional)
let filterCode = ["inner_example"] // [String] | A share code (e.g. `xyz`) (optional)
let filterId = ["inner_example"] // [String] | List of shares IDs (e.g. `a468bee88def`) (optional)

// Get multiple shares.
SharesAPI.sharesGet(include: include, filterCode: filterCode, filterId: filterId) { (response, error) in
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
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners, sharedResources | [optional] 
 **filterCode** | [**[String]**](String.md) | A share code (e.g. &#x60;xyz&#x60;) | [optional] 
 **filterId** | [**[String]**](String.md) | List of shares IDs (e.g. &#x60;a468bee88def&#x60;) | [optional] 

### Return type

[**SharesMultiResourceDataDocument**](SharesMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **sharesIdGet**
```swift
    open class func sharesIdGet(id: String, include: [String]? = nil, completion: @escaping (_ data: SharesSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single share.

Retrieves single share by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User share id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners, sharedResources (optional)

// Get single share.
SharesAPI.sharesIdGet(id: id, include: include) { (response, error) in
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
 **id** | **String** | User share id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners, sharedResources | [optional] 

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
    open class func sharesIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: SharesMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User share id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get owners relationship (\"to-many\").
SharesAPI.sharesIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | User share id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**SharesMultiRelationshipDataDocument**](SharesMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **sharesIdRelationshipsSharedResourcesGet**
```swift
    open class func sharesIdRelationshipsSharedResourcesGet(id: String, pageCursor: String? = nil, include: [String]? = nil, completion: @escaping (_ data: SharesMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get sharedResources relationship (\"to-many\").

Retrieves sharedResources relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User share id
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: sharedResources (optional)

// Get sharedResources relationship (\"to-many\").
SharesAPI.sharesIdRelationshipsSharedResourcesGet(id: id, pageCursor: pageCursor, include: include) { (response, error) in
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
 **id** | **String** | User share id | 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: sharedResources | [optional] 

### Return type

[**SharesMultiRelationshipDataDocument**](SharesMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **sharesPost**
```swift
    open class func sharesPost(sharesCreateOperationPayload: SharesCreateOperationPayload? = nil, completion: @escaping (_ data: SharesSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Create single share.

Creates a new share.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let sharesCreateOperationPayload = SharesCreateOperation_Payload(data: SharesCreateOperation_Payload_Data(relationships: SharesCreateOperation_Payload_Data_Relationships(sharedResources: SharesCreateOperation_Payload_Data_Relationships_SharedResources(data: [SharesCreateOperation_Payload_Data_Relationships_SharedResources_Data(id: "id_example", type: "type_example")])), type: "type_example")) // SharesCreateOperationPayload |  (optional)

// Create single share.
SharesAPI.sharesPost(sharesCreateOperationPayload: sharesCreateOperationPayload) { (response, error) in
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
 **sharesCreateOperationPayload** | [**SharesCreateOperationPayload**](SharesCreateOperationPayload.md) |  | [optional] 

### Return type

[**SharesSingleResourceDataDocument**](SharesSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

