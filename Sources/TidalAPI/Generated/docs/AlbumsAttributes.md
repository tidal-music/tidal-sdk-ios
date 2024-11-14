# AlbumsAttributes

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**title** | **String** | Original title | 
**barcodeId** | **String** | Barcode id (EAN-13 or UPC-A) | 
**numberOfVolumes** | **Int** | Number of volumes | 
**numberOfItems** | **Int** | Number of album items | 
**duration** | **String** | Duration (ISO-8601) | 
**explicit** | **Bool** | Indicates whether an album consist of any explicit content | 
**releaseDate** | **Date** | Release date (ISO-8601) | [optional] 
**copyright** | **String** | Copyright information | [optional] 
**popularity** | **Double** | Album popularity (ranged in 0.00 ... 1.00). Conditionally visible | 
**availability** | **[String]** | Defines an album availability e.g. for streaming, DJs, stems | [optional] 
**mediaTags** | **[String]** |  | 
**imageLinks** | [CatalogueItemImageLink] | Represents available links to, and metadata about, an album cover images | [optional] 
**videoLinks** | [CatalogueItemVideoLink] | Represents available links to, and metadata about, an album cover videos | [optional] 
**externalLinks** | [CatalogueItemExternalLink] | Represents available links to something that is related to an album resource, but external to the TIDAL API | [optional] 
**type** | **String** | Album type, e.g. single, regular album, or extended play | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


