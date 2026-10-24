# SquareItemsVariationsRelationshipUpdateOperationPayloadMeta

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**expectedRevision** | **Int64** |  | 
**mode** | **String** | Relationship mutation mode. INCREMENTAL updates selected existing entries without adding or removing memberships; REPLACE_ALL replaces the complete membership and its order where applicable. Omission defaults to INCREMENTAL. | [optional] [default to .incremental]
**positionBefore** | **String** | Variation before which the selected block is placed; omission appends | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


