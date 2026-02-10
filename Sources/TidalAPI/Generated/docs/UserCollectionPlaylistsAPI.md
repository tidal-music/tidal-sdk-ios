# UserCollectionPlaylistsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**userCollectionPlaylistsIdGet**](UserCollectionPlaylistsAPI.md#usercollectionplaylistsidget) | **GET** /userCollectionPlaylists/{id} | Get single userCollectionPlaylist.
[**userCollectionPlaylistsIdRelationshipsItemsDelete**](UserCollectionPlaylistsAPI.md#usercollectionplaylistsidrelationshipsitemsdelete) | **DELETE** /userCollectionPlaylists/{id}/relationships/items | Delete from items relationship (\&quot;to-many\&quot;).
[**userCollectionPlaylistsIdRelationshipsItemsGet**](UserCollectionPlaylistsAPI.md#usercollectionplaylistsidrelationshipsitemsget) | **GET** /userCollectionPlaylists/{id}/relationships/items | Get items relationship (\&quot;to-many\&quot;).
[**userCollectionPlaylistsIdRelationshipsItemsPost**](UserCollectionPlaylistsAPI.md#usercollectionplaylistsidrelationshipsitemspost) | **POST** /userCollectionPlaylists/{id}/relationships/items | Add to items relationship (\&quot;to-many\&quot;).
[**userCollectionPlaylistsIdRelationshipsOwnersGet**](UserCollectionPlaylistsAPI.md#usercollectionplaylistsidrelationshipsownersget) | **GET** /userCollectionPlaylists/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).


# **userCollectionPlaylistsIdGet**
```swift
    open class func userCollectionPlaylistsIdGet(id: String, countryCode: String? = nil, locale: String? = nil, include: [String]? = nil, completion: @escaping (_ data: UserCollectionPlaylistsSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single userCollectionPlaylist.

Retrieves single userCollectionPlaylist by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection playlists id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let locale = "locale_example" // String | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. (optional) (default to "en-US")
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: items, owners (optional)

// Get single userCollectionPlaylist.
UserCollectionPlaylistsAPI.userCollectionPlaylistsIdGet(id: id, countryCode: countryCode, locale: locale, include: include) { (response, error) in
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
 **id** | **String** | User collection playlists id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **locale** | **String** | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. | [optional] [default to &quot;en-US&quot;]
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: items, owners | [optional] 

### Return type

[**UserCollectionPlaylistsSingleResourceDataDocument**](UserCollectionPlaylistsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionPlaylistsIdRelationshipsItemsDelete**
```swift
    open class func userCollectionPlaylistsIdRelationshipsItemsDelete(id: String, userCollectionPlaylistsItemsRelationshipRemoveOperationPayload: UserCollectionPlaylistsItemsRelationshipRemoveOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Delete from items relationship (\"to-many\").

Deletes item(s) from items relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection playlists id
let userCollectionPlaylistsItemsRelationshipRemoveOperationPayload = UserCollectionPlaylistsItemsRelationshipRemoveOperation_Payload(data: [UserCollectionPlaylistsItemsRelationshipRemoveOperation_Payload_Data(id: "id_example", type: "type_example")]) // UserCollectionPlaylistsItemsRelationshipRemoveOperationPayload |  (optional)

// Delete from items relationship (\"to-many\").
UserCollectionPlaylistsAPI.userCollectionPlaylistsIdRelationshipsItemsDelete(id: id, userCollectionPlaylistsItemsRelationshipRemoveOperationPayload: userCollectionPlaylistsItemsRelationshipRemoveOperationPayload) { (response, error) in
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
 **id** | **String** | User collection playlists id | 
 **userCollectionPlaylistsItemsRelationshipRemoveOperationPayload** | [**UserCollectionPlaylistsItemsRelationshipRemoveOperationPayload**](UserCollectionPlaylistsItemsRelationshipRemoveOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionPlaylistsIdRelationshipsItemsGet**
```swift
    open class func userCollectionPlaylistsIdRelationshipsItemsGet(id: String, collectionView: CollectionView_userCollectionPlaylistsIdRelationshipsItemsGet? = nil, pageCursor: String? = nil, sort: [Sort_userCollectionPlaylistsIdRelationshipsItemsGet]? = nil, include: [String]? = nil, completion: @escaping (_ data: UserCollectionPlaylistsItemsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get items relationship (\"to-many\").

Retrieves items relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection playlists id
let collectionView = "collectionView_example" // String |  (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let sort = ["sort_example"] // [String] | Values prefixed with \"-\" are sorted descending; values without it are sorted ascending. (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: items (optional)

// Get items relationship (\"to-many\").
UserCollectionPlaylistsAPI.userCollectionPlaylistsIdRelationshipsItemsGet(id: id, collectionView: collectionView, pageCursor: pageCursor, sort: sort, include: include) { (response, error) in
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
 **id** | **String** | User collection playlists id | 
 **collectionView** | **String** |  | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **sort** | [**[String]**](String.md) | Values prefixed with \&quot;-\&quot; are sorted descending; values without it are sorted ascending. | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: items | [optional] 

### Return type

[**UserCollectionPlaylistsItemsMultiRelationshipDataDocument**](UserCollectionPlaylistsItemsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionPlaylistsIdRelationshipsItemsPost**
```swift
    open class func userCollectionPlaylistsIdRelationshipsItemsPost(id: String, userCollectionPlaylistsItemsRelationshipAddOperationPayload: UserCollectionPlaylistsItemsRelationshipAddOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Add to items relationship (\"to-many\").

Adds item(s) to items relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection playlists id
let userCollectionPlaylistsItemsRelationshipAddOperationPayload = UserCollectionPlaylistsItemsRelationshipAddOperation_Payload(data: [UserCollectionPlaylistsItemsRelationshipAddOperation_Payload_Data(id: "id_example", type: "type_example")]) // UserCollectionPlaylistsItemsRelationshipAddOperationPayload |  (optional)

// Add to items relationship (\"to-many\").
UserCollectionPlaylistsAPI.userCollectionPlaylistsIdRelationshipsItemsPost(id: id, userCollectionPlaylistsItemsRelationshipAddOperationPayload: userCollectionPlaylistsItemsRelationshipAddOperationPayload) { (response, error) in
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
 **id** | **String** | User collection playlists id | 
 **userCollectionPlaylistsItemsRelationshipAddOperationPayload** | [**UserCollectionPlaylistsItemsRelationshipAddOperationPayload**](UserCollectionPlaylistsItemsRelationshipAddOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionPlaylistsIdRelationshipsOwnersGet**
```swift
    open class func userCollectionPlaylistsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: UserCollectionPlaylistsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection playlists id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get owners relationship (\"to-many\").
UserCollectionPlaylistsAPI.userCollectionPlaylistsIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | User collection playlists id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**UserCollectionPlaylistsMultiRelationshipDataDocument**](UserCollectionPlaylistsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

