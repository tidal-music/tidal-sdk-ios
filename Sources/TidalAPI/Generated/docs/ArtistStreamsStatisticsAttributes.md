# ArtistStreamsStatisticsAttributes

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**breakdownsStatus** | **String** | Status of artist statistics that may be withheld. OK: the data is present. SUPPRESSED: withheld because too few people are counted to show it. UNAVAILABLE: not available at the moment | 
**dataThrough** | **Date** | Last day included in the underlying data | 
**endDate** | **Date** | Last day of the window, inclusive | 
**lastModifiedAt** | **Date** | When these statistics were computed | 
**listeners** | [**ArtistStreamsStatisticsCount**](ArtistStreamsStatisticsCount.md) |  | 
**newFollowers** | [**ArtistStreamsStatisticsCount**](ArtistStreamsStatisticsCount.md) |  | 
**plays** | [**ArtistStreamsStatisticsPlays**](ArtistStreamsStatisticsPlays.md) |  | 
**playsBySource** | [**ArtistStreamsStatisticsPlaysBySource**](ArtistStreamsStatisticsPlaysBySource.md) |  | [optional] 
**saves** | [**ArtistStreamsStatisticsCount**](ArtistStreamsStatisticsCount.md) |  | 
**series** | [**ArtistStreamsStatisticsSeries**](ArtistStreamsStatisticsSeries.md) |  | 
**startDate** | **Date** | First day of the window | 
**topCountries** | [**ArtistStreamsStatisticsTopCountries**](ArtistStreamsStatisticsTopCountries.md) |  | [optional] 
**windowPeriod** | [**ArtistStatisticsWindowPeriod**](ArtistStatisticsWindowPeriod.md) |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


