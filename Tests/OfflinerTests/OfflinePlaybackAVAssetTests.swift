@testable import Offliner
import AVFoundation
import Foundation
import XCTest

final class OfflinePlaybackAVAssetTests: OfflinerTestCase {

	func testUnprotectedAssetUsesPlainURLAsset() throws {
		let mediaURL = tempDir.appendingPathComponent("media.movpkg")
		let preparedAsset = try OfflinePlaybackAVAsset(playbackAsset: playbackAsset(
			mediaURL: mediaURL,
			licenseURL: nil
		))

		XCTAssertEqual(preparedAsset.urlAsset.url, mediaURL)
		XCTAssertFalse(preparedAsset.usesStoredLicense)
	}

	func testProtectedAssetRetainsStoredLicenseContext() throws {
		#if targetEnvironment(simulator)
			throw XCTSkip("AVContentKeySession FairPlay construction is unavailable on simulators")
		#else
			let mediaURL = tempDir.appendingPathComponent("media.movpkg")
			let licenseURL = tempDir.appendingPathComponent("license.key")
			try Data([0x01, 0x02, 0x03]).write(to: licenseURL)

			let preparedAsset = try OfflinePlaybackAVAsset(playbackAsset: playbackAsset(
				mediaURL: mediaURL,
				licenseURL: licenseURL
			))

			XCTAssertEqual(preparedAsset.urlAsset.url, mediaURL)
			XCTAssertTrue(preparedAsset.usesStoredLicense)
		#endif
	}

	func testProtectedAssetRejectsMissingStoredLicense() {
		let licenseURL = tempDir.appendingPathComponent("missing.key")

		XCTAssertThrowsError(try OfflinePlaybackAVAsset(playbackAsset: playbackAsset(
			mediaURL: tempDir.appendingPathComponent("media.movpkg"),
			licenseURL: licenseURL
		))) { error in
			XCTAssertEqual(error as? OfflinePlaybackAVAssetError, .storedLicenseNotFound(licenseURL))
		}
	}

	func testProtectedAssetRejectsUnreadableStoredLicense() throws {
		let licenseURL = tempDir.appendingPathComponent("license.key", isDirectory: true)
		try FileManager.default.createDirectory(at: licenseURL, withIntermediateDirectories: true)

		XCTAssertThrowsError(try OfflinePlaybackAVAsset(playbackAsset: playbackAsset(
			mediaURL: tempDir.appendingPathComponent("media.movpkg"),
			licenseURL: licenseURL
		))) { error in
			XCTAssertEqual(error as? OfflinePlaybackAVAssetError, .storedLicenseUnreadable(licenseURL))
		}
	}

	func testProtectedAssetRejectsEmptyStoredLicense() throws {
		let licenseURL = tempDir.appendingPathComponent("license.key")
		try Data().write(to: licenseURL)

		XCTAssertThrowsError(try OfflinePlaybackAVAsset(playbackAsset: playbackAsset(
			mediaURL: tempDir.appendingPathComponent("media.movpkg"),
			licenseURL: licenseURL
		))) { error in
			XCTAssertEqual(error as? OfflinePlaybackAVAssetError, .storedLicenseUnreadable(licenseURL))
		}
	}

	func testPreparedLookupInvalidatesCorruptLicenseAndSchedulesOneReplacement() async throws {
		let backend = StubOfflineApiClient()
		let mediaDownloader = SuspendingMediaDownloader()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: mediaDownloader
		)
		let mediaURL = tempDir.appendingPathComponent("track.movpkg")
		let licenseURL = tempDir.appendingPathComponent("track.key")
		try Data("media".utf8).write(to: mediaURL)
		try Data().write(to: licenseURL)
		let store = OfflineStore(lastDatabaseQueue)
		try store.storeMediaItem(StoreItemTaskResult(
			resourceType: OfflineMediaItemType.tracks.rawValue,
			resourceId: "track-id",
			catalogMetadata: .track(.mock(id: "track-id")),
			playbackMetadata: nil,
			collectionResourceType: OfflineCollectionType.albums.rawValue,
			collectionResourceId: "album-id",
			volume: 1,
			position: 1,
			addedAt: nil,
			mediaURL: mediaURL,
			licenseURL: licenseURL,
			artworkURL: nil
		))

		let firstAsset = await offliner.getOfflinePlaybackAVAsset(
			mediaType: .tracks,
			resourceId: .identifier("track-id")
		)
		let secondAsset = await offliner.getOfflinePlaybackAVAsset(
			mediaType: .tracks,
			resourceId: .identifier("track-id")
		)
		for _ in 0 ..< 100 where backend.addedItems.isEmpty {
			try await Task.sleep(nanoseconds: 10_000_000)
		}

		XCTAssertNil(firstAsset)
		XCTAssertNil(secondAsset)
		XCTAssertEqual(backend.addedItems.map(\.id), ["track-id"])
		let storedItem = try await store.getMediaItem(mediaType: .tracks, resourceId: "track-id")
		XCTAssertNil(storedItem)
	}

	private func playbackAsset(mediaURL: URL, licenseURL: URL?) -> OfflinePlaybackAsset {
		OfflinePlaybackAsset(
			playbackMetadata: nil,
			mediaURL: mediaURL,
			licenseURL: licenseURL
		)
	}
}
