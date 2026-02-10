# AlbumsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**albumsGet**](AlbumsAPI.md#albumsget) | **GET** /albums | Get multiple albums.
[**albumsIdDelete**](AlbumsAPI.md#albumsiddelete) | **DELETE** /albums/{id} | Delete single album.
[**albumsIdGet**](AlbumsAPI.md#albumsidget) | **GET** /albums/{id} | Get single album.
[**albumsIdPatch**](AlbumsAPI.md#albumsidpatch) | **PATCH** /albums/{id} | Update single album.
[**albumsIdRelationshipsArtistsGet**](AlbumsAPI.md#albumsidrelationshipsartistsget) | **GET** /albums/{id}/relationships/artists | Get artists relationship (\&quot;to-many\&quot;).
[**albumsIdRelationshipsCoverArtGet**](AlbumsAPI.md#albumsidrelationshipscoverartget) | **GET** /albums/{id}/relationships/coverArt | Get coverArt relationship (\&quot;to-many\&quot;).
[**albumsIdRelationshipsCoverArtPatch**](AlbumsAPI.md#albumsidrelationshipscoverartpatch) | **PATCH** /albums/{id}/relationships/coverArt | Update coverArt relationship (\&quot;to-many\&quot;).
[**albumsIdRelationshipsGenresGet**](AlbumsAPI.md#albumsidrelationshipsgenresget) | **GET** /albums/{id}/relationships/genres | Get genres relationship (\&quot;to-many\&quot;).
[**albumsIdRelationshipsItemsGet**](AlbumsAPI.md#albumsidrelationshipsitemsget) | **GET** /albums/{id}/relationships/items | Get items relationship (\&quot;to-many\&quot;).
[**albumsIdRelationshipsItemsPatch**](AlbumsAPI.md#albumsidrelationshipsitemspatch) | **PATCH** /albums/{id}/relationships/items | Update items relationship (\&quot;to-many\&quot;).
[**albumsIdRelationshipsOwnersGet**](AlbumsAPI.md#albumsidrelationshipsownersget) | **GET** /albums/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
[**albumsIdRelationshipsPriceConfigGet**](AlbumsAPI.md#albumsidrelationshipspriceconfigget) | **GET** /albums/{id}/relationships/priceConfig | Get priceConfig relationship (\&quot;to-one\&quot;).
[**albumsIdRelationshipsProvidersGet**](AlbumsAPI.md#albumsidrelationshipsprovidersget) | **GET** /albums/{id}/relationships/providers | Get providers relationship (\&quot;to-many\&quot;).
[**albumsIdRelationshipsReplacementGet**](AlbumsAPI.md#albumsidrelationshipsreplacementget) | **GET** /albums/{id}/relationships/replacement | Get replacement relationship (\&quot;to-one\&quot;).
[**albumsIdRelationshipsSimilarAlbumsGet**](AlbumsAPI.md#albumsidrelationshipssimilaralbumsget) | **GET** /albums/{id}/relationships/similarAlbums | Get similarAlbums relationship (\&quot;to-many\&quot;).
[**albumsIdRelationshipsSuggestedCoverArtsGet**](AlbumsAPI.md#albumsidrelationshipssuggestedcoverartsget) | **GET** /albums/{id}/relationships/suggestedCoverArts | Get suggestedCoverArts relationship (\&quot;to-many\&quot;).
[**albumsIdRelationshipsUsageRulesGet**](AlbumsAPI.md#albumsidrelationshipsusagerulesget) | **GET** /albums/{id}/relationships/usageRules | Get usageRules relationship (\&quot;to-one\&quot;).
[**albumsPost**](AlbumsAPI.md#albumspost) | **POST** /albums | Create single album.


# **albumsGet**
```swift
    open class func albumsGet(pageCursor: String? = nil, countryCode: String? = nil, include: [String]? = nil, filterBarcodeId: [String]? = nil, filterId: [String]? = nil, filterOwnersId: [String]? = nil, shareCode: String? = nil, completion: @escaping (_ data: AlbumsMultiResourceDataDocument?, _ error: Error?) -> Void)
```

Get multiple albums.

Retrieves multiple albums by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: artists, coverArt, genres, items, owners, priceConfig, providers, replacement, similarAlbums, suggestedCoverArts, usageRules (optional)
let filterBarcodeId = ["inner_example"] // [String] | List of barcode IDs (EAN-13 or UPC-A). NOTE: Supplying more than one barcode ID will currently only return one album per barcode ID. (optional)
let filterId = ["inner_example"] // [String] | Album id (optional)
let filterOwnersId = ["inner_example"] // [String] | User id (optional)
let shareCode = "shareCode_example" // String | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. (optional)

// Get multiple albums.
AlbumsAPI.albumsGet(pageCursor: pageCursor, countryCode: countryCode, include: include, filterBarcodeId: filterBarcodeId, filterId: filterId, filterOwnersId: filterOwnersId, shareCode: shareCode) { (response, error) in
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
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: artists, coverArt, genres, items, owners, priceConfig, providers, replacement, similarAlbums, suggestedCoverArts, usageRules | [optional] 
 **filterBarcodeId** | [**[String]**](String.md) | List of barcode IDs (EAN-13 or UPC-A). NOTE: Supplying more than one barcode ID will currently only return one album per barcode ID. | [optional] 
 **filterId** | [**[String]**](String.md) | Album id | [optional] 
 **filterOwnersId** | [**[String]**](String.md) | User id | [optional] 
 **shareCode** | **String** | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. | [optional] 

### Return type

[**AlbumsMultiResourceDataDocument**](AlbumsMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **albumsIdDelete**
```swift
    open class func albumsIdDelete(id: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Delete single album.

Deletes existing album.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Album id

// Delete single album.
AlbumsAPI.albumsIdDelete(id: id) { (response, error) in
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
 **id** | **String** | Album id | 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **albumsIdGet**
```swift
    open class func albumsIdGet(id: String, countryCode: String? = nil, include: [String]? = nil, shareCode: String? = nil, completion: @escaping (_ data: AlbumsSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single album.

Retrieves single album by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Album id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: artists, coverArt, genres, items, owners, priceConfig, providers, replacement, similarAlbums, suggestedCoverArts, usageRules (optional)
let shareCode = "shareCode_example" // String | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. (optional)

// Get single album.
AlbumsAPI.albumsIdGet(id: id, countryCode: countryCode, include: include, shareCode: shareCode) { (response, error) in
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
 **id** | **String** | Album id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: artists, coverArt, genres, items, owners, priceConfig, providers, replacement, similarAlbums, suggestedCoverArts, usageRules | [optional] 
 **shareCode** | **String** | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. | [optional] 

### Return type

[**AlbumsSingleResourceDataDocument**](AlbumsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **albumsIdPatch**
```swift
    open class func albumsIdPatch(id: String, albumsUpdateOperationPayload: AlbumsUpdateOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Update single album.

Updates existing album.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Album id
let albumsUpdateOperationPayload = AlbumsUpdateOperation_Payload(data: AlbumsUpdateOperation_Payload_Data(attributes: AlbumsUpdateOperation_Payload_Data_Attributes(accessType: "accessType_example", albumType: "albumType_example", copyright: Copyright(text: "text_example"), explicit: false, explicitLyrics: false, releaseDate: Date(), title: "title_example", version: "version_example"), id: "id_example", relationships: AlbumsUpdateOperation_Payload_Data_Relationships(genres: AlbumsUpdateOperation_Payload_Data_Relationships_Genres(data: [AlbumsUpdateOperation_Payload_Data_Relationships_Genres_Data(id: "id_example", type: "type_example")])), type: "type_example")) // AlbumsUpdateOperationPayload |  (optional)

// Update single album.
AlbumsAPI.albumsIdPatch(id: id, albumsUpdateOperationPayload: albumsUpdateOperationPayload) { (response, error) in
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
 **id** | **String** | Album id | 
 **albumsUpdateOperationPayload** | [**AlbumsUpdateOperationPayload**](AlbumsUpdateOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **albumsIdRelationshipsArtistsGet**
```swift
    open class func albumsIdRelationshipsArtistsGet(id: String, pageCursor: String? = nil, countryCode: String? = nil, include: [String]? = nil, shareCode: String? = nil, completion: @escaping (_ data: AlbumsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get artists relationship (\"to-many\").

Retrieves artists relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Album id
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: artists (optional)
let shareCode = "shareCode_example" // String | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. (optional)

// Get artists relationship (\"to-many\").
AlbumsAPI.albumsIdRelationshipsArtistsGet(id: id, pageCursor: pageCursor, countryCode: countryCode, include: include, shareCode: shareCode) { (response, error) in
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
 **id** | **String** | Album id | 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: artists | [optional] 
 **shareCode** | **String** | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. | [optional] 

### Return type

[**AlbumsMultiRelationshipDataDocument**](AlbumsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **albumsIdRelationshipsCoverArtGet**
```swift
    open class func albumsIdRelationshipsCoverArtGet(id: String, pageCursor: String? = nil, countryCode: String? = nil, include: [String]? = nil, shareCode: String? = nil, completion: @escaping (_ data: AlbumsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get coverArt relationship (\"to-many\").

Retrieves coverArt relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Album id
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: coverArt (optional)
let shareCode = "shareCode_example" // String | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. (optional)

// Get coverArt relationship (\"to-many\").
AlbumsAPI.albumsIdRelationshipsCoverArtGet(id: id, pageCursor: pageCursor, countryCode: countryCode, include: include, shareCode: shareCode) { (response, error) in
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
 **id** | **String** | Album id | 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: coverArt | [optional] 
 **shareCode** | **String** | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. | [optional] 

### Return type

[**AlbumsMultiRelationshipDataDocument**](AlbumsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **albumsIdRelationshipsCoverArtPatch**
```swift
    open class func albumsIdRelationshipsCoverArtPatch(id: String, albumsCoverArtRelationshipUpdateOperationPayload: AlbumsCoverArtRelationshipUpdateOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Update coverArt relationship (\"to-many\").

Updates coverArt relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Album id
let albumsCoverArtRelationshipUpdateOperationPayload = AlbumsCoverArtRelationshipUpdateOperation_Payload(data: [AlbumsCoverArtRelationshipUpdateOperation_Payload_Data(id: "id_example", type: "type_example")]) // AlbumsCoverArtRelationshipUpdateOperationPayload |  (optional)

// Update coverArt relationship (\"to-many\").
AlbumsAPI.albumsIdRelationshipsCoverArtPatch(id: id, albumsCoverArtRelationshipUpdateOperationPayload: albumsCoverArtRelationshipUpdateOperationPayload) { (response, error) in
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
 **id** | **String** | Album id | 
 **albumsCoverArtRelationshipUpdateOperationPayload** | [**AlbumsCoverArtRelationshipUpdateOperationPayload**](AlbumsCoverArtRelationshipUpdateOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **albumsIdRelationshipsGenresGet**
```swift
    open class func albumsIdRelationshipsGenresGet(id: String, pageCursor: String? = nil, countryCode: String? = nil, include: [String]? = nil, shareCode: String? = nil, completion: @escaping (_ data: AlbumsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get genres relationship (\"to-many\").

Retrieves genres relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Album id
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: genres (optional)
let shareCode = "shareCode_example" // String | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. (optional)

// Get genres relationship (\"to-many\").
AlbumsAPI.albumsIdRelationshipsGenresGet(id: id, pageCursor: pageCursor, countryCode: countryCode, include: include, shareCode: shareCode) { (response, error) in
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
 **id** | **String** | Album id | 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: genres | [optional] 
 **shareCode** | **String** | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. | [optional] 

### Return type

[**AlbumsMultiRelationshipDataDocument**](AlbumsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **albumsIdRelationshipsItemsGet**
```swift
    open class func albumsIdRelationshipsItemsGet(id: String, pageCursor: String? = nil, countryCode: String? = nil, include: [String]? = nil, shareCode: String? = nil, completion: @escaping (_ data: AlbumsItemsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get items relationship (\"to-many\").

Retrieves items relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Album id
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: items (optional)
let shareCode = "shareCode_example" // String | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. (optional)

// Get items relationship (\"to-many\").
AlbumsAPI.albumsIdRelationshipsItemsGet(id: id, pageCursor: pageCursor, countryCode: countryCode, include: include, shareCode: shareCode) { (response, error) in
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
 **id** | **String** | Album id | 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: items | [optional] 
 **shareCode** | **String** | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. | [optional] 

### Return type

[**AlbumsItemsMultiRelationshipDataDocument**](AlbumsItemsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **albumsIdRelationshipsItemsPatch**
```swift
    open class func albumsIdRelationshipsItemsPatch(id: String, albumsItemsRelationshipUpdateOperationPayload: AlbumsItemsRelationshipUpdateOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Update items relationship (\"to-many\").

Updates items relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Album id
let albumsItemsRelationshipUpdateOperationPayload = AlbumsItemsRelationshipUpdateOperation_Payload(data: [AlbumsItemsRelationshipUpdateOperation_Payload_Data(id: "id_example", type: "type_example")], meta: AlbumsItemsRelationshipUpdateOperation_Payload_Meta(positionIndex: 123)) // AlbumsItemsRelationshipUpdateOperationPayload |  (optional)

// Update items relationship (\"to-many\").
AlbumsAPI.albumsIdRelationshipsItemsPatch(id: id, albumsItemsRelationshipUpdateOperationPayload: albumsItemsRelationshipUpdateOperationPayload) { (response, error) in
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
 **id** | **String** | Album id | 
 **albumsItemsRelationshipUpdateOperationPayload** | [**AlbumsItemsRelationshipUpdateOperationPayload**](AlbumsItemsRelationshipUpdateOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **albumsIdRelationshipsOwnersGet**
```swift
    open class func albumsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil, shareCode: String? = nil, completion: @escaping (_ data: AlbumsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Album id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let shareCode = "shareCode_example" // String | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. (optional)

// Get owners relationship (\"to-many\").
AlbumsAPI.albumsIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor, shareCode: shareCode) { (response, error) in
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
 **id** | **String** | Album id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **shareCode** | **String** | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. | [optional] 

### Return type

[**AlbumsMultiRelationshipDataDocument**](AlbumsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **albumsIdRelationshipsPriceConfigGet**
```swift
    open class func albumsIdRelationshipsPriceConfigGet(id: String, countryCode: String? = nil, include: [String]? = nil, shareCode: String? = nil, completion: @escaping (_ data: AlbumsSingleRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get priceConfig relationship (\"to-one\").

Retrieves priceConfig relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Album id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: priceConfig (optional)
let shareCode = "shareCode_example" // String | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. (optional)

// Get priceConfig relationship (\"to-one\").
AlbumsAPI.albumsIdRelationshipsPriceConfigGet(id: id, countryCode: countryCode, include: include, shareCode: shareCode) { (response, error) in
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
 **id** | **String** | Album id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: priceConfig | [optional] 
 **shareCode** | **String** | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. | [optional] 

### Return type

[**AlbumsSingleRelationshipDataDocument**](AlbumsSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **albumsIdRelationshipsProvidersGet**
```swift
    open class func albumsIdRelationshipsProvidersGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil, shareCode: String? = nil, completion: @escaping (_ data: AlbumsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get providers relationship (\"to-many\").

Retrieves providers relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Album id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: providers (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let shareCode = "shareCode_example" // String | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. (optional)

// Get providers relationship (\"to-many\").
AlbumsAPI.albumsIdRelationshipsProvidersGet(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor, shareCode: shareCode) { (response, error) in
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
 **id** | **String** | Album id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: providers | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **shareCode** | **String** | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. | [optional] 

### Return type

[**AlbumsMultiRelationshipDataDocument**](AlbumsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **albumsIdRelationshipsReplacementGet**
```swift
    open class func albumsIdRelationshipsReplacementGet(id: String, countryCode: String? = nil, include: [String]? = nil, shareCode: String? = nil, completion: @escaping (_ data: AlbumsSingleRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get replacement relationship (\"to-one\").

Retrieves replacement relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Album id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: replacement (optional)
let shareCode = "shareCode_example" // String | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. (optional)

// Get replacement relationship (\"to-one\").
AlbumsAPI.albumsIdRelationshipsReplacementGet(id: id, countryCode: countryCode, include: include, shareCode: shareCode) { (response, error) in
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
 **id** | **String** | Album id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: replacement | [optional] 
 **shareCode** | **String** | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. | [optional] 

### Return type

[**AlbumsSingleRelationshipDataDocument**](AlbumsSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **albumsIdRelationshipsSimilarAlbumsGet**
```swift
    open class func albumsIdRelationshipsSimilarAlbumsGet(id: String, pageCursor: String? = nil, countryCode: String? = nil, include: [String]? = nil, shareCode: String? = nil, completion: @escaping (_ data: AlbumsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get similarAlbums relationship (\"to-many\").

Retrieves similarAlbums relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Album id
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: similarAlbums (optional)
let shareCode = "shareCode_example" // String | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. (optional)

// Get similarAlbums relationship (\"to-many\").
AlbumsAPI.albumsIdRelationshipsSimilarAlbumsGet(id: id, pageCursor: pageCursor, countryCode: countryCode, include: include, shareCode: shareCode) { (response, error) in
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
 **id** | **String** | Album id | 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: similarAlbums | [optional] 
 **shareCode** | **String** | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. | [optional] 

### Return type

[**AlbumsMultiRelationshipDataDocument**](AlbumsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **albumsIdRelationshipsSuggestedCoverArtsGet**
```swift
    open class func albumsIdRelationshipsSuggestedCoverArtsGet(id: String, include: [String]? = nil, pageCursor: String? = nil, shareCode: String? = nil, completion: @escaping (_ data: AlbumsSuggestedCoverArtsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get suggestedCoverArts relationship (\"to-many\").

Retrieves suggestedCoverArts relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Album id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: suggestedCoverArts (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let shareCode = "shareCode_example" // String | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. (optional)

// Get suggestedCoverArts relationship (\"to-many\").
AlbumsAPI.albumsIdRelationshipsSuggestedCoverArtsGet(id: id, include: include, pageCursor: pageCursor, shareCode: shareCode) { (response, error) in
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
 **id** | **String** | Album id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: suggestedCoverArts | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **shareCode** | **String** | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. | [optional] 

### Return type

[**AlbumsSuggestedCoverArtsMultiRelationshipDataDocument**](AlbumsSuggestedCoverArtsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **albumsIdRelationshipsUsageRulesGet**
```swift
    open class func albumsIdRelationshipsUsageRulesGet(id: String, countryCode: String? = nil, include: [String]? = nil, shareCode: String? = nil, completion: @escaping (_ data: AlbumsSingleRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get usageRules relationship (\"to-one\").

Retrieves usageRules relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Album id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: usageRules (optional)
let shareCode = "shareCode_example" // String | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. (optional)

// Get usageRules relationship (\"to-one\").
AlbumsAPI.albumsIdRelationshipsUsageRulesGet(id: id, countryCode: countryCode, include: include, shareCode: shareCode) { (response, error) in
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
 **id** | **String** | Album id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: usageRules | [optional] 
 **shareCode** | **String** | Share code that grants access to UNLISTED resources. When provided, allows non-owners to access resources that would otherwise be restricted. | [optional] 

### Return type

[**AlbumsSingleRelationshipDataDocument**](AlbumsSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **albumsPost**
```swift
    open class func albumsPost(albumsCreateOperationPayload: AlbumsCreateOperationPayload? = nil, completion: @escaping (_ data: AlbumsSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Create single album.

Creates a new album.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let albumsCreateOperationPayload = AlbumsCreateOperation_Payload(data: AlbumsCreateOperation_Payload_Data(attributes: AlbumsCreateOperation_Payload_Data_Attributes(albumType: "albumType_example", barcodeId: "barcodeId_example", copyright: Copyright(text: "text_example"), explicit: false, explicitLyrics: false, releaseDate: Date(), title: "title_example", upc: "upc_example", version: "version_example"), relationships: AlbumsCreateOperation_Payload_Data_Relationships(artists: AlbumsCreateOperation_Payload_Data_Relationships_Artists(data: [AlbumsCreateOperation_Payload_Data_Relationships_Artists_Data(id: "id_example", type: "type_example")]), genres: AlbumsCreateOperation_Payload_Data_Relationships_Genres(data: [AlbumsCreateOperation_Payload_Data_Relationships_Genres_Data(id: "id_example", type: "type_example")])), type: "type_example")) // AlbumsCreateOperationPayload |  (optional)

// Create single album.
AlbumsAPI.albumsPost(albumsCreateOperationPayload: albumsCreateOperationPayload) { (response, error) in
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
 **albumsCreateOperationPayload** | [**AlbumsCreateOperationPayload**](AlbumsCreateOperationPayload.md) |  | [optional] 

### Return type

[**AlbumsSingleResourceDataDocument**](AlbumsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

