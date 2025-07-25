# AlbumsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**albumsGet**](AlbumsAPI.md#albumsget) | **GET** /albums | Get multiple albums.
[**albumsIdGet**](AlbumsAPI.md#albumsidget) | **GET** /albums/{id} | Get single album.
[**albumsIdRelationshipsArtistsGet**](AlbumsAPI.md#albumsidrelationshipsartistsget) | **GET** /albums/{id}/relationships/artists | Get artists relationship (\&quot;to-many\&quot;).
[**albumsIdRelationshipsCoverArtGet**](AlbumsAPI.md#albumsidrelationshipscoverartget) | **GET** /albums/{id}/relationships/coverArt | Get coverArt relationship (\&quot;to-many\&quot;).
[**albumsIdRelationshipsItemsGet**](AlbumsAPI.md#albumsidrelationshipsitemsget) | **GET** /albums/{id}/relationships/items | Get items relationship (\&quot;to-many\&quot;).
[**albumsIdRelationshipsOwnersGet**](AlbumsAPI.md#albumsidrelationshipsownersget) | **GET** /albums/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
[**albumsIdRelationshipsProvidersGet**](AlbumsAPI.md#albumsidrelationshipsprovidersget) | **GET** /albums/{id}/relationships/providers | Get providers relationship (\&quot;to-many\&quot;).
[**albumsIdRelationshipsSimilarAlbumsGet**](AlbumsAPI.md#albumsidrelationshipssimilaralbumsget) | **GET** /albums/{id}/relationships/similarAlbums | Get similarAlbums relationship (\&quot;to-many\&quot;).
[**albumsPost**](AlbumsAPI.md#albumspost) | **POST** /albums | Create single album.


# **albumsGet**
```swift
    open class func albumsGet(countryCode: String, pageCursor: String? = nil, include: [String]? = nil, filterROwnersId: [String]? = nil, filterId: [String]? = nil, filterBarcodeId: [String]? = nil, completion: @escaping (_ data: AlbumsMultiDataDocument?, _ error: Error?) -> Void)
```

Get multiple albums.

Retrieves multiple albums by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: artists, coverArt, items, owners, providers, similarAlbums (optional)
let filterROwnersId = ["inner_example"] // [String] | User id (optional)
let filterId = ["inner_example"] // [String] | Album id (optional)
let filterBarcodeId = ["inner_example"] // [String] | Barcode Id (optional)

// Get multiple albums.
AlbumsAPI.albumsGet(countryCode: countryCode, pageCursor: pageCursor, include: include, filterROwnersId: filterROwnersId, filterId: filterId, filterBarcodeId: filterBarcodeId) { (response, error) in
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
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: artists, coverArt, items, owners, providers, similarAlbums | [optional] 
 **filterROwnersId** | [**[String]**](String.md) | User id | [optional] 
 **filterId** | [**[String]**](String.md) | Album id | [optional] 
 **filterBarcodeId** | [**[String]**](String.md) | Barcode Id | [optional] 

### Return type

[**AlbumsMultiDataDocument**](AlbumsMultiDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **albumsIdGet**
```swift
    open class func albumsIdGet(id: String, countryCode: String, include: [String]? = nil, completion: @escaping (_ data: AlbumsSingleDataDocument?, _ error: Error?) -> Void)
```

Get single album.

Retrieves single album by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Album id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: artists, coverArt, items, owners, providers, similarAlbums (optional)

// Get single album.
AlbumsAPI.albumsIdGet(id: id, countryCode: countryCode, include: include) { (response, error) in
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
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: artists, coverArt, items, owners, providers, similarAlbums | [optional] 

### Return type

[**AlbumsSingleDataDocument**](AlbumsSingleDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **albumsIdRelationshipsArtistsGet**
```swift
    open class func albumsIdRelationshipsArtistsGet(id: String, countryCode: String, pageCursor: String? = nil, include: [String]? = nil, completion: @escaping (_ data: AlbumsMultiDataRelationshipDocument?, _ error: Error?) -> Void)
```

Get artists relationship (\"to-many\").

Retrieves artists relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Album id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: artists (optional)

// Get artists relationship (\"to-many\").
AlbumsAPI.albumsIdRelationshipsArtistsGet(id: id, countryCode: countryCode, pageCursor: pageCursor, include: include) { (response, error) in
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
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: artists | [optional] 

### Return type

[**AlbumsMultiDataRelationshipDocument**](AlbumsMultiDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **albumsIdRelationshipsCoverArtGet**
```swift
    open class func albumsIdRelationshipsCoverArtGet(id: String, countryCode: String, pageCursor: String? = nil, include: [String]? = nil, completion: @escaping (_ data: AlbumsMultiDataRelationshipDocument?, _ error: Error?) -> Void)
```

Get coverArt relationship (\"to-many\").

Retrieves coverArt relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Album id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: coverArt (optional)

// Get coverArt relationship (\"to-many\").
AlbumsAPI.albumsIdRelationshipsCoverArtGet(id: id, countryCode: countryCode, pageCursor: pageCursor, include: include) { (response, error) in
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
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: coverArt | [optional] 

### Return type

[**AlbumsMultiDataRelationshipDocument**](AlbumsMultiDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **albumsIdRelationshipsItemsGet**
```swift
    open class func albumsIdRelationshipsItemsGet(id: String, countryCode: String, pageCursor: String? = nil, include: [String]? = nil, completion: @escaping (_ data: AlbumsItemsMultiDataRelationshipDocument?, _ error: Error?) -> Void)
```

Get items relationship (\"to-many\").

Retrieves items relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Album id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: items (optional)

// Get items relationship (\"to-many\").
AlbumsAPI.albumsIdRelationshipsItemsGet(id: id, countryCode: countryCode, pageCursor: pageCursor, include: include) { (response, error) in
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
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: items | [optional] 

### Return type

[**AlbumsItemsMultiDataRelationshipDocument**](AlbumsItemsMultiDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **albumsIdRelationshipsOwnersGet**
```swift
    open class func albumsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: AlbumsMultiDataRelationshipDocument?, _ error: Error?) -> Void)
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

// Get owners relationship (\"to-many\").
AlbumsAPI.albumsIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor) { (response, error) in
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

### Return type

[**AlbumsMultiDataRelationshipDocument**](AlbumsMultiDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **albumsIdRelationshipsProvidersGet**
```swift
    open class func albumsIdRelationshipsProvidersGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: AlbumsMultiDataRelationshipDocument?, _ error: Error?) -> Void)
```

Get providers relationship (\"to-many\").

Retrieves providers relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Album id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: providers (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get providers relationship (\"to-many\").
AlbumsAPI.albumsIdRelationshipsProvidersGet(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor) { (response, error) in
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
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: providers | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**AlbumsMultiDataRelationshipDocument**](AlbumsMultiDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **albumsIdRelationshipsSimilarAlbumsGet**
```swift
    open class func albumsIdRelationshipsSimilarAlbumsGet(id: String, countryCode: String, pageCursor: String? = nil, include: [String]? = nil, completion: @escaping (_ data: AlbumsMultiDataRelationshipDocument?, _ error: Error?) -> Void)
```

Get similarAlbums relationship (\"to-many\").

Retrieves similarAlbums relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Album id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: similarAlbums (optional)

// Get similarAlbums relationship (\"to-many\").
AlbumsAPI.albumsIdRelationshipsSimilarAlbumsGet(id: id, countryCode: countryCode, pageCursor: pageCursor, include: include) { (response, error) in
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
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: similarAlbums | [optional] 

### Return type

[**AlbumsMultiDataRelationshipDocument**](AlbumsMultiDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **albumsPost**
```swift
    open class func albumsPost(albumCreateOperationPayload: AlbumCreateOperationPayload? = nil, completion: @escaping (_ data: AlbumsSingleDataDocument?, _ error: Error?) -> Void)
```

Create single album.

Creates a new album.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let albumCreateOperationPayload = AlbumCreateOperation_Payload(data: AlbumCreateOperation_Payload_Data(attributes: AlbumCreateOperation_Payload_Data_Attributes(copyright: AlbumCreateOperation_Payload_Data_Attributes_Copyright(text: "text_example", year: 123), explicitLyrics: false, genres: ["genres_example"], releaseDate: Date(), title: "title_example", upc: "upc_example", version: "version_example"), relationships: AlbumCreateOperation_Payload_Data_Relationships(artists: AlbumCreateOperation_Payload_Data_Relationships_Artists(data: [AlbumCreateOperation_Payload_Data_Relationships_Artists_Data(id: "id_example", type: "type_example")])), type: "type_example")) // AlbumCreateOperationPayload |  (optional)

// Create single album.
AlbumsAPI.albumsPost(albumCreateOperationPayload: albumCreateOperationPayload) { (response, error) in
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
 **albumCreateOperationPayload** | [**AlbumCreateOperationPayload**](AlbumCreateOperationPayload.md) |  | [optional] 

### Return type

[**AlbumsSingleDataDocument**](AlbumsSingleDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

