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
    open class func artworksGet(filterId: [String], countryCode: String? = nil, include: [String]? = nil, includeLinkage: [IncludeLinkage_artworksGet]? = nil) async throws -> ArtworksMultiResourceDataDocument
```

Get multiple artworks.

Retrieves multiple artworks by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let filterId = ["inner_example"] // [String] | Artwork id (e.g. `a468bee88def`)
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: owners (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)

// Get multiple artworks.
do {
    let response = try await ArtworksAPI.artworksGet(filterId: filterId, countryCode: countryCode, include: include, includeLinkage: includeLinkage)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **filterId** | [**[String]**](String.md) | Artwork id (e.g. &#x60;a468bee88def&#x60;) | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: owners | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 

### Return type

[**ArtworksMultiResourceDataDocument**](ArtworksMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artworksIdGet**
```swift
    open class func artworksIdGet(id: String, countryCode: String? = nil, include: [String]? = nil, includeLinkage: [IncludeLinkage_artworksIdGet]? = nil) async throws -> ArtworksSingleResourceDataDocument
```

Get single artwork.

Retrieves single artwork by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artwork id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: owners (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)

// Get single artwork.
do {
    let response = try await ArtworksAPI.artworksIdGet(id: id, countryCode: countryCode, include: include, includeLinkage: includeLinkage)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Artwork id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: owners | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 

### Return type

[**ArtworksSingleResourceDataDocument**](ArtworksSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artworksIdRelationshipsOwnersGet**
```swift
    open class func artworksIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> ArtworksOwnersMultiRelationshipDataDocument
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artwork id
let include = ["inner_example"] // [String] | Include related resources. Available relationships: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get owners relationship (\"to-many\").
do {
    let response = try await ArtworksAPI.artworksIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Artwork id | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**ArtworksOwnersMultiRelationshipDataDocument**](ArtworksOwnersMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artworksPost**
```swift
    open class func artworksPost(idempotencyKey: String? = nil, artworksCreateOperationPayload: ArtworksCreateOperationPayload? = nil) async throws -> ArtworksCreateSingleResourceDataDocument
```

Create single artwork.

Creates a new artwork.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let artworksCreateOperationPayload = ArtworksCreateOperation_Payload(data: ArtworksCreateOperation_Payload_Data(attributes: ArtworksCreateOperation_Payload_Data_Attributes(mediaType: "mediaType_example", sourceFile: ArtworksCreateOperation_Payload_Data_Attributes_SourceFile(md5Hash: "md5Hash_example", size: 123)), type: "type_example")) // ArtworksCreateOperationPayload |  (optional)

// Create single artwork.
do {
    let response = try await ArtworksAPI.artworksPost(idempotencyKey: idempotencyKey, artworksCreateOperationPayload: artworksCreateOperationPayload)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **artworksCreateOperationPayload** | [**ArtworksCreateOperationPayload**](ArtworksCreateOperationPayload.md) |  | [optional] 

### Return type

[**ArtworksCreateSingleResourceDataDocument**](ArtworksCreateSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

