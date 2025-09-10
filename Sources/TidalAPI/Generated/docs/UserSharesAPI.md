# UserSharesAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**userSharesGet**](UserSharesAPI.md#usersharesget) | **GET** /userShares | Get multiple userShares.
[**userSharesIdGet**](UserSharesAPI.md#usersharesidget) | **GET** /userShares/{id} | Get single userShare.
[**userSharesIdRelationshipsOwnersGet**](UserSharesAPI.md#usersharesidrelationshipsownersget) | **GET** /userShares/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
[**userSharesIdRelationshipsSharedResourcesGet**](UserSharesAPI.md#usersharesidrelationshipssharedresourcesget) | **GET** /userShares/{id}/relationships/sharedResources | Get sharedResources relationship (\&quot;to-many\&quot;).
[**userSharesPost**](UserSharesAPI.md#usersharespost) | **POST** /userShares | Create single userShare.


# **userSharesGet**
```swift
    open class func userSharesGet(include: [String]? = nil, filterCode: [String]? = nil, filterId: [String]? = nil, completion: @escaping (_ data: UserSharesMultiResourceDataDocument?, _ error: Error?) -> Void)
```

Get multiple userShares.

Retrieves multiple userShares by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners, sharedResources (optional)
let filterCode = ["inner_example"] // [String] | Share code (optional)
let filterId = ["inner_example"] // [String] | User share id (optional)

// Get multiple userShares.
UserSharesAPI.userSharesGet(include: include, filterCode: filterCode, filterId: filterId) { (response, error) in
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
 **filterCode** | [**[String]**](String.md) | Share code | [optional] 
 **filterId** | [**[String]**](String.md) | User share id | [optional] 

### Return type

[**UserSharesMultiResourceDataDocument**](UserSharesMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userSharesIdGet**
```swift
    open class func userSharesIdGet(id: String, include: [String]? = nil, completion: @escaping (_ data: UserSharesSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single userShare.

Retrieves single userShare by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User share id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners, sharedResources (optional)

// Get single userShare.
UserSharesAPI.userSharesIdGet(id: id, include: include) { (response, error) in
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

[**UserSharesSingleResourceDataDocument**](UserSharesSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userSharesIdRelationshipsOwnersGet**
```swift
    open class func userSharesIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: UserSharesMultiRelationshipDataDocument?, _ error: Error?) -> Void)
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
UserSharesAPI.userSharesIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor) { (response, error) in
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

[**UserSharesMultiRelationshipDataDocument**](UserSharesMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userSharesIdRelationshipsSharedResourcesGet**
```swift
    open class func userSharesIdRelationshipsSharedResourcesGet(id: String, pageCursor: String? = nil, include: [String]? = nil, completion: @escaping (_ data: UserSharesMultiRelationshipDataDocument?, _ error: Error?) -> Void)
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
UserSharesAPI.userSharesIdRelationshipsSharedResourcesGet(id: id, pageCursor: pageCursor, include: include) { (response, error) in
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

[**UserSharesMultiRelationshipDataDocument**](UserSharesMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userSharesPost**
```swift
    open class func userSharesPost(userSharesCreateOperationPayload: UserSharesCreateOperationPayload? = nil, completion: @escaping (_ data: UserSharesSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Create single userShare.

Creates a new userShare.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let userSharesCreateOperationPayload = UserSharesCreateOperation_Payload(data: UserSharesCreateOperation_Payload_Data(relationships: UserSharesCreateOperation_Payload_Data_Relationships(sharedResources: UserSharesCreateOperation_Payload_Data_Relationships_SharedResources(data: [UserSharesCreateOperation_Payload_Data_Relationships_SharedResources_Data(id: "id_example", type: "type_example")])), type: "type_example")) // UserSharesCreateOperationPayload |  (optional)

// Create single userShare.
UserSharesAPI.userSharesPost(userSharesCreateOperationPayload: userSharesCreateOperationPayload) { (response, error) in
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
 **userSharesCreateOperationPayload** | [**UserSharesCreateOperationPayload**](UserSharesCreateOperationPayload.md) |  | [optional] 

### Return type

[**UserSharesSingleResourceDataDocument**](UserSharesSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

