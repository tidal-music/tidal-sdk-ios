# Offliner

Offliner is the TIDAL SDK module for managing offline content. It handles downloading media (tracks and videos) and collections (albums, playlists, and user collection tracks) for offline playback, including DRM license acquisition and local storage management.

## Getting Started

### Initialization

Offliner requires that `OpenAPIClientAPI.credentialsProvider` is configured before use (typically set to your Auth module's credential provider).

Create an `Offliner` instance by providing an installation identifier and a `Configuration`:

```swift
let configuration = Configuration(
    audioFormats: [.flac, .heaacv1],
    allowDownloadsOnExpensiveNetworks: false
)
let offliner = try Offliner(installationId: installationId, configuration: configuration)
```

The `installationId` is obtained by creating an installation resource via the TIDAL API using `InstallationsAPI.installationsPost()`. When creating the installation, you provide a `clientProvidedInstallationId` (a stable, unique identifier you generate for this device) and a human-readable `name`. The API returns an installation resource whose `id` is what you pass to `Offliner`.

You can look up an existing installation by your client-provided ID using `InstallationsAPI.installationsGet()` with the `filterClientProvidedInstallationId` parameter.

### Configuration

`Configuration` lets you control:

- **`audioFormats`**: Preferred audio formats for downloads, in priority order. Defaults to `[.heaacv1]`. Available formats: `.heaacv1`, `.aaclc`, `.flac`, `.flacHires`, `.eac3Joc`.
- **`allowDownloadsOnExpensiveNetworks`**: Whether to allow downloads over cellular/expensive networks. Defaults to `true`.

You can update these at runtime:

```swift
// Update preferred audio formats
offliner.audioFormats = [.flac, .heaacv1]

// Toggle expensive network downloads
await offliner.setAllowDownloadsOnExpensiveNetworks(false)
```

### Running the Task Processor

Offliner processes download and removal tasks in the background. Call `run()` to start processing:

```swift
await offliner.run()
```

This fetches pending tasks from the backend and begins executing them. You can call `run()` multiple times—it will pick up any new tasks that have been queued.

### Background URL Session

To support background downloads, forward background URL session events to Offliner in your `AppDelegate`:

```swift
offliner.handleBackgroundURLSessionEvents(identifier: identifier, completionHandler: completionHandler)
```

## Downloading Content

### Request a Download

To download content, specify the type and resource ID:

```swift
// Download a single track
try await offliner.download(mediaType: .tracks, resourceId: "track-id")

// Download a video
try await offliner.download(mediaType: .videos, resourceId: "video-id")

// Download an album (includes all tracks)
try await offliner.download(collectionType: .albums, resourceId: .identifier("album-id"))

// Download a playlist
try await offliner.download(collectionType: .playlists, resourceId: .identifier("playlist-id"))

// Download user collection tracks
try await offliner.download(collectionType: .userCollectionTracks, resourceId: .me)
```

These methods register the download request with the backend and automatically trigger task processing.

### Monitoring Downloads

#### New Downloads Stream

Subscribe to new downloads as they're picked up for processing:

```swift
for await download in offliner.newDownloads {
    print("Task \(download.taskId) started \(download.resource)")
}
```

#### Current Downloads

Get a snapshot of all active downloads:

```swift
let downloads = await offliner.currentDownloads
```

#### Collection Download State

The compatibility collection stream remains available for its original three-state UI:

```swift
for await state in offliner.getOfflineCollectionDownloadState(
    collectionType: .albums,
    resourceId: .identifier("album-id")
) {
    // Handle state: .notDownloaded, .downloading, .downloaded
}
```

| State | Meaning |
| --- | --- |
| `.notDownloaded` | The collection is not locally available, or it is being removed. |
| `.downloading` | The collection or one of its members has active download/acquisition work known by this SDK instance. |
| `.downloaded` | The collection is locally stored and no pending download/acquisition work is known. |

Removal tasks are not surfaced as `.downloading`; callers can map this state directly to a download button label:
`Download`, `Downloading...`, and `Downloaded`.

For resource-scoped media and collection state, use the normalized snapshot and observation APIs:

```swift
let resource = OfflineResource.collection(type: .albums, resourceId: "album-id")
let state = try await offliner.getOfflineResourceState(for: resource)

for await state in offliner.observeOfflineResourceState(for: resource) {
    switch state {
    case .notDownloaded, .queued, .downloading, .downloaded, .removing:
        break
    case .failed(let action):
        // `action` is `.download` or `.remove` and is the stable retry direction.
        break
    }
}
```

Queued, removing, and failed operation state is stored in the installation-scoped Offliner database and recovered on a
new `Offliner` instance. Backend task inventory refreshes queued versus active transfer state when connectivity permits;
a refresh failure does not hide locally stored content or discard the last known operation. Streams finish when the
instance is reset. Repeating the same active request is idempotent. An opposite request while work is queued, downloading,
or removing throws `OfflineResourceOperationError.conflictingOperationInProgress` so collection removal cannot race its
member stores.

#### Tracking Individual Download Progress

Each `Download` is an actor that exposes an event stream for state changes and progress updates:

```swift
for await event in download.events {
    switch event {
    case .state(let state):
        // Handle state: .pending, .inProgress, .completed, .failed
        print("State changed to: \(state)")
    case .progress(let progress):
        // Progress from 0.0 to 1.0
        print("Progress: \(Int(progress * 100))%")
    }
}
```

You can also read download info directly:

```swift
let title = download.title         // Track or video title
let artists = download.artists     // Artist names
let imageURL = download.imageURL   // Artwork URL
```

## Accessing Offline Content

### Media Items (Tracks and Videos)

Retrieve a specific offline media item:

```swift
if let track = try await offliner.getOfflineMediaItem(mediaType: .tracks, resourceId: "track-id") {
    // Access artworkURL, catalogMetadata, and playbackMetadata without resolving playback files
}
```

List all offline items of a type:

```swift
let allTracks = try await offliner.getOfflineMediaItems(mediaType: .tracks)
let allVideos = try await offliner.getOfflineMediaItems(mediaType: .videos)
```

### Collections (Albums, Playlists, and User Collection Tracks)

Retrieve a specific collection:

```swift
if let album = try await offliner.getOfflineCollection(collectionType: .albums, resourceId: "album-id") {
    // Access artworkURL and catalogMetadata
}
```

List all offline collections:

```swift
let allAlbums = try await offliner.getOfflineCollections(collectionType: .albums)
let allPlaylists = try await offliner.getOfflineCollections(collectionType: .playlists)
```

For a finite, local-only snapshot that preserves database errors and works without a network connection, use:

```swift
let storedAlbums = try await offliner.getStoredOfflineCollections(collectionType: .albums)
let storedPlaylists = try await offliner.getStoredOfflineCollections(collectionType: .playlists)
```

The existing streams continue to combine local state with pending backend inventory for compatibility.

### Logout and Installation Changes

Offline databases, artwork, licenses, media bookmarks, and background download sessions are isolated by the
`installationId` passed to `Offliner`. Before discarding an instance during logout or an installation/account change,
reset it and await completion:

```swift
try await offliner.reset()
```

Reset is local-only: it cancels and awaits ongoing work, removes that installation's local data and artifacts, and does
not enqueue backend removals. A reset instance is permanently invalid; create a new `Offliner` for the next session.

When upgrading from an SDK version that used the original unscoped store, the first installation initialized after the
upgrade claims and migrates that existing database and its artwork/license directories into installation-scoped
storage. Its persisted bookmarks are retained and renewed when needed.

### Collection Items (Paginated)

Get items within a collection using cursor-based pagination:

```swift
let page = try await offliner.getOfflineCollectionItems(
    collectionType: .albums,
    resourceId: "album-id",
    limit: 20
)

for item in page.items {
    // item.item - the OfflineMediaItem
    // item.volume - disc number
    // item.position - track number within the volume
    // item.addedAt - optional playlist relationship date used for date-added sorting
}

// Fetch next page using the cursor
if let cursor = page.cursor {
    let nextPage = try await offliner.getOfflineCollectionItems(
        collectionType: .albums,
        resourceId: "album-id",
        limit: 20,
        after: cursor
    )
}
```

Omitting `sort` returns stored collection order. Pass a `sort` to order by another field (`.title`, `.album`,
`.artist`, or `.dateAdded`). The `cursor` is an opaque `String` to pass back via `after`:

```swift
var sortedPage = try await offliner.getOfflineCollectionItems(
    collectionType: .playlists,
    resourceId: "playlist-id",
    limit: 20,
    sort: .title(direction: .ascending)
)

// Fetch next page using the cursor
if let cursor = sortedPage.cursor {
    sortedPage = try await offliner.getOfflineCollectionItems(
        collectionType: .playlists,
        resourceId: "playlist-id",
        limit: 20,
        sort: .title(direction: .ascending),
        after: cursor
    )
}
```

Missing values (e.g. a track without album metadata, or an item without a relationship date) sort as an empty
string: first in ascending order, last in descending order.

### Searching Within a Collection

Search the offline tracks/videos of a single collection by title or any credited artist. Matching is
case- and accent-insensitive substring matching (e.g. `kiss` matches `One Kiss`, `beyonce` matches `Beyoncé`).
A blank query returns an empty result.

```swift
let page = try await offliner.findInOfflineCollection(
    search: "halo",
    collectionType: .albums,
    resourceId: .identifier("album-id"),
    sort: .title(direction: .ascending)
)
```

Omitting `sort` orders hits (and their cursors) by natural stored order. A page holds at most `limit` hits
(default 20). A non-empty page always carries a `cursor`; pass it back via `after` and keep fetching until a
page comes back empty:

```swift
var hits = page.hits
var cursor = page.cursor

while let after = cursor {
    let next = try await offliner.findInOfflineCollection(
        search: "halo",
        collectionType: .albums,
        resourceId: .identifier("album-id"),
        sort: .title(direction: .ascending),
        after: after
    )
    guard !next.hits.isEmpty else { break }
    hits += next.hits
    cursor = next.cursor
}
```

Each hit also carries the `cursor` of the page that immediately follows it in the supplied sort order, so
jumping from a search result into the collection at that position is a single follow-up call:

```swift
if let hit = page.hits.first {
    let following = try await offliner.getOfflineCollectionItems(
        collectionType: .albums,
        resourceId: .identifier("album-id"),
        limit: 50,
        sort: .title(direction: .ascending),
        after: hit.cursor
    )
}
```

### Collection Utilities

```swift
// Get the item count for a collection
let count = try await offliner.countOfflineCollectionItems(collectionType: .albums, resourceId: "album-id")

// Get the total duration (in seconds) of a collection
let duration = try await offliner.getCollectionDuration(collectionType: .albums, resourceId: "album-id")

// Get the audio format used for a collection's tracks
let format = try await offliner.getAudioFormatOfCollection(collectionType: .albums, resourceId: "album-id")
```

## Removing Content

Remove content using the same pattern as downloading:

```swift
try await offliner.remove(mediaType: .tracks, resourceId: "track-id")
try await offliner.remove(collectionType: .albums, resourceId: .identifier("album-id"))
```

Removal requests are registered with the backend and task processing is triggered automatically.

## Offline Playback

Offliner exposes a Player-independent playback asset lookup. The lookup resolves the stored media and license file bookmarks only when playback is requested:

```swift
let asset = await offliner.getOfflinePlaybackAsset(
    mediaType: .tracks,
    resourceId: .identifier("track-id")
)
// Returns mediaURL, licenseURL, and playback metadata, or nil when no playable asset is stored.
```

Offliner has no dependency on the Player module because Player does not support watchOS. Consumers that use Player can declare the `OfflineItemProvider` conformance in a target that links both products:

```swift
import Offliner
import Player

extension Offliner: @retroactive OfflineItemProvider {
    public func get(productType: ProductType, productId: String) async -> OfflinePlaybackItem? {
        let mediaType: OfflineMediaItemType
        switch productType {
        case .TRACK: mediaType = .tracks
        case .VIDEO: mediaType = .videos
        case .UC: return nil
        }

        guard let asset = await getOfflinePlaybackAsset(
            mediaType: mediaType,
            resourceId: .identifier(productId)
        ) else {
            return nil
        }

        return OfflinePlaybackItem(
            mediaURL: asset.mediaURL,
            licenseURL: asset.licenseURL,
            format: asset.playbackMetadata?.format.rawValue,
            albumReplayGain: asset.playbackMetadata?.albumNormalizationData?.replayGain,
            albumPeakAmplitude: asset.playbackMetadata?.albumNormalizationData?.peakAmplitude,
            productType: productType
        )
    }
}
```

## Platform Support

Offliner supports iOS 15+, macOS 12+, and watchOS 10+. Its shared download pipeline uses `AVAssetDownloadConfiguration`, KVO progress observation, and the platform-appropriate asset location delegate callback.

---

## Architecture

Offliner uses a task-based architecture where the backend is the source of truth for what should be offline.

**Key components:**

- **OfflineApiClient**: Communicates with the TIDAL API to register requests and fetch pending tasks
- **TaskRunner**: Manages concurrent task execution and dispatches to handlers
- **Handlers**: Execute specific task types (store/remove for items/collections)
- **MediaDownloader**: Downloads HLS content via `AVAssetDownloadURLSession`
- **LicenseDownloader**: Acquires FairPlay DRM licenses for protected content
- **ManifestFetcher**: Fetches track and video manifests (playback URLs and metadata)
- **ArtworkDownloader**: Downloads and stores artwork images locally
- **OfflineStore**: Persists metadata and file references in a local GRDB database

**Flow**: `download()` registers with backend → `run()` fetches tasks → handlers fetch manifests, download media, acquire licenses, and store artwork → results stored locally → content available via `getOfflineMediaItem()`
