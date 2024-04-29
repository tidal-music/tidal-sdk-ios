import Combine
import Foundation

/// The EventSenderClient role exposes functionality for sending events and monitoring the status of the transportation layer.
public final class EventSenderClient: EventSender {
	// MARK: - Public properties

	public static let shared = EventSenderClient()
	public var config: EventSenderConfig?

	// MARK: - Private properties

	private let outageSubject = PassthroughSubject<OutageState, Never>()
	private let scheduler: EventScheduler
	private let eventSubmitter: EventSubmitter
	private let monitoring: Monitoring
	private let fileManager: FileManagerHelper

	private init(
		scheduler: EventScheduler = .shared,
		eventSubmitter: EventSubmitter = .shared,
		monitoring: Monitoring = .shared,
		fileManager: FileManagerHelper = .shared
	) {
		self.scheduler = scheduler
		self.eventSubmitter = eventSubmitter
		self.monitoring = monitoring
		self.fileManager = fileManager
	}

	/// Used to configure settings for sending events, must be called before sending events
	/// - Parameter config: required properties needed to tune even sending, sucn as maxDiskUsageBytes,  maxDiskUsageBytes etc
	public func setupConfiguration(config: EventSenderConfig) {
		self.config = config
	}

	/// Used to set blockedConsentCategories. Any new entry would clear previous entry, ie overwrite it.
	/// - Parameters:
	/// - categories: variable number of category entries
	public func setBlockedConsentCategories(_ categories: Set<ConsentCategory>?) {
		config?.blockedConsentCategories = categories
	}

	/// Used to send an event to the consumer.
	/// - Parameters:
	///   - name: Defines a certain type of event. E.g. "play-log".
	///   - consentCategory: The consent category the event belongs to
	///   - headers: Headers containing metadata attached to the payload.
	///   - payload: Contains business information the app wants to send.
	public func sendEvent(
		name: String,
		consentCategory: ConsentCategory,
		headers: [String: String] = [:],
		payload: String
	) async throws {
		var event = Event(name: name, headers: headers, payload: payload)

		guard let eventData = try? JSONEncoder().encode(event) else {
			throw EventProducerError.eventSendDataEncodingFailure
		}

		guard let config else {
			throw EventProducerError
				.genericError("EventSenderConfig not setup, you must call setupConfiguration() before calling sendEvent")
		}

		guard !fileManager.exceedsMaximumSize(object: eventData, maximumSize: config.maxDiskUsageBytes) else {
			try await monitoring.updateMonitoringEvent(monitoringEventType: .failedStorage, eventName: event.name)
			startOutage(eventName: event.name)
			return
		}

		if let blockedConsentCategories = config.blockedConsentCategories,
		   blockedConsentCategories.contains(where: { $0 == consentCategory })
		{
			try await monitoring.updateMonitoringEvent(monitoringEventType: .filteredConsent, eventName: name)
			startOutage(eventName: event.name)
			return
		}

		let headerHelper = HeaderHelper(auth: config.authProvider)
		let defaultHeaders = await headerHelper.getDefaultHeaders(with: consentCategory)
		let enrichedHeaders = defaultHeaders.merging(event.headers) { _, suppliedEntry in suppliedEntry }

		event.headers = enrichedHeaders

		try await EventSubmitter.shared.sendEvent(
			name: name,
			consentCategory: consentCategory,
			headers: event.headers,
			payload: payload
		)
		endOutage(eventName: event.name)
	}

	public func start() {
		EventScheduler.shared.runScheduling(headerHelper: .init(auth: config?.authProvider))
		MonitoringScheduler.shared.runScheduling(headerHelper: .init(auth: config?.authProvider))
	}

	private func startOutage(eventName: String) {
		outageSubject.send(.outage(error: .init(code: "100", message: "Start outage error for \(eventName)")))
	}

	private func endOutage(eventName: String) {
		outageSubject.send(.noOutage(message: .init(message: "No outage for \(eventName)")))
	}
}
