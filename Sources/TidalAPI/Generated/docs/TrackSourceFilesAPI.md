# TrackSourceFilesAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**trackSourceFilesGet**](TrackSourceFilesAPI.md#tracksourcefilesget) | **GET** /trackSourceFiles | Get multiple trackSourceFiles.
[**trackSourceFilesIdGet**](TrackSourceFilesAPI.md#tracksourcefilesidget) | **GET** /trackSourceFiles/{id} | Get single trackSourceFile.
[**trackSourceFilesIdRelationshipsOwnersGet**](TrackSourceFilesAPI.md#tracksourcefilesidrelationshipsownersget) | **GET** /trackSourceFiles/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
[**trackSourceFilesPost**](TrackSourceFilesAPI.md#tracksourcefilespost) | **POST** /trackSourceFiles | Create single trackSourceFile.


# **trackSourceFilesGet**
```swift
    open class func trackSourceFilesGet(include: [String]? = nil, filterId: [String]? = nil, completion: @escaping (_ data: TrackSourceFilesMultiResourceDataDocument?, _ error: Error?) -> Void)
```

Get multiple trackSourceFiles.

Retrieves multiple trackSourceFiles by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners (optional)
let filterId = ["inner_example"] // [String] | Track source file id (optional)

// Get multiple trackSourceFiles.
TrackSourceFilesAPI.trackSourceFilesGet(include: include, filterId: filterId) { (response, error) in
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
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners | [optional] 
 **filterId** | [**[String]**](String.md) | Track source file id | [optional] 

### Return type

[**TrackSourceFilesMultiResourceDataDocument**](TrackSourceFilesMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **trackSourceFilesIdGet**
```swift
    open class func trackSourceFilesIdGet(id: String, include: [String]? = nil, completion: @escaping (_ data: TrackSourceFilesSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single trackSourceFile.

Retrieves single trackSourceFile by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Track source file id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners (optional)

// Get single trackSourceFile.
TrackSourceFilesAPI.trackSourceFilesIdGet(id: id, include: include) { (response, error) in
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
 **id** | **String** | Track source file id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners | [optional] 

### Return type

[**TrackSourceFilesSingleResourceDataDocument**](TrackSourceFilesSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **trackSourceFilesIdRelationshipsOwnersGet**
```swift
    open class func trackSourceFilesIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: TrackSourceFilesMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Track source file id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get owners relationship (\"to-many\").
TrackSourceFilesAPI.trackSourceFilesIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | Track source file id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**TrackSourceFilesMultiRelationshipDataDocument**](TrackSourceFilesMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **trackSourceFilesPost**
```swift
    open class func trackSourceFilesPost(trackSourceFilesCreateOperationPayload: TrackSourceFilesCreateOperationPayload? = nil, completion: @escaping (_ data: TrackSourceFilesSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Create single trackSourceFile.

Create a track source file. <p/> The response contains a upload link that must be used to upload the actual content.<p/> The headers in the upload link response must be sent doing the actual upload. 

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let trackSourceFilesCreateOperationPayload = TrackSourceFilesCreateOperation_Payload(data: TrackSourceFilesCreateOperation_Payload_Data(attributes: TrackSourceFilesCreateOperation_Payload_Data_Attributes(md5Hash: "md5Hash_example", size: 123), relationships: TrackSourceFilesCreateOperation_Payload_Data_Relationships(track: TrackSourceFilesCreateOperation_Payload_Data_Relationships_Track(data: TrackSourceFilesCreateOperation_Payload_Data_Relationships_Track_Data(id: "id_example", type: "type_example"), id: "id_example", type: "type_example")), type: "type_example")) // TrackSourceFilesCreateOperationPayload |  (optional)

// Create single trackSourceFile.
TrackSourceFilesAPI.trackSourceFilesPost(trackSourceFilesCreateOperationPayload: trackSourceFilesCreateOperationPayload) { (response, error) in
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
 **trackSourceFilesCreateOperationPayload** | [**TrackSourceFilesCreateOperationPayload**](TrackSourceFilesCreateOperationPayload.md) |  | [optional] 

### Return type

[**TrackSourceFilesSingleResourceDataDocument**](TrackSourceFilesSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

