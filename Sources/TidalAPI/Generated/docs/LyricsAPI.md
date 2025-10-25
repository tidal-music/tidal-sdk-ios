# LyricsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**lyricsGet**](LyricsAPI.md#lyricsget) | **GET** /lyrics | Get multiple lyrics.
[**lyricsIdDelete**](LyricsAPI.md#lyricsiddelete) | **DELETE** /lyrics/{id} | Delete single lyric.
[**lyricsIdGet**](LyricsAPI.md#lyricsidget) | **GET** /lyrics/{id} | Get single lyric.
[**lyricsIdPatch**](LyricsAPI.md#lyricsidpatch) | **PATCH** /lyrics/{id} | Update single lyric.
[**lyricsIdRelationshipsOwnersGet**](LyricsAPI.md#lyricsidrelationshipsownersget) | **GET** /lyrics/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
[**lyricsIdRelationshipsTrackGet**](LyricsAPI.md#lyricsidrelationshipstrackget) | **GET** /lyrics/{id}/relationships/track | Get track relationship (\&quot;to-one\&quot;).
[**lyricsPost**](LyricsAPI.md#lyricspost) | **POST** /lyrics | Create single lyric.


# **lyricsGet**
```swift
    open class func lyricsGet(include: [String]? = nil, filterId: [String]? = nil, completion: @escaping (_ data: LyricsMultiResourceDataDocument?, _ error: Error?) -> Void)
```

Get multiple lyrics.

Retrieves multiple lyrics by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners, track (optional)
let filterId = ["inner_example"] // [String] | Lyrics Id (optional)

// Get multiple lyrics.
LyricsAPI.lyricsGet(include: include, filterId: filterId) { (response, error) in
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
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners, track | [optional] 
 **filterId** | [**[String]**](String.md) | Lyrics Id | [optional] 

### Return type

[**LyricsMultiResourceDataDocument**](LyricsMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **lyricsIdDelete**
```swift
    open class func lyricsIdDelete(id: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Delete single lyric.

Deletes existing lyric.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Lyrics Id

// Delete single lyric.
LyricsAPI.lyricsIdDelete(id: id) { (response, error) in
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
 **id** | **String** | Lyrics Id | 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **lyricsIdGet**
```swift
    open class func lyricsIdGet(id: String, include: [String]? = nil, completion: @escaping (_ data: LyricsSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single lyric.

Retrieves single lyric by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Lyrics Id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners, track (optional)

// Get single lyric.
LyricsAPI.lyricsIdGet(id: id, include: include) { (response, error) in
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
 **id** | **String** | Lyrics Id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners, track | [optional] 

### Return type

[**LyricsSingleResourceDataDocument**](LyricsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **lyricsIdPatch**
```swift
    open class func lyricsIdPatch(id: String, lyricsUpdateOperationPayload: LyricsUpdateOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Update single lyric.

Updates existing lyric.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Lyrics Id
let lyricsUpdateOperationPayload = LyricsUpdateOperation_Payload(data: LyricsUpdateOperation_Payload_Data(attributes: LyricsUpdateOperation_Payload_Data_Attributes(lrcText: "lrcText_example", text: "text_example"), id: "id_example", type: "type_example")) // LyricsUpdateOperationPayload |  (optional)

// Update single lyric.
LyricsAPI.lyricsIdPatch(id: id, lyricsUpdateOperationPayload: lyricsUpdateOperationPayload) { (response, error) in
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
 **id** | **String** | Lyrics Id | 
 **lyricsUpdateOperationPayload** | [**LyricsUpdateOperationPayload**](LyricsUpdateOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **lyricsIdRelationshipsOwnersGet**
```swift
    open class func lyricsIdRelationshipsOwnersGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: LyricsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Lyrics Id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (default to "US")
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get owners relationship (\"to-many\").
LyricsAPI.lyricsIdRelationshipsOwnersGet(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | Lyrics Id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [default to &quot;US&quot;]
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**LyricsMultiRelationshipDataDocument**](LyricsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **lyricsIdRelationshipsTrackGet**
```swift
    open class func lyricsIdRelationshipsTrackGet(id: String, countryCode: String, include: [String]? = nil, completion: @escaping (_ data: LyricsSingleRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get track relationship (\"to-one\").

Retrieves track relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Lyrics Id
let countryCode = "countryCode_example" // String | ISO 3166-1 alpha-2 country code (default to "US")
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: track (optional)

// Get track relationship (\"to-one\").
LyricsAPI.lyricsIdRelationshipsTrackGet(id: id, countryCode: countryCode, include: include) { (response, error) in
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
 **id** | **String** | Lyrics Id | 
 **countryCode** | **String** | ISO 3166-1 alpha-2 country code | [default to &quot;US&quot;]
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: track | [optional] 

### Return type

[**LyricsSingleRelationshipDataDocument**](LyricsSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE), [Client_Credentials](../README.md#Client_Credentials)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **lyricsPost**
```swift
    open class func lyricsPost(lyricsCreateOperationPayload: LyricsCreateOperationPayload? = nil, completion: @escaping (_ data: LyricsSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Create single lyric.

Creates a new lyric.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let lyricsCreateOperationPayload = LyricsCreateOperation_Payload(data: LyricsCreateOperation_Payload_Data(attributes: LyricsCreateOperation_Payload_Data_Attributes(text: "text_example"), relationships: LyricsCreateOperation_Payload_Data_Relationships(track: LyricsCreateOperation_Payload_Data_Relationships_Track(id: "id_example", type: "type_example")), type: "type_example"), meta: LyricsCreateOperation_Payload_Meta(generate: false)) // LyricsCreateOperationPayload |  (optional)

// Create single lyric.
LyricsAPI.lyricsPost(lyricsCreateOperationPayload: lyricsCreateOperationPayload) { (response, error) in
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
 **lyricsCreateOperationPayload** | [**LyricsCreateOperationPayload**](LyricsCreateOperationPayload.md) |  | [optional] 

### Return type

[**LyricsSingleResourceDataDocument**](LyricsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

