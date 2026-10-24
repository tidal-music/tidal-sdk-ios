# SharesCreateOperationPayloadDataAttributes

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**accessModes** | **Set<String>** | Ways this share may be used to obtain access. BEARER permits access by presenting its code while active. VOUCHER permits redemption for a stored grant. Defaults to both modes for every role. Playlist shares must include VOUCHER; bearer-only playlist shares are rejected with 400. | [optional] 
**role** | **String** | Role offered by the share. | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


