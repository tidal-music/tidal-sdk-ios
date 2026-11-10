# SharesAttributes

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**accessModes** | **Set<String>** | Ways this share may be used to obtain access, decided by the server. Deprecated: clients must not rely on it. | 
**code** | **String** | Share code | 
**createdAt** | **Date** | Time the share was created. | 
**expiresAt** | **Date** | Time bearer access and acceptance expire; accepted grants remain valid. | 
**externalLinks** | [ExternalLink] | Links external to TIDAL API | [optional] 
**maxUses** | **Int** | Number of saves the share permits. Absent when unlimited. | [optional] 
**password** | **String** | Password a user must send to save the share. Write-only: never returned. | [optional] 
**passwordProtected** | **Bool** | Whether saving the share requires a password. A protected share never permits BEARER access, and only its owner and users with a role on its shared resource see that resource. | 
**role** | **String** | Role offered on the shared resource. | 
**useCount** | **Int** | Number of saves so far, repeated saves included. Once it reaches maxUses, bearer access and acceptance end. Absent when maxUses is. | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


