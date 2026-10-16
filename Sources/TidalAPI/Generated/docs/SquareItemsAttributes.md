# SquareItemsAttributes

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**currency** | **String** | Currency of every price on the item | 
**description** | **String** | Item description | [optional] 
**lastModifiedAt** | **Date** | Timestamp when the item was last modified in Square; absent when Square has not reported one | [optional] 
**origin** | **String** | Where the item was created | [optional] 
**publishedInSelectedSite** | **Bool** | Whether the item is published in the seller&#39;s selected Square Online site; false when no site is selected | [optional] 
**revision** | **Int64** | Square catalog item revision used to guard item updates; excludes inventory stock | 
**title** | **String** | Item title; empty for an untitled item created in Square | 
**variations** | [SquareItemsVariation] | Variations, in Square&#39;s order | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


