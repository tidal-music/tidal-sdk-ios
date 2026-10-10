# ViewerContextsAttributes

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**hasCommentedOn** | **AnyCodable** | The viewer has at least one existing comment on the subject; deleted historical comments do not count. Reserved; not currently populated and omitted from responses. Omission does not indicate that the relation is absent. | [optional] 
**hasInCollection** | **AnyCodable** | The viewer has the original subject in their normal collection. Present as an empty object when known present, otherwise omitted. Includes owned and saved playlists and saved mixes across folders; excludes Save for Later. | [optional] 
**hasPurchased** | **AnyCodable** | The viewer has a current qualifying purchase entitlement. Includes a track covered by its purchased album; excludes subscription access and free downloads. Reserved; not currently populated and omitted from responses. Omission does not indicate that the relation is absent. | [optional] 
**hasReactedTo** | [**Reaction**](Reaction.md) |  | [optional] 
**hasSavedForLater** | **AnyCodable** | The viewer has saved the subject for later. Reserved; not currently populated and omitted from responses. Omission does not indicate that the relation is absent. | [optional] 
**isFollowedBy** | **AnyCodable** | The viewer is followed by the subject. Reserved; not currently populated and omitted from responses. Omission does not indicate that the relation is absent. | [optional] 
**isFollowing** | **AnyCodable** | The viewer follows the subject. Reserved; not currently populated and omitted from responses. Omission does not indicate that the relation is absent. | [optional] 
**isGranteeOf** | [**Grantee**](Grantee.md) |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


