import Foundation
import GRDB

// MARK: - GRDBOfflineStorage

class GRDBOfflineStorage {
	private let dbQueue: DatabaseQueue

	init(dbQueue: DatabaseQueue) {
		self.dbQueue = dbQueue
		try? initializeDatabase()
	}
}

// MARK: OfflineStorage

extension GRDBOfflineStorage: OfflineStorage {
	// MARK: - Save OfflineEntry

	func save(_ entry: OfflineEntry) throws {
		let entity = GRDBOfflineEntryEntity(from: entry)
		try dbQueue.write { db in
			try entity.insert(db)
		}
	}

	// MARK: - Get OfflineEntry by MediaProduct

	func get(mediaProduct: MediaProduct) throws -> OfflineEntry? {
		let entity = try dbQueue.read { db in
			try GRDBOfflineEntryEntity.filter(GRDBOfflineEntryEntity.Columns.productId == mediaProduct.productId).fetchOne(db)
		}
		return entity?.offlineEntry
	}

	// MARK: - Delete OfflineEntry by MediaProduct

	func delete(mediaProduct: MediaProduct) throws {
		_ = try dbQueue.write { db in
			try GRDBOfflineEntryEntity.filter(GRDBOfflineEntryEntity.Columns.productId == mediaProduct.productId).deleteAll(db)
		}
	}

	// MARK: - Update OfflineEntry

	func update(_ entry: OfflineEntry) throws {
		let entity = GRDBOfflineEntryEntity(from: entry)
		try dbQueue.write { db in
			try entity.update(db)
		}
	}

	// MARK: - Get All CacheEntries

	func getAll() throws -> [OfflineEntry] {
		let entities = try dbQueue.read { db in
			try GRDBOfflineEntryEntity.fetchAll(db)
		}
		return entities.map { $0.offlineEntry }
	}

	// MARK: - clear All OfflineEntries

	func clear() throws {
		_ = try dbQueue.write { db in
			try GRDBOfflineEntryEntity.deleteAll(db)
		}
	}
}

private extension GRDBOfflineStorage {
	func initializeDatabase() throws {
		do {
			try dbQueue.write { db in
				if try !db.tableExists(GRDBOfflineEntryEntity.databaseTableName) {
					try db.create(table: GRDBOfflineEntryEntity.databaseTableName) { t in
						t.column("productId", .text).primaryKey()
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
						t.column("mediaBookmark", .blob)
						t.column("licenseBookmark", .blob)
					}
				}
			}
		} catch {
			// TODO: Log error
			print("Failed to initialize table \(GRDBOfflineEntryEntity.databaseTableName): \(error)")
			throw error
		}
	}
}
