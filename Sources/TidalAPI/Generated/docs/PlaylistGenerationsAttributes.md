# PlaylistGenerationsAttributes

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**lastGeneratedAt** | **Date** | Datetime the playlist content this generation produced was committed (ISO 8601). Unlike progress.lastModifiedAt, which any write moves, this only moves when a generation succeeds. Omitted while a generation is still running, when it failed, and for playlists generated before generation history was recorded | [optional] 
**progress** | [**PlaylistGenerationProgress**](PlaylistGenerationProgress.md) |  | 
**prompt** | **String** | Prompt used to create the generation; omitted for legacy generations | [optional] 
**status** | **String** | Current prompted-playlist generation status | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


