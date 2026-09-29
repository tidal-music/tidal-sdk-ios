# FolderItemsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**folderItemsIdDelete**](FolderItemsAPI.md#folderitemsiddelete) | **DELETE** /folderItems/{id} | Delete single folderItem.
[**folderItemsIdGet**](FolderItemsAPI.md#folderitemsidget) | **GET** /folderItems/{id} | Get single folderItem.
[**folderItemsIdRelationshipsOwnersGet**](FolderItemsAPI.md#folderitemsidrelationshipsownersget) | **GET** /folderItems/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
[**folderItemsIdRelationshipsParentGet**](FolderItemsAPI.md#folderitemsidrelationshipsparentget) | **GET** /folderItems/{id}/relationships/parent | Get parent relationship (\&quot;to-one\&quot;).
[**folderItemsIdRelationshipsParentPatch**](FolderItemsAPI.md#folderitemsidrelationshipsparentpatch) | **PATCH** /folderItems/{id}/relationships/parent | Update parent relationship (\&quot;to-one\&quot;).
[**folderItemsIdRelationshipsSubjectGet**](FolderItemsAPI.md#folderitemsidrelationshipssubjectget) | **GET** /folderItems/{id}/relationships/subject | Get subject relationship (\&quot;to-one\&quot;).
[**folderItemsPost**](FolderItemsAPI.md#folderitemspost) | **POST** /folderItems | Create single folderItem.


# **folderItemsIdDelete**
```swift
    open class func folderItemsIdDelete(id: String, idempotencyKey: String? = nil, completion: @escaping (_ data: MutationResponseDocument?, _ error: Error?) -> Void)
```

Delete single folderItem.

Deletes existing folderItem.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Folder item id
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. (optional)

// Delete single folderItem.
FolderItemsAPI.folderItemsIdDelete(id: id, idempotencyKey: idempotencyKey) { (response, error) in
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
 **id** | **String** | Folder item id | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. | [optional] 

### Return type

[**MutationResponseDocument**](MutationResponseDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **folderItemsIdGet**
```swift
    open class func folderItemsIdGet(id: String, include: [String]? = nil, replaceMedia: String? = nil, completion: @escaping (_ data: FolderItemsSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single folderItem.

Retrieves single folderItem by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Folder item id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners, parent, subject (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: parent.children.subject (optional)

// Get single folderItem.
FolderItemsAPI.folderItemsIdGet(id: id, include: include, replaceMedia: replaceMedia) { (response, error) in
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
 **id** | **String** | Folder item id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners, parent, subject | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: parent.children.subject | [optional] 

### Return type

[**FolderItemsSingleResourceDataDocument**](FolderItemsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **folderItemsIdRelationshipsOwnersGet**
```swift
    open class func folderItemsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: FolderItemsOwnersMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Folder item id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get owners relationship (\"to-many\").
FolderItemsAPI.folderItemsIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | Folder item id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**FolderItemsOwnersMultiRelationshipDataDocument**](FolderItemsOwnersMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **folderItemsIdRelationshipsParentGet**
```swift
    open class func folderItemsIdRelationshipsParentGet(id: String, include: [String]? = nil, replaceMedia: String? = nil, completion: @escaping (_ data: FolderItemsParentSingleRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get parent relationship (\"to-one\").

Retrieves parent relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Folder item id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: parent (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: parent.children.subject (optional)

// Get parent relationship (\"to-one\").
FolderItemsAPI.folderItemsIdRelationshipsParentGet(id: id, include: include, replaceMedia: replaceMedia) { (response, error) in
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
 **id** | **String** | Folder item id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: parent | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: parent.children.subject | [optional] 

### Return type

[**FolderItemsParentSingleRelationshipDataDocument**](FolderItemsParentSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **folderItemsIdRelationshipsParentPatch**
```swift
    open class func folderItemsIdRelationshipsParentPatch(id: String, idempotencyKey: String? = nil, folderItemsParentRelationshipUpdateOperationPayload: FolderItemsParentRelationshipUpdateOperationPayload? = nil, completion: @escaping (_ data: FolderItemsParentUpdateSingleRelationshipDataDocument?, _ error: Error?) -> Void)
```

Update parent relationship (\"to-one\").

Updates parent relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Folder item id
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. (optional)
let folderItemsParentRelationshipUpdateOperationPayload = FolderItemsParentRelationshipUpdateOperation_Payload(data: FolderItemsParentRelationshipUpdateOperation_Payload_Data(id: "id_example", type: "type_example")) // FolderItemsParentRelationshipUpdateOperationPayload |  (optional)

// Update parent relationship (\"to-one\").
FolderItemsAPI.folderItemsIdRelationshipsParentPatch(id: id, idempotencyKey: idempotencyKey, folderItemsParentRelationshipUpdateOperationPayload: folderItemsParentRelationshipUpdateOperationPayload) { (response, error) in
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
 **id** | **String** | Folder item id | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. | [optional] 
 **folderItemsParentRelationshipUpdateOperationPayload** | [**FolderItemsParentRelationshipUpdateOperationPayload**](FolderItemsParentRelationshipUpdateOperationPayload.md) |  | [optional] 

### Return type

[**FolderItemsParentUpdateSingleRelationshipDataDocument**](FolderItemsParentUpdateSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **folderItemsIdRelationshipsSubjectGet**
```swift
    open class func folderItemsIdRelationshipsSubjectGet(id: String, include: [String]? = nil, replaceMedia: String? = nil, completion: @escaping (_ data: FolderItemsSubjectSingleRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get subject relationship (\"to-one\").

Retrieves subject relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Folder item id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: subject (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: subject (optional)

// Get subject relationship (\"to-one\").
FolderItemsAPI.folderItemsIdRelationshipsSubjectGet(id: id, include: include, replaceMedia: replaceMedia) { (response, error) in
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
 **id** | **String** | Folder item id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: subject | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: subject | [optional] 

### Return type

[**FolderItemsSubjectSingleRelationshipDataDocument**](FolderItemsSubjectSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **folderItemsPost**
```swift
    open class func folderItemsPost(idempotencyKey: String? = nil, folderItemsCreateOperationPayload: FolderItemsCreateOperationPayload? = nil, completion: @escaping (_ data: FolderItemsCreateSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Create single folderItem.

Creates a new folderItem.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. (optional)
let folderItemsCreateOperationPayload = FolderItemsCreateOperation_Payload(data: FolderItemsCreateOperation_Payload_Data(relationships: FolderItemsCreateOperation_Payload_Data_Relationships(parent: FolderItemsCreateOperation_Payload_Data_Relationships_Parent(data: FolderItemsCreateOperation_Payload_Data_Relationships_Parent_Data(id: "id_example", type: "type_example")), subject: FolderItemsCreateOperation_Payload_Data_Relationships_Subject(data: FolderItemsCreateOperation_Payload_Data_Relationships_Subject_Data(id: "id_example", type: "type_example"))), type: "type_example")) // FolderItemsCreateOperationPayload |  (optional)

// Create single folderItem.
FolderItemsAPI.folderItemsPost(idempotencyKey: idempotencyKey, folderItemsCreateOperationPayload: folderItemsCreateOperationPayload) { (response, error) in
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
 **folderItemsCreateOperationPayload** | [**FolderItemsCreateOperationPayload**](FolderItemsCreateOperationPayload.md) |  | [optional] 

### Return type

[**FolderItemsCreateSingleResourceDataDocument**](FolderItemsCreateSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

