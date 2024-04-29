import Common
import Foundation
import SWXMLHash

// MARK: - EventScheduler

/// The Scheduler periodically gets events from the Queue, batches them according to the TL Consumer API,
/// sends them to the TL Consumer, and removes events confirmed received by the TL Consumer from the Queue.
final class EventScheduler {
	static let shared = EventScheduler()
	private let batchSize: Int = 10
	private let eventSchedulerTime: TimeInterval = 30
	private var timer: Timer?

	private let eventQueue: EventQueue
	private let networkService: NetworkingService

	private var schedulingTime: TimeInterval {
		switch Environment.system {
		case .development: 5
		case .production: Constants.eventSchedulerTime
		}
	}

	private init(
		eventQueue: EventQueue = .shared,
		networkService: NetworkingService = .init()
	) {
		self.eventQueue = eventQueue
		self.networkService = networkService
	}

	/// The Scheduler applies a best-effort approach to sending events to the TL Consumer, meaning that it continuously tries to send
	/// events while the app is executing,
	/// regardless of current internet conditions or if the app considers itself to be online or not. As long as the app is
	/// executing, the Scheduler shall be running
	func runScheduling(headerHelper: HeaderHelper) {
		guard timer == nil else {
			return
		}

		timer = Timer.scheduledTimer(withTimeInterval: schedulingTime, repeats: true) { [weak self] _ in
			guard let self else {
				return
			}

			Task {
				do {
					try await self.sendAllEvents(headerHelper: headerHelper)
				} catch let EventProducerError.unauthorized(code) {
					try? headerHelper.auth?.refreshAccessToken(status: code)
				} catch {
					throw error
				}
			}
		}
		guard let timer else {
			return
		}
		RunLoop.current.add(timer, forMode: .common)
	}

	func invalidateTimer() {
		timer?.invalidate()
		timer = nil
	}

	/// Fetches all events from the local storage, and sends them to the backend in batches.
	func sendAllEvents(headerHelper: HeaderHelper) async throws {
		let allEvents = try await eventQueue.getAllEvents()
		let batches = allEvents.chunkedBy(Constants.batchSize)

		for batch in batches {
			try await batchAndSend(batch, headerHelper: headerHelper)
		}
	}

	/// Sends the provided batch to the backend
	/// - Parameters:
	///   - batch: Batch that will be sent
	func batchAndSend(_ batch: [Event], headerHelper: HeaderHelper) async throws {
		let formattedEvents = formatEvents(batch)

		guard !formattedEvents.isEmpty else {
			return
		}

		guard let requestData = try networkService.getRequestBodyData(parameters: formattedEvents) else {
			throw NSError(domain: "Invalid requestData", code: 0, userInfo: nil)
		}

		do {
			let endpoint: Endpoint
			if let authTokenHeader = await headerHelper.getAuthTokenHeader() {
				endpoint = .events(requestData, authHeader: authTokenHeader)
			} else if let clientAuth = headerHelper.clientAuthHeader {
				endpoint = .publicEvents(requestData, clientAuth: clientAuth)
			} else {
				throw EventProducerError.clientIdMissingFailure
			}

			let data = try await networkService.sendEventBatch(endpoint: endpoint)

			let xml = XMLHash.parse(data)
			let results = xml["SendMessageBatchResponse"]["SendMessageBatchResult"]["SendMessageBatchResultEntry"]
			try await clearStoredEvents(from: batch, with: results.all)
		} catch {
			throw EventProducerError.eventSendBatchRequestFailure(error.localizedDescription)
		}
	}

	@discardableResult
	func sendMonitoringEvent(_ event: Event, headerHelper: HeaderHelper) async throws -> [XMLIndexer] {
		let formattedEvents = formatEvents([event])

		guard let requestData = try networkService.getRequestBodyData(parameters: formattedEvents) else {
			throw NSError(domain: "Invalid requestData", code: 0, userInfo: nil)
		}

		let endpoint: Endpoint
		if let authTokenHeader = await headerHelper.getAuthTokenHeader() {
			endpoint = .events(requestData, authHeader: authTokenHeader)
		} else if let clientAuth = headerHelper.clientAuthHeader {
			endpoint = .publicEvents(requestData, clientAuth: clientAuth)
		} else {
			throw EventProducerError.clientIdMissingFailure
		}

		let data = try await networkService.sendEventBatch(endpoint: endpoint)

		let xml = XMLHash.parse(data)
		let results = xml["SendMessageBatchResponse"]["SendMessageBatchResult"]["SendMessageBatchResultEntry"]

		return results.all
	}

	/// Removes events from local database
	/// - Parameters:
	///   - sentBatch: Batch that was sent to the backend
	///   - delivered: Batch that was received from the backend after successful delivery
	func clearStoredEvents(from sentBatch: [Event], with delivered: [XMLIndexer]) async throws {
		try await eventQueue.handleCleanup(sent: sentBatch, delivered: delivered)
	}

	/// Formats to the event dictionary needed for AWS SQS. It utilises the `Parameters` enum to safeguard against future parameter
	/// name changes.
	/// - Parameter events: Array of events to be re-formatted to the expected dictionary
	/// - Returns: A dictionary of parameter values
	func formatEvents(_ events: [Event]) -> [String: String] {
		var parameters: [String: String] = [:]
		for (index, event) in events.enumerated() {
			let attributeIndex = 1
			let index = index + 1
			let baseAttributePrefix =
				"\(Parameters.sendBatch.rawValue).\(index).\(Parameters.attribute.rawValue).\(attributeIndex)"

			// Format base attributes
			parameters["\(Parameters.sendBatch.rawValue).\(index).\(Parameters.id.rawValue)"] = event.id
			parameters["\(Parameters.sendBatch.rawValue).\(index).\(Parameters.body.rawValue)"] = event.payload

			parameters["\(baseAttributePrefix).\(Parameters.nameKey.rawValue)"] = Parameters.nameKey.rawValue
			parameters["\(baseAttributePrefix).\(Parameters.value.rawValue)"] = event.name
			parameters["\(baseAttributePrefix).\(Parameters.valueDatatype.rawValue)"] = Parameters.string.rawValue

			// Format headers
			guard let eventHeadersString = event.headers.jsonEncoded else {
				continue
			}

			let headerAttributeIndex = 2
			let baseHeaderPrefix =
				"\(Parameters.sendBatch.rawValue).\(index).\(Parameters.attribute.rawValue).\(headerAttributeIndex)"

			parameters["\(baseHeaderPrefix).\(Parameters.nameKey.rawValue)"] = Parameters.headers.rawValue
			parameters["\(baseHeaderPrefix).\(Parameters.value.rawValue)"] = eventHeadersString
			parameters["\(baseHeaderPrefix).\(Parameters.valueDatatype.rawValue)"] = Parameters.string.rawValue
		}
		return parameters
	}
}

// MARK: EventScheduler.Parameters

private extension EventScheduler {
	/// Used in `formatEvents` method to increase readability and safeguard against future modifications.
	enum Parameters: String {
		case sendBatch = "SendMessageBatchRequestEntry"
		case string = "String"
		case attribute = "MessageAttribute"
		case body = "MessageBody"
		case id = "Id"
		case nameKey = "Name"
		case headers = "Headers"
		case value = "Value.StringValue"
		case valueDatatype = "Value.DataType"
	}
}
