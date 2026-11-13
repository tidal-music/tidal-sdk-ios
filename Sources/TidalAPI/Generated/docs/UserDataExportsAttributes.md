# UserDataExportsAttributes

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**createdAt** | **Date** | When the export was requested | 
**dataTypes** | **[String]** | Kinds of data the export contains, as picked when requesting it | 
**downloadLink** | [**LinkObject**](LinkObject.md) |  | [optional] 
**expiresAt** | **Date** | When the export and its download stop being available; absent until it is ready | [optional] 
**readyAt** | **Date** | When the export became ready; absent until then | [optional] 
**status** | **String** | Lifecycle state of a user data export. New values may be added at any time. | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


