# SharesAttributes

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**accessModes** | **Set<String>** | Ways this share may be used to obtain access. BEARER permits access by presenting its code while active. VOUCHER permits an authenticated user to redeem it for a stored grant. Multiple modes may be enabled. | 
**code** | **String** | Share code | 
**createdAt** | **Date** | Time the share was created. | 
**expiresAt** | **Date** | Time bearer access and acceptance expire; accepted grants remain valid. | 
**externalLinks** | [ExternalLink] | Links external to TIDAL API | [optional] 
**maxUses** | **Int** | Number of users other than the owner who may save the share. Absent when unlimited. | [optional] 
**role** | **String** | Role offered on the shared resource. | 
**useCount** | **Int** | Number of users other than the owner who have saved the share. Once it reaches maxUses, bearer access and acceptance end. Absent when maxUses is. | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


