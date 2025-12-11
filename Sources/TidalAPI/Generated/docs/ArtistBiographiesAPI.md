# ArtistBiographiesAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**artistBiographiesGet**](ArtistBiographiesAPI.md#artistbiographiesget) | **GET** /artistBiographies | Get multiple artistBiographies.
[**artistBiographiesIdGet**](ArtistBiographiesAPI.md#artistbiographiesidget) | **GET** /artistBiographies/{id} | Get single artistBiographie.
[**artistBiographiesIdPatch**](ArtistBiographiesAPI.md#artistbiographiesidpatch) | **PATCH** /artistBiographies/{id} | Update single artistBiographie.
[**artistBiographiesIdRelationshipsOwnersGet**](ArtistBiographiesAPI.md#artistbiographiesidrelationshipsownersget) | **GET** /artistBiographies/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).


# **artistBiographiesGet**
```swift
    open class func artistBiographiesGet(countryCode: String, include: [String]? = nil, filterId: [String]? = nil, completion: @escaping (_ data: ArtistBiographiesMultiResourceDataDocument?, _ error: Error?) -> Void)
```

Get multiple artistBiographies.

Retrieves multiple artistBiographies by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners (optional)
let filterId = ["inner_example"] // [String] | Artist id (optional)

// Get multiple artistBiographies.
ArtistBiographiesAPI.artistBiographiesGet(countryCode: countryCode, include: include, filterId: filterId) { (response, error) in
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
 **filterId** | [**[String]**](String.md) | Artist id | [optional] 

### Return type

[**ArtistBiographiesMultiResourceDataDocument**](ArtistBiographiesMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artistBiographiesIdGet**
```swift
    open class func artistBiographiesIdGet(id: String, countryCode: String, include: [String]? = nil, completion: @escaping (_ data: ArtistBiographiesSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single artistBiographie.

Retrieves single artistBiographie by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist biography id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners (optional)

// Get single artistBiographie.
ArtistBiographiesAPI.artistBiographiesIdGet(id: id, countryCode: countryCode, include: include) { (response, error) in
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
 **id** | **String** | Artist biography id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners | [optional] 

### Return type

[**ArtistBiographiesSingleResourceDataDocument**](ArtistBiographiesSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artistBiographiesIdPatch**
```swift
    open class func artistBiographiesIdPatch(id: String, artistBiographyUpdateBody: ArtistBiographyUpdateBody? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Update single artistBiographie.

Updates existing artistBiographie.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist biography id
let artistBiographyUpdateBody = ArtistBiographyUpdateBody(data: ArtistBiographyUpdateBody_Data(attributes: ArtistBiographyUpdateBody_Data_Attributes(text: "text_example"), id: "id_example", type: "type_example")) // ArtistBiographyUpdateBody |  (optional)

// Update single artistBiographie.
ArtistBiographiesAPI.artistBiographiesIdPatch(id: id, artistBiographyUpdateBody: artistBiographyUpdateBody) { (response, error) in
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
 **id** | **String** | Artist biography id | 
 **artistBiographyUpdateBody** | [**ArtistBiographyUpdateBody**](ArtistBiographyUpdateBody.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artistBiographiesIdRelationshipsOwnersGet**
```swift
    open class func artistBiographiesIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: ArtistBiographiesMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist biography id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get owners relationship (\"to-many\").
ArtistBiographiesAPI.artistBiographiesIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | Artist biography id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**ArtistBiographiesMultiRelationshipDataDocument**](ArtistBiographiesMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

