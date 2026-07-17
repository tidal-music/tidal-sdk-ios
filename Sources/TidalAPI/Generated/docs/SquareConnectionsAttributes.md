# SquareConnectionsAttributes

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**capabilities** | [SquareConnectionsCapability] | Per-feature capability statuses for this Square connection. Every capability the connection offers is listed with a status carrying more than mere presence: SITES is GRANTED when the Square Online sites scopes are granted, or REQUIRES_REAUTH when the connection exists but its credential lacks them (the seller must reconnect Square via POST /squareConnections). Because a connection always offers the sites feature, SITES is always present here. Extensible — only SITES is defined today. Absent only when the connection has no sites state (e.g. no approved Square credential). Client rule: if SITES !&#x3D; GRANTED prompt reconnect; else if selectedSite.data is null show the site picker; else the selected site is shown to buyers. | [optional] 
**createdAt** | **Date** | Timestamp when the connection was created | [optional] 
**externalLinks** | [ExternalLink] | External links for Square connection | [optional] 
**lastModifiedAt** | **Date** | Timestamp when the connection was last modified | [optional] 
**status** | **String** | Current status of this Square connection | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


