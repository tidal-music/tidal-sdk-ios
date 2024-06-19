import Combine
import Foundation
import protocol Auth.CredentialsProvider

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
	private var scheduler: EventScheduler
	private let eventSubmitter: EventSubmitter
	private var monitoring: Monitoring
	private var monitoringScheduler: MonitoringScheduler
	private let fileManager: FileManagerHelper
	
	// MARK: - Init
	public init() {
		self.eventSubmitter = EventSubmitter.shared
		self.monitoring = Monitoring.shared
		self.scheduler = EventScheduler(consumerUri: config?.consumerUri)
		self.monitoringScheduler = MonitoringScheduler(consumerUri: config?.consumerUri)
		self.fileManager = FileManagerHelper.shared
	}

	public func config(_ config: EventConfig) {
		self.config = config
		self.scheduler = EventScheduler(consumerUri: config.consumerUri)
		self.monitoringScheduler = MonitoringScheduler(consumerUri: config.consumerUri)
		self.start()
	}
	
	public func updateConfiguration(_ config: EventConfig) {
		self.config = config
		self.scheduler = EventScheduler(consumerUri: config.consumerUri, maxDiskUsageBytes: config.maxDiskUsageBytes)
		self.monitoringScheduler = MonitoringScheduler(consumerUri: config.consumerUri)
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

		guard !fileManager.exceedsMaximumSize(object: eventData,
																					maximumSize: EventConfig.singleEventMaxDiskUsageBytes) else {
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

		try await EventSubmitter.shared.sendEvent(
			name: name,
			consentCategory: consentCategory,
			headers: event.headers,
			payload: payload
		)
		endOutage(eventName: event.name)
	}

	public func start() {
		let headerHelper = HeaderHelper(credentialsProvider: config?.credentialsProvider)
		scheduler.runScheduling(with: headerHelper)
		monitoringScheduler.runScheduling(with: headerHelper)
	}

	private func startOutage(eventName event: String) {
		monitoring.startOutage(eventName: event)
	}

	private func endOutage(eventName event: String) {
		monitoring.endOutage(eventName: event)
	}
}
