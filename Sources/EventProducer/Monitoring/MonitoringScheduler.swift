import Common
import Foundation

final class MonitoringScheduler {
	private let monitoringSchedulerTime: TimeInterval = 60
	private var timer: Timer?
	
	private let consumerUri: String?
	private let monitoring: Monitoring
	private let eventScheduler: EventScheduler
	private let networkService: NetworkingService

	private var schedulingTime: TimeInterval {
		switch BuildEnvironment.system {
		case .development: 5
		case .production: monitoringSchedulerTime
		}
	}

	init(
		consumerUri: String?,
		monitoringQueue: Monitoring = .shared
	) {
		self.consumerUri = consumerUri
		self.monitoring = monitoringQueue
		self.eventScheduler = EventScheduler(consumerUri: consumerUri)
		self.networkService = NetworkingService(consumerUri: consumerUri)
	}

	func runScheduling(with headerHelper: HeaderHelper) {
		guard timer == nil else {
			return
		}

		timer = Timer.scheduledTimer(withTimeInterval: schedulingTime, repeats: true) { [weak self] _ in
			guard let self else {
				return
			}

			Task {
				await self.sendMonitoringEvent(headerHelper: headerHelper)
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
