import Foundation

struct Monitoring {
	static let eventName = "tep-tl-monitoring"
	static let shared = Monitoring()

	private let monitoringQueue: MonitoringQueue

	private init(monitoringQueue: MonitoringQueue = .shared) {
		self.monitoringQueue = monitoringQueue
	}

	func getMonitoringInfo() async -> MonitoringInfo? {
		try? await monitoringQueue.getMonitoringInfo()
	}

	func deleteAllMonitoringInfo() async {
		try? await monitoringQueue.deleteAllMonitoringInfo()
	}

	func clearMonitoringInfo() async {
		try? await addNewMonitoringInfo(emptyMonitoringInfo)
	}

	func getMonitoringEvent(from monitoringInfo: MonitoringInfo, headerHelper: HeaderHelper) async -> Event? {
		guard let monitoringInfoData = try? JSONEncoder().encode(monitoringInfo),
		      let monitoringPayload = String(data: monitoringInfoData, encoding: .utf8)
		else {
			return nil
		}
		let headers = await headerHelper.getDefaultHeaders(with: .necessary, isMonitoringEvent: true)
		return Event(name: Self.eventName, headers: headers, payload: monitoringPayload)
	}

	func updateMonitoringEvent(monitoringEventType: MonitoringEventType, eventName: String) async throws {
		var monitoringInfo = try? await monitoringQueue.getMonitoringInfo()
		if monitoringInfo == nil {
			try await addNewMonitoringInfo(emptyMonitoringInfo)
			monitoringInfo = try? await monitoringQueue.getMonitoringInfo()
		}

		guard var monitoringInfo else {
			return
		}

		switch monitoringEventType {
		case .filteredConsent:
			if let filteredConsentCount = monitoringInfo.consentFilteredEvents[eventName] {
				monitoringInfo.consentFilteredEvents[eventName] = filteredConsentCount + 1
			} else {
				monitoringInfo.consentFilteredEvents = [eventName: 1]
			}
		case .failedValidation:
			if let failedValidationCount = monitoringInfo.validationFailedEvents[eventName] {
				monitoringInfo.validationFailedEvents[eventName] = failedValidationCount + 1
			} else {
				monitoringInfo.validationFailedEvents = [eventName: 1]
			}
		case .failedStorage:
			if let failedStorageCount = monitoringInfo.storingFailedEvents[eventName] {
				monitoringInfo.storingFailedEvents[eventName] = failedStorageCount + 1
			} else {
				monitoringInfo.storingFailedEvents = [eventName: 1]
			}
		}

		try await updateMonitoringInfo(monitoringInfo)
	}

	private func addNewMonitoringInfo(_ monitoringInfo: MonitoringInfo) async throws {
		do {
			try await monitoringQueue.addNewMonitoringInfo(monitoringInfo)
		} catch {
			throw EventProducerError.monitoringAddInfoFailure(error.localizedDescription)
		}
	}

	private func updateMonitoringInfo(_ monitoringInfo: MonitoringInfo) async throws {
		do {
			try await monitoringQueue.updateMonitoringInfo(monitoringInfo)
		} catch {
			throw EventProducerError.monitoringUdpateInfoFailure(error.localizedDescription)
		}
	}

	var emptyMonitoringInfo: MonitoringInfo {
		MonitoringInfo(
			consentFilteredEvents: [:],
			validationFailedEvents: [:],
			storingFailedEvents: [:]
		)
	}
}
