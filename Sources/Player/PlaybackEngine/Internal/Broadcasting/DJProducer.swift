import Auth
import Foundation

// MARK: - DJProducer

final class DJProducer {
	private static let CREATE_BROADCAST_URL = URL(string: "https://api.tidal.com/v2/djsession")!

	weak var delegate: DJProducerListener?

	private let queue: OperationQueue
	private let httpClient: HttpClient
	private let accessTokenProvider: AccessTokenProvider
	private let credentialsProvider: CredentialsProvider
	private let featureFlagProvider: FeatureFlagProvider

	private var stopOnNextCommand: Bool
	@Atomic private var curationUrl: URL?

	init(
		httpClient: HttpClient,
		with accessTokenProvider: AccessTokenProvider,
		credentialsProvider: CredentialsProvider,
		featureFlagProvider: FeatureFlagProvider
	) {
		self.httpClient = httpClient
		self.accessTokenProvider = accessTokenProvider
		self.credentialsProvider = credentialsProvider
		self.featureFlagProvider = featureFlagProvider

		queue = OperationQueue()
		queue.maxConcurrentOperationCount = 1

		stopOnNextCommand = false
	}

	func start(_ title: String, with mediaProduct: MediaProduct, at position: Double) {
		queue.dispatch {
			guard self.curationUrl == nil else {
				return
			}

			do {
				let response: CreateBroadcastResponse

				let token = try await self.credentialsProvider.getAuthBearerToken()
				response = try await self.httpClient.postJson(
					url: DJProducer.CREATE_BROADCAST_URL,
					headers: ["Authorization": token, "Content-type": "text/plain"],
					payload: title.data(using: .utf8)
				)

				let sessionData = DJSessionMetadata(
					sessionId: response.broadcastId,
					title: title,
					sharingURL: response.sharingUrl,
					reactions: response.reactions
				)
				self.delegate?.djSessionStarted(metadata: sessionData)
				self.curationUrl = response.curationUrl
			} catch {
				self.delegate?.djSessionEnded(reason: .failedToStart(code: DJProducer.errorCode(from: error)))
			}

			self.play(mediaProduct, at: position)
		}
	}

	func play(_ mediaProduct: MediaProduct, at position: Double) {
		queue.dispatch {
			guard let curationUrl = self.curationUrl else {
				return
			}

			guard mediaProduct.productType == .TRACK else {
				await self.delete(url: curationUrl, reason: .invalidContent)
				return
			}

			let now = PlayerWorld.timeProvider.timestamp()
			await self.send(
				Command.play(mediaProduct.productId, at: DJProducer.convertToMilliseconds(position), timestamp: now),
				to: curationUrl
			)
		}
	}

	func pause(_ mediaProduct: MediaProduct) {
		queue.dispatch {
			guard let curationUrl = self.curationUrl else {
				return
			}

			let now = PlayerWorld.timeProvider.timestamp()
			await self.send(Command.pause(mediaProduct.productId, timestamp: now), to: curationUrl)
		}
	}

	func stop(immediately: Bool) {
		queue.dispatch {
			guard let curationUrl = self.curationUrl else {
				return
			}

			guard immediately else {
				self.stopOnNextCommand = true
				return
			}

			await self.delete(url: curationUrl, reason: .userControlled)
		}
	}

	func reset(_ error: Error) {
		queue.dispatch {
			guard let curationUrl = self.curationUrl else {
				self.clearSession()
				return
			}

			await self.delete(url: curationUrl, reason: DJProducer.reason(from: error))
		}
	}

	var isLive: Bool {
		curationUrl != nil
	}
}

private extension DJProducer {
	func send(_ command: Command, to url: URL) async {
		if stopOnNextCommand {
			stop(immediately: true)
			return
		}

		do {
			_ = try await httpClient.putJsonReceiveData(url: url, headers: [:], payload: command)
		} catch {
			endSession(with: DJProducer.reason(from: error))
		}
	}

	func clearSession() {
		curationUrl = nil
		stopOnNextCommand = false
	}

	func endSession(with reason: DJSessionEndReason) {
		clearSession()
		delegate?.djSessionEnded(reason: reason)
	}

	func delete(url: URL, reason: DJSessionEndReason) async {
		endSession(with: reason)
		_ = try? await httpClient.delete(url: url, headers: [:])
	}

	static func convertToMilliseconds(_ position: Double) -> UInt64 {
		if !position.isNaN, position.isFinite, position > 0 {
			return UInt64(position * 1000)
		}

		return 0
	}

	static func errorCode(from error: Error) -> String {
		if let error = error as? PlayerInternalError {
			return error.code
		}

		if let error = error as? HttpError {
			return String(statusCode(of: error))
		}

		return String((error as NSError).code)
	}

	static func reason(from error: Error) -> DJSessionEndReason {
		if let error = error as? PlayerInternalError {
			return .error(code: error.code)
		}

		guard let error = error as? HttpError else {
			return .error(code: String((error as NSError).code))
		}

		let statusCode = statusCode(of: error)
		if statusCode == 403 {
			return .maxDurationReached
		}

		return .error(code: String(statusCode))
	}

	static func statusCode(of error: HttpError) -> Int {
		switch error {
		case let .httpClientError(statusCode, _):
			statusCode
		case let .httpServerError(statusCode):
			statusCode
		}
	}
}
