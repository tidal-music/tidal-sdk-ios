@testable import Player
import Testing

// MARK: - Constants

private enum Constants {
	static let initialTime: UInt64 = 1
	static let assetPosition: Double = 2
}

// MARK: - MetricsTests

@Suite(.serialized)
final class MetricsTests {
	private var timestamp: UInt64 = Constants.initialTime
	private var metrics: Metrics!

	init() {
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

	@Test
	func test_playbackFailedWithin5seconds() {
		// Test arithmetic overflow crash when now > idealStartTime
		timestamp = 0
		#expect(metrics.endTime == nil)
		#expect(metrics.endAssetPosition == nil)
		#expect(metrics.endInfo == Metrics.EndInfo.mock(reason: .OTHER))

		timestamp = 5005
		#expect(metrics.endTime == nil)
		#expect(metrics.endAssetPosition == nil)
		#expect(
			metrics.endInfo ==
				Metrics.EndInfo.mock(reason: .ERROR, message: Metrics.EndInfo.Constants.failed_within_5seconds)
		)
	}

	@Test
	func test_recordProgress() {
		assertRecordProgress()
	}

	func assertRecordProgress() {
		timestamp = Constants.initialTime

		let assetPosition = Constants.assetPosition
		metrics.recordProgress(at: assetPosition)

		#expect(metrics.idealStartTime == Constants.initialTime)
		#expect(metrics.actualStartTime == timestamp)
		#expect(metrics.startAssetPosition == assetPosition)

		#expect(metrics.endTime == nil)
		#expect(metrics.endAssetPosition == nil)
		#expect(metrics.endInfo == Metrics.EndInfo.mock(reason: .OTHER))

		#expect(metrics.actions == [])
		#expect(metrics.stalls == [])
	}

	// MARK: - recordPause

	@Test
	func test_recordPause() {
		timestamp = Constants.initialTime

		let assetPosition = Constants.assetPosition
		metrics.recordPause(at: assetPosition)

		#expect(metrics.idealStartTime == Constants.initialTime)
		#expect(metrics.actualStartTime == nil)
		#expect(metrics.startAssetPosition == nil)

		#expect(metrics.endTime == nil)
		#expect(metrics.endAssetPosition == nil)
		#expect(metrics.endInfo == Metrics.EndInfo.mock(reason: .OTHER))

		let actions = [Action.mock(actionType: .PLAYBACK_STOP, assetPosition: assetPosition, timestamp: timestamp)]
		#expect(metrics.actions == actions)
		#expect(metrics.stalls == [])
	}

	// MARK: - recordSeek

	@Test
	func test_recordSeek() {
		timestamp = Constants.initialTime

		let assetPosition = Constants.assetPosition
		metrics.recordSeek(at: assetPosition)

		#expect(metrics.idealStartTime == Constants.initialTime)
		#expect(metrics.actualStartTime == nil)
		#expect(metrics.startAssetPosition == nil)

		#expect(metrics.endTime == nil)
		#expect(metrics.endAssetPosition == nil)
		#expect(metrics.endInfo == Metrics.EndInfo.mock(reason: .OTHER))

		let actions = [Action.mock(actionType: .PLAYBACK_STOP, assetPosition: assetPosition, timestamp: timestamp)]
		#expect(metrics.actions == actions)
		#expect(metrics.stalls == [])
	}

	// MARK: - recordStall

	@Test
	func test_recordStall() {
		timestamp = Constants.initialTime

		let assetPosition = Constants.assetPosition
		metrics.recordStall(at: assetPosition)

		#expect(metrics.idealStartTime == Constants.initialTime)
		#expect(metrics.actualStartTime == nil)
		#expect(metrics.startAssetPosition == nil)

		#expect(metrics.endTime == nil)
		#expect(metrics.endAssetPosition == nil)
		#expect(metrics.endInfo == Metrics.EndInfo.mock(reason: .OTHER))

		#expect(metrics.actions == [])
		#expect(metrics.stalls == [])
	}

	@Test
	func test_recordStall_after_recordProgress() {
		assertRecordProgress()

		timestamp = 2

		let assetPosition2: Double = 3
		metrics.recordStall(at: assetPosition2)

		#expect(metrics.idealStartTime == Constants.initialTime)
		#expect(metrics.actualStartTime == Constants.initialTime)
		#expect(metrics.startAssetPosition == Constants.assetPosition)

		#expect(metrics.endTime == nil)
		#expect(metrics.endAssetPosition == nil)
		#expect(metrics.endInfo == Metrics.EndInfo.mock(reason: .ERROR, message: "Ended while stalled (counts as error)"))

		let actions = [Action.mock(actionType: .PLAYBACK_STOP, assetPosition: assetPosition2, timestamp: timestamp)]
		#expect(metrics.actions == actions)

		let stalls = [Stall.mock(
			reason: .UNEXPECTED,
			assetPosition: assetPosition2,
			startTimestamp: timestamp,
			endTimestamp: timestamp
		)]
		#expect(metrics.stalls == stalls)
	}

	@Test
	func test_recordStall_after_recordProgress_and_recordSeek() {
		assertRecordProgress()

		// record seek
		timestamp = 2

		let assetPosition: Double = 3
		metrics.recordSeek(at: assetPosition)

		#expect(metrics.idealStartTime == Constants.initialTime)
		#expect(metrics.actualStartTime == Constants.initialTime)
		#expect(metrics.startAssetPosition == Constants.assetPosition)

		#expect(metrics.endTime == nil)
		#expect(metrics.endAssetPosition == nil)
		#expect(metrics.endInfo == Metrics.EndInfo.mock(reason: .OTHER))

		let actions = [Action.mock(actionType: .PLAYBACK_STOP, assetPosition: assetPosition, timestamp: timestamp)]
		#expect(metrics.actions == actions)
		#expect(metrics.stalls == [])

		// record stall
		timestamp = 3

		let assetPosition2: Double = 4
		metrics.recordStall(at: assetPosition2)

		#expect(metrics.idealStartTime == Constants.initialTime)
		#expect(metrics.actualStartTime == Constants.initialTime)
		#expect(metrics.startAssetPosition == Constants.assetPosition)

		#expect(metrics.endTime == nil)
		#expect(metrics.endAssetPosition == nil)
		#expect(metrics.endInfo == Metrics.EndInfo.mock(reason: .ERROR, message: "Ended while stalled (counts as error)"))

		// no changes to actions, same as aftre progress
		#expect(metrics.actions == actions)

		let stalls = [Stall.mock(
			reason: .SEEK,
			assetPosition: assetPosition2,
			startTimestamp: timestamp,
			endTimestamp: timestamp
		)]
		#expect(metrics.stalls == stalls)
	}

	// MARK: - recordEnd

	@Test
	func test_recordEnd_whenReasonIsComplete() {
		timestamp = Constants.initialTime

		let assetPosition = Constants.assetPosition
		metrics.recordEnd(endReason: .COMPLETE, assetPosition: assetPosition, error: nil)

		#expect(metrics.idealStartTime == Constants.initialTime)
		#expect(metrics.actualStartTime == nil)
		#expect(metrics.startAssetPosition == nil)

		#expect(metrics.endTime == timestamp)
		#expect(metrics.endAssetPosition == assetPosition)
		#expect(metrics.endInfo == Metrics.EndInfo.mock(reason: .COMPLETE))

		#expect(metrics.actions == [])
		#expect(metrics.stalls == [])
	}

	@Test
	func test_recordEnd_whenReasonIsError() {
		timestamp = Constants.initialTime

		let assetPosition = Constants.assetPosition
		let error = PlayerError(errorId: ErrorId.EUnexpected, errorCode: "")
		metrics.recordEnd(endReason: .ERROR, assetPosition: assetPosition, error: error)

		#expect(metrics.idealStartTime == Constants.initialTime)
		#expect(metrics.actualStartTime == nil)
		#expect(metrics.startAssetPosition == nil)

		#expect(metrics.endTime == timestamp)
		#expect(metrics.endAssetPosition == assetPosition)
		#expect(
			metrics.endInfo ==
				Metrics.EndInfo.mock(
					reason: .ERROR,
					message: "PlayerError(errorId: Player.ErrorId.EUnexpected, errorCode: \"\")",
					code: "14:1"
				)
		)

		#expect(metrics.actions == [])
		#expect(metrics.stalls == [])
	}

	@Test
	func test_recordEnd_whenReasonIsError_withoutError() {
		timestamp = Constants.initialTime

		let assetPosition = Constants.assetPosition
		metrics.recordEnd(endReason: .ERROR, assetPosition: assetPosition)

		#expect(metrics.idealStartTime == Constants.initialTime)
		#expect(metrics.actualStartTime == nil)
		#expect(metrics.startAssetPosition == nil)

		#expect(metrics.endTime == timestamp)
		#expect(metrics.endAssetPosition == assetPosition)
		#expect(metrics.endInfo == Metrics.EndInfo.mock(reason: .ERROR))

		#expect(metrics.actions == [])
		#expect(metrics.stalls == [])
	}

	@Test
	func test_recordEnd_afterRecordProgress() {
		assertRecordProgress()

		timestamp = 2

		let assetPosition = Constants.assetPosition
		metrics.recordEnd(endReason: .COMPLETE, assetPosition: assetPosition, error: nil)

		#expect(metrics.idealStartTime == Constants.initialTime)
		#expect(metrics.actualStartTime == Constants.initialTime)
		#expect(metrics.startAssetPosition == assetPosition)

		#expect(metrics.endTime == timestamp)
		#expect(metrics.endAssetPosition == assetPosition)
		#expect(metrics.endInfo == Metrics.EndInfo.mock(reason: .COMPLETE))

		#expect(metrics.actions == [])
		#expect(metrics.stalls == [])
	}

	// MARK: - Playback fail

	@Test
	func test_playbackFailedToStartWithin5Seconds() {
		let initialTimestamp = Constants.initialTime
		timestamp = initialTimestamp

		// record seek
		let assetPosition = Constants.assetPosition
		metrics.recordSeek(at: assetPosition)

		// pass more than 5 seconds
		timestamp = 5100

		#expect(metrics.idealStartTime == Constants.initialTime)
		#expect(metrics.actualStartTime == nil)
		#expect(metrics.startAssetPosition == nil)

		#expect(metrics.endTime == nil)
		#expect(metrics.endAssetPosition == nil)
		#expect(
			metrics.endInfo ==
				Metrics.EndInfo.mock(reason: .ERROR, message: "Ended and playback failed to start within 5 seconds (counts as error)")
		)

		let actions = [Action.mock(actionType: .PLAYBACK_STOP, assetPosition: assetPosition, timestamp: initialTimestamp)]
		#expect(metrics.actions == actions)
		#expect(metrics.stalls == [])
	}
}
