# ArtistClaimsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**artistClaimsIdGet**](ArtistClaimsAPI.md#artistclaimsidget) | **GET** /artistClaims/{id} | Get single artistClaim.
[**artistClaimsIdPatch**](ArtistClaimsAPI.md#artistclaimsidpatch) | **PATCH** /artistClaims/{id} | Update single artistClaim.
[**artistClaimsIdRelationshipsAcceptedArtistsGet**](ArtistClaimsAPI.md#artistclaimsidrelationshipsacceptedartistsget) | **GET** /artistClaims/{id}/relationships/acceptedArtists | Get acceptedArtists relationship (\&quot;to-many\&quot;).
[**artistClaimsIdRelationshipsAcceptedArtistsPatch**](ArtistClaimsAPI.md#artistclaimsidrelationshipsacceptedartistspatch) | **PATCH** /artistClaims/{id}/relationships/acceptedArtists | Update acceptedArtists relationship (\&quot;to-many\&quot;).
[**artistClaimsIdRelationshipsOwnersGet**](ArtistClaimsAPI.md#artistclaimsidrelationshipsownersget) | **GET** /artistClaims/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
[**artistClaimsIdRelationshipsRecommendedArtistsGet**](ArtistClaimsAPI.md#artistclaimsidrelationshipsrecommendedartistsget) | **GET** /artistClaims/{id}/relationships/recommendedArtists | Get recommendedArtists relationship (\&quot;to-many\&quot;).
[**artistClaimsPost**](ArtistClaimsAPI.md#artistclaimspost) | **POST** /artistClaims | Create single artistClaim.


# **artistClaimsIdGet**
```swift
    open class func artistClaimsIdGet(id: String, include: [String]? = nil, completion: @escaping (_ data: ArtistClaimsSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single artistClaim.

Retrieves single artistClaim by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist claim id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: acceptedArtists, owners, recommendedArtists (optional)

// Get single artistClaim.
ArtistClaimsAPI.artistClaimsIdGet(id: id, include: include) { (response, error) in
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
 **id** | **String** | Artist claim id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: acceptedArtists, owners, recommendedArtists | [optional] 

### Return type

[**ArtistClaimsSingleResourceDataDocument**](ArtistClaimsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artistClaimsIdPatch**
```swift
    open class func artistClaimsIdPatch(id: String, countryCode: String? = nil, artistClaimsUpdateOperationPayload: ArtistClaimsUpdateOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Update single artistClaim.

Updates existing artistClaim.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist claim id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let artistClaimsUpdateOperationPayload = ArtistClaimsUpdateOperation_Payload(data: ArtistClaimsUpdateOperation_Payload_Data(attributes: 123, id: "id_example", type: "type_example"), meta: ArtistClaimsUpdateOperation_Payload_Meta(authorizationCode: "authorizationCode_example", redirectUri: "redirectUri_example")) // ArtistClaimsUpdateOperationPayload |  (optional)

// Update single artistClaim.
ArtistClaimsAPI.artistClaimsIdPatch(id: id, countryCode: countryCode, artistClaimsUpdateOperationPayload: artistClaimsUpdateOperationPayload) { (response, error) in
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
 **id** | **String** | Artist claim id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [optional] 
 **artistClaimsUpdateOperationPayload** | [**ArtistClaimsUpdateOperationPayload**](ArtistClaimsUpdateOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artistClaimsIdRelationshipsAcceptedArtistsGet**
```swift
    open class func artistClaimsIdRelationshipsAcceptedArtistsGet(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: ArtistClaimsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get acceptedArtists relationship (\"to-many\").

Retrieves acceptedArtists relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist claim id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: acceptedArtists (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get acceptedArtists relationship (\"to-many\").
ArtistClaimsAPI.artistClaimsIdRelationshipsAcceptedArtistsGet(id: id, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | Artist claim id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: acceptedArtists | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**ArtistClaimsMultiRelationshipDataDocument**](ArtistClaimsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artistClaimsIdRelationshipsAcceptedArtistsPatch**
```swift
    open class func artistClaimsIdRelationshipsAcceptedArtistsPatch(id: String, artistClaimAcceptedArtistsRelationshipUpdateOperationPayload: ArtistClaimAcceptedArtistsRelationshipUpdateOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Update acceptedArtists relationship (\"to-many\").

Updates acceptedArtists relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist claim id
let artistClaimAcceptedArtistsRelationshipUpdateOperationPayload = ArtistClaimAcceptedArtistsRelationshipUpdateOperation_Payload(data: [ArtistClaimAcceptedArtistsRelationshipUpdateOperation_Payload_Data(id: "id_example", type: "type_example")]) // ArtistClaimAcceptedArtistsRelationshipUpdateOperationPayload |  (optional)

// Update acceptedArtists relationship (\"to-many\").
ArtistClaimsAPI.artistClaimsIdRelationshipsAcceptedArtistsPatch(id: id, artistClaimAcceptedArtistsRelationshipUpdateOperationPayload: artistClaimAcceptedArtistsRelationshipUpdateOperationPayload) { (response, error) in
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
 **id** | **String** | Artist claim id | 
 **artistClaimAcceptedArtistsRelationshipUpdateOperationPayload** | [**ArtistClaimAcceptedArtistsRelationshipUpdateOperationPayload**](ArtistClaimAcceptedArtistsRelationshipUpdateOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artistClaimsIdRelationshipsOwnersGet**
```swift
    open class func artistClaimsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: ArtistClaimsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist claim id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get owners relationship (\"to-many\").
ArtistClaimsAPI.artistClaimsIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | Artist claim id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**ArtistClaimsMultiRelationshipDataDocument**](ArtistClaimsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artistClaimsIdRelationshipsRecommendedArtistsGet**
```swift
    open class func artistClaimsIdRelationshipsRecommendedArtistsGet(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: ArtistClaimsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get recommendedArtists relationship (\"to-many\").

Retrieves recommendedArtists relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Artist claim id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: recommendedArtists (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get recommendedArtists relationship (\"to-many\").
ArtistClaimsAPI.artistClaimsIdRelationshipsRecommendedArtistsGet(id: id, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | Artist claim id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: recommendedArtists | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**ArtistClaimsMultiRelationshipDataDocument**](ArtistClaimsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **artistClaimsPost**
```swift
    open class func artistClaimsPost(countryCode: String? = nil, artistClaimsCreateOperationPayload: ArtistClaimsCreateOperationPayload? = nil, completion: @escaping (_ data: ArtistClaimsSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Create single artistClaim.

Creates a new artistClaim.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (optional)
let artistClaimsCreateOperationPayload = ArtistClaimsCreateOperation_Payload(data: ArtistClaimsCreateOperation_Payload_Data(attributes: ArtistClaimsCreateOperation_Payload_Data_Attributes(artistId: "artistId_example", provider: "provider_example"), type: "type_example"), meta: ArtistClaimsCreateOperation_Payload_Meta(nonce: "nonce_example", redirectUrl: "redirectUrl_example")) // ArtistClaimsCreateOperationPayload |  (optional)

// Create single artistClaim.
ArtistClaimsAPI.artistClaimsPost(countryCode: countryCode, artistClaimsCreateOperationPayload: artistClaimsCreateOperationPayload) { (response, error) in
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
 **artistClaimsCreateOperationPayload** | [**ArtistClaimsCreateOperationPayload**](ArtistClaimsCreateOperationPayload.md) |  | [optional] 

### Return type

[**ArtistClaimsSingleResourceDataDocument**](ArtistClaimsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

