# FolderItemsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**folderItemsGet**](FolderItemsAPI.md#folderitemsget) | **GET** /folderItems | Get multiple folderItems.
[**folderItemsIdDelete**](FolderItemsAPI.md#folderitemsiddelete) | **DELETE** /folderItems/{id} | Delete single folderItem.
[**folderItemsIdGet**](FolderItemsAPI.md#folderitemsidget) | **GET** /folderItems/{id} | Get single folderItem.
[**folderItemsIdRelationshipsBreadcrumbGet**](FolderItemsAPI.md#folderitemsidrelationshipsbreadcrumbget) | **GET** /folderItems/{id}/relationships/breadcrumb | Get breadcrumb relationship (\&quot;to-many\&quot;).
[**folderItemsIdRelationshipsOwnersGet**](FolderItemsAPI.md#folderitemsidrelationshipsownersget) | **GET** /folderItems/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
[**folderItemsIdRelationshipsParentGet**](FolderItemsAPI.md#folderitemsidrelationshipsparentget) | **GET** /folderItems/{id}/relationships/parent | Get parent relationship (\&quot;to-one\&quot;).
[**folderItemsIdRelationshipsParentPatch**](FolderItemsAPI.md#folderitemsidrelationshipsparentpatch) | **PATCH** /folderItems/{id}/relationships/parent | Update parent relationship (\&quot;to-one\&quot;).
[**folderItemsIdRelationshipsSubjectGet**](FolderItemsAPI.md#folderitemsidrelationshipssubjectget) | **GET** /folderItems/{id}/relationships/subject | Get subject relationship (\&quot;to-one\&quot;).
[**folderItemsPost**](FolderItemsAPI.md#folderitemspost) | **POST** /folderItems | Create single folderItem.


# **folderItemsGet**
```swift
    open class func folderItemsGet(filterParentId: String? = nil, filterParentIsRoot: String? = nil, filterParentOwnersId: String? = nil, filterQuery: String? = nil, filterSubjectAlbumsPublished: String? = nil, filterSubjectOwnersId: String? = nil, filterSubjectOwnersIdNe: String? = nil, include: [String]? = nil, includeLinkage: [IncludeLinkage_folderItemsGet]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil, completion: @escaping (_ data: FolderItemsMultiResourceDataDocument?, _ error: Error?) -> Void)
```

Get multiple folderItems.

Lists items in a folder, newest placement first. Select a folder with parent.id, or select your root with parent.isRoot=true and parent.owners.id=me. These forms cannot be combined; no other parent-filter combinations are supported. To search every folder in your tree instead, use query, subject.albums:published or both with parent.owners.id=me alone.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let filterParentId = "filterParentId_example" // String | Folder id (e.g. `e3226624-355b-48f8-aa93-db42532caa66`). Also accepts `me`. (optional)
let filterParentIsRoot = "filterParentIsRoot_example" // String | Filter by parent.isRoot (optional)
let filterParentOwnersId = "filterParentOwnersId_example" // String | Owner of the folder an item is in; must be the authenticated user. With parent.isRoot=true it selects your root, and with query or subject.albums:published your whole tree. Also accepts `me`. (optional)
let filterQuery = "filterQuery_example" // String | Searches every folder in your tree, selected with parent.owners.id=me, and lists the matching items in one flat list. An item matches when each word given starts a word in its folder's name, its album's title or the title of one of the album's tracks, ignoring case. An item shared with you matches by its subject, and only while you can open it. (e.g. `demo`) (optional)
let filterSubjectAlbumsPublished = "filterSubjectAlbumsPublished_example" // String | Searches every folder in your tree, selected with parent.owners.id=me, for albums that are (true) or are not (false) published, and lists them in one flat list. Other items never match. Combines with query. (e.g. `true`) (optional)
let filterSubjectOwnersId = "filterSubjectOwnersId_example" // String | In your folders, `=me` selects owned placements and `[ne]=me` selects shared placements. In someone else's folder, `=me` returns no items and `[ne]=me` returns all items. Accepts only `me` or your own user ID. (optional)
let filterSubjectOwnersIdNe = "filterSubjectOwnersIdNe_example" // String | In your folders, `=me` selects owned placements and `[ne]=me` selects shared placements. In someone else's folder, `=me` returns no items and `[ne]=me` returns all items. Accepts only `me` or your own user ID. (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: breadcrumb, owners, parent, subject (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: breadcrumb.children.subject (optional)

// Get multiple folderItems.
FolderItemsAPI.folderItemsGet(filterParentId: filterParentId, filterParentIsRoot: filterParentIsRoot, filterParentOwnersId: filterParentOwnersId, filterQuery: filterQuery, filterSubjectAlbumsPublished: filterSubjectAlbumsPublished, filterSubjectOwnersId: filterSubjectOwnersId, filterSubjectOwnersIdNe: filterSubjectOwnersIdNe, include: include, includeLinkage: includeLinkage, pageCursor: pageCursor, replaceMedia: replaceMedia) { (response, error) in
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
 **filterParentId** | **String** | Folder id (e.g. &#x60;e3226624-355b-48f8-aa93-db42532caa66&#x60;). Also accepts &#x60;me&#x60;. | [optional] 
 **filterParentIsRoot** | **String** | Filter by parent.isRoot | [optional] 
 **filterParentOwnersId** | **String** | Owner of the folder an item is in; must be the authenticated user. With parent.isRoot&#x3D;true it selects your root, and with query or subject.albums:published your whole tree. Also accepts &#x60;me&#x60;. | [optional] 
 **filterQuery** | **String** | Searches every folder in your tree, selected with parent.owners.id&#x3D;me, and lists the matching items in one flat list. An item matches when each word given starts a word in its folder&#39;s name, its album&#39;s title or the title of one of the album&#39;s tracks, ignoring case. An item shared with you matches by its subject, and only while you can open it. (e.g. &#x60;demo&#x60;) | [optional] 
 **filterSubjectAlbumsPublished** | **String** | Searches every folder in your tree, selected with parent.owners.id&#x3D;me, for albums that are (true) or are not (false) published, and lists them in one flat list. Other items never match. Combines with query. (e.g. &#x60;true&#x60;) | [optional] 
 **filterSubjectOwnersId** | **String** | In your folders, &#x60;&#x3D;me&#x60; selects owned placements and &#x60;[ne]&#x3D;me&#x60; selects shared placements. In someone else&#39;s folder, &#x60;&#x3D;me&#x60; returns no items and &#x60;[ne]&#x3D;me&#x60; returns all items. Accepts only &#x60;me&#x60; or your own user ID. | [optional] 
 **filterSubjectOwnersIdNe** | **String** | In your folders, &#x60;&#x3D;me&#x60; selects owned placements and &#x60;[ne]&#x3D;me&#x60; selects shared placements. In someone else&#39;s folder, &#x60;&#x3D;me&#x60; returns no items and &#x60;[ne]&#x3D;me&#x60; returns all items. Accepts only &#x60;me&#x60; or your own user ID. | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: breadcrumb, owners, parent, subject | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: breadcrumb.children.subject | [optional] 

### Return type

[**FolderItemsMultiResourceDataDocument**](FolderItemsMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

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
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)

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
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 

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
    open class func folderItemsIdGet(id: String, include: [String]? = nil, includeLinkage: [IncludeLinkage_folderItemsIdGet]? = nil, replaceMedia: String? = nil, completion: @escaping (_ data: FolderItemsSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single folderItem.

Retrieves single folderItem by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Folder item id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: breadcrumb, owners, parent, subject (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: breadcrumb.children.subject (optional)

// Get single folderItem.
FolderItemsAPI.folderItemsIdGet(id: id, include: include, includeLinkage: includeLinkage, replaceMedia: replaceMedia) { (response, error) in
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
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: breadcrumb, owners, parent, subject | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: breadcrumb.children.subject | [optional] 

### Return type

[**FolderItemsSingleResourceDataDocument**](FolderItemsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **folderItemsIdRelationshipsBreadcrumbGet**
```swift
    open class func folderItemsIdRelationshipsBreadcrumbGet(id: String, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil, completion: @escaping (_ data: FolderItemsBreadcrumbMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get breadcrumb relationship (\"to-many\").

The folders from the root to this item's parent; only for the tree's owner, empty otherwise.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Folder item id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: breadcrumb (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: breadcrumb.children.subject (optional)

// Get breadcrumb relationship (\"to-many\").
FolderItemsAPI.folderItemsIdRelationshipsBreadcrumbGet(id: id, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia) { (response, error) in
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
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: breadcrumb | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: breadcrumb.children.subject | [optional] 

### Return type

[**FolderItemsBreadcrumbMultiRelationshipDataDocument**](FolderItemsBreadcrumbMultiRelationshipDataDocument.md)

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
let include = ["inner_example"] // [String] | Include related resources. Available relationships: owners (optional)
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
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: owners | [optional] 
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
let include = ["inner_example"] // [String] | Include related resources. Available relationships: parent (optional)
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
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: parent | [optional] 
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

Moves the item to the supplied parent folder, replacing its previous parent. To move to the top level, supply the root folder explicitly; null data is rejected. Returns the new parent linkage.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Folder item id
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
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
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
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
let include = ["inner_example"] // [String] | Include related resources. Available relationships: subject (optional)
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
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: subject | [optional] 
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

let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
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
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **folderItemsCreateOperationPayload** | [**FolderItemsCreateOperationPayload**](FolderItemsCreateOperationPayload.md) |  | [optional] 

### Return type

[**FolderItemsCreateSingleResourceDataDocument**](FolderItemsCreateSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

