# UsageRulesAttributes

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**countryCode** | **String** | Country code (ISO 3166-1 alpha-2) | 
**free** | **[String]** | Usage types allowed for free/ad-supported model | [optional] 
**inherited** | **Bool** | Whether these usage rules are inherited from a parent (e.g. a track inheriting from its album). Tri-state: true means the rules are inherited, false means an explicit per-track override, null means the value is unknown or not applicable (albums, videos, and legacy data). | [optional] 
**paid** | **[String]** | Usage types allowed for paid/purchase model | [optional] 
**subscription** | **[String]** | Usage types allowed for subscription model | [optional] 
**validFrom** | **Date** | Datetime from which these usage rules are valid (ISO 8601) | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


