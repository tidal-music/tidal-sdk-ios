# UsageRulesCreateOperationPayloadDataAttributes

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**countryCode** | **String** |  | [optional] 
**free** | **[String]** |  | [optional] 
**inherited** | **Bool** | Tracks only. Set to true (with empty paid/subscription/free) to clear an explicit track-level override and inherit usage rules from the album. Must be omitted or false when providing explicit usage values. | [optional] 
**paid** | **[String]** |  | [optional] 
**subscription** | **[String]** |  | [optional] 
**validFrom** | **Date** | Datetime from which these usage rules are valid (ISO 8601) | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


