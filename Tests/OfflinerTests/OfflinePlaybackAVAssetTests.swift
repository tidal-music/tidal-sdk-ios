import AVFoundation
import Foundation
@testable import Offliner
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

	func testProtectedAssetStructurallyPreparesNonEmptyStoredLicense() throws {
		#if targetEnvironment(simulator)
			throw XCTSkip("AVContentKeySession FairPlay construction is unavailable on simulators")
		#else
			let mediaURL = tempDir.appendingPathComponent("media.movpkg")
			let licenseURL = tempDir.appendingPathComponent("license.key")
			// Unit scope verifies retained setup only; AVFoundation validates license bytes during playback.
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

	func testPreparedLookupReturnsNilAndSchedulesRedownloadForEmptyStoredLicense() async throws {
		let backend = StubOfflineApiClient()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SuspendingMediaDownloader()
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

		let preparedAsset = await offliner.getOfflinePlaybackAVAsset(
			mediaType: .tracks,
			resourceId: .identifier("track-id")
		)
		let observedRepairRequest = try await backend.waitForAddedItems(count: 1)

		XCTAssertNil(preparedAsset)
		XCTAssertTrue(observedRepairRequest, "Timed out waiting for playback repair request")
		XCTAssertEqual(backend.addedItems.count, 1)
		XCTAssertEqual(backend.addedItems.first?.type, .track)
		XCTAssertEqual(backend.addedItems.first?.id, "track-id")
	}

	private func playbackAsset(mediaURL: URL, licenseURL: URL?) -> OfflinePlaybackAsset {
		OfflinePlaybackAsset(
			playbackMetadata: nil,
			mediaURL: mediaURL,
			licenseURL: licenseURL
		)
	}
}
