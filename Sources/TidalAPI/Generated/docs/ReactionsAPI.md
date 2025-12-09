# ReactionsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**reactionsGet**](ReactionsAPI.md#reactionsget) | **GET** /reactions | Get multiple reactions.
[**reactionsIdDelete**](ReactionsAPI.md#reactionsiddelete) | **DELETE** /reactions/{id} | Delete single reaction.
[**reactionsIdRelationshipsOwnerProfilesGet**](ReactionsAPI.md#reactionsidrelationshipsownerprofilesget) | **GET** /reactions/{id}/relationships/ownerProfiles | Get ownerProfiles relationship (\&quot;to-many\&quot;).
[**reactionsPost**](ReactionsAPI.md#reactionspost) | **POST** /reactions | Create single reaction.


# **reactionsGet**
```swift
    open class func reactionsGet(stats: Stats_reactionsGet? = nil, statsOnly: Bool? = nil, pageCursor: String? = nil, include: [String]? = nil, filterOwnerId: [String]? = nil, filterReactedResourceId: [String]? = nil, filterReactedResourceType: [String]? = nil, filterReactionType: [String]? = nil, completion: @escaping (_ data: ReactionsMultiResourceDataDocument?, _ error: Error?) -> Void)
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
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: ownerProfiles (optional)
let filterOwnerId = ["inner_example"] // [String] | Filter by owner id (optional)
let filterReactedResourceId = ["inner_example"] // [String] | Filter by resource ID (optional)
let filterReactedResourceType = ["inner_example"] // [String] | Filter by resource type (optional)
let filterReactionType = ["inner_example"] // [String] | Filter by reaction type (optional)

// Get multiple reactions.
ReactionsAPI.reactionsGet(stats: stats, statsOnly: statsOnly, pageCursor: pageCursor, include: include, filterOwnerId: filterOwnerId, filterReactedResourceId: filterReactedResourceId, filterReactedResourceType: filterReactedResourceType, filterReactionType: filterReactionType) { (response, error) in
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
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: ownerProfiles | [optional] 
 **filterOwnerId** | [**[String]**](String.md) | Filter by owner id | [optional] 
 **filterReactedResourceId** | [**[String]**](String.md) | Filter by resource ID | [optional] 
 **filterReactedResourceType** | [**[String]**](String.md) | Filter by resource type | [optional] 
 **filterReactionType** | [**[String]**](String.md) | Filter by reaction type | [optional] 

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

# **reactionsPost**
```swift
    open class func reactionsPost(createReactionPayload: CreateReactionPayload? = nil, completion: @escaping (_ data: ReactionsSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Create single reaction.

Creates a new reaction.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let createReactionPayload = CreateReactionPayload(data: CreateReactionPayload_Data(attributes: CreateReactionPayload_Data_Attributes(reactionType: "reactionType_example"), relationships: CreateReactionPayload_Data_Relationships(reactedResource: ReactedResourceRelationship(data: ReactedResourceIdentifier(id: "id_example", type: "type_example"))), type: "type_example")) // CreateReactionPayload |  (optional)

// Create single reaction.
ReactionsAPI.reactionsPost(createReactionPayload: createReactionPayload) { (response, error) in
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
 **createReactionPayload** | [**CreateReactionPayload**](CreateReactionPayload.md) |  | [optional] 

### Return type

[**ReactionsSingleResourceDataDocument**](ReactionsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

