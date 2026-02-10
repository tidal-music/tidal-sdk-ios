# UserCollectionArtistsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**userCollectionArtistsIdGet**](UserCollectionArtistsAPI.md#usercollectionartistsidget) | **GET** /userCollectionArtists/{id} | Get single userCollectionArtist.
[**userCollectionArtistsIdRelationshipsItemsDelete**](UserCollectionArtistsAPI.md#usercollectionartistsidrelationshipsitemsdelete) | **DELETE** /userCollectionArtists/{id}/relationships/items | Delete from items relationship (\&quot;to-many\&quot;).
[**userCollectionArtistsIdRelationshipsItemsGet**](UserCollectionArtistsAPI.md#usercollectionartistsidrelationshipsitemsget) | **GET** /userCollectionArtists/{id}/relationships/items | Get items relationship (\&quot;to-many\&quot;).
[**userCollectionArtistsIdRelationshipsItemsPost**](UserCollectionArtistsAPI.md#usercollectionartistsidrelationshipsitemspost) | **POST** /userCollectionArtists/{id}/relationships/items | Add to items relationship (\&quot;to-many\&quot;).
[**userCollectionArtistsIdRelationshipsOwnersGet**](UserCollectionArtistsAPI.md#usercollectionartistsidrelationshipsownersget) | **GET** /userCollectionArtists/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).


# **userCollectionArtistsIdGet**
```swift
    open class func userCollectionArtistsIdGet(id: String, countryCode: String? = nil, locale: String? = nil, include: [String]? = nil, completion: @escaping (_ data: UserCollectionArtistsSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single userCollectionArtist.

Retrieves single userCollectionArtist by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection artists id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let locale = "locale_example" // String | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. (optional) (default to "en-US")
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: items, owners (optional)

// Get single userCollectionArtist.
UserCollectionArtistsAPI.userCollectionArtistsIdGet(id: id, countryCode: countryCode, locale: locale, include: include) { (response, error) in
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
 **id** | **String** | User collection artists id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **locale** | **String** | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. | [optional] [default to &quot;en-US&quot;]
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: items, owners | [optional] 

### Return type

[**UserCollectionArtistsSingleResourceDataDocument**](UserCollectionArtistsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionArtistsIdRelationshipsItemsDelete**
```swift
    open class func userCollectionArtistsIdRelationshipsItemsDelete(id: String, userCollectionArtistsItemsRelationshipRemoveOperationPayload: UserCollectionArtistsItemsRelationshipRemoveOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Delete from items relationship (\"to-many\").

Deletes item(s) from items relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection artists id
let userCollectionArtistsItemsRelationshipRemoveOperationPayload = UserCollectionArtistsItemsRelationshipRemoveOperation_Payload(data: [UserCollectionArtistsItemsRelationshipRemoveOperation_Payload_Data(id: "id_example", type: "type_example")]) // UserCollectionArtistsItemsRelationshipRemoveOperationPayload |  (optional)

// Delete from items relationship (\"to-many\").
UserCollectionArtistsAPI.userCollectionArtistsIdRelationshipsItemsDelete(id: id, userCollectionArtistsItemsRelationshipRemoveOperationPayload: userCollectionArtistsItemsRelationshipRemoveOperationPayload) { (response, error) in
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
 **id** | **String** | User collection artists id | 
 **userCollectionArtistsItemsRelationshipRemoveOperationPayload** | [**UserCollectionArtistsItemsRelationshipRemoveOperationPayload**](UserCollectionArtistsItemsRelationshipRemoveOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionArtistsIdRelationshipsItemsGet**
```swift
    open class func userCollectionArtistsIdRelationshipsItemsGet(id: String, pageCursor: String? = nil, sort: [Sort_userCollectionArtistsIdRelationshipsItemsGet]? = nil, countryCode: String? = nil, locale: String? = nil, include: [String]? = nil, completion: @escaping (_ data: UserCollectionArtistsItemsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get items relationship (\"to-many\").

Retrieves items relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection artists id
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let sort = ["sort_example"] // [String] | Values prefixed with \"-\" are sorted descending; values without it are sorted ascending. (optional)
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let locale = "locale_example" // String | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. (optional) (default to "en-US")
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: items (optional)

// Get items relationship (\"to-many\").
UserCollectionArtistsAPI.userCollectionArtistsIdRelationshipsItemsGet(id: id, pageCursor: pageCursor, sort: sort, countryCode: countryCode, locale: locale, include: include) { (response, error) in
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
 **id** | **String** | User collection artists id | 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **sort** | [**[String]**](String.md) | Values prefixed with \&quot;-\&quot; are sorted descending; values without it are sorted ascending. | [optional] 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **locale** | **String** | BCP 47 locale (e.g., en-US, nb-NO, pt-BR). Defaults to en-US if not provided or unsupported. | [optional] [default to &quot;en-US&quot;]
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: items | [optional] 

### Return type

[**UserCollectionArtistsItemsMultiRelationshipDataDocument**](UserCollectionArtistsItemsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionArtistsIdRelationshipsItemsPost**
```swift
    open class func userCollectionArtistsIdRelationshipsItemsPost(id: String, countryCode: String? = nil, userCollectionArtistsItemsRelationshipAddOperationPayload: UserCollectionArtistsItemsRelationshipAddOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Add to items relationship (\"to-many\").

Adds item(s) to items relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection artists id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let userCollectionArtistsItemsRelationshipAddOperationPayload = UserCollectionArtistsItemsRelationshipAddOperation_Payload(data: [UserCollectionArtistsItemsRelationshipAddOperation_Payload_Data(id: "id_example", meta: UserCollectionArtistsItemsRelationshipAddOperation_Payload_Data_Meta(addedAt: Date()), type: "type_example")]) // UserCollectionArtistsItemsRelationshipAddOperationPayload |  (optional)

// Add to items relationship (\"to-many\").
UserCollectionArtistsAPI.userCollectionArtistsIdRelationshipsItemsPost(id: id, countryCode: countryCode, userCollectionArtistsItemsRelationshipAddOperationPayload: userCollectionArtistsItemsRelationshipAddOperationPayload) { (response, error) in
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
 **id** | **String** | User collection artists id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **userCollectionArtistsItemsRelationshipAddOperationPayload** | [**UserCollectionArtistsItemsRelationshipAddOperationPayload**](UserCollectionArtistsItemsRelationshipAddOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCollectionArtistsIdRelationshipsOwnersGet**
```swift
    open class func userCollectionArtistsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: UserCollectionArtistsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | User collection artists id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get owners relationship (\"to-many\").
UserCollectionArtistsAPI.userCollectionArtistsIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | User collection artists id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**UserCollectionArtistsMultiRelationshipDataDocument**](UserCollectionArtistsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

