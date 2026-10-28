# SharesCreateOperationPayloadDataAttributes

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**accessModes** | **Set<String>** | Ways this share may be used to obtain access. BEARER permits access by presenting its code while active. VOUCHER permits redemption for a stored grant. Defaults to both modes for every role. Playlist shares must include VOUCHER; bearer-only playlist shares are rejected with 400. | [optional] 
**expiresAt** | **Date** | Time bearer access and acceptance expire; must be in the future and at most a year away. Defaults to seven days after creation when omitted or null. | [optional] 
**maxUses** | **Int** | Number of users other than the owner who may save the share. Only a save counts as a use, and a used-up share also stops bearer access. Requires the VOUCHER access mode. Omit or send null for unlimited saves. | [optional] 
**role** | **String** | Role offered by the share. | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


