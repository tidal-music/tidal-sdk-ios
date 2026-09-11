# AlbumsUpdateOperationPayloadDataAttributes

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**accessType** | **String** | Access type | [optional] 
**albumType** | **String** |  | [optional] 
**barcodeId** | **String** | A barcode the rights holder already owns: a GTIN-12 or GTIN-13 (UPC-A or EAN-13) with a valid GS1 check digit. It can only be set while the album has no barcode of its own: the barcode TIDAL assigns at the album&#39;s first sale is permanent. Omit the field, and TIDAL assigns one then. | [optional] 
**copyright** | [**Copyright**](Copyright.md) |  | [optional] 
**explicit** | **Bool** | Explicit content | [optional] 
**explicitLyrics** | **Bool** | Explicit content. Deprecated: use &#39;explicit&#39; instead. This field will be removed in a future version. | [optional] 
**releaseDate** | **Date** |  | [optional] 
**title** | **String** |  | [optional] 
**version** | **String** |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


