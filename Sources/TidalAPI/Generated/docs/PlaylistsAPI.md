# PlaylistsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**playlistsGet**](PlaylistsAPI.md#playlistsget) | **GET** /playlists | Get multiple playlists.
[**playlistsIdDelete**](PlaylistsAPI.md#playlistsiddelete) | **DELETE** /playlists/{id} | Delete single playlist.
[**playlistsIdGet**](PlaylistsAPI.md#playlistsidget) | **GET** /playlists/{id} | Get single playlist.
[**playlistsIdPatch**](PlaylistsAPI.md#playlistsidpatch) | **PATCH** /playlists/{id} | Update single playlist.
[**playlistsIdRelationshipsCollaboratorProfilesDelete**](PlaylistsAPI.md#playlistsidrelationshipscollaboratorprofilesdelete) | **DELETE** /playlists/{id}/relationships/collaboratorProfiles | Delete from collaboratorProfiles relationship (\&quot;to-many\&quot;).
[**playlistsIdRelationshipsCollaboratorProfilesGet**](PlaylistsAPI.md#playlistsidrelationshipscollaboratorprofilesget) | **GET** /playlists/{id}/relationships/collaboratorProfiles | Get collaboratorProfiles relationship (\&quot;to-many\&quot;).
[**playlistsIdRelationshipsCollaboratorProfilesPost**](PlaylistsAPI.md#playlistsidrelationshipscollaboratorprofilespost) | **POST** /playlists/{id}/relationships/collaboratorProfiles | Add to collaboratorProfiles relationship (\&quot;to-many\&quot;).
[**playlistsIdRelationshipsCollaboratorsGet**](PlaylistsAPI.md#playlistsidrelationshipscollaboratorsget) | **GET** /playlists/{id}/relationships/collaborators | Get collaborators relationship (\&quot;to-many\&quot;).
[**playlistsIdRelationshipsCoverArtGet**](PlaylistsAPI.md#playlistsidrelationshipscoverartget) | **GET** /playlists/{id}/relationships/coverArt | Get coverArt relationship (\&quot;to-many\&quot;).
[**playlistsIdRelationshipsCoverArtPatch**](PlaylistsAPI.md#playlistsidrelationshipscoverartpatch) | **PATCH** /playlists/{id}/relationships/coverArt | Update coverArt relationship (\&quot;to-many\&quot;).
[**playlistsIdRelationshipsItemsDelete**](PlaylistsAPI.md#playlistsidrelationshipsitemsdelete) | **DELETE** /playlists/{id}/relationships/items | Delete from items relationship (\&quot;to-many\&quot;).
[**playlistsIdRelationshipsItemsGet**](PlaylistsAPI.md#playlistsidrelationshipsitemsget) | **GET** /playlists/{id}/relationships/items | Get items relationship (\&quot;to-many\&quot;).
[**playlistsIdRelationshipsItemsPatch**](PlaylistsAPI.md#playlistsidrelationshipsitemspatch) | **PATCH** /playlists/{id}/relationships/items | Update items relationship (\&quot;to-many\&quot;).
[**playlistsIdRelationshipsItemsPost**](PlaylistsAPI.md#playlistsidrelationshipsitemspost) | **POST** /playlists/{id}/relationships/items | Add to items relationship (\&quot;to-many\&quot;).
[**playlistsIdRelationshipsOwnerProfilesGet**](PlaylistsAPI.md#playlistsidrelationshipsownerprofilesget) | **GET** /playlists/{id}/relationships/ownerProfiles | Get ownerProfiles relationship (\&quot;to-many\&quot;).
[**playlistsIdRelationshipsOwnersGet**](PlaylistsAPI.md#playlistsidrelationshipsownersget) | **GET** /playlists/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
[**playlistsPost**](PlaylistsAPI.md#playlistspost) | **POST** /playlists | Create single playlist.


# **playlistsGet**
```swift
    open class func playlistsGet(pageCursor: String? = nil, sort: [Sort_playlistsGet]? = nil, countryCode: String? = nil, include: [String]? = nil, filterId: [String]? = nil, filterOwnersId: [String]? = nil, completion: @escaping (_ data: PlaylistsMultiResourceDataDocument?, _ error: Error?) -> Void)
```

Get multiple playlists.

Retrieves multiple playlists by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let sort = ["sort_example"] // [String] | Values prefixed with \"-\" are sorted descending; values without it are sorted ascending. (optional)
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: collaboratorProfiles, collaborators, coverArt, items, ownerProfiles, owners (optional)
let filterId = ["inner_example"] // [String] | Playlist id (e.g. `550e8400-e29b-41d4-a716-446655440000`) (optional)
let filterOwnersId = ["inner_example"] // [String] | User id. Use `me` for the authenticated user (optional)

// Get multiple playlists.
PlaylistsAPI.playlistsGet(pageCursor: pageCursor, sort: sort, countryCode: countryCode, include: include, filterId: filterId, filterOwnersId: filterOwnersId) { (response, error) in
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
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **sort** | [**[String]**](String.md) | Values prefixed with \&quot;-\&quot; are sorted descending; values without it are sorted ascending. | [optional] 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: collaboratorProfiles, collaborators, coverArt, items, ownerProfiles, owners | [optional] 
 **filterId** | [**[String]**](String.md) | Playlist id (e.g. &#x60;550e8400-e29b-41d4-a716-446655440000&#x60;) | [optional] 
 **filterOwnersId** | [**[String]**](String.md) | User id. Use &#x60;me&#x60; for the authenticated user | [optional] 

### Return type

[**PlaylistsMultiResourceDataDocument**](PlaylistsMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistsIdDelete**
```swift
    open class func playlistsIdDelete(id: String, idempotencyKey: String? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Delete single playlist.

Deletes existing playlist.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Playlist id
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. (optional)

// Delete single playlist.
PlaylistsAPI.playlistsIdDelete(id: id, idempotencyKey: idempotencyKey) { (response, error) in
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
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. | [optional] 

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
    open class func playlistsIdGet(id: String, countryCode: String? = nil, include: [String]? = nil, completion: @escaping (_ data: PlaylistsSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single playlist.

Retrieves single playlist by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Playlist id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: collaboratorProfiles, collaborators, coverArt, items, ownerProfiles, owners (optional)

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
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: collaboratorProfiles, collaborators, coverArt, items, ownerProfiles, owners | [optional] 

### Return type

[**PlaylistsSingleResourceDataDocument**](PlaylistsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistsIdPatch**
```swift
    open class func playlistsIdPatch(id: String, countryCode: String? = nil, idempotencyKey: String? = nil, playlistsUpdateOperationPayload: PlaylistsUpdateOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Update single playlist.

Updates existing playlist.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Playlist id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. (optional)
let playlistsUpdateOperationPayload = PlaylistsUpdateOperation_Payload(data: PlaylistsUpdateOperation_Payload_Data(attributes: PlaylistsUpdateOperation_Payload_Data_Attributes(accessType: "accessType_example", description: "description_example", name: "name_example"), id: "id_example", type: "type_example")) // PlaylistsUpdateOperationPayload |  (optional)

// Update single playlist.
PlaylistsAPI.playlistsIdPatch(id: id, countryCode: countryCode, idempotencyKey: idempotencyKey, playlistsUpdateOperationPayload: playlistsUpdateOperationPayload) { (response, error) in
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
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. | [optional] 
 **playlistsUpdateOperationPayload** | [**PlaylistsUpdateOperationPayload**](PlaylistsUpdateOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistsIdRelationshipsCollaboratorProfilesDelete**
```swift
    open class func playlistsIdRelationshipsCollaboratorProfilesDelete(id: String, idempotencyKey: String? = nil, playlistsCollaboratorProfilesRelationshipRemoveOperationPayload: PlaylistsCollaboratorProfilesRelationshipRemoveOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Delete from collaboratorProfiles relationship (\"to-many\").

Deletes item(s) from collaboratorProfiles relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Playlist id
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. (optional)
let playlistsCollaboratorProfilesRelationshipRemoveOperationPayload = PlaylistsCollaboratorProfilesRelationshipRemoveOperation_Payload(data: [PlaylistsCollaboratorProfilesRelationshipRemoveOperation_Payload_Data(id: "id_example", type: "type_example")]) // PlaylistsCollaboratorProfilesRelationshipRemoveOperationPayload |  (optional)

// Delete from collaboratorProfiles relationship (\"to-many\").
PlaylistsAPI.playlistsIdRelationshipsCollaboratorProfilesDelete(id: id, idempotencyKey: idempotencyKey, playlistsCollaboratorProfilesRelationshipRemoveOperationPayload: playlistsCollaboratorProfilesRelationshipRemoveOperationPayload) { (response, error) in
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
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. | [optional] 
 **playlistsCollaboratorProfilesRelationshipRemoveOperationPayload** | [**PlaylistsCollaboratorProfilesRelationshipRemoveOperationPayload**](PlaylistsCollaboratorProfilesRelationshipRemoveOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistsIdRelationshipsCollaboratorProfilesGet**
```swift
    open class func playlistsIdRelationshipsCollaboratorProfilesGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: PlaylistsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get collaboratorProfiles relationship (\"to-many\").

Retrieves collaboratorProfiles relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Playlist id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: collaboratorProfiles (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get collaboratorProfiles relationship (\"to-many\").
PlaylistsAPI.playlistsIdRelationshipsCollaboratorProfilesGet(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor) { (response, error) in
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
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: collaboratorProfiles | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**PlaylistsMultiRelationshipDataDocument**](PlaylistsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistsIdRelationshipsCollaboratorProfilesPost**
```swift
    open class func playlistsIdRelationshipsCollaboratorProfilesPost(id: String, idempotencyKey: String? = nil, playlistsCollaboratorProfilesRelationshipAddOperationPayload: PlaylistsCollaboratorProfilesRelationshipAddOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Add to collaboratorProfiles relationship (\"to-many\").

Adds item(s) to collaboratorProfiles relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Playlist id
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. (optional)
let playlistsCollaboratorProfilesRelationshipAddOperationPayload = PlaylistsCollaboratorProfilesRelationshipAddOperation_Payload(data: [PlaylistsCollaboratorProfilesRelationshipAddOperation_Payload_Data(id: "id_example", type: "type_example")]) // PlaylistsCollaboratorProfilesRelationshipAddOperationPayload |  (optional)

// Add to collaboratorProfiles relationship (\"to-many\").
PlaylistsAPI.playlistsIdRelationshipsCollaboratorProfilesPost(id: id, idempotencyKey: idempotencyKey, playlistsCollaboratorProfilesRelationshipAddOperationPayload: playlistsCollaboratorProfilesRelationshipAddOperationPayload) { (response, error) in
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
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. | [optional] 
 **playlistsCollaboratorProfilesRelationshipAddOperationPayload** | [**PlaylistsCollaboratorProfilesRelationshipAddOperationPayload**](PlaylistsCollaboratorProfilesRelationshipAddOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistsIdRelationshipsCollaboratorsGet**
```swift
    open class func playlistsIdRelationshipsCollaboratorsGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: PlaylistsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get collaborators relationship (\"to-many\").

Retrieves collaborators relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Playlist id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: collaborators (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get collaborators relationship (\"to-many\").
PlaylistsAPI.playlistsIdRelationshipsCollaboratorsGet(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor) { (response, error) in
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
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: collaborators | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**PlaylistsMultiRelationshipDataDocument**](PlaylistsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistsIdRelationshipsCoverArtGet**
```swift
    open class func playlistsIdRelationshipsCoverArtGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: PlaylistsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get coverArt relationship (\"to-many\").

Retrieves coverArt relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Playlist id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
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
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: coverArt | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**PlaylistsMultiRelationshipDataDocument**](PlaylistsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistsIdRelationshipsCoverArtPatch**
```swift
    open class func playlistsIdRelationshipsCoverArtPatch(id: String, idempotencyKey: String? = nil, playlistsCoverArtRelationshipUpdateOperationPayload: PlaylistsCoverArtRelationshipUpdateOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Update coverArt relationship (\"to-many\").

Updates coverArt relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Playlist id
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. (optional)
let playlistsCoverArtRelationshipUpdateOperationPayload = PlaylistsCoverArtRelationshipUpdateOperation_Payload(data: [PlaylistsCoverArtRelationshipUpdateOperation_Payload_Data(id: "id_example", type: "type_example")]) // PlaylistsCoverArtRelationshipUpdateOperationPayload |  (optional)

// Update coverArt relationship (\"to-many\").
PlaylistsAPI.playlistsIdRelationshipsCoverArtPatch(id: id, idempotencyKey: idempotencyKey, playlistsCoverArtRelationshipUpdateOperationPayload: playlistsCoverArtRelationshipUpdateOperationPayload) { (response, error) in
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
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. | [optional] 
 **playlistsCoverArtRelationshipUpdateOperationPayload** | [**PlaylistsCoverArtRelationshipUpdateOperationPayload**](PlaylistsCoverArtRelationshipUpdateOperationPayload.md) |  | [optional] 

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
    open class func playlistsIdRelationshipsItemsDelete(id: String, idempotencyKey: String? = nil, playlistsItemsRelationshipRemoveOperationPayload: PlaylistsItemsRelationshipRemoveOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Delete from items relationship (\"to-many\").

Deletes item(s) from items relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Playlist id
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. (optional)
let playlistsItemsRelationshipRemoveOperationPayload = PlaylistsItemsRelationshipRemoveOperation_Payload(data: [PlaylistsItemsRelationshipRemoveOperation_Payload_Data(id: "id_example", meta: PlaylistsItemsRelationshipRemoveOperation_Payload_Data_Meta(itemId: "itemId_example"), type: "type_example")]) // PlaylistsItemsRelationshipRemoveOperationPayload |  (optional)

// Delete from items relationship (\"to-many\").
PlaylistsAPI.playlistsIdRelationshipsItemsDelete(id: id, idempotencyKey: idempotencyKey, playlistsItemsRelationshipRemoveOperationPayload: playlistsItemsRelationshipRemoveOperationPayload) { (response, error) in
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
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. | [optional] 
 **playlistsItemsRelationshipRemoveOperationPayload** | [**PlaylistsItemsRelationshipRemoveOperationPayload**](PlaylistsItemsRelationshipRemoveOperationPayload.md) |  | [optional] 

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
    open class func playlistsIdRelationshipsItemsGet(id: String, pageCursor: String? = nil, countryCode: String? = nil, include: [String]? = nil, completion: @escaping (_ data: PlaylistsItemsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get items relationship (\"to-many\").

Retrieves items relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Playlist id
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: items (optional)

// Get items relationship (\"to-many\").
PlaylistsAPI.playlistsIdRelationshipsItemsGet(id: id, pageCursor: pageCursor, countryCode: countryCode, include: include) { (response, error) in
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
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: items | [optional] 

### Return type

[**PlaylistsItemsMultiRelationshipDataDocument**](PlaylistsItemsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistsIdRelationshipsItemsPatch**
```swift
    open class func playlistsIdRelationshipsItemsPatch(id: String, idempotencyKey: String? = nil, playlistsItemsRelationshipUpdateOperationPayload: PlaylistsItemsRelationshipUpdateOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Update items relationship (\"to-many\").

Updates items relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Playlist id
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. (optional)
let playlistsItemsRelationshipUpdateOperationPayload = PlaylistsItemsRelationshipUpdateOperation_Payload(data: [PlaylistsItemsRelationshipUpdateOperation_Payload_Data(id: "id_example", meta: PlaylistsItemsRelationshipUpdateOperation_Payload_Data_Meta(itemId: "itemId_example"), type: "type_example")], meta: PlaylistsItemsRelationshipUpdateOperation_Payload_Meta(positionBefore: "positionBefore_example")) // PlaylistsItemsRelationshipUpdateOperationPayload |  (optional)

// Update items relationship (\"to-many\").
PlaylistsAPI.playlistsIdRelationshipsItemsPatch(id: id, idempotencyKey: idempotencyKey, playlistsItemsRelationshipUpdateOperationPayload: playlistsItemsRelationshipUpdateOperationPayload) { (response, error) in
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
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. | [optional] 
 **playlistsItemsRelationshipUpdateOperationPayload** | [**PlaylistsItemsRelationshipUpdateOperationPayload**](PlaylistsItemsRelationshipUpdateOperationPayload.md) |  | [optional] 

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
    open class func playlistsIdRelationshipsItemsPost(id: String, countryCode: String? = nil, idempotencyKey: String? = nil, playlistsItemsRelationshipAddOperationPayload: PlaylistsItemsRelationshipAddOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Add to items relationship (\"to-many\").

Adds item(s) to items relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Playlist id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. (optional)
let playlistsItemsRelationshipAddOperationPayload = PlaylistsItemsRelationshipAddOperation_Payload(data: [PlaylistsItemsRelationshipAddOperation_Payload_Data(id: "id_example", meta: PlaylistsItemsRelationshipAddOperation_Payload_Data_Meta(addedAt: Date()), type: "type_example")], meta: PlaylistsItemsRelationshipAddOperation_Payload_Meta(positionBefore: "positionBefore_example")) // PlaylistsItemsRelationshipAddOperationPayload |  (optional)

// Add to items relationship (\"to-many\").
PlaylistsAPI.playlistsIdRelationshipsItemsPost(id: id, countryCode: countryCode, idempotencyKey: idempotencyKey, playlistsItemsRelationshipAddOperationPayload: playlistsItemsRelationshipAddOperationPayload) { (response, error) in
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
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. | [optional] 
 **playlistsItemsRelationshipAddOperationPayload** | [**PlaylistsItemsRelationshipAddOperationPayload**](PlaylistsItemsRelationshipAddOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistsIdRelationshipsOwnerProfilesGet**
```swift
    open class func playlistsIdRelationshipsOwnerProfilesGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: PlaylistsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get ownerProfiles relationship (\"to-many\").

Retrieves ownerProfiles relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Playlist id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: ownerProfiles (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get ownerProfiles relationship (\"to-many\").
PlaylistsAPI.playlistsIdRelationshipsOwnerProfilesGet(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor) { (response, error) in
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
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: ownerProfiles | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**PlaylistsMultiRelationshipDataDocument**](PlaylistsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistsIdRelationshipsOwnersGet**
```swift
    open class func playlistsIdRelationshipsOwnersGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: PlaylistsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Playlist id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
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
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**PlaylistsMultiRelationshipDataDocument**](PlaylistsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistsPost**
```swift
    open class func playlistsPost(countryCode: String? = nil, idempotencyKey: String? = nil, playlistsCreateOperationPayload: PlaylistsCreateOperationPayload? = nil, completion: @escaping (_ data: PlaylistsSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Create single playlist.

Creates a new playlist.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. (optional)
let playlistsCreateOperationPayload = PlaylistsCreateOperation_Payload(data: PlaylistsCreateOperation_Payload_Data(attributes: PlaylistsCreateOperation_Payload_Data_Attributes(accessType: "accessType_example", createdAt: Date(), description: "description_example", name: "name_example"), type: "type_example")) // PlaylistsCreateOperationPayload |  (optional)

// Create single playlist.
PlaylistsAPI.playlistsPost(countryCode: countryCode, idempotencyKey: idempotencyKey, playlistsCreateOperationPayload: playlistsCreateOperationPayload) { (response, error) in
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
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. | [optional] 
 **playlistsCreateOperationPayload** | [**PlaylistsCreateOperationPayload**](PlaylistsCreateOperationPayload.md) |  | [optional] 

### Return type

[**PlaylistsSingleResourceDataDocument**](PlaylistsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

