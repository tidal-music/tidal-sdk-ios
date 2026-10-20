# GenresAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**genresGet**](GenresAPI.md#genresget) | **GET** /genres | Get multiple genres.
[**genresIdGet**](GenresAPI.md#genresidget) | **GET** /genres/{id} | Get single genre.


# **genresGet**
```swift
    open class func genresGet(filterId: [String], locale: String? = nil, pageCursor: String? = nil) async throws -> GenresMultiResourceDataDocument
```

Get multiple genres.

Retrieves multiple genres by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let filterId = ["inner_example"] // [String] | Allows filtering by genre id(s). USER_SELECTABLE is special value used to return specific genres which users can select from (e.g. `'1,2,3' or 'USER_SELECTABLE'`)
let locale = "locale_example" // String | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. (optional) (default to "en-US")
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get multiple genres.
do {
    let response = try await GenresAPI.genresGet(filterId: filterId, locale: locale, pageCursor: pageCursor)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **filterId** | [**[String]**](String.md) | Allows filtering by genre id(s). USER_SELECTABLE is special value used to return specific genres which users can select from (e.g. &#x60;&#39;1,2,3&#39; or &#39;USER_SELECTABLE&#39;&#x60;) | 
 **locale** | **String** | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. | [optional] [default to &quot;en-US&quot;]
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**GenresMultiResourceDataDocument**](GenresMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **genresIdGet**
```swift
    open class func genresIdGet(id: String, locale: String? = nil) async throws -> GenresSingleResourceDataDocument
```

Get single genre.

Retrieves single genre by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Genre id
let locale = "locale_example" // String | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. (optional) (default to "en-US")

// Get single genre.
do {
    let response = try await GenresAPI.genresIdGet(id: id, locale: locale)
    dump(response)
} catch {
    print(error)
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String** | Genre id | 
 **locale** | **String** | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. | [optional] [default to &quot;en-US&quot;]

### Return type

[**GenresSingleResourceDataDocument**](GenresSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

