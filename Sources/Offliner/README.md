# Offliner

Offliner is the TIDAL SDK module for managing offline content. It handles downloading media (tracks and videos) and collections (albums and playlists) for offline playback, including DRM license acquisition and local storage management.

## Getting Started

### Initialization

Offliner requires that `OpenAPIClientAPI.credentialsProvider` is configured before use (typically set to your Auth module's credential provider).

Create an `Offliner` instance by providing an installation identifier:

```swift
let offliner = try Offliner(installationId: installationId)
```

The `installationId` is obtained by creating an installation resource via the TIDAL API using `InstallationsAPI.installationsPost()`. When creating the installation, you provide a `clientProvidedInstallationId` (a stable, unique identifier you generate for this device) and a human-readable `name`. The API returns an installation resource whose `id` is what you pass to `Offliner`.

You can look up an existing installation by your client-provided ID using `InstallationsAPI.installationsGet()` with the `filterClientProvidedInstallationId` parameter.

### Running the Task Processor

Offliner processes download and removal tasks in the background. Call `run()` to start processing:

```swift
try await offliner.run()
```

This fetches pending tasks from the backend and begins executing them. You can call `run()` multiple times—it will pick up any new tasks that have been queued.

## Downloading Content

### Request a Download

To download content, specify the type and resource ID:

```swift
// Download a single track
try await offliner.download(mediaType: .tracks, resourceId: "track-id")

// Download a video
try await offliner.download(mediaType: .videos, resourceId: "video-id")

// Download an album (includes all tracks)
try await offliner.download(collectionType: .albums, resourceId: "album-id")

// Download a playlist
try await offliner.download(collectionType: .playlists, resourceId: "playlist-id")
```

These methods register the download request with the backend. The actual download begins when `run()` processes the task.

### Monitoring Downloads

#### New Downloads Stream

Subscribe to new downloads as they're picked up for processing:

```swift
for await download in offliner.newDownloads {
    print("Started downloading: \(download.metadata)")
}
```

#### Current Downloads

Get a snapshot of all active downloads:

```swift
let downloads = await offliner.currentDownloads
```

#### Tracking Individual Download Progress

Each download exposes an event stream for state changes and progress updates:

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

You can also read the current state and progress directly:

```swift
let currentState = download.state
let currentProgress = download.progress
let metadata = download.metadata  // Track or video metadata
```

## Accessing Offline Content

### Media Items (Tracks and Videos)

Retrieve a specific offline media item:

```swift
if let track = try offliner.getOfflineMediaItem(mediaType: .tracks, resourceId: "track-id") {
    // Access the media file URL, license URL, artwork URL, and metadata
}
```

List all offline items of a type:

```swift
let allTracks = try offliner.getOfflineMediaItems(mediaType: .tracks)
let allVideos = try offliner.getOfflineMediaItems(mediaType: .videos)
```

### Collections (Albums and Playlists)

Retrieve a specific collection:

```swift
if let album = try offliner.getOfflineCollection(collectionType: .albums, resourceId: "album-id") {
    // Access artwork URL and metadata
}
```

List all offline collections:

```swift
let allAlbums = try offliner.getOfflineCollections(collectionType: .albums)
let allPlaylists = try offliner.getOfflineCollections(collectionType: .playlists)
```

### Collection Items

Get all items within a collection, ordered by volume and position:

```swift
let albumTracks = try offliner.getOfflineCollectionItems(collectionType: .albums, resourceId: "album-id")

for item in albumTracks {
    // item.item - the offline media item
    // item.volume - disc number
    // item.position - track number within the volume
}
```

## Removing Content

Remove content using the same pattern as downloading:

```swift
try await offliner.remove(mediaType: .tracks, resourceId: "track-id")
try await offliner.remove(collectionType: .albums, resourceId: "album-id")
```

Like downloads, removal requests are processed when `run()` executes.

---

## Architecture

Offliner uses a task-based architecture where the backend is the source of truth for what should be offline.

**Key components:**

- **BackendClient**: Communicates with the TIDAL API to register requests and fetch pending tasks
- **TaskRunner**: Manages concurrent task execution and dispatches to handlers
- **Handlers**: Execute specific task types (store/remove for items/collections)
- **MediaDownloader**: Downloads HLS content via `AVAssetDownloadURLSession`
- **LicenseFetcher**: Acquires FairPlay DRM licenses for protected content
- **OfflineStore**: Persists metadata and file references in a local database

**Flow**: `download()` registers with backend → `run()` fetches tasks → handlers execute downloads → results stored locally → content available via `getOfflineMediaItem()`
