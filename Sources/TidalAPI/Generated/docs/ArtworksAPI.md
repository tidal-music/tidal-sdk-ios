# ArtworksAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**artworksGet**](ArtworksAPI.md#artworksget) | **GET** /artworks | Get multiple artworks.
[**artworksIdGet**](ArtworksAPI.md#artworksidget) | **GET** /artworks/{id} | Get single artwork.


# **artworksGet**
```swift
    open class func artworksGet(countryCode: String, filterId: [String]? = nil, completion: @escaping (_ data: ArtworksMultiDataDocument?, _ error: Error?) -> Void)
```

Get multiple artworks.

Retrieves multiple artworks by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code
let filterId = ["inner_example"] // [String] | Artwork id (optional)

// Get multiple artworks.
ArtworksAPI.artworksGet(countryCode: countryCode, filterId: filterId) { (response, error) in
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
    open class func artworksIdGet(id: String, countryCode: String, completion: @escaping (_ data: ArtworksSingleDataDocument?, _ error: Error?) -> Void)
```

Get single artwork.

Retrieves single artwork by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artwork id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code

// Get single artwork.
ArtworksAPI.artworksIdGet(id: id, countryCode: countryCode) { (response, error) in
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

### Return type

[**ArtworksSingleDataDocument**](ArtworksSingleDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

