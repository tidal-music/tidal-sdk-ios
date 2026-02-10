# UserCollectionTracksAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**userCollectionTracksIdGet**](UserCollectionTracksAPI.md#usercollectiontracksidget) | **GET** /userCollectionTracks/{id} | Get single userCollectionTrack.
[**userCollectionTracksIdRelationshipsItemsDelete**](UserCollectionTracksAPI.md#usercollectiontracksidrelationshipsitemsdelete) | **DELETE** /userCollectionTracks/{id}/relationships/items | Delete from items relationship (\&quot;to-many\&quot;).
[**userCollectionTracksIdRelationshipsItemsGet**](UserCollectionTracksAPI.md#usercollectiontracksidrelationshipsitemsget) | **GET** /userCollectionTracks/{id}/relationships/items | Get items relationship (\&quot;to-many\&quot;).
[**userCollectionTracksIdRelationshipsItemsPost**](UserCollectionTracksAPI.md#usercollectiontracksidrelationshipsitemspost) | **POST** /userCollectionTracks/{id}/relationships/items | Add to items relationship (\&quot;to-many\&quot;).
[**userCollectionTracksIdRelationshipsOwnersGet**](UserCollectionTracksAPI.md#usercollectiontracksidrelationshipsownersget) | **GET** /userCollectionTracks/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).


# **userCollectionTracksIdGet**
```swift
    open class func userCollectionTracksIdGet(id: String, countryCode: String? = nil, locale: String? = nil, include: [String]? = nil, completion: @escaping (_ data: UserCollectionTracksSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single userCollectionTrack.

Retrieves single userCollectionTrack by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection tracks id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let locale = "locale_example" // String | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. (optional) (default to "en-US")
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: items, owners (optional)

// Get single userCollectionTrack.
UserCollectionTracksAPI.userCollectionTracksIdGet(id: id, countryCode: countryCode, locale: locale, include: include) { (response, error) in
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
 **id** | **String** | User collection tracks id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **locale** | **String** | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. | [optional] [default to &quot;en-US&quot;]
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: items, owners | [optional] 

### Return type

[**UserCollectionTracksSingleResourceDataDocument**](UserCollectionTracksSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionTracksIdRelationshipsItemsDelete**
```swift
    open class func userCollectionTracksIdRelationshipsItemsDelete(id: String, userCollectionTracksItemsRelationshipRemoveOperationPayload: UserCollectionTracksItemsRelationshipRemoveOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Delete from items relationship (\"to-many\").

Deletes item(s) from items relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection tracks id
let userCollectionTracksItemsRelationshipRemoveOperationPayload = UserCollectionTracksItemsRelationshipRemoveOperation_Payload(data: [UserCollectionTracksItemsRelationshipRemoveOperation_Payload_Data(id: "id_example", type: "type_example")]) // UserCollectionTracksItemsRelationshipRemoveOperationPayload |  (optional)

// Delete from items relationship (\"to-many\").
UserCollectionTracksAPI.userCollectionTracksIdRelationshipsItemsDelete(id: id, userCollectionTracksItemsRelationshipRemoveOperationPayload: userCollectionTracksItemsRelationshipRemoveOperationPayload) { (response, error) in
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
 **id** | **String** | User collection tracks id | 
 **userCollectionTracksItemsRelationshipRemoveOperationPayload** | [**UserCollectionTracksItemsRelationshipRemoveOperationPayload**](UserCollectionTracksItemsRelationshipRemoveOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionTracksIdRelationshipsItemsGet**
```swift
    open class func userCollectionTracksIdRelationshipsItemsGet(id: String, pageCursor: String? = nil, sort: [Sort_userCollectionTracksIdRelationshipsItemsGet]? = nil, countryCode: String? = nil, locale: String? = nil, include: [String]? = nil, completion: @escaping (_ data: UserCollectionTracksItemsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get items relationship (\"to-many\").

Retrieves items relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection tracks id
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let sort = ["sort_example"] // [String] | Values prefixed with \"-\" are sorted descending; values without it are sorted ascending. (optional)
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let locale = "locale_example" // String | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. (optional) (default to "en-US")
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: items (optional)

// Get items relationship (\"to-many\").
UserCollectionTracksAPI.userCollectionTracksIdRelationshipsItemsGet(id: id, pageCursor: pageCursor, sort: sort, countryCode: countryCode, locale: locale, include: include) { (response, error) in
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
 **id** | **String** | User collection tracks id | 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **sort** | [**[String]**](String.md) | Values prefixed with \&quot;-\&quot; are sorted descending; values without it are sorted ascending. | [optional] 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **locale** | **String** | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. | [optional] [default to &quot;en-US&quot;]
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: items | [optional] 

### Return type

[**UserCollectionTracksItemsMultiRelationshipDataDocument**](UserCollectionTracksItemsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionTracksIdRelationshipsItemsPost**
```swift
    open class func userCollectionTracksIdRelationshipsItemsPost(id: String, countryCode: String? = nil, userCollectionTracksItemsRelationshipAddOperationPayload: UserCollectionTracksItemsRelationshipAddOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Add to items relationship (\"to-many\").

Adds item(s) to items relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection tracks id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let userCollectionTracksItemsRelationshipAddOperationPayload = UserCollectionTracksItemsRelationshipAddOperation_Payload(data: [UserCollectionTracksItemsRelationshipAddOperation_Payload_Data(id: "id_example", meta: UserCollectionTracksItemsRelationshipAddOperation_Payload_Data_Meta(addedAt: Date()), type: "type_example")]) // UserCollectionTracksItemsRelationshipAddOperationPayload |  (optional)

// Add to items relationship (\"to-many\").
UserCollectionTracksAPI.userCollectionTracksIdRelationshipsItemsPost(id: id, countryCode: countryCode, userCollectionTracksItemsRelationshipAddOperationPayload: userCollectionTracksItemsRelationshipAddOperationPayload) { (response, error) in
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
 **id** | **String** | User collection tracks id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **userCollectionTracksItemsRelationshipAddOperationPayload** | [**UserCollectionTracksItemsRelationshipAddOperationPayload**](UserCollectionTracksItemsRelationshipAddOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionTracksIdRelationshipsOwnersGet**
```swift
    open class func userCollectionTracksIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: UserCollectionTracksMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection tracks id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get owners relationship (\"to-many\").
UserCollectionTracksAPI.userCollectionTracksIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | User collection tracks id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**UserCollectionTracksMultiRelationshipDataDocument**](UserCollectionTracksMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

