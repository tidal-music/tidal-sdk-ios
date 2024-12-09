import protocol Auth.CredentialsProvider
import Combine
import Foundation

/// The TidalEventProducer role exposes functionality for sending events and monitoring the status of the transportation layer.
public final class TidalEventSender: EventSender {
	// MARK: - Singleton properties

	public static let shared = TidalEventSender()

	// MARK: - Public properties

	public var config: EventConfig?

	// MARK: - Private properties

	var isOutage: Bool {
		guard let outageState = monitoring.outageSubject?.value else {
			return false
		}
		switch outageState {
		case .outageStart:
			return true
		case .outageEnd:
			return false
		}
	}

	private var scheduler: EventScheduler?
	private var monitoringScheduler: MonitoringScheduler?

	private let eventSubmitter: EventSubmitter
	private var monitoring: Monitoring
	private let eventQueue: EventQueue
	private let monitoringQueue: MonitoringQueue
	private let fileManager: FileManagerHelper

	// MARK: - Init

	public init() {
		self.eventQueue = EventQueue()
		self.monitoringQueue = MonitoringQueue()
		self.monitoring = Monitoring(monitoringQueue: monitoringQueue)
		self.eventSubmitter = EventSubmitter(eventsQueue: eventQueue, monitoring: monitoring)

		self.fileManager = FileManagerHelper.shared
	}

	public func config(_ config: EventConfig) {
		self.config = config

		// In case of reentrancy we invalidate schedulers before creating new ones
		self.scheduler?.invalidateTimer()
		self.monitoringScheduler?.invalidateTimer()

		self.scheduler = .init(config: config, eventQueue: eventQueue, monitoring: monitoring)
		self.monitoringScheduler = .init(config: config, eventQueue: eventQueue, monitoring: monitoring)

		self.start()
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
		guard scheduler != nil, monitoringScheduler != nil else {
			throw EventProducerError.notConfigured
		}

		var event = Event(name: name, headers: headers, payload: payload)

		guard let eventData = try? JSONEncoder().encode(event) else {
			throw EventProducerError.eventSendDataEncodingFailure
		}

		guard !fileManager.exceedsMaximumSize(
			object: eventData,
			maximumSize: EventConfig.singleEventMaxDiskUsageBytes
		) else {
			try await monitoring.updateMonitoringEvent(monitoringEventType: .failedStorage, eventName: event.name)
			startOutage(eventName: event.name)
			return
		}
		if let blockedConsentCategories = config?.blockedConsentCategories,
		   blockedConsentCategories.contains(where: { $0 == consentCategory })
		{
			try await monitoring.updateMonitoringEvent(monitoringEventType: .filteredConsent, eventName: name)
			startOutage(eventName: event.name)
			return
		}

		let headerHelper = HeaderHelper(credentialsProvider: config?.credentialsProvider)
		let defaultHeaders = await headerHelper.getDefaultHeaders(with: consentCategory)
		let enrichedHeaders = defaultHeaders.merging(event.headers) { _, suppliedEntry in suppliedEntry }

		event.headers = enrichedHeaders

		try await eventSubmitter.sendEvent(
			name: name,
			consentCategory: consentCategory,
			headers: event.headers,
			payload: payload
		)
		endOutage(eventName: event.name)
	}

	/// Used to explicitly send all events directly from the scheduler. Usage would depend on the client (ex. when app moves to the
	/// background)
	public func sendAllEvents() async throws {
		let headerHelper = HeaderHelper(credentialsProvider: config?.credentialsProvider)
		do {
			try await scheduler?.sendAllEvents(headerHelper: headerHelper)
		} catch let EventProducerError.unauthorized(code) where code <= Constants.httpUnauthorized {
			print("⛔️\(#function): EventProducer is unauthorized with code: \(code)")
			_ = try await headerHelper.credentialsProvider?.getCredentials(apiErrorSubStatus: code.description)
			try await scheduler?.sendAllEvents(headerHelper: headerHelper)
		} catch {
			throw error
		}
	}

	private func start() {
		let headerHelper = HeaderHelper(credentialsProvider: config?.credentialsProvider)
		scheduler?.runScheduling(with: headerHelper)
		monitoringScheduler?.runScheduling(with: headerHelper)
	}

	private func startOutage(eventName event: String) {
		monitoring.startOutage(eventName: event)
	}

	private func endOutage(eventName event: String) {
		monitoring.endOutage(eventName: event)
	}
}
