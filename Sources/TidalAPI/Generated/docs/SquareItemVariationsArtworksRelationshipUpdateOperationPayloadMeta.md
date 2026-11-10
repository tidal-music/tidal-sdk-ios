# SquareItemVariationsArtworksRelationshipUpdateOperationPayloadMeta

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**expectedRevision** | **Int64** | Observed variation revision, read from attributes.revision or the relationship&#39;s meta.revision; a stale revision returns 409 and changes nothing. Does not guard the parent item, sibling variations or inventory quantity | 
**mode** | **String** | Relationship mutation mode. INCREMENTAL updates selected existing entries without adding or removing memberships; REPLACE_ALL replaces the complete membership and its order where applicable. Omission defaults to REPLACE_ALL. | [optional] [default to .replaceAll]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


