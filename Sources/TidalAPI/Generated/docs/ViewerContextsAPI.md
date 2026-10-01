# ViewerContextsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**viewerContextsGet**](ViewerContextsAPI.md#viewercontextsget) | **GET** /viewerContexts | Get multiple viewerContexts.
[**viewerContextsIdGet**](ViewerContextsAPI.md#viewercontextsidget) | **GET** /viewerContexts/{id} | Get single viewerContext.
[**viewerContextsIdRelationshipsSubjectGet**](ViewerContextsAPI.md#viewercontextsidrelationshipssubjectget) | **GET** /viewerContexts/{id}/relationships/subject | Get subject relationship (\&quot;to-one\&quot;).
[**viewerContextsIdRelationshipsViewerGet**](ViewerContextsAPI.md#viewercontextsidrelationshipsviewerget) | **GET** /viewerContexts/{id}/relationships/viewer | Get viewer relationship (\&quot;to-one\&quot;).


# **viewerContextsGet**
```swift
    open class func viewerContextsGet(filterSubject: [String], include: [String]? = nil, includeLinkage: [IncludeLinkage_viewerContextsGet]? = nil, replaceMedia: String? = nil, completion: @escaping (_ data: ViewerContextsMultiResourceDataDocument?, _ error: Error?) -> Void)
```

Get multiple viewerContexts.

Returns viewer contexts for up to 20 original subjects. Duplicate subjects are returned once.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let filterSubject = ["inner_example"] // [String] | Original subjects to look up.
let include = ["inner_example"] // [String] | Include related resources. Available relationships: subject, viewer (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: subject (optional)

// Get multiple viewerContexts.
ViewerContextsAPI.viewerContextsGet(filterSubject: filterSubject, include: include, includeLinkage: includeLinkage, replaceMedia: replaceMedia) { (response, error) in
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
 **filterSubject** | [**[String]**](String.md) | Original subjects to look up. | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: subject, viewer | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: subject | [optional] 

### Return type

[**ViewerContextsMultiResourceDataDocument**](ViewerContextsMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **viewerContextsIdGet**
```swift
    open class func viewerContextsIdGet(id: String, include: [String]? = nil, includeLinkage: [IncludeLinkage_viewerContextsIdGet]? = nil, replaceMedia: String? = nil, completion: @escaping (_ data: ViewerContextsSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single viewerContext.

Retrieves single viewerContext by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Opaque identifier of one authenticated viewer and original subject pair
let include = ["inner_example"] // [String] | Include related resources. Available relationships: subject, viewer (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: subject (optional)

// Get single viewerContext.
ViewerContextsAPI.viewerContextsIdGet(id: id, include: include, includeLinkage: includeLinkage, replaceMedia: replaceMedia) { (response, error) in
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
 **id** | **String** | Opaque identifier of one authenticated viewer and original subject pair | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: subject, viewer | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: subject | [optional] 

### Return type

[**ViewerContextsSingleResourceDataDocument**](ViewerContextsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **viewerContextsIdRelationshipsSubjectGet**
```swift
    open class func viewerContextsIdRelationshipsSubjectGet(id: String, include: [String]? = nil, replaceMedia: String? = nil, completion: @escaping (_ data: ViewerContextsSubjectSingleRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get subject relationship (\"to-one\").

Returns the subject of this viewer context.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Opaque identifier of one authenticated viewer and original subject pair
let include = ["inner_example"] // [String] | Include related resources. Available relationships: subject (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: subject (optional)

// Get subject relationship (\"to-one\").
ViewerContextsAPI.viewerContextsIdRelationshipsSubjectGet(id: id, include: include, replaceMedia: replaceMedia) { (response, error) in
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
 **id** | **String** | Opaque identifier of one authenticated viewer and original subject pair | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: subject | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: subject | [optional] 

### Return type

[**ViewerContextsSubjectSingleRelationshipDataDocument**](ViewerContextsSubjectSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **viewerContextsIdRelationshipsViewerGet**
```swift
    open class func viewerContextsIdRelationshipsViewerGet(id: String, include: [String]? = nil, replaceMedia: String? = nil, completion: @escaping (_ data: ViewerContextsViewerSingleRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get viewer relationship (\"to-one\").

Returns the authenticated viewer of this context.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Opaque identifier of one authenticated viewer and original subject pair
let include = ["inner_example"] // [String] | Include related resources. Available relationships: viewer (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: viewer.artist.albums (optional)

// Get viewer relationship (\"to-one\").
ViewerContextsAPI.viewerContextsIdRelationshipsViewerGet(id: id, include: include, replaceMedia: replaceMedia) { (response, error) in
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
 **id** | **String** | Opaque identifier of one authenticated viewer and original subject pair | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: viewer | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: viewer.artist.albums | [optional] 

### Return type

[**ViewerContextsViewerSingleRelationshipDataDocument**](ViewerContextsViewerSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

