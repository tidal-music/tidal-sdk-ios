# ProviderProductInfosAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**providerProductInfosGet**](ProviderProductInfosAPI.md#providerproductinfosget) | **GET** /providerProductInfos | Get multiple providerProductInfos.
[**providerProductInfosIdRelationshipsProviderGet**](ProviderProductInfosAPI.md#providerproductinfosidrelationshipsproviderget) | **GET** /providerProductInfos/{id}/relationships/provider | Get provider relationship (\&quot;to-one\&quot;).
[**providerProductInfosIdRelationshipsSubjectGet**](ProviderProductInfosAPI.md#providerproductinfosidrelationshipssubjectget) | **GET** /providerProductInfos/{id}/relationships/subject | Get subject relationship (\&quot;to-one\&quot;).


# **providerProductInfosGet**
```swift
    open class func providerProductInfosGet(countryCode: String? = nil, include: [String]? = nil, filterBarcodeId: [String]? = nil, filterProviderId: [String]? = nil, completion: @escaping (_ data: ProviderProductInfosMultiResourceDataDocument?, _ error: Error?) -> Void)
```

Get multiple providerProductInfos.

Retrieves multiple providerProductInfos by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: provider, subject (optional)
let filterBarcodeId = ["inner_example"] // [String] | List of barcode IDs (EAN-13 or UPC-A) (e.g. `00602527336510`) (optional)
let filterProviderId = ["inner_example"] // [String] | Content provider ID (e.g. `50`) (optional)

// Get multiple providerProductInfos.
ProviderProductInfosAPI.providerProductInfosGet(countryCode: countryCode, include: include, filterBarcodeId: filterBarcodeId, filterProviderId: filterProviderId) { (response, error) in
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
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: provider, subject | [optional] 
 **filterBarcodeId** | [**[String]**](String.md) | List of barcode IDs (EAN-13 or UPC-A) (e.g. &#x60;00602527336510&#x60;) | [optional] 
 **filterProviderId** | [**[String]**](String.md) | Content provider ID (e.g. &#x60;50&#x60;) | [optional] 

### Return type

[**ProviderProductInfosMultiResourceDataDocument**](ProviderProductInfosMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **providerProductInfosIdRelationshipsProviderGet**
```swift
    open class func providerProductInfosIdRelationshipsProviderGet(id: String, include: [String]? = nil, completion: @escaping (_ data: ProviderProductInfosSingleRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get provider relationship (\"to-one\").

Retrieves provider relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Provider product info id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: provider (optional)

// Get provider relationship (\"to-one\").
ProviderProductInfosAPI.providerProductInfosIdRelationshipsProviderGet(id: id, include: include) { (response, error) in
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
 **id** | **String** | Provider product info id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: provider | [optional] 

### Return type

[**ProviderProductInfosSingleRelationshipDataDocument**](ProviderProductInfosSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **providerProductInfosIdRelationshipsSubjectGet**
```swift
    open class func providerProductInfosIdRelationshipsSubjectGet(id: String, countryCode: String? = nil, include: [String]? = nil, completion: @escaping (_ data: ProviderProductInfosSingleRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get subject relationship (\"to-one\").

Retrieves subject relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Provider product info id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: subject (optional)

// Get subject relationship (\"to-one\").
ProviderProductInfosAPI.providerProductInfosIdRelationshipsSubjectGet(id: id, countryCode: countryCode, include: include) { (response, error) in
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
 **id** | **String** | Provider product info id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: subject | [optional] 

### Return type

[**ProviderProductInfosSingleRelationshipDataDocument**](ProviderProductInfosSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

