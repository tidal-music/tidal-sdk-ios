# GenresAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**genresGet**](GenresAPI.md#genresget) | **GET** /genres | Get multiple genres.
[**genresIdGet**](GenresAPI.md#genresidget) | **GET** /genres/{id} | Get single genre.


# **genresGet**
```swift
    open class func genresGet(pageCursor: String? = nil, locale: String? = nil, filterId: [String]? = nil, completion: @escaping (_ data: GenresMultiResourceDataDocument?, _ error: Error?) -> Void)
```

Get multiple genres.

Retrieves multiple genres by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let locale = "locale_example" // String | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. (optional) (default to "en-US")
let filterId = ["inner_example"] // [String] | Allows filtering by genre id(s). USER_SELECTABLE is special value used to return specific genres which users can select from (e.g. `'1,2,3' or 'USER_SELECTABLE'`) (optional)

// Get multiple genres.
GenresAPI.genresGet(pageCursor: pageCursor, locale: locale, filterId: filterId) { (response, error) in
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
 **locale** | **String** | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. | [optional] [default to &quot;en-US&quot;]
 **filterId** | [**[String]**](String.md) | Allows filtering by genre id(s). USER_SELECTABLE is special value used to return specific genres which users can select from (e.g. &#x60;&#39;1,2,3&#39; or &#39;USER_SELECTABLE&#39;&#x60;) | [optional] 

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
    open class func genresIdGet(id: String, locale: String? = nil, completion: @escaping (_ data: GenresSingleResourceDataDocument?, _ error: Error?) -> Void)
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
GenresAPI.genresIdGet(id: id, locale: locale) { (response, error) in
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

