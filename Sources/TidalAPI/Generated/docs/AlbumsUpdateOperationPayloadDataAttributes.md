# AlbumsUpdateOperationPayloadDataAttributes

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**accessType** | **String** | Access type | [optional] 
**albumType** | **String** |  | [optional] 
**barcodeId** | **String** | A barcode the rights holder already owns: a GTIN-12 or GTIN-13 (UPC-A or EAN-13) with a valid GS1 check digit. A barcode set here can be replaced until the album is first sold, and null resets it to the default value. An empty string is also accepted as a reset for now, for compatibility. After the first sale both are rejected. The barcode TIDAL assigns at the album&#39;s first sale is permanent. Omit the field to leave the barcode unchanged. | [optional] 
**copyright** | [**Copyright**](Copyright.md) |  | [optional] 
**explicit** | **Bool** | Explicit content | [optional] 
**explicitLyrics** | **Bool** | Explicit content. Deprecated: use &#39;explicit&#39; instead. This field will be removed in a future version. | [optional] 
**releaseDate** | **Date** |  | [optional] 
**title** | **String** |  | [optional] 
**version** | **String** |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


