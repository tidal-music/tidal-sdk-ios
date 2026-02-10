# PlayQueuesAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**playQueuesGet**](PlayQueuesAPI.md#playqueuesget) | **GET** /playQueues | Get multiple playQueues.
[**playQueuesIdDelete**](PlayQueuesAPI.md#playqueuesiddelete) | **DELETE** /playQueues/{id} | Delete single playQueue.
[**playQueuesIdGet**](PlayQueuesAPI.md#playqueuesidget) | **GET** /playQueues/{id} | Get single playQueue.
[**playQueuesIdPatch**](PlayQueuesAPI.md#playqueuesidpatch) | **PATCH** /playQueues/{id} | Update single playQueue.
[**playQueuesIdRelationshipsCurrentGet**](PlayQueuesAPI.md#playqueuesidrelationshipscurrentget) | **GET** /playQueues/{id}/relationships/current | Get current relationship (\&quot;to-one\&quot;).
[**playQueuesIdRelationshipsCurrentPatch**](PlayQueuesAPI.md#playqueuesidrelationshipscurrentpatch) | **PATCH** /playQueues/{id}/relationships/current | Update current relationship (\&quot;to-one\&quot;).
[**playQueuesIdRelationshipsFutureDelete**](PlayQueuesAPI.md#playqueuesidrelationshipsfuturedelete) | **DELETE** /playQueues/{id}/relationships/future | Delete from future relationship (\&quot;to-many\&quot;).
[**playQueuesIdRelationshipsFutureGet**](PlayQueuesAPI.md#playqueuesidrelationshipsfutureget) | **GET** /playQueues/{id}/relationships/future | Get future relationship (\&quot;to-many\&quot;).
[**playQueuesIdRelationshipsFuturePatch**](PlayQueuesAPI.md#playqueuesidrelationshipsfuturepatch) | **PATCH** /playQueues/{id}/relationships/future | Update future relationship (\&quot;to-many\&quot;).
[**playQueuesIdRelationshipsFuturePost**](PlayQueuesAPI.md#playqueuesidrelationshipsfuturepost) | **POST** /playQueues/{id}/relationships/future | Add to future relationship (\&quot;to-many\&quot;).
[**playQueuesIdRelationshipsOwnersGet**](PlayQueuesAPI.md#playqueuesidrelationshipsownersget) | **GET** /playQueues/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
[**playQueuesIdRelationshipsPastGet**](PlayQueuesAPI.md#playqueuesidrelationshipspastget) | **GET** /playQueues/{id}/relationships/past | Get past relationship (\&quot;to-many\&quot;).
[**playQueuesPost**](PlayQueuesAPI.md#playqueuespost) | **POST** /playQueues | Create single playQueue.


# **playQueuesGet**
```swift
    open class func playQueuesGet(pageCursor: String? = nil, include: [String]? = nil, filterOwnersId: [String]? = nil, completion: @escaping (_ data: PlayQueuesMultiResourceDataDocument?, _ error: Error?) -> Void)
```

Get multiple playQueues.

Retrieves multiple playQueues by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: current, future, owners, past (optional)
let filterOwnersId = ["inner_example"] // [String] | User id (optional)

// Get multiple playQueues.
PlayQueuesAPI.playQueuesGet(pageCursor: pageCursor, include: include, filterOwnersId: filterOwnersId) { (response, error) in
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
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: current, future, owners, past | [optional] 
 **filterOwnersId** | [**[String]**](String.md) | User id | [optional] 

### Return type

[**PlayQueuesMultiResourceDataDocument**](PlayQueuesMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playQueuesIdDelete**
```swift
    open class func playQueuesIdDelete(id: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Delete single playQueue.

Deletes existing playQueue.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Play queue id

// Delete single playQueue.
PlayQueuesAPI.playQueuesIdDelete(id: id) { (response, error) in
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
 **id** | **String** | Play queue id | 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playQueuesIdGet**
```swift
    open class func playQueuesIdGet(id: String, include: [String]? = nil, completion: @escaping (_ data: PlayQueuesSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single playQueue.

Retrieves single playQueue by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Play queue id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: current, future, owners, past (optional)

// Get single playQueue.
PlayQueuesAPI.playQueuesIdGet(id: id, include: include) { (response, error) in
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
 **id** | **String** | Play queue id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: current, future, owners, past | [optional] 

### Return type

[**PlayQueuesSingleResourceDataDocument**](PlayQueuesSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playQueuesIdPatch**
```swift
    open class func playQueuesIdPatch(id: String, playQueuesUpdateOperationPayload: PlayQueuesUpdateOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Update single playQueue.

Updates existing playQueue.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Play queue id
let playQueuesUpdateOperationPayload = PlayQueuesUpdateOperation_Payload(data: PlayQueuesUpdateOperation_Payload_Data(attributes: PlayQueuesUpdateOperation_Payload_Data_Attributes(_repeat: "_repeat_example", shuffled: false), id: "id_example", type: "type_example")) // PlayQueuesUpdateOperationPayload |  (optional)

// Update single playQueue.
PlayQueuesAPI.playQueuesIdPatch(id: id, playQueuesUpdateOperationPayload: playQueuesUpdateOperationPayload) { (response, error) in
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
 **id** | **String** | Play queue id | 
 **playQueuesUpdateOperationPayload** | [**PlayQueuesUpdateOperationPayload**](PlayQueuesUpdateOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playQueuesIdRelationshipsCurrentGet**
```swift
    open class func playQueuesIdRelationshipsCurrentGet(id: String, include: [String]? = nil, completion: @escaping (_ data: PlayQueuesCurrentSingleRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get current relationship (\"to-one\").

Retrieves current relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Play queue id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: current (optional)

// Get current relationship (\"to-one\").
PlayQueuesAPI.playQueuesIdRelationshipsCurrentGet(id: id, include: include) { (response, error) in
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
 **id** | **String** | Play queue id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: current | [optional] 

### Return type

[**PlayQueuesCurrentSingleRelationshipDataDocument**](PlayQueuesCurrentSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playQueuesIdRelationshipsCurrentPatch**
```swift
    open class func playQueuesIdRelationshipsCurrentPatch(id: String, playQueuesCurrentRelationshipUpdateOperationPayload: PlayQueuesCurrentRelationshipUpdateOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Update current relationship (\"to-one\").

Updates current relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Play queue id
let playQueuesCurrentRelationshipUpdateOperationPayload = PlayQueuesCurrentRelationshipUpdateOperation_Payload(data: PlayQueuesCurrentRelationshipUpdateOperation_Payload_Data(id: "id_example", meta: PlayQueuesCurrentRelationshipUpdateOperation_Payload_Data_Meta(itemId: "itemId_example"), type: "type_example")) // PlayQueuesCurrentRelationshipUpdateOperationPayload |  (optional)

// Update current relationship (\"to-one\").
PlayQueuesAPI.playQueuesIdRelationshipsCurrentPatch(id: id, playQueuesCurrentRelationshipUpdateOperationPayload: playQueuesCurrentRelationshipUpdateOperationPayload) { (response, error) in
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
 **id** | **String** | Play queue id | 
 **playQueuesCurrentRelationshipUpdateOperationPayload** | [**PlayQueuesCurrentRelationshipUpdateOperationPayload**](PlayQueuesCurrentRelationshipUpdateOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playQueuesIdRelationshipsFutureDelete**
```swift
    open class func playQueuesIdRelationshipsFutureDelete(id: String, playQueuesFutureRelationshipRemoveOperationPayload: PlayQueuesFutureRelationshipRemoveOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Delete from future relationship (\"to-many\").

Deletes item(s) from future relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Play queue id
let playQueuesFutureRelationshipRemoveOperationPayload = PlayQueuesFutureRelationshipRemoveOperation_Payload(data: [PlayQueuesFutureRelationshipRemoveOperation_Payload_Data(id: "id_example", meta: PlayQueuesFutureRelationshipRemoveOperation_Payload_Data_Meta(itemId: "itemId_example"), type: "type_example")]) // PlayQueuesFutureRelationshipRemoveOperationPayload |  (optional)

// Delete from future relationship (\"to-many\").
PlayQueuesAPI.playQueuesIdRelationshipsFutureDelete(id: id, playQueuesFutureRelationshipRemoveOperationPayload: playQueuesFutureRelationshipRemoveOperationPayload) { (response, error) in
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
 **id** | **String** | Play queue id | 
 **playQueuesFutureRelationshipRemoveOperationPayload** | [**PlayQueuesFutureRelationshipRemoveOperationPayload**](PlayQueuesFutureRelationshipRemoveOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playQueuesIdRelationshipsFutureGet**
```swift
    open class func playQueuesIdRelationshipsFutureGet(id: String, pageCursor: String? = nil, include: [String]? = nil, completion: @escaping (_ data: PlayQueuesFutureMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get future relationship (\"to-many\").

Retrieves future relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Play queue id
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: future (optional)

// Get future relationship (\"to-many\").
PlayQueuesAPI.playQueuesIdRelationshipsFutureGet(id: id, pageCursor: pageCursor, include: include) { (response, error) in
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
 **id** | **String** | Play queue id | 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: future | [optional] 

### Return type

[**PlayQueuesFutureMultiRelationshipDataDocument**](PlayQueuesFutureMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playQueuesIdRelationshipsFuturePatch**
```swift
    open class func playQueuesIdRelationshipsFuturePatch(id: String, playQueuesFutureRelationshipUpdateOperationPayload: PlayQueuesFutureRelationshipUpdateOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Update future relationship (\"to-many\").

Updates future relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Play queue id
let playQueuesFutureRelationshipUpdateOperationPayload = PlayQueuesFutureRelationshipUpdateOperation_Payload(data: [PlayQueuesFutureRelationshipUpdateOperation_Payload_Data(id: "id_example", meta: PlayQueuesFutureRelationshipUpdateOperation_Payload_Data_Meta(itemId: "itemId_example"), type: "type_example")], meta: PlayQueuesFutureRelationshipUpdateOperation_Payload_Meta(positionBefore: "positionBefore_example")) // PlayQueuesFutureRelationshipUpdateOperationPayload |  (optional)

// Update future relationship (\"to-many\").
PlayQueuesAPI.playQueuesIdRelationshipsFuturePatch(id: id, playQueuesFutureRelationshipUpdateOperationPayload: playQueuesFutureRelationshipUpdateOperationPayload) { (response, error) in
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
 **id** | **String** | Play queue id | 
 **playQueuesFutureRelationshipUpdateOperationPayload** | [**PlayQueuesFutureRelationshipUpdateOperationPayload**](PlayQueuesFutureRelationshipUpdateOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playQueuesIdRelationshipsFuturePost**
```swift
    open class func playQueuesIdRelationshipsFuturePost(id: String, playQueuesFutureRelationshipAddOperationPayload: PlayQueuesFutureRelationshipAddOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Add to future relationship (\"to-many\").

Adds item(s) to future relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Play queue id
let playQueuesFutureRelationshipAddOperationPayload = PlayQueuesFutureRelationshipAddOperation_Payload(data: [PlayQueuesFutureRelationshipAddOperation_Payload_Data(id: "id_example", type: "type_example")], meta: PlayQueuesFutureRelationshipAddOperation_Payload_Meta(batchId: 123, legacySource: LegacySource(id: "id_example", type: "type_example"), mode: "mode_example", positionBefore: "positionBefore_example")) // PlayQueuesFutureRelationshipAddOperationPayload |  (optional)

// Add to future relationship (\"to-many\").
PlayQueuesAPI.playQueuesIdRelationshipsFuturePost(id: id, playQueuesFutureRelationshipAddOperationPayload: playQueuesFutureRelationshipAddOperationPayload) { (response, error) in
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
 **id** | **String** | Play queue id | 
 **playQueuesFutureRelationshipAddOperationPayload** | [**PlayQueuesFutureRelationshipAddOperationPayload**](PlayQueuesFutureRelationshipAddOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playQueuesIdRelationshipsOwnersGet**
```swift
    open class func playQueuesIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: PlayQueuesMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Play queue id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get owners relationship (\"to-many\").
PlayQueuesAPI.playQueuesIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | Play queue id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**PlayQueuesMultiRelationshipDataDocument**](PlayQueuesMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playQueuesIdRelationshipsPastGet**
```swift
    open class func playQueuesIdRelationshipsPastGet(id: String, pageCursor: String? = nil, include: [String]? = nil, completion: @escaping (_ data: PlayQueuesPastMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get past relationship (\"to-many\").

Retrieves past relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Play queue id
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: past (optional)

// Get past relationship (\"to-many\").
PlayQueuesAPI.playQueuesIdRelationshipsPastGet(id: id, pageCursor: pageCursor, include: include) { (response, error) in
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
 **id** | **String** | Play queue id | 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: past | [optional] 

### Return type

[**PlayQueuesPastMultiRelationshipDataDocument**](PlayQueuesPastMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playQueuesPost**
```swift
    open class func playQueuesPost(playQueuesCreateOperationPayload: PlayQueuesCreateOperationPayload? = nil, completion: @escaping (_ data: PlayQueuesSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Create single playQueue.

Creates a new playQueue.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let playQueuesCreateOperationPayload = PlayQueuesCreateOperation_Payload(data: PlayQueuesCreateOperation_Payload_Data(type: "type_example")) // PlayQueuesCreateOperationPayload |  (optional)

// Create single playQueue.
PlayQueuesAPI.playQueuesPost(playQueuesCreateOperationPayload: playQueuesCreateOperationPayload) { (response, error) in
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
 **playQueuesCreateOperationPayload** | [**PlayQueuesCreateOperationPayload**](PlayQueuesCreateOperationPayload.md) |  | [optional] 

### Return type

[**PlayQueuesSingleResourceDataDocument**](PlayQueuesSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

