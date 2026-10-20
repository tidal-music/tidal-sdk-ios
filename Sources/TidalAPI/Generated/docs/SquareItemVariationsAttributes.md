# SquareItemVariationsAttributes

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**currency** | **String** |  | 
**name** | **String** | Variation name; may be empty | 
**price** | **String** | Amount in the currency&#39;s major units | [optional] 
**pricingType** | **String** | Effective pricing mode at the selected site&#39;s shipping location (merchant-main fallback). Price is present only for FIXED when its amount is available | 
**revision** | **Int64** | Square variation revision covering its catalog fields, including name, pricing and stock tracking; excludes inventory quantity and other variations | 
**stockQuantity** | **Int64** | Units at the selected site&#39;s shipping location (merchant-main fallback); present only when tracked and available; may be negative | [optional] 
**stockTracked** | **Bool** | Whether Square tracks stock at the selected site&#39;s shipping location (merchant-main fallback) | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


