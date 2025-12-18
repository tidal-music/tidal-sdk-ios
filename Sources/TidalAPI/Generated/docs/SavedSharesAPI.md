# SavedSharesAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**savedSharesPost**](SavedSharesAPI.md#savedsharespost) | **POST** /savedShares | Create single savedShare.


# **savedSharesPost**
```swift
    open class func savedSharesPost(savedSharesCreateOperationPayload: SavedSharesCreateOperationPayload? = nil, completion: @escaping (_ data: SavedSharesSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Create single savedShare.

Creates a new savedShare.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let savedSharesCreateOperationPayload = SavedSharesCreateOperation_Payload(data: SavedSharesCreateOperation_Payload_Data(relationships: SavedSharesCreateOperation_Payload_Data_Relationships(share: SavedSharesCreateOperation_Payload_Data_Relationships_Share(data: SavedSharesCreateOperation_Payload_Data_Relationships_Share_Data(id: "id_example", type: "type_example"))), type: "type_example")) // SavedSharesCreateOperationPayload |  (optional)

// Create single savedShare.
SavedSharesAPI.savedSharesPost(savedSharesCreateOperationPayload: savedSharesCreateOperationPayload) { (response, error) in
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
 **savedSharesCreateOperationPayload** | [**SavedSharesCreateOperationPayload**](SavedSharesCreateOperationPayload.md) |  | [optional] 

### Return type

[**SavedSharesSingleResourceDataDocument**](SavedSharesSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

