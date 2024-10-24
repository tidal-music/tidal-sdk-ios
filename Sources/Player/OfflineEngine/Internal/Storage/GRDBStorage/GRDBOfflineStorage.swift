import Foundation
import GRDB

// MARK: - GRDBOfflineStorage

class GRDBOfflineStorage {
	private let dbQueue: DatabaseQueue

	init(dbQueue: DatabaseQueue) {
		self.dbQueue = dbQueue
	}

	static func initializeDatabase(dbQueue: DatabaseQueue) throws {
		try dbQueue.write { db in
			if try !db.tableExists(OfflineEntryGRDBEntity.databaseTableName) {
				try db.create(table: OfflineEntryGRDBEntity.databaseTableName) { t in
					t.column("productId", .text).primaryKey()
					t.column("actualProductId", .text).notNull()
					t.column("productType", .text).notNull()
					t.column("assetPresentation", .text).notNull()
					t.column("audioMode", .text)
					t.column("audioQuality", .text)
					t.column("audioCodec", .text)
					t.column("audioSampleRate", .integer)
					t.column("audioBitDepth", .integer)
					t.column("videoQuality", .text)
					t.column("revalidateAt", .integer)
					t.column("expiry", .integer)
					t.column("mediaType", .text)
					t.column("albumReplayGain", .double)
					t.column("albumPeakAmplitude", .double)
					t.column("trackReplayGain", .double)
					t.column("trackPeakAmplitude", .double)
					t.column("licenseSecurityToken", .text)
					t.column("size", .integer)
					t.column("mediaBookmark", .blob)
					t.column("licenseBookmark", .blob)
				}
			}
		}
	}

	static func withDefaultDatabase() -> GRDBOfflineStorage? {
		do {
			let databaseURL = try GRDBOfflineStorage.databaseURL()
			let dbQueue = try DatabaseQueue(path: databaseURL.path)
			try GRDBOfflineStorage.initializeDatabase(dbQueue: dbQueue)

			return GRDBOfflineStorage(dbQueue: dbQueue)
		} catch {
			PlayerWorld.logger?.log(loggable: PlayerLoggable.withDefaultDatabase(error: error))
			return nil
		}
	}
}

// MARK: OfflineStorage

extension GRDBOfflineStorage: OfflineStorage {
	// MARK: - Save OfflineEntry

	func save(_ entry: OfflineEntry) throws {
		let entity = OfflineEntryGRDBEntity(from: entry)
		try dbQueue.write { db in
			try entity.insert(db)
		}
	}

	// MARK: - Get OfflineEntry by MediaProduct

	func get(key: String) throws -> OfflineEntry? {
		let entity = try dbQueue.read { db in
			try OfflineEntryGRDBEntity.filter(OfflineEntryGRDBEntity.Columns.productId == key).fetchOne(db)
		}
		return entity?.offlineEntry
	}

	// MARK: - Delete OfflineEntry by MediaProduct

	func delete(key: String) throws {
		_ = try dbQueue.write { db in
			try OfflineEntryGRDBEntity.filter(OfflineEntryGRDBEntity.Columns.productId == key).deleteAll(db)
		}
	}

	// MARK: - Update OfflineEntry

	func update(_ entry: OfflineEntry) throws {
		let entity = OfflineEntryGRDBEntity(from: entry)
		try dbQueue.write { db in
			try entity.update(db)
		}
	}

	// MARK: - Get All Offline Entries

	func getAll() throws -> [OfflineEntry] {
		let entities = try dbQueue.read { db in
			try OfflineEntryGRDBEntity.fetchAll(db)
		}
		return entities.map { $0.offlineEntry }
	}

	// MARK: - Clear OfflineEntries

	func clear() throws {
		_ = try dbQueue.write { db in
			try OfflineEntryGRDBEntity.deleteAll(db)
		}
	}

	// MARK: - Total size of all entries

	func totalSize() throws -> Int {
		try dbQueue.read { db in
			try calculateTotalSize(db)
		}
	}
}

private extension GRDBOfflineStorage {
	static func databaseURL() throws -> URL {
		let appSupportURL = PlayerWorld.fileManagerClient.applicationSupportDirectory()
		let directoryURL = appSupportURL.appendingPathComponent("PlayerOfflineDatabase", isDirectory: true)
		try PlayerWorld.fileManagerClient.createDirectory(at: directoryURL, withIntermediateDirectories: true)
		return directoryURL.appendingPathComponent("db.sqlite")
	}

	func calculateTotalSize(_ db: Database) throws -> Int {
		let totalSize = try OfflineEntryGRDBEntity.select(sum(OfflineEntryGRDBEntity.Columns.size)).fetchOne(db) ?? 0
		return totalSize
	}
}
