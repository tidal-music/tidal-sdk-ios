# UserFeedItemsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**userFeedItemsGet**](UserFeedItemsAPI.md#userfeeditemsget) | **GET** /userFeedItems | Get multiple userFeedItems.
[**userFeedItemsIdRelationshipsActorsGet**](UserFeedItemsAPI.md#userfeeditemsidrelationshipsactorsget) | **GET** /userFeedItems/{id}/relationships/actors | Get actors relationship (\&quot;to-many\&quot;).
[**userFeedItemsIdRelationshipsSubjectGet**](UserFeedItemsAPI.md#userfeeditemsidrelationshipssubjectget) | **GET** /userFeedItems/{id}/relationships/subject | Get subject relationship (\&quot;to-one\&quot;).


# **userFeedItemsGet**
```swift
    open class func userFeedItemsGet(filterOwnersId: [String], filterSurface: FilterSurface_userFeedItemsGet, pageCursor: String? = nil, include: [String]? = nil, includeLinkage: [IncludeLinkage_userFeedItemsGet]? = nil, replaceMedia: String? = nil, completion: @escaping (_ data: UserFeedItemsMultiResourceDataDocument?, _ error: Error?) -> Void)
```

Get multiple userFeedItems.

The authenticated user's activity on the selected feed surface.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let filterOwnersId = ["inner_example"] // [String] | User id. Use `me` for the authenticated user
let filterSurface = "filterSurface_example" // String | Feed surface to read (e.g. `INBOX`)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: actors, subject (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: actors.albums (optional)

// Get multiple userFeedItems.
UserFeedItemsAPI.userFeedItemsGet(filterOwnersId: filterOwnersId, filterSurface: filterSurface, pageCursor: pageCursor, include: include, includeLinkage: includeLinkage, replaceMedia: replaceMedia) { (response, error) in
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
 **filterOwnersId** | [**[String]**](String.md) | User id. Use &#x60;me&#x60; for the authenticated user | 
 **filterSurface** | **String** | Feed surface to read (e.g. &#x60;INBOX&#x60;) | 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: actors, subject | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: actors.albums | [optional] 

### Return type

[**UserFeedItemsMultiResourceDataDocument**](UserFeedItemsMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userFeedItemsIdRelationshipsActorsGet**
```swift
    open class func userFeedItemsIdRelationshipsActorsGet(id: String, pageCursor: String? = nil, include: [String]? = nil, replaceMedia: String? = nil, completion: @escaping (_ data: UserFeedItemsActorsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get actors relationship (\"to-many\").

Artists attributed to the activity. Always empty for `ALBUM_FAVOURITED`, `TRACK_FAVOURITED` and `TRACK_PLAYLISTED`, which are counts only, and for `HISTORY_MIX_READY`, which nobody else acted on.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Opaque identifier of a user feed item.
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: actors (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: actors.albums (optional)

// Get actors relationship (\"to-many\").
UserFeedItemsAPI.userFeedItemsIdRelationshipsActorsGet(id: id, pageCursor: pageCursor, include: include, replaceMedia: replaceMedia) { (response, error) in
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
 **id** | **String** | Opaque identifier of a user feed item. | 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: actors | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: actors.albums | [optional] 

### Return type

[**UserFeedItemsActorsMultiRelationshipDataDocument**](UserFeedItemsActorsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userFeedItemsIdRelationshipsSubjectGet**
```swift
    open class func userFeedItemsIdRelationshipsSubjectGet(id: String, include: [String]? = nil, replaceMedia: String? = nil, completion: @escaping (_ data: UserFeedItemsSubjectSingleRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get subject relationship (\"to-one\").

The resource the activity concerns. For `HISTORY_MIX_READY`, the viewer's history mix as a playlist.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Opaque identifier of a user feed item.
let include = ["inner_example"] // [String] | Include related resources. Available relationships: subject (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: subject (optional)

// Get subject relationship (\"to-one\").
UserFeedItemsAPI.userFeedItemsIdRelationshipsSubjectGet(id: id, include: include, replaceMedia: replaceMedia) { (response, error) in
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
 **id** | **String** | Opaque identifier of a user feed item. | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: subject | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: subject | [optional] 

### Return type

[**UserFeedItemsSubjectSingleRelationshipDataDocument**](UserFeedItemsSubjectSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

