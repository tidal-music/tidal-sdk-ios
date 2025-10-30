import Foundation
import GRDB

// MARK: - GRDBCacheStorage

final class GRDBCacheStorage {
	private let dbQueue: DatabaseQueue

	init(dbQueue: DatabaseQueue) {
		self.dbQueue = dbQueue
		try? initializeDatabase()
		try? addLastAccessedAtIndex()
	}
}

private extension GRDBCacheStorage {
	private func calculateTotalSize(_ db: Database) throws -> Int {
		let totalSize = try CacheEntryGRDBEntity.select(sum(CacheEntryGRDBEntity.Columns.size)).fetchOne(db) ?? 0
		return totalSize
	}
}

// MARK: CacheStorage

extension GRDBCacheStorage: CacheStorage {
	// MARK: - Save CacheEntry

	func save(_ entry: CacheEntry) throws {
		let entity = CacheEntryGRDBEntity(from: entry)
		try dbQueue.write { db in
			try entity.insert(db)
		}
	}

	// MARK: - Get CacheEntry by Key

	func get(key: String) throws -> CacheEntry? {
		let entity = try dbQueue.read { db in
			try CacheEntryGRDBEntity.filter(CacheEntryGRDBEntity.Columns.key == key).fetchOne(db)
		}
		return entity?.cacheEntry
	}

	// MARK: - Delete CacheEntry by Key

	func delete(key: String) throws {
		_ = try dbQueue.write { db in
			try CacheEntryGRDBEntity.filter(CacheEntryGRDBEntity.Columns.key == key).deleteAll(db)
		}
	}

	// MARK: - Update CacheEntry

	func update(_ entry: CacheEntry) throws {
		let entity = CacheEntryGRDBEntity(from: entry)
		try dbQueue.write { db in
			try entity.update(db)
		}
	}

	// MARK: - Get All CacheEntries

	func getAll() throws -> [CacheEntry] {
		let entities = try dbQueue.read { db in
			try CacheEntryGRDBEntity.fetchAll(db)
		}
		return entities.map { $0.cacheEntry }
	}

	// MARK: - Calculate Total Size

	func totalSize() throws -> Int {
		try dbQueue.read { db in
			try calculateTotalSize(db)
		}
	}

	// MARK: - Prune to a Maximum Size

	/// Removes cache entries until total size is below the target using LRU (Least Recently Used) eviction.
	///
	/// Uses database-level sorting via the `idx_cacheEntry_lastAccessedAt` index for efficient
	/// retrieval of oldest entries. Entries are sorted by `lastAccessedAt` in ascending order
	/// and deleted until cache size is below the target.
	///
	/// - Parameter maxSize: Target cache size in bytes
	/// - Throws: Any database operation errors
	/// - Performance: O(k log n) where k = entries deleted, n = total entries
	///   Query is efficient due to index on lastAccessedAt column
	/// - Note: This operation runs in a write transaction for atomicity
	func pruneToSize(_ maxSize: Int) throws {
		try dbQueue.write { db in
			var currentSize = try self.calculateTotalSize(db)
			guard currentSize > maxSize else {
				return
			}

			let entries = try CacheEntryGRDBEntity
				.order(CacheEntryGRDBEntity.Columns.lastAccessedAt.asc) // Oldest first (uses index)
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
}

private extension GRDBCacheStorage {
	func initializeDatabase() throws {
		do {
			try dbQueue.write { db in
				if try !db.tableExists(CacheEntryGRDBEntity.databaseTableName) {
					try db.create(table: CacheEntryGRDBEntity.databaseTableName) { t in
						t.column("key", .text).primaryKey()
						t.column("type", .text).notNull()
						t.column("url", .text).notNull()
						t.column("lastAccessedAt", .datetime).notNull()
						t.column("size", .integer).notNull()
					}
				}
			}
		} catch {
			// TODO: Log error
			print("Failed to initialize table \(CacheEntryGRDBEntity.databaseTableName): \(error)")
			throw error
		}
	}

	/// Creates an index on lastAccessedAt column for efficient LRU pruning queries.
	/// Idempotent: safe to call multiple times (checks for existing index before creating).
	func addLastAccessedAtIndex() throws {
		try dbQueue.write { db in
			// Create index on lastAccessedAt for efficient ORDER BY queries in pruneToSize.
			// Use IF NOT EXISTS to make it idempotent (safe to call multiple times).
			let indexName = "idx_cacheEntry_lastAccessedAt"
			try db.execute(sql: """
				CREATE INDEX IF NOT EXISTS \(indexName)
				ON \(CacheEntryGRDBEntity.databaseTableName)(lastAccessedAt)
				""")
		}
	}
}
