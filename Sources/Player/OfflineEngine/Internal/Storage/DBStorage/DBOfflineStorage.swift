import Foundation
import GRDB

// MARK: - DBOfflineStorage

class DBOfflineStorage {
	private let dbQueue: DatabaseQueue

	init(dbQueue: DatabaseQueue) {
		self.dbQueue = dbQueue
		try? initializeDatabase()
	}
}

// MARK: OfflineStorage

extension DBOfflineStorage: OfflineStorage {
	// MARK: - Save OfflineEntry

	func save(_ entry: OfflineEntry) throws {
		let entryDTO = DBOfflineEntryDTO(from: entry)
		try dbQueue.write { db in
			try entryDTO.insert(db)
		}
	}

	// MARK: - Get OfflineEntry by MediaProduct

	func get(mediaProduct: MediaProduct) throws -> OfflineEntry? {
		let entryDTO = try dbQueue.read { db in
			try DBOfflineEntryDTO.filter(DBOfflineEntryDTO.Columns.productId == mediaProduct.productId).fetchOne(db)
		}
		return entryDTO?.toOfflineEntry()
	}

	// MARK: - Delete OfflineEntry by MediaProduct

	func delete(mediaProduct: MediaProduct) throws {
		_ = try dbQueue.write { db in
			try DBOfflineEntryDTO.filter(DBOfflineEntryDTO.Columns.productId == mediaProduct.productId).deleteAll(db)
		}
	}

	// MARK: - Update OfflineEntry

	func update(_ entry: OfflineEntry) throws {
		let entryDTO = DBOfflineEntryDTO(from: entry)
		try dbQueue.write { db in
			try entryDTO.update(db)
		}
	}

	// MARK: - Get All CacheEntries

	func getAll() throws -> [OfflineEntry] {
		let entriesDTOs = try dbQueue.read { db in
			try DBOfflineEntryDTO.fetchAll(db)
		}
		return entriesDTOs.map { $0.toOfflineEntry() }
	}

	// MARK: - clear All OfflineEntries

	func clear() throws {
		_ = try dbQueue.write { db in
			try DBOfflineEntryDTO.deleteAll(db)
		}
	}
}

private extension DBOfflineStorage {
	func initializeDatabase() throws {
		do {
			try dbQueue.write { db in
				if try !db.tableExists(DBOfflineEntryDTO.databaseTableName) {
					try db.create(table: DBOfflineEntryDTO.databaseTableName) { t in
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
			print("Failed to initialize table \(DBOfflineEntryDTO.databaseTableName): \(error)")
			throw error
		}
	}
}
