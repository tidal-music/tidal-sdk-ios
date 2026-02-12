# InstallationsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**installationsGet**](InstallationsAPI.md#installationsget) | **GET** /installations | Get multiple installations.
[**installationsIdGet**](InstallationsAPI.md#installationsidget) | **GET** /installations/{id} | Get single installation.
[**installationsIdRelationshipsOfflineInventoryDelete**](InstallationsAPI.md#installationsidrelationshipsofflineinventorydelete) | **DELETE** /installations/{id}/relationships/offlineInventory | Delete from offlineInventory relationship (\&quot;to-many\&quot;).
[**installationsIdRelationshipsOfflineInventoryGet**](InstallationsAPI.md#installationsidrelationshipsofflineinventoryget) | **GET** /installations/{id}/relationships/offlineInventory | Get offlineInventory relationship (\&quot;to-many\&quot;).
[**installationsIdRelationshipsOfflineInventoryPost**](InstallationsAPI.md#installationsidrelationshipsofflineinventorypost) | **POST** /installations/{id}/relationships/offlineInventory | Add to offlineInventory relationship (\&quot;to-many\&quot;).
[**installationsIdRelationshipsOwnersGet**](InstallationsAPI.md#installationsidrelationshipsownersget) | **GET** /installations/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
[**installationsPost**](InstallationsAPI.md#installationspost) | **POST** /installations | Create single installation.


# **installationsGet**
```swift
    open class func installationsGet(pageCursor: String? = nil, include: [String]? = nil, filterClientProvidedInstallationId: [String]? = nil, filterId: [String]? = nil, filterOwnersId: [String]? = nil, completion: @escaping (_ data: InstallationsMultiResourceDataDocument?, _ error: Error?) -> Void)
```

Get multiple installations.

Retrieves multiple installations by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: offlineInventory, owners (optional)
let filterClientProvidedInstallationId = ["inner_example"] // [String] | Client provided installation identifier (e.g. `a468bee88def`) (optional)
let filterId = ["inner_example"] // [String] | Installation id (e.g. `a468bee88def`) (optional)
let filterOwnersId = ["inner_example"] // [String] | User id (e.g. `123456`) (optional)

// Get multiple installations.
InstallationsAPI.installationsGet(pageCursor: pageCursor, include: include, filterClientProvidedInstallationId: filterClientProvidedInstallationId, filterId: filterId, filterOwnersId: filterOwnersId) { (response, error) in
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
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: offlineInventory, owners | [optional] 
 **filterClientProvidedInstallationId** | [**[String]**](String.md) | Client provided installation identifier (e.g. &#x60;a468bee88def&#x60;) | [optional] 
 **filterId** | [**[String]**](String.md) | Installation id (e.g. &#x60;a468bee88def&#x60;) | [optional] 
 **filterOwnersId** | [**[String]**](String.md) | User id (e.g. &#x60;123456&#x60;) | [optional] 

### Return type

[**InstallationsMultiResourceDataDocument**](InstallationsMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **installationsIdGet**
```swift
    open class func installationsIdGet(id: String, include: [String]? = nil, completion: @escaping (_ data: InstallationsSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single installation.

Retrieves single installation by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Installation id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: offlineInventory, owners (optional)

// Get single installation.
InstallationsAPI.installationsIdGet(id: id, include: include) { (response, error) in
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
 **id** | **String** | Installation id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: offlineInventory, owners | [optional] 

### Return type

[**InstallationsSingleResourceDataDocument**](InstallationsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **installationsIdRelationshipsOfflineInventoryDelete**
```swift
    open class func installationsIdRelationshipsOfflineInventoryDelete(id: String, installationsOfflineInventoryRelationshipRemoveOperationPayload: InstallationsOfflineInventoryRelationshipRemoveOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Delete from offlineInventory relationship (\"to-many\").

Deletes item(s) from offlineInventory relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Installation id
let installationsOfflineInventoryRelationshipRemoveOperationPayload = InstallationsOfflineInventoryRelationshipRemoveOperation_Payload(data: [InstallationsOfflineInventory_ItemIdentifier(id: "id_example", type: "type_example")]) // InstallationsOfflineInventoryRelationshipRemoveOperationPayload |  (optional)

// Delete from offlineInventory relationship (\"to-many\").
InstallationsAPI.installationsIdRelationshipsOfflineInventoryDelete(id: id, installationsOfflineInventoryRelationshipRemoveOperationPayload: installationsOfflineInventoryRelationshipRemoveOperationPayload) { (response, error) in
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
 **id** | **String** | Installation id | 
 **installationsOfflineInventoryRelationshipRemoveOperationPayload** | [**InstallationsOfflineInventoryRelationshipRemoveOperationPayload**](InstallationsOfflineInventoryRelationshipRemoveOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **installationsIdRelationshipsOfflineInventoryGet**
```swift
    open class func installationsIdRelationshipsOfflineInventoryGet(id: String, pageCursor: String? = nil, include: [String]? = nil, filterType: [FilterType_installationsIdRelationshipsOfflineInventoryGet]? = nil, completion: @escaping (_ data: InstallationsOfflineInventoryMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get offlineInventory relationship (\"to-many\").

Retrieves offlineInventory relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Installation id
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: offlineInventory (optional)
let filterType = ["filterType_example"] // [String] | One of: tracks, videos, albums, playlists (e.g. `tracks`) (optional)

// Get offlineInventory relationship (\"to-many\").
InstallationsAPI.installationsIdRelationshipsOfflineInventoryGet(id: id, pageCursor: pageCursor, include: include, filterType: filterType) { (response, error) in
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
 **id** | **String** | Installation id | 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: offlineInventory | [optional] 
 **filterType** | [**[String]**](String.md) | One of: tracks, videos, albums, playlists (e.g. &#x60;tracks&#x60;) | [optional] 

### Return type

[**InstallationsOfflineInventoryMultiRelationshipDataDocument**](InstallationsOfflineInventoryMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **installationsIdRelationshipsOfflineInventoryPost**
```swift
    open class func installationsIdRelationshipsOfflineInventoryPost(id: String, installationsOfflineInventoryRelationshipAddOperationPayload: InstallationsOfflineInventoryRelationshipAddOperationPayload? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Add to offlineInventory relationship (\"to-many\").

Adds item(s) to offlineInventory relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Installation id
let installationsOfflineInventoryRelationshipAddOperationPayload = InstallationsOfflineInventoryRelationshipAddOperation_Payload(data: [InstallationsOfflineInventory_ItemIdentifier(id: "id_example", type: "type_example")]) // InstallationsOfflineInventoryRelationshipAddOperationPayload |  (optional)

// Add to offlineInventory relationship (\"to-many\").
InstallationsAPI.installationsIdRelationshipsOfflineInventoryPost(id: id, installationsOfflineInventoryRelationshipAddOperationPayload: installationsOfflineInventoryRelationshipAddOperationPayload) { (response, error) in
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
 **id** | **String** | Installation id | 
 **installationsOfflineInventoryRelationshipAddOperationPayload** | [**InstallationsOfflineInventoryRelationshipAddOperationPayload**](InstallationsOfflineInventoryRelationshipAddOperationPayload.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **installationsIdRelationshipsOwnersGet**
```swift
    open class func installationsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: InstallationsMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Installation id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get owners relationship (\"to-many\").
InstallationsAPI.installationsIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | Installation id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**InstallationsMultiRelationshipDataDocument**](InstallationsMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **installationsPost**
```swift
    open class func installationsPost(installationsCreateOperationPayload: InstallationsCreateOperationPayload? = nil, completion: @escaping (_ data: InstallationsSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Create single installation.

Creates a new installation.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let installationsCreateOperationPayload = InstallationsCreateOperation_Payload(data: InstallationsCreateOperation_Payload_Data(attributes: InstallationsCreateOperation_Payload_Data_Attributes(clientProvidedInstallationId: "clientProvidedInstallationId_example", name: "name_example"), type: "type_example")) // InstallationsCreateOperationPayload |  (optional)

// Create single installation.
InstallationsAPI.installationsPost(installationsCreateOperationPayload: installationsCreateOperationPayload) { (response, error) in
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
 **installationsCreateOperationPayload** | [**InstallationsCreateOperationPayload**](InstallationsCreateOperationPayload.md) |  | [optional] 

### Return type

[**InstallationsSingleResourceDataDocument**](InstallationsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

