# CollaborationInvitesAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**collaborationInvitesGet**](CollaborationInvitesAPI.md#collaborationinvitesget) | **GET** /collaborationInvites | Get multiple collaborationInvites.
[**collaborationInvitesIdDelete**](CollaborationInvitesAPI.md#collaborationinvitesiddelete) | **DELETE** /collaborationInvites/{id} | Delete single collaborationInvite.
[**collaborationInvitesIdGet**](CollaborationInvitesAPI.md#collaborationinvitesidget) | **GET** /collaborationInvites/{id} | Get single collaborationInvite.
[**collaborationInvitesIdRelationshipsOwnersGet**](CollaborationInvitesAPI.md#collaborationinvitesidrelationshipsownersget) | **GET** /collaborationInvites/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
[**collaborationInvitesIdRelationshipsSubjectGet**](CollaborationInvitesAPI.md#collaborationinvitesidrelationshipssubjectget) | **GET** /collaborationInvites/{id}/relationships/subject | Get subject relationship (\&quot;to-one\&quot;).
[**collaborationInvitesPost**](CollaborationInvitesAPI.md#collaborationinvitespost) | **POST** /collaborationInvites | Create single collaborationInvite.


# **collaborationInvitesGet**
```swift
    open class func collaborationInvitesGet(include: [String]? = nil, filterCode: [String]? = nil, completion: @escaping (_ data: CollaborationInvitesMultiResourceDataDocument?, _ error: Error?) -> Void)
```

Get multiple collaborationInvites.

Retrieves multiple collaborationInvites by available filters, or without if applicable.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners, subject (optional)
let filterCode = ["inner_example"] // [String] | Invite code (optional)

// Get multiple collaborationInvites.
CollaborationInvitesAPI.collaborationInvitesGet(include: include, filterCode: filterCode) { (response, error) in
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
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners, subject | [optional] 
 **filterCode** | [**[String]**](String.md) | Invite code | [optional] 

### Return type

[**CollaborationInvitesMultiResourceDataDocument**](CollaborationInvitesMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **collaborationInvitesIdDelete**
```swift
    open class func collaborationInvitesIdDelete(id: String, idempotencyKey: String? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Delete single collaborationInvite.

Deletes existing collaborationInvite.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Collaboration invite id
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. (optional)

// Delete single collaborationInvite.
CollaborationInvitesAPI.collaborationInvitesIdDelete(id: id, idempotencyKey: idempotencyKey) { (response, error) in
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
 **id** | **String** | Collaboration invite id | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. | [optional] 

### Return type

Void (empty response body)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **collaborationInvitesIdGet**
```swift
    open class func collaborationInvitesIdGet(id: String, include: [String]? = nil, completion: @escaping (_ data: CollaborationInvitesSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single collaborationInvite.

Retrieves single collaborationInvite by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Collaboration invite id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners, subject (optional)

// Get single collaborationInvite.
CollaborationInvitesAPI.collaborationInvitesIdGet(id: id, include: include) { (response, error) in
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
 **id** | **String** | Collaboration invite id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners, subject | [optional] 

### Return type

[**CollaborationInvitesSingleResourceDataDocument**](CollaborationInvitesSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **collaborationInvitesIdRelationshipsOwnersGet**
```swift
    open class func collaborationInvitesIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil, completion: @escaping (_ data: CollaborationInvitesMultiRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get owners relationship (\"to-many\").

Retrieves owners relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Collaboration invite id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: owners (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)

// Get owners relationship (\"to-many\").
CollaborationInvitesAPI.collaborationInvitesIdRelationshipsOwnersGet(id: id, include: include, pageCursor: pageCursor) { (response, error) in
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
 **id** | **String** | Collaboration invite id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: owners | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 

### Return type

[**CollaborationInvitesMultiRelationshipDataDocument**](CollaborationInvitesMultiRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **collaborationInvitesIdRelationshipsSubjectGet**
```swift
    open class func collaborationInvitesIdRelationshipsSubjectGet(id: String, include: [String]? = nil, completion: @escaping (_ data: CollaborationInvitesSingleRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get subject relationship (\"to-one\").

Retrieves subject relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Collaboration invite id
let include = ["inner_example"] // [String] | Allows the client to customize which related resources should be returned. Available options: subject (optional)

// Get subject relationship (\"to-one\").
CollaborationInvitesAPI.collaborationInvitesIdRelationshipsSubjectGet(id: id, include: include) { (response, error) in
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
 **id** | **String** | Collaboration invite id | 
 **include** | [**[String]**](String.md) | Allows the client to customize which related resources should be returned. Available options: subject | [optional] 

### Return type

[**CollaborationInvitesSingleRelationshipDataDocument**](CollaborationInvitesSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **collaborationInvitesPost**
```swift
    open class func collaborationInvitesPost(idempotencyKey: String? = nil, collaborationInvitesCreateOperationPayload: CollaborationInvitesCreateOperationPayload? = nil, completion: @escaping (_ data: CollaborationInvitesSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Create single collaborationInvite.

Creates a new collaborationInvite.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. (optional)
let collaborationInvitesCreateOperationPayload = CollaborationInvitesCreateOperation_Payload(data: CollaborationInvitesCreateOperation_Payload_Data(relationships: CollaborationInvitesCreateOperation_Payload_Data_Relationships(subject: CollaborationInvitesCreateOperation_Payload_Data_Relationships_Subject(data: CollaborationInvitesCreateOperation_Payload_Data_Relationships_Subject_Data(id: "id_example", type: "type_example"))), type: "type_example")) // CollaborationInvitesCreateOperationPayload |  (optional)

// Create single collaborationInvite.
CollaborationInvitesAPI.collaborationInvitesPost(idempotencyKey: idempotencyKey, collaborationInvitesCreateOperationPayload: collaborationInvitesCreateOperationPayload) { (response, error) in
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
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If a duplicate key is sent with the same payload, the original response is replayed. If the payload differs, a 422 error is returned. | [optional] 
 **collaborationInvitesCreateOperationPayload** | [**CollaborationInvitesCreateOperationPayload**](CollaborationInvitesCreateOperationPayload.md) |  | [optional] 

### Return type

[**CollaborationInvitesSingleResourceDataDocument**](CollaborationInvitesSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

