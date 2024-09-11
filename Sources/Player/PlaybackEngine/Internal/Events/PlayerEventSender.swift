import Auth
import EventProducer
import Foundation

private let MAX_BATCH_SIZE: Int = 100
private let SEND_TIME_INTERVAL: TimeInterval = 30.0
private let EVENT_URL: URL = URL(string: "https://et.tidal.com/api/events")!
private let OFFLINE_PLAYS_URL: URL = URL(string: "https://api.tidal.com/v1/report/offlineplays")!

// MARK: - PlayerEventSender

class PlayerEventSender {
	private let configuration: Configuration
	private let httpClient: HttpClient
	private let credentialsProvider: CredentialsProvider
	private let dataWriter: DataWriterProtocol
	private let featureFlagProvider: FeatureFlagProvider
	private let eventSender: EventSender

	@Atomic private var userClientIdSupplier: (() -> Int)?

	private let encoder: JSONEncoder
	private let eventsDirectory: URL
	private let offlinePlaysDirectory: URL
	private var timer: Timer?

	private let fileManager = PlayerWorld.fileManagerClient

	private let asyncSchedulerFactory: AsyncSchedulerFactory

	init(
		configuration: Configuration,
		httpClient: HttpClient,
		credentialsProvider: CredentialsProvider,
		dataWriter: DataWriterProtocol,
		featureFlagProvider: FeatureFlagProvider,
		eventSender: EventSender,
		userClientIdSupplier: (() -> Int)? = nil
	) {
		self.configuration = configuration
		self.httpClient = httpClient
		self.credentialsProvider = credentialsProvider
		self.dataWriter = dataWriter
		self.featureFlagProvider = featureFlagProvider
		self.eventSender = eventSender
		self.userClientIdSupplier = userClientIdSupplier
		asyncSchedulerFactory = PlayerWorld.asyncSchedulerFactoryProvider.newFactory()

		encoder = JSONEncoder()

		PlayerEventSender.migrateLegacyDirectory(from: "boombox_events", to: "player_events")

		if let eventsDirectory = PlayerEventSender.initializeDirectory(name: "player_events") {
			self.eventsDirectory = eventsDirectory
		} else {
			preconditionFailure("[Player] Failed to initilize Events directory")
		}

		if let offlinePlaysDirectory = PlayerEventSender.initializeDirectory(name: "offline_plays") {
			self.offlinePlaysDirectory = offlinePlaysDirectory
		} else {
			preconditionFailure("[Player] Failed to initilize Offline Plays directory")
		}

		initializeTimer()
	}

	deinit {
		timer?.invalidate()
	}

	func send(_ event: any StreamingMetricsEvent) {
		write(group: .streamingMetrics, name: event.name, payload: event, extras: nil)
	}

	func send(_ event: PlayLogEvent, extras: [String: String?]?) {
		write(group: .playlog, name: EventNames.playbackSession, payload: event, extras: extras)
	}

	func send(_ offlinePlay: OfflinePlay) {
		asyncSchedulerFactory.create { [weak self] in
			guard let self else {
				return
			}

			do {
				let data = try encoder.encode(offlinePlay)
				let uuid = PlayerWorld.uuidProvider.uuidString()
				let url = offlinePlaysDirectory.appendingPathComponent(uuid)
				try dataWriter.write(data: data, to: url, options: .atomic)
			} catch {
				// TODO: This error should be centrally logged
			}
		}
	}

	func writeEvent<T: Codable & Equatable>(event: LegacyEvent<T>) {
		do {
			let data = try encoder.encode(event)
			let uuid = PlayerWorld.uuidProvider.uuidString()
			let url = eventsDirectory.appendingPathComponent(uuid)
			try dataWriter.write(data: data, to: url, options: .atomic)
		} catch {
			// TODO: This error should be centrally logged
		}
	}
}

private extension PlayerEventSender {
	static func urlPathForDirectory(name: String) -> URL? {
		do {
			let fileManager = PlayerWorld.fileManagerClient

			let url = try fileManager.url(
				for: .documentDirectory,
				in: .userDomainMask,
				appropriateFor: nil,
				shouldCreate: false
			).appendingPathComponent(name)

			return url
		} catch {
			return nil
		}
	}

	static func migrateLegacyDirectory(from sourceName: String, to destinationName: String) {
		let fileManager = PlayerWorld.fileManagerClient

		if let sourceURL = urlPathForDirectory(name: sourceName),
		   let destURL = urlPathForDirectory(name: destinationName),
		   fileManager.fileExists(atPath: sourceURL.path, isDirectory: nil),
		   !fileManager.fileExists(atPath: destURL.path, isDirectory: nil)
		{
			do {
				try fileManager.copyItem(at: sourceURL, to: destURL)
				try fileManager.removeItem(at: sourceURL)
			} catch {
				// TODO: This error should be centrally logged
				print("Could not migrate legacy events folder. \(String(describing: error))")
			}
		}
	}

	static func initializeDirectory(name: String) -> URL? {
		do {
			let fileManager = PlayerWorld.fileManagerClient
			guard let url = urlPathForDirectory(name: name) else {
				return nil
			}
			if !fileManager.fileExistsAtPath(url.path) {
				try fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
			}
			return url
		} catch {
			return nil
		}
	}

	func initializeTimer() {
		let block: (Timer) -> Void = { [weak self] _ in
			guard let self else {
				return
			}

			batchAndSend(
				contentOf: eventsDirectory,
				to: EVENT_URL,
				seralizeWith: serializeEvents
			)

			batchAndSend(
				contentOf: offlinePlaysDirectory,
				to: OFFLINE_PLAYS_URL,
				seralizeWith: serializeOfflinePlays
			)
		}

		let timer = Timer(timeInterval: SEND_TIME_INTERVAL, repeats: true, block: block)

		timer.tolerance = 10.0
		RunLoop.main.add(timer, forMode: .common)

		self.timer = timer
	}

	func write<T: Codable & Equatable>(group: EventGroup, name: String, payload: T, extras: [String: String?]?) {
		let now = PlayerWorld.timeProvider.timestamp()
		asyncSchedulerFactory.create { [weak self] in
			guard let self else {
				return
			}

			let token: String?
			let userId: String?

			do {
				let authToken = try await credentialsProvider.getCredentials()
				token = authToken.toBearerToken()
				userId = authToken.userId

				guard authToken.isAuthorized else {
					// TODO: Should we log this error?
					print("EventSender succeeded to get credentials but user is not authorized.")
					return
				}
			} catch {
				// TODO: Should we log this error?
				print("StreamingPrivilegesHandler failed to get credentials")
				return
			}
			
			let userClientId: Int? = if let userClientIdSupplier {
				userClientIdSupplier()
			} else {
				nil
			}
		
			let user = User(
				id: Int(userId!) ?? -1,
				accessToken: token ?? "N/A",
				clientId: userClientId
			)

			let clientIdString: String = if let token, let clientId = CredentialsSuccessDataParser().clientIdFromToken(token) {
				"\(clientId)"
			} else {
				""
			}

			let client = Client(
				token: clientIdString,
				version: configuration.clientVersion,
				deviceType: PlayerWorld.deviceInfoProvider.deviceType(PlayerWorld.audioInfoProvider)
			)

			if featureFlagProvider.shouldUseEventProducer() {
				let consentCategory = group.consentCategory
				let event = PlayerEvent(
					group: group.rawValue,
					version: group.version,
					ts: now,
					user: user,
					client: client,
					payload: payload,
					extras: extras
				)
				await sendToEventProducer(name: name, event: event, consentCategory: consentCategory)
			} else {
				let event = LegacyEvent(
					group: group.rawValue,
					name: name,
					version: group.version,
					ts: now,
					user: user,
					client: client,
					payload: payload,
					extras: extras
				)
				writeEvent(event: event)
			}
		}
	}

	func sendToEventProducer<T: Codable & Equatable>(
		name: String,
		event: PlayerEvent<T>,
		consentCategory: ConsentCategory
	) async {
		do {
			let data = try encoder.encode(event)
			guard let serializedString = String(data: data, encoding: .utf8) else {
				// TODO: Should we log this error?
				print("Unable to encode data from encoded event: \(event)")
				return
			}

			try await eventSender.sendEvent(
				name: name,
				consentCategory: consentCategory,
				headers: [:],
				payload: serializedString
			)
		} catch {
			// TODO: Should we log this error?
			print("Error when encoding event: \(event)")
		}
	}

	func batchAndSend(contentOf directory: URL, to url: URL, seralizeWith serializer: @escaping ([URL]) throws -> Data?) {
		let urls = try? fileManager.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)

		var batches = [[URL]]()
		for (i, url) in (urls ?? []).enumerated() {
			if i % MAX_BATCH_SIZE == 0 {
				batches.append([URL]())
			}

			batches[i / MAX_BATCH_SIZE].append(url)
		}

		batches.forEach { urls in self.send(contentOfAll: urls, to: url, serialize: serializer) }
	}

	func send(contentOfAll urls: [URL], to url: URL, serialize: @escaping ([URL]) throws -> Data?) {
		asyncSchedulerFactory.create { [weak self] in
			guard let self else {
				return
			}

			do {
				let token: String?

				let authToken = try await credentialsProvider.getCredentials()
				token = authToken.toBearerToken()

				guard authToken.isAuthorized else {
					// TODO: Should we log this error?
					print("EventSender succeeded to get credentials but user is not authorized.")
					return
				}

				guard let token, let data = try serialize(urls) else {
					return
				}

				_ = try await httpClient.post(
					url: url,
					headers: ["Authorization": token, "Content-Type": "application/json"],
					payload: data
				)

				urls.forEach { try? self.fileManager.removeItem(at: $0) }

			} catch {
				// TODO: This error should be centrally logged
				print("Failed to send data to \(url) [\(String(describing: error))")
			}
		}
	}

	func serializeEvents(contentOfAll urls: [URL]) throws -> Data? {
		let serializedEvents = try urls
			.compactMap { try Data(contentsOf: $0) }
			.compactMap { try JSONSerialization.jsonObject(with: $0) }

		guard !serializedEvents.isEmpty else {
			return nil
		}

		let uuid = PlayerWorld.uuidProvider.uuidString()
		let batch: [String: Any] = [
			"batchId": uuid,
			"events": serializedEvents,
		]

		return try JSONSerialization.data(withJSONObject: batch, options: [])
	}

	func serializeOfflinePlays(contentOfAll urls: [URL]) throws -> Data? {
		let serializedEvents = try urls
			.compactMap { try Data(contentsOf: $0) }
			.compactMap { try JSONSerialization.jsonObject(with: $0) }

		guard !serializedEvents.isEmpty else {
			return nil
		}

		return try JSONSerialization.data(withJSONObject: serializedEvents, options: [])
	}
}

private extension EventGroup {
	var consentCategory: ConsentCategory {
		switch self {
		case .playback, .playlog:
			ConsentCategory.necessary
		case .streamingMetrics:
			ConsentCategory.performance
		}
	}
}
