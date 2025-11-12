# SearchSuggestionsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**searchSuggestionsIdGet**](SearchSuggestionsAPI.md#searchsuggestionsidget) | **GET** /searchSuggestions/{id} | Get single searchSuggestion.
[**searchSuggestionsIdRelationshipsDirectHitsGet**](SearchSuggestionsAPI.md#searchsuggestionsidrelationshipsdirecthitsget) | **GET** /searchSuggestions/{id}/relationships/directHits | Get directHits relationship (\&quot;to-many\&quot;).


# **searchSuggestionsIdGet**
```swift
    open class func searchSuggestionsIdGet(id: String, explicitFilter: ExplicitFilter_searchSuggestionsIdGet? = nil, countryCode: String? = nil, include: [String]? = nil, completion: @escaping (_ data: SearchSuggestionsSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single searchSuggestion.

Retrieves single searchSuggestion by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | 
let explicitFilter = "explicitFilter_example" // String | Explicit filter (optional) (default to .include)
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: directHits (optional)

// Get single searchSuggestion.
SearchSuggestionsAPI.searchSuggestionsIdGet(id: id, explicitFilter: explicitFilter, countryCode: countryCode, include: include) { (response, error) in
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
 **id** | **String** |  | 
 **explicitFilter** | **String** | Explicit filter | [optional] [default to .include]
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: directHits | [optional] 

### Return type

[**SearchSuggestionsSingleResourceDataDocument**](SearchSuggestionsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **searchSuggestionsIdRelationshipsDirectHitsGet**
```swift
    open class func searchSuggestionsIdRelationshipsDirectHitsGet(id: String, explicitFilter: ExplicitFilter_searchSuggestionsIdRelationshipsDirectHitsGet? = nil, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: SearchSuggestionsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get directHits relationship (\"to-many\").

Retrieves directHits relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | 
let explicitFilter = "explicitFilter_example" // String | Explicit filter (optional) (default to .include)
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: directHits (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get directHits relationship (\"to-many\").
SearchSuggestionsAPI.searchSuggestionsIdRelationshipsDirectHitsGet(id: id, explicitFilter: explicitFilter, countryCode: countryCode, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** |  | 
 **explicitFilter** | **String** | Explicit filter | [optional] [default to .include]
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: directHits | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**SearchSuggestionsMultiRelationshipDataDocument**](SearchSuggestionsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

