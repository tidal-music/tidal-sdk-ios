# ArtistSalesStatisticsAttributes

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**buyerSources** | [**ArtistSalesStatisticsBuyerSources**](ArtistSalesStatisticsBuyerSources.md) |  | [optional] 
**byType** | [**ArtistSalesStatisticsByType**](ArtistSalesStatisticsByType.md) |  | [optional] 
**currency** | **String** | Currency of every amount | [optional] 
**dataThrough** | **Date** | Last day included in the underlying data | 
**endDate** | **Date** | Last day of the window, inclusive | 
**itemsSold** | **Int64** | Items sold in the window | [optional] 
**lastModifiedAt** | **Date** | When these statistics were computed | 
**netSales** | [**ArtistSalesStatisticsNetSales**](ArtistSalesStatisticsNetSales.md) |  | [optional] 
**orders** | **Int64** | Orders in the window | [optional] 
**refunds** | [**ArtistSalesStatisticsRefunds**](ArtistSalesStatisticsRefunds.md) |  | [optional] 
**series** | [**ArtistSalesStatisticsSeries**](ArtistSalesStatisticsSeries.md) |  | [optional] 
**startDate** | **Date** | First day of the window | 
**status** | **String** | Status of sales statistics. NOT_SET_UP: the artist has not set up sales. UNAVAILABLE: not available at the moment | 
**windowPeriod** | [**ArtistStatisticsWindowPeriod**](ArtistStatisticsWindowPeriod.md) |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


