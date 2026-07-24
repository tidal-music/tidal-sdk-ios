# DynamicModulesAttributes

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**fullViewLayout** | **String** | Rendering layout for a dynamic module. previewLayout controls the module on a dynamic page. fullViewLayout controls its view-all screen; when omitted, the module has no view-all screen. GRID means artwork-forward tiles; the client owns scroll axis and column count. LIST means detailed text-forward rows in a single column and may be a table on wide screens. COMPACT means dense rows the client may pack into multiple columns; clients should treat it as LIST in a full view. UNKNOWN is the forward-compatible default; clients should skip the module or use a safe default. | [optional] 
**icons** | **[String]** | Semantic icons the module should show. SPOTLIGHT_INFO identifies modules whose content was selected by TIDAL&#39;s editorial team. | 
**previewLayout** | **String** | Rendering layout for a dynamic module. previewLayout controls the module on a dynamic page. fullViewLayout controls its view-all screen; when omitted, the module has no view-all screen. GRID means artwork-forward tiles; the client owns scroll axis and column count. LIST means detailed text-forward rows in a single column and may be a table on wide screens. COMPACT means dense rows the client may pack into multiple columns; clients should treat it as LIST in a full view. UNKNOWN is the forward-compatible default; clients should skip the module or use a safe default. | 
**subtitle** | **String** | Subtitle of the module | [optional] 
**title** | **String** | Title of the module | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


