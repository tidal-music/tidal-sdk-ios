# SharesCreateOperationPayloadDataAttributes

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**expiresAt** | **Date** | Time bearer access and acceptance expire; must be in the future and at most a year away. Defaults to seven days after creation when omitted or null. | [optional] 
**maxUses** | **Int** | Number of saves the share permits. Every save counts as a use, and a used-up share also stops bearer access. Omit or send null for unlimited saves. | [optional] 
**password** | **String** | Password a user must send to save the share. Never returned. Must be printable ASCII characters. A protected share permits no bearer access. A password on a playlist share is rejected with 400. | [optional] 
**role** | **String** | Role offered by the share. | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


