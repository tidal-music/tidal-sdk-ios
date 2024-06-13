import Foundation
import GRDB

public final class MonitoringQueue {
	static let databaseName = "MonitoringDatabase.sqlite"
	public static let shared = MonitoringQueue()
	private var databaseQueue: DatabaseQueue!

	private init() {
		try? setup()
	}

	private func setup() throws {
		guard let databaseURL = FileManagerHelper.shared.eventQueueDatabaseURL else {
			throw EventProducerError.monitoringQueueDatabaseURLFailure
		}
		
		var configuration = Configuration()
		configuration.qos = .background

		do {
			databaseQueue = try DatabaseQueue(path: databaseURL.path, configuration: configuration)
			try databaseQueue.write { database in
				try database.create(table: MonitoringInfoPersistentObject.databaseTableName, ifNotExists: true) { table in
					table.column(MonitoringInfoPersistentObject.columnId, .text).notNull()
					table.column(MonitoringInfoPersistentObject.columnStoringFailedEvents, .any).notNull()
					table.column(MonitoringInfoPersistentObject.columnConsentFilteredEvents, .any).notNull()
					table.column(MonitoringInfoPersistentObject.columnValidationFailedEvents, .any).notNull()
				}
			}
		} catch {
			throw EventProducerError.monitoringDatabaseCreateFailure(error.localizedDescription)
		}
	}

	func addNewMonitoringInfo(_ monitoringInfo: MonitoringInfo) async throws {
		try await databaseQueue.write { database in
			let persistentObject = monitoringInfo.toMonitoringInfoPersistentObject()
			try persistentObject.insert(database)
		}
	}

	public func updateMonitoringInfo(_ monitoringInfo: MonitoringInfo) async throws {
		try await databaseQueue.write { database in
			let persistentObject = monitoringInfo.toMonitoringInfoPersistentObject()
			try persistentObject.update(database)
		}
	}

	public func getMonitoringInfo() async throws -> MonitoringInfo? {
		try await databaseQueue.read { database in
			try MonitoringInfoPersistentObject.fetchAll(database).last?.toMonitoringInfo()
		}
	}

	public func getAllMonitoringInfo() async throws -> [MonitoringInfo] {
		try await databaseQueue.read { database in
			try MonitoringInfoPersistentObject.fetchAll(database).map { $0.toMonitoringInfo() }
		}
	}

	public func deleteAllMonitoringInfo() async throws {
		_ = try await databaseQueue.write { database in
			try MonitoringInfoPersistentObject.deleteAll(database)
		}
	}
}
