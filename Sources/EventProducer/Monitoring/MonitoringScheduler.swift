import Common
import Foundation

final class MonitoringScheduler: Scheduler {
	private let monitoringSchedulerTime: TimeInterval = 60
	var schedulerTask: Task<Void, any Error>?

	private let consumerUri: String?
	private let monitoring: Monitoring
	private let eventScheduler: EventScheduler
	private let networkService: NetworkingService

	var schedulingTime: TimeInterval {
		switch BuildEnvironment.system {
		case .development: 5
		case .production: monitoringSchedulerTime
		}
	}

	init(
		consumerUri: String?,
		monitoring: Monitoring,
		eventQueue: EventQueue
	) {
		self.consumerUri = consumerUri
		self.monitoring = monitoring
		eventScheduler = EventScheduler(
			consumerUri: consumerUri,
			eventQueue: eventQueue,
			monitoring: monitoring
		)
		networkService = NetworkingService(consumerUri: consumerUri)
	}

	convenience init(config: EventConfig?, eventQueue: EventQueue, monitoring: Monitoring) {
		self.init(
			consumerUri: config?.consumerUri,
			monitoring: monitoring,
			eventQueue: eventQueue
		)
	}

	func timerTriggered(headerHelper: HeaderHelper) async throws {
		await sendMonitoringEvent(headerHelper: headerHelper)
	}

	func sendMonitoringEvent(headerHelper: HeaderHelper) async {
		let monitoringInfo = await monitoring.getMonitoringInfo()
		guard let monitoringInfo, monitoringInfo != monitoring.emptyMonitoringInfo else {
			return
		}

		guard let monitoringEvent = await monitoring.getMonitoringEvent(from: monitoringInfo, headerHelper: headerHelper) else {
			return
		}

		await monitoring.clearMonitoringInfo()
		Task {
			do {
				try await eventScheduler.sendMonitoringEvent(monitoringEvent, headerHelper: headerHelper)
			} catch {
				throw EventProducerError.monitoringSendEventFailure(error.localizedDescription)
			}
		}
	}
}
