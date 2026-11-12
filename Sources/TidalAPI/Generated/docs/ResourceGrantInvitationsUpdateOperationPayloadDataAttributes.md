# ResourceGrantInvitationsUpdateOperationPayloadDataAttributes

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**password** | **String** | Password a user must send to redeem. Never returned. Must be printable ASCII characters. A value sets or changes it; null removes it; omitted leaves it unchanged. Playlist invitations cannot have one. | [optional] 
**preview** | **Bool** | Whether the code also gives VIEWER access to the subject, whatever the role, until the invitation expires. Previews are not yet supported, so true is rejected with 400. Omitted leaves it unchanged. | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


