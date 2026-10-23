# ResourceGrantsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**resourceGrantsGet**](ResourceGrantsAPI.md#resourcegrantsget) | **GET** /resourceGrants | Get multiple resourceGrants.
[**resourceGrantsIdDelete**](ResourceGrantsAPI.md#resourcegrantsiddelete) | **DELETE** /resourceGrants/{id} | Delete single resourceGrant.
[**resourceGrantsIdGet**](ResourceGrantsAPI.md#resourcegrantsidget) | **GET** /resourceGrants/{id} | Get single resourceGrant.
[**resourceGrantsIdPatch**](ResourceGrantsAPI.md#resourcegrantsidpatch) | **PATCH** /resourceGrants/{id} | Update single resourceGrant.
[**resourceGrantsIdRelationshipsGranteeGet**](ResourceGrantsAPI.md#resourcegrantsidrelationshipsgranteeget) | **GET** /resourceGrants/{id}/relationships/grantee | Get grantee relationship (\&quot;to-one\&quot;).
[**resourceGrantsIdRelationshipsSubjectGet**](ResourceGrantsAPI.md#resourcegrantsidrelationshipssubjectget) | **GET** /resourceGrants/{id}/relationships/subject | Get subject relationship (\&quot;to-one\&quot;).
[**resourceGrantsPost**](ResourceGrantsAPI.md#resourcegrantspost) | **POST** /resourceGrants | Create single resourceGrant.


# **resourceGrantsGet**
```swift
    open class func resourceGrantsGet(filterGrantee: String? = nil, filterRole: FilterRole_resourceGrantsGet? = nil, filterSubject: String? = nil, include: [String]? = nil, includeLinkage: [IncludeLinkage_resourceGrantsGet]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil, completion: @escaping (_ data: ResourceGrantsMultiResourceDataDocument?, _ error: Error?) -> Void)
```

Get multiple resourceGrants.

Lists stored grants from every source visible to the subject's owner or named user grantee, selected by subject or grantee, optionally restricted by assigned role. Requires subject or grantee.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let filterGrantee = "filterGrantee_example" // String | Filter by grantee. Also accepts `users:me`. (optional)
let filterRole = "filterRole_example" // String | One of: VIEWER, COLLABORATOR, OWNER (e.g. `VIEWER`) (optional)
let filterSubject = "filterSubject_example" // String | Filter by subject. Also accepts `folders:me`. (optional)
let include = ["inner_example"] // [String] | Include related resources. Available relationships: grantee, subject (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let pageCursor = "pageCursor_example" // String | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: grantee.artist.albums (optional)

// Get multiple resourceGrants.
ResourceGrantsAPI.resourceGrantsGet(filterGrantee: filterGrantee, filterRole: filterRole, filterSubject: filterSubject, include: include, includeLinkage: includeLinkage, pageCursor: pageCursor, replaceMedia: replaceMedia) { (response, error) in
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
 **filterGrantee** | **String** | Filter by grantee. Also accepts &#x60;users:me&#x60;. | [optional] 
 **filterRole** | **String** | One of: VIEWER, COLLABORATOR, OWNER (e.g. &#x60;VIEWER&#x60;) | [optional] 
 **filterSubject** | **String** | Filter by subject. Also accepts &#x60;folders:me&#x60;. | [optional] 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: grantee, subject | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **pageCursor** | **String** | Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: grantee.artist.albums | [optional] 

### Return type

[**ResourceGrantsMultiResourceDataDocument**](ResourceGrantsMultiResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **resourceGrantsIdDelete**
```swift
    open class func resourceGrantsIdDelete(id: String, idempotencyKey: String? = nil, completion: @escaping (_ data: MutationResponseDocument?, _ error: Error?) -> Void)
```

Delete single resourceGrant.

Deletes existing resourceGrant.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Opaque resource grant ID
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)

// Delete single resourceGrant.
ResourceGrantsAPI.resourceGrantsIdDelete(id: id, idempotencyKey: idempotencyKey) { (response, error) in
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
 **id** | **String** | Opaque resource grant ID | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 

### Return type

[**MutationResponseDocument**](MutationResponseDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **resourceGrantsIdGet**
```swift
    open class func resourceGrantsIdGet(id: String, include: [String]? = nil, includeLinkage: [IncludeLinkage_resourceGrantsIdGet]? = nil, replaceMedia: String? = nil, completion: @escaping (_ data: ResourceGrantsSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Get single resourceGrant.

Retrieves single resourceGrant by id.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Opaque resource grant ID
let include = ["inner_example"] // [String] | Include related resources. Available relationships: grantee, subject (optional)
let includeLinkage = ["includeLinkage_example"] // [String] | Comma-separated direct relationships to return as linkage only, without related content. (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: grantee.artist.albums (optional)

// Get single resourceGrant.
ResourceGrantsAPI.resourceGrantsIdGet(id: id, include: include, includeLinkage: includeLinkage, replaceMedia: replaceMedia) { (response, error) in
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
 **id** | **String** | Opaque resource grant ID | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: grantee, subject | [optional] 
 **includeLinkage** | [**[String]**](String.md) | Comma-separated direct relationships to return as linkage only, without related content. | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: grantee.artist.albums | [optional] 

### Return type

[**ResourceGrantsSingleResourceDataDocument**](ResourceGrantsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **resourceGrantsIdPatch**
```swift
    open class func resourceGrantsIdPatch(id: String, idempotencyKey: String? = nil, resourceGrantsUpdateOperationPayload: ResourceGrantsUpdateOperationPayload? = nil, completion: @escaping (_ data: ResourceGrantsUpdateSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Update single resourceGrant.

Updates existing resourceGrant.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Opaque resource grant ID
let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let resourceGrantsUpdateOperationPayload = ResourceGrantsUpdateOperation_Payload(data: ResourceGrantsUpdateOperation_Payload_Data(attributes: ResourceGrantsUpdateOperation_Payload_Data_Attributes(role: "role_example"), id: "id_example", type: "type_example")) // ResourceGrantsUpdateOperationPayload |  (optional)

// Update single resourceGrant.
ResourceGrantsAPI.resourceGrantsIdPatch(id: id, idempotencyKey: idempotencyKey, resourceGrantsUpdateOperationPayload: resourceGrantsUpdateOperationPayload) { (response, error) in
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
 **id** | **String** | Opaque resource grant ID | 
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **resourceGrantsUpdateOperationPayload** | [**ResourceGrantsUpdateOperationPayload**](ResourceGrantsUpdateOperationPayload.md) |  | [optional] 

### Return type

[**ResourceGrantsUpdateSingleResourceDataDocument**](ResourceGrantsUpdateSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **resourceGrantsIdRelationshipsGranteeGet**
```swift
    open class func resourceGrantsIdRelationshipsGranteeGet(id: String, include: [String]? = nil, replaceMedia: String? = nil, completion: @escaping (_ data: ResourceGrantsGranteeSingleRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get grantee relationship (\"to-one\").

Retrieves grantee relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Opaque resource grant ID
let include = ["inner_example"] // [String] | Include related resources. Available relationships: grantee (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: grantee.artist.albums (optional)

// Get grantee relationship (\"to-one\").
ResourceGrantsAPI.resourceGrantsIdRelationshipsGranteeGet(id: id, include: include, replaceMedia: replaceMedia) { (response, error) in
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
 **id** | **String** | Opaque resource grant ID | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: grantee | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: grantee.artist.albums | [optional] 

### Return type

[**ResourceGrantsGranteeSingleRelationshipDataDocument**](ResourceGrantsGranteeSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **resourceGrantsIdRelationshipsSubjectGet**
```swift
    open class func resourceGrantsIdRelationshipsSubjectGet(id: String, include: [String]? = nil, replaceMedia: String? = nil, completion: @escaping (_ data: ResourceGrantsSubjectSingleRelationshipDataDocument?, _ error: Error?) -> Void)
```

Get subject relationship (\"to-one\").

Retrieves subject relationship.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = "id_example" // String | Opaque resource grant ID
let include = ["inner_example"] // [String] | Include related resources. Available relationships: subject (optional)
let replaceMedia = "replaceMedia_example" // String | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow `include` syntax. Example: subject (optional)

// Get subject relationship (\"to-one\").
ResourceGrantsAPI.resourceGrantsIdRelationshipsSubjectGet(id: id, include: include, replaceMedia: replaceMedia) { (response, error) in
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
 **id** | **String** | Opaque resource grant ID | 
 **include** | [**[String]**](String.md) | Include related resources. Available relationships: subject | [optional] 
 **replaceMedia** | **String** | Applies context-dependent replacements to media resource identifiers in selected relationships without changing stored data. Paths are comma-separated and follow &#x60;include&#x60; syntax. Example: subject | [optional] 

### Return type

[**ResourceGrantsSubjectSingleRelationshipDataDocument**](ResourceGrantsSubjectSingleRelationshipDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **resourceGrantsPost**
```swift
    open class func resourceGrantsPost(idempotencyKey: String? = nil, resourceGrantsCreateOperationPayload: ResourceGrantsCreateOperationPayload? = nil, completion: @escaping (_ data: ResourceGrantsCreateSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Create single resourceGrant.

Creates a new resourceGrant.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let idempotencyKey = "idempotencyKey_example" // String | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. (optional)
let resourceGrantsCreateOperationPayload = ResourceGrantsCreateOperation_Payload(data: ResourceGrantsCreateOperation_Payload_Data(attributes: ResourceGrantsCreateOperation_Payload_Data_Attributes(role: "role_example"), relationships: ResourceGrantsCreateOperation_Payload_Data_Relationships(grantee: ResourceGrantsGranteeLinkage(data: ResourceGrantsGrantee(id: "id_example", type: "type_example")), subject: ResourceGrantsSubjectLinkage(data: ResourceGrantsSubject(id: "id_example", type: "type_example"))), type: "type_example")) // ResourceGrantsCreateOperationPayload |  (optional)

// Create single resourceGrant.
ResourceGrantsAPI.resourceGrantsPost(idempotencyKey: idempotencyKey, resourceGrantsCreateOperationPayload: resourceGrantsCreateOperationPayload) { (response, error) in
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
 **idempotencyKey** | **String** | Unique idempotency key for safe retry of mutation requests. If the same caller repeats a key with the same method, path, query and payload, the original response is replayed. If the request differs, a 422 error is returned. | [optional] 
 **resourceGrantsCreateOperationPayload** | [**ResourceGrantsCreateOperationPayload**](ResourceGrantsCreateOperationPayload.md) |  | [optional] 

### Return type

[**ResourceGrantsCreateSingleResourceDataDocument**](ResourceGrantsCreateSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

