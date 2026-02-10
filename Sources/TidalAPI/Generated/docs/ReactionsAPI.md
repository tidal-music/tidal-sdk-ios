# ReactionsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**reactionsGet**](ReactionsAPI.md#reactionsget) | **GET** /reactions | Get multiple reactions.
[**reactionsIdDelete**](ReactionsAPI.md#reactionsiddelete) | **DELETE** /reactions/{id} | Delete single reaction.
[**reactionsIdRelationshipsOwnerProfilesGet**](ReactionsAPI.md#reactionsidrelationshipsownerprofilesget) | **GET** /reactions/{id}/relationships/ownerProfiles | Get ownerProfiles relationship (\&quot;to-many\&quot;).
[**reactionsIdRelationshipsOwnersGet**](ReactionsAPI.md#reactionsidrelationshipsownersget) | **GET** /reactions/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
[**reactionsPost**](ReactionsAPI.md#reactionspost) | **POST** /reactions | Create single reaction.


# **reactionsGet**
```swift
    open class func reactionsGet(stats: Stats_reactionsGet? = nil, statsOnly: Bool? = nil, pageCursor: String? = nil, include: [String]? = nil, filterEmoji: [String]? = nil, filterOwnersId: [String]? = nil, filterReactedResourceId: [String]? = nil, filterReactedResourceType: [FilterReactedResourceType_reactionsGet]? = nil, completion: @escaping (_ data: ReactionsMultiResourceDataDocument?, _ error: Error?) -> Void)
```

Get multiple reactions.

Retrieves multiple reactions by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let stats = "stats_example" // String |  (optional)
let statsOnly = true // Bool |  (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: ownerProfiles, owners (optional)
let filterEmoji = ["inner_example"] // [String] | Filter by emoji (optional)
let filterOwnersId = ["inner_example"] // [String] | Filter by owner id (optional)
let filterReactedResourceId = ["inner_example"] // [String] | Filter by reacted resource ID (optional)
let filterReactedResourceType = ["filterReactedResourceType_example"] // [String] | Filter by reacted resource type (optional)

// Get multiple reactions.
ReactionsAPI.reactionsGet(stats: stats, statsOnly: statsOnly, pageCursor: pageCursor, include: include, filterEmoji: filterEmoji, filterOwnersId: filterOwnersId, filterReactedResourceId: filterReactedResourceId, filterReactedResourceType: filterReactedResourceType) { (response, error) in
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
 **stats** | **String** |  | [optional] 
 **statsOnly** | **Bool** |  | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: ownerProfiles, owners | [optional] 
 **filterEmoji** | [**[String]**](String.md) | Filter by emoji | [optional] 
 **filterOwnersId** | [**[String]**](String.md) | Filter by owner id | [optional] 
 **filterReactedResourceId** | [**[String]**](String.md) | Filter by reacted resource ID | [optional] 
 **filterReactedResourceType** | [**[String]**](String.md) | Filter by reacted resource type | [optional] 

### Return type

[**ReactionsMultiResourceDataDocument**](ReactionsMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **reactionsIdDelete**
```swift
    open class func reactionsIdDelete(id: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Delete single reaction.

Deletes existing reaction.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Reaction Id

// Delete single reaction.
ReactionsAPI.reactionsIdDelete(id: id) { (response, error) in
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
 **id** | **String** | Reaction Id | 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **reactionsIdRelationshipsOwnerProfilesGet**
```swift
    open class func reactionsIdRelationshipsOwnerProfilesGet(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: ReactionsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get ownerProfiles relationship (\"to-many\").

Retrieves ownerProfiles relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Reaction Id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: ownerProfiles (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get ownerProfiles relationship (\"to-many\").
ReactionsAPI.reactionsIdRelationshipsOwnerProfilesGet(id: id, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | Reaction Id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: ownerProfiles | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**ReactionsMultiRelationshipDataDocument**](ReactionsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **reactionsIdRelationshipsOwnersGet**
```swift
    open class func reactionsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: ReactionsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Reaction Id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get owners relationship (\"to-many\").
ReactionsAPI.reactionsIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | Reaction Id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**ReactionsMultiRelationshipDataDocument**](ReactionsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **reactionsPost**
```swift
    open class func reactionsPost(reactionsCreateOperationPayload: ReactionsCreateOperationPayload? = nil, completion: @escaping (_ data: ReactionsSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Create single reaction.

Creates a new reaction.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let reactionsCreateOperationPayload = ReactionsCreateOperation_Payload(data: ReactionsCreateOperation_Payload_Data(attributes: ReactionsCreateOperation_Payload_Data_Attributes(emoji: "emoji_example"), relationships: ReactionsCreateOperation_Payload_Data_Relationships(reactedResource: ReactionsCreateOperation_Payload_Data_Relationships_ReactedResource(data: ReactionsCreateOperation_Payload_Data_Relationships_ReactedResource_Data(id: "id_example", type: "type_example"))), type: "type_example")) // ReactionsCreateOperationPayload |  (optional)

// Create single reaction.
ReactionsAPI.reactionsPost(reactionsCreateOperationPayload: reactionsCreateOperationPayload) { (response, error) in
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
 **reactionsCreateOperationPayload** | [**ReactionsCreateOperationPayload**](ReactionsCreateOperationPayload.md) |  | [optional] 

### Return type

[**ReactionsSingleResourceDataDocument**](ReactionsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

