# UserDataExportsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**userDataExportsGet**](UserDataExportsAPI.md#userdataexportsget) | **GET** /userDataExports | Get multiple userDataExports.
[**userDataExportsIdGet**](UserDataExportsAPI.md#userdataexportsidget) | **GET** /userDataExports/{id} | Get single userDataExport.
[**userDataExportsIdRelationshipsOwnersGet**](UserDataExportsAPI.md#userdataexportsidrelationshipsownersget) | **GET** /userDataExports/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
[**userDataExportsPost**](UserDataExportsAPI.md#userdataexportspost) | **POST** /userDataExports | Create single userDataExport.


# **userDataExportsGet**
```swift
    open class func userDataExportsGet(filterOwnersId: [String], include: [String]? = nil, includeLinkage: [IncludeLinkage_userDataExportsGet]? = nil, pageCursor: String? = nil) async throws -> UserDataExportsMultiResourceDataDocument
```

Get multiple userDataExports.

Lists the authenticated user's exports, newest first.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let filterOwnersId = ["inner_example"] // [String] | The authenticated user; exports of other users are never listed. Also accepts `me`.
let include = ["inner_example"] // [String] | Include related resources. Available relationships: owners (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get multiple userDataExports.
do {
    let response = try await UserDataExportsAPI.userDataExportsGet(filterOwnersId: filterOwnersId, include: include, includeLinkage: includeLinkage, pageCursor: pageCursor)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **filterOwnersId** | [**[String]**](String.md) | The authenticated user; exports of other users are never listed. Also accepts &#x60;me&#x60;. | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: owners | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**UserDataExportsMultiResourceDataDocument**](UserDataExportsMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userDataExportsIdGet**
```swift
    open class func userDataExportsIdGet(id: String, include: [String]? = nil, includeLinkage: [IncludeLinkage_userDataExportsIdGet]? = nil) async throws -> UserDataExportsSingleResourceDataDocument
```

Get single userDataExport.

Retrieves single userDataExport by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | 
let include = ["inner_example"] // [String] | Include related resources. Available relationships: owners (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)

// Get single userDataExport.
do {
    let response = try await UserDataExportsAPI.userDataExportsIdGet(id: id, include: include, includeLinkage: includeLinkage)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** |  | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: owners | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 

### Return type

[**UserDataExportsSingleResourceDataDocument**](UserDataExportsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userDataExportsIdRelationshipsOwnersGet**
```swift
    open class func userDataExportsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> UserDataExportsOwnersMultiRelationshipDataDocument
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | 
let include = ["inner_example"] // [String] | Include related resources. Available relationships: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get owners relationship (\"to-many\").
do {
    let response = try await UserDataExportsAPI.userDataExportsIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** |  | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**UserDataExportsOwnersMultiRelationshipDataDocument**](UserDataExportsOwnersMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userDataExportsPost**
```swift
    open class func userDataExportsPost(idempotencyKey: String? = nil, userDataExportsCreateOperationPayload: UserDataExportsCreateOperationPayload? = nil) async throws -> UserDataExportsCreateSingleResourceDataDocument
```

Create single userDataExport.

Requests an export of the selected data types of the authenticated user's data, or returns the export already in progress as it was requested.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let userDataExportsCreateOperationPayload = UserDataExportsCreateOperation_Payload(data: UserDataExportsCreateOperation_Payload_Data(attributes: UserDataExportsCreateOperation_Payload_Data_Attributes(dataTypes: ["dataTypes_example"]), type: "type_example"), meta: UserDataExportsCreateOperation_Payload_Meta(locale: "locale_example")) // UserDataExportsCreateOperationPayload |  (optional)

// Create single userDataExport.
do {
    let response = try await UserDataExportsAPI.userDataExportsPost(idempotencyKey: idempotencyKey, userDataExportsCreateOperationPayload: userDataExportsCreateOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **userDataExportsCreateOperationPayload** | [**UserDataExportsCreateOperationPayload**](UserDataExportsCreateOperationPayload.md) |  | [optional] 

### Return type

[**UserDataExportsCreateSingleResourceDataDocument**](UserDataExportsCreateSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

