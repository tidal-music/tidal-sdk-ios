import Foundation
import GRDB

public final class MonitoringQueue {
	static let databaseName = "MonitoringDatabase.sqlite"
	private var _databaseQueue: DatabaseQueue?
	
	private var databaseQueue: DatabaseQueue {
		get throws {
			if let _databaseQueue {
				return _databaseQueue
			}
			
			guard let databaseURL = FileManagerHelper.shared.monitoringQueueDatabaseURL else {
				throw EventProducerError.monitoringQueueDatabaseURLFailure
			}

			do {
				let databaseQueue = try DatabaseQueue(path: databaseURL.path)
				try databaseQueue.write { database in
					try database.create(table: MonitoringInfoPersistentObject.databaseTableName, ifNotExists: true) { table in
						table.column(MonitoringInfoPersistentObject.columnId, .text).notNull()
						table.column(MonitoringInfoPersistentObject.columnStoringFailedEvents, .any).notNull()
						table.column(MonitoringInfoPersistentObject.columnConsentFilteredEvents, .any).notNull()
						table.column(MonitoringInfoPersistentObject.columnValidationFailedEvents, .any).notNull()
					}
				}
				self._databaseQueue = databaseQueue
				return databaseQueue
			} catch {
				throw EventProducerError.monitoringDatabaseCreateFailure(error.localizedDescription)
			}
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
