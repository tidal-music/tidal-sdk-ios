# OfflineTasksAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**offlineTasksGet**](OfflineTasksAPI.md#offlinetasksget) | **GET** /offlineTasks | Get multiple offlineTasks.
[**offlineTasksIdGet**](OfflineTasksAPI.md#offlinetasksidget) | **GET** /offlineTasks/{id} | Get single offlineTask.
[**offlineTasksIdPatch**](OfflineTasksAPI.md#offlinetasksidpatch) | **PATCH** /offlineTasks/{id} | Update single offlineTask.
[**offlineTasksIdRelationshipsCollectionGet**](OfflineTasksAPI.md#offlinetasksidrelationshipscollectionget) | **GET** /offlineTasks/{id}/relationships/collection | Get collection relationship (\&quot;to-one\&quot;).
[**offlineTasksIdRelationshipsItemGet**](OfflineTasksAPI.md#offlinetasksidrelationshipsitemget) | **GET** /offlineTasks/{id}/relationships/item | Get item relationship (\&quot;to-one\&quot;).
[**offlineTasksIdRelationshipsOwnersGet**](OfflineTasksAPI.md#offlinetasksidrelationshipsownersget) | **GET** /offlineTasks/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).


# **offlineTasksGet**
```swift
    open class func offlineTasksGet(pageCursor: String? = nil, include: [String]? = nil, filterId: [String]? = nil, filterInstallationId: [String]? = nil, completion: @escaping (_ data: OfflineTasksMultiResourceDataDocument?, _ error: Error?) -> Void)
```

Get multiple offlineTasks.

Retrieves multiple offlineTasks by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: collection, item, owners (optional)
let filterId = ["inner_example"] // [String] | List of offline task IDs (e.g. `a468bee8-8def-4a1b-8c1e-123456789abc`) (optional)
let filterInstallationId = ["inner_example"] // [String] | List of offline task IDs (e.g. `a468bee88def`) (optional)

// Get multiple offlineTasks.
OfflineTasksAPI.offlineTasksGet(pageCursor: pageCursor, include: include, filterId: filterId, filterInstallationId: filterInstallationId) { (response, error) in
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
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: collection, item, owners | [optional] 
 **filterId** | [**[String]**](String.md) | List of offline task IDs (e.g. &#x60;a468bee8-8def-4a1b-8c1e-123456789abc&#x60;) | [optional] 
 **filterInstallationId** | [**[String]**](String.md) | List of offline task IDs (e.g. &#x60;a468bee88def&#x60;) | [optional] 

### Return type

[**OfflineTasksMultiResourceDataDocument**](OfflineTasksMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **offlineTasksIdGet**
```swift
    open class func offlineTasksIdGet(id: String, include: [String]? = nil, completion: @escaping (_ data: OfflineTasksSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single offlineTask.

Retrieves single offlineTask by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Offline task id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: collection, item, owners (optional)

// Get single offlineTask.
OfflineTasksAPI.offlineTasksIdGet(id: id, include: include) { (response, error) in
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
 **id** | **String** | Offline task id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: collection, item, owners | [optional] 

### Return type

[**OfflineTasksSingleResourceDataDocument**](OfflineTasksSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **offlineTasksIdPatch**
```swift
    open class func offlineTasksIdPatch(id: String, offlineTasksUpdateOperationPayload: OfflineTasksUpdateOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Update single offlineTask.

Updates existing offlineTask.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Offline task id
let offlineTasksUpdateOperationPayload = OfflineTasksUpdateOperation_Payload(data: OfflineTasksUpdateOperation_Payload_Data(attributes: OfflineTasksUpdateOperation_Payload_Data_Attributes(state: "state_example"), id: "id_example", type: "type_example")) // OfflineTasksUpdateOperationPayload |  (optional)

// Update single offlineTask.
OfflineTasksAPI.offlineTasksIdPatch(id: id, offlineTasksUpdateOperationPayload: offlineTasksUpdateOperationPayload) { (response, error) in
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
 **id** | **String** | Offline task id | 
 **offlineTasksUpdateOperationPayload** | [**OfflineTasksUpdateOperationPayload**](OfflineTasksUpdateOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **offlineTasksIdRelationshipsCollectionGet**
```swift
    open class func offlineTasksIdRelationshipsCollectionGet(id: String, include: [String]? = nil, completion: @escaping (_ data: OfflineTasksSingleRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get collection relationship (\"to-one\").

Retrieves collection relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Offline task id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: collection (optional)

// Get collection relationship (\"to-one\").
OfflineTasksAPI.offlineTasksIdRelationshipsCollectionGet(id: id, include: include) { (response, error) in
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
 **id** | **String** | Offline task id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: collection | [optional] 

### Return type

[**OfflineTasksSingleRelationshipDataDocument**](OfflineTasksSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **offlineTasksIdRelationshipsItemGet**
```swift
    open class func offlineTasksIdRelationshipsItemGet(id: String, include: [String]? = nil, completion: @escaping (_ data: OfflineTasksSingleRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get item relationship (\"to-one\").

Retrieves item relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Offline task id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: item (optional)

// Get item relationship (\"to-one\").
OfflineTasksAPI.offlineTasksIdRelationshipsItemGet(id: id, include: include) { (response, error) in
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
 **id** | **String** | Offline task id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: item | [optional] 

### Return type

[**OfflineTasksSingleRelationshipDataDocument**](OfflineTasksSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **offlineTasksIdRelationshipsOwnersGet**
```swift
    open class func offlineTasksIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: OfflineTasksMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Offline task id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get owners relationship (\"to-many\").
OfflineTasksAPI.offlineTasksIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | Offline task id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**OfflineTasksMultiRelationshipDataDocument**](OfflineTasksMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

