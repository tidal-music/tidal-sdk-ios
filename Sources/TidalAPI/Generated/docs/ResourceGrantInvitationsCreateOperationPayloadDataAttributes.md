# ResourceGrantInvitationsCreateOperationPayloadDataAttributes

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**expiresAt** | **Date** | Time redemption ends; must be in the future and at most a year away. Defaults to seven days after creation. | [optional] 
**maxUses** | **Int** | Number of redemptions permitted, repeated ones included. Unlimited when omitted or null. | [optional] 
**password** | **String** | Password a user must send to redeem. Never returned. Must be printable ASCII characters. Playlist invitations cannot have one; 400. | [optional] 
**preview** | **Bool** | Whether previewGrant gives VIEWER access to the subject, whatever the role, until the invitation expires. Defaults to false. | [optional] 
**role** | **String** | Role a redemption grants. | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


