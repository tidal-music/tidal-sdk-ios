# Swift5 API client for OpenAPIClient

The TIDAL API is a [JSON:API](https://jsonapi.org/)-compliant web API exposing TIDAL's music catalogue, metadata, and user functionality. Guides, authorization documentation, and API key management live at [developer.tidal.com](https://developer.tidal.com).

All endpoints exchange `application/vnd.api+json` documents per the [JSON:API specification](https://jsonapi.org/format/): [resource objects](https://jsonapi.org/format/#document-resource-objects) with `attributes` and `relationships`, [compound documents](https://jsonapi.org/format/#document-compound-documents) via `include`, and standard [error objects](https://jsonapi.org/format/#error-objects).

### Authentication and authorization

Every request requires an OAuth 2.0 access token in the `Authorization: Bearer` header. Tokens are issued at `https://auth.tidal.com/v1/oauth2/token` via the client-credentials flow (server-to-server) or the authorization-code + PKCE flow (user context; authorize at `https://login.tidal.com/authorize`). Each endpoint documents which flows it accepts, the access tier it requires, and the scopes that apply. Scopes protect private user data: fields you are not authorized to read are redacted from the response rather than causing an error, and resources you cannot access at all behave as if they do not exist. See the [authorization guide](https://developer.tidal.com/documentation/api-sdk/api-sdk-authorization) for details.

### Working with responses

- **Enums** — new values can be added to any enum at any time. Treat unknown values as forward-compatible, not as errors.
- **IDs** are opaque strings. Never parse, construct, or infer meaning from them.
- **Formats** — dates, times and durations are ISO 8601 (`2024-05-01T12:00:00Z`, `PT3M5S`); countries ISO 3166-1 alpha-2; languages BCP 47; currencies ISO 4217; colors six-digit hex.

### Relationships and includes

[Relationships](https://jsonapi.org/format/#document-resource-object-relationships) are returned only on request: a resource's `relationships` object contains just the relationships named in [`include`](https://jsonapi.org/format/#fetching-includes) — a relationship that was not requested is absent from the response, not empty. The full set of relationships a resource supports is documented in its schema.

Request related resources in one round trip with `?include=`, a comma-separated list of dot-separated relationship paths — e.g. `include=coverArt,artists.profileArt` on an album. A nested path automatically embeds its intermediate resources: `artists.profileArt` includes the artists as well as their profile art. Include paths are always relative to the request's root resource, also on relationship endpoints. Including a relationship never changes the primary data; the related resources are added to `included`.

Include paths are validated: a path that cannot be resolved against the resources' documented relationships is rejected with `400`. Include trees are also bounded in path depth (default 3 levels) and in the total number of distinct resources they name (default 10); individual endpoints may apply different limits. A request exceeding either limit is rejected with `400`, with the effective limit stated in the error.

### Filtering, sorting, pagination

- [`filter[<member>]=value`](https://jsonapi.org/format/#fetching-filtering) filters collections; each endpoint documents its available filters, and most collections require at least one.
- [`sort=<member>`](https://jsonapi.org/format/#fetching-sorting) sorts ascending, `-<member>` descending (`sort=-addedAt`). Filter and sort members are relative to the resources being returned.
- Parameters an endpoint cannot honor are rejected with `400`: a `filter[...]` parameter the endpoint does not document (the error lists the available filters), or `sort` on an endpoint that documents no sort values.
- [Pagination](https://jsonapi.org/format/#fetching-pagination) is cursor-based: responses carry `links.self` and, while more pages exist, `links.next` with an opaque `page[cursor]`. Follow `next` until absent — there are no offset or total-page parameters. Collection sizes, when available, appear as `meta.total` and may be approximate.

### Type qualifiers

Where a relationship can contain several resource types, a path segment may be prefixed with a concrete type to scope which type's member is accessed. A playlist's `items` are `tracks` or `videos`: `GET /playlists/{id}?include=items.tracks:albums` resolves `albums` only for the items that are tracks. Qualifiers scope member access — they never filter which resources appear in a relationship — and can be chained.

The same syntax applies to `filter` and `sort` member paths on endpoints that support it; where supported, the qualified member is listed among the endpoint's documented filters and sort values. The syntax follows JSON:API proposal [json-api#1695](https://github.com/json-api/json-api/issues/1695).

### Mutations

- [Partial updates](https://jsonapi.org/format/#crud-updating-resource-attributes) distinguish three wire states for nullable attributes: omission leaves the current value unchanged, an explicit `null` clears it, and a concrete value updates it.
- Every mutation accepts an [`Idempotency-Key`](https://www.ietf.org/archive/id/draft-ietf-httpapi-idempotency-key-header-07.html) header. Once the original request has completed, retrying with the same key and payload within one hour replays its response; a retry while it is still processing is rejected with `409`, and the same key with a different payload with `422`.
- After a successful write, your own subsequent reads reflect the change; other clients may observe it with a delay.

### Media resource replacements - BETA Internal only

Media resources (`tracks`, `videos`, and `albums`) can become unavailable in a country when licensing rights change. By default, TIDAL API returns the resource identifiers originally stored in a collection. This keeps ordinary reads predictable and consistent.

If a stored media resource is unavailable for the effective country, TIDAL may identify a contextually applicable alternative that is available there. Replacement is best effort, so an alternative is not always available. Replacement never changes the stored collection.

TIDAL API provides two ways to work with replacements:

1. **Inspect the `replacement` relationship.** A media resource can expose its applicable alternative through the `replacement` relationship. Include this relationship when a client needs both the original and replacement identifiers or wants to decide whether to use the replacement.

2. **Apply replacements with `replaceMedia`.** Clients can use `replaceMedia` to substitute applicable replacements directly into selected relationship data. The parameter accepts relationship paths using the same syntax as `include`. Projection affects only the response and preserves relationship order and metadata. Each identifier includes `meta.replacement` describing whether it was `ORIGINAL`, `REPLACED`, or `NOT_REPLACED`.

For example, `GET /playlists/{id}?include=items&replaceMedia=items` applies replacements to media identifiers in the playlist's `items` relationship.

### Compression

Responses are gzip-compressed when the request includes `Accept-Encoding: gzip` (bodies over 2 KB).

### Deprecation

Deprecated endpoints, parameters, and fields are marked `deprecated` in this specification, with the replacement noted in their description. Deprecated functionality keeps working for at least six months after being marked, and is only removed once a replacement is generally available.

## Overview
This API client was generated by the [OpenAPI Generator](https://openapi-generator.tech) project.  By using the [openapi-spec](https://github.com/OAI/OpenAPI-Specification) from a remote server, you can easily generate an API client.

- API version: 1.10.101
- Package version: 
- Generator version: 7.24.0
- Build package: org.openapitools.codegen.languages.Swift5ClientCodegen
For more information, please visit [https://github.com/orgs/tidal-music/discussions](https://github.com/orgs/tidal-music/discussions)

## Installation

### Carthage

Run `carthage update`

### CocoaPods

Run `pod install`

## Documentation for API Endpoints

All URIs are relative to *https://openapi.tidal.com/v2*

Class | Method | HTTP request | Description
------------ | ------------- | ------------- | -------------
*AcceptedTermsAPI* | [**acceptedTermsGet**](docs/AcceptedTermsAPI.md#acceptedtermsget) | **GET** /acceptedTerms | Get multiple acceptedTerms.
*AcceptedTermsAPI* | [**acceptedTermsIdRelationshipsOwnersGet**](docs/AcceptedTermsAPI.md#acceptedtermsidrelationshipsownersget) | **GET** /acceptedTerms/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
*AcceptedTermsAPI* | [**acceptedTermsIdRelationshipsTermsGet**](docs/AcceptedTermsAPI.md#acceptedtermsidrelationshipstermsget) | **GET** /acceptedTerms/{id}/relationships/terms | Get terms relationship (\&quot;to-one\&quot;).
*AcceptedTermsAPI* | [**acceptedTermsPost**](docs/AcceptedTermsAPI.md#acceptedtermspost) | **POST** /acceptedTerms | Create single acceptedTerm.
*AlbumStatisticsAPI* | [**albumStatisticsIdGet**](docs/AlbumStatisticsAPI.md#albumstatisticsidget) | **GET** /albumStatistics/{id} | Get single albumStatistic.
*AlbumStatisticsAPI* | [**albumStatisticsIdRelationshipsOwnersGet**](docs/AlbumStatisticsAPI.md#albumstatisticsidrelationshipsownersget) | **GET** /albumStatistics/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
*AlbumsAPI* | [**albumsGet**](docs/AlbumsAPI.md#albumsget) | **GET** /albums | Get multiple albums.
*AlbumsAPI* | [**albumsIdDelete**](docs/AlbumsAPI.md#albumsiddelete) | **DELETE** /albums/{id} | Delete single album.
*AlbumsAPI* | [**albumsIdGet**](docs/AlbumsAPI.md#albumsidget) | **GET** /albums/{id} | Get single album.
*AlbumsAPI* | [**albumsIdPatch**](docs/AlbumsAPI.md#albumsidpatch) | **PATCH** /albums/{id} | Update single album.
*AlbumsAPI* | [**albumsIdRelationshipsAlbumStatisticsGet**](docs/AlbumsAPI.md#albumsidrelationshipsalbumstatisticsget) | **GET** /albums/{id}/relationships/albumStatistics | Get albumStatistics relationship (\&quot;to-one\&quot;).
*AlbumsAPI* | [**albumsIdRelationshipsArtistsGet**](docs/AlbumsAPI.md#albumsidrelationshipsartistsget) | **GET** /albums/{id}/relationships/artists | Get artists relationship (\&quot;to-many\&quot;).
*AlbumsAPI* | [**albumsIdRelationshipsCoverArtGet**](docs/AlbumsAPI.md#albumsidrelationshipscoverartget) | **GET** /albums/{id}/relationships/coverArt | Get coverArt relationship (\&quot;to-many\&quot;).
*AlbumsAPI* | [**albumsIdRelationshipsCoverArtPatch**](docs/AlbumsAPI.md#albumsidrelationshipscoverartpatch) | **PATCH** /albums/{id}/relationships/coverArt | Update coverArt relationship (\&quot;to-many\&quot;).
*AlbumsAPI* | [**albumsIdRelationshipsGenresGet**](docs/AlbumsAPI.md#albumsidrelationshipsgenresget) | **GET** /albums/{id}/relationships/genres | Get genres relationship (\&quot;to-many\&quot;).
*AlbumsAPI* | [**albumsIdRelationshipsItemsGet**](docs/AlbumsAPI.md#albumsidrelationshipsitemsget) | **GET** /albums/{id}/relationships/items | Get items relationship (\&quot;to-many\&quot;).
*AlbumsAPI* | [**albumsIdRelationshipsItemsPatch**](docs/AlbumsAPI.md#albumsidrelationshipsitemspatch) | **PATCH** /albums/{id}/relationships/items | Update items relationship (\&quot;to-many\&quot;).
*AlbumsAPI* | [**albumsIdRelationshipsOwnersGet**](docs/AlbumsAPI.md#albumsidrelationshipsownersget) | **GET** /albums/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
*AlbumsAPI* | [**albumsIdRelationshipsPriceConfigGet**](docs/AlbumsAPI.md#albumsidrelationshipspriceconfigget) | **GET** /albums/{id}/relationships/priceConfig | Get priceConfig relationship (\&quot;to-one\&quot;).
*AlbumsAPI* | [**albumsIdRelationshipsProvidersGet**](docs/AlbumsAPI.md#albumsidrelationshipsprovidersget) | **GET** /albums/{id}/relationships/providers | Get providers relationship (\&quot;to-many\&quot;).
*AlbumsAPI* | [**albumsIdRelationshipsReplacementGet**](docs/AlbumsAPI.md#albumsidrelationshipsreplacementget) | **GET** /albums/{id}/relationships/replacement | Get replacement relationship (\&quot;to-one\&quot;).
*AlbumsAPI* | [**albumsIdRelationshipsSharesGet**](docs/AlbumsAPI.md#albumsidrelationshipssharesget) | **GET** /albums/{id}/relationships/shares | Get shares relationship (\&quot;to-many\&quot;).
*AlbumsAPI* | [**albumsIdRelationshipsSimilarAlbumsGet**](docs/AlbumsAPI.md#albumsidrelationshipssimilaralbumsget) | **GET** /albums/{id}/relationships/similarAlbums | Get similarAlbums relationship (\&quot;to-many\&quot;).
*AlbumsAPI* | [**albumsIdRelationshipsSuggestedCoverArtsGet**](docs/AlbumsAPI.md#albumsidrelationshipssuggestedcoverartsget) | **GET** /albums/{id}/relationships/suggestedCoverArts | Get suggestedCoverArts relationship (\&quot;to-many\&quot;).
*AlbumsAPI* | [**albumsIdRelationshipsUsageRulesGet**](docs/AlbumsAPI.md#albumsidrelationshipsusagerulesget) | **GET** /albums/{id}/relationships/usageRules | Get usageRules relationship (\&quot;to-one\&quot;).
*AlbumsAPI* | [**albumsPost**](docs/AlbumsAPI.md#albumspost) | **POST** /albums | Create single album.
*AppreciationsAPI* | [**appreciationsPost**](docs/AppreciationsAPI.md#appreciationspost) | **POST** /appreciations | Create single appreciation.
*ArtistBiographiesAPI* | [**artistBiographiesIdGet**](docs/ArtistBiographiesAPI.md#artistbiographiesidget) | **GET** /artistBiographies/{id} | Get single artistBiographie.
*ArtistBiographiesAPI* | [**artistBiographiesIdPatch**](docs/ArtistBiographiesAPI.md#artistbiographiesidpatch) | **PATCH** /artistBiographies/{id} | Update single artistBiographie.
*ArtistBiographiesAPI* | [**artistBiographiesIdRelationshipsOwnersGet**](docs/ArtistBiographiesAPI.md#artistbiographiesidrelationshipsownersget) | **GET** /artistBiographies/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
*ArtistClaimStatusesAPI* | [**artistClaimStatusesGet**](docs/ArtistClaimStatusesAPI.md#artistclaimstatusesget) | **GET** /artistClaimStatuses | Get multiple artistClaimStatuses.
*ArtistClaimsAPI* | [**artistClaimsGet**](docs/ArtistClaimsAPI.md#artistclaimsget) | **GET** /artistClaims | Get multiple artistClaims.
*ArtistClaimsAPI* | [**artistClaimsIdDelete**](docs/ArtistClaimsAPI.md#artistclaimsiddelete) | **DELETE** /artistClaims/{id} | Delete single artistClaim.
*ArtistClaimsAPI* | [**artistClaimsIdGet**](docs/ArtistClaimsAPI.md#artistclaimsidget) | **GET** /artistClaims/{id} | Get single artistClaim.
*ArtistClaimsAPI* | [**artistClaimsIdPatch**](docs/ArtistClaimsAPI.md#artistclaimsidpatch) | **PATCH** /artistClaims/{id} | Update single artistClaim.
*ArtistClaimsAPI* | [**artistClaimsIdRelationshipsAcceptedArtistsGet**](docs/ArtistClaimsAPI.md#artistclaimsidrelationshipsacceptedartistsget) | **GET** /artistClaims/{id}/relationships/acceptedArtists | Get acceptedArtists relationship (\&quot;to-many\&quot;).
*ArtistClaimsAPI* | [**artistClaimsIdRelationshipsAcceptedArtistsPatch**](docs/ArtistClaimsAPI.md#artistclaimsidrelationshipsacceptedartistspatch) | **PATCH** /artistClaims/{id}/relationships/acceptedArtists | Update acceptedArtists relationship (\&quot;to-many\&quot;).
*ArtistClaimsAPI* | [**artistClaimsIdRelationshipsOwnersGet**](docs/ArtistClaimsAPI.md#artistclaimsidrelationshipsownersget) | **GET** /artistClaims/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
*ArtistClaimsAPI* | [**artistClaimsIdRelationshipsRecommendedArtistsGet**](docs/ArtistClaimsAPI.md#artistclaimsidrelationshipsrecommendedartistsget) | **GET** /artistClaims/{id}/relationships/recommendedArtists | Get recommendedArtists relationship (\&quot;to-many\&quot;).
*ArtistClaimsAPI* | [**artistClaimsPost**](docs/ArtistClaimsAPI.md#artistclaimspost) | **POST** /artistClaims | Create single artistClaim.
*ArtistRolesAPI* | [**artistRolesIdGet**](docs/ArtistRolesAPI.md#artistrolesidget) | **GET** /artistRoles/{id} | Get single artistRole.
*ArtistsAPI* | [**artistsGet**](docs/ArtistsAPI.md#artistsget) | **GET** /artists | Get multiple artists.
*ArtistsAPI* | [**artistsIdGet**](docs/ArtistsAPI.md#artistsidget) | **GET** /artists/{id} | Get single artist.
*ArtistsAPI* | [**artistsIdPatch**](docs/ArtistsAPI.md#artistsidpatch) | **PATCH** /artists/{id} | Update single artist.
*ArtistsAPI* | [**artistsIdRelationshipsAlbumsGet**](docs/ArtistsAPI.md#artistsidrelationshipsalbumsget) | **GET** /artists/{id}/relationships/albums | Get albums relationship (\&quot;to-many\&quot;).
*ArtistsAPI* | [**artistsIdRelationshipsBiographyGet**](docs/ArtistsAPI.md#artistsidrelationshipsbiographyget) | **GET** /artists/{id}/relationships/biography | Get biography relationship (\&quot;to-one\&quot;).
*ArtistsAPI* | [**artistsIdRelationshipsClaimStatusGet**](docs/ArtistsAPI.md#artistsidrelationshipsclaimstatusget) | **GET** /artists/{id}/relationships/claimStatus | Get claimStatus relationship (\&quot;to-one\&quot;).
*ArtistsAPI* | [**artistsIdRelationshipsFollowersGet**](docs/ArtistsAPI.md#artistsidrelationshipsfollowersget) | **GET** /artists/{id}/relationships/followers | Get followers relationship (\&quot;to-many\&quot;).
*ArtistsAPI* | [**artistsIdRelationshipsFollowingDelete**](docs/ArtistsAPI.md#artistsidrelationshipsfollowingdelete) | **DELETE** /artists/{id}/relationships/following | Delete from following relationship (\&quot;to-many\&quot;).
*ArtistsAPI* | [**artistsIdRelationshipsFollowingGet**](docs/ArtistsAPI.md#artistsidrelationshipsfollowingget) | **GET** /artists/{id}/relationships/following | Get following relationship (\&quot;to-many\&quot;).
*ArtistsAPI* | [**artistsIdRelationshipsFollowingPost**](docs/ArtistsAPI.md#artistsidrelationshipsfollowingpost) | **POST** /artists/{id}/relationships/following | Add to following relationship (\&quot;to-many\&quot;).
*ArtistsAPI* | [**artistsIdRelationshipsOwnersGet**](docs/ArtistsAPI.md#artistsidrelationshipsownersget) | **GET** /artists/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
*ArtistsAPI* | [**artistsIdRelationshipsProfileArtGet**](docs/ArtistsAPI.md#artistsidrelationshipsprofileartget) | **GET** /artists/{id}/relationships/profileArt | Get profileArt relationship (\&quot;to-many\&quot;).
*ArtistsAPI* | [**artistsIdRelationshipsProfileArtPatch**](docs/ArtistsAPI.md#artistsidrelationshipsprofileartpatch) | **PATCH** /artists/{id}/relationships/profileArt | Update profileArt relationship (\&quot;to-many\&quot;).
*ArtistsAPI* | [**artistsIdRelationshipsRadioGet**](docs/ArtistsAPI.md#artistsidrelationshipsradioget) | **GET** /artists/{id}/relationships/radio | Get radio relationship (\&quot;to-many\&quot;).
*ArtistsAPI* | [**artistsIdRelationshipsRolesGet**](docs/ArtistsAPI.md#artistsidrelationshipsrolesget) | **GET** /artists/{id}/relationships/roles | Get roles relationship (\&quot;to-many\&quot;).
*ArtistsAPI* | [**artistsIdRelationshipsSimilarArtistsGet**](docs/ArtistsAPI.md#artistsidrelationshipssimilarartistsget) | **GET** /artists/{id}/relationships/similarArtists | Get similarArtists relationship (\&quot;to-many\&quot;).
*ArtistsAPI* | [**artistsIdRelationshipsTrackProvidersGet**](docs/ArtistsAPI.md#artistsidrelationshipstrackprovidersget) | **GET** /artists/{id}/relationships/trackProviders | Get trackProviders relationship (\&quot;to-many\&quot;).
*ArtistsAPI* | [**artistsIdRelationshipsTracksGet**](docs/ArtistsAPI.md#artistsidrelationshipstracksget) | **GET** /artists/{id}/relationships/tracks | Get tracks relationship (\&quot;to-many\&quot;).
*ArtistsAPI* | [**artistsIdRelationshipsVideosGet**](docs/ArtistsAPI.md#artistsidrelationshipsvideosget) | **GET** /artists/{id}/relationships/videos | Get videos relationship (\&quot;to-many\&quot;).
*ArtistsAPI* | [**artistsPost**](docs/ArtistsAPI.md#artistspost) | **POST** /artists | Create single artist.
*ArtworksAPI* | [**artworksGet**](docs/ArtworksAPI.md#artworksget) | **GET** /artworks | Get multiple artworks.
*ArtworksAPI* | [**artworksIdGet**](docs/ArtworksAPI.md#artworksidget) | **GET** /artworks/{id} | Get single artwork.
*ArtworksAPI* | [**artworksIdRelationshipsOwnersGet**](docs/ArtworksAPI.md#artworksidrelationshipsownersget) | **GET** /artworks/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
*ArtworksAPI* | [**artworksPost**](docs/ArtworksAPI.md#artworkspost) | **POST** /artworks | Create single artwork.
*ClientsAPI* | [**clientsGet**](docs/ClientsAPI.md#clientsget) | **GET** /clients | Get multiple clients.
*ClientsAPI* | [**clientsIdDelete**](docs/ClientsAPI.md#clientsiddelete) | **DELETE** /clients/{id} | Delete single client.
*ClientsAPI* | [**clientsIdGet**](docs/ClientsAPI.md#clientsidget) | **GET** /clients/{id} | Get single client.
*ClientsAPI* | [**clientsIdPatch**](docs/ClientsAPI.md#clientsidpatch) | **PATCH** /clients/{id} | Update single client.
*ClientsAPI* | [**clientsIdRelationshipsOwnersGet**](docs/ClientsAPI.md#clientsidrelationshipsownersget) | **GET** /clients/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
*ClientsAPI* | [**clientsPost**](docs/ClientsAPI.md#clientspost) | **POST** /clients | Create single client.
*CollaborationInviteRedemptionsAPI* | [**collaborationInviteRedemptionsPost**](docs/CollaborationInviteRedemptionsAPI.md#collaborationinviteredemptionspost) | **POST** /collaborationInviteRedemptions | Create single collaborationInviteRedemption.
*CollaborationInvitesAPI* | [**collaborationInvitesGet**](docs/CollaborationInvitesAPI.md#collaborationinvitesget) | **GET** /collaborationInvites | Get multiple collaborationInvites.
*CollaborationInvitesAPI* | [**collaborationInvitesIdDelete**](docs/CollaborationInvitesAPI.md#collaborationinvitesiddelete) | **DELETE** /collaborationInvites/{id} | Delete single collaborationInvite.
*CollaborationInvitesAPI* | [**collaborationInvitesIdGet**](docs/CollaborationInvitesAPI.md#collaborationinvitesidget) | **GET** /collaborationInvites/{id} | Get single collaborationInvite.
*CollaborationInvitesAPI* | [**collaborationInvitesIdRelationshipsOwnersGet**](docs/CollaborationInvitesAPI.md#collaborationinvitesidrelationshipsownersget) | **GET** /collaborationInvites/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
*CollaborationInvitesAPI* | [**collaborationInvitesIdRelationshipsSubjectGet**](docs/CollaborationInvitesAPI.md#collaborationinvitesidrelationshipssubjectget) | **GET** /collaborationInvites/{id}/relationships/subject | Get subject relationship (\&quot;to-one\&quot;).
*CollaborationInvitesAPI* | [**collaborationInvitesPost**](docs/CollaborationInvitesAPI.md#collaborationinvitespost) | **POST** /collaborationInvites | Create single collaborationInvite.
*CommentsAPI* | [**commentsGet**](docs/CommentsAPI.md#commentsget) | **GET** /comments | Get multiple comments.
*CommentsAPI* | [**commentsIdDelete**](docs/CommentsAPI.md#commentsiddelete) | **DELETE** /comments/{id} | Delete single comment.
*CommentsAPI* | [**commentsIdGet**](docs/CommentsAPI.md#commentsidget) | **GET** /comments/{id} | Get single comment.
*CommentsAPI* | [**commentsIdPatch**](docs/CommentsAPI.md#commentsidpatch) | **PATCH** /comments/{id} | Update single comment.
*CommentsAPI* | [**commentsIdRelationshipsOwnerProfilesGet**](docs/CommentsAPI.md#commentsidrelationshipsownerprofilesget) | **GET** /comments/{id}/relationships/ownerProfiles | Get ownerProfiles relationship (\&quot;to-many\&quot;).
*CommentsAPI* | [**commentsIdRelationshipsOwnersGet**](docs/CommentsAPI.md#commentsidrelationshipsownersget) | **GET** /comments/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
*CommentsAPI* | [**commentsIdRelationshipsParentCommentGet**](docs/CommentsAPI.md#commentsidrelationshipsparentcommentget) | **GET** /comments/{id}/relationships/parentComment | Get parentComment relationship (\&quot;to-one\&quot;).
*CommentsAPI* | [**commentsPost**](docs/CommentsAPI.md#commentspost) | **POST** /comments | Create single comment.
*ContentClaimsAPI* | [**contentClaimsGet**](docs/ContentClaimsAPI.md#contentclaimsget) | **GET** /contentClaims | Get multiple contentClaims.
*ContentClaimsAPI* | [**contentClaimsIdGet**](docs/ContentClaimsAPI.md#contentclaimsidget) | **GET** /contentClaims/{id} | Get single contentClaim.
*ContentClaimsAPI* | [**contentClaimsIdRelationshipsClaimedResourceGet**](docs/ContentClaimsAPI.md#contentclaimsidrelationshipsclaimedresourceget) | **GET** /contentClaims/{id}/relationships/claimedResource | Get claimedResource relationship (\&quot;to-one\&quot;).
*ContentClaimsAPI* | [**contentClaimsIdRelationshipsClaimingArtistGet**](docs/ContentClaimsAPI.md#contentclaimsidrelationshipsclaimingartistget) | **GET** /contentClaims/{id}/relationships/claimingArtist | Get claimingArtist relationship (\&quot;to-one\&quot;).
*ContentClaimsAPI* | [**contentClaimsIdRelationshipsOwnersGet**](docs/ContentClaimsAPI.md#contentclaimsidrelationshipsownersget) | **GET** /contentClaims/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
*ContentClaimsAPI* | [**contentClaimsPost**](docs/ContentClaimsAPI.md#contentclaimspost) | **POST** /contentClaims | Create single contentClaim.
*CreditsAPI* | [**creditsIdGet**](docs/CreditsAPI.md#creditsidget) | **GET** /credits/{id} | Get single credit.
*CreditsAPI* | [**creditsIdRelationshipsArtistGet**](docs/CreditsAPI.md#creditsidrelationshipsartistget) | **GET** /credits/{id}/relationships/artist | Get artist relationship (\&quot;to-one\&quot;).
*CreditsAPI* | [**creditsIdRelationshipsCategoryGet**](docs/CreditsAPI.md#creditsidrelationshipscategoryget) | **GET** /credits/{id}/relationships/category | Get category relationship (\&quot;to-one\&quot;).
*DownloadsAPI* | [**downloadsGet**](docs/DownloadsAPI.md#downloadsget) | **GET** /downloads | Get multiple downloads.
*DownloadsAPI* | [**downloadsIdGet**](docs/DownloadsAPI.md#downloadsidget) | **GET** /downloads/{id} | Get single download.
*DownloadsAPI* | [**downloadsIdRelationshipsOwnersGet**](docs/DownloadsAPI.md#downloadsidrelationshipsownersget) | **GET** /downloads/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
*DspSharingLinksAPI* | [**dspSharingLinksGet**](docs/DspSharingLinksAPI.md#dspsharinglinksget) | **GET** /dspSharingLinks | Get multiple dspSharingLinks.
*DspSharingLinksAPI* | [**dspSharingLinksIdRelationshipsSubjectGet**](docs/DspSharingLinksAPI.md#dspsharinglinksidrelationshipssubjectget) | **GET** /dspSharingLinks/{id}/relationships/subject | Get subject relationship (\&quot;to-one\&quot;).
*DynamicModulesAPI* | [**dynamicModulesGet**](docs/DynamicModulesAPI.md#dynamicmodulesget) | **GET** /dynamicModules | Get multiple dynamicModules.
*DynamicModulesAPI* | [**dynamicModulesIdGet**](docs/DynamicModulesAPI.md#dynamicmodulesidget) | **GET** /dynamicModules/{id} | Get single dynamicModule.
*DynamicModulesAPI* | [**dynamicModulesIdRelationshipsItemsGet**](docs/DynamicModulesAPI.md#dynamicmodulesidrelationshipsitemsget) | **GET** /dynamicModules/{id}/relationships/items | Get items relationship (\&quot;to-many\&quot;).
*DynamicModulesAPI* | [**dynamicModulesIdRelationshipsSeedItemGet**](docs/DynamicModulesAPI.md#dynamicmodulesidrelationshipsseeditemget) | **GET** /dynamicModules/{id}/relationships/seedItem | Get seedItem relationship (\&quot;to-one\&quot;).
*DynamicPagesAPI* | [**dynamicPagesGet**](docs/DynamicPagesAPI.md#dynamicpagesget) | **GET** /dynamicPages | Get multiple dynamicPages.
*DynamicPagesAPI* | [**dynamicPagesIdRelationshipsModulesGet**](docs/DynamicPagesAPI.md#dynamicpagesidrelationshipsmodulesget) | **GET** /dynamicPages/{id}/relationships/modules | Get modules relationship (\&quot;to-many\&quot;).
*DynamicPagesAPI* | [**dynamicPagesIdRelationshipsSubjectGet**](docs/DynamicPagesAPI.md#dynamicpagesidrelationshipssubjectget) | **GET** /dynamicPages/{id}/relationships/subject | Get subject relationship (\&quot;to-one\&quot;).
*GenresAPI* | [**genresGet**](docs/GenresAPI.md#genresget) | **GET** /genres | Get multiple genres.
*GenresAPI* | [**genresIdGet**](docs/GenresAPI.md#genresidget) | **GET** /genres/{id} | Get single genre.
*InstallationsAPI* | [**installationsGet**](docs/InstallationsAPI.md#installationsget) | **GET** /installations | Get multiple installations.
*InstallationsAPI* | [**installationsIdGet**](docs/InstallationsAPI.md#installationsidget) | **GET** /installations/{id} | Get single installation.
*InstallationsAPI* | [**installationsIdRelationshipsOfflineInventoryDelete**](docs/InstallationsAPI.md#installationsidrelationshipsofflineinventorydelete) | **DELETE** /installations/{id}/relationships/offlineInventory | Delete from offlineInventory relationship (\&quot;to-many\&quot;).
*InstallationsAPI* | [**installationsIdRelationshipsOfflineInventoryGet**](docs/InstallationsAPI.md#installationsidrelationshipsofflineinventoryget) | **GET** /installations/{id}/relationships/offlineInventory | Get offlineInventory relationship (\&quot;to-many\&quot;).
*InstallationsAPI* | [**installationsIdRelationshipsOfflineInventoryPost**](docs/InstallationsAPI.md#installationsidrelationshipsofflineinventorypost) | **POST** /installations/{id}/relationships/offlineInventory | Add to offlineInventory relationship (\&quot;to-many\&quot;).
*InstallationsAPI* | [**installationsIdRelationshipsOwnersGet**](docs/InstallationsAPI.md#installationsidrelationshipsownersget) | **GET** /installations/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
*InstallationsAPI* | [**installationsPost**](docs/InstallationsAPI.md#installationspost) | **POST** /installations | Create single installation.
*LyricsAPI* | [**lyricsIdDelete**](docs/LyricsAPI.md#lyricsiddelete) | **DELETE** /lyrics/{id} | Delete single lyric.
*LyricsAPI* | [**lyricsIdGet**](docs/LyricsAPI.md#lyricsidget) | **GET** /lyrics/{id} | Get single lyric.
*LyricsAPI* | [**lyricsIdPatch**](docs/LyricsAPI.md#lyricsidpatch) | **PATCH** /lyrics/{id} | Update single lyric.
*LyricsAPI* | [**lyricsIdRelationshipsOwnersGet**](docs/LyricsAPI.md#lyricsidrelationshipsownersget) | **GET** /lyrics/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
*LyricsAPI* | [**lyricsIdRelationshipsTrackGet**](docs/LyricsAPI.md#lyricsidrelationshipstrackget) | **GET** /lyrics/{id}/relationships/track | Get track relationship (\&quot;to-one\&quot;).
*LyricsAPI* | [**lyricsPost**](docs/LyricsAPI.md#lyricspost) | **POST** /lyrics | Create single lyric.
*ManualArtistClaimsAPI* | [**manualArtistClaimsPost**](docs/ManualArtistClaimsAPI.md#manualartistclaimspost) | **POST** /manualArtistClaims | Create single manualArtistClaim.
*OfflineTasksAPI* | [**offlineTasksGet**](docs/OfflineTasksAPI.md#offlinetasksget) | **GET** /offlineTasks | Get multiple offlineTasks.
*OfflineTasksAPI* | [**offlineTasksIdGet**](docs/OfflineTasksAPI.md#offlinetasksidget) | **GET** /offlineTasks/{id} | Get single offlineTask.
*OfflineTasksAPI* | [**offlineTasksIdPatch**](docs/OfflineTasksAPI.md#offlinetasksidpatch) | **PATCH** /offlineTasks/{id} | Update single offlineTask.
*OfflineTasksAPI* | [**offlineTasksIdRelationshipsCollectionGet**](docs/OfflineTasksAPI.md#offlinetasksidrelationshipscollectionget) | **GET** /offlineTasks/{id}/relationships/collection | Get collection relationship (\&quot;to-one\&quot;).
*OfflineTasksAPI* | [**offlineTasksIdRelationshipsItemGet**](docs/OfflineTasksAPI.md#offlinetasksidrelationshipsitemget) | **GET** /offlineTasks/{id}/relationships/item | Get item relationship (\&quot;to-one\&quot;).
*OfflineTasksAPI* | [**offlineTasksIdRelationshipsOwnersGet**](docs/OfflineTasksAPI.md#offlinetasksidrelationshipsownersget) | **GET** /offlineTasks/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
*PlayQueuesAPI* | [**playQueuesGet**](docs/PlayQueuesAPI.md#playqueuesget) | **GET** /playQueues | Get multiple playQueues.
*PlayQueuesAPI* | [**playQueuesIdDelete**](docs/PlayQueuesAPI.md#playqueuesiddelete) | **DELETE** /playQueues/{id} | Delete single playQueue.
*PlayQueuesAPI* | [**playQueuesIdGet**](docs/PlayQueuesAPI.md#playqueuesidget) | **GET** /playQueues/{id} | Get single playQueue.
*PlayQueuesAPI* | [**playQueuesIdPatch**](docs/PlayQueuesAPI.md#playqueuesidpatch) | **PATCH** /playQueues/{id} | Update single playQueue.
*PlayQueuesAPI* | [**playQueuesIdRelationshipsCurrentGet**](docs/PlayQueuesAPI.md#playqueuesidrelationshipscurrentget) | **GET** /playQueues/{id}/relationships/current | Get current relationship (\&quot;to-one\&quot;).
*PlayQueuesAPI* | [**playQueuesIdRelationshipsCurrentPatch**](docs/PlayQueuesAPI.md#playqueuesidrelationshipscurrentpatch) | **PATCH** /playQueues/{id}/relationships/current | Update current relationship (\&quot;to-one\&quot;).
*PlayQueuesAPI* | [**playQueuesIdRelationshipsFutureDelete**](docs/PlayQueuesAPI.md#playqueuesidrelationshipsfuturedelete) | **DELETE** /playQueues/{id}/relationships/future | Delete from future relationship (\&quot;to-many\&quot;).
*PlayQueuesAPI* | [**playQueuesIdRelationshipsFutureGet**](docs/PlayQueuesAPI.md#playqueuesidrelationshipsfutureget) | **GET** /playQueues/{id}/relationships/future | Get future relationship (\&quot;to-many\&quot;).
*PlayQueuesAPI* | [**playQueuesIdRelationshipsFuturePatch**](docs/PlayQueuesAPI.md#playqueuesidrelationshipsfuturepatch) | **PATCH** /playQueues/{id}/relationships/future | Update future relationship (\&quot;to-many\&quot;).
*PlayQueuesAPI* | [**playQueuesIdRelationshipsFuturePost**](docs/PlayQueuesAPI.md#playqueuesidrelationshipsfuturepost) | **POST** /playQueues/{id}/relationships/future | Add to future relationship (\&quot;to-many\&quot;).
*PlayQueuesAPI* | [**playQueuesIdRelationshipsOwnersGet**](docs/PlayQueuesAPI.md#playqueuesidrelationshipsownersget) | **GET** /playQueues/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
*PlayQueuesAPI* | [**playQueuesIdRelationshipsPastGet**](docs/PlayQueuesAPI.md#playqueuesidrelationshipspastget) | **GET** /playQueues/{id}/relationships/past | Get past relationship (\&quot;to-many\&quot;).
*PlayQueuesAPI* | [**playQueuesPost**](docs/PlayQueuesAPI.md#playqueuespost) | **POST** /playQueues | Create single playQueue.
*PlaylistsAPI* | [**playlistsGet**](docs/PlaylistsAPI.md#playlistsget) | **GET** /playlists | Get multiple playlists.
*PlaylistsAPI* | [**playlistsIdDelete**](docs/PlaylistsAPI.md#playlistsiddelete) | **DELETE** /playlists/{id} | Delete single playlist.
*PlaylistsAPI* | [**playlistsIdGet**](docs/PlaylistsAPI.md#playlistsidget) | **GET** /playlists/{id} | Get single playlist.
*PlaylistsAPI* | [**playlistsIdPatch**](docs/PlaylistsAPI.md#playlistsidpatch) | **PATCH** /playlists/{id} | Update single playlist.
*PlaylistsAPI* | [**playlistsIdRelationshipsCollaboratorProfilesDelete**](docs/PlaylistsAPI.md#playlistsidrelationshipscollaboratorprofilesdelete) | **DELETE** /playlists/{id}/relationships/collaboratorProfiles | Delete from collaboratorProfiles relationship (\&quot;to-many\&quot;).
*PlaylistsAPI* | [**playlistsIdRelationshipsCollaboratorProfilesGet**](docs/PlaylistsAPI.md#playlistsidrelationshipscollaboratorprofilesget) | **GET** /playlists/{id}/relationships/collaboratorProfiles | Get collaboratorProfiles relationship (\&quot;to-many\&quot;).
*PlaylistsAPI* | [**playlistsIdRelationshipsCollaboratorProfilesPost**](docs/PlaylistsAPI.md#playlistsidrelationshipscollaboratorprofilespost) | **POST** /playlists/{id}/relationships/collaboratorProfiles | Add to collaboratorProfiles relationship (\&quot;to-many\&quot;).
*PlaylistsAPI* | [**playlistsIdRelationshipsCollaboratorsGet**](docs/PlaylistsAPI.md#playlistsidrelationshipscollaboratorsget) | **GET** /playlists/{id}/relationships/collaborators | Get collaborators relationship (\&quot;to-many\&quot;).
*PlaylistsAPI* | [**playlistsIdRelationshipsCoverArtGet**](docs/PlaylistsAPI.md#playlistsidrelationshipscoverartget) | **GET** /playlists/{id}/relationships/coverArt | Get coverArt relationship (\&quot;to-many\&quot;).
*PlaylistsAPI* | [**playlistsIdRelationshipsCoverArtPatch**](docs/PlaylistsAPI.md#playlistsidrelationshipscoverartpatch) | **PATCH** /playlists/{id}/relationships/coverArt | Update coverArt relationship (\&quot;to-many\&quot;).
*PlaylistsAPI* | [**playlistsIdRelationshipsItemsDelete**](docs/PlaylistsAPI.md#playlistsidrelationshipsitemsdelete) | **DELETE** /playlists/{id}/relationships/items | Delete from items relationship (\&quot;to-many\&quot;).
*PlaylistsAPI* | [**playlistsIdRelationshipsItemsGet**](docs/PlaylistsAPI.md#playlistsidrelationshipsitemsget) | **GET** /playlists/{id}/relationships/items | Get items relationship (\&quot;to-many\&quot;).
*PlaylistsAPI* | [**playlistsIdRelationshipsItemsPatch**](docs/PlaylistsAPI.md#playlistsidrelationshipsitemspatch) | **PATCH** /playlists/{id}/relationships/items | Update items relationship (\&quot;to-many\&quot;).
*PlaylistsAPI* | [**playlistsIdRelationshipsItemsPost**](docs/PlaylistsAPI.md#playlistsidrelationshipsitemspost) | **POST** /playlists/{id}/relationships/items | Add to items relationship (\&quot;to-many\&quot;).
*PlaylistsAPI* | [**playlistsIdRelationshipsOwnerProfilesGet**](docs/PlaylistsAPI.md#playlistsidrelationshipsownerprofilesget) | **GET** /playlists/{id}/relationships/ownerProfiles | Get ownerProfiles relationship (\&quot;to-many\&quot;).
*PlaylistsAPI* | [**playlistsIdRelationshipsOwnersGet**](docs/PlaylistsAPI.md#playlistsidrelationshipsownersget) | **GET** /playlists/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
*PlaylistsAPI* | [**playlistsIdRelationshipsSuggestedCoverArtsGet**](docs/PlaylistsAPI.md#playlistsidrelationshipssuggestedcoverartsget) | **GET** /playlists/{id}/relationships/suggestedCoverArts | Get suggestedCoverArts relationship (\&quot;to-many\&quot;).
*PlaylistsAPI* | [**playlistsPost**](docs/PlaylistsAPI.md#playlistspost) | **POST** /playlists | Create single playlist.
*PriceConfigurationsAPI* | [**priceConfigurationsGet**](docs/PriceConfigurationsAPI.md#priceconfigurationsget) | **GET** /priceConfigurations | Get multiple priceConfigurations.
*PriceConfigurationsAPI* | [**priceConfigurationsIdGet**](docs/PriceConfigurationsAPI.md#priceconfigurationsidget) | **GET** /priceConfigurations/{id} | Get single priceConfiguration.
*PriceConfigurationsAPI* | [**priceConfigurationsPost**](docs/PriceConfigurationsAPI.md#priceconfigurationspost) | **POST** /priceConfigurations | Create single priceConfiguration.
*ProviderOwnersAPI* | [**providerOwnersGet**](docs/ProviderOwnersAPI.md#providerownersget) | **GET** /providerOwners | Get multiple providerOwners.
*ProviderOwnersAPI* | [**providerOwnersIdRelationshipsOwnersGet**](docs/ProviderOwnersAPI.md#providerownersidrelationshipsownersget) | **GET** /providerOwners/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
*ProviderOwnersAPI* | [**providerOwnersIdRelationshipsProviderGet**](docs/ProviderOwnersAPI.md#providerownersidrelationshipsproviderget) | **GET** /providerOwners/{id}/relationships/provider | Get provider relationship (\&quot;to-one\&quot;).
*ProviderProductInfosAPI* | [**providerProductInfosGet**](docs/ProviderProductInfosAPI.md#providerproductinfosget) | **GET** /providerProductInfos | Get multiple providerProductInfos.
*ProviderProductInfosAPI* | [**providerProductInfosIdRelationshipsProviderGet**](docs/ProviderProductInfosAPI.md#providerproductinfosidrelationshipsproviderget) | **GET** /providerProductInfos/{id}/relationships/provider | Get provider relationship (\&quot;to-one\&quot;).
*ProviderProductInfosAPI* | [**providerProductInfosIdRelationshipsSubjectGet**](docs/ProviderProductInfosAPI.md#providerproductinfosidrelationshipssubjectget) | **GET** /providerProductInfos/{id}/relationships/subject | Get subject relationship (\&quot;to-one\&quot;).
*ProvidersAPI* | [**providersIdGet**](docs/ProvidersAPI.md#providersidget) | **GET** /providers/{id} | Get single provider.
*PurchasesAPI* | [**purchasesGet**](docs/PurchasesAPI.md#purchasesget) | **GET** /purchases | Get multiple purchases.
*PurchasesAPI* | [**purchasesIdRelationshipsOwnersGet**](docs/PurchasesAPI.md#purchasesidrelationshipsownersget) | **GET** /purchases/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
*PurchasesAPI* | [**purchasesIdRelationshipsSubjectGet**](docs/PurchasesAPI.md#purchasesidrelationshipssubjectget) | **GET** /purchases/{id}/relationships/subject | Get subject relationship (\&quot;to-one\&quot;).
*ReactionsAPI* | [**reactionsGet**](docs/ReactionsAPI.md#reactionsget) | **GET** /reactions | Get multiple reactions.
*ReactionsAPI* | [**reactionsIdDelete**](docs/ReactionsAPI.md#reactionsiddelete) | **DELETE** /reactions/{id} | Delete single reaction.
*ReactionsAPI* | [**reactionsIdRelationshipsOwnerProfilesGet**](docs/ReactionsAPI.md#reactionsidrelationshipsownerprofilesget) | **GET** /reactions/{id}/relationships/ownerProfiles | Get ownerProfiles relationship (\&quot;to-many\&quot;).
*ReactionsAPI* | [**reactionsIdRelationshipsOwnersGet**](docs/ReactionsAPI.md#reactionsidrelationshipsownersget) | **GET** /reactions/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
*ReactionsAPI* | [**reactionsPost**](docs/ReactionsAPI.md#reactionspost) | **POST** /reactions | Create single reaction.
*SavedSharesAPI* | [**savedSharesPost**](docs/SavedSharesAPI.md#savedsharespost) | **POST** /savedShares | Create single savedShare.
*ScopesAPI* | [**scopesGet**](docs/ScopesAPI.md#scopesget) | **GET** /scopes | Get multiple scopes.
*SearchHistoryEntriesAPI* | [**searchHistoryEntriesIdDelete**](docs/SearchHistoryEntriesAPI.md#searchhistoryentriesiddelete) | **DELETE** /searchHistoryEntries/{id} | Delete single searchHistoryEntrie.
*SearchResultsAPI* | [**searchResultsGet**](docs/SearchResultsAPI.md#searchresultsget) | **GET** /searchResults | Get search results by query.
*SearchResultsAPI* | [**searchResultsIdRelationshipsAlbumsGet**](docs/SearchResultsAPI.md#searchresultsidrelationshipsalbumsget) | **GET** /searchResults/{id}/relationships/albums | Get albums relationship (\&quot;to-many\&quot;).
*SearchResultsAPI* | [**searchResultsIdRelationshipsArtistsGet**](docs/SearchResultsAPI.md#searchresultsidrelationshipsartistsget) | **GET** /searchResults/{id}/relationships/artists | Get artists relationship (\&quot;to-many\&quot;).
*SearchResultsAPI* | [**searchResultsIdRelationshipsPlaylistsGet**](docs/SearchResultsAPI.md#searchresultsidrelationshipsplaylistsget) | **GET** /searchResults/{id}/relationships/playlists | Get playlists relationship (\&quot;to-many\&quot;).
*SearchResultsAPI* | [**searchResultsIdRelationshipsTopHitsGet**](docs/SearchResultsAPI.md#searchresultsidrelationshipstophitsget) | **GET** /searchResults/{id}/relationships/topHits | Get topHits relationship (\&quot;to-many\&quot;).
*SearchResultsAPI* | [**searchResultsIdRelationshipsTracksGet**](docs/SearchResultsAPI.md#searchresultsidrelationshipstracksget) | **GET** /searchResults/{id}/relationships/tracks | Get tracks relationship (\&quot;to-many\&quot;).
*SearchResultsAPI* | [**searchResultsIdRelationshipsVideosGet**](docs/SearchResultsAPI.md#searchresultsidrelationshipsvideosget) | **GET** /searchResults/{id}/relationships/videos | Get videos relationship (\&quot;to-many\&quot;).
*SearchSuggestionsAPI* | [**searchSuggestionsGet**](docs/SearchSuggestionsAPI.md#searchsuggestionsget) | **GET** /searchSuggestions | Get search suggestions by query.
*SearchSuggestionsAPI* | [**searchSuggestionsIdRelationshipsDirectHitsGet**](docs/SearchSuggestionsAPI.md#searchsuggestionsidrelationshipsdirecthitsget) | **GET** /searchSuggestions/{id}/relationships/directHits | Get directHits relationship (\&quot;to-many\&quot;).
*SearchSuggestionsAPI* | [**searchSuggestionsIdRelationshipsHistoryGet**](docs/SearchSuggestionsAPI.md#searchsuggestionsidrelationshipshistoryget) | **GET** /searchSuggestions/{id}/relationships/history | Get history relationship (\&quot;to-many\&quot;).
*SharesAPI* | [**sharesGet**](docs/SharesAPI.md#sharesget) | **GET** /shares | Get multiple shares.
*SharesAPI* | [**sharesIdGet**](docs/SharesAPI.md#sharesidget) | **GET** /shares/{id} | Get single share.
*SharesAPI* | [**sharesIdRelationshipsOwnersGet**](docs/SharesAPI.md#sharesidrelationshipsownersget) | **GET** /shares/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
*SharesAPI* | [**sharesIdRelationshipsSharedResourcesGet**](docs/SharesAPI.md#sharesidrelationshipssharedresourcesget) | **GET** /shares/{id}/relationships/sharedResources | Get sharedResources relationship (\&quot;to-many\&quot;).
*SharesAPI* | [**sharesPost**](docs/SharesAPI.md#sharespost) | **POST** /shares | Create single share.
*SquareConnectionsAPI* | [**squareConnectionsIdGet**](docs/SquareConnectionsAPI.md#squareconnectionsidget) | **GET** /squareConnections/{id} | Get single squareConnection.
*SquareConnectionsAPI* | [**squareConnectionsIdRelationshipsSelectedSiteGet**](docs/SquareConnectionsAPI.md#squareconnectionsidrelationshipsselectedsiteget) | **GET** /squareConnections/{id}/relationships/selectedSite | Get selectedSite relationship (\&quot;to-one\&quot;).
*SquareConnectionsAPI* | [**squareConnectionsIdRelationshipsSelectedSitePatch**](docs/SquareConnectionsAPI.md#squareconnectionsidrelationshipsselectedsitepatch) | **PATCH** /squareConnections/{id}/relationships/selectedSite | Update selectedSite relationship (\&quot;to-one\&quot;).
*SquareConnectionsAPI* | [**squareConnectionsIdRelationshipsSitesGet**](docs/SquareConnectionsAPI.md#squareconnectionsidrelationshipssitesget) | **GET** /squareConnections/{id}/relationships/sites | Get sites relationship (\&quot;to-many\&quot;).
*SquareConnectionsAPI* | [**squareConnectionsPost**](docs/SquareConnectionsAPI.md#squareconnectionspost) | **POST** /squareConnections | Create single squareConnection.
*StripeConnectionsAPI* | [**stripeConnectionsGet**](docs/StripeConnectionsAPI.md#stripeconnectionsget) | **GET** /stripeConnections | Get multiple stripeConnections.
*StripeConnectionsAPI* | [**stripeConnectionsIdRelationshipsOwnersGet**](docs/StripeConnectionsAPI.md#stripeconnectionsidrelationshipsownersget) | **GET** /stripeConnections/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
*StripeConnectionsAPI* | [**stripeConnectionsPost**](docs/StripeConnectionsAPI.md#stripeconnectionspost) | **POST** /stripeConnections | Create single stripeConnection.
*StripeDashboardLinksAPI* | [**stripeDashboardLinksGet**](docs/StripeDashboardLinksAPI.md#stripedashboardlinksget) | **GET** /stripeDashboardLinks | Get multiple stripeDashboardLinks.
*StripeDashboardLinksAPI* | [**stripeDashboardLinksIdRelationshipsOwnersGet**](docs/StripeDashboardLinksAPI.md#stripedashboardlinksidrelationshipsownersget) | **GET** /stripeDashboardLinks/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
*SubscriptionPriceChangeDecisionsAPI* | [**subscriptionPriceChangeDecisionsGet**](docs/SubscriptionPriceChangeDecisionsAPI.md#subscriptionpricechangedecisionsget) | **GET** /subscriptionPriceChangeDecisions | Get multiple subscriptionPriceChangeDecisions.
*SubscriptionPriceChangeDecisionsAPI* | [**subscriptionPriceChangeDecisionsIdPatch**](docs/SubscriptionPriceChangeDecisionsAPI.md#subscriptionpricechangedecisionsidpatch) | **PATCH** /subscriptionPriceChangeDecisions/{id} | Update single subscriptionPriceChangeDecision.
*SubscriptionPriceChangeDecisionsAPI* | [**subscriptionPriceChangeDecisionsIdRelationshipsPriceChangeGet**](docs/SubscriptionPriceChangeDecisionsAPI.md#subscriptionpricechangedecisionsidrelationshipspricechangeget) | **GET** /subscriptionPriceChangeDecisions/{id}/relationships/priceChange | Get priceChange relationship (\&quot;to-one\&quot;).
*SubscriptionPriceChangeDecisionsAPI* | [**subscriptionPriceChangeDecisionsPost**](docs/SubscriptionPriceChangeDecisionsAPI.md#subscriptionpricechangedecisionspost) | **POST** /subscriptionPriceChangeDecisions | Create single subscriptionPriceChangeDecision.
*TemporaryUserTokensAPI* | [**temporaryUserTokensIdGet**](docs/TemporaryUserTokensAPI.md#temporaryusertokensidget) | **GET** /temporaryUserTokens/{id} | Get single temporaryUserToken.
*TemporaryUserTokensAPI* | [**temporaryUserTokensIdRelationshipsOwnersGet**](docs/TemporaryUserTokensAPI.md#temporaryusertokensidrelationshipsownersget) | **GET** /temporaryUserTokens/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
*TemporaryUserTokensAPI* | [**temporaryUserTokensPost**](docs/TemporaryUserTokensAPI.md#temporaryusertokenspost) | **POST** /temporaryUserTokens | Create single temporaryUserToken.
*TermsAPI* | [**termsGet**](docs/TermsAPI.md#termsget) | **GET** /terms | Get multiple terms.
*TermsAPI* | [**termsIdGet**](docs/TermsAPI.md#termsidget) | **GET** /terms/{id} | Get single term.
*TrackFilesAPI* | [**trackFilesIdGet**](docs/TrackFilesAPI.md#trackfilesidget) | **GET** /trackFiles/{id} | Get single trackFile.
*TrackManifestsAPI* | [**trackManifestsIdGet**](docs/TrackManifestsAPI.md#trackmanifestsidget) | **GET** /trackManifests/{id} | Get single trackManifest.
*TrackSourceFilesAPI* | [**trackSourceFilesIdGet**](docs/TrackSourceFilesAPI.md#tracksourcefilesidget) | **GET** /trackSourceFiles/{id} | Get single trackSourceFile.
*TrackSourceFilesAPI* | [**trackSourceFilesIdRelationshipsOwnersGet**](docs/TrackSourceFilesAPI.md#tracksourcefilesidrelationshipsownersget) | **GET** /trackSourceFiles/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
*TrackSourceFilesAPI* | [**trackSourceFilesPost**](docs/TrackSourceFilesAPI.md#tracksourcefilespost) | **POST** /trackSourceFiles | Create single trackSourceFile.
*TrackStatisticsAPI* | [**trackStatisticsIdGet**](docs/TrackStatisticsAPI.md#trackstatisticsidget) | **GET** /trackStatistics/{id} | Get single trackStatistic.
*TrackStatisticsAPI* | [**trackStatisticsIdRelationshipsOwnersGet**](docs/TrackStatisticsAPI.md#trackstatisticsidrelationshipsownersget) | **GET** /trackStatistics/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
*TracksAPI* | [**tracksGet**](docs/TracksAPI.md#tracksget) | **GET** /tracks | Get multiple tracks.
*TracksAPI* | [**tracksIdDelete**](docs/TracksAPI.md#tracksiddelete) | **DELETE** /tracks/{id} | Delete single track.
*TracksAPI* | [**tracksIdGet**](docs/TracksAPI.md#tracksidget) | **GET** /tracks/{id} | Get single track.
*TracksAPI* | [**tracksIdPatch**](docs/TracksAPI.md#tracksidpatch) | **PATCH** /tracks/{id} | Update single track.
*TracksAPI* | [**tracksIdRelationshipsAlbumsGet**](docs/TracksAPI.md#tracksidrelationshipsalbumsget) | **GET** /tracks/{id}/relationships/albums | Get albums relationship (\&quot;to-many\&quot;).
*TracksAPI* | [**tracksIdRelationshipsAlbumsPatch**](docs/TracksAPI.md#tracksidrelationshipsalbumspatch) | **PATCH** /tracks/{id}/relationships/albums | Update albums relationship (\&quot;to-many\&quot;).
*TracksAPI* | [**tracksIdRelationshipsArtistsGet**](docs/TracksAPI.md#tracksidrelationshipsartistsget) | **GET** /tracks/{id}/relationships/artists | Get artists relationship (\&quot;to-many\&quot;).
*TracksAPI* | [**tracksIdRelationshipsCreditsGet**](docs/TracksAPI.md#tracksidrelationshipscreditsget) | **GET** /tracks/{id}/relationships/credits | Get credits relationship (\&quot;to-many\&quot;).
*TracksAPI* | [**tracksIdRelationshipsDownloadGet**](docs/TracksAPI.md#tracksidrelationshipsdownloadget) | **GET** /tracks/{id}/relationships/download | Get download relationship (\&quot;to-one\&quot;).
*TracksAPI* | [**tracksIdRelationshipsGenresGet**](docs/TracksAPI.md#tracksidrelationshipsgenresget) | **GET** /tracks/{id}/relationships/genres | Get genres relationship (\&quot;to-many\&quot;).
*TracksAPI* | [**tracksIdRelationshipsLyricsGet**](docs/TracksAPI.md#tracksidrelationshipslyricsget) | **GET** /tracks/{id}/relationships/lyrics | Get lyrics relationship (\&quot;to-many\&quot;).
*TracksAPI* | [**tracksIdRelationshipsMetadataStatusGet**](docs/TracksAPI.md#tracksidrelationshipsmetadatastatusget) | **GET** /tracks/{id}/relationships/metadataStatus | Get metadataStatus relationship (\&quot;to-one\&quot;).
*TracksAPI* | [**tracksIdRelationshipsOwnersGet**](docs/TracksAPI.md#tracksidrelationshipsownersget) | **GET** /tracks/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
*TracksAPI* | [**tracksIdRelationshipsPriceConfigGet**](docs/TracksAPI.md#tracksidrelationshipspriceconfigget) | **GET** /tracks/{id}/relationships/priceConfig | Get priceConfig relationship (\&quot;to-one\&quot;).
*TracksAPI* | [**tracksIdRelationshipsProvidersGet**](docs/TracksAPI.md#tracksidrelationshipsprovidersget) | **GET** /tracks/{id}/relationships/providers | Get providers relationship (\&quot;to-many\&quot;).
*TracksAPI* | [**tracksIdRelationshipsRadioGet**](docs/TracksAPI.md#tracksidrelationshipsradioget) | **GET** /tracks/{id}/relationships/radio | Get radio relationship (\&quot;to-many\&quot;).
*TracksAPI* | [**tracksIdRelationshipsReplacementGet**](docs/TracksAPI.md#tracksidrelationshipsreplacementget) | **GET** /tracks/{id}/relationships/replacement | Get replacement relationship (\&quot;to-one\&quot;).
*TracksAPI* | [**tracksIdRelationshipsSharesGet**](docs/TracksAPI.md#tracksidrelationshipssharesget) | **GET** /tracks/{id}/relationships/shares | Get shares relationship (\&quot;to-many\&quot;).
*TracksAPI* | [**tracksIdRelationshipsSimilarTracksGet**](docs/TracksAPI.md#tracksidrelationshipssimilartracksget) | **GET** /tracks/{id}/relationships/similarTracks | Get similarTracks relationship (\&quot;to-many\&quot;).
*TracksAPI* | [**tracksIdRelationshipsSourceFileGet**](docs/TracksAPI.md#tracksidrelationshipssourcefileget) | **GET** /tracks/{id}/relationships/sourceFile | Get sourceFile relationship (\&quot;to-one\&quot;).
*TracksAPI* | [**tracksIdRelationshipsSuggestedTracksGet**](docs/TracksAPI.md#tracksidrelationshipssuggestedtracksget) | **GET** /tracks/{id}/relationships/suggestedTracks | Get suggestedTracks relationship (\&quot;to-many\&quot;).
*TracksAPI* | [**tracksIdRelationshipsTrackStatisticsGet**](docs/TracksAPI.md#tracksidrelationshipstrackstatisticsget) | **GET** /tracks/{id}/relationships/trackStatistics | Get trackStatistics relationship (\&quot;to-one\&quot;).
*TracksAPI* | [**tracksIdRelationshipsUsageRulesGet**](docs/TracksAPI.md#tracksidrelationshipsusagerulesget) | **GET** /tracks/{id}/relationships/usageRules | Get usageRules relationship (\&quot;to-one\&quot;).
*TracksAPI* | [**tracksPost**](docs/TracksAPI.md#trackspost) | **POST** /tracks | Create single track.
*TracksMetadataStatusAPI* | [**tracksMetadataStatusIdGet**](docs/TracksMetadataStatusAPI.md#tracksmetadatastatusidget) | **GET** /tracksMetadataStatus/{id} | Get single tracksMetadataStatu.
*UsageRulesAPI* | [**usageRulesIdGet**](docs/UsageRulesAPI.md#usagerulesidget) | **GET** /usageRules/{id} | Get single usageRule.
*UsageRulesAPI* | [**usageRulesPost**](docs/UsageRulesAPI.md#usagerulespost) | **POST** /usageRules | Create single usageRule.
*UserCollectionAlbumsAPI* | [**userCollectionAlbumsIdGet**](docs/UserCollectionAlbumsAPI.md#usercollectionalbumsidget) | **GET** /userCollectionAlbums/{id} | Get single userCollectionAlbum.
*UserCollectionAlbumsAPI* | [**userCollectionAlbumsIdRelationshipsItemsDelete**](docs/UserCollectionAlbumsAPI.md#usercollectionalbumsidrelationshipsitemsdelete) | **DELETE** /userCollectionAlbums/{id}/relationships/items | Delete from items relationship (\&quot;to-many\&quot;).
*UserCollectionAlbumsAPI* | [**userCollectionAlbumsIdRelationshipsItemsGet**](docs/UserCollectionAlbumsAPI.md#usercollectionalbumsidrelationshipsitemsget) | **GET** /userCollectionAlbums/{id}/relationships/items | Get items relationship (\&quot;to-many\&quot;).
*UserCollectionAlbumsAPI* | [**userCollectionAlbumsIdRelationshipsItemsPost**](docs/UserCollectionAlbumsAPI.md#usercollectionalbumsidrelationshipsitemspost) | **POST** /userCollectionAlbums/{id}/relationships/items | Add to items relationship (\&quot;to-many\&quot;).
*UserCollectionAlbumsAPI* | [**userCollectionAlbumsIdRelationshipsOwnersGet**](docs/UserCollectionAlbumsAPI.md#usercollectionalbumsidrelationshipsownersget) | **GET** /userCollectionAlbums/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
*UserCollectionArtistsAPI* | [**userCollectionArtistsIdGet**](docs/UserCollectionArtistsAPI.md#usercollectionartistsidget) | **GET** /userCollectionArtists/{id} | Get single userCollectionArtist.
*UserCollectionArtistsAPI* | [**userCollectionArtistsIdRelationshipsItemsDelete**](docs/UserCollectionArtistsAPI.md#usercollectionartistsidrelationshipsitemsdelete) | **DELETE** /userCollectionArtists/{id}/relationships/items | Delete from items relationship (\&quot;to-many\&quot;).
*UserCollectionArtistsAPI* | [**userCollectionArtistsIdRelationshipsItemsGet**](docs/UserCollectionArtistsAPI.md#usercollectionartistsidrelationshipsitemsget) | **GET** /userCollectionArtists/{id}/relationships/items | Get items relationship (\&quot;to-many\&quot;).
*UserCollectionArtistsAPI* | [**userCollectionArtistsIdRelationshipsItemsPost**](docs/UserCollectionArtistsAPI.md#usercollectionartistsidrelationshipsitemspost) | **POST** /userCollectionArtists/{id}/relationships/items | Add to items relationship (\&quot;to-many\&quot;).
*UserCollectionArtistsAPI* | [**userCollectionArtistsIdRelationshipsOwnersGet**](docs/UserCollectionArtistsAPI.md#usercollectionartistsidrelationshipsownersget) | **GET** /userCollectionArtists/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
*UserCollectionFoldersAPI* | [**userCollectionFoldersGet**](docs/UserCollectionFoldersAPI.md#usercollectionfoldersget) | **GET** /userCollectionFolders | Get multiple userCollectionFolders.
*UserCollectionFoldersAPI* | [**userCollectionFoldersIdDelete**](docs/UserCollectionFoldersAPI.md#usercollectionfoldersiddelete) | **DELETE** /userCollectionFolders/{id} | Delete single userCollectionFolder.
*UserCollectionFoldersAPI* | [**userCollectionFoldersIdGet**](docs/UserCollectionFoldersAPI.md#usercollectionfoldersidget) | **GET** /userCollectionFolders/{id} | Get single userCollectionFolder.
*UserCollectionFoldersAPI* | [**userCollectionFoldersIdPatch**](docs/UserCollectionFoldersAPI.md#usercollectionfoldersidpatch) | **PATCH** /userCollectionFolders/{id} | Update single userCollectionFolder.
*UserCollectionFoldersAPI* | [**userCollectionFoldersIdRelationshipsItemsDelete**](docs/UserCollectionFoldersAPI.md#usercollectionfoldersidrelationshipsitemsdelete) | **DELETE** /userCollectionFolders/{id}/relationships/items | Delete from items relationship (\&quot;to-many\&quot;).
*UserCollectionFoldersAPI* | [**userCollectionFoldersIdRelationshipsItemsGet**](docs/UserCollectionFoldersAPI.md#usercollectionfoldersidrelationshipsitemsget) | **GET** /userCollectionFolders/{id}/relationships/items | Get items relationship (\&quot;to-many\&quot;).
*UserCollectionFoldersAPI* | [**userCollectionFoldersIdRelationshipsItemsPost**](docs/UserCollectionFoldersAPI.md#usercollectionfoldersidrelationshipsitemspost) | **POST** /userCollectionFolders/{id}/relationships/items | Add to items relationship (\&quot;to-many\&quot;).
*UserCollectionFoldersAPI* | [**userCollectionFoldersIdRelationshipsOwnersGet**](docs/UserCollectionFoldersAPI.md#usercollectionfoldersidrelationshipsownersget) | **GET** /userCollectionFolders/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
*UserCollectionFoldersAPI* | [**userCollectionFoldersIdRelationshipsUserCollectionGet**](docs/UserCollectionFoldersAPI.md#usercollectionfoldersidrelationshipsusercollectionget) | **GET** /userCollectionFolders/{id}/relationships/userCollection | Get userCollection relationship (\&quot;to-one\&quot;).
*UserCollectionFoldersAPI* | [**userCollectionFoldersPost**](docs/UserCollectionFoldersAPI.md#usercollectionfolderspost) | **POST** /userCollectionFolders | Create single userCollectionFolder.
*UserCollectionPlaylistsAPI* | [**userCollectionPlaylistsIdGet**](docs/UserCollectionPlaylistsAPI.md#usercollectionplaylistsidget) | **GET** /userCollectionPlaylists/{id} | Get single userCollectionPlaylist.
*UserCollectionPlaylistsAPI* | [**userCollectionPlaylistsIdRelationshipsItemsDelete**](docs/UserCollectionPlaylistsAPI.md#usercollectionplaylistsidrelationshipsitemsdelete) | **DELETE** /userCollectionPlaylists/{id}/relationships/items | Delete from items relationship (\&quot;to-many\&quot;).
*UserCollectionPlaylistsAPI* | [**userCollectionPlaylistsIdRelationshipsItemsGet**](docs/UserCollectionPlaylistsAPI.md#usercollectionplaylistsidrelationshipsitemsget) | **GET** /userCollectionPlaylists/{id}/relationships/items | Get items relationship (\&quot;to-many\&quot;).
*UserCollectionPlaylistsAPI* | [**userCollectionPlaylistsIdRelationshipsItemsPost**](docs/UserCollectionPlaylistsAPI.md#usercollectionplaylistsidrelationshipsitemspost) | **POST** /userCollectionPlaylists/{id}/relationships/items | Add to items relationship (\&quot;to-many\&quot;).
*UserCollectionPlaylistsAPI* | [**userCollectionPlaylistsIdRelationshipsOwnersGet**](docs/UserCollectionPlaylistsAPI.md#usercollectionplaylistsidrelationshipsownersget) | **GET** /userCollectionPlaylists/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
*UserCollectionSaveForLatersAPI* | [**userCollectionSaveForLatersIdGet**](docs/UserCollectionSaveForLatersAPI.md#usercollectionsaveforlatersidget) | **GET** /userCollectionSaveForLaters/{id} | Get single userCollectionSaveForLater.
*UserCollectionSaveForLatersAPI* | [**userCollectionSaveForLatersIdRelationshipsItemsDelete**](docs/UserCollectionSaveForLatersAPI.md#usercollectionsaveforlatersidrelationshipsitemsdelete) | **DELETE** /userCollectionSaveForLaters/{id}/relationships/items | Delete from items relationship (\&quot;to-many\&quot;).
*UserCollectionSaveForLatersAPI* | [**userCollectionSaveForLatersIdRelationshipsItemsGet**](docs/UserCollectionSaveForLatersAPI.md#usercollectionsaveforlatersidrelationshipsitemsget) | **GET** /userCollectionSaveForLaters/{id}/relationships/items | Get items relationship (\&quot;to-many\&quot;).
*UserCollectionSaveForLatersAPI* | [**userCollectionSaveForLatersIdRelationshipsItemsPost**](docs/UserCollectionSaveForLatersAPI.md#usercollectionsaveforlatersidrelationshipsitemspost) | **POST** /userCollectionSaveForLaters/{id}/relationships/items | Add to items relationship (\&quot;to-many\&quot;).
*UserCollectionSaveForLatersAPI* | [**userCollectionSaveForLatersIdRelationshipsOwnersGet**](docs/UserCollectionSaveForLatersAPI.md#usercollectionsaveforlatersidrelationshipsownersget) | **GET** /userCollectionSaveForLaters/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
*UserCollectionTracksAPI* | [**userCollectionTracksIdGet**](docs/UserCollectionTracksAPI.md#usercollectiontracksidget) | **GET** /userCollectionTracks/{id} | Get single userCollectionTrack.
*UserCollectionTracksAPI* | [**userCollectionTracksIdRelationshipsItemsDelete**](docs/UserCollectionTracksAPI.md#usercollectiontracksidrelationshipsitemsdelete) | **DELETE** /userCollectionTracks/{id}/relationships/items | Delete from items relationship (\&quot;to-many\&quot;).
*UserCollectionTracksAPI* | [**userCollectionTracksIdRelationshipsItemsGet**](docs/UserCollectionTracksAPI.md#usercollectiontracksidrelationshipsitemsget) | **GET** /userCollectionTracks/{id}/relationships/items | Get items relationship (\&quot;to-many\&quot;).
*UserCollectionTracksAPI* | [**userCollectionTracksIdRelationshipsItemsPost**](docs/UserCollectionTracksAPI.md#usercollectiontracksidrelationshipsitemspost) | **POST** /userCollectionTracks/{id}/relationships/items | Add to items relationship (\&quot;to-many\&quot;).
*UserCollectionTracksAPI* | [**userCollectionTracksIdRelationshipsOwnersGet**](docs/UserCollectionTracksAPI.md#usercollectiontracksidrelationshipsownersget) | **GET** /userCollectionTracks/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
*UserCollectionVideosAPI* | [**userCollectionVideosIdGet**](docs/UserCollectionVideosAPI.md#usercollectionvideosidget) | **GET** /userCollectionVideos/{id} | Get single userCollectionVideo.
*UserCollectionVideosAPI* | [**userCollectionVideosIdRelationshipsItemsDelete**](docs/UserCollectionVideosAPI.md#usercollectionvideosidrelationshipsitemsdelete) | **DELETE** /userCollectionVideos/{id}/relationships/items | Delete from items relationship (\&quot;to-many\&quot;).
*UserCollectionVideosAPI* | [**userCollectionVideosIdRelationshipsItemsGet**](docs/UserCollectionVideosAPI.md#usercollectionvideosidrelationshipsitemsget) | **GET** /userCollectionVideos/{id}/relationships/items | Get items relationship (\&quot;to-many\&quot;).
*UserCollectionVideosAPI* | [**userCollectionVideosIdRelationshipsItemsPost**](docs/UserCollectionVideosAPI.md#usercollectionvideosidrelationshipsitemspost) | **POST** /userCollectionVideos/{id}/relationships/items | Add to items relationship (\&quot;to-many\&quot;).
*UserCollectionVideosAPI* | [**userCollectionVideosIdRelationshipsOwnersGet**](docs/UserCollectionVideosAPI.md#usercollectionvideosidrelationshipsownersget) | **GET** /userCollectionVideos/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
*UserCollectionsAPI* | [**userCollectionsIdGet**](docs/UserCollectionsAPI.md#usercollectionsidget) | **GET** /userCollections/{id} | Get single userCollection.
*UserCollectionsAPI* | [**userCollectionsIdRelationshipsAlbumsDelete**](docs/UserCollectionsAPI.md#usercollectionsidrelationshipsalbumsdelete) | **DELETE** /userCollections/{id}/relationships/albums | Delete from albums relationship (\&quot;to-many\&quot;).
*UserCollectionsAPI* | [**userCollectionsIdRelationshipsAlbumsGet**](docs/UserCollectionsAPI.md#usercollectionsidrelationshipsalbumsget) | **GET** /userCollections/{id}/relationships/albums | Get albums relationship (\&quot;to-many\&quot;).
*UserCollectionsAPI* | [**userCollectionsIdRelationshipsAlbumsPost**](docs/UserCollectionsAPI.md#usercollectionsidrelationshipsalbumspost) | **POST** /userCollections/{id}/relationships/albums | Add to albums relationship (\&quot;to-many\&quot;).
*UserCollectionsAPI* | [**userCollectionsIdRelationshipsArtistsDelete**](docs/UserCollectionsAPI.md#usercollectionsidrelationshipsartistsdelete) | **DELETE** /userCollections/{id}/relationships/artists | Delete from artists relationship (\&quot;to-many\&quot;).
*UserCollectionsAPI* | [**userCollectionsIdRelationshipsArtistsGet**](docs/UserCollectionsAPI.md#usercollectionsidrelationshipsartistsget) | **GET** /userCollections/{id}/relationships/artists | Get artists relationship (\&quot;to-many\&quot;).
*UserCollectionsAPI* | [**userCollectionsIdRelationshipsArtistsPost**](docs/UserCollectionsAPI.md#usercollectionsidrelationshipsartistspost) | **POST** /userCollections/{id}/relationships/artists | Add to artists relationship (\&quot;to-many\&quot;).
*UserCollectionsAPI* | [**userCollectionsIdRelationshipsOwnersGet**](docs/UserCollectionsAPI.md#usercollectionsidrelationshipsownersget) | **GET** /userCollections/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
*UserCollectionsAPI* | [**userCollectionsIdRelationshipsPlaylistsDelete**](docs/UserCollectionsAPI.md#usercollectionsidrelationshipsplaylistsdelete) | **DELETE** /userCollections/{id}/relationships/playlists | Delete from playlists relationship (\&quot;to-many\&quot;).
*UserCollectionsAPI* | [**userCollectionsIdRelationshipsPlaylistsGet**](docs/UserCollectionsAPI.md#usercollectionsidrelationshipsplaylistsget) | **GET** /userCollections/{id}/relationships/playlists | Get playlists relationship (\&quot;to-many\&quot;).
*UserCollectionsAPI* | [**userCollectionsIdRelationshipsPlaylistsPost**](docs/UserCollectionsAPI.md#usercollectionsidrelationshipsplaylistspost) | **POST** /userCollections/{id}/relationships/playlists | Add to playlists relationship (\&quot;to-many\&quot;).
*UserCollectionsAPI* | [**userCollectionsIdRelationshipsTracksDelete**](docs/UserCollectionsAPI.md#usercollectionsidrelationshipstracksdelete) | **DELETE** /userCollections/{id}/relationships/tracks | Delete from tracks relationship (\&quot;to-many\&quot;).
*UserCollectionsAPI* | [**userCollectionsIdRelationshipsTracksGet**](docs/UserCollectionsAPI.md#usercollectionsidrelationshipstracksget) | **GET** /userCollections/{id}/relationships/tracks | Get tracks relationship (\&quot;to-many\&quot;).
*UserCollectionsAPI* | [**userCollectionsIdRelationshipsTracksPost**](docs/UserCollectionsAPI.md#usercollectionsidrelationshipstrackspost) | **POST** /userCollections/{id}/relationships/tracks | Add to tracks relationship (\&quot;to-many\&quot;).
*UserCollectionsAPI* | [**userCollectionsIdRelationshipsVideosDelete**](docs/UserCollectionsAPI.md#usercollectionsidrelationshipsvideosdelete) | **DELETE** /userCollections/{id}/relationships/videos | Delete from videos relationship (\&quot;to-many\&quot;).
*UserCollectionsAPI* | [**userCollectionsIdRelationshipsVideosGet**](docs/UserCollectionsAPI.md#usercollectionsidrelationshipsvideosget) | **GET** /userCollections/{id}/relationships/videos | Get videos relationship (\&quot;to-many\&quot;).
*UserCollectionsAPI* | [**userCollectionsIdRelationshipsVideosPost**](docs/UserCollectionsAPI.md#usercollectionsidrelationshipsvideospost) | **POST** /userCollections/{id}/relationships/videos | Add to videos relationship (\&quot;to-many\&quot;).
*UserDailyMixesAPI* | [**userDailyMixesIdGet**](docs/UserDailyMixesAPI.md#userdailymixesidget) | **GET** /userDailyMixes/{id} | Get single userDailyMixe.
*UserDailyMixesAPI* | [**userDailyMixesIdRelationshipsItemsGet**](docs/UserDailyMixesAPI.md#userdailymixesidrelationshipsitemsget) | **GET** /userDailyMixes/{id}/relationships/items | Get items relationship (\&quot;to-many\&quot;).
*UserDataExportRequestsAPI* | [**userDataExportRequestsPost**](docs/UserDataExportRequestsAPI.md#userdataexportrequestspost) | **POST** /userDataExportRequests | Create single userDataExportRequest.
*UserDiscoveryMixesAPI* | [**userDiscoveryMixesIdGet**](docs/UserDiscoveryMixesAPI.md#userdiscoverymixesidget) | **GET** /userDiscoveryMixes/{id} | Get single userDiscoveryMixe.
*UserDiscoveryMixesAPI* | [**userDiscoveryMixesIdRelationshipsItemsGet**](docs/UserDiscoveryMixesAPI.md#userdiscoverymixesidrelationshipsitemsget) | **GET** /userDiscoveryMixes/{id}/relationships/items | Get items relationship (\&quot;to-many\&quot;).
*UserNewReleaseMixesAPI* | [**userNewReleaseMixesIdGet**](docs/UserNewReleaseMixesAPI.md#usernewreleasemixesidget) | **GET** /userNewReleaseMixes/{id} | Get single userNewReleaseMixe.
*UserNewReleaseMixesAPI* | [**userNewReleaseMixesIdRelationshipsItemsGet**](docs/UserNewReleaseMixesAPI.md#usernewreleasemixesidrelationshipsitemsget) | **GET** /userNewReleaseMixes/{id}/relationships/items | Get items relationship (\&quot;to-many\&quot;).
*UserOfflineMixesAPI* | [**userOfflineMixesIdGet**](docs/UserOfflineMixesAPI.md#userofflinemixesidget) | **GET** /userOfflineMixes/{id} | Get single userOfflineMixe.
*UserOfflineMixesAPI* | [**userOfflineMixesIdRelationshipsItemsGet**](docs/UserOfflineMixesAPI.md#userofflinemixesidrelationshipsitemsget) | **GET** /userOfflineMixes/{id}/relationships/items | Get items relationship (\&quot;to-many\&quot;).
*UserRecommendationBlocksAPI* | [**userRecommendationBlocksIdGet**](docs/UserRecommendationBlocksAPI.md#userrecommendationblocksidget) | **GET** /userRecommendationBlocks/{id} | Get single userRecommendationBlock.
*UserRecommendationBlocksAPI* | [**userRecommendationBlocksIdRelationshipsArtistsDelete**](docs/UserRecommendationBlocksAPI.md#userrecommendationblocksidrelationshipsartistsdelete) | **DELETE** /userRecommendationBlocks/{id}/relationships/artists | Delete from artists relationship (\&quot;to-many\&quot;).
*UserRecommendationBlocksAPI* | [**userRecommendationBlocksIdRelationshipsArtistsGet**](docs/UserRecommendationBlocksAPI.md#userrecommendationblocksidrelationshipsartistsget) | **GET** /userRecommendationBlocks/{id}/relationships/artists | Get artists relationship (\&quot;to-many\&quot;).
*UserRecommendationBlocksAPI* | [**userRecommendationBlocksIdRelationshipsArtistsPost**](docs/UserRecommendationBlocksAPI.md#userrecommendationblocksidrelationshipsartistspost) | **POST** /userRecommendationBlocks/{id}/relationships/artists | Add to artists relationship (\&quot;to-many\&quot;).
*UserRecommendationBlocksAPI* | [**userRecommendationBlocksIdRelationshipsOwnersGet**](docs/UserRecommendationBlocksAPI.md#userrecommendationblocksidrelationshipsownersget) | **GET** /userRecommendationBlocks/{id}/relationships/owners | Get owners relationship (\&quot;to-many\&quot;).
*UserRecommendationBlocksAPI* | [**userRecommendationBlocksIdRelationshipsTracksDelete**](docs/UserRecommendationBlocksAPI.md#userrecommendationblocksidrelationshipstracksdelete) | **DELETE** /userRecommendationBlocks/{id}/relationships/tracks | Delete from tracks relationship (\&quot;to-many\&quot;).
*UserRecommendationBlocksAPI* | [**userRecommendationBlocksIdRelationshipsTracksGet**](docs/UserRecommendationBlocksAPI.md#userrecommendationblocksidrelationshipstracksget) | **GET** /userRecommendationBlocks/{id}/relationships/tracks | Get tracks relationship (\&quot;to-many\&quot;).
*UserRecommendationBlocksAPI* | [**userRecommendationBlocksIdRelationshipsTracksPost**](docs/UserRecommendationBlocksAPI.md#userrecommendationblocksidrelationshipstrackspost) | **POST** /userRecommendationBlocks/{id}/relationships/tracks | Add to tracks relationship (\&quot;to-many\&quot;).
*UserRecommendationBlocksAPI* | [**userRecommendationBlocksIdRelationshipsVideosDelete**](docs/UserRecommendationBlocksAPI.md#userrecommendationblocksidrelationshipsvideosdelete) | **DELETE** /userRecommendationBlocks/{id}/relationships/videos | Delete from videos relationship (\&quot;to-many\&quot;).
*UserRecommendationBlocksAPI* | [**userRecommendationBlocksIdRelationshipsVideosGet**](docs/UserRecommendationBlocksAPI.md#userrecommendationblocksidrelationshipsvideosget) | **GET** /userRecommendationBlocks/{id}/relationships/videos | Get videos relationship (\&quot;to-many\&quot;).
*UserRecommendationBlocksAPI* | [**userRecommendationBlocksIdRelationshipsVideosPost**](docs/UserRecommendationBlocksAPI.md#userrecommendationblocksidrelationshipsvideospost) | **POST** /userRecommendationBlocks/{id}/relationships/videos | Add to videos relationship (\&quot;to-many\&quot;).
*UserRecommendationsAPI* | [**userRecommendationsIdGet**](docs/UserRecommendationsAPI.md#userrecommendationsidget) | **GET** /userRecommendations/{id} | Get single userRecommendation.
*UserRecommendationsAPI* | [**userRecommendationsIdRelationshipsDiscoveryMixesGet**](docs/UserRecommendationsAPI.md#userrecommendationsidrelationshipsdiscoverymixesget) | **GET** /userRecommendations/{id}/relationships/discoveryMixes | Get discoveryMixes relationship (\&quot;to-many\&quot;).
*UserRecommendationsAPI* | [**userRecommendationsIdRelationshipsMyMixesGet**](docs/UserRecommendationsAPI.md#userrecommendationsidrelationshipsmymixesget) | **GET** /userRecommendations/{id}/relationships/myMixes | Get myMixes relationship (\&quot;to-many\&quot;).
*UserRecommendationsAPI* | [**userRecommendationsIdRelationshipsNewArrivalMixesGet**](docs/UserRecommendationsAPI.md#userrecommendationsidrelationshipsnewarrivalmixesget) | **GET** /userRecommendations/{id}/relationships/newArrivalMixes | Get newArrivalMixes relationship (\&quot;to-many\&quot;).
*UserRecommendationsAPI* | [**userRecommendationsIdRelationshipsOfflineMixesGet**](docs/UserRecommendationsAPI.md#userrecommendationsidrelationshipsofflinemixesget) | **GET** /userRecommendations/{id}/relationships/offlineMixes | Get offlineMixes relationship (\&quot;to-many\&quot;).
*UserReportsAPI* | [**userReportsPost**](docs/UserReportsAPI.md#userreportspost) | **POST** /userReports | Create single userReport.
*UserSubscriptionPriceChangesAPI* | [**userSubscriptionPriceChangesGet**](docs/UserSubscriptionPriceChangesAPI.md#usersubscriptionpricechangesget) | **GET** /userSubscriptionPriceChanges | Get multiple userSubscriptionPriceChanges.
*UserSubscriptionPriceChangesAPI* | [**userSubscriptionPriceChangesIdRelationshipsDecisionGet**](docs/UserSubscriptionPriceChangesAPI.md#usersubscriptionpricechangesidrelationshipsdecisionget) | **GET** /userSubscriptionPriceChanges/{id}/relationships/decision | Get decision relationship (\&quot;to-one\&quot;).
*UsersAPI* | [**usersIdGet**](docs/UsersAPI.md#usersidget) | **GET** /users/{id} | Get single user.
*VideoManifestsAPI* | [**videoManifestsIdGet**](docs/VideoManifestsAPI.md#videomanifestsidget) | **GET** /videoManifests/{id} | Get single videoManifest.
*VideosAPI* | [**videosGet**](docs/VideosAPI.md#videosget) | **GET** /videos | Get multiple videos.
*VideosAPI* | [**videosIdGet**](docs/VideosAPI.md#videosidget) | **GET** /videos/{id} | Get single video.
*VideosAPI* | [**videosIdRelationshipsAlbumsGet**](docs/VideosAPI.md#videosidrelationshipsalbumsget) | **GET** /videos/{id}/relationships/albums | Get albums relationship (\&quot;to-many\&quot;).
*VideosAPI* | [**videosIdRelationshipsArtistsGet**](docs/VideosAPI.md#videosidrelationshipsartistsget) | **GET** /videos/{id}/relationships/artists | Get artists relationship (\&quot;to-many\&quot;).
*VideosAPI* | [**videosIdRelationshipsCreditsGet**](docs/VideosAPI.md#videosidrelationshipscreditsget) | **GET** /videos/{id}/relationships/credits | Get credits relationship (\&quot;to-many\&quot;).
*VideosAPI* | [**videosIdRelationshipsProvidersGet**](docs/VideosAPI.md#videosidrelationshipsprovidersget) | **GET** /videos/{id}/relationships/providers | Get providers relationship (\&quot;to-many\&quot;).
*VideosAPI* | [**videosIdRelationshipsReplacementGet**](docs/VideosAPI.md#videosidrelationshipsreplacementget) | **GET** /videos/{id}/relationships/replacement | Get replacement relationship (\&quot;to-one\&quot;).
*VideosAPI* | [**videosIdRelationshipsSimilarVideosGet**](docs/VideosAPI.md#videosidrelationshipssimilarvideosget) | **GET** /videos/{id}/relationships/similarVideos | Get similarVideos relationship (\&quot;to-many\&quot;).
*VideosAPI* | [**videosIdRelationshipsSuggestedVideosGet**](docs/VideosAPI.md#videosidrelationshipssuggestedvideosget) | **GET** /videos/{id}/relationships/suggestedVideos | Get suggestedVideos relationship (\&quot;to-many\&quot;).
*VideosAPI* | [**videosIdRelationshipsThumbnailArtGet**](docs/VideosAPI.md#videosidrelationshipsthumbnailartget) | **GET** /videos/{id}/relationships/thumbnailArt | Get thumbnailArt relationship (\&quot;to-many\&quot;).
*VideosAPI* | [**videosIdRelationshipsUsageRulesGet**](docs/VideosAPI.md#videosidrelationshipsusagerulesget) | **GET** /videos/{id}/relationships/usageRules | Get usageRules relationship (\&quot;to-one\&quot;).


## Documentation For Models

 - [AcceptedTermsAttributes](docs/AcceptedTermsAttributes.md)
 - [AcceptedTermsCreateOperationPayload](docs/AcceptedTermsCreateOperationPayload.md)
 - [AcceptedTermsCreateOperationPayloadData](docs/AcceptedTermsCreateOperationPayloadData.md)
 - [AcceptedTermsCreateOperationPayloadDataRelationships](docs/AcceptedTermsCreateOperationPayloadDataRelationships.md)
 - [AcceptedTermsCreateOperationPayloadDataRelationshipsTerms](docs/AcceptedTermsCreateOperationPayloadDataRelationshipsTerms.md)
 - [AcceptedTermsCreateOperationPayloadDataRelationshipsTermsData](docs/AcceptedTermsCreateOperationPayloadDataRelationshipsTermsData.md)
 - [AcceptedTermsCreateSingleResourceDataDocument](docs/AcceptedTermsCreateSingleResourceDataDocument.md)
 - [AcceptedTermsMultiRelationshipDataDocument](docs/AcceptedTermsMultiRelationshipDataDocument.md)
 - [AcceptedTermsMultiResourceDataDocument](docs/AcceptedTermsMultiResourceDataDocument.md)
 - [AcceptedTermsRelationships](docs/AcceptedTermsRelationships.md)
 - [AcceptedTermsResourceObject](docs/AcceptedTermsResourceObject.md)
 - [AcceptedTermsSingleRelationshipDataDocument](docs/AcceptedTermsSingleRelationshipDataDocument.md)
 - [AlbumStatisticsAttributes](docs/AlbumStatisticsAttributes.md)
 - [AlbumStatisticsMultiRelationshipDataDocument](docs/AlbumStatisticsMultiRelationshipDataDocument.md)
 - [AlbumStatisticsRelationships](docs/AlbumStatisticsRelationships.md)
 - [AlbumStatisticsResourceObject](docs/AlbumStatisticsResourceObject.md)
 - [AlbumStatisticsSingleResourceDataDocument](docs/AlbumStatisticsSingleResourceDataDocument.md)
 - [AlbumsAttributes](docs/AlbumsAttributes.md)
 - [AlbumsCoverArtRelationshipUpdateOperationPayload](docs/AlbumsCoverArtRelationshipUpdateOperationPayload.md)
 - [AlbumsCoverArtRelationshipUpdateOperationPayloadData](docs/AlbumsCoverArtRelationshipUpdateOperationPayloadData.md)
 - [AlbumsCreateOperationPayload](docs/AlbumsCreateOperationPayload.md)
 - [AlbumsCreateOperationPayloadData](docs/AlbumsCreateOperationPayloadData.md)
 - [AlbumsCreateOperationPayloadDataAttributes](docs/AlbumsCreateOperationPayloadDataAttributes.md)
 - [AlbumsCreateOperationPayloadDataRelationships](docs/AlbumsCreateOperationPayloadDataRelationships.md)
 - [AlbumsCreateOperationPayloadDataRelationshipsArtists](docs/AlbumsCreateOperationPayloadDataRelationshipsArtists.md)
 - [AlbumsCreateOperationPayloadDataRelationshipsArtistsData](docs/AlbumsCreateOperationPayloadDataRelationshipsArtistsData.md)
 - [AlbumsCreateOperationPayloadDataRelationshipsGenres](docs/AlbumsCreateOperationPayloadDataRelationshipsGenres.md)
 - [AlbumsCreateOperationPayloadDataRelationshipsGenresData](docs/AlbumsCreateOperationPayloadDataRelationshipsGenresData.md)
 - [AlbumsCreateSingleResourceDataDocument](docs/AlbumsCreateSingleResourceDataDocument.md)
 - [AlbumsItemsMultiRelationshipDataDocument](docs/AlbumsItemsMultiRelationshipDataDocument.md)
 - [AlbumsItemsRelationshipUpdateOperationPayload](docs/AlbumsItemsRelationshipUpdateOperationPayload.md)
 - [AlbumsItemsRelationshipUpdateOperationPayloadData](docs/AlbumsItemsRelationshipUpdateOperationPayloadData.md)
 - [AlbumsItemsRelationshipUpdateOperationPayloadMeta](docs/AlbumsItemsRelationshipUpdateOperationPayloadMeta.md)
 - [AlbumsItemsResourceIdentifier](docs/AlbumsItemsResourceIdentifier.md)
 - [AlbumsItemsResourceIdentifierMeta](docs/AlbumsItemsResourceIdentifierMeta.md)
 - [AlbumsMultiRelationshipDataDocument](docs/AlbumsMultiRelationshipDataDocument.md)
 - [AlbumsMultiResourceDataDocument](docs/AlbumsMultiResourceDataDocument.md)
 - [AlbumsRelationships](docs/AlbumsRelationships.md)
 - [AlbumsReplacementResourceIdentifier](docs/AlbumsReplacementResourceIdentifier.md)
 - [AlbumsReplacementResourceIdentifierMeta](docs/AlbumsReplacementResourceIdentifierMeta.md)
 - [AlbumsReplacementSingleRelationshipDataDocument](docs/AlbumsReplacementSingleRelationshipDataDocument.md)
 - [AlbumsResourceObject](docs/AlbumsResourceObject.md)
 - [AlbumsSimilarAlbumsMultiRelationshipDataDocument](docs/AlbumsSimilarAlbumsMultiRelationshipDataDocument.md)
 - [AlbumsSimilarAlbumsResourceIdentifier](docs/AlbumsSimilarAlbumsResourceIdentifier.md)
 - [AlbumsSimilarAlbumsResourceIdentifierMeta](docs/AlbumsSimilarAlbumsResourceIdentifierMeta.md)
 - [AlbumsSingleRelationshipDataDocument](docs/AlbumsSingleRelationshipDataDocument.md)
 - [AlbumsSingleResourceDataDocument](docs/AlbumsSingleResourceDataDocument.md)
 - [AlbumsSuggestedCoverArtsMultiRelationshipDataDocument](docs/AlbumsSuggestedCoverArtsMultiRelationshipDataDocument.md)
 - [AlbumsSuggestedCoverArtsMultiRelationshipDataDocumentMeta](docs/AlbumsSuggestedCoverArtsMultiRelationshipDataDocumentMeta.md)
 - [AlbumsSuggestedCoverArtsResourceIdentifier](docs/AlbumsSuggestedCoverArtsResourceIdentifier.md)
 - [AlbumsSuggestedCoverArtsResourceIdentifierMeta](docs/AlbumsSuggestedCoverArtsResourceIdentifierMeta.md)
 - [AlbumsUpdateOperationPayload](docs/AlbumsUpdateOperationPayload.md)
 - [AlbumsUpdateOperationPayloadData](docs/AlbumsUpdateOperationPayloadData.md)
 - [AlbumsUpdateOperationPayloadDataAttributes](docs/AlbumsUpdateOperationPayloadDataAttributes.md)
 - [AlbumsUpdateOperationPayloadDataRelationships](docs/AlbumsUpdateOperationPayloadDataRelationships.md)
 - [AlbumsUpdateOperationPayloadDataRelationshipsGenres](docs/AlbumsUpdateOperationPayloadDataRelationshipsGenres.md)
 - [AlbumsUpdateOperationPayloadDataRelationshipsGenresData](docs/AlbumsUpdateOperationPayloadDataRelationshipsGenresData.md)
 - [AppreciationsAttributes](docs/AppreciationsAttributes.md)
 - [AppreciationsCreateOperationPayload](docs/AppreciationsCreateOperationPayload.md)
 - [AppreciationsCreateOperationPayloadData](docs/AppreciationsCreateOperationPayloadData.md)
 - [AppreciationsCreateOperationPayloadDataRelationships](docs/AppreciationsCreateOperationPayloadDataRelationships.md)
 - [AppreciationsCreateOperationPayloadDataRelationshipsAppreciatedItem](docs/AppreciationsCreateOperationPayloadDataRelationshipsAppreciatedItem.md)
 - [AppreciationsCreateOperationPayloadDataRelationshipsAppreciatedItemData](docs/AppreciationsCreateOperationPayloadDataRelationshipsAppreciatedItemData.md)
 - [AppreciationsCreateOperationPayloadMeta](docs/AppreciationsCreateOperationPayloadMeta.md)
 - [AppreciationsCreateSingleResourceDataDocument](docs/AppreciationsCreateSingleResourceDataDocument.md)
 - [AppreciationsResourceObject](docs/AppreciationsResourceObject.md)
 - [ArtistBiographiesAttributes](docs/ArtistBiographiesAttributes.md)
 - [ArtistBiographiesMultiRelationshipDataDocument](docs/ArtistBiographiesMultiRelationshipDataDocument.md)
 - [ArtistBiographiesRelationships](docs/ArtistBiographiesRelationships.md)
 - [ArtistBiographiesResourceObject](docs/ArtistBiographiesResourceObject.md)
 - [ArtistBiographiesSingleResourceDataDocument](docs/ArtistBiographiesSingleResourceDataDocument.md)
 - [ArtistBiographiesUpdateOperationPayload](docs/ArtistBiographiesUpdateOperationPayload.md)
 - [ArtistBiographiesUpdateOperationPayloadData](docs/ArtistBiographiesUpdateOperationPayloadData.md)
 - [ArtistBiographiesUpdateOperationPayloadDataAttributes](docs/ArtistBiographiesUpdateOperationPayloadDataAttributes.md)
 - [ArtistClaimStatusesAttributes](docs/ArtistClaimStatusesAttributes.md)
 - [ArtistClaimStatusesMultiResourceDataDocument](docs/ArtistClaimStatusesMultiResourceDataDocument.md)
 - [ArtistClaimStatusesResourceObject](docs/ArtistClaimStatusesResourceObject.md)
 - [ArtistClaimsAcceptedArtistsRelationshipUpdateOperationPayload](docs/ArtistClaimsAcceptedArtistsRelationshipUpdateOperationPayload.md)
 - [ArtistClaimsAcceptedArtistsRelationshipUpdateOperationPayloadData](docs/ArtistClaimsAcceptedArtistsRelationshipUpdateOperationPayloadData.md)
 - [ArtistClaimsAttributes](docs/ArtistClaimsAttributes.md)
 - [ArtistClaimsCreateOperationPayload](docs/ArtistClaimsCreateOperationPayload.md)
 - [ArtistClaimsCreateOperationPayloadData](docs/ArtistClaimsCreateOperationPayloadData.md)
 - [ArtistClaimsCreateOperationPayloadDataAttributes](docs/ArtistClaimsCreateOperationPayloadDataAttributes.md)
 - [ArtistClaimsCreateOperationPayloadMeta](docs/ArtistClaimsCreateOperationPayloadMeta.md)
 - [ArtistClaimsCreateSingleResourceDataDocument](docs/ArtistClaimsCreateSingleResourceDataDocument.md)
 - [ArtistClaimsMultiRelationshipDataDocument](docs/ArtistClaimsMultiRelationshipDataDocument.md)
 - [ArtistClaimsMultiResourceDataDocument](docs/ArtistClaimsMultiResourceDataDocument.md)
 - [ArtistClaimsRelationships](docs/ArtistClaimsRelationships.md)
 - [ArtistClaimsResourceObject](docs/ArtistClaimsResourceObject.md)
 - [ArtistClaimsSingleResourceDataDocument](docs/ArtistClaimsSingleResourceDataDocument.md)
 - [ArtistClaimsUpdateOperationPayload](docs/ArtistClaimsUpdateOperationPayload.md)
 - [ArtistClaimsUpdateOperationPayloadData](docs/ArtistClaimsUpdateOperationPayloadData.md)
 - [ArtistClaimsUpdateOperationPayloadMeta](docs/ArtistClaimsUpdateOperationPayloadMeta.md)
 - [ArtistRolesAttributes](docs/ArtistRolesAttributes.md)
 - [ArtistRolesResourceObject](docs/ArtistRolesResourceObject.md)
 - [ArtistRolesSingleResourceDataDocument](docs/ArtistRolesSingleResourceDataDocument.md)
 - [ArtistsAlbumsMultiRelationshipDataDocument](docs/ArtistsAlbumsMultiRelationshipDataDocument.md)
 - [ArtistsAlbumsResourceIdentifier](docs/ArtistsAlbumsResourceIdentifier.md)
 - [ArtistsAlbumsResourceIdentifierMeta](docs/ArtistsAlbumsResourceIdentifierMeta.md)
 - [ArtistsAttributes](docs/ArtistsAttributes.md)
 - [ArtistsCreateOperationPayload](docs/ArtistsCreateOperationPayload.md)
 - [ArtistsCreateOperationPayloadData](docs/ArtistsCreateOperationPayloadData.md)
 - [ArtistsCreateOperationPayloadDataAttributes](docs/ArtistsCreateOperationPayloadDataAttributes.md)
 - [ArtistsCreateOperationPayloadMeta](docs/ArtistsCreateOperationPayloadMeta.md)
 - [ArtistsCreateSingleResourceDataDocument](docs/ArtistsCreateSingleResourceDataDocument.md)
 - [ArtistsFollowersMultiRelationshipDataDocument](docs/ArtistsFollowersMultiRelationshipDataDocument.md)
 - [ArtistsFollowersResourceIdentifier](docs/ArtistsFollowersResourceIdentifier.md)
 - [ArtistsFollowersResourceIdentifierMeta](docs/ArtistsFollowersResourceIdentifierMeta.md)
 - [ArtistsFollowersResourceMetaViewerContext](docs/ArtistsFollowersResourceMetaViewerContext.md)
 - [ArtistsFollowingMultiRelationshipDataDocument](docs/ArtistsFollowingMultiRelationshipDataDocument.md)
 - [ArtistsFollowingRelationshipAddOperationPayload](docs/ArtistsFollowingRelationshipAddOperationPayload.md)
 - [ArtistsFollowingRelationshipAddOperationPayloadData](docs/ArtistsFollowingRelationshipAddOperationPayloadData.md)
 - [ArtistsFollowingRelationshipRemoveOperationPayload](docs/ArtistsFollowingRelationshipRemoveOperationPayload.md)
 - [ArtistsFollowingRelationshipRemoveOperationPayloadData](docs/ArtistsFollowingRelationshipRemoveOperationPayloadData.md)
 - [ArtistsFollowingResourceIdentifier](docs/ArtistsFollowingResourceIdentifier.md)
 - [ArtistsFollowingResourceIdentifierMeta](docs/ArtistsFollowingResourceIdentifierMeta.md)
 - [ArtistsMultiRelationshipDataDocument](docs/ArtistsMultiRelationshipDataDocument.md)
 - [ArtistsMultiResourceDataDocument](docs/ArtistsMultiResourceDataDocument.md)
 - [ArtistsProfileArtRelationshipUpdateOperationPayload](docs/ArtistsProfileArtRelationshipUpdateOperationPayload.md)
 - [ArtistsProfileArtRelationshipUpdateOperationPayloadData](docs/ArtistsProfileArtRelationshipUpdateOperationPayloadData.md)
 - [ArtistsRelationships](docs/ArtistsRelationships.md)
 - [ArtistsResourceObject](docs/ArtistsResourceObject.md)
 - [ArtistsSingleRelationshipDataDocument](docs/ArtistsSingleRelationshipDataDocument.md)
 - [ArtistsSingleResourceDataDocument](docs/ArtistsSingleResourceDataDocument.md)
 - [ArtistsTrackProvidersMultiRelationshipDataDocument](docs/ArtistsTrackProvidersMultiRelationshipDataDocument.md)
 - [ArtistsTrackProvidersResourceIdentifier](docs/ArtistsTrackProvidersResourceIdentifier.md)
 - [ArtistsTrackProvidersResourceIdentifierMeta](docs/ArtistsTrackProvidersResourceIdentifierMeta.md)
 - [ArtistsTracksMultiRelationshipDataDocument](docs/ArtistsTracksMultiRelationshipDataDocument.md)
 - [ArtistsTracksResourceIdentifier](docs/ArtistsTracksResourceIdentifier.md)
 - [ArtistsTracksResourceIdentifierMeta](docs/ArtistsTracksResourceIdentifierMeta.md)
 - [ArtistsUpdateOperationPayload](docs/ArtistsUpdateOperationPayload.md)
 - [ArtistsUpdateOperationPayloadData](docs/ArtistsUpdateOperationPayloadData.md)
 - [ArtistsUpdateOperationPayloadDataAttributes](docs/ArtistsUpdateOperationPayloadDataAttributes.md)
 - [ArtistsUpdateOperationPayloadMeta](docs/ArtistsUpdateOperationPayloadMeta.md)
 - [ArtistsVideosMultiRelationshipDataDocument](docs/ArtistsVideosMultiRelationshipDataDocument.md)
 - [ArtistsVideosResourceIdentifier](docs/ArtistsVideosResourceIdentifier.md)
 - [ArtistsVideosResourceIdentifierMeta](docs/ArtistsVideosResourceIdentifierMeta.md)
 - [ArtworkFile](docs/ArtworkFile.md)
 - [ArtworkFileMeta](docs/ArtworkFileMeta.md)
 - [ArtworkSourceFile](docs/ArtworkSourceFile.md)
 - [ArtworkVisualMetadata](docs/ArtworkVisualMetadata.md)
 - [ArtworksAttributes](docs/ArtworksAttributes.md)
 - [ArtworksCreateOperationPayload](docs/ArtworksCreateOperationPayload.md)
 - [ArtworksCreateOperationPayloadData](docs/ArtworksCreateOperationPayloadData.md)
 - [ArtworksCreateOperationPayloadDataAttributes](docs/ArtworksCreateOperationPayloadDataAttributes.md)
 - [ArtworksCreateOperationPayloadDataAttributesSourceFile](docs/ArtworksCreateOperationPayloadDataAttributesSourceFile.md)
 - [ArtworksCreateSingleResourceDataDocument](docs/ArtworksCreateSingleResourceDataDocument.md)
 - [ArtworksMultiRelationshipDataDocument](docs/ArtworksMultiRelationshipDataDocument.md)
 - [ArtworksMultiResourceDataDocument](docs/ArtworksMultiResourceDataDocument.md)
 - [ArtworksRelationships](docs/ArtworksRelationships.md)
 - [ArtworksResourceObject](docs/ArtworksResourceObject.md)
 - [ArtworksSingleResourceDataDocument](docs/ArtworksSingleResourceDataDocument.md)
 - [AudioNormalizationData](docs/AudioNormalizationData.md)
 - [ClientsAttributes](docs/ClientsAttributes.md)
 - [ClientsCreateOperationPayload](docs/ClientsCreateOperationPayload.md)
 - [ClientsCreateOperationPayloadData](docs/ClientsCreateOperationPayloadData.md)
 - [ClientsCreateOperationPayloadDataAttributes](docs/ClientsCreateOperationPayloadDataAttributes.md)
 - [ClientsCreateSingleResourceDataDocument](docs/ClientsCreateSingleResourceDataDocument.md)
 - [ClientsMultiRelationshipDataDocument](docs/ClientsMultiRelationshipDataDocument.md)
 - [ClientsMultiResourceDataDocument](docs/ClientsMultiResourceDataDocument.md)
 - [ClientsRelationships](docs/ClientsRelationships.md)
 - [ClientsResourceObject](docs/ClientsResourceObject.md)
 - [ClientsSingleResourceDataDocument](docs/ClientsSingleResourceDataDocument.md)
 - [ClientsUpdateOperationPayload](docs/ClientsUpdateOperationPayload.md)
 - [ClientsUpdateOperationPayloadData](docs/ClientsUpdateOperationPayloadData.md)
 - [ClientsUpdateOperationPayloadDataAttributes](docs/ClientsUpdateOperationPayloadDataAttributes.md)
 - [ClientsUpdateSingleResourceDataDocument](docs/ClientsUpdateSingleResourceDataDocument.md)
 - [CollaborationInviteRedemptionsAttributes](docs/CollaborationInviteRedemptionsAttributes.md)
 - [CollaborationInviteRedemptionsCreateOperationPayload](docs/CollaborationInviteRedemptionsCreateOperationPayload.md)
 - [CollaborationInviteRedemptionsCreateOperationPayloadData](docs/CollaborationInviteRedemptionsCreateOperationPayloadData.md)
 - [CollaborationInviteRedemptionsCreateOperationPayloadDataRelationships](docs/CollaborationInviteRedemptionsCreateOperationPayloadDataRelationships.md)
 - [CollaborationInviteRedemptionsCreateOperationPayloadDataRelationshipsInvite](docs/CollaborationInviteRedemptionsCreateOperationPayloadDataRelationshipsInvite.md)
 - [CollaborationInviteRedemptionsCreateOperationPayloadDataRelationshipsInviteData](docs/CollaborationInviteRedemptionsCreateOperationPayloadDataRelationshipsInviteData.md)
 - [CollaborationInviteRedemptionsCreateSingleResourceDataDocument](docs/CollaborationInviteRedemptionsCreateSingleResourceDataDocument.md)
 - [CollaborationInviteRedemptionsResourceObject](docs/CollaborationInviteRedemptionsResourceObject.md)
 - [CollaborationInvitesAttributes](docs/CollaborationInvitesAttributes.md)
 - [CollaborationInvitesCreateOperationPayload](docs/CollaborationInvitesCreateOperationPayload.md)
 - [CollaborationInvitesCreateOperationPayloadData](docs/CollaborationInvitesCreateOperationPayloadData.md)
 - [CollaborationInvitesCreateOperationPayloadDataRelationships](docs/CollaborationInvitesCreateOperationPayloadDataRelationships.md)
 - [CollaborationInvitesCreateOperationPayloadDataRelationshipsSubject](docs/CollaborationInvitesCreateOperationPayloadDataRelationshipsSubject.md)
 - [CollaborationInvitesCreateOperationPayloadDataRelationshipsSubjectData](docs/CollaborationInvitesCreateOperationPayloadDataRelationshipsSubjectData.md)
 - [CollaborationInvitesCreateSingleResourceDataDocument](docs/CollaborationInvitesCreateSingleResourceDataDocument.md)
 - [CollaborationInvitesMultiRelationshipDataDocument](docs/CollaborationInvitesMultiRelationshipDataDocument.md)
 - [CollaborationInvitesMultiResourceDataDocument](docs/CollaborationInvitesMultiResourceDataDocument.md)
 - [CollaborationInvitesRelationships](docs/CollaborationInvitesRelationships.md)
 - [CollaborationInvitesResourceObject](docs/CollaborationInvitesResourceObject.md)
 - [CollaborationInvitesSingleRelationshipDataDocument](docs/CollaborationInvitesSingleRelationshipDataDocument.md)
 - [CollaborationInvitesSingleResourceDataDocument](docs/CollaborationInvitesSingleResourceDataDocument.md)
 - [CommentsAttributes](docs/CommentsAttributes.md)
 - [CommentsCreateOperationPayload](docs/CommentsCreateOperationPayload.md)
 - [CommentsCreateOperationPayloadData](docs/CommentsCreateOperationPayloadData.md)
 - [CommentsCreateOperationPayloadDataAttributes](docs/CommentsCreateOperationPayloadDataAttributes.md)
 - [CommentsCreateOperationPayloadDataRelationships](docs/CommentsCreateOperationPayloadDataRelationships.md)
 - [CommentsCreateOperationPayloadDataRelationshipsParentComment](docs/CommentsCreateOperationPayloadDataRelationshipsParentComment.md)
 - [CommentsCreateOperationPayloadDataRelationshipsParentCommentData](docs/CommentsCreateOperationPayloadDataRelationshipsParentCommentData.md)
 - [CommentsCreateOperationPayloadDataRelationshipsSubject](docs/CommentsCreateOperationPayloadDataRelationshipsSubject.md)
 - [CommentsCreateOperationPayloadDataRelationshipsSubjectData](docs/CommentsCreateOperationPayloadDataRelationshipsSubjectData.md)
 - [CommentsCreateSingleResourceDataDocument](docs/CommentsCreateSingleResourceDataDocument.md)
 - [CommentsMultiRelationshipDataDocument](docs/CommentsMultiRelationshipDataDocument.md)
 - [CommentsMultiResourceDataDocument](docs/CommentsMultiResourceDataDocument.md)
 - [CommentsRelationships](docs/CommentsRelationships.md)
 - [CommentsResourceObject](docs/CommentsResourceObject.md)
 - [CommentsSingleRelationshipDataDocument](docs/CommentsSingleRelationshipDataDocument.md)
 - [CommentsSingleResourceDataDocument](docs/CommentsSingleResourceDataDocument.md)
 - [CommentsUpdateOperationPayload](docs/CommentsUpdateOperationPayload.md)
 - [CommentsUpdateOperationPayloadData](docs/CommentsUpdateOperationPayloadData.md)
 - [CommentsUpdateOperationPayloadDataAttributes](docs/CommentsUpdateOperationPayloadDataAttributes.md)
 - [ContentClaimsAttributes](docs/ContentClaimsAttributes.md)
 - [ContentClaimsClaimedResourceResourceIdentifier](docs/ContentClaimsClaimedResourceResourceIdentifier.md)
 - [ContentClaimsClaimedResourceResourceIdentifierMeta](docs/ContentClaimsClaimedResourceResourceIdentifierMeta.md)
 - [ContentClaimsClaimedResourceSingleRelationshipDataDocument](docs/ContentClaimsClaimedResourceSingleRelationshipDataDocument.md)
 - [ContentClaimsCreateOperationPayload](docs/ContentClaimsCreateOperationPayload.md)
 - [ContentClaimsCreateOperationPayloadData](docs/ContentClaimsCreateOperationPayloadData.md)
 - [ContentClaimsCreateOperationPayloadDataAttributes](docs/ContentClaimsCreateOperationPayloadDataAttributes.md)
 - [ContentClaimsCreateOperationPayloadDataRelationships](docs/ContentClaimsCreateOperationPayloadDataRelationships.md)
 - [ContentClaimsCreateOperationPayloadDataRelationshipsClaimedResource](docs/ContentClaimsCreateOperationPayloadDataRelationshipsClaimedResource.md)
 - [ContentClaimsCreateOperationPayloadDataRelationshipsClaimedResourceData](docs/ContentClaimsCreateOperationPayloadDataRelationshipsClaimedResourceData.md)
 - [ContentClaimsCreateOperationPayloadDataRelationshipsClaimingArtist](docs/ContentClaimsCreateOperationPayloadDataRelationshipsClaimingArtist.md)
 - [ContentClaimsCreateOperationPayloadDataRelationshipsClaimingArtistData](docs/ContentClaimsCreateOperationPayloadDataRelationshipsClaimingArtistData.md)
 - [ContentClaimsCreateSingleResourceDataDocument](docs/ContentClaimsCreateSingleResourceDataDocument.md)
 - [ContentClaimsMultiRelationshipDataDocument](docs/ContentClaimsMultiRelationshipDataDocument.md)
 - [ContentClaimsMultiResourceDataDocument](docs/ContentClaimsMultiResourceDataDocument.md)
 - [ContentClaimsRelationships](docs/ContentClaimsRelationships.md)
 - [ContentClaimsResourceObject](docs/ContentClaimsResourceObject.md)
 - [ContentClaimsSingleRelationshipDataDocument](docs/ContentClaimsSingleRelationshipDataDocument.md)
 - [ContentClaimsSingleResourceDataDocument](docs/ContentClaimsSingleResourceDataDocument.md)
 - [Copyright](docs/Copyright.md)
 - [CreditsAttributes](docs/CreditsAttributes.md)
 - [CreditsRelationships](docs/CreditsRelationships.md)
 - [CreditsResourceObject](docs/CreditsResourceObject.md)
 - [CreditsSingleRelationshipDataDocument](docs/CreditsSingleRelationshipDataDocument.md)
 - [CreditsSingleResourceDataDocument](docs/CreditsSingleResourceDataDocument.md)
 - [CurrentUserReaction](docs/CurrentUserReaction.md)
 - [Default400ResponseBody](docs/Default400ResponseBody.md)
 - [Default400ResponseBodyErrorsInner](docs/Default400ResponseBodyErrorsInner.md)
 - [Default404ResponseBody](docs/Default404ResponseBody.md)
 - [Default404ResponseBodyErrorsInner](docs/Default404ResponseBodyErrorsInner.md)
 - [Default405ResponseBody](docs/Default405ResponseBody.md)
 - [Default405ResponseBodyErrorsInner](docs/Default405ResponseBodyErrorsInner.md)
 - [Default406ResponseBody](docs/Default406ResponseBody.md)
 - [Default406ResponseBodyErrorsInner](docs/Default406ResponseBodyErrorsInner.md)
 - [Default415ResponseBody](docs/Default415ResponseBody.md)
 - [Default415ResponseBodyErrorsInner](docs/Default415ResponseBodyErrorsInner.md)
 - [Default429ResponseBody](docs/Default429ResponseBody.md)
 - [Default429ResponseBodyErrorsInner](docs/Default429ResponseBodyErrorsInner.md)
 - [Default500ResponseBody](docs/Default500ResponseBody.md)
 - [Default500ResponseBodyErrorsInner](docs/Default500ResponseBodyErrorsInner.md)
 - [Default503ResponseBody](docs/Default503ResponseBody.md)
 - [Default503ResponseBodyErrorsInner](docs/Default503ResponseBodyErrorsInner.md)
 - [DownloadLink](docs/DownloadLink.md)
 - [DownloadLinkMeta](docs/DownloadLinkMeta.md)
 - [DownloadsAttributes](docs/DownloadsAttributes.md)
 - [DownloadsMultiRelationshipDataDocument](docs/DownloadsMultiRelationshipDataDocument.md)
 - [DownloadsMultiResourceDataDocument](docs/DownloadsMultiResourceDataDocument.md)
 - [DownloadsRelationships](docs/DownloadsRelationships.md)
 - [DownloadsResourceObject](docs/DownloadsResourceObject.md)
 - [DownloadsSingleResourceDataDocument](docs/DownloadsSingleResourceDataDocument.md)
 - [DrmData](docs/DrmData.md)
 - [DspSharingLinksAttributes](docs/DspSharingLinksAttributes.md)
 - [DspSharingLinksMultiResourceDataDocument](docs/DspSharingLinksMultiResourceDataDocument.md)
 - [DspSharingLinksRelationships](docs/DspSharingLinksRelationships.md)
 - [DspSharingLinksResourceObject](docs/DspSharingLinksResourceObject.md)
 - [DspSharingLinksSingleRelationshipDataDocument](docs/DspSharingLinksSingleRelationshipDataDocument.md)
 - [DspSharingLinksSubjectResourceIdentifier](docs/DspSharingLinksSubjectResourceIdentifier.md)
 - [DspSharingLinksSubjectResourceIdentifierMeta](docs/DspSharingLinksSubjectResourceIdentifierMeta.md)
 - [DspSharingLinksSubjectSingleRelationshipDataDocument](docs/DspSharingLinksSubjectSingleRelationshipDataDocument.md)
 - [DynamicModulesAttributes](docs/DynamicModulesAttributes.md)
 - [DynamicModulesItemsMultiRelationshipDataDocument](docs/DynamicModulesItemsMultiRelationshipDataDocument.md)
 - [DynamicModulesItemsResourceIdentifier](docs/DynamicModulesItemsResourceIdentifier.md)
 - [DynamicModulesItemsResourceIdentifierMeta](docs/DynamicModulesItemsResourceIdentifierMeta.md)
 - [DynamicModulesMultiRelationshipDataDocument](docs/DynamicModulesMultiRelationshipDataDocument.md)
 - [DynamicModulesMultiResourceDataDocument](docs/DynamicModulesMultiResourceDataDocument.md)
 - [DynamicModulesRelationships](docs/DynamicModulesRelationships.md)
 - [DynamicModulesResourceObject](docs/DynamicModulesResourceObject.md)
 - [DynamicModulesSeedItemResourceIdentifier](docs/DynamicModulesSeedItemResourceIdentifier.md)
 - [DynamicModulesSeedItemResourceIdentifierMeta](docs/DynamicModulesSeedItemResourceIdentifierMeta.md)
 - [DynamicModulesSeedItemSingleRelationshipDataDocument](docs/DynamicModulesSeedItemSingleRelationshipDataDocument.md)
 - [DynamicModulesSingleRelationshipDataDocument](docs/DynamicModulesSingleRelationshipDataDocument.md)
 - [DynamicModulesSingleResourceDataDocument](docs/DynamicModulesSingleResourceDataDocument.md)
 - [DynamicPagesAttributes](docs/DynamicPagesAttributes.md)
 - [DynamicPagesMultiRelationshipDataDocument](docs/DynamicPagesMultiRelationshipDataDocument.md)
 - [DynamicPagesMultiResourceDataDocument](docs/DynamicPagesMultiResourceDataDocument.md)
 - [DynamicPagesRelationships](docs/DynamicPagesRelationships.md)
 - [DynamicPagesResourceObject](docs/DynamicPagesResourceObject.md)
 - [DynamicPagesResourceObjectMeta](docs/DynamicPagesResourceObjectMeta.md)
 - [DynamicPagesSingleRelationshipDataDocument](docs/DynamicPagesSingleRelationshipDataDocument.md)
 - [DynamicPagesSubjectResourceIdentifier](docs/DynamicPagesSubjectResourceIdentifier.md)
 - [DynamicPagesSubjectResourceIdentifierMeta](docs/DynamicPagesSubjectResourceIdentifierMeta.md)
 - [DynamicPagesSubjectSingleRelationshipDataDocument](docs/DynamicPagesSubjectSingleRelationshipDataDocument.md)
 - [ErrorObject](docs/ErrorObject.md)
 - [ErrorObjectSource](docs/ErrorObjectSource.md)
 - [ErrorsDocument](docs/ErrorsDocument.md)
 - [ExternalLink](docs/ExternalLink.md)
 - [ExternalLinkMeta](docs/ExternalLinkMeta.md)
 - [ExternalLinkPayload](docs/ExternalLinkPayload.md)
 - [FileStatus](docs/FileStatus.md)
 - [FileUploadLink](docs/FileUploadLink.md)
 - [FileUploadLinkMeta](docs/FileUploadLinkMeta.md)
 - [GenresAttributes](docs/GenresAttributes.md)
 - [GenresMultiResourceDataDocument](docs/GenresMultiResourceDataDocument.md)
 - [GenresResourceObject](docs/GenresResourceObject.md)
 - [GenresSingleResourceDataDocument](docs/GenresSingleResourceDataDocument.md)
 - [Idempotency409ResponseBody](docs/Idempotency409ResponseBody.md)
 - [Idempotency409ResponseBodyErrorsInner](docs/Idempotency409ResponseBodyErrorsInner.md)
 - [Idempotency422ResponseBody](docs/Idempotency422ResponseBody.md)
 - [Idempotency422ResponseBodyErrorsInner](docs/Idempotency422ResponseBodyErrorsInner.md)
 - [IncludedInner](docs/IncludedInner.md)
 - [InstallationsAttributes](docs/InstallationsAttributes.md)
 - [InstallationsCreateOperationPayload](docs/InstallationsCreateOperationPayload.md)
 - [InstallationsCreateOperationPayloadData](docs/InstallationsCreateOperationPayloadData.md)
 - [InstallationsCreateOperationPayloadDataAttributes](docs/InstallationsCreateOperationPayloadDataAttributes.md)
 - [InstallationsCreateSingleResourceDataDocument](docs/InstallationsCreateSingleResourceDataDocument.md)
 - [InstallationsMultiRelationshipDataDocument](docs/InstallationsMultiRelationshipDataDocument.md)
 - [InstallationsMultiResourceDataDocument](docs/InstallationsMultiResourceDataDocument.md)
 - [InstallationsOfflineInventoryItemIdentifier](docs/InstallationsOfflineInventoryItemIdentifier.md)
 - [InstallationsOfflineInventoryMultiRelationshipDataDocument](docs/InstallationsOfflineInventoryMultiRelationshipDataDocument.md)
 - [InstallationsOfflineInventoryRelationshipAddOperationPayload](docs/InstallationsOfflineInventoryRelationshipAddOperationPayload.md)
 - [InstallationsOfflineInventoryRelationshipRemoveOperationPayload](docs/InstallationsOfflineInventoryRelationshipRemoveOperationPayload.md)
 - [InstallationsOfflineInventoryResourceIdentifier](docs/InstallationsOfflineInventoryResourceIdentifier.md)
 - [InstallationsOfflineInventoryResourceIdentifierMeta](docs/InstallationsOfflineInventoryResourceIdentifierMeta.md)
 - [InstallationsRelationships](docs/InstallationsRelationships.md)
 - [InstallationsResourceObject](docs/InstallationsResourceObject.md)
 - [InstallationsSingleResourceDataDocument](docs/InstallationsSingleResourceDataDocument.md)
 - [LegacyBarcodeId](docs/LegacyBarcodeId.md)
 - [LegacySource](docs/LegacySource.md)
 - [LinkObject](docs/LinkObject.md)
 - [Links](docs/Links.md)
 - [LinksMeta](docs/LinksMeta.md)
 - [LyricsAttributes](docs/LyricsAttributes.md)
 - [LyricsAttributesProvider](docs/LyricsAttributesProvider.md)
 - [LyricsCreateOperationPayload](docs/LyricsCreateOperationPayload.md)
 - [LyricsCreateOperationPayloadData](docs/LyricsCreateOperationPayloadData.md)
 - [LyricsCreateOperationPayloadDataAttributes](docs/LyricsCreateOperationPayloadDataAttributes.md)
 - [LyricsCreateOperationPayloadDataRelationships](docs/LyricsCreateOperationPayloadDataRelationships.md)
 - [LyricsCreateOperationPayloadDataRelationshipsTrack](docs/LyricsCreateOperationPayloadDataRelationshipsTrack.md)
 - [LyricsCreateOperationPayloadDataRelationshipsTrackData](docs/LyricsCreateOperationPayloadDataRelationshipsTrackData.md)
 - [LyricsCreateOperationPayloadMeta](docs/LyricsCreateOperationPayloadMeta.md)
 - [LyricsCreateSingleResourceDataDocument](docs/LyricsCreateSingleResourceDataDocument.md)
 - [LyricsMultiRelationshipDataDocument](docs/LyricsMultiRelationshipDataDocument.md)
 - [LyricsProvider](docs/LyricsProvider.md)
 - [LyricsRelationships](docs/LyricsRelationships.md)
 - [LyricsResourceObject](docs/LyricsResourceObject.md)
 - [LyricsSingleRelationshipDataDocument](docs/LyricsSingleRelationshipDataDocument.md)
 - [LyricsSingleResourceDataDocument](docs/LyricsSingleResourceDataDocument.md)
 - [LyricsTrackResourceIdentifier](docs/LyricsTrackResourceIdentifier.md)
 - [LyricsTrackResourceIdentifierMeta](docs/LyricsTrackResourceIdentifierMeta.md)
 - [LyricsTrackSingleRelationshipDataDocument](docs/LyricsTrackSingleRelationshipDataDocument.md)
 - [LyricsUpdateOperationPayload](docs/LyricsUpdateOperationPayload.md)
 - [LyricsUpdateOperationPayloadData](docs/LyricsUpdateOperationPayloadData.md)
 - [LyricsUpdateOperationPayloadDataAttributes](docs/LyricsUpdateOperationPayloadDataAttributes.md)
 - [ManualArtistClaimsAttributes](docs/ManualArtistClaimsAttributes.md)
 - [ManualArtistClaimsCreateOperationPayload](docs/ManualArtistClaimsCreateOperationPayload.md)
 - [ManualArtistClaimsCreateOperationPayloadData](docs/ManualArtistClaimsCreateOperationPayloadData.md)
 - [ManualArtistClaimsCreateOperationPayloadDataAttributes](docs/ManualArtistClaimsCreateOperationPayloadDataAttributes.md)
 - [ManualArtistClaimsCreateSingleResourceDataDocument](docs/ManualArtistClaimsCreateSingleResourceDataDocument.md)
 - [ManualArtistClaimsResourceObject](docs/ManualArtistClaimsResourceObject.md)
 - [MultiRelationshipDataDocument](docs/MultiRelationshipDataDocument.md)
 - [OfflineTasksAttributes](docs/OfflineTasksAttributes.md)
 - [OfflineTasksCollectionResourceIdentifier](docs/OfflineTasksCollectionResourceIdentifier.md)
 - [OfflineTasksCollectionResourceIdentifierMeta](docs/OfflineTasksCollectionResourceIdentifierMeta.md)
 - [OfflineTasksCollectionSingleRelationshipDataDocument](docs/OfflineTasksCollectionSingleRelationshipDataDocument.md)
 - [OfflineTasksItemResourceIdentifier](docs/OfflineTasksItemResourceIdentifier.md)
 - [OfflineTasksItemResourceIdentifierMeta](docs/OfflineTasksItemResourceIdentifierMeta.md)
 - [OfflineTasksItemSingleRelationshipDataDocument](docs/OfflineTasksItemSingleRelationshipDataDocument.md)
 - [OfflineTasksMultiRelationshipDataDocument](docs/OfflineTasksMultiRelationshipDataDocument.md)
 - [OfflineTasksMultiResourceDataDocument](docs/OfflineTasksMultiResourceDataDocument.md)
 - [OfflineTasksRelationships](docs/OfflineTasksRelationships.md)
 - [OfflineTasksResourceObject](docs/OfflineTasksResourceObject.md)
 - [OfflineTasksSingleRelationshipDataDocument](docs/OfflineTasksSingleRelationshipDataDocument.md)
 - [OfflineTasksSingleResourceDataDocument](docs/OfflineTasksSingleResourceDataDocument.md)
 - [OfflineTasksUpdateOperationPayload](docs/OfflineTasksUpdateOperationPayload.md)
 - [OfflineTasksUpdateOperationPayloadData](docs/OfflineTasksUpdateOperationPayloadData.md)
 - [OfflineTasksUpdateOperationPayloadDataAttributes](docs/OfflineTasksUpdateOperationPayloadDataAttributes.md)
 - [PlayQueuesAttributes](docs/PlayQueuesAttributes.md)
 - [PlayQueuesCreateOperationPayload](docs/PlayQueuesCreateOperationPayload.md)
 - [PlayQueuesCreateOperationPayloadData](docs/PlayQueuesCreateOperationPayloadData.md)
 - [PlayQueuesCreateSingleResourceDataDocument](docs/PlayQueuesCreateSingleResourceDataDocument.md)
 - [PlayQueuesCurrentRelationshipUpdateOperationPayload](docs/PlayQueuesCurrentRelationshipUpdateOperationPayload.md)
 - [PlayQueuesCurrentRelationshipUpdateOperationPayloadData](docs/PlayQueuesCurrentRelationshipUpdateOperationPayloadData.md)
 - [PlayQueuesCurrentRelationshipUpdateOperationPayloadDataMeta](docs/PlayQueuesCurrentRelationshipUpdateOperationPayloadDataMeta.md)
 - [PlayQueuesCurrentResourceIdentifier](docs/PlayQueuesCurrentResourceIdentifier.md)
 - [PlayQueuesCurrentResourceIdentifierMeta](docs/PlayQueuesCurrentResourceIdentifierMeta.md)
 - [PlayQueuesCurrentSingleRelationshipDataDocument](docs/PlayQueuesCurrentSingleRelationshipDataDocument.md)
 - [PlayQueuesFutureMultiRelationshipDataDocument](docs/PlayQueuesFutureMultiRelationshipDataDocument.md)
 - [PlayQueuesFutureRelationshipAddOperationPayload](docs/PlayQueuesFutureRelationshipAddOperationPayload.md)
 - [PlayQueuesFutureRelationshipAddOperationPayloadData](docs/PlayQueuesFutureRelationshipAddOperationPayloadData.md)
 - [PlayQueuesFutureRelationshipAddOperationPayloadDataMeta](docs/PlayQueuesFutureRelationshipAddOperationPayloadDataMeta.md)
 - [PlayQueuesFutureRelationshipAddOperationPayloadMeta](docs/PlayQueuesFutureRelationshipAddOperationPayloadMeta.md)
 - [PlayQueuesFutureRelationshipRemoveOperationPayload](docs/PlayQueuesFutureRelationshipRemoveOperationPayload.md)
 - [PlayQueuesFutureRelationshipRemoveOperationPayloadData](docs/PlayQueuesFutureRelationshipRemoveOperationPayloadData.md)
 - [PlayQueuesFutureRelationshipRemoveOperationPayloadDataMeta](docs/PlayQueuesFutureRelationshipRemoveOperationPayloadDataMeta.md)
 - [PlayQueuesFutureRelationshipUpdateOperationPayload](docs/PlayQueuesFutureRelationshipUpdateOperationPayload.md)
 - [PlayQueuesFutureRelationshipUpdateOperationPayloadData](docs/PlayQueuesFutureRelationshipUpdateOperationPayloadData.md)
 - [PlayQueuesFutureRelationshipUpdateOperationPayloadDataMeta](docs/PlayQueuesFutureRelationshipUpdateOperationPayloadDataMeta.md)
 - [PlayQueuesFutureRelationshipUpdateOperationPayloadMeta](docs/PlayQueuesFutureRelationshipUpdateOperationPayloadMeta.md)
 - [PlayQueuesFutureResourceIdentifier](docs/PlayQueuesFutureResourceIdentifier.md)
 - [PlayQueuesFutureResourceIdentifierMeta](docs/PlayQueuesFutureResourceIdentifierMeta.md)
 - [PlayQueuesMultiRelationshipDataDocument](docs/PlayQueuesMultiRelationshipDataDocument.md)
 - [PlayQueuesMultiResourceDataDocument](docs/PlayQueuesMultiResourceDataDocument.md)
 - [PlayQueuesPastMultiRelationshipDataDocument](docs/PlayQueuesPastMultiRelationshipDataDocument.md)
 - [PlayQueuesPastResourceIdentifier](docs/PlayQueuesPastResourceIdentifier.md)
 - [PlayQueuesPastResourceIdentifierMeta](docs/PlayQueuesPastResourceIdentifierMeta.md)
 - [PlayQueuesRelationships](docs/PlayQueuesRelationships.md)
 - [PlayQueuesResourceObject](docs/PlayQueuesResourceObject.md)
 - [PlayQueuesSingleRelationshipDataDocument](docs/PlayQueuesSingleRelationshipDataDocument.md)
 - [PlayQueuesSingleResourceDataDocument](docs/PlayQueuesSingleResourceDataDocument.md)
 - [PlayQueuesUpdateOperationPayload](docs/PlayQueuesUpdateOperationPayload.md)
 - [PlayQueuesUpdateOperationPayloadData](docs/PlayQueuesUpdateOperationPayloadData.md)
 - [PlayQueuesUpdateOperationPayloadDataAttributes](docs/PlayQueuesUpdateOperationPayloadDataAttributes.md)
 - [PlaylistsAttributes](docs/PlaylistsAttributes.md)
 - [PlaylistsCollaboratorProfilesRelationshipAddOperationPayload](docs/PlaylistsCollaboratorProfilesRelationshipAddOperationPayload.md)
 - [PlaylistsCollaboratorProfilesRelationshipAddOperationPayloadData](docs/PlaylistsCollaboratorProfilesRelationshipAddOperationPayloadData.md)
 - [PlaylistsCollaboratorProfilesRelationshipRemoveOperationPayload](docs/PlaylistsCollaboratorProfilesRelationshipRemoveOperationPayload.md)
 - [PlaylistsCollaboratorProfilesRelationshipRemoveOperationPayloadData](docs/PlaylistsCollaboratorProfilesRelationshipRemoveOperationPayloadData.md)
 - [PlaylistsCoverArtRelationshipUpdateOperationPayload](docs/PlaylistsCoverArtRelationshipUpdateOperationPayload.md)
 - [PlaylistsCoverArtRelationshipUpdateOperationPayloadData](docs/PlaylistsCoverArtRelationshipUpdateOperationPayloadData.md)
 - [PlaylistsCreateOperationPayload](docs/PlaylistsCreateOperationPayload.md)
 - [PlaylistsCreateOperationPayloadData](docs/PlaylistsCreateOperationPayloadData.md)
 - [PlaylistsCreateOperationPayloadDataAttributes](docs/PlaylistsCreateOperationPayloadDataAttributes.md)
 - [PlaylistsCreateSingleResourceDataDocument](docs/PlaylistsCreateSingleResourceDataDocument.md)
 - [PlaylistsItemsAddMultiRelationshipDataDocument](docs/PlaylistsItemsAddMultiRelationshipDataDocument.md)
 - [PlaylistsItemsAddMultiRelationshipDataDocumentMeta](docs/PlaylistsItemsAddMultiRelationshipDataDocumentMeta.md)
 - [PlaylistsItemsAddResourceIdentifier](docs/PlaylistsItemsAddResourceIdentifier.md)
 - [PlaylistsItemsAddResourceIdentifierMeta](docs/PlaylistsItemsAddResourceIdentifierMeta.md)
 - [PlaylistsItemsMultiRelationshipDataDocument](docs/PlaylistsItemsMultiRelationshipDataDocument.md)
 - [PlaylistsItemsRelationshipAddOperationPayload](docs/PlaylistsItemsRelationshipAddOperationPayload.md)
 - [PlaylistsItemsRelationshipAddOperationPayloadData](docs/PlaylistsItemsRelationshipAddOperationPayloadData.md)
 - [PlaylistsItemsRelationshipAddOperationPayloadDataMeta](docs/PlaylistsItemsRelationshipAddOperationPayloadDataMeta.md)
 - [PlaylistsItemsRelationshipAddOperationPayloadMeta](docs/PlaylistsItemsRelationshipAddOperationPayloadMeta.md)
 - [PlaylistsItemsRelationshipAddOperationResponseMetaSkippedItem](docs/PlaylistsItemsRelationshipAddOperationResponseMetaSkippedItem.md)
 - [PlaylistsItemsRelationshipRemoveOperationPayload](docs/PlaylistsItemsRelationshipRemoveOperationPayload.md)
 - [PlaylistsItemsRelationshipRemoveOperationPayloadData](docs/PlaylistsItemsRelationshipRemoveOperationPayloadData.md)
 - [PlaylistsItemsRelationshipRemoveOperationPayloadDataMeta](docs/PlaylistsItemsRelationshipRemoveOperationPayloadDataMeta.md)
 - [PlaylistsItemsRelationshipUpdateOperationPayload](docs/PlaylistsItemsRelationshipUpdateOperationPayload.md)
 - [PlaylistsItemsRelationshipUpdateOperationPayloadData](docs/PlaylistsItemsRelationshipUpdateOperationPayloadData.md)
 - [PlaylistsItemsRelationshipUpdateOperationPayloadDataMeta](docs/PlaylistsItemsRelationshipUpdateOperationPayloadDataMeta.md)
 - [PlaylistsItemsRelationshipUpdateOperationPayloadMeta](docs/PlaylistsItemsRelationshipUpdateOperationPayloadMeta.md)
 - [PlaylistsItemsResourceIdentifier](docs/PlaylistsItemsResourceIdentifier.md)
 - [PlaylistsItemsResourceIdentifierMeta](docs/PlaylistsItemsResourceIdentifierMeta.md)
 - [PlaylistsMultiRelationshipDataDocument](docs/PlaylistsMultiRelationshipDataDocument.md)
 - [PlaylistsMultiResourceDataDocument](docs/PlaylistsMultiResourceDataDocument.md)
 - [PlaylistsRelationships](docs/PlaylistsRelationships.md)
 - [PlaylistsResourceObject](docs/PlaylistsResourceObject.md)
 - [PlaylistsSingleResourceDataDocument](docs/PlaylistsSingleResourceDataDocument.md)
 - [PlaylistsSuggestedCoverArtsMultiRelationshipDataDocument](docs/PlaylistsSuggestedCoverArtsMultiRelationshipDataDocument.md)
 - [PlaylistsSuggestedCoverArtsResourceIdentifier](docs/PlaylistsSuggestedCoverArtsResourceIdentifier.md)
 - [PlaylistsSuggestedCoverArtsResourceIdentifierMeta](docs/PlaylistsSuggestedCoverArtsResourceIdentifierMeta.md)
 - [PlaylistsUpdateOperationPayload](docs/PlaylistsUpdateOperationPayload.md)
 - [PlaylistsUpdateOperationPayloadData](docs/PlaylistsUpdateOperationPayloadData.md)
 - [PlaylistsUpdateOperationPayloadDataAttributes](docs/PlaylistsUpdateOperationPayloadDataAttributes.md)
 - [PlaylistsUpdateSingleResourceDataDocument](docs/PlaylistsUpdateSingleResourceDataDocument.md)
 - [PriceConfigurationsAttributes](docs/PriceConfigurationsAttributes.md)
 - [PriceConfigurationsCreateOperationPayload](docs/PriceConfigurationsCreateOperationPayload.md)
 - [PriceConfigurationsCreateOperationPayloadData](docs/PriceConfigurationsCreateOperationPayloadData.md)
 - [PriceConfigurationsCreateOperationPayloadDataAttributes](docs/PriceConfigurationsCreateOperationPayloadDataAttributes.md)
 - [PriceConfigurationsCreateOperationPayloadDataRelationships](docs/PriceConfigurationsCreateOperationPayloadDataRelationships.md)
 - [PriceConfigurationsCreateOperationPayloadDataRelationshipsSubjects](docs/PriceConfigurationsCreateOperationPayloadDataRelationshipsSubjects.md)
 - [PriceConfigurationsCreateOperationPayloadSubjects](docs/PriceConfigurationsCreateOperationPayloadSubjects.md)
 - [PriceConfigurationsCreateSingleResourceDataDocument](docs/PriceConfigurationsCreateSingleResourceDataDocument.md)
 - [PriceConfigurationsMultiResourceDataDocument](docs/PriceConfigurationsMultiResourceDataDocument.md)
 - [PriceConfigurationsResourceObject](docs/PriceConfigurationsResourceObject.md)
 - [PriceConfigurationsSingleResourceDataDocument](docs/PriceConfigurationsSingleResourceDataDocument.md)
 - [ProviderOwnersAttributes](docs/ProviderOwnersAttributes.md)
 - [ProviderOwnersMultiRelationshipDataDocument](docs/ProviderOwnersMultiRelationshipDataDocument.md)
 - [ProviderOwnersMultiResourceDataDocument](docs/ProviderOwnersMultiResourceDataDocument.md)
 - [ProviderOwnersRelationships](docs/ProviderOwnersRelationships.md)
 - [ProviderOwnersResourceObject](docs/ProviderOwnersResourceObject.md)
 - [ProviderOwnersSingleRelationshipDataDocument](docs/ProviderOwnersSingleRelationshipDataDocument.md)
 - [ProviderProductInfosAttributes](docs/ProviderProductInfosAttributes.md)
 - [ProviderProductInfosMultiResourceDataDocument](docs/ProviderProductInfosMultiResourceDataDocument.md)
 - [ProviderProductInfosRelationships](docs/ProviderProductInfosRelationships.md)
 - [ProviderProductInfosResourceObject](docs/ProviderProductInfosResourceObject.md)
 - [ProviderProductInfosSingleRelationshipDataDocument](docs/ProviderProductInfosSingleRelationshipDataDocument.md)
 - [ProviderProductInfosSubjectResourceIdentifier](docs/ProviderProductInfosSubjectResourceIdentifier.md)
 - [ProviderProductInfosSubjectResourceIdentifierMeta](docs/ProviderProductInfosSubjectResourceIdentifierMeta.md)
 - [ProviderProductInfosSubjectSingleRelationshipDataDocument](docs/ProviderProductInfosSubjectSingleRelationshipDataDocument.md)
 - [ProvidersAttributes](docs/ProvidersAttributes.md)
 - [ProvidersResourceObject](docs/ProvidersResourceObject.md)
 - [ProvidersSingleResourceDataDocument](docs/ProvidersSingleResourceDataDocument.md)
 - [PurchasesAttributes](docs/PurchasesAttributes.md)
 - [PurchasesMultiRelationshipDataDocument](docs/PurchasesMultiRelationshipDataDocument.md)
 - [PurchasesMultiResourceDataDocument](docs/PurchasesMultiResourceDataDocument.md)
 - [PurchasesRelationships](docs/PurchasesRelationships.md)
 - [PurchasesResourceObject](docs/PurchasesResourceObject.md)
 - [PurchasesSingleRelationshipDataDocument](docs/PurchasesSingleRelationshipDataDocument.md)
 - [PurchasesSubjectResourceIdentifier](docs/PurchasesSubjectResourceIdentifier.md)
 - [PurchasesSubjectResourceIdentifierMeta](docs/PurchasesSubjectResourceIdentifierMeta.md)
 - [PurchasesSubjectSingleRelationshipDataDocument](docs/PurchasesSubjectSingleRelationshipDataDocument.md)
 - [ReactionStats](docs/ReactionStats.md)
 - [ReactionsAttributes](docs/ReactionsAttributes.md)
 - [ReactionsCreateOperationPayload](docs/ReactionsCreateOperationPayload.md)
 - [ReactionsCreateOperationPayloadData](docs/ReactionsCreateOperationPayloadData.md)
 - [ReactionsCreateOperationPayloadDataAttributes](docs/ReactionsCreateOperationPayloadDataAttributes.md)
 - [ReactionsCreateOperationPayloadDataRelationships](docs/ReactionsCreateOperationPayloadDataRelationships.md)
 - [ReactionsCreateOperationPayloadDataRelationshipsSubject](docs/ReactionsCreateOperationPayloadDataRelationshipsSubject.md)
 - [ReactionsCreateOperationPayloadDataRelationshipsSubjectData](docs/ReactionsCreateOperationPayloadDataRelationshipsSubjectData.md)
 - [ReactionsCreateSingleResourceDataDocument](docs/ReactionsCreateSingleResourceDataDocument.md)
 - [ReactionsMultiRelationshipDataDocument](docs/ReactionsMultiRelationshipDataDocument.md)
 - [ReactionsMultiResourceDataDocument](docs/ReactionsMultiResourceDataDocument.md)
 - [ReactionsMultiResourceDataDocumentMeta](docs/ReactionsMultiResourceDataDocumentMeta.md)
 - [ReactionsRelationships](docs/ReactionsRelationships.md)
 - [ReactionsResourceObject](docs/ReactionsResourceObject.md)
 - [ReplacementOriginalIdentifier](docs/ReplacementOriginalIdentifier.md)
 - [ReplacementProvenance](docs/ReplacementProvenance.md)
 - [ResourceIdentifier](docs/ResourceIdentifier.md)
 - [ResourceObjectObjectObject](docs/ResourceObjectObjectObject.md)
 - [SavedSharesAttributes](docs/SavedSharesAttributes.md)
 - [SavedSharesCreateOperationPayload](docs/SavedSharesCreateOperationPayload.md)
 - [SavedSharesCreateOperationPayloadData](docs/SavedSharesCreateOperationPayloadData.md)
 - [SavedSharesCreateOperationPayloadDataRelationships](docs/SavedSharesCreateOperationPayloadDataRelationships.md)
 - [SavedSharesCreateOperationPayloadDataRelationshipsShare](docs/SavedSharesCreateOperationPayloadDataRelationshipsShare.md)
 - [SavedSharesCreateOperationPayloadDataRelationshipsShareData](docs/SavedSharesCreateOperationPayloadDataRelationshipsShareData.md)
 - [SavedSharesCreateSingleResourceDataDocument](docs/SavedSharesCreateSingleResourceDataDocument.md)
 - [SavedSharesResourceObject](docs/SavedSharesResourceObject.md)
 - [ScopesAttributes](docs/ScopesAttributes.md)
 - [ScopesMultiResourceDataDocument](docs/ScopesMultiResourceDataDocument.md)
 - [ScopesResourceObject](docs/ScopesResourceObject.md)
 - [SearchHistoryEntriesAttributes](docs/SearchHistoryEntriesAttributes.md)
 - [SearchHistoryEntriesResourceObject](docs/SearchHistoryEntriesResourceObject.md)
 - [SearchResultsAlbumsMultiRelationshipDataDocument](docs/SearchResultsAlbumsMultiRelationshipDataDocument.md)
 - [SearchResultsAlbumsResourceIdentifier](docs/SearchResultsAlbumsResourceIdentifier.md)
 - [SearchResultsAlbumsResourceIdentifierMeta](docs/SearchResultsAlbumsResourceIdentifierMeta.md)
 - [SearchResultsArtistsMultiRelationshipDataDocument](docs/SearchResultsArtistsMultiRelationshipDataDocument.md)
 - [SearchResultsArtistsResourceIdentifier](docs/SearchResultsArtistsResourceIdentifier.md)
 - [SearchResultsArtistsResourceIdentifierMeta](docs/SearchResultsArtistsResourceIdentifierMeta.md)
 - [SearchResultsAttributes](docs/SearchResultsAttributes.md)
 - [SearchResultsMultiRelationshipDataDocument](docs/SearchResultsMultiRelationshipDataDocument.md)
 - [SearchResultsMultiResourceDataDocument](docs/SearchResultsMultiResourceDataDocument.md)
 - [SearchResultsPlaylistsMultiRelationshipDataDocument](docs/SearchResultsPlaylistsMultiRelationshipDataDocument.md)
 - [SearchResultsPlaylistsResourceIdentifier](docs/SearchResultsPlaylistsResourceIdentifier.md)
 - [SearchResultsPlaylistsResourceIdentifierMeta](docs/SearchResultsPlaylistsResourceIdentifierMeta.md)
 - [SearchResultsRelationships](docs/SearchResultsRelationships.md)
 - [SearchResultsResourceObject](docs/SearchResultsResourceObject.md)
 - [SearchResultsTopHitsMultiRelationshipDataDocument](docs/SearchResultsTopHitsMultiRelationshipDataDocument.md)
 - [SearchResultsTopHitsResourceIdentifier](docs/SearchResultsTopHitsResourceIdentifier.md)
 - [SearchResultsTopHitsResourceIdentifierMeta](docs/SearchResultsTopHitsResourceIdentifierMeta.md)
 - [SearchResultsTracksMultiRelationshipDataDocument](docs/SearchResultsTracksMultiRelationshipDataDocument.md)
 - [SearchResultsTracksResourceIdentifier](docs/SearchResultsTracksResourceIdentifier.md)
 - [SearchResultsTracksResourceIdentifierMeta](docs/SearchResultsTracksResourceIdentifierMeta.md)
 - [SearchResultsVideosMultiRelationshipDataDocument](docs/SearchResultsVideosMultiRelationshipDataDocument.md)
 - [SearchResultsVideosResourceIdentifier](docs/SearchResultsVideosResourceIdentifier.md)
 - [SearchResultsVideosResourceIdentifierMeta](docs/SearchResultsVideosResourceIdentifierMeta.md)
 - [SearchSuggestionsAttributes](docs/SearchSuggestionsAttributes.md)
 - [SearchSuggestionsDirectHitsMultiRelationshipDataDocument](docs/SearchSuggestionsDirectHitsMultiRelationshipDataDocument.md)
 - [SearchSuggestionsDirectHitsResourceIdentifier](docs/SearchSuggestionsDirectHitsResourceIdentifier.md)
 - [SearchSuggestionsDirectHitsResourceIdentifierMeta](docs/SearchSuggestionsDirectHitsResourceIdentifierMeta.md)
 - [SearchSuggestionsHighlights](docs/SearchSuggestionsHighlights.md)
 - [SearchSuggestionsMultiRelationshipDataDocument](docs/SearchSuggestionsMultiRelationshipDataDocument.md)
 - [SearchSuggestionsMultiResourceDataDocument](docs/SearchSuggestionsMultiResourceDataDocument.md)
 - [SearchSuggestionsRelationships](docs/SearchSuggestionsRelationships.md)
 - [SearchSuggestionsResourceObject](docs/SearchSuggestionsResourceObject.md)
 - [SearchSuggestionsSuggestions](docs/SearchSuggestionsSuggestions.md)
 - [SharesAttributes](docs/SharesAttributes.md)
 - [SharesCreateOperationPayload](docs/SharesCreateOperationPayload.md)
 - [SharesCreateOperationPayloadData](docs/SharesCreateOperationPayloadData.md)
 - [SharesCreateOperationPayloadDataRelationships](docs/SharesCreateOperationPayloadDataRelationships.md)
 - [SharesCreateOperationPayloadDataRelationshipsSharedResources](docs/SharesCreateOperationPayloadDataRelationshipsSharedResources.md)
 - [SharesCreateOperationPayloadDataRelationshipsSharedResourcesData](docs/SharesCreateOperationPayloadDataRelationshipsSharedResourcesData.md)
 - [SharesCreateSingleResourceDataDocument](docs/SharesCreateSingleResourceDataDocument.md)
 - [SharesMultiRelationshipDataDocument](docs/SharesMultiRelationshipDataDocument.md)
 - [SharesMultiResourceDataDocument](docs/SharesMultiResourceDataDocument.md)
 - [SharesRelationships](docs/SharesRelationships.md)
 - [SharesResourceObject](docs/SharesResourceObject.md)
 - [SharesSharedResourcesMultiRelationshipDataDocument](docs/SharesSharedResourcesMultiRelationshipDataDocument.md)
 - [SharesSharedResourcesResourceIdentifier](docs/SharesSharedResourcesResourceIdentifier.md)
 - [SharesSharedResourcesResourceIdentifierMeta](docs/SharesSharedResourcesResourceIdentifierMeta.md)
 - [SharesSingleResourceDataDocument](docs/SharesSingleResourceDataDocument.md)
 - [SingleRelationshipDataDocument](docs/SingleRelationshipDataDocument.md)
 - [SquareConnectionsAttributes](docs/SquareConnectionsAttributes.md)
 - [SquareConnectionsCapability](docs/SquareConnectionsCapability.md)
 - [SquareConnectionsCreateOperationPayload](docs/SquareConnectionsCreateOperationPayload.md)
 - [SquareConnectionsCreateOperationPayloadData](docs/SquareConnectionsCreateOperationPayloadData.md)
 - [SquareConnectionsCreateOperationPayloadMeta](docs/SquareConnectionsCreateOperationPayloadMeta.md)
 - [SquareConnectionsCreateSingleResourceDataDocument](docs/SquareConnectionsCreateSingleResourceDataDocument.md)
 - [SquareConnectionsMultiRelationshipDataDocument](docs/SquareConnectionsMultiRelationshipDataDocument.md)
 - [SquareConnectionsReadById403ResponseBody](docs/SquareConnectionsReadById403ResponseBody.md)
 - [SquareConnectionsReadById403ResponseBodyErrorsInner](docs/SquareConnectionsReadById403ResponseBodyErrorsInner.md)
 - [SquareConnectionsReadMultiDataRelationship403ResponseBody](docs/SquareConnectionsReadMultiDataRelationship403ResponseBody.md)
 - [SquareConnectionsReadSingleDataRelationship403ResponseBody](docs/SquareConnectionsReadSingleDataRelationship403ResponseBody.md)
 - [SquareConnectionsRelationships](docs/SquareConnectionsRelationships.md)
 - [SquareConnectionsResourceObject](docs/SquareConnectionsResourceObject.md)
 - [SquareConnectionsSelectedSiteRelationshipUpdateOperationPayload](docs/SquareConnectionsSelectedSiteRelationshipUpdateOperationPayload.md)
 - [SquareConnectionsSelectedSiteRelationshipUpdateOperationPayloadData](docs/SquareConnectionsSelectedSiteRelationshipUpdateOperationPayloadData.md)
 - [SquareConnectionsSelectedSiteUpdateResourceIdentifier](docs/SquareConnectionsSelectedSiteUpdateResourceIdentifier.md)
 - [SquareConnectionsSelectedSiteUpdateSingleRelationshipDataDocument](docs/SquareConnectionsSelectedSiteUpdateSingleRelationshipDataDocument.md)
 - [SquareConnectionsSingleRelationshipDataDocument](docs/SquareConnectionsSingleRelationshipDataDocument.md)
 - [SquareConnectionsSingleResourceDataDocument](docs/SquareConnectionsSingleResourceDataDocument.md)
 - [SquareConnectionsUpdateSingleDataRelationship403ResponseBody](docs/SquareConnectionsUpdateSingleDataRelationship403ResponseBody.md)
 - [SquareConnectionsUpdateSingleDataRelationship409ResponseBody](docs/SquareConnectionsUpdateSingleDataRelationship409ResponseBody.md)
 - [SquareConnectionsUpdateSingleDataRelationship409ResponseBodyErrorsInner](docs/SquareConnectionsUpdateSingleDataRelationship409ResponseBodyErrorsInner.md)
 - [SquareSitesAttributes](docs/SquareSitesAttributes.md)
 - [SquareSitesResourceObject](docs/SquareSitesResourceObject.md)
 - [StripeConnectionsAttributes](docs/StripeConnectionsAttributes.md)
 - [StripeConnectionsCreateOperationPayload](docs/StripeConnectionsCreateOperationPayload.md)
 - [StripeConnectionsCreateOperationPayloadData](docs/StripeConnectionsCreateOperationPayloadData.md)
 - [StripeConnectionsCreateOperationPayloadDataAttributes](docs/StripeConnectionsCreateOperationPayloadDataAttributes.md)
 - [StripeConnectionsCreateOperationPayloadMeta](docs/StripeConnectionsCreateOperationPayloadMeta.md)
 - [StripeConnectionsCreateSingleResourceDataDocument](docs/StripeConnectionsCreateSingleResourceDataDocument.md)
 - [StripeConnectionsMultiRelationshipDataDocument](docs/StripeConnectionsMultiRelationshipDataDocument.md)
 - [StripeConnectionsMultiResourceDataDocument](docs/StripeConnectionsMultiResourceDataDocument.md)
 - [StripeConnectionsRelationships](docs/StripeConnectionsRelationships.md)
 - [StripeConnectionsResourceObject](docs/StripeConnectionsResourceObject.md)
 - [StripeDashboardLinksAttributes](docs/StripeDashboardLinksAttributes.md)
 - [StripeDashboardLinksMultiRelationshipDataDocument](docs/StripeDashboardLinksMultiRelationshipDataDocument.md)
 - [StripeDashboardLinksMultiResourceDataDocument](docs/StripeDashboardLinksMultiResourceDataDocument.md)
 - [StripeDashboardLinksRelationships](docs/StripeDashboardLinksRelationships.md)
 - [StripeDashboardLinksResourceObject](docs/StripeDashboardLinksResourceObject.md)
 - [SubscriptionPriceChangeDecisionsAttributes](docs/SubscriptionPriceChangeDecisionsAttributes.md)
 - [SubscriptionPriceChangeDecisionsCreateOperationPayload](docs/SubscriptionPriceChangeDecisionsCreateOperationPayload.md)
 - [SubscriptionPriceChangeDecisionsCreateOperationPayloadData](docs/SubscriptionPriceChangeDecisionsCreateOperationPayloadData.md)
 - [SubscriptionPriceChangeDecisionsCreateOperationPayloadDataAttributes](docs/SubscriptionPriceChangeDecisionsCreateOperationPayloadDataAttributes.md)
 - [SubscriptionPriceChangeDecisionsCreateOperationPayloadDataRelationships](docs/SubscriptionPriceChangeDecisionsCreateOperationPayloadDataRelationships.md)
 - [SubscriptionPriceChangeDecisionsCreateOperationPayloadDataRelationshipsPriceChange](docs/SubscriptionPriceChangeDecisionsCreateOperationPayloadDataRelationshipsPriceChange.md)
 - [SubscriptionPriceChangeDecisionsCreateOperationPayloadDataRelationshipsPriceChangeData](docs/SubscriptionPriceChangeDecisionsCreateOperationPayloadDataRelationshipsPriceChangeData.md)
 - [SubscriptionPriceChangeDecisionsCreateSingleResourceDataDocument](docs/SubscriptionPriceChangeDecisionsCreateSingleResourceDataDocument.md)
 - [SubscriptionPriceChangeDecisionsMultiResourceDataDocument](docs/SubscriptionPriceChangeDecisionsMultiResourceDataDocument.md)
 - [SubscriptionPriceChangeDecisionsRelationships](docs/SubscriptionPriceChangeDecisionsRelationships.md)
 - [SubscriptionPriceChangeDecisionsResourceObject](docs/SubscriptionPriceChangeDecisionsResourceObject.md)
 - [SubscriptionPriceChangeDecisionsSingleRelationshipDataDocument](docs/SubscriptionPriceChangeDecisionsSingleRelationshipDataDocument.md)
 - [SubscriptionPriceChangeDecisionsUpdateOperationPayload](docs/SubscriptionPriceChangeDecisionsUpdateOperationPayload.md)
 - [SubscriptionPriceChangeDecisionsUpdateOperationPayloadData](docs/SubscriptionPriceChangeDecisionsUpdateOperationPayloadData.md)
 - [SubscriptionPriceChangeDecisionsUpdateOperationPayloadDataAttributes](docs/SubscriptionPriceChangeDecisionsUpdateOperationPayloadDataAttributes.md)
 - [SubscriptionPriceChangeDecisionsUpdateSingleResourceDataDocument](docs/SubscriptionPriceChangeDecisionsUpdateSingleResourceDataDocument.md)
 - [TemporaryUserTokensCreateOperationPayload](docs/TemporaryUserTokensCreateOperationPayload.md)
 - [TemporaryUserTokensCreateOperationPayloadData](docs/TemporaryUserTokensCreateOperationPayloadData.md)
 - [TemporaryUserTokensCreateSingleResourceDataDocument](docs/TemporaryUserTokensCreateSingleResourceDataDocument.md)
 - [TemporaryUserTokensMultiRelationshipDataDocument](docs/TemporaryUserTokensMultiRelationshipDataDocument.md)
 - [TemporaryUserTokensRelationships](docs/TemporaryUserTokensRelationships.md)
 - [TemporaryUserTokensResourceObject](docs/TemporaryUserTokensResourceObject.md)
 - [TemporaryUserTokensSingleResourceDataDocument](docs/TemporaryUserTokensSingleResourceDataDocument.md)
 - [TermsAttributes](docs/TermsAttributes.md)
 - [TermsMultiResourceDataDocument](docs/TermsMultiResourceDataDocument.md)
 - [TermsResourceObject](docs/TermsResourceObject.md)
 - [TermsResourceObjectMeta](docs/TermsResourceObjectMeta.md)
 - [TermsSingleResourceDataDocument](docs/TermsSingleResourceDataDocument.md)
 - [ThirdPartyLyricsProvider](docs/ThirdPartyLyricsProvider.md)
 - [TidalLyricsProvider](docs/TidalLyricsProvider.md)
 - [TrackFilesAttributes](docs/TrackFilesAttributes.md)
 - [TrackFilesReadById403ResponseBody](docs/TrackFilesReadById403ResponseBody.md)
 - [TrackFilesReadById403ResponseBodyErrorsInner](docs/TrackFilesReadById403ResponseBodyErrorsInner.md)
 - [TrackFilesReadById404ResponseBody](docs/TrackFilesReadById404ResponseBody.md)
 - [TrackFilesReadById404ResponseBodyErrorsInner](docs/TrackFilesReadById404ResponseBodyErrorsInner.md)
 - [TrackFilesResourceObject](docs/TrackFilesResourceObject.md)
 - [TrackFilesSingleResourceDataDocument](docs/TrackFilesSingleResourceDataDocument.md)
 - [TrackInfo](docs/TrackInfo.md)
 - [TrackManifestsAttributes](docs/TrackManifestsAttributes.md)
 - [TrackManifestsReadById403ResponseBody](docs/TrackManifestsReadById403ResponseBody.md)
 - [TrackManifestsReadById404ResponseBody](docs/TrackManifestsReadById404ResponseBody.md)
 - [TrackManifestsResourceObject](docs/TrackManifestsResourceObject.md)
 - [TrackManifestsSingleResourceDataDocument](docs/TrackManifestsSingleResourceDataDocument.md)
 - [TrackSourceFilesAttributes](docs/TrackSourceFilesAttributes.md)
 - [TrackSourceFilesCreateOperationPayload](docs/TrackSourceFilesCreateOperationPayload.md)
 - [TrackSourceFilesCreateOperationPayloadData](docs/TrackSourceFilesCreateOperationPayloadData.md)
 - [TrackSourceFilesCreateOperationPayloadDataAttributes](docs/TrackSourceFilesCreateOperationPayloadDataAttributes.md)
 - [TrackSourceFilesCreateOperationPayloadDataRelationships](docs/TrackSourceFilesCreateOperationPayloadDataRelationships.md)
 - [TrackSourceFilesCreateOperationPayloadDataRelationshipsTrack](docs/TrackSourceFilesCreateOperationPayloadDataRelationshipsTrack.md)
 - [TrackSourceFilesCreateOperationPayloadDataRelationshipsTrackData](docs/TrackSourceFilesCreateOperationPayloadDataRelationshipsTrackData.md)
 - [TrackSourceFilesCreateSingleResourceDataDocument](docs/TrackSourceFilesCreateSingleResourceDataDocument.md)
 - [TrackSourceFilesMultiRelationshipDataDocument](docs/TrackSourceFilesMultiRelationshipDataDocument.md)
 - [TrackSourceFilesRelationships](docs/TrackSourceFilesRelationships.md)
 - [TrackSourceFilesResourceObject](docs/TrackSourceFilesResourceObject.md)
 - [TrackSourceFilesSingleResourceDataDocument](docs/TrackSourceFilesSingleResourceDataDocument.md)
 - [TrackStatisticsAttributes](docs/TrackStatisticsAttributes.md)
 - [TrackStatisticsMultiRelationshipDataDocument](docs/TrackStatisticsMultiRelationshipDataDocument.md)
 - [TrackStatisticsRelationships](docs/TrackStatisticsRelationships.md)
 - [TrackStatisticsResourceObject](docs/TrackStatisticsResourceObject.md)
 - [TrackStatisticsSingleResourceDataDocument](docs/TrackStatisticsSingleResourceDataDocument.md)
 - [TracksAlbumsMultiRelationshipDataDocument](docs/TracksAlbumsMultiRelationshipDataDocument.md)
 - [TracksAlbumsRelationshipUpdateOperationPayload](docs/TracksAlbumsRelationshipUpdateOperationPayload.md)
 - [TracksAlbumsRelationshipUpdateOperationPayloadData](docs/TracksAlbumsRelationshipUpdateOperationPayloadData.md)
 - [TracksAlbumsResourceIdentifier](docs/TracksAlbumsResourceIdentifier.md)
 - [TracksAlbumsResourceIdentifierMeta](docs/TracksAlbumsResourceIdentifierMeta.md)
 - [TracksAttributes](docs/TracksAttributes.md)
 - [TracksCreateOperationPayload](docs/TracksCreateOperationPayload.md)
 - [TracksCreateOperationPayloadData](docs/TracksCreateOperationPayloadData.md)
 - [TracksCreateOperationPayloadDataAttributes](docs/TracksCreateOperationPayloadDataAttributes.md)
 - [TracksCreateOperationPayloadDataRelationships](docs/TracksCreateOperationPayloadDataRelationships.md)
 - [TracksCreateOperationPayloadDataRelationshipsAlbums](docs/TracksCreateOperationPayloadDataRelationshipsAlbums.md)
 - [TracksCreateOperationPayloadDataRelationshipsAlbumsData](docs/TracksCreateOperationPayloadDataRelationshipsAlbumsData.md)
 - [TracksCreateOperationPayloadDataRelationshipsArtists](docs/TracksCreateOperationPayloadDataRelationshipsArtists.md)
 - [TracksCreateOperationPayloadDataRelationshipsArtistsData](docs/TracksCreateOperationPayloadDataRelationshipsArtistsData.md)
 - [TracksCreateOperationPayloadDataRelationshipsGenres](docs/TracksCreateOperationPayloadDataRelationshipsGenres.md)
 - [TracksCreateOperationPayloadDataRelationshipsGenresData](docs/TracksCreateOperationPayloadDataRelationshipsGenresData.md)
 - [TracksCreateSingleResourceDataDocument](docs/TracksCreateSingleResourceDataDocument.md)
 - [TracksMetadataStatusAttributes](docs/TracksMetadataStatusAttributes.md)
 - [TracksMetadataStatusResourceObject](docs/TracksMetadataStatusResourceObject.md)
 - [TracksMetadataStatusSingleResourceDataDocument](docs/TracksMetadataStatusSingleResourceDataDocument.md)
 - [TracksMultiRelationshipDataDocument](docs/TracksMultiRelationshipDataDocument.md)
 - [TracksMultiResourceDataDocument](docs/TracksMultiResourceDataDocument.md)
 - [TracksRelationships](docs/TracksRelationships.md)
 - [TracksReplacementResourceIdentifier](docs/TracksReplacementResourceIdentifier.md)
 - [TracksReplacementResourceIdentifierMeta](docs/TracksReplacementResourceIdentifierMeta.md)
 - [TracksReplacementSingleRelationshipDataDocument](docs/TracksReplacementSingleRelationshipDataDocument.md)
 - [TracksResourceObject](docs/TracksResourceObject.md)
 - [TracksSimilarTracksMultiRelationshipDataDocument](docs/TracksSimilarTracksMultiRelationshipDataDocument.md)
 - [TracksSimilarTracksResourceIdentifier](docs/TracksSimilarTracksResourceIdentifier.md)
 - [TracksSimilarTracksResourceIdentifierMeta](docs/TracksSimilarTracksResourceIdentifierMeta.md)
 - [TracksSingleRelationshipDataDocument](docs/TracksSingleRelationshipDataDocument.md)
 - [TracksSingleResourceDataDocument](docs/TracksSingleResourceDataDocument.md)
 - [TracksSuggestedTracksMultiRelationshipDataDocument](docs/TracksSuggestedTracksMultiRelationshipDataDocument.md)
 - [TracksSuggestedTracksResourceIdentifier](docs/TracksSuggestedTracksResourceIdentifier.md)
 - [TracksSuggestedTracksResourceIdentifierMeta](docs/TracksSuggestedTracksResourceIdentifierMeta.md)
 - [TracksUpdateOperationPayload](docs/TracksUpdateOperationPayload.md)
 - [TracksUpdateOperationPayloadData](docs/TracksUpdateOperationPayloadData.md)
 - [TracksUpdateOperationPayloadDataAttributes](docs/TracksUpdateOperationPayloadDataAttributes.md)
 - [TracksUpdateOperationPayloadDataRelationships](docs/TracksUpdateOperationPayloadDataRelationships.md)
 - [TracksUpdateOperationPayloadDataRelationshipsGenres](docs/TracksUpdateOperationPayloadDataRelationshipsGenres.md)
 - [TracksUpdateOperationPayloadDataRelationshipsGenresData](docs/TracksUpdateOperationPayloadDataRelationshipsGenresData.md)
 - [UsageRulesAttributes](docs/UsageRulesAttributes.md)
 - [UsageRulesCreateOperationPayload](docs/UsageRulesCreateOperationPayload.md)
 - [UsageRulesCreateOperationPayloadData](docs/UsageRulesCreateOperationPayloadData.md)
 - [UsageRulesCreateOperationPayloadDataAttributes](docs/UsageRulesCreateOperationPayloadDataAttributes.md)
 - [UsageRulesCreateOperationPayloadDataRelationships](docs/UsageRulesCreateOperationPayloadDataRelationships.md)
 - [UsageRulesCreateOperationPayloadDataRelationshipsSubject](docs/UsageRulesCreateOperationPayloadDataRelationshipsSubject.md)
 - [UsageRulesCreateOperationPayloadSubject](docs/UsageRulesCreateOperationPayloadSubject.md)
 - [UsageRulesCreateSingleResourceDataDocument](docs/UsageRulesCreateSingleResourceDataDocument.md)
 - [UsageRulesResourceObject](docs/UsageRulesResourceObject.md)
 - [UsageRulesSingleResourceDataDocument](docs/UsageRulesSingleResourceDataDocument.md)
 - [UserCollection](docs/UserCollection.md)
 - [UserCollectionAlbumsAddMultiDataRelationshipWithResponse409ResponseBody](docs/UserCollectionAlbumsAddMultiDataRelationshipWithResponse409ResponseBody.md)
 - [UserCollectionAlbumsAddMultiDataRelationshipWithResponse409ResponseBodyErrorsInner](docs/UserCollectionAlbumsAddMultiDataRelationshipWithResponse409ResponseBodyErrorsInner.md)
 - [UserCollectionAlbumsAttributes](docs/UserCollectionAlbumsAttributes.md)
 - [UserCollectionAlbumsItemsAddMultiRelationshipDataDocument](docs/UserCollectionAlbumsItemsAddMultiRelationshipDataDocument.md)
 - [UserCollectionAlbumsItemsAddMultiRelationshipDataDocumentMeta](docs/UserCollectionAlbumsItemsAddMultiRelationshipDataDocumentMeta.md)
 - [UserCollectionAlbumsItemsAddResourceIdentifier](docs/UserCollectionAlbumsItemsAddResourceIdentifier.md)
 - [UserCollectionAlbumsItemsAddResourceIdentifierMeta](docs/UserCollectionAlbumsItemsAddResourceIdentifierMeta.md)
 - [UserCollectionAlbumsItemsMultiRelationshipDataDocument](docs/UserCollectionAlbumsItemsMultiRelationshipDataDocument.md)
 - [UserCollectionAlbumsItemsRelationshipAddOperationPayload](docs/UserCollectionAlbumsItemsRelationshipAddOperationPayload.md)
 - [UserCollectionAlbumsItemsRelationshipAddOperationPayloadData](docs/UserCollectionAlbumsItemsRelationshipAddOperationPayloadData.md)
 - [UserCollectionAlbumsItemsRelationshipAddOperationPayloadDataMeta](docs/UserCollectionAlbumsItemsRelationshipAddOperationPayloadDataMeta.md)
 - [UserCollectionAlbumsItemsRelationshipAddOperationResponseMetaSkippedItem](docs/UserCollectionAlbumsItemsRelationshipAddOperationResponseMetaSkippedItem.md)
 - [UserCollectionAlbumsItemsRelationshipRemoveOperationPayload](docs/UserCollectionAlbumsItemsRelationshipRemoveOperationPayload.md)
 - [UserCollectionAlbumsItemsRelationshipRemoveOperationPayloadData](docs/UserCollectionAlbumsItemsRelationshipRemoveOperationPayloadData.md)
 - [UserCollectionAlbumsItemsResourceIdentifier](docs/UserCollectionAlbumsItemsResourceIdentifier.md)
 - [UserCollectionAlbumsItemsResourceIdentifierMeta](docs/UserCollectionAlbumsItemsResourceIdentifierMeta.md)
 - [UserCollectionAlbumsMultiRelationshipDataDocument](docs/UserCollectionAlbumsMultiRelationshipDataDocument.md)
 - [UserCollectionAlbumsRelationships](docs/UserCollectionAlbumsRelationships.md)
 - [UserCollectionAlbumsResourceObject](docs/UserCollectionAlbumsResourceObject.md)
 - [UserCollectionAlbumsSingleResourceDataDocument](docs/UserCollectionAlbumsSingleResourceDataDocument.md)
 - [UserCollectionArtistsAddMultiDataRelationshipWithResponse409ResponseBody](docs/UserCollectionArtistsAddMultiDataRelationshipWithResponse409ResponseBody.md)
 - [UserCollectionArtistsAttributes](docs/UserCollectionArtistsAttributes.md)
 - [UserCollectionArtistsItemsAddMultiRelationshipDataDocument](docs/UserCollectionArtistsItemsAddMultiRelationshipDataDocument.md)
 - [UserCollectionArtistsItemsAddMultiRelationshipDataDocumentMeta](docs/UserCollectionArtistsItemsAddMultiRelationshipDataDocumentMeta.md)
 - [UserCollectionArtistsItemsAddResourceIdentifier](docs/UserCollectionArtistsItemsAddResourceIdentifier.md)
 - [UserCollectionArtistsItemsAddResourceIdentifierMeta](docs/UserCollectionArtistsItemsAddResourceIdentifierMeta.md)
 - [UserCollectionArtistsItemsMultiRelationshipDataDocument](docs/UserCollectionArtistsItemsMultiRelationshipDataDocument.md)
 - [UserCollectionArtistsItemsRelationshipAddOperationPayload](docs/UserCollectionArtistsItemsRelationshipAddOperationPayload.md)
 - [UserCollectionArtistsItemsRelationshipAddOperationPayloadData](docs/UserCollectionArtistsItemsRelationshipAddOperationPayloadData.md)
 - [UserCollectionArtistsItemsRelationshipAddOperationPayloadDataMeta](docs/UserCollectionArtistsItemsRelationshipAddOperationPayloadDataMeta.md)
 - [UserCollectionArtistsItemsRelationshipAddOperationResponseMetaSkippedItem](docs/UserCollectionArtistsItemsRelationshipAddOperationResponseMetaSkippedItem.md)
 - [UserCollectionArtistsItemsRelationshipRemoveOperationPayload](docs/UserCollectionArtistsItemsRelationshipRemoveOperationPayload.md)
 - [UserCollectionArtistsItemsRelationshipRemoveOperationPayloadData](docs/UserCollectionArtistsItemsRelationshipRemoveOperationPayloadData.md)
 - [UserCollectionArtistsItemsResourceIdentifier](docs/UserCollectionArtistsItemsResourceIdentifier.md)
 - [UserCollectionArtistsItemsResourceIdentifierMeta](docs/UserCollectionArtistsItemsResourceIdentifierMeta.md)
 - [UserCollectionArtistsMultiRelationshipDataDocument](docs/UserCollectionArtistsMultiRelationshipDataDocument.md)
 - [UserCollectionArtistsRelationships](docs/UserCollectionArtistsRelationships.md)
 - [UserCollectionArtistsResourceObject](docs/UserCollectionArtistsResourceObject.md)
 - [UserCollectionArtistsSingleResourceDataDocument](docs/UserCollectionArtistsSingleResourceDataDocument.md)
 - [UserCollectionFoldersAttributes](docs/UserCollectionFoldersAttributes.md)
 - [UserCollectionFoldersCreateOperationPayload](docs/UserCollectionFoldersCreateOperationPayload.md)
 - [UserCollectionFoldersCreateOperationPayloadData](docs/UserCollectionFoldersCreateOperationPayloadData.md)
 - [UserCollectionFoldersCreateOperationPayloadDataAttributes](docs/UserCollectionFoldersCreateOperationPayloadDataAttributes.md)
 - [UserCollectionFoldersCreateOperationPayloadDataRelationships](docs/UserCollectionFoldersCreateOperationPayloadDataRelationships.md)
 - [UserCollectionFoldersCreateOperationPayloadDataRelationshipsUserCollection](docs/UserCollectionFoldersCreateOperationPayloadDataRelationshipsUserCollection.md)
 - [UserCollectionFoldersCreateSingleResourceDataDocument](docs/UserCollectionFoldersCreateSingleResourceDataDocument.md)
 - [UserCollectionFoldersDeleteResource400ResponseBody](docs/UserCollectionFoldersDeleteResource400ResponseBody.md)
 - [UserCollectionFoldersDeleteResource400ResponseBodyErrorsInner](docs/UserCollectionFoldersDeleteResource400ResponseBodyErrorsInner.md)
 - [UserCollectionFoldersItemsMultiRelationshipDataDocument](docs/UserCollectionFoldersItemsMultiRelationshipDataDocument.md)
 - [UserCollectionFoldersItemsRelationshipAddOperationPayload](docs/UserCollectionFoldersItemsRelationshipAddOperationPayload.md)
 - [UserCollectionFoldersItemsRelationshipAddOperationPayloadData](docs/UserCollectionFoldersItemsRelationshipAddOperationPayloadData.md)
 - [UserCollectionFoldersItemsRelationshipRemoveOperationPayload](docs/UserCollectionFoldersItemsRelationshipRemoveOperationPayload.md)
 - [UserCollectionFoldersItemsRelationshipRemoveOperationPayloadData](docs/UserCollectionFoldersItemsRelationshipRemoveOperationPayloadData.md)
 - [UserCollectionFoldersItemsResourceIdentifier](docs/UserCollectionFoldersItemsResourceIdentifier.md)
 - [UserCollectionFoldersItemsResourceIdentifierMeta](docs/UserCollectionFoldersItemsResourceIdentifierMeta.md)
 - [UserCollectionFoldersMultiRelationshipDataDocument](docs/UserCollectionFoldersMultiRelationshipDataDocument.md)
 - [UserCollectionFoldersMultiResourceDataDocument](docs/UserCollectionFoldersMultiResourceDataDocument.md)
 - [UserCollectionFoldersRelationships](docs/UserCollectionFoldersRelationships.md)
 - [UserCollectionFoldersResourceObject](docs/UserCollectionFoldersResourceObject.md)
 - [UserCollectionFoldersSingleRelationshipDataDocument](docs/UserCollectionFoldersSingleRelationshipDataDocument.md)
 - [UserCollectionFoldersSingleResourceDataDocument](docs/UserCollectionFoldersSingleResourceDataDocument.md)
 - [UserCollectionFoldersUpdateOperationPayload](docs/UserCollectionFoldersUpdateOperationPayload.md)
 - [UserCollectionFoldersUpdateOperationPayloadData](docs/UserCollectionFoldersUpdateOperationPayloadData.md)
 - [UserCollectionFoldersUpdateOperationPayloadDataAttributes](docs/UserCollectionFoldersUpdateOperationPayloadDataAttributes.md)
 - [UserCollectionPlaylistsAddMultiDataRelationshipWithResponse409ResponseBody](docs/UserCollectionPlaylistsAddMultiDataRelationshipWithResponse409ResponseBody.md)
 - [UserCollectionPlaylistsAttributes](docs/UserCollectionPlaylistsAttributes.md)
 - [UserCollectionPlaylistsItemsAddMultiRelationshipDataDocument](docs/UserCollectionPlaylistsItemsAddMultiRelationshipDataDocument.md)
 - [UserCollectionPlaylistsItemsAddMultiRelationshipDataDocumentMeta](docs/UserCollectionPlaylistsItemsAddMultiRelationshipDataDocumentMeta.md)
 - [UserCollectionPlaylistsItemsAddResourceIdentifier](docs/UserCollectionPlaylistsItemsAddResourceIdentifier.md)
 - [UserCollectionPlaylistsItemsAddResourceIdentifierMeta](docs/UserCollectionPlaylistsItemsAddResourceIdentifierMeta.md)
 - [UserCollectionPlaylistsItemsMultiRelationshipDataDocument](docs/UserCollectionPlaylistsItemsMultiRelationshipDataDocument.md)
 - [UserCollectionPlaylistsItemsRelationshipAddOperationPayload](docs/UserCollectionPlaylistsItemsRelationshipAddOperationPayload.md)
 - [UserCollectionPlaylistsItemsRelationshipAddOperationPayloadData](docs/UserCollectionPlaylistsItemsRelationshipAddOperationPayloadData.md)
 - [UserCollectionPlaylistsItemsRelationshipAddOperationPayloadDataMeta](docs/UserCollectionPlaylistsItemsRelationshipAddOperationPayloadDataMeta.md)
 - [UserCollectionPlaylistsItemsRelationshipAddOperationResponseMetaSkippedItem](docs/UserCollectionPlaylistsItemsRelationshipAddOperationResponseMetaSkippedItem.md)
 - [UserCollectionPlaylistsItemsRelationshipRemoveOperationPayload](docs/UserCollectionPlaylistsItemsRelationshipRemoveOperationPayload.md)
 - [UserCollectionPlaylistsItemsRelationshipRemoveOperationPayloadData](docs/UserCollectionPlaylistsItemsRelationshipRemoveOperationPayloadData.md)
 - [UserCollectionPlaylistsItemsResourceIdentifier](docs/UserCollectionPlaylistsItemsResourceIdentifier.md)
 - [UserCollectionPlaylistsItemsResourceIdentifierMeta](docs/UserCollectionPlaylistsItemsResourceIdentifierMeta.md)
 - [UserCollectionPlaylistsMultiRelationshipDataDocument](docs/UserCollectionPlaylistsMultiRelationshipDataDocument.md)
 - [UserCollectionPlaylistsRelationships](docs/UserCollectionPlaylistsRelationships.md)
 - [UserCollectionPlaylistsResourceObject](docs/UserCollectionPlaylistsResourceObject.md)
 - [UserCollectionPlaylistsSingleResourceDataDocument](docs/UserCollectionPlaylistsSingleResourceDataDocument.md)
 - [UserCollectionSaveForLatersAddMultiDataRelationshipWithResponse409ResponseBody](docs/UserCollectionSaveForLatersAddMultiDataRelationshipWithResponse409ResponseBody.md)
 - [UserCollectionSaveForLatersAttributes](docs/UserCollectionSaveForLatersAttributes.md)
 - [UserCollectionSaveForLatersItemsAddMultiRelationshipDataDocument](docs/UserCollectionSaveForLatersItemsAddMultiRelationshipDataDocument.md)
 - [UserCollectionSaveForLatersItemsAddMultiRelationshipDataDocumentMeta](docs/UserCollectionSaveForLatersItemsAddMultiRelationshipDataDocumentMeta.md)
 - [UserCollectionSaveForLatersItemsAddResourceIdentifier](docs/UserCollectionSaveForLatersItemsAddResourceIdentifier.md)
 - [UserCollectionSaveForLatersItemsAddResourceIdentifierMeta](docs/UserCollectionSaveForLatersItemsAddResourceIdentifierMeta.md)
 - [UserCollectionSaveForLatersItemsMultiRelationshipDataDocument](docs/UserCollectionSaveForLatersItemsMultiRelationshipDataDocument.md)
 - [UserCollectionSaveForLatersItemsRelationshipAddOperationPayload](docs/UserCollectionSaveForLatersItemsRelationshipAddOperationPayload.md)
 - [UserCollectionSaveForLatersItemsRelationshipAddOperationPayloadData](docs/UserCollectionSaveForLatersItemsRelationshipAddOperationPayloadData.md)
 - [UserCollectionSaveForLatersItemsRelationshipAddOperationResponseMetaSkippedItem](docs/UserCollectionSaveForLatersItemsRelationshipAddOperationResponseMetaSkippedItem.md)
 - [UserCollectionSaveForLatersItemsRelationshipRemoveOperationPayload](docs/UserCollectionSaveForLatersItemsRelationshipRemoveOperationPayload.md)
 - [UserCollectionSaveForLatersItemsRelationshipRemoveOperationPayloadData](docs/UserCollectionSaveForLatersItemsRelationshipRemoveOperationPayloadData.md)
 - [UserCollectionSaveForLatersItemsResourceIdentifier](docs/UserCollectionSaveForLatersItemsResourceIdentifier.md)
 - [UserCollectionSaveForLatersItemsResourceIdentifierMeta](docs/UserCollectionSaveForLatersItemsResourceIdentifierMeta.md)
 - [UserCollectionSaveForLatersMultiRelationshipDataDocument](docs/UserCollectionSaveForLatersMultiRelationshipDataDocument.md)
 - [UserCollectionSaveForLatersRelationships](docs/UserCollectionSaveForLatersRelationships.md)
 - [UserCollectionSaveForLatersResourceObject](docs/UserCollectionSaveForLatersResourceObject.md)
 - [UserCollectionSaveForLatersSingleResourceDataDocument](docs/UserCollectionSaveForLatersSingleResourceDataDocument.md)
 - [UserCollectionTracksAddMultiDataRelationshipWithResponse409ResponseBody](docs/UserCollectionTracksAddMultiDataRelationshipWithResponse409ResponseBody.md)
 - [UserCollectionTracksAttributes](docs/UserCollectionTracksAttributes.md)
 - [UserCollectionTracksItemsAddMultiRelationshipDataDocument](docs/UserCollectionTracksItemsAddMultiRelationshipDataDocument.md)
 - [UserCollectionTracksItemsAddMultiRelationshipDataDocumentMeta](docs/UserCollectionTracksItemsAddMultiRelationshipDataDocumentMeta.md)
 - [UserCollectionTracksItemsAddResourceIdentifier](docs/UserCollectionTracksItemsAddResourceIdentifier.md)
 - [UserCollectionTracksItemsAddResourceIdentifierMeta](docs/UserCollectionTracksItemsAddResourceIdentifierMeta.md)
 - [UserCollectionTracksItemsMultiRelationshipDataDocument](docs/UserCollectionTracksItemsMultiRelationshipDataDocument.md)
 - [UserCollectionTracksItemsRelationshipAddOperationPayload](docs/UserCollectionTracksItemsRelationshipAddOperationPayload.md)
 - [UserCollectionTracksItemsRelationshipAddOperationPayloadData](docs/UserCollectionTracksItemsRelationshipAddOperationPayloadData.md)
 - [UserCollectionTracksItemsRelationshipAddOperationPayloadDataMeta](docs/UserCollectionTracksItemsRelationshipAddOperationPayloadDataMeta.md)
 - [UserCollectionTracksItemsRelationshipAddOperationResponseMetaSkippedItem](docs/UserCollectionTracksItemsRelationshipAddOperationResponseMetaSkippedItem.md)
 - [UserCollectionTracksItemsRelationshipRemoveOperationPayload](docs/UserCollectionTracksItemsRelationshipRemoveOperationPayload.md)
 - [UserCollectionTracksItemsRelationshipRemoveOperationPayloadData](docs/UserCollectionTracksItemsRelationshipRemoveOperationPayloadData.md)
 - [UserCollectionTracksItemsResourceIdentifier](docs/UserCollectionTracksItemsResourceIdentifier.md)
 - [UserCollectionTracksItemsResourceIdentifierMeta](docs/UserCollectionTracksItemsResourceIdentifierMeta.md)
 - [UserCollectionTracksMultiRelationshipDataDocument](docs/UserCollectionTracksMultiRelationshipDataDocument.md)
 - [UserCollectionTracksRelationships](docs/UserCollectionTracksRelationships.md)
 - [UserCollectionTracksResourceObject](docs/UserCollectionTracksResourceObject.md)
 - [UserCollectionTracksSingleResourceDataDocument](docs/UserCollectionTracksSingleResourceDataDocument.md)
 - [UserCollectionVideosAddMultiDataRelationshipWithResponse409ResponseBody](docs/UserCollectionVideosAddMultiDataRelationshipWithResponse409ResponseBody.md)
 - [UserCollectionVideosAttributes](docs/UserCollectionVideosAttributes.md)
 - [UserCollectionVideosItemsAddMultiRelationshipDataDocument](docs/UserCollectionVideosItemsAddMultiRelationshipDataDocument.md)
 - [UserCollectionVideosItemsAddMultiRelationshipDataDocumentMeta](docs/UserCollectionVideosItemsAddMultiRelationshipDataDocumentMeta.md)
 - [UserCollectionVideosItemsAddResourceIdentifier](docs/UserCollectionVideosItemsAddResourceIdentifier.md)
 - [UserCollectionVideosItemsAddResourceIdentifierMeta](docs/UserCollectionVideosItemsAddResourceIdentifierMeta.md)
 - [UserCollectionVideosItemsMultiRelationshipDataDocument](docs/UserCollectionVideosItemsMultiRelationshipDataDocument.md)
 - [UserCollectionVideosItemsRelationshipAddOperationPayload](docs/UserCollectionVideosItemsRelationshipAddOperationPayload.md)
 - [UserCollectionVideosItemsRelationshipAddOperationPayloadData](docs/UserCollectionVideosItemsRelationshipAddOperationPayloadData.md)
 - [UserCollectionVideosItemsRelationshipAddOperationPayloadDataMeta](docs/UserCollectionVideosItemsRelationshipAddOperationPayloadDataMeta.md)
 - [UserCollectionVideosItemsRelationshipAddOperationResponseMetaSkippedItem](docs/UserCollectionVideosItemsRelationshipAddOperationResponseMetaSkippedItem.md)
 - [UserCollectionVideosItemsRelationshipRemoveOperationPayload](docs/UserCollectionVideosItemsRelationshipRemoveOperationPayload.md)
 - [UserCollectionVideosItemsRelationshipRemoveOperationPayloadData](docs/UserCollectionVideosItemsRelationshipRemoveOperationPayloadData.md)
 - [UserCollectionVideosItemsResourceIdentifier](docs/UserCollectionVideosItemsResourceIdentifier.md)
 - [UserCollectionVideosItemsResourceIdentifierMeta](docs/UserCollectionVideosItemsResourceIdentifierMeta.md)
 - [UserCollectionVideosMultiRelationshipDataDocument](docs/UserCollectionVideosMultiRelationshipDataDocument.md)
 - [UserCollectionVideosRelationships](docs/UserCollectionVideosRelationships.md)
 - [UserCollectionVideosResourceObject](docs/UserCollectionVideosResourceObject.md)
 - [UserCollectionVideosSingleResourceDataDocument](docs/UserCollectionVideosSingleResourceDataDocument.md)
 - [UserCollectionsAddMultiDataRelationship409ResponseBody](docs/UserCollectionsAddMultiDataRelationship409ResponseBody.md)
 - [UserCollectionsAlbumsMultiRelationshipDataDocument](docs/UserCollectionsAlbumsMultiRelationshipDataDocument.md)
 - [UserCollectionsAlbumsRelationshipAddOperationPayload](docs/UserCollectionsAlbumsRelationshipAddOperationPayload.md)
 - [UserCollectionsAlbumsRelationshipAddOperationPayloadData](docs/UserCollectionsAlbumsRelationshipAddOperationPayloadData.md)
 - [UserCollectionsAlbumsRelationshipAddOperationPayloadDataMeta](docs/UserCollectionsAlbumsRelationshipAddOperationPayloadDataMeta.md)
 - [UserCollectionsAlbumsRelationshipRemoveOperationPayload](docs/UserCollectionsAlbumsRelationshipRemoveOperationPayload.md)
 - [UserCollectionsAlbumsRelationshipRemoveOperationPayloadData](docs/UserCollectionsAlbumsRelationshipRemoveOperationPayloadData.md)
 - [UserCollectionsAlbumsResourceIdentifier](docs/UserCollectionsAlbumsResourceIdentifier.md)
 - [UserCollectionsAlbumsResourceIdentifierMeta](docs/UserCollectionsAlbumsResourceIdentifierMeta.md)
 - [UserCollectionsArtistsMultiRelationshipDataDocument](docs/UserCollectionsArtistsMultiRelationshipDataDocument.md)
 - [UserCollectionsArtistsRelationshipAddOperationPayload](docs/UserCollectionsArtistsRelationshipAddOperationPayload.md)
 - [UserCollectionsArtistsRelationshipAddOperationPayloadData](docs/UserCollectionsArtistsRelationshipAddOperationPayloadData.md)
 - [UserCollectionsArtistsRelationshipAddOperationPayloadDataMeta](docs/UserCollectionsArtistsRelationshipAddOperationPayloadDataMeta.md)
 - [UserCollectionsArtistsRelationshipRemoveOperationPayload](docs/UserCollectionsArtistsRelationshipRemoveOperationPayload.md)
 - [UserCollectionsArtistsRelationshipRemoveOperationPayloadData](docs/UserCollectionsArtistsRelationshipRemoveOperationPayloadData.md)
 - [UserCollectionsArtistsResourceIdentifier](docs/UserCollectionsArtistsResourceIdentifier.md)
 - [UserCollectionsArtistsResourceIdentifierMeta](docs/UserCollectionsArtistsResourceIdentifierMeta.md)
 - [UserCollectionsMultiRelationshipDataDocument](docs/UserCollectionsMultiRelationshipDataDocument.md)
 - [UserCollectionsPlaylistsMultiRelationshipDataDocument](docs/UserCollectionsPlaylistsMultiRelationshipDataDocument.md)
 - [UserCollectionsPlaylistsRelationshipAddOperationPayload](docs/UserCollectionsPlaylistsRelationshipAddOperationPayload.md)
 - [UserCollectionsPlaylistsRelationshipAddOperationPayloadData](docs/UserCollectionsPlaylistsRelationshipAddOperationPayloadData.md)
 - [UserCollectionsPlaylistsRelationshipRemoveOperationPayload](docs/UserCollectionsPlaylistsRelationshipRemoveOperationPayload.md)
 - [UserCollectionsPlaylistsRelationshipRemoveOperationPayloadData](docs/UserCollectionsPlaylistsRelationshipRemoveOperationPayloadData.md)
 - [UserCollectionsPlaylistsResourceIdentifier](docs/UserCollectionsPlaylistsResourceIdentifier.md)
 - [UserCollectionsPlaylistsResourceIdentifierMeta](docs/UserCollectionsPlaylistsResourceIdentifierMeta.md)
 - [UserCollectionsRelationships](docs/UserCollectionsRelationships.md)
 - [UserCollectionsResourceObject](docs/UserCollectionsResourceObject.md)
 - [UserCollectionsSingleResourceDataDocument](docs/UserCollectionsSingleResourceDataDocument.md)
 - [UserCollectionsTracksMultiRelationshipDataDocument](docs/UserCollectionsTracksMultiRelationshipDataDocument.md)
 - [UserCollectionsTracksRelationshipAddOperationPayload](docs/UserCollectionsTracksRelationshipAddOperationPayload.md)
 - [UserCollectionsTracksRelationshipAddOperationPayloadData](docs/UserCollectionsTracksRelationshipAddOperationPayloadData.md)
 - [UserCollectionsTracksRelationshipAddOperationPayloadDataMeta](docs/UserCollectionsTracksRelationshipAddOperationPayloadDataMeta.md)
 - [UserCollectionsTracksRelationshipRemoveOperationPayload](docs/UserCollectionsTracksRelationshipRemoveOperationPayload.md)
 - [UserCollectionsTracksRelationshipRemoveOperationPayloadData](docs/UserCollectionsTracksRelationshipRemoveOperationPayloadData.md)
 - [UserCollectionsTracksResourceIdentifier](docs/UserCollectionsTracksResourceIdentifier.md)
 - [UserCollectionsTracksResourceIdentifierMeta](docs/UserCollectionsTracksResourceIdentifierMeta.md)
 - [UserCollectionsVideosMultiRelationshipDataDocument](docs/UserCollectionsVideosMultiRelationshipDataDocument.md)
 - [UserCollectionsVideosRelationshipAddOperationPayload](docs/UserCollectionsVideosRelationshipAddOperationPayload.md)
 - [UserCollectionsVideosRelationshipAddOperationPayloadData](docs/UserCollectionsVideosRelationshipAddOperationPayloadData.md)
 - [UserCollectionsVideosRelationshipRemoveOperationPayload](docs/UserCollectionsVideosRelationshipRemoveOperationPayload.md)
 - [UserCollectionsVideosRelationshipRemoveOperationPayloadData](docs/UserCollectionsVideosRelationshipRemoveOperationPayloadData.md)
 - [UserCollectionsVideosResourceIdentifier](docs/UserCollectionsVideosResourceIdentifier.md)
 - [UserCollectionsVideosResourceIdentifierMeta](docs/UserCollectionsVideosResourceIdentifierMeta.md)
 - [UserDailyMixesMultiRelationshipDataDocument](docs/UserDailyMixesMultiRelationshipDataDocument.md)
 - [UserDailyMixesRelationships](docs/UserDailyMixesRelationships.md)
 - [UserDailyMixesResourceObject](docs/UserDailyMixesResourceObject.md)
 - [UserDailyMixesSingleResourceDataDocument](docs/UserDailyMixesSingleResourceDataDocument.md)
 - [UserDataExportRequestsAttributes](docs/UserDataExportRequestsAttributes.md)
 - [UserDataExportRequestsCreateOperationPayload](docs/UserDataExportRequestsCreateOperationPayload.md)
 - [UserDataExportRequestsCreateOperationPayloadData](docs/UserDataExportRequestsCreateOperationPayloadData.md)
 - [UserDataExportRequestsCreateOperationPayloadDataAttributes](docs/UserDataExportRequestsCreateOperationPayloadDataAttributes.md)
 - [UserDataExportRequestsCreateSingleResourceDataDocument](docs/UserDataExportRequestsCreateSingleResourceDataDocument.md)
 - [UserDataExportRequestsResourceObject](docs/UserDataExportRequestsResourceObject.md)
 - [UserDiscoveryMixesMultiRelationshipDataDocument](docs/UserDiscoveryMixesMultiRelationshipDataDocument.md)
 - [UserDiscoveryMixesRelationships](docs/UserDiscoveryMixesRelationships.md)
 - [UserDiscoveryMixesResourceObject](docs/UserDiscoveryMixesResourceObject.md)
 - [UserDiscoveryMixesSingleResourceDataDocument](docs/UserDiscoveryMixesSingleResourceDataDocument.md)
 - [UserNewReleaseMixesMultiRelationshipDataDocument](docs/UserNewReleaseMixesMultiRelationshipDataDocument.md)
 - [UserNewReleaseMixesRelationships](docs/UserNewReleaseMixesRelationships.md)
 - [UserNewReleaseMixesResourceObject](docs/UserNewReleaseMixesResourceObject.md)
 - [UserNewReleaseMixesSingleResourceDataDocument](docs/UserNewReleaseMixesSingleResourceDataDocument.md)
 - [UserOfflineMixesMultiRelationshipDataDocument](docs/UserOfflineMixesMultiRelationshipDataDocument.md)
 - [UserOfflineMixesRelationships](docs/UserOfflineMixesRelationships.md)
 - [UserOfflineMixesResourceObject](docs/UserOfflineMixesResourceObject.md)
 - [UserOfflineMixesSingleResourceDataDocument](docs/UserOfflineMixesSingleResourceDataDocument.md)
 - [UserRecommendationBlocksAddMultiDataRelationshipWithResponse409ResponseBody](docs/UserRecommendationBlocksAddMultiDataRelationshipWithResponse409ResponseBody.md)
 - [UserRecommendationBlocksAddMultiDataRelationshipWithResponse409ResponseBodyErrorsInner](docs/UserRecommendationBlocksAddMultiDataRelationshipWithResponse409ResponseBodyErrorsInner.md)
 - [UserRecommendationBlocksArtistsAddMultiRelationshipDataDocument](docs/UserRecommendationBlocksArtistsAddMultiRelationshipDataDocument.md)
 - [UserRecommendationBlocksArtistsAddResourceIdentifier](docs/UserRecommendationBlocksArtistsAddResourceIdentifier.md)
 - [UserRecommendationBlocksArtistsMultiRelationshipDataDocument](docs/UserRecommendationBlocksArtistsMultiRelationshipDataDocument.md)
 - [UserRecommendationBlocksArtistsRelationshipAddOperationPayload](docs/UserRecommendationBlocksArtistsRelationshipAddOperationPayload.md)
 - [UserRecommendationBlocksArtistsRelationshipAddOperationPayloadData](docs/UserRecommendationBlocksArtistsRelationshipAddOperationPayloadData.md)
 - [UserRecommendationBlocksArtistsRelationshipRemoveOperationPayload](docs/UserRecommendationBlocksArtistsRelationshipRemoveOperationPayload.md)
 - [UserRecommendationBlocksArtistsRelationshipRemoveOperationPayloadData](docs/UserRecommendationBlocksArtistsRelationshipRemoveOperationPayloadData.md)
 - [UserRecommendationBlocksArtistsResourceIdentifier](docs/UserRecommendationBlocksArtistsResourceIdentifier.md)
 - [UserRecommendationBlocksArtistsResourceIdentifierMeta](docs/UserRecommendationBlocksArtistsResourceIdentifierMeta.md)
 - [UserRecommendationBlocksMultiRelationshipDataDocument](docs/UserRecommendationBlocksMultiRelationshipDataDocument.md)
 - [UserRecommendationBlocksRelationships](docs/UserRecommendationBlocksRelationships.md)
 - [UserRecommendationBlocksResourceObject](docs/UserRecommendationBlocksResourceObject.md)
 - [UserRecommendationBlocksSingleResourceDataDocument](docs/UserRecommendationBlocksSingleResourceDataDocument.md)
 - [UserRecommendationBlocksTracksAddMultiRelationshipDataDocument](docs/UserRecommendationBlocksTracksAddMultiRelationshipDataDocument.md)
 - [UserRecommendationBlocksTracksAddResourceIdentifier](docs/UserRecommendationBlocksTracksAddResourceIdentifier.md)
 - [UserRecommendationBlocksTracksMultiRelationshipDataDocument](docs/UserRecommendationBlocksTracksMultiRelationshipDataDocument.md)
 - [UserRecommendationBlocksTracksRelationshipAddOperationPayload](docs/UserRecommendationBlocksTracksRelationshipAddOperationPayload.md)
 - [UserRecommendationBlocksTracksRelationshipAddOperationPayloadData](docs/UserRecommendationBlocksTracksRelationshipAddOperationPayloadData.md)
 - [UserRecommendationBlocksTracksRelationshipRemoveOperationPayload](docs/UserRecommendationBlocksTracksRelationshipRemoveOperationPayload.md)
 - [UserRecommendationBlocksTracksRelationshipRemoveOperationPayloadData](docs/UserRecommendationBlocksTracksRelationshipRemoveOperationPayloadData.md)
 - [UserRecommendationBlocksTracksResourceIdentifier](docs/UserRecommendationBlocksTracksResourceIdentifier.md)
 - [UserRecommendationBlocksTracksResourceIdentifierMeta](docs/UserRecommendationBlocksTracksResourceIdentifierMeta.md)
 - [UserRecommendationBlocksVideosAddMultiRelationshipDataDocument](docs/UserRecommendationBlocksVideosAddMultiRelationshipDataDocument.md)
 - [UserRecommendationBlocksVideosAddResourceIdentifier](docs/UserRecommendationBlocksVideosAddResourceIdentifier.md)
 - [UserRecommendationBlocksVideosMultiRelationshipDataDocument](docs/UserRecommendationBlocksVideosMultiRelationshipDataDocument.md)
 - [UserRecommendationBlocksVideosRelationshipAddOperationPayload](docs/UserRecommendationBlocksVideosRelationshipAddOperationPayload.md)
 - [UserRecommendationBlocksVideosRelationshipAddOperationPayloadData](docs/UserRecommendationBlocksVideosRelationshipAddOperationPayloadData.md)
 - [UserRecommendationBlocksVideosRelationshipRemoveOperationPayload](docs/UserRecommendationBlocksVideosRelationshipRemoveOperationPayload.md)
 - [UserRecommendationBlocksVideosRelationshipRemoveOperationPayloadData](docs/UserRecommendationBlocksVideosRelationshipRemoveOperationPayloadData.md)
 - [UserRecommendationBlocksVideosResourceIdentifier](docs/UserRecommendationBlocksVideosResourceIdentifier.md)
 - [UserRecommendationBlocksVideosResourceIdentifierMeta](docs/UserRecommendationBlocksVideosResourceIdentifierMeta.md)
 - [UserRecommendationsMultiRelationshipDataDocument](docs/UserRecommendationsMultiRelationshipDataDocument.md)
 - [UserRecommendationsRelationships](docs/UserRecommendationsRelationships.md)
 - [UserRecommendationsResourceObject](docs/UserRecommendationsResourceObject.md)
 - [UserRecommendationsSingleResourceDataDocument](docs/UserRecommendationsSingleResourceDataDocument.md)
 - [UserReportsAttributes](docs/UserReportsAttributes.md)
 - [UserReportsCreateOperationPayload](docs/UserReportsCreateOperationPayload.md)
 - [UserReportsCreateOperationPayloadData](docs/UserReportsCreateOperationPayloadData.md)
 - [UserReportsCreateOperationPayloadDataAttributes](docs/UserReportsCreateOperationPayloadDataAttributes.md)
 - [UserReportsCreateOperationPayloadDataRelationships](docs/UserReportsCreateOperationPayloadDataRelationships.md)
 - [UserReportsCreateOperationPayloadDataRelationshipsReportedResources](docs/UserReportsCreateOperationPayloadDataRelationshipsReportedResources.md)
 - [UserReportsCreateOperationPayloadDataRelationshipsReportedResourcesData](docs/UserReportsCreateOperationPayloadDataRelationshipsReportedResourcesData.md)
 - [UserReportsCreateSingleResourceDataDocument](docs/UserReportsCreateSingleResourceDataDocument.md)
 - [UserReportsResourceObject](docs/UserReportsResourceObject.md)
 - [UserSubscriptionPriceChangesAttributes](docs/UserSubscriptionPriceChangesAttributes.md)
 - [UserSubscriptionPriceChangesMultiResourceDataDocument](docs/UserSubscriptionPriceChangesMultiResourceDataDocument.md)
 - [UserSubscriptionPriceChangesRelationships](docs/UserSubscriptionPriceChangesRelationships.md)
 - [UserSubscriptionPriceChangesResourceObject](docs/UserSubscriptionPriceChangesResourceObject.md)
 - [UserSubscriptionPriceChangesSingleRelationshipDataDocument](docs/UserSubscriptionPriceChangesSingleRelationshipDataDocument.md)
 - [UsersAttributes](docs/UsersAttributes.md)
 - [UsersResourceObject](docs/UsersResourceObject.md)
 - [UsersSingleResourceDataDocument](docs/UsersSingleResourceDataDocument.md)
 - [VideoManifestsAttributes](docs/VideoManifestsAttributes.md)
 - [VideoManifestsReadById403ResponseBody](docs/VideoManifestsReadById403ResponseBody.md)
 - [VideoManifestsReadById404ResponseBody](docs/VideoManifestsReadById404ResponseBody.md)
 - [VideoManifestsResourceObject](docs/VideoManifestsResourceObject.md)
 - [VideoManifestsSingleResourceDataDocument](docs/VideoManifestsSingleResourceDataDocument.md)
 - [VideosAlbumsMultiRelationshipDataDocument](docs/VideosAlbumsMultiRelationshipDataDocument.md)
 - [VideosAlbumsResourceIdentifier](docs/VideosAlbumsResourceIdentifier.md)
 - [VideosAlbumsResourceIdentifierMeta](docs/VideosAlbumsResourceIdentifierMeta.md)
 - [VideosAttributes](docs/VideosAttributes.md)
 - [VideosMultiRelationshipDataDocument](docs/VideosMultiRelationshipDataDocument.md)
 - [VideosMultiResourceDataDocument](docs/VideosMultiResourceDataDocument.md)
 - [VideosRelationships](docs/VideosRelationships.md)
 - [VideosReplacementResourceIdentifier](docs/VideosReplacementResourceIdentifier.md)
 - [VideosReplacementResourceIdentifierMeta](docs/VideosReplacementResourceIdentifierMeta.md)
 - [VideosReplacementSingleRelationshipDataDocument](docs/VideosReplacementSingleRelationshipDataDocument.md)
 - [VideosResourceObject](docs/VideosResourceObject.md)
 - [VideosSimilarVideosMultiRelationshipDataDocument](docs/VideosSimilarVideosMultiRelationshipDataDocument.md)
 - [VideosSimilarVideosResourceIdentifier](docs/VideosSimilarVideosResourceIdentifier.md)
 - [VideosSimilarVideosResourceIdentifierMeta](docs/VideosSimilarVideosResourceIdentifierMeta.md)
 - [VideosSingleRelationshipDataDocument](docs/VideosSingleRelationshipDataDocument.md)
 - [VideosSingleResourceDataDocument](docs/VideosSingleResourceDataDocument.md)
 - [VideosSuggestedVideosMultiRelationshipDataDocument](docs/VideosSuggestedVideosMultiRelationshipDataDocument.md)
 - [VideosSuggestedVideosResourceIdentifier](docs/VideosSuggestedVideosResourceIdentifier.md)
 - [VideosSuggestedVideosResourceIdentifierMeta](docs/VideosSuggestedVideosResourceIdentifierMeta.md)


<a id="documentation-for-authorization"></a>
## Documentation For Authorization


Authentication schemes defined for the API:
<a id="Authorization_Code_PKCE"></a>
### Authorization_Code_PKCE

- **Type**: OAuth
- **Flow**: accessCode
- **Authorization URL**: https://login.tidal.com/authorize
- **Scopes**: 
 - **collection.read**: Read access to a user's \"My Collection\".
 - **collection.write**: Write access to a user's \"My Collection\".
 - **entitlements.read**: Read access to what functionality a user is entitled to access on TIDAL, such as whether they can stream music, use DJ add-ons and similar.
 - **playback**: Required to play media content and control playback.
 - **playlists.read**: Required to list playlists created by a user.
 - **playlists.write**: Write access to a user's playlists.
 - **r_usr**: Read access to all end user data
 - **recommendations.read**: Read access to a user’s personal recommendations.
 - **search.read**: Required to read personalized search results.
 - **search.write**: Required to update personalized search results, e.g. delete search history.
 - **user.read**: Read access to a user's account information, such as country and email address.
 - **w_usr**: Write user

<a id="Client_Credentials"></a>
### Client_Credentials

- **Type**: OAuth
- **Flow**: application
- **Authorization URL**: 
- **Scopes**: N/A


# How do I migrate from the Swift 5 generator to the swift 6 generator?

https://openapi-generator.tech/docs/faq-generators#how-do-i-migrate-from-the-swift-5-generator-to-the-swift-6-generator

### How do I implement bearer token authentication with URLSession on the Swift 5 API client?

https://openapi-generator.tech/docs/faq-generators#how-do-i-implement-bearer-token-authentication-with-urlsession-on-the-swift-5-api-client

## Author



