# FoldersAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**foldersGet**](FoldersAPI.md#foldersget) | **GET** /folders | Get multiple folders.
[**foldersIdDelete**](FoldersAPI.md#foldersiddelete) | **DELETE** /folders/{id} | Delete single folder.
[**foldersIdGet**](FoldersAPI.md#foldersidget) | **GET** /folders/{id} | Get single folder.
[**foldersIdPatch**](FoldersAPI.md#foldersidpatch) | **PATCH** /folders/{id} | Update single folder.
[**foldersIdRelationshipsChildrenGet**](FoldersAPI.md#foldersidrelationshipschildrenget) | **GET** /folders/{id}/relationships/children | Get children relationship (\&quot;to-many\&quot;).
[**foldersIdRelationshipsOwnersGet**](FoldersAPI.md#foldersidrelationshipsownersget) | **GET** /folders/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
[**foldersIdRelationshipsParentGet**](FoldersAPI.md#foldersidrelationshipsparentget) | **GET** /folders/{id}/relationships/parent | Get parent relationship (\&quot;to-one\&quot;).
[**foldersIdRelationshipsPreviewGet**](FoldersAPI.md#foldersidrelationshipspreviewget) | **GET** /folders/{id}/relationships/preview | Get preview relationship (\&quot;to-many\&quot;).
[**foldersPost**](FoldersAPI.md#folderspost) | **POST** /folders | Create single folder.


# **foldersGet**
```swift
    open class func foldersGet(filterId: [String], include: [String]? = nil, includeLinkage: [IncludeLinkage_foldersGet]? = nil, replaceMedia: String? = nil, completion: @escaping (_ data: FoldersMultiResourceDataDocument?, _ error: Error?) -> Void)
```

Get multiple folders.

Retrieves multiple folders by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let filterId = ["inner_example"] // [String] | Folder id (e.g. `e3226624-355b-48f8-aa93-db42532caa66`)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: children, owners, parent, preview (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: children.subject (optional)

// Get multiple folders.
FoldersAPI.foldersGet(filterId: filterId, include: include, includeLinkage: includeLinkage, replaceMedia: replaceMedia) { (response, error) in
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
 **filterId** | [**[String]**](String.md) | Folder id (e.g. &#x60;e3226624-355b-48f8-aa93-db42532caa66&#x60;) | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: children, owners, parent, preview | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: children.subject | [optional] 

### Return type

[**FoldersMultiResourceDataDocument**](FoldersMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **foldersIdDelete**
```swift
    open class func foldersIdDelete(id: String, idempotencyKey: String? = nil, completion: @escaping (_ data: MutationResponseDocument?, _ error: Error?) -> Void)
```

Delete single folder.

Deletes existing folder.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Folder id. Use `me` for the authenticated user's resource
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. (optional)

// Delete single folder.
FoldersAPI.foldersIdDelete(id: id, idempotencyKey: idempotencyKey) { (response, error) in
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
 **id** | **String** | Folder id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. | [optional] 

### Return type

[**MutationResponseDocument**](MutationResponseDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **foldersIdGet**
```swift
    open class func foldersIdGet(id: String, include: [String]? = nil, includeLinkage: [IncludeLinkage_foldersIdGet]? = nil, replaceMedia: String? = nil, completion: @escaping (_ data: FoldersSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single folder.

Retrieves single folder by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Folder id. Use `me` for the authenticated user's resource
let include = ["inner_example"] // [String] | Include related resources. Available relationships: children, owners, parent, preview (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: children.subject (optional)

// Get single folder.
FoldersAPI.foldersIdGet(id: id, include: include, includeLinkage: includeLinkage, replaceMedia: replaceMedia) { (response, error) in
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
 **id** | **String** | Folder id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: children, owners, parent, preview | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: children.subject | [optional] 

### Return type

[**FoldersSingleResourceDataDocument**](FoldersSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **foldersIdPatch**
```swift
    open class func foldersIdPatch(id: String, idempotencyKey: String? = nil, foldersUpdateOperationPayload: FoldersUpdateOperationPayload? = nil, completion: @escaping (_ data: FoldersUpdateSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Update single folder.

Updates existing folder.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Folder id. Use `me` for the authenticated user's resource
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. (optional)
let foldersUpdateOperationPayload = FoldersUpdateOperation_Payload(data: FoldersUpdateOperation_Payload_Data(attributes: FoldersUpdateOperation_Payload_Data_Attributes(name: "name_example"), id: "id_example", type: "type_example")) // FoldersUpdateOperationPayload |  (optional)

// Update single folder.
FoldersAPI.foldersIdPatch(id: id, idempotencyKey: idempotencyKey, foldersUpdateOperationPayload: foldersUpdateOperationPayload) { (response, error) in
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
 **id** | **String** | Folder id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. | [optional] 
 **foldersUpdateOperationPayload** | [**FoldersUpdateOperationPayload**](FoldersUpdateOperationPayload.md) |  | [optional] 

### Return type

[**FoldersUpdateSingleResourceDataDocument**](FoldersUpdateSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **foldersIdRelationshipsChildrenGet**
```swift
    open class func foldersIdRelationshipsChildrenGet(id: String, pageCursor: String? = nil, include: [String]? = nil, replaceMedia: String? = nil, completion: @escaping (_ data: FoldersChildrenMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get children relationship (\"to-many\").

Lists folder items newest first by placement timestamp, with ID as a stable tie-breaker. Moving to another parent resets the timestamp; renaming preserves it.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Folder id. Use `me` for the authenticated user's resource
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: children (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: children.subject (optional)

// Get children relationship (\"to-many\").
FoldersAPI.foldersIdRelationshipsChildrenGet(id: id, pageCursor: pageCursor, include: include, replaceMedia: replaceMedia) { (response, error) in
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
 **id** | **String** | Folder id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: children | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: children.subject | [optional] 

### Return type

[**FoldersChildrenMultiRelationshipDataDocument**](FoldersChildrenMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **foldersIdRelationshipsOwnersGet**
```swift
    open class func foldersIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: FoldersOwnersMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Folder id. Use `me` for the authenticated user's resource
let include = ["inner_example"] // [String] | Include related resources. Available relationships: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get owners relationship (\"to-many\").
FoldersAPI.foldersIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | Folder id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**FoldersOwnersMultiRelationshipDataDocument**](FoldersOwnersMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **foldersIdRelationshipsParentGet**
```swift
    open class func foldersIdRelationshipsParentGet(id: String, include: [String]? = nil, replaceMedia: String? = nil, completion: @escaping (_ data: FoldersParentSingleRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get parent relationship (\"to-one\").

Retrieves parent relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Folder id. Use `me` for the authenticated user's resource
let include = ["inner_example"] // [String] | Include related resources. Available relationships: parent (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: parent.children.subject (optional)

// Get parent relationship (\"to-one\").
FoldersAPI.foldersIdRelationshipsParentGet(id: id, include: include, replaceMedia: replaceMedia) { (response, error) in
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
 **id** | **String** | Folder id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: parent | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: parent.children.subject | [optional] 

### Return type

[**FoldersParentSingleRelationshipDataDocument**](FoldersParentSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **foldersIdRelationshipsPreviewGet**
```swift
    open class func foldersIdRelationshipsPreviewGet(id: String, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil, completion: @escaping (_ data: FoldersPreviewMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get preview relationship (\"to-many\").

The first four items of this folder, as `children` lists them.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Folder id. Use `me` for the authenticated user's resource
let include = ["inner_example"] // [String] | Include related resources. Available relationships: preview (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: preview.subject (optional)

// Get preview relationship (\"to-many\").
FoldersAPI.foldersIdRelationshipsPreviewGet(id: id, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia) { (response, error) in
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
 **id** | **String** | Folder id. Use &#x60;me&#x60; for the authenticated user&#39;s resource | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: preview | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: preview.subject | [optional] 

### Return type

[**FoldersPreviewMultiRelationshipDataDocument**](FoldersPreviewMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **foldersPost**
```swift
    open class func foldersPost(idempotencyKey: String? = nil, foldersCreateOperationPayload: FoldersCreateOperationPayload? = nil, completion: @escaping (_ data: FoldersCreateSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Create single folder.

Creates a new folder.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. (optional)
let foldersCreateOperationPayload = FoldersCreateOperation_Payload(data: FoldersCreateOperation_Payload_Data(attributes: FoldersCreateOperation_Payload_Data_Attributes(name: "name_example"), relationships: FoldersCreateOperation_Payload_Data_Relationships(parent: FoldersCreateOperation_Payload_Data_Relationships_Parent(data: FoldersParentIdentifier(id: "id_example", type: "type_example"))), type: "type_example")) // FoldersCreateOperationPayload |  (optional)

// Create single folder.
FoldersAPI.foldersPost(idempotencyKey: idempotencyKey, foldersCreateOperationPayload: foldersCreateOperationPayload) { (response, error) in
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
 **foldersCreateOperationPayload** | [**FoldersCreateOperationPayload**](FoldersCreateOperationPayload.md) |  | [optional] 

### Return type

[**FoldersCreateSingleResourceDataDocument**](FoldersCreateSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

