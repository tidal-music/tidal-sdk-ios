@testable import Offliner
import GRDB
import TidalAPI
import XCTest

final class OfflineRepositoryTests: XCTestCase {
	private var repository: OfflineRepository!
	private var tempDir: URL!

	override func setUp() {
		super.setUp()
		tempDir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
		try? FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
		let dbPath = tempDir.appendingPathComponent("test.sqlite").path
		if let databaseQueue = try? DatabaseQueue(path: dbPath) {
			try? Migrations.run(databaseQueue)
			repository = OfflineRepository(databaseQueue)
		}
	}

	override func tearDown() {
		repository = nil
		if let tempDir {
			try? FileManager.default.removeItem(at: tempDir)
		}
		super.tearDown()
	}

	private func createTempFile(name: String) throws -> (url: URL, bookmark: Data) {
		let fileURL = tempDir.appendingPathComponent(name)
		try Data().write(to: fileURL)
		let bookmark = try fileURL.bookmarkData(options: [], includingResourceValuesForKeys: nil, relativeTo: nil)
		return (fileURL, bookmark)
	}

	func testStoreAndGetCollection() throws {
		let resourceId = "album-456"

		try insertCollection(resourceId: resourceId)

		let collection = try repository.getCollection(collectionType: .albums, resourceId: resourceId)

		XCTAssertNotNil(collection)
		XCTAssertEqual(collection?.collection.resourceId, resourceId)
		if case .album = collection?.collection {} else {
			XCTFail("Expected album collection type")
		}
	}

	func testStoreAndGetMediaItem() throws {
		let resourceId = "track-789"
		let (mediaURL, _) = try createTempFile(name: "media.m4a")
		let (licenseURL, _) = try createTempFile(name: "license.lic")

		try insertCollection()
		try insertMediaItem(
			resourceId: resourceId,
			mediaURL: mediaURL,
			licenseURL: licenseURL
		)

		let mediaItem = try repository.getMediaItem(mediaType: .tracks, resourceId: resourceId)

		XCTAssertNotNil(mediaItem)
		XCTAssertEqual(mediaItem?.item.resourceId, resourceId)
		XCTAssertEqual(mediaItem?.mediaURL.standardizedFileURL, mediaURL.standardizedFileURL)
		XCTAssertEqual(mediaItem?.licenseURL?.standardizedFileURL, licenseURL.standardizedFileURL)
	}

	func testGetMediaItems() throws {
		try insertCollection()
		try insertMediaItem(id: "media-1", type: .tracks, resourceId: "track-1", position: 1)
		try insertMediaItem(id: "media-2", type: .tracks, resourceId: "track-2", position: 2)
		try insertMediaItem(id: "media-3", type: .videos, resourceId: "video-1", position: 3)

		let tracks = try repository.getMediaItems(mediaType: .tracks)
		let videos = try repository.getMediaItems(mediaType: .videos)

		XCTAssertEqual(tracks.count, 2)
		XCTAssertEqual(videos.count, 1)
	}

	func testGetCollections() throws {
		try insertCollection(id: "col-1", type: .albums, resourceId: "album-1")
		try insertCollection(id: "col-2", type: .albums, resourceId: "album-2")
		try insertCollection(id: "col-3", type: .playlists, resourceId: "playlist-1")

		let albums = try repository.getCollections(collectionType: .albums)
		let playlists = try repository.getCollections(collectionType: .playlists)

		XCTAssertEqual(albums.count, 2)
		XCTAssertEqual(playlists.count, 1)
	}

	func testGetCollectionItems() throws {
		let collectionResourceId = "album-123"

		try insertCollection(resourceId: collectionResourceId)
		try insertMediaItem(id: "media-1", resourceId: "track-1", position: 2)
		try insertMediaItem(id: "media-2", resourceId: "track-2", position: 1)

		let items = try repository.getCollectionItems(collectionType: .albums, resourceId: collectionResourceId)

		XCTAssertEqual(items.count, 2)
		XCTAssertEqual(items[0].item.item.resourceId, "track-2")
		XCTAssertEqual(items[0].position, 1)
		XCTAssertEqual(items[1].item.item.resourceId, "track-1")
		XCTAssertEqual(items[1].position, 2)
	}

	func testDeleteItem() throws {
		let resourceId = "track-to-delete"

		try insertCollection()
		try insertMediaItem(resourceId: resourceId)

		try repository.deleteItem(id: "media-1")

		let mediaItem = try repository.getMediaItem(mediaType: .tracks, resourceId: resourceId)
		XCTAssertNil(mediaItem)
	}

	func testDeleteCollectionRemovesRelationships() throws {
		let collectionResourceId = "album-to-delete"
		let collectionId = "collection-1"

		try insertCollection(id: collectionId, resourceId: collectionResourceId)
		try insertMediaItem(collectionId: collectionId)

		try repository.deleteItem(id: collectionId)

		let collection = try repository.getCollection(collectionType: .albums, resourceId: collectionResourceId)
		let items = try repository.getCollectionItems(collectionType: .albums, resourceId: collectionResourceId)

		XCTAssertNil(collection)
		XCTAssertEqual(items.count, 0)
	}

	private func insertCollection(
		id: String = "collection-1",
		type: CollectionType = .albums,
		resourceId: String = "album-123"
	) throws {
		let collection: CollectionMetadata
		switch type {
		case .albums:
			collection = .album(AlbumsResourceObject(id: resourceId, type: "albums"))
		case .playlists:
			collection = .playlist(PlaylistsResourceObject(id: resourceId, type: "playlists"))
		}

		let task = StoreCollectionTask(id: id, collection: collection)
		try repository.storeCollection(task: task)
	}

	private func insertMediaItem(
		id: String = "media-1",
		type: MediaType = .tracks,
		resourceId: String = "track-123",
		mediaURL: URL? = nil,
		licenseURL: URL? = nil,
		collectionId: String = "collection-1",
		volume: Int = 1,
		position: Int = 1
	) throws {
		let item: ItemMetadata
		switch type {
		case .tracks:
			item = .track(TracksResourceObject(id: resourceId, type: "tracks"))
		case .videos:
			item = .video(VideosResourceObject(id: resourceId, type: "videos"))
		}

		let url = try mediaURL ?? createTempFile(name: "\(id)-media.m4a").url
		let task = StoreItemTask(id: id, item: item, collectionId: collectionId, volume: volume, index: position)
		try repository.storeMediaItem(task: task, mediaURL: url, licenseURL: licenseURL)
	}
}
