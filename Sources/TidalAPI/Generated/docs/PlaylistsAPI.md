# PlaylistsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**playlistsGet**](PlaylistsAPI.md#playlistsget) | **GET** /playlists | Get multiple playlists.
[**playlistsIdDelete**](PlaylistsAPI.md#playlistsiddelete) | **DELETE** /playlists/{id} | Delete single playlist.
[**playlistsIdGet**](PlaylistsAPI.md#playlistsidget) | **GET** /playlists/{id} | Get single playlist.
[**playlistsIdPatch**](PlaylistsAPI.md#playlistsidpatch) | **PATCH** /playlists/{id} | Update single playlist.
[**playlistsIdRelationshipsCoverArtGet**](PlaylistsAPI.md#playlistsidrelationshipscoverartget) | **GET** /playlists/{id}/relationships/coverArt | Get coverArt relationship (\&quot;to-many\&quot;).
[**playlistsIdRelationshipsCoverArtPatch**](PlaylistsAPI.md#playlistsidrelationshipscoverartpatch) | **PATCH** /playlists/{id}/relationships/coverArt | Update coverArt relationship (\&quot;to-many\&quot;).
[**playlistsIdRelationshipsItemsDelete**](PlaylistsAPI.md#playlistsidrelationshipsitemsdelete) | **DELETE** /playlists/{id}/relationships/items | Delete from items relationship (\&quot;to-many\&quot;).
[**playlistsIdRelationshipsItemsGet**](PlaylistsAPI.md#playlistsidrelationshipsitemsget) | **GET** /playlists/{id}/relationships/items | Get items relationship (\&quot;to-many\&quot;).
[**playlistsIdRelationshipsItemsPatch**](PlaylistsAPI.md#playlistsidrelationshipsitemspatch) | **PATCH** /playlists/{id}/relationships/items | Update items relationship (\&quot;to-many\&quot;).
[**playlistsIdRelationshipsItemsPost**](PlaylistsAPI.md#playlistsidrelationshipsitemspost) | **POST** /playlists/{id}/relationships/items | Add to items relationship (\&quot;to-many\&quot;).
[**playlistsIdRelationshipsOwnersGet**](PlaylistsAPI.md#playlistsidrelationshipsownersget) | **GET** /playlists/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
[**playlistsPost**](PlaylistsAPI.md#playlistspost) | **POST** /playlists | Create single playlist.


# **playlistsGet**
```swift
    open class func playlistsGet(countryCode: String, pageCursor: String? = nil, include: [String]? = nil, filterROwnersId: [String]? = nil, filterId: [String]? = nil, completion: @escaping (_ data: PlaylistsMultiDataDocument?, _ error: Error?) -> Void)
```

Get multiple playlists.

Retrieves multiple playlists by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: coverArt, items, owners (optional)
let filterROwnersId = ["inner_example"] // [String] | User id (optional)
let filterId = ["inner_example"] // [String] | Playlist id (optional)

// Get multiple playlists.
PlaylistsAPI.playlistsGet(countryCode: countryCode, pageCursor: pageCursor, include: include, filterROwnersId: filterROwnersId, filterId: filterId) { (response, error) in
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
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: coverArt, items, owners | [optional] 
 **filterROwnersId** | [**[String]**](String.md) | User id | [optional] 
 **filterId** | [**[String]**](String.md) | Playlist id | [optional] 

### Return type

[**PlaylistsMultiDataDocument**](PlaylistsMultiDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistsIdDelete**
```swift
    open class func playlistsIdDelete(id: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Delete single playlist.

Deletes existing playlist.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Playlist id

// Delete single playlist.
PlaylistsAPI.playlistsIdDelete(id: id) { (response, error) in
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
 **id** | **String** | Playlist id | 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistsIdGet**
```swift
    open class func playlistsIdGet(id: String, countryCode: String, include: [String]? = nil, completion: @escaping (_ data: PlaylistsSingleDataDocument?, _ error: Error?) -> Void)
```

Get single playlist.

Retrieves single playlist by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Playlist id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: coverArt, items, owners (optional)

// Get single playlist.
PlaylistsAPI.playlistsIdGet(id: id, countryCode: countryCode, include: include) { (response, error) in
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
 **id** | **String** | Playlist id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: coverArt, items, owners | [optional] 

### Return type

[**PlaylistsSingleDataDocument**](PlaylistsSingleDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistsIdPatch**
```swift
    open class func playlistsIdPatch(id: String, countryCode: String, playlistUpdateOperationPayload: PlaylistUpdateOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Update single playlist.

Updates existing playlist.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Playlist id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let playlistUpdateOperationPayload = PlaylistUpdateOperation_Payload(data: PlaylistUpdateOperation_Payload_Data(id: "id_example", type: "type_example", attributes: PlaylistUpdateOperation_Payload_Data_Attributes(name: "name_example", description: "description_example", accessType: "accessType_example"))) // PlaylistUpdateOperationPayload |  (optional)

// Update single playlist.
PlaylistsAPI.playlistsIdPatch(id: id, countryCode: countryCode, playlistUpdateOperationPayload: playlistUpdateOperationPayload) { (response, error) in
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
 **id** | **String** | Playlist id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **playlistUpdateOperationPayload** | [**PlaylistUpdateOperationPayload**](PlaylistUpdateOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistsIdRelationshipsCoverArtGet**
```swift
    open class func playlistsIdRelationshipsCoverArtGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: PlaylistsMultiDataRelationshipDocument?, _ error: Error?) -> Void)
```

Get coverArt relationship (\"to-many\").

Retrieves coverArt relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Playlist id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: coverArt (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get coverArt relationship (\"to-many\").
PlaylistsAPI.playlistsIdRelationshipsCoverArtGet(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | Playlist id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: coverArt | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**PlaylistsMultiDataRelationshipDocument**](PlaylistsMultiDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistsIdRelationshipsCoverArtPatch**
```swift
    open class func playlistsIdRelationshipsCoverArtPatch(id: String, playlistCoverArtRelationshipUpdateOperationPayload: PlaylistCoverArtRelationshipUpdateOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Update coverArt relationship (\"to-many\").

Updates coverArt relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Playlist id
let playlistCoverArtRelationshipUpdateOperationPayload = PlaylistCoverArtRelationshipUpdateOperation_Payload(data: [PlaylistCoverArtRelationshipUpdateOperation_Payload_Data(id: "id_example", type: "type_example")]) // PlaylistCoverArtRelationshipUpdateOperationPayload |  (optional)

// Update coverArt relationship (\"to-many\").
PlaylistsAPI.playlistsIdRelationshipsCoverArtPatch(id: id, playlistCoverArtRelationshipUpdateOperationPayload: playlistCoverArtRelationshipUpdateOperationPayload) { (response, error) in
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
 **id** | **String** | Playlist id | 
 **playlistCoverArtRelationshipUpdateOperationPayload** | [**PlaylistCoverArtRelationshipUpdateOperationPayload**](PlaylistCoverArtRelationshipUpdateOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistsIdRelationshipsItemsDelete**
```swift
    open class func playlistsIdRelationshipsItemsDelete(id: String, playlistItemsRelationshipRemoveOperationPayload: PlaylistItemsRelationshipRemoveOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Delete from items relationship (\"to-many\").

Deletes item(s) from items relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Playlist id
let playlistItemsRelationshipRemoveOperationPayload = PlaylistItemsRelationshipRemoveOperation_Payload(data: [PlaylistItemsRelationshipRemoveOperation_Payload_Data(id: "id_example", type: "type_example", meta: PlaylistItemsRelationshipRemoveOperation_Payload_Data_Meta(itemId: "itemId_example"))]) // PlaylistItemsRelationshipRemoveOperationPayload |  (optional)

// Delete from items relationship (\"to-many\").
PlaylistsAPI.playlistsIdRelationshipsItemsDelete(id: id, playlistItemsRelationshipRemoveOperationPayload: playlistItemsRelationshipRemoveOperationPayload) { (response, error) in
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
 **id** | **String** | Playlist id | 
 **playlistItemsRelationshipRemoveOperationPayload** | [**PlaylistItemsRelationshipRemoveOperationPayload**](PlaylistItemsRelationshipRemoveOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistsIdRelationshipsItemsGet**
```swift
    open class func playlistsIdRelationshipsItemsGet(id: String, countryCode: String, pageCursor: String? = nil, include: [String]? = nil, completion: @escaping (_ data: PlaylistsItemsMultiDataRelationshipDocument?, _ error: Error?) -> Void)
```

Get items relationship (\"to-many\").

Retrieves items relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Playlist id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: items (optional)

// Get items relationship (\"to-many\").
PlaylistsAPI.playlistsIdRelationshipsItemsGet(id: id, countryCode: countryCode, pageCursor: pageCursor, include: include) { (response, error) in
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
 **id** | **String** | Playlist id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: items | [optional] 

### Return type

[**PlaylistsItemsMultiDataRelationshipDocument**](PlaylistsItemsMultiDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistsIdRelationshipsItemsPatch**
```swift
    open class func playlistsIdRelationshipsItemsPatch(id: String, playlistItemsRelationshipReorderOperationPayload: PlaylistItemsRelationshipReorderOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Update items relationship (\"to-many\").

Updates items relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Playlist id
let playlistItemsRelationshipReorderOperationPayload = PlaylistItemsRelationshipReorderOperation_Payload(data: [PlaylistItemsRelationshipReorderOperation_Payload_Data(id: "id_example", type: "type_example", meta: PlaylistItemsRelationshipReorderOperation_Payload_Data_Meta(itemId: "itemId_example"))], meta: PlaylistItemsRelationshipReorderOperation_Payload_Meta(positionBefore: "positionBefore_example")) // PlaylistItemsRelationshipReorderOperationPayload |  (optional)

// Update items relationship (\"to-many\").
PlaylistsAPI.playlistsIdRelationshipsItemsPatch(id: id, playlistItemsRelationshipReorderOperationPayload: playlistItemsRelationshipReorderOperationPayload) { (response, error) in
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
 **id** | **String** | Playlist id | 
 **playlistItemsRelationshipReorderOperationPayload** | [**PlaylistItemsRelationshipReorderOperationPayload**](PlaylistItemsRelationshipReorderOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistsIdRelationshipsItemsPost**
```swift
    open class func playlistsIdRelationshipsItemsPost(id: String, countryCode: String, playlistItemsRelationshipAddOperationPayload: PlaylistItemsRelationshipAddOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Add to items relationship (\"to-many\").

Adds item(s) to items relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Playlist id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let playlistItemsRelationshipAddOperationPayload = PlaylistItemsRelationshipAddOperation_Payload(data: [PlaylistItemsRelationshipAddOperation_Payload_Data(id: "id_example", type: "type_example")], meta: PlaylistItemsRelationshipAddOperation_Payload_Meta(positionBefore: "positionBefore_example")) // PlaylistItemsRelationshipAddOperationPayload |  (optional)

// Add to items relationship (\"to-many\").
PlaylistsAPI.playlistsIdRelationshipsItemsPost(id: id, countryCode: countryCode, playlistItemsRelationshipAddOperationPayload: playlistItemsRelationshipAddOperationPayload) { (response, error) in
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
 **id** | **String** | Playlist id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **playlistItemsRelationshipAddOperationPayload** | [**PlaylistItemsRelationshipAddOperationPayload**](PlaylistItemsRelationshipAddOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistsIdRelationshipsOwnersGet**
```swift
    open class func playlistsIdRelationshipsOwnersGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: PlaylistsMultiDataRelationshipDocument?, _ error: Error?) -> Void)
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Playlist id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get owners relationship (\"to-many\").
PlaylistsAPI.playlistsIdRelationshipsOwnersGet(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | Playlist id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**PlaylistsMultiDataRelationshipDocument**](PlaylistsMultiDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistsPost**
```swift
    open class func playlistsPost(countryCode: String, playlistCreateOperationPayload: PlaylistCreateOperationPayload? = nil, completion: @escaping (_ data: PlaylistsSingleDataDocument?, _ error: Error?) -> Void)
```

Create single playlist.

Creates a new playlist.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let playlistCreateOperationPayload = PlaylistCreateOperation_Payload(data: PlaylistCreateOperation_Payload_Data(type: "type_example", attributes: PlaylistCreateOperation_Payload_Data_Attributes(name: "name_example", description: "description_example", accessType: "accessType_example"))) // PlaylistCreateOperationPayload |  (optional)

// Create single playlist.
PlaylistsAPI.playlistsPost(countryCode: countryCode, playlistCreateOperationPayload: playlistCreateOperationPayload) { (response, error) in
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
 **playlistCreateOperationPayload** | [**PlaylistCreateOperationPayload**](PlaylistCreateOperationPayload.md) |  | [optional] 

### Return type

[**PlaylistsSingleDataDocument**](PlaylistsSingleDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

