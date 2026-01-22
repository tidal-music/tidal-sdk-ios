# UserCollectionFoldersAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**userCollectionFoldersGet**](UserCollectionFoldersAPI.md#usercollectionfoldersget) | **GET** /userCollectionFolders | Get multiple userCollectionFolders.
[**userCollectionFoldersIdDelete**](UserCollectionFoldersAPI.md#usercollectionfoldersiddelete) | **DELETE** /userCollectionFolders/{id} | Delete single userCollectionFolder.
[**userCollectionFoldersIdGet**](UserCollectionFoldersAPI.md#usercollectionfoldersidget) | **GET** /userCollectionFolders/{id} | Get single userCollectionFolder.
[**userCollectionFoldersIdPatch**](UserCollectionFoldersAPI.md#usercollectionfoldersidpatch) | **PATCH** /userCollectionFolders/{id} | Update single userCollectionFolder.
[**userCollectionFoldersIdRelationshipsItemsDelete**](UserCollectionFoldersAPI.md#usercollectionfoldersidrelationshipsitemsdelete) | **DELETE** /userCollectionFolders/{id}/relationships/items | Delete from items relationship (\&quot;to-many\&quot;).
[**userCollectionFoldersIdRelationshipsItemsGet**](UserCollectionFoldersAPI.md#usercollectionfoldersidrelationshipsitemsget) | **GET** /userCollectionFolders/{id}/relationships/items | Get items relationship (\&quot;to-many\&quot;).
[**userCollectionFoldersIdRelationshipsItemsPost**](UserCollectionFoldersAPI.md#usercollectionfoldersidrelationshipsitemspost) | **POST** /userCollectionFolders/{id}/relationships/items | Add to items relationship (\&quot;to-many\&quot;).
[**userCollectionFoldersIdRelationshipsOwnersGet**](UserCollectionFoldersAPI.md#usercollectionfoldersidrelationshipsownersget) | **GET** /userCollectionFolders/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
[**userCollectionFoldersPost**](UserCollectionFoldersAPI.md#usercollectionfolderspost) | **POST** /userCollectionFolders | Create single userCollectionFolder.


# **userCollectionFoldersGet**
```swift
    open class func userCollectionFoldersGet(include: [String]? = nil, filterId: [String]? = nil, completion: @escaping (_ data: UserCollectionFoldersMultiResourceDataDocument?, _ error: Error?) -> Void)
```

Get multiple userCollectionFolders.

Retrieves multiple userCollectionFolders by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: items, owners (optional)
let filterId = ["inner_example"] // [String] | Folder Id (optional)

// Get multiple userCollectionFolders.
UserCollectionFoldersAPI.userCollectionFoldersGet(include: include, filterId: filterId) { (response, error) in
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
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: items, owners | [optional] 
 **filterId** | [**[String]**](String.md) | Folder Id | [optional] 

### Return type

[**UserCollectionFoldersMultiResourceDataDocument**](UserCollectionFoldersMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionFoldersIdDelete**
```swift
    open class func userCollectionFoldersIdDelete(id: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Delete single userCollectionFolder.

Deletes existing userCollectionFolder.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "" // String | Folder Id

// Delete single userCollectionFolder.
UserCollectionFoldersAPI.userCollectionFoldersIdDelete(id: id) { (response, error) in
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
 **id** | **String** | Folder Id | 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionFoldersIdGet**
```swift
    open class func userCollectionFoldersIdGet(id: String, include: [String]? = nil, completion: @escaping (_ data: UserCollectionFoldersSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single userCollectionFolder.

Retrieves single userCollectionFolder by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "" // String | Folder Id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: items, owners (optional)

// Get single userCollectionFolder.
UserCollectionFoldersAPI.userCollectionFoldersIdGet(id: id, include: include) { (response, error) in
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
 **id** | **String** | Folder Id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: items, owners | [optional] 

### Return type

[**UserCollectionFoldersSingleResourceDataDocument**](UserCollectionFoldersSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionFoldersIdPatch**
```swift
    open class func userCollectionFoldersIdPatch(id: String, folderUpdateOperationPayload: FolderUpdateOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Update single userCollectionFolder.

Updates existing userCollectionFolder.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "" // String | Folder Id
let folderUpdateOperationPayload = FolderUpdateOperation_Payload(data: FolderUpdateOperation_Payload_Data(attributes: Attributes(collectionType: "collectionType_example", name: "name_example"), id: "id_example", type: "type_example")) // FolderUpdateOperationPayload |  (optional)

// Update single userCollectionFolder.
UserCollectionFoldersAPI.userCollectionFoldersIdPatch(id: id, folderUpdateOperationPayload: folderUpdateOperationPayload) { (response, error) in
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
 **id** | **String** | Folder Id | 
 **folderUpdateOperationPayload** | [**FolderUpdateOperationPayload**](FolderUpdateOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionFoldersIdRelationshipsItemsDelete**
```swift
    open class func userCollectionFoldersIdRelationshipsItemsDelete(id: String, userCollectionFoldersItemsRelationshipRemoveOperationPayload: UserCollectionFoldersItemsRelationshipRemoveOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Delete from items relationship (\"to-many\").

Deletes item(s) from items relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "" // String | Folder Id
let userCollectionFoldersItemsRelationshipRemoveOperationPayload = UserCollectionFoldersItemsRelationshipRemoveOperation_Payload(data: [UserCollectionFoldersItemsRelationshipRemoveOperation_Payload_Data(id: "id_example", resourceType: "resourceType_example")]) // UserCollectionFoldersItemsRelationshipRemoveOperationPayload |  (optional)

// Delete from items relationship (\"to-many\").
UserCollectionFoldersAPI.userCollectionFoldersIdRelationshipsItemsDelete(id: id, userCollectionFoldersItemsRelationshipRemoveOperationPayload: userCollectionFoldersItemsRelationshipRemoveOperationPayload) { (response, error) in
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
 **id** | **String** | Folder Id | 
 **userCollectionFoldersItemsRelationshipRemoveOperationPayload** | [**UserCollectionFoldersItemsRelationshipRemoveOperationPayload**](UserCollectionFoldersItemsRelationshipRemoveOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionFoldersIdRelationshipsItemsGet**
```swift
    open class func userCollectionFoldersIdRelationshipsItemsGet(id: String, pageCursor: String? = nil, sort: [Sort_userCollectionFoldersIdRelationshipsItemsGet]? = nil, include: [String]? = nil, completion: @escaping (_ data: UserCollectionFoldersItemsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get items relationship (\"to-many\").

Retrieves items relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "" // String | Folder Id
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let sort = ["sort_example"] // [String] | Values prefixed with \"-\" are sorted descending; values without it are sorted ascending. (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: items (optional)

// Get items relationship (\"to-many\").
UserCollectionFoldersAPI.userCollectionFoldersIdRelationshipsItemsGet(id: id, pageCursor: pageCursor, sort: sort, include: include) { (response, error) in
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
 **id** | **String** | Folder Id | 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **sort** | [**[String]**](String.md) | Values prefixed with \&quot;-\&quot; are sorted descending; values without it are sorted ascending. | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: items | [optional] 

### Return type

[**UserCollectionFoldersItemsMultiRelationshipDataDocument**](UserCollectionFoldersItemsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionFoldersIdRelationshipsItemsPost**
```swift
    open class func userCollectionFoldersIdRelationshipsItemsPost(id: String, userCollectionFoldersItemsRelationshipAddOperationPayload: UserCollectionFoldersItemsRelationshipAddOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Add to items relationship (\"to-many\").

Adds item(s) to items relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "" // String | Folder Id
let userCollectionFoldersItemsRelationshipAddOperationPayload = UserCollectionFoldersItemsRelationshipAddOperation_Payload(data: [UserCollectionFoldersItemsRelationshipAddOperation_Payload_Data(id: "id_example", resourceType: "resourceType_example")]) // UserCollectionFoldersItemsRelationshipAddOperationPayload |  (optional)

// Add to items relationship (\"to-many\").
UserCollectionFoldersAPI.userCollectionFoldersIdRelationshipsItemsPost(id: id, userCollectionFoldersItemsRelationshipAddOperationPayload: userCollectionFoldersItemsRelationshipAddOperationPayload) { (response, error) in
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
 **id** | **String** | Folder Id | 
 **userCollectionFoldersItemsRelationshipAddOperationPayload** | [**UserCollectionFoldersItemsRelationshipAddOperationPayload**](UserCollectionFoldersItemsRelationshipAddOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionFoldersIdRelationshipsOwnersGet**
```swift
    open class func userCollectionFoldersIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: UserCollectionFoldersMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "" // String | Folder Id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get owners relationship (\"to-many\").
UserCollectionFoldersAPI.userCollectionFoldersIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | Folder Id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**UserCollectionFoldersMultiRelationshipDataDocument**](UserCollectionFoldersMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionFoldersPost**
```swift
    open class func userCollectionFoldersPost(folderCreateOperationPayload: FolderCreateOperationPayload? = nil, completion: @escaping (_ data: UserCollectionFoldersSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Create single userCollectionFolder.

Creates a new userCollectionFolder.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let folderCreateOperationPayload = FolderCreateOperation_Payload(data: FolderCreateOperation_Payload_Data(attributes: Attributes(collectionType: "collectionType_example", name: "name_example"), type: "type_example")) // FolderCreateOperationPayload |  (optional)

// Create single userCollectionFolder.
UserCollectionFoldersAPI.userCollectionFoldersPost(folderCreateOperationPayload: folderCreateOperationPayload) { (response, error) in
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
 **folderCreateOperationPayload** | [**FolderCreateOperationPayload**](FolderCreateOperationPayload.md) |  | [optional] 

### Return type

[**UserCollectionFoldersSingleResourceDataDocument**](UserCollectionFoldersSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

