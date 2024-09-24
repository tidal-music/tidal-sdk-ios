import Foundation

// MARK: - Metrics

final class Metrics {
	private struct PlaybackEvent {
		enum PlaybackEventType {
			case PROGRESS
			case PAUSE
			case SEEK
			case STALL
		}

		let playbackEventType: PlaybackEventType
		let assetPosition: Double
		let timestamp: UInt64

		init(
			_ playbackEventType: PlaybackEventType,
			_ assetPosition: Double,
			_ timestamp: UInt64 = PlayerWorld.timeProvider.timestamp()
		) {
			self.playbackEventType = playbackEventType
			self.assetPosition = assetPosition
			self.timestamp = timestamp
		}
	}

	struct EndInfo: Equatable {
		enum Constants {
			static let ended_while_stalled = "Ended while stalled (counts as error)"
			static let failed_within_5seconds = "Ended and playback failed to start within 5 seconds (counts as error)"
		}

		let reason: EndReason
		let message: String?
		let code: String?
	}

	private var _idealStartTime: UInt64?
	private var _events: [PlaybackEvent]
	private var _endReason: EndReason?
	private var _endTime: UInt64?
	private var _endAssetPosition: Double?
	private var _error: Error?

	convenience init(idealStartTime: UInt64) {
		self.init()
		_idealStartTime = idealStartTime
	}

	init() {
		_events = []
	}

	var idealStartTime: UInt64? { _idealStartTime }
	var actualStartTime: UInt64? { _events.first { $0.playbackEventType == .PROGRESS }?.timestamp }
	var startAssetPosition: Double? { _events.first { $0.playbackEventType == .PROGRESS }?.assetPosition }
	var endAssetPosition: Double? { _endAssetPosition }
	var endTime: UInt64? { _endTime }

	var endInfo: EndInfo {
		if let endReason = _endReason {
			switch endReason {
			case .COMPLETE, .OTHER:
				return EndInfo(reason: endReason, message: nil, code: nil)
			case .ERROR:
				if let error = _error {
					let playerError = PlayerInternalError.from(error)
					return EndInfo(reason: endReason, message: playerError.technicalDescription, code: playerError.code)
				}
				return EndInfo(reason: endReason, message: nil, code: nil)
			}
		}

		if stalled() {
			return EndInfo(reason: .ERROR, message: EndInfo.Constants.ended_while_stalled, code: nil)
		}

		if playbackFailedToStartWithin5Seconds() {
			return EndInfo(reason: .ERROR, message: EndInfo.Constants.failed_within_5seconds, code: nil)
		}

		return EndInfo(reason: .OTHER, message: nil, code: nil)
	}

	var stalls: [Stall] {
		_events.enumerated()
			.filter { _, event in event.playbackEventType == .STALL }
			.map { i, event in
				Stall(
					reason: i > 0 && _events[i - 1].playbackEventType == .SEEK ? StallReason.SEEK : StallReason.UNEXPECTED,
					assetPosition: event.assetPosition,
					startTimestamp: event.timestamp,
					endTimestamp: _events.dropFirst(i).first {
						$0.playbackEventType == .PROGRESS
					}?.timestamp ?? PlayerWorld.timeProvider.timestamp()
				)
			}
	}

	var actions: [Action] {
		var actions = [Action]()
		for i in 0 ..< _events.count {
			let action = Action(
				actionType: _events[i].playbackEventType == .PROGRESS ? .PLAYBACK_START : .PLAYBACK_STOP,
				assetPosition: _events[i].assetPosition,
				timestamp: _events[i].timestamp
			)

			if action.actionType != actions.last?.actionType {
				actions.append(action)
			}
		}

		if actions.first?.actionType == .PLAYBACK_START {
			actions.removeFirst()
		}

		return actions
	}

	func recordProgress(at assetPosition: Double) {
		_events.append(PlaybackEvent(.PROGRESS, assetPosition))
	}

	func recordPause(at assetPosition: Double) {
		_events.append(PlaybackEvent(.PAUSE, assetPosition))
	}

	func recordSeek(at assetPosition: Double) {
		_events.append(PlaybackEvent(.SEEK, assetPosition))
	}

	func recordStall(at assetPosition: Double) {
		// Do not record stalls that occurs before playback has started. The reasoning behind this
		// is that any loading before playback should affect the statistical start up time, not the
		// stall rate or stall duration.
		if actualStartTime != nil {
			_events.append(PlaybackEvent(.STALL, assetPosition))
		}
	}

	func recordEnd(endReason: EndReason, assetPosition: Double, error: Error? = nil) {
		_endReason = endReason
		_endAssetPosition = assetPosition
		_endTime = PlayerWorld.timeProvider.timestamp()
		_error = error
	}
}

private extension Metrics {
	func stalled() -> Bool {
		_events.last?.playbackEventType == .STALL
	}

	func playbackFailedToStartWithin5Seconds() -> Bool {
		guard let idealStartTime else {
			// idealStartTime isn't set, so there has been no intention to start playback.
			// If no one has tried to play, playback cannot fail.
			PlayerWorld.logger?.log(loggable: PlayerLoggable.metricsNoIdealStartTime)
			return false
		}

		// If the actualStartTime is nil playback has not yet started.
		let now = PlayerWorld.timeProvider.timestamp()
		let hasPlaybackStarted = (now > idealStartTime) && (now - idealStartTime > 5000)
		return actualStartTime == nil && hasPlaybackStarted
	}
}
