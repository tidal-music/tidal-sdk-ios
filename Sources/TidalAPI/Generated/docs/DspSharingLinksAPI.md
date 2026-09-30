# DspSharingLinksAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**dspSharingLinksGet**](DspSharingLinksAPI.md#dspsharinglinksget) | **GET** /dspSharingLinks | Get multiple dspSharingLinks.
[**dspSharingLinksIdRelationshipsSubjectGet**](DspSharingLinksAPI.md#dspsharinglinksidrelationshipssubjectget) | **GET** /dspSharingLinks/{id}/relationships/subject | Get subject relationship (\&quot;to-one\&quot;).


# **dspSharingLinksGet**
```swift
    open class func dspSharingLinksGet(include: [String]? = nil, filterSubject: String? = nil, filterSubjectId: [String]? = nil, filterSubjectType: [FilterSubjectType_dspSharingLinksGet]? = nil, replaceMedia: String? = nil, completion: @escaping (_ data: DspSharingLinksMultiResourceDataDocument?, _ error: Error?) -> Void)
```

Get multiple dspSharingLinks.

Retrieves multiple dspSharingLinks by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: subject (optional)
let filterSubject = "filterSubject_example" // String | The subject whose DSP sharing links to return. Use either subject or the deprecated subject.id and subject.type pair. (optional)
let filterSubjectId = ["inner_example"] // [String] | Deprecated: use filter[subject]. The id of the subject resource (optional)
let filterSubjectType = ["filterSubjectType_example"] // [String] | Deprecated: use filter[subject]. The type of the subject resource (e.g. `tracks`) (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: subject (optional)

// Get multiple dspSharingLinks.
DspSharingLinksAPI.dspSharingLinksGet(include: include, filterSubject: filterSubject, filterSubjectId: filterSubjectId, filterSubjectType: filterSubjectType, replaceMedia: replaceMedia) { (response, error) in
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
 **filterSubject** | **String** | The subject whose DSP sharing links to return. Use either subject or the deprecated subject.id and subject.type pair. | [optional] 
 **filterSubjectId** | [**[String]**](String.md) | Deprecated: use filter[subject]. The id of the subject resource | [optional] 
 **filterSubjectType** | [**[String]**](String.md) | Deprecated: use filter[subject]. The type of the subject resource (e.g. &#x60;tracks&#x60;) | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: subject | [optional] 

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
    open class func dspSharingLinksIdRelationshipsSubjectGet(id: String, include: [String]? = nil, replaceMedia: String? = nil, completion: @escaping (_ data: DspSharingLinksSubjectSingleRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get subject relationship (\"to-one\").

Retrieves subject relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | DspSharingLinks Id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: subject (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: subject (optional)

// Get subject relationship (\"to-one\").
DspSharingLinksAPI.dspSharingLinksIdRelationshipsSubjectGet(id: id, include: include, replaceMedia: replaceMedia) { (response, error) in
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
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: subject | [optional] 

### Return type

[**DspSharingLinksSubjectSingleRelationshipDataDocument**](DspSharingLinksSubjectSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

