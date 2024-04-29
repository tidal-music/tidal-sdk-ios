import Common
import Foundation

final class MonitoringScheduler {
	static let shared = MonitoringScheduler()

	private let monitoringSchedulerTime: TimeInterval = 60
	private var timer: Timer?
	private let monitoring: Monitoring
	private let eventScheduler: EventScheduler
	private let networkService: NetworkingService

	private var schedulingTime: TimeInterval {
		switch Environment.system {
		case .development: 5
		case .production: monitoringSchedulerTime
		}
	}

	private init(
		monitoringQueue: Monitoring = .shared,
		networkService: NetworkingService = .init(),
		eventScheduler: EventScheduler = .shared
	) {
		monitoring = monitoringQueue
		self.networkService = networkService
		self.eventScheduler = eventScheduler
	}

	func runScheduling(headerHelper: HeaderHelper) {
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
