import Foundation
import GRDB
import SWXMLHash

final class EventQueue {
	static let databaseName = "EventQueueDatabase.sqlite"
	
	private var dbQueue: DatabaseQueue?

	private func getDatabaseQueue() throws -> DatabaseQueue {
		// if dbQueue is not nil, we have already set up the database
		if let dbQueue {
			return dbQueue
		}

		guard let databaseURL = FileManagerHelper.shared.eventQueueDatabaseURL else {
			throw EventProducerError.eventQueueDatabaseURLFailure
		}

		do {
			let databaseQueue = try DatabaseQueue(path: databaseURL.path)
			try databaseQueue.write { db in
				try db.create(table: EventPersistentObject.databaseTableName, ifNotExists: true) { table in
					table.column(EventPersistentObject.columnID, .text).notNull()
					table.column(EventPersistentObject.columnName, .text).notNull()
					table.column(EventPersistentObject.columnConsentCategory, .text)
					table.column(EventPersistentObject.columnHeaders, .text)
					table.column(EventPersistentObject.columnPayload, .text)
				}
			}
			self.dbQueue = databaseQueue
			return databaseQueue
		} catch {
			throw EventProducerError.eventDatabaseCreateFailure(error.localizedDescription)
		}
	}

	/// Adds an event to the event queue.
	/// If this operation returns successfully, the event shall be stored in persistent storage.
	/// - Parameters:
	///   - event: The event to add to the queue
	///   - throws: Any error that can occur that causes the event not to be added to the queue, e.g. configured max disk size is
	/// exceeded, disk is full or similar.
	func addEvent(event: Event, consentCategory: ConsentCategory) async throws {
		let dbQueue = try getDatabaseQueue()
		do {
			try await dbQueue.write { db in
				let persistentObject = event.toEventPersistentObject(consentCategory: consentCategory)
				try persistentObject.insert(db)
			}
		} catch {
			throw EventProducerError.eventAddFailure(error.localizedDescription)
		}
	}

	/// Fetch events from local storage, usually just before being sent to the backend
	/// - Returns: Array of events
	func getAllEvents() async throws -> [Event] {
		let dbQueue = try getDatabaseQueue()
		return try await dbQueue.read { db in
			try EventPersistentObject.fetchAll(db).map { $0.toEvent() }
		}
	}

	/// Removes events from local database
	/// - Parameters:
	///   - sent: Batch that was sent to the backend
	///   - delivered: Batch that was received from the backend after successful delivery
	func handleCleanup(sent: [Event], delivered: [XMLIndexer]) async throws {
		let dbQueue = try getDatabaseQueue()

		var deliveredIDs: Set<String> = Set()
		// Extract all the IDs from the delivered array
		for item in delivered {
			deliveredIDs.insert(item["Id"].element?.text ?? "")
		}

		let filteredSent = sent.filter { deliveredIDs.contains($0.id) }

		for event in filteredSent {
			do {
				_ = try await dbQueue.write { db in
					try EventPersistentObject.deleteOne(db, key: event.id)
				}
			} catch {
				throw EventProducerError.eventDeletionFailure(error.localizedDescription)
			}
		}
	}

	func deleteAllEvents() async throws {
		let dbQueue = try getDatabaseQueue()
		_ = try await dbQueue.write { db in
			try EventPersistentObject.deleteAll(db)
		}
	}

	func deleteDB() async throws {
		let dbQueue = try getDatabaseQueue()
		try await dbQueue.erase()
	}
}
