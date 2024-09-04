import Foundation
import GRDB

// MARK: - DBCacheStorage

class DBCacheStorage {
	private let dbQueue: DatabaseQueue

	init(dbQueue: DatabaseQueue) {
		self.dbQueue = dbQueue
		try? initializedDatabase()
	}

	// MARK: - Calculate Total Size

	func totalSize() throws -> Int {
		try dbQueue.read { db in
			try calculateTotalSize(db)
		}
	}

	// MARK: - Prune to a Maximum Size

	func pruneToSize(_ maxSize: Int) throws {
		try dbQueue.write { db in
			var currentSize = try self.calculateTotalSize(db)
			guard currentSize > maxSize else {
				return
			}

			let entries = try DBCacheEntryDTO
				.order(DBCacheEntryDTO.Columns.lastAccessedAt.asc) // Oldest first
				.fetchAll(db)

			for entry in entries {
				try entry.delete(db)
				currentSize -= entry.size

				if currentSize <= maxSize {
					break
				}
			}
		}
	}

	private func calculateTotalSize(_ db: Database) throws -> Int {
		let totalSize = try DBCacheEntryDTO.select(sum(DBCacheEntryDTO.Columns.size)).fetchOne(db) ?? 0
		return totalSize
	}
}

// MARK: CacheStorage

extension DBCacheStorage: CacheStorage {
	// MARK: - Save CacheEntry

	func save(_ entry: CacheEntry) throws {
		let entryDTO = DBCacheEntryDTO(from: entry)
		try dbQueue.write { db in
			try entryDTO.insert(db)
		}
	}

	// MARK: - Get CacheEntry by Key

	func get(key: String) throws -> CacheEntry? {
		let entryDTO = try dbQueue.read { db in
			try DBCacheEntryDTO.filter(DBCacheEntryDTO.Columns.key == key).fetchOne(db)
		}
		return entryDTO?.toCacheEntry()
	}

	// MARK: - Delete CacheEntry by Key

	func delete(key: String) throws {
		_ = try dbQueue.write { db in
			try DBCacheEntryDTO.filter(DBCacheEntryDTO.Columns.key == key).deleteAll(db)
		}
	}

	// MARK: - Update CacheEntry

	func update(_ entry: CacheEntry) throws {
		let entryDTO = DBCacheEntryDTO(from: entry)
		try dbQueue.write { db in
			try entryDTO.update(db)
		}
	}

	// MARK: - Get All CacheEntries

	func getAll() throws -> [CacheEntry] {
		let entriesDTOs = try dbQueue.read { db in
			try DBCacheEntryDTO.fetchAll(db)
		}
		return entriesDTOs.map { $0.toCacheEntry() }
	}
}

private extension DBCacheStorage {
	func initializedDatabase() throws {
		do {
			try dbQueue.write { db in
				if try !db.tableExists(DBCacheEntryDTO.databaseTableName) {
					try db.create(table: DBCacheEntryDTO.databaseTableName) { t in
						t.column("key", .text).primaryKey()
						t.column("type", .text).notNull()
						t.column("url", .text).notNull()
						t.column("lastAccessedAt", .datetime).notNull()
						t.column("size", .integer).notNull()
					}
				}
			}
		} catch {
			print("Failed to initialize table \(DBCacheEntryDTO.databaseTableName): \(error)")
			throw error
		}
	}
}
