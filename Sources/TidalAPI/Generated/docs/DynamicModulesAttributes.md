# DynamicModulesAttributes

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**icons** | **[String]** | Semantic icons the module should show. SPOTLIGHT_INFO identifies modules whose content was selected by TIDAL&#39;s editorial team. | 
**previewLayout** | **String** | Rendering layout for a dynamic module on a dynamic page. GRID means artwork-forward tiles; the client owns scroll axis and column count. LIST means detailed text-forward rows in a single column and may be a table on wide screens. SHORTCUT selects a quick-access shortcut-bank renderer; clients own responsive rows and columns and chip styling. UNKNOWN is the forward-compatible default; clients should skip the module or use a safe default. | 
**subtitle** | **String** | Subtitle of the module | [optional] 
**title** | **String** | Title of the module | [optional] 
**viewAllLayout** | **String** | Rendering layout for a dynamic module&#39;s view-all screen. When viewAllLayout is omitted, the module has no view-all screen. GRID means artwork-forward tiles; the client owns column count. LIST means detailed text-forward rows in a single column and may be a table on wide screens. UNKNOWN is the forward-compatible default; clients should skip the module or use a safe default. | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


