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
[**playlistsIdRelationshipsCollaboratorsGet**](PlaylistsAPI.md#playlistsidrelationshipscollaboratorsget) | **GET** /playlists/{id}/relationships/collaborators | Get collaborators relationship (\&quot;to-many\&quot;).
[**playlistsIdRelationshipsCoverArtGet**](PlaylistsAPI.md#playlistsidrelationshipscoverartget) | **GET** /playlists/{id}/relationships/coverArt | Get coverArt relationship (\&quot;to-many\&quot;).
[**playlistsIdRelationshipsCoverArtPatch**](PlaylistsAPI.md#playlistsidrelationshipscoverartpatch) | **PATCH** /playlists/{id}/relationships/coverArt | Update coverArt relationship (\&quot;to-many\&quot;).
[**playlistsIdRelationshipsCuratorsGet**](PlaylistsAPI.md#playlistsidrelationshipscuratorsget) | **GET** /playlists/{id}/relationships/curators | Get curators relationship (\&quot;to-many\&quot;).
[**playlistsIdRelationshipsItemsDelete**](PlaylistsAPI.md#playlistsidrelationshipsitemsdelete) | **DELETE** /playlists/{id}/relationships/items | Delete from items relationship (\&quot;to-many\&quot;).
[**playlistsIdRelationshipsItemsGet**](PlaylistsAPI.md#playlistsidrelationshipsitemsget) | **GET** /playlists/{id}/relationships/items | Get items relationship (\&quot;to-many\&quot;).
[**playlistsIdRelationshipsItemsPatch**](PlaylistsAPI.md#playlistsidrelationshipsitemspatch) | **PATCH** /playlists/{id}/relationships/items | Update items relationship (\&quot;to-many\&quot;).
[**playlistsIdRelationshipsItemsPost**](PlaylistsAPI.md#playlistsidrelationshipsitemspost) | **POST** /playlists/{id}/relationships/items | Add to items relationship (\&quot;to-many\&quot;).
[**playlistsIdRelationshipsOwnerProfilesGet**](PlaylistsAPI.md#playlistsidrelationshipsownerprofilesget) | **GET** /playlists/{id}/relationships/ownerProfiles | Get ownerProfiles relationship (\&quot;to-many\&quot;).
[**playlistsIdRelationshipsOwnersGet**](PlaylistsAPI.md#playlistsidrelationshipsownersget) | **GET** /playlists/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
[**playlistsIdRelationshipsSuggestedCoverArtsGet**](PlaylistsAPI.md#playlistsidrelationshipssuggestedcoverartsget) | **GET** /playlists/{id}/relationships/suggestedCoverArts | Get suggestedCoverArts relationship (\&quot;to-many\&quot;).
[**playlistsPost**](PlaylistsAPI.md#playlistspost) | **POST** /playlists | Create single playlist.


# **playlistsGet**
```swift
    open class func playlistsGet(countryCode: String? = nil, filterCollaboratorsId: [String]? = nil, filterId: [String]? = nil, filterOwnersId: [String]? = nil, include: [String]? = nil, includeLinkage: [IncludeLinkage_playlistsGet]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil, sort: [Sort_playlistsGet]? = nil) async throws -> PlaylistsMultiResourceDataDocument
```

Get multiple playlists.

Retrieves multiple playlists by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let filterCollaboratorsId = ["inner_example"] // [String] | User id. Also accepts `me`. (optional)
let filterId = ["inner_example"] // [String] | List of playlist IDs (e.g. `550e8400-e29b-41d4-a716-446655440000`) (optional)
let filterOwnersId = ["inner_example"] // [String] | User id. Also accepts `me`. (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: collaboratorProfiles, collaborators, coverArt, curators, items, ownerProfiles, owners, suggestedCoverArts (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: curators.albums (optional)
let sort = ["sort_example"] // [String] | Values prefixed with \"-\" are sorted descending; values without it are sorted ascending. (optional)

// Get multiple playlists.
do {
    let response = try await PlaylistsAPI.playlistsGet(countryCode: countryCode, filterCollaboratorsId: filterCollaboratorsId, filterId: filterId, filterOwnersId: filterOwnersId, include: include, includeLinkage: includeLinkage, pageCursor: pageCursor, replaceMedia: replaceMedia, sort: sort)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **filterCollaboratorsId** | [**[String]**](String.md) | User id. Also accepts &#x60;me&#x60;. | [optional] 
 **filterId** | [**[String]**](String.md) | List of playlist IDs (e.g. &#x60;550e8400-e29b-41d4-a716-446655440000&#x60;) | [optional] 
 **filterOwnersId** | [**[String]**](String.md) | User id. Also accepts &#x60;me&#x60;. | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: collaboratorProfiles, collaborators, coverArt, curators, items, ownerProfiles, owners, suggestedCoverArts | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: curators.albums | [optional] 
 **sort** | [**[String]**](String.md) | Values prefixed with \&quot;-\&quot; are sorted descending; values without it are sorted ascending. | [optional] 

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
    open class func playlistsIdDelete(id: String, idempotencyKey: String? = nil) async throws -> MutationResponseDocument
```

Delete single playlist.

Deletes existing playlist.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Playlist id
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)

// Delete single playlist.
do {
    let response = try await PlaylistsAPI.playlistsIdDelete(id: id, idempotencyKey: idempotencyKey)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Playlist id | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 

### Return type

[**MutationResponseDocument**](MutationResponseDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistsIdGet**
```swift
    open class func playlistsIdGet(id: String, countryCode: String? = nil, include: [String]? = nil, includeLinkage: [IncludeLinkage_playlistsIdGet]? = nil, replaceMedia: String? = nil) async throws -> PlaylistsSingleResourceDataDocument
```

Get single playlist.

Retrieves single playlist by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Playlist id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: collaboratorProfiles, collaborators, coverArt, curators, items, ownerProfiles, owners, suggestedCoverArts (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: curators.albums (optional)

// Get single playlist.
do {
    let response = try await PlaylistsAPI.playlistsIdGet(id: id, countryCode: countryCode, include: include, includeLinkage: includeLinkage, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Playlist id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: collaboratorProfiles, collaborators, coverArt, curators, items, ownerProfiles, owners, suggestedCoverArts | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: curators.albums | [optional] 

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
    open class func playlistsIdPatch(id: String, idempotencyKey: String? = nil, playlistsUpdateOperationPayload: PlaylistsUpdateOperationPayload? = nil) async throws -> PlaylistsUpdateSingleResourceDataDocument
```

Update single playlist.

Updates existing playlist.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Playlist id
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let playlistsUpdateOperationPayload = PlaylistsUpdateOperation_Payload(data: PlaylistsUpdateOperation_Payload_Data(attributes: PlaylistsUpdateOperation_Payload_Data_Attributes(accessType: "accessType_example", description: "description_example", name: "name_example"), id: "id_example", type: "type_example")) // PlaylistsUpdateOperationPayload |  (optional)

// Update single playlist.
do {
    let response = try await PlaylistsAPI.playlistsIdPatch(id: id, idempotencyKey: idempotencyKey, playlistsUpdateOperationPayload: playlistsUpdateOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Playlist id | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **playlistsUpdateOperationPayload** | [**PlaylistsUpdateOperationPayload**](PlaylistsUpdateOperationPayload.md) |  | [optional] 

### Return type

[**PlaylistsUpdateSingleResourceDataDocument**](PlaylistsUpdateSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistsIdRelationshipsCollaboratorProfilesDelete**
```swift
    open class func playlistsIdRelationshipsCollaboratorProfilesDelete(id: String, idempotencyKey: String? = nil, playlistsCollaboratorProfilesRelationshipRemoveOperationPayload: PlaylistsCollaboratorProfilesRelationshipRemoveOperationPayload? = nil) async throws -> MutationResponseDocument
```

Delete from collaboratorProfiles relationship (\"to-many\").

Deletes item(s) from collaboratorProfiles relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Playlist id
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let playlistsCollaboratorProfilesRelationshipRemoveOperationPayload = PlaylistsCollaboratorProfilesRelationshipRemoveOperation_Payload(data: [PlaylistsCollaboratorProfilesRelationshipRemoveOperation_Payload_Data(id: "id_example", type: "type_example")]) // PlaylistsCollaboratorProfilesRelationshipRemoveOperationPayload |  (optional)

// Delete from collaboratorProfiles relationship (\"to-many\").
do {
    let response = try await PlaylistsAPI.playlistsIdRelationshipsCollaboratorProfilesDelete(id: id, idempotencyKey: idempotencyKey, playlistsCollaboratorProfilesRelationshipRemoveOperationPayload: playlistsCollaboratorProfilesRelationshipRemoveOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Playlist id | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **playlistsCollaboratorProfilesRelationshipRemoveOperationPayload** | [**PlaylistsCollaboratorProfilesRelationshipRemoveOperationPayload**](PlaylistsCollaboratorProfilesRelationshipRemoveOperationPayload.md) |  | [optional] 

### Return type

[**MutationResponseDocument**](MutationResponseDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistsIdRelationshipsCollaboratorProfilesGet**
```swift
    open class func playlistsIdRelationshipsCollaboratorProfilesGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> PlaylistsCollaboratorProfilesMultiRelationshipDataDocument
```

Get collaboratorProfiles relationship (\"to-many\").

Deprecated. Use curators for attribution.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Playlist id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: collaboratorProfiles (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get collaboratorProfiles relationship (\"to-many\").
do {
    let response = try await PlaylistsAPI.playlistsIdRelationshipsCollaboratorProfilesGet(id: id, include: include, pageCursor: pageCursor)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Playlist id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: collaboratorProfiles | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**PlaylistsCollaboratorProfilesMultiRelationshipDataDocument**](PlaylistsCollaboratorProfilesMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistsIdRelationshipsCollaboratorsGet**
```swift
    open class func playlistsIdRelationshipsCollaboratorsGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> PlaylistsCollaboratorsMultiRelationshipDataDocument
```

Get collaborators relationship (\"to-many\").

Retrieves collaborators relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Playlist id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: collaborators (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get collaborators relationship (\"to-many\").
do {
    let response = try await PlaylistsAPI.playlistsIdRelationshipsCollaboratorsGet(id: id, include: include, pageCursor: pageCursor)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Playlist id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: collaborators | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**PlaylistsCollaboratorsMultiRelationshipDataDocument**](PlaylistsCollaboratorsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistsIdRelationshipsCoverArtGet**
```swift
    open class func playlistsIdRelationshipsCoverArtGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil) async throws -> PlaylistsCoverArtMultiRelationshipDataDocument
```

Get coverArt relationship (\"to-many\").

Retrieves coverArt relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Playlist id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: coverArt (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get coverArt relationship (\"to-many\").
do {
    let response = try await PlaylistsAPI.playlistsIdRelationshipsCoverArtGet(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Playlist id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: coverArt | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**PlaylistsCoverArtMultiRelationshipDataDocument**](PlaylistsCoverArtMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistsIdRelationshipsCoverArtPatch**
```swift
    open class func playlistsIdRelationshipsCoverArtPatch(id: String, idempotencyKey: String? = nil, playlistsCoverArtRelationshipUpdateOperationPayload: PlaylistsCoverArtRelationshipUpdateOperationPayload? = nil) async throws -> MutationResponseDocument
```

Update coverArt relationship (\"to-many\").

Updates coverArt relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Playlist id
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let playlistsCoverArtRelationshipUpdateOperationPayload = PlaylistsCoverArtRelationshipUpdateOperation_Payload(data: [PlaylistsCoverArtRelationshipUpdateOperation_Payload_Data(id: "id_example", type: "type_example")]) // PlaylistsCoverArtRelationshipUpdateOperationPayload |  (optional)

// Update coverArt relationship (\"to-many\").
do {
    let response = try await PlaylistsAPI.playlistsIdRelationshipsCoverArtPatch(id: id, idempotencyKey: idempotencyKey, playlistsCoverArtRelationshipUpdateOperationPayload: playlistsCoverArtRelationshipUpdateOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Playlist id | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **playlistsCoverArtRelationshipUpdateOperationPayload** | [**PlaylistsCoverArtRelationshipUpdateOperationPayload**](PlaylistsCoverArtRelationshipUpdateOperationPayload.md) |  | [optional] 

### Return type

[**MutationResponseDocument**](MutationResponseDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistsIdRelationshipsCuratorsGet**
```swift
    open class func playlistsIdRelationshipsCuratorsGet(id: String, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil) async throws -> PlaylistsCuratorsMultiRelationshipDataDocument
```

Get curators relationship (\"to-many\").

Artist profiles credited for the playlist

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Playlist id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: curators (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: curators.albums (optional)

// Get curators relationship (\"to-many\").
do {
    let response = try await PlaylistsAPI.playlistsIdRelationshipsCuratorsGet(id: id, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Playlist id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: curators | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: curators.albums | [optional] 

### Return type

[**PlaylistsCuratorsMultiRelationshipDataDocument**](PlaylistsCuratorsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistsIdRelationshipsItemsDelete**
```swift
    open class func playlistsIdRelationshipsItemsDelete(id: String, idempotencyKey: String? = nil, playlistsItemsRelationshipRemoveOperationPayload: PlaylistsItemsRelationshipRemoveOperationPayload? = nil) async throws -> MutationResponseDocument
```

Delete from items relationship (\"to-many\").

Deletes item(s) from items relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Playlist id
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let playlistsItemsRelationshipRemoveOperationPayload = PlaylistsItemsRelationshipRemoveOperation_Payload(data: [PlaylistsItemsRelationshipRemoveOperation_Payload_Data(id: "id_example", meta: PlaylistsItemsRelationshipRemoveOperation_Payload_Data_Meta(itemId: "itemId_example"), type: "type_example")]) // PlaylistsItemsRelationshipRemoveOperationPayload |  (optional)

// Delete from items relationship (\"to-many\").
do {
    let response = try await PlaylistsAPI.playlistsIdRelationshipsItemsDelete(id: id, idempotencyKey: idempotencyKey, playlistsItemsRelationshipRemoveOperationPayload: playlistsItemsRelationshipRemoveOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Playlist id | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **playlistsItemsRelationshipRemoveOperationPayload** | [**PlaylistsItemsRelationshipRemoveOperationPayload**](PlaylistsItemsRelationshipRemoveOperationPayload.md) |  | [optional] 

### Return type

[**MutationResponseDocument**](MutationResponseDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistsIdRelationshipsItemsGet**
```swift
    open class func playlistsIdRelationshipsItemsGet(id: String, countryCode: String? = nil, filterQuery: String? = nil, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil, sort: [Sort_playlistsIdRelationshipsItemsGet]? = nil) async throws -> PlaylistsItemsMultiRelationshipDataDocument
```

Get items relationship (\"to-many\").

Retrieves items relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Playlist id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let filterQuery = "filterQuery_example" // String | Filter playlist items by a free-text query (e.g. `halo`) (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: items (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: items (optional)
let sort = ["sort_example"] // [String] | Values prefixed with \"-\" are sorted descending; values without it are sorted ascending. (optional)

// Get items relationship (\"to-many\").
do {
    let response = try await PlaylistsAPI.playlistsIdRelationshipsItemsGet(id: id, countryCode: countryCode, filterQuery: filterQuery, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia, sort: sort)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Playlist id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **filterQuery** | **String** | Filter playlist items by a free-text query (e.g. &#x60;halo&#x60;) | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: items | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: items | [optional] 
 **sort** | [**[String]**](String.md) | Values prefixed with \&quot;-\&quot; are sorted descending; values without it are sorted ascending. | [optional] 

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
    open class func playlistsIdRelationshipsItemsPatch(id: String, idempotencyKey: String? = nil, playlistsItemsRelationshipUpdateOperationPayload: PlaylistsItemsRelationshipUpdateOperationPayload? = nil) async throws -> MutationResponseDocument
```

Update items relationship (\"to-many\").

Updates items relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Playlist id
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let playlistsItemsRelationshipUpdateOperationPayload = PlaylistsItemsRelationshipUpdateOperation_Payload(data: [PlaylistsItemsRelationshipUpdateOperation_Payload_Data(id: "id_example", meta: PlaylistsItemsRelationshipUpdateOperation_Payload_Data_Meta(itemId: "itemId_example"), type: "type_example")], meta: PlaylistsItemsRelationshipUpdateOperation_Payload_Meta(positionBefore: "positionBefore_example")) // PlaylistsItemsRelationshipUpdateOperationPayload |  (optional)

// Update items relationship (\"to-many\").
do {
    let response = try await PlaylistsAPI.playlistsIdRelationshipsItemsPatch(id: id, idempotencyKey: idempotencyKey, playlistsItemsRelationshipUpdateOperationPayload: playlistsItemsRelationshipUpdateOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Playlist id | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **playlistsItemsRelationshipUpdateOperationPayload** | [**PlaylistsItemsRelationshipUpdateOperationPayload**](PlaylistsItemsRelationshipUpdateOperationPayload.md) |  | [optional] 

### Return type

[**MutationResponseDocument**](MutationResponseDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistsIdRelationshipsItemsPost**
```swift
    open class func playlistsIdRelationshipsItemsPost(id: String, idempotencyKey: String? = nil, playlistsItemsRelationshipAddOperationPayload: PlaylistsItemsRelationshipAddOperationPayload? = nil) async throws -> PlaylistsItemsAddMultiRelationshipDataDocument
```

Add to items relationship (\"to-many\").

Adds item(s) to items relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Playlist id
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let playlistsItemsRelationshipAddOperationPayload = PlaylistsItemsRelationshipAddOperation_Payload(data: [PlaylistsItemsRelationshipAddOperation_Payload_Data(id: "id_example", meta: PlaylistsItemsRelationshipAddOperation_Payload_Data_Meta(addedAt: Date()), type: "type_example")], meta: PlaylistsItemsRelationshipAddOperation_Payload_Meta(onDuplicates: "onDuplicates_example", positionBefore: "positionBefore_example")) // PlaylistsItemsRelationshipAddOperationPayload |  (optional)

// Add to items relationship (\"to-many\").
do {
    let response = try await PlaylistsAPI.playlistsIdRelationshipsItemsPost(id: id, idempotencyKey: idempotencyKey, playlistsItemsRelationshipAddOperationPayload: playlistsItemsRelationshipAddOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Playlist id | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **playlistsItemsRelationshipAddOperationPayload** | [**PlaylistsItemsRelationshipAddOperationPayload**](PlaylistsItemsRelationshipAddOperationPayload.md) |  | [optional] 

### Return type

[**PlaylistsItemsAddMultiRelationshipDataDocument**](PlaylistsItemsAddMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistsIdRelationshipsOwnerProfilesGet**
```swift
    open class func playlistsIdRelationshipsOwnerProfilesGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> PlaylistsOwnerProfilesMultiRelationshipDataDocument
```

Get ownerProfiles relationship (\"to-many\").

Deprecated. Use curators for attribution.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Playlist id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: ownerProfiles (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get ownerProfiles relationship (\"to-many\").
do {
    let response = try await PlaylistsAPI.playlistsIdRelationshipsOwnerProfilesGet(id: id, include: include, pageCursor: pageCursor)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Playlist id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: ownerProfiles | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**PlaylistsOwnerProfilesMultiRelationshipDataDocument**](PlaylistsOwnerProfilesMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistsIdRelationshipsOwnersGet**
```swift
    open class func playlistsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> PlaylistsOwnersMultiRelationshipDataDocument
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Playlist id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get owners relationship (\"to-many\").
do {
    let response = try await PlaylistsAPI.playlistsIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Playlist id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**PlaylistsOwnersMultiRelationshipDataDocument**](PlaylistsOwnersMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistsIdRelationshipsSuggestedCoverArtsGet**
```swift
    open class func playlistsIdRelationshipsSuggestedCoverArtsGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> PlaylistsSuggestedCoverArtsMultiRelationshipDataDocument
```

Get suggestedCoverArts relationship (\"to-many\").

Retrieves suggestedCoverArts relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Playlist id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: suggestedCoverArts (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get suggestedCoverArts relationship (\"to-many\").
do {
    let response = try await PlaylistsAPI.playlistsIdRelationshipsSuggestedCoverArtsGet(id: id, include: include, pageCursor: pageCursor)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Playlist id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: suggestedCoverArts | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**PlaylistsSuggestedCoverArtsMultiRelationshipDataDocument**](PlaylistsSuggestedCoverArtsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playlistsPost**
```swift
    open class func playlistsPost(idempotencyKey: String? = nil, playlistsCreateOperationPayload: PlaylistsCreateOperationPayload? = nil) async throws -> PlaylistsCreateSingleResourceDataDocument
```

Create single playlist.

Creates a new playlist.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let playlistsCreateOperationPayload = PlaylistsCreateOperation_Payload(data: PlaylistsCreateOperation_Payload_Data(attributes: PlaylistsCreateOperation_Payload_Data_Attributes(accessType: "accessType_example", createdAt: Date(), description: "description_example", name: "name_example"), type: "type_example")) // PlaylistsCreateOperationPayload |  (optional)

// Create single playlist.
do {
    let response = try await PlaylistsAPI.playlistsPost(idempotencyKey: idempotencyKey, playlistsCreateOperationPayload: playlistsCreateOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **playlistsCreateOperationPayload** | [**PlaylistsCreateOperationPayload**](PlaylistsCreateOperationPayload.md) |  | [optional] 

### Return type

[**PlaylistsCreateSingleResourceDataDocument**](PlaylistsCreateSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

