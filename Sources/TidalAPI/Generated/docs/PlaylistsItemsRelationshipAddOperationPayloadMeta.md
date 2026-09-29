# PlaylistsItemsRelationshipAddOperationPayloadMeta

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**onDuplicates** | **String** | How to handle available items already present in the playlist. Presence is evaluated against playlist state immediately before the operation; duplicate occurrences within this request do not make one another already present. ADD adds every requested occurrence. FAIL returns 409 and adds nothing when any requested resource type and id is already present. SKIP adds only absent resources and reports every omitted occurrence in response meta.skipped with reason ALREADY_PRESENT. Track and video identities with the same id are distinct. Defaults to ADD. | [optional] [default to .add]
**positionBefore** | **String** |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


