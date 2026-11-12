# ResourceGrantInvitationsAttributes

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**code** | **String** | Code that identifies the invitation to its recipients. | 
**createdAt** | **Date** | Time the invitation was created. | 
**expiresAt** | **Date** | Time redemption ends; issued grants remain. | 
**maxUses** | **Int** | Number of redemptions permitted. Absent when unlimited. | [optional] 
**password** | **String** | Password a user must send to redeem. Write-only: never returned. | [optional] 
**passwordProtected** | **Bool** | Whether redemption requires a password. Only the owner and users with a role on the subject see a protected invitation&#39;s subject; others get null linkage. | 
**preview** | **Bool** | Whether the code also gives VIEWER access to the subject until the invitation expires, through previewGrant. Previews are not yet supported, so it is always false. | 
**redemptionLink** | [**LinkObject**](LinkObject.md) |  | [optional] 
**role** | **String** | Role a redemption grants. | 
**useCount** | **Int** | Number of redemptions so far, repeated ones included. Absent when maxUses is. | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


