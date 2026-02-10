# DspSharingLinksAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**dspSharingLinksGet**](DspSharingLinksAPI.md#dspsharinglinksget) | **GET** /dspSharingLinks | Get multiple dspSharingLinks.
[**dspSharingLinksIdRelationshipsSubjectGet**](DspSharingLinksAPI.md#dspsharinglinksidrelationshipssubjectget) | **GET** /dspSharingLinks/{id}/relationships/subject | Get subject relationship (\&quot;to-one\&quot;).


# **dspSharingLinksGet**
```swift
    open class func dspSharingLinksGet(include: [String]? = nil, filterSubjectId: [String]? = nil, filterSubjectType: [FilterSubjectType_dspSharingLinksGet]? = nil, completion: @escaping (_ data: DspSharingLinksMultiResourceDataDocument?, _ error: Error?) -> Void)
```

Get multiple dspSharingLinks.

Retrieves multiple dspSharingLinks by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: subject (optional)
let filterSubjectId = ["inner_example"] // [String] | The id of the subject resource (optional)
let filterSubjectType = ["filterSubjectType_example"] // [String] | The type of the subject resource (e.g., albums, tracks, artists) (optional)

// Get multiple dspSharingLinks.
DspSharingLinksAPI.dspSharingLinksGet(include: include, filterSubjectId: filterSubjectId, filterSubjectType: filterSubjectType) { (response, error) in
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
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: subject | [optional] 
 **filterSubjectId** | [**[String]**](String.md) | The id of the subject resource | [optional] 
 **filterSubjectType** | [**[String]**](String.md) | The type of the subject resource (e.g., albums, tracks, artists) | [optional] 

### Return type

[**DspSharingLinksMultiResourceDataDocument**](DspSharingLinksMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **dspSharingLinksIdRelationshipsSubjectGet**
```swift
    open class func dspSharingLinksIdRelationshipsSubjectGet(id: String, include: [String]? = nil, completion: @escaping (_ data: DspSharingLinksSingleRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get subject relationship (\"to-one\").

Retrieves subject relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | DspSharingLinks Id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: subject (optional)

// Get subject relationship (\"to-one\").
DspSharingLinksAPI.dspSharingLinksIdRelationshipsSubjectGet(id: id, include: include) { (response, error) in
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
 **id** | **String** | DspSharingLinks Id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: subject | [optional] 

### Return type

[**DspSharingLinksSingleRelationshipDataDocument**](DspSharingLinksSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

