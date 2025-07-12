# ArtworksAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**artworksGet**](ArtworksAPI.md#artworksget) | **GET** /artworks | Get multiple artworks.
[**artworksIdGet**](ArtworksAPI.md#artworksidget) | **GET** /artworks/{id} | Get single artwork.
[**artworksIdRelationshipsOwnersGet**](ArtworksAPI.md#artworksidrelationshipsownersget) | **GET** /artworks/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
[**artworksPost**](ArtworksAPI.md#artworkspost) | **POST** /artworks | Create single artwork.


# **artworksGet**
```swift
    open class func artworksGet(countryCode: String, include: [String]? = nil, filterId: [String]? = nil, completion: @escaping (_ data: ArtworksMultiDataDocument?, _ error: Error?) -> Void)
```

Get multiple artworks.

Retrieves multiple artworks by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners (optional)
let filterId = ["inner_example"] // [String] | Artwork id (optional)

// Get multiple artworks.
ArtworksAPI.artworksGet(countryCode: countryCode, include: include, filterId: filterId) { (response, error) in
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
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners | [optional] 
 **filterId** | [**[String]**](String.md) | Artwork id | [optional] 

### Return type

[**ArtworksMultiDataDocument**](ArtworksMultiDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artworksIdGet**
```swift
    open class func artworksIdGet(id: String, countryCode: String, include: [String]? = nil, completion: @escaping (_ data: ArtworksSingleDataDocument?, _ error: Error?) -> Void)
```

Get single artwork.

Retrieves single artwork by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artwork id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners (optional)

// Get single artwork.
ArtworksAPI.artworksIdGet(id: id, countryCode: countryCode, include: include) { (response, error) in
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
 **id** | **String** | Artwork id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners | [optional] 

### Return type

[**ArtworksSingleDataDocument**](ArtworksSingleDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artworksIdRelationshipsOwnersGet**
```swift
    open class func artworksIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: ArtworksMultiDataRelationshipDocument?, _ error: Error?) -> Void)
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artwork id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get owners relationship (\"to-many\").
ArtworksAPI.artworksIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | Artwork id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**ArtworksMultiDataRelationshipDocument**](ArtworksMultiDataRelationshipDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artworksPost**
```swift
    open class func artworksPost(artworkCreateOperationPayload: ArtworkCreateOperationPayload? = nil, completion: @escaping (_ data: ArtworksSingleDataDocument?, _ error: Error?) -> Void)
```

Create single artwork.

Creates a new artwork.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let artworkCreateOperationPayload = ArtworkCreateOperation_Payload(data: ArtworkCreateOperation_Payload_Data(attributes: ArtworkCreateOperation_Payload_Data_Attributes(mediaType: "mediaType_example", sourceFile: ArtworkCreateOperation_Payload_Data_Attributes_SourceFile(md5Hash: "md5Hash_example", size: 123)), type: "type_example")) // ArtworkCreateOperationPayload |  (optional)

// Create single artwork.
ArtworksAPI.artworksPost(artworkCreateOperationPayload: artworkCreateOperationPayload) { (response, error) in
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
 **artworkCreateOperationPayload** | [**ArtworkCreateOperationPayload**](ArtworkCreateOperationPayload.md) |  | [optional] 

### Return type

[**ArtworksSingleDataDocument**](ArtworksSingleDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

