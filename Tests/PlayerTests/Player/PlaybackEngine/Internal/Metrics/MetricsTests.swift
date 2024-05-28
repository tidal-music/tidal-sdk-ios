@testable import Player
import XCTest

// MARK: - Constants

private enum Constants {
	static let initialTime: UInt64 = 1
	static let assetPosition: Double = 2
}

// MARK: - MetricsTests

final class MetricsTests: XCTestCase {
	private var timestamp: UInt64 = Constants.initialTime
	private var metrics: Metrics!

	override func setUp() {
		let timeProvider = TimeProvider.mock(
			timestamp: {
				self.timestamp
			}
		)
		PlayerWorld = PlayerWorldClient.mock(timeProvider: timeProvider)

		metrics = Metrics(idealStartTime: Constants.initialTime)
	}
}

extension MetricsTests {
	// MARK: - recordProgress

	func test_playbackFailedWithin5seconds() {
		// Test arithmetic overflow crash when now > idealStartTime
		timestamp = 0
		XCTAssertEqual(metrics.endTime, nil)
		XCTAssertEqual(metrics.endAssetPosition, nil)
		XCTAssertEqual(metrics.endInfo, Metrics.EndInfo.mock(reason: .OTHER))

		timestamp = 5005
		XCTAssertEqual(metrics.endTime, nil)
		XCTAssertEqual(metrics.endAssetPosition, nil)
		XCTAssertEqual(
			metrics.endInfo,
			Metrics.EndInfo.mock(reason: .ERROR, message: Metrics.EndInfo.Constants.failed_within_5seconds)
		)
	}

	func test_recordProgress() {
		assertRecordProgress()
	}

	func assertRecordProgress() {
		timestamp = Constants.initialTime

		let assetPosition = Constants.assetPosition
		metrics.recordProgress(at: assetPosition)

		XCTAssertEqual(metrics.idealStartTime, Constants.initialTime)
		XCTAssertEqual(metrics.actualStartTime, timestamp)
		XCTAssertEqual(metrics.startAssetPosition, assetPosition)

		XCTAssertEqual(metrics.endTime, nil)
		XCTAssertEqual(metrics.endAssetPosition, nil)
		XCTAssertEqual(metrics.endInfo, Metrics.EndInfo.mock(reason: .OTHER))

		XCTAssertEqual(metrics.actions, [])
		XCTAssertEqual(metrics.stalls, [])
	}

	// MARK: - recordPause

	func test_recordPause() {
		timestamp = Constants.initialTime

		let assetPosition = Constants.assetPosition
		metrics.recordPause(at: assetPosition)

		XCTAssertEqual(metrics.idealStartTime, Constants.initialTime)
		XCTAssertEqual(metrics.actualStartTime, nil)
		XCTAssertEqual(metrics.startAssetPosition, nil)

		XCTAssertEqual(metrics.endTime, nil)
		XCTAssertEqual(metrics.endAssetPosition, nil)
		XCTAssertEqual(metrics.endInfo, Metrics.EndInfo.mock(reason: .OTHER))

		let actions = [Action.mock(actionType: .PLAYBACK_STOP, assetPosition: assetPosition, timestamp: timestamp)]
		XCTAssertEqual(metrics.actions, actions)
		XCTAssertEqual(metrics.stalls, [])
	}

	// MARK: - recordSeek

	func test_recordSeek() {
		timestamp = Constants.initialTime

		let assetPosition = Constants.assetPosition
		metrics.recordSeek(at: assetPosition)

		XCTAssertEqual(metrics.idealStartTime, Constants.initialTime)
		XCTAssertEqual(metrics.actualStartTime, nil)
		XCTAssertEqual(metrics.startAssetPosition, nil)

		XCTAssertEqual(metrics.endTime, nil)
		XCTAssertEqual(metrics.endAssetPosition, nil)
		XCTAssertEqual(metrics.endInfo, Metrics.EndInfo.mock(reason: .OTHER))

		let actions = [Action.mock(actionType: .PLAYBACK_STOP, assetPosition: assetPosition, timestamp: timestamp)]
		XCTAssertEqual(metrics.actions, actions)
		XCTAssertEqual(metrics.stalls, [])
	}

	// MARK: - recordStall

	func test_recordStall() {
		timestamp = Constants.initialTime

		let assetPosition = Constants.assetPosition
		metrics.recordStall(at: assetPosition)

		XCTAssertEqual(metrics.idealStartTime, Constants.initialTime)
		XCTAssertEqual(metrics.actualStartTime, nil)
		XCTAssertEqual(metrics.startAssetPosition, nil)

		XCTAssertEqual(metrics.endTime, nil)
		XCTAssertEqual(metrics.endAssetPosition, nil)
		XCTAssertEqual(metrics.endInfo, Metrics.EndInfo.mock(reason: .OTHER))

		XCTAssertEqual(metrics.actions, [])
		XCTAssertEqual(metrics.stalls, [])
	}

	func test_recordStall_after_recordProgress() {
		assertRecordProgress()

		timestamp = 2

		let assetPosition2: Double = 3
		metrics.recordStall(at: assetPosition2)

		XCTAssertEqual(metrics.idealStartTime, Constants.initialTime)
		XCTAssertEqual(metrics.actualStartTime, Constants.initialTime)
		XCTAssertEqual(metrics.startAssetPosition, Constants.assetPosition)

		XCTAssertEqual(metrics.endTime, nil)
		XCTAssertEqual(metrics.endAssetPosition, nil)
		XCTAssertEqual(metrics.endInfo, Metrics.EndInfo.mock(reason: .ERROR, message: "Ended while stalled (counts as error)"))

		let actions = [Action.mock(actionType: .PLAYBACK_STOP, assetPosition: assetPosition2, timestamp: timestamp)]
		XCTAssertEqual(metrics.actions, actions)

		let stalls = [Stall.mock(
			reason: .UNEXPECTED,
			assetPosition: assetPosition2,
			startTimestamp: timestamp,
			endTimestamp: timestamp
		)]
		XCTAssertEqual(metrics.stalls, stalls)
	}

	func test_recordStall_after_recordProgress_and_recordSeek() {
		assertRecordProgress()

		// record seek
		timestamp = 2

		let assetPosition: Double = 3
		metrics.recordSeek(at: assetPosition)

		XCTAssertEqual(metrics.idealStartTime, Constants.initialTime)
		XCTAssertEqual(metrics.actualStartTime, Constants.initialTime)
		XCTAssertEqual(metrics.startAssetPosition, Constants.assetPosition)

		XCTAssertEqual(metrics.endTime, nil)
		XCTAssertEqual(metrics.endAssetPosition, nil)
		XCTAssertEqual(metrics.endInfo, Metrics.EndInfo.mock(reason: .OTHER))

		let actions = [Action.mock(actionType: .PLAYBACK_STOP, assetPosition: assetPosition, timestamp: timestamp)]
		XCTAssertEqual(metrics.actions, actions)
		XCTAssertEqual(metrics.stalls, [])

		// record stall
		timestamp = 3

		let assetPosition2: Double = 4
		metrics.recordStall(at: assetPosition2)

		XCTAssertEqual(metrics.idealStartTime, Constants.initialTime)
		XCTAssertEqual(metrics.actualStartTime, Constants.initialTime)
		XCTAssertEqual(metrics.startAssetPosition, Constants.assetPosition)

		XCTAssertEqual(metrics.endTime, nil)
		XCTAssertEqual(metrics.endAssetPosition, nil)
		XCTAssertEqual(metrics.endInfo, Metrics.EndInfo.mock(reason: .ERROR, message: "Ended while stalled (counts as error)"))

		// no changes to actions, same as aftre progress
		XCTAssertEqual(metrics.actions, actions)

		let stalls = [Stall.mock(
			reason: .SEEK,
			assetPosition: assetPosition2,
			startTimestamp: timestamp,
			endTimestamp: timestamp
		)]
		XCTAssertEqual(metrics.stalls, stalls)
	}

	// MARK: - recordEnd

	func test_recordEnd_whenReasonIsComplete() {
		timestamp = Constants.initialTime

		let assetPosition = Constants.assetPosition
		metrics.recordEnd(endReason: .COMPLETE, assetPosition: assetPosition, error: nil)

		XCTAssertEqual(metrics.idealStartTime, Constants.initialTime)
		XCTAssertEqual(metrics.actualStartTime, nil)
		XCTAssertEqual(metrics.startAssetPosition, nil)

		XCTAssertEqual(metrics.endTime, timestamp)
		XCTAssertEqual(metrics.endAssetPosition, assetPosition)
		XCTAssertEqual(metrics.endInfo, Metrics.EndInfo.mock(reason: .COMPLETE))

		XCTAssertEqual(metrics.actions, [])
		XCTAssertEqual(metrics.stalls, [])
	}

	func test_recordEnd_whenReasonIsError() {
		timestamp = Constants.initialTime

		let assetPosition = Constants.assetPosition
		let error = PlayerError(errorId: ErrorId.EUnexpected, errorCode: "")
		metrics.recordEnd(endReason: .ERROR, assetPosition: assetPosition, error: error)

		XCTAssertEqual(metrics.idealStartTime, Constants.initialTime)
		XCTAssertEqual(metrics.actualStartTime, nil)
		XCTAssertEqual(metrics.startAssetPosition, nil)

		XCTAssertEqual(metrics.endTime, timestamp)
		XCTAssertEqual(metrics.endAssetPosition, assetPosition)
		XCTAssertEqual(
			metrics.endInfo,
			Metrics.EndInfo.mock(
				reason: .ERROR,
				message: "PlayerError(errorId: Player.ErrorId.EUnexpected, errorCode: \"\")",
				code: "14:1"
			)
		)

		XCTAssertEqual(metrics.actions, [])
		XCTAssertEqual(metrics.stalls, [])
	}

	func test_recordEnd_whenReasonIsError_withoutError() {
		timestamp = Constants.initialTime

		let assetPosition = Constants.assetPosition
		metrics.recordEnd(endReason: .ERROR, assetPosition: assetPosition)

		XCTAssertEqual(metrics.idealStartTime, Constants.initialTime)
		XCTAssertEqual(metrics.actualStartTime, nil)
		XCTAssertEqual(metrics.startAssetPosition, nil)

		XCTAssertEqual(metrics.endTime, timestamp)
		XCTAssertEqual(metrics.endAssetPosition, assetPosition)
		XCTAssertEqual(metrics.endInfo, Metrics.EndInfo.mock(reason: .ERROR))

		XCTAssertEqual(metrics.actions, [])
		XCTAssertEqual(metrics.stalls, [])
	}

	func test_recordEnd_afterRecordProgress() {
		assertRecordProgress()

		timestamp = 2

		let assetPosition = Constants.assetPosition
		metrics.recordEnd(endReason: .COMPLETE, assetPosition: assetPosition, error: nil)

		XCTAssertEqual(metrics.idealStartTime, Constants.initialTime)
		XCTAssertEqual(metrics.actualStartTime, Constants.initialTime)
		XCTAssertEqual(metrics.startAssetPosition, assetPosition)

		XCTAssertEqual(metrics.endTime, timestamp)
		XCTAssertEqual(metrics.endAssetPosition, assetPosition)
		XCTAssertEqual(metrics.endInfo, Metrics.EndInfo.mock(reason: .COMPLETE))

		XCTAssertEqual(metrics.actions, [])
		XCTAssertEqual(metrics.stalls, [])
	}

	// MARK: - Playback fail

	func test_playbackFailedToStartWithin5Seconds() {
		let initialTimestamp = Constants.initialTime
		timestamp = initialTimestamp

		// record seek
		let assetPosition = Constants.assetPosition
		metrics.recordSeek(at: assetPosition)

		// pass more than 5 seconds
		timestamp = 5100

		XCTAssertEqual(metrics.idealStartTime, Constants.initialTime)
		XCTAssertEqual(metrics.actualStartTime, nil)
		XCTAssertEqual(metrics.startAssetPosition, nil)

		XCTAssertEqual(metrics.endTime, nil)
		XCTAssertEqual(metrics.endAssetPosition, nil)
		XCTAssertEqual(
			metrics.endInfo,
			Metrics.EndInfo.mock(reason: .ERROR, message: "Ended and playback failed to start within 5 seconds (counts as error)")
		)

		let actions = [Action.mock(actionType: .PLAYBACK_STOP, assetPosition: assetPosition, timestamp: initialTimestamp)]
		XCTAssertEqual(metrics.actions, actions)
		XCTAssertEqual(metrics.stalls, [])
	}
}
