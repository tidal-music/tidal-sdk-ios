# ContentClaimsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**contentClaimsGet**](ContentClaimsAPI.md#contentclaimsget) | **GET** /contentClaims | Get multiple contentClaims.
[**contentClaimsIdGet**](ContentClaimsAPI.md#contentclaimsidget) | **GET** /contentClaims/{id} | Get single contentClaim.
[**contentClaimsIdRelationshipsClaimedResourceGet**](ContentClaimsAPI.md#contentclaimsidrelationshipsclaimedresourceget) | **GET** /contentClaims/{id}/relationships/claimedResource | Get claimedResource relationship (\&quot;to-one\&quot;).
[**contentClaimsIdRelationshipsClaimingArtistGet**](ContentClaimsAPI.md#contentclaimsidrelationshipsclaimingartistget) | **GET** /contentClaims/{id}/relationships/claimingArtist | Get claimingArtist relationship (\&quot;to-one\&quot;).
[**contentClaimsIdRelationshipsOwnersGet**](ContentClaimsAPI.md#contentclaimsidrelationshipsownersget) | **GET** /contentClaims/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
[**contentClaimsPost**](ContentClaimsAPI.md#contentclaimspost) | **POST** /contentClaims | Create single contentClaim.


# **contentClaimsGet**
```swift
    open class func contentClaimsGet(include: [String]? = nil, filterOwnersId: [String]? = nil, completion: @escaping (_ data: ContentClaimsMultiResourceDataDocument?, _ error: Error?) -> Void)
```

Get multiple contentClaims.

Retrieves multiple contentClaims by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: claimedResource, claimingArtist, owners (optional)
let filterOwnersId = ["inner_example"] // [String] | User id (e.g. `123456`) (optional)

// Get multiple contentClaims.
ContentClaimsAPI.contentClaimsGet(include: include, filterOwnersId: filterOwnersId) { (response, error) in
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
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: claimedResource, claimingArtist, owners | [optional] 
 **filterOwnersId** | [**[String]**](String.md) | User id (e.g. &#x60;123456&#x60;) | [optional] 

### Return type

[**ContentClaimsMultiResourceDataDocument**](ContentClaimsMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **contentClaimsIdGet**
```swift
    open class func contentClaimsIdGet(id: String, include: [String]? = nil, completion: @escaping (_ data: ContentClaimsSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single contentClaim.

Retrieves single contentClaim by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Content claim id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: claimedResource, claimingArtist, owners (optional)

// Get single contentClaim.
ContentClaimsAPI.contentClaimsIdGet(id: id, include: include) { (response, error) in
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
 **id** | **String** | Content claim id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: claimedResource, claimingArtist, owners | [optional] 

### Return type

[**ContentClaimsSingleResourceDataDocument**](ContentClaimsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **contentClaimsIdRelationshipsClaimedResourceGet**
```swift
    open class func contentClaimsIdRelationshipsClaimedResourceGet(id: String, include: [String]? = nil, completion: @escaping (_ data: ContentClaimsSingleRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get claimedResource relationship (\"to-one\").

Retrieves claimedResource relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Content claim id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: claimedResource (optional)

// Get claimedResource relationship (\"to-one\").
ContentClaimsAPI.contentClaimsIdRelationshipsClaimedResourceGet(id: id, include: include) { (response, error) in
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
 **id** | **String** | Content claim id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: claimedResource | [optional] 

### Return type

[**ContentClaimsSingleRelationshipDataDocument**](ContentClaimsSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **contentClaimsIdRelationshipsClaimingArtistGet**
```swift
    open class func contentClaimsIdRelationshipsClaimingArtistGet(id: String, include: [String]? = nil, completion: @escaping (_ data: ContentClaimsSingleRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get claimingArtist relationship (\"to-one\").

Retrieves claimingArtist relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Content claim id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: claimingArtist (optional)

// Get claimingArtist relationship (\"to-one\").
ContentClaimsAPI.contentClaimsIdRelationshipsClaimingArtistGet(id: id, include: include) { (response, error) in
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
 **id** | **String** | Content claim id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: claimingArtist | [optional] 

### Return type

[**ContentClaimsSingleRelationshipDataDocument**](ContentClaimsSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **contentClaimsIdRelationshipsOwnersGet**
```swift
    open class func contentClaimsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: ContentClaimsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Content claim id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get owners relationship (\"to-many\").
ContentClaimsAPI.contentClaimsIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | Content claim id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**ContentClaimsMultiRelationshipDataDocument**](ContentClaimsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **contentClaimsPost**
```swift
    open class func contentClaimsPost(contentClaimsCreateOperationPayload: ContentClaimsCreateOperationPayload? = nil, completion: @escaping (_ data: ContentClaimsSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Create single contentClaim.

Creates a new contentClaim.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let contentClaimsCreateOperationPayload = ContentClaimsCreateOperation_Payload(data: ContentClaimsCreateOperation_Payload_Data(attributes: ContentClaimsCreateOperation_Payload_Data_Attributes(assertion: "assertion_example"), relationships: ContentClaimsCreateOperation_Payload_Data_Relationships(claimedResource: ContentClaimsCreateOperation_Payload_Data_Relationships_ClaimedResource(data: ContentClaimsCreateOperation_Payload_Data_Relationships_ClaimedResource_Data(id: "id_example", type: "type_example")), claimingArtist: ContentClaimsCreateOperation_Payload_Data_Relationships_ClaimingArtist(data: ContentClaimsCreateOperation_Payload_Data_Relationships_ClaimingArtist_Data(id: "id_example", type: "type_example"))), type: "type_example")) // ContentClaimsCreateOperationPayload |  (optional)

// Create single contentClaim.
ContentClaimsAPI.contentClaimsPost(contentClaimsCreateOperationPayload: contentClaimsCreateOperationPayload) { (response, error) in
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
 **contentClaimsCreateOperationPayload** | [**ContentClaimsCreateOperationPayload**](ContentClaimsCreateOperationPayload.md) |  | [optional] 

### Return type

[**ContentClaimsSingleResourceDataDocument**](ContentClaimsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

