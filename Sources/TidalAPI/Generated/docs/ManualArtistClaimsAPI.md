# ManualArtistClaimsAPI

All URIs are relative to *https://openapi.tidal.com/v2*

Method | HTTP request | Description
------------- | ------------- | -------------
[**manualArtistClaimsPost**](ManualArtistClaimsAPI.md#manualartistclaimspost) | **POST** /manualArtistClaims | Create single manualArtistClaim.


# **manualArtistClaimsPost**
```swift
    open class func manualArtistClaimsPost(manualArtistClaimsCreateOperationPayload: ManualArtistClaimsCreateOperationPayload? = nil, completion: @escaping (_ data: ManualArtistClaimsSingleResourceDataDocument?, _ error: Error?) -> Void)
```

Create single manualArtistClaim.

Creates a new manualArtistClaim.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let manualArtistClaimsCreateOperationPayload = ManualArtistClaimsCreateOperation_Payload(data: ManualArtistClaimsCreateOperation_Payload_Data(attributes: ManualArtistClaimsCreateOperation_Payload_Data_Attributes(acceptedTerms: false, artistId: "artistId_example", distributorName: "distributorName_example", errorReason: "errorReason_example", labelContactEmail: "labelContactEmail_example", labelContactName: "labelContactName_example", labelName: "labelName_example", legalFirstName: "legalFirstName_example", legalLastName: "legalLastName_example", managerEmail: "managerEmail_example", managerName: "managerName_example", role: "role_example", selectedAlbums: ["selectedAlbums_example"], selectedSingles: ["selectedSingles_example"], websiteOrSocialLink: "websiteOrSocialLink_example"), type: "type_example")) // ManualArtistClaimsCreateOperationPayload |  (optional)

// Create single manualArtistClaim.
ManualArtistClaimsAPI.manualArtistClaimsPost(manualArtistClaimsCreateOperationPayload: manualArtistClaimsCreateOperationPayload) { (response, error) in
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
 **manualArtistClaimsCreateOperationPayload** | [**ManualArtistClaimsCreateOperationPayload**](ManualArtistClaimsCreateOperationPayload.md) |  | [optional] 

### Return type

[**ManualArtistClaimsSingleResourceDataDocument**](ManualArtistClaimsSingleResourceDataDocument.md)

### Authorization

[Authorization_Code_PKCE](../README.md#Authorization_Code_PKCE)

### HTTP request headers

 - **Content-Type**: application/vnd.api+json
 - **Accept**: application/vnd.api+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

