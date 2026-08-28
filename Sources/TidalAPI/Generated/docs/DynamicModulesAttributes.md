# DynamicModulesAttributes

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**icons** | **[String]** | Semantic icons the module should show. SPOTLIGHT_INFO identifies modules whose content was selected by TIDAL&#39;s editorial team. | 
**previewLayout** | **String** | Presentation family for items in a dynamic module preview. The API selects the semantic presentation intent while clients own platform-specific geometry. A layout does not prescribe scroll direction, row or column count, dimensions, spacing, breakpoints, or visible item count; clients preserve the server-provided item order. GRID means artwork-forward tiles or cards. LIST means detail-forward row cells, which clients may arrange in one or more columns. SHORTCUT means compact quick-access items, which clients may arrange as a responsive grid or rail. UNKNOWN is the forward-compatible default; clients should skip the module or use a safe default. | 
**subtitle** | **String** | Subtitle of the module | [optional] 
**title** | **String** | Title of the module | [optional] 
**viewAllLayout** | **String** | Presentation family for items on a dynamic module&#39;s view-all screen. The API selects the semantic presentation intent while clients own platform-specific geometry. A layout does not prescribe scroll direction, row or column count, dimensions, spacing, or breakpoints; clients preserve the server-provided item order. When viewAllLayout is omitted, the module has no view-all screen. GRID means artwork-forward tiles or cards. LIST means detail-forward row cells, which clients may arrange in one or more columns or as a table. UNKNOWN is the forward-compatible default; clients should skip the module or use a safe default. | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


