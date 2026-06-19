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
    print("Started downloading: \(download.title) by \(download.artists)")
}
```

#### Current Downloads

Get a snapshot of all active downloads:

```swift
let downloads = await offliner.currentDownloads
```

#### Collection Download State

Subscribe to collection download-state changes for albums, playlists, and user collection tracks. The stream emits an
initial local state from local storage and active in-memory SDK work, then continues polling for local changes:

```swift
for await state in offliner.getOfflineCollectionDownloadState(
    collectionType: .albums,
    resourceId: .identifier("album-id")
) {
    // Handle state: .notDownloaded, .downloading, .downloaded
}
```

The stream is optimized for view entry and does not poll backend task inventory. Backend-provided per-collection
activity metadata would be required for authoritative task state after a cold start.

| State | Meaning |
| --- | --- |
| `.notDownloaded` | The collection is not locally available, or it is being removed. |
| `.downloading` | The collection or one of its members has active download/acquisition work known by this SDK instance. |
| `.downloaded` | The collection is locally stored and no pending download/acquisition work is known. |

Removal tasks are not surfaced as `.downloading`; callers can map this state directly to a download button label:
`Download`, `Downloading...`, and `Downloaded`.

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
    // Access mediaURL, licenseURL, artworkURL, catalogMetadata, and playbackMetadata
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
case- and accent-insensitive substring matching (e.g. `kiss` matches `One Kiss`, `beyonce` matches `Beyoncé`). Each hit carries the pagination `cursor`
for the page that immediately follows it in the supplied sort order, so jumping from a search result into the
collection at that position is a single follow-up call:

```swift
let hits = try await offliner.findInOfflineCollection(
    search: "halo",
    collectionType: .albums,
    resourceId: .identifier("album-id"),
    sort: .title(direction: .ascending)
)

if let hit = hits.first {
    // hit.item is an OfflineCollectionItem; hit.cursor points at the next page in the same sort order.
    let nextPage = try await offliner.getOfflineCollectionItems(
        collectionType: .albums,
        resourceId: .identifier("album-id"),
        limit: 50,
        sort: .title(direction: .ascending),
        after: hit.cursor
    )
}
```

Omitting `sort` orders results (and their cursors) by natural stored order. A blank query returns an empty result.
At most `limit` hits are returned (default 20).

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

Offliner conforms to `OfflineItemProvider` (from the Player module), so it can be used directly as the offline content source for the Player:

```swift
let item = await offliner.get(productType: .TRACK, productId: "track-id")
// Returns an OfflinePlaybackItem with mediaURL, licenseURL, format, and normalization data
```

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
