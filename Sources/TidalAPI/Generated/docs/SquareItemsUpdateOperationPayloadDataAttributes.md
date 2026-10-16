# SquareItemsUpdateOperationPayloadDataAttributes

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**description** | **String** | Item description; an empty string removes it | [optional] 
**title** | **String** | Item title | [optional] 
**variations** | [SquareItemsUpdateOperationPayloadDataAttributesVariation] | Complete variation list in display order; variations without a variationId are added and omitted ones deleted. Every price must be positive and is written as FIXED. Replacement requires every existing variation to have a positive fixed price at the main location; otherwise edit the variations in Square Dashboard. Updates without variations remain supported. | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


