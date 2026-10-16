@testable import Offliner
import XCTest

final class BackendFailureTests: OfflinerTestCase {
	func testTaskIsSkippedWhenInProgressUpdateFailsAndRetriedWhenRedelivered() async throws {
		let backend = FailOnUpdateToInProgressOfflineApiClient()
		await backend.setFailingInProgressTaskIds(["task-0"])
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await offliner.download(mediaType: .tracks, resourceId: .identifier("failing-track"))
		try await offliner.download(mediaType: .tracks, resourceId: .identifier("track-456"))

		await runUntil(offliner) { await !backend.remainingTaskIds.contains("task-1") }

		let skippedItem = try await offliner.getOfflineMediaItem(mediaType: .tracks, resourceId: .identifier("failing-track"))
		XCTAssertNil(skippedItem)

		let storedItem = try await offliner.getOfflineMediaItem(mediaType: .tracks, resourceId: .identifier("track-456"))
		XCTAssertNotNil(storedItem)

		await backend.setFailingInProgressTaskIds([])
		await runUntil(offliner) { await backend.remainingTaskIds.isEmpty }
		await runUntil(offliner) { await offliner.currentDownloads.isEmpty }

		let retriedItem = try await offliner.getOfflineMediaItem(mediaType: .tracks, resourceId: .identifier("failing-track"))
		XCTAssertNotNil(retriedItem)

		let performedTaskIds = await backend.performedTaskIds
		XCTAssertEqual(performedTaskIds, ["task-1", "task-0"])
	}

	func testDownloadTrackCompletesLocallyEvenWhenBackendUpdateFails() async throws {
		let backend = FailOnUpdateToCompletedOfflineApiClient()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await offliner.download(mediaType: .tracks, resourceId: .identifier("track-123"))

		let downloads = offliner.newDownloads
		async let runTask: () = offliner.run()

		for await download in downloads {
			let events = download.events
			await assertEventually(events) { event in
				if case .state(.completed) = event {
					return true
				}
				return false
			}
			break
		}

		await runTask

		let storedItem = try await offliner.getOfflineMediaItem(mediaType: .tracks, resourceId: .identifier("track-123"))
		XCTAssertNotNil(storedItem)
	}

	func testDownloadTrackFailsWhenAddItemFails() async throws {
		let offliner = createOffliner(
			offlineApiClient: FailingOfflineApiClient(),
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		do {
			try await offliner.download(mediaType: .tracks, resourceId: .identifier("track-123"))
			XCTFail("Expected download to throw when addItem fails")
		} catch {
			// Expected - addItem failure should propagate
		}

		let downloads = await offliner.currentDownloads
		XCTAssertEqual(downloads.count, 0)
	}

	func testDownloadAlbumFailsWhenAddItemFails() async throws {
		let offliner = createOffliner(
			offlineApiClient: FailingOfflineApiClient(),
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		do {
			try await offliner.download(collectionType: .albums, resourceId: .identifier("album-123"))
			XCTFail("Expected download to throw when addItem fails")
		} catch {
			// Expected - addItem failure should propagate
		}
	}

	func testGetTasksFailureDoesNotHaltRun() async throws {
		let backend = FailOnGetTasksOfflineApiClient()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		await offliner.run()
	}

	private func runUntil(
		_ offliner: Offliner,
		timeout: TimeInterval = 10,
		file: StaticString = #filePath,
		line: UInt = #line,
		condition: () async -> Bool
	) async {
		let deadline = Date().addingTimeInterval(timeout)
		while await !condition() {
			guard Date() < deadline else {
				return XCTFail("Timed out waiting for condition", file: file, line: line)
			}
			await offliner.run()
			try? await Task.sleep(nanoseconds: 10_000_000)
		}
	}
}
