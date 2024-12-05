import Foundation
import GRDB

// MARK: - GRDBCacheStorage

final class GRDBCacheStorage {
	private let dbQueue: DatabaseQueue

	init(dbQueue: DatabaseQueue) {
		self.dbQueue = dbQueue
	}

	static func initializeDatabase(dbQueue: DatabaseQueue) throws {
		do {
			var migrator = DatabaseMigrator()

			migrator.registerMigration("Setup CacheEntries table") { db in
				try db.create(table: CacheEntryGRDBEntity.databaseTableName) { t in
					t.column("key", .text).primaryKey()
					t.column("type", .text).notNull()
					t.column("mediaBookmark", .blob)
					t.column("lastAccessedAt", .datetime).notNull()
					t.column("size", .integer).notNull()
				}
			}

			try migrator.migrate(dbQueue)
		} catch {
			// TODO: Log error
			print("Failed to initialize Cache database: \(error)")
			throw error
		}
	}

	static func withDefaultDatabase() throws -> GRDBCacheStorage {
		let databaseURL = try GRDBCacheStorage.databaseURL()
		let dbQueue = try DatabaseQueue(path: databaseURL.path)
		try GRDBCacheStorage.initializeDatabase(dbQueue: dbQueue)

		return GRDBCacheStorage(dbQueue: dbQueue)
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

		guard let entity else {
			return nil
		}

		if entity.bookmarkDataNeedsUpdating() {
			try update(entity.cacheEntry)
		}

		return entity.cacheEntry
	}

	// MARK: - Delete CacheEntry by Key

	func delete(key: String) throws {
		_ = try dbQueue.write { db in
			try CacheEntryGRDBEntity.filter(CacheEntryGRDBEntity.Columns.key == key).deleteAll(db)
		}
	}

	// MARK: - Delete All CacheEntries

	func deleteAll() throws {
		let contentURLs = try getAll().compactMap { $0.url }

		_ = try dbQueue.write { db in
			try CacheEntryGRDBEntity.deleteAll(db)
		}

		guard !contentURLs.isEmpty else {
			return
		}

		SafeTask { [contentURLs] in
			for url in contentURLs {
				try? PlayerWorld.fileManagerClient.removeFile(url)
			}
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

	func pruneToSize(_ maxSize: Int) throws {
		try dbQueue.write { db in
			var currentSize = try self.calculateTotalSize(db)
			guard currentSize > maxSize else {
				return
			}

			let entries = try CacheEntryGRDBEntity
				.order(CacheEntryGRDBEntity.Columns.lastAccessedAt.asc) // Oldest first
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
	static func databaseURL() throws -> URL {
		let appSupportURL = PlayerWorld.fileManagerClient.applicationSupportDirectory()
		let directoryURL = appSupportURL.appendingPathComponent("PlayerCacheDatabase", isDirectory: true)
		try PlayerWorld.fileManagerClient.createDirectory(
			at: directoryURL,
			withIntermediateDirectories: true,
			attributes: [FileAttributeKey.protectionKey: URLFileProtection.none]
		)
		return directoryURL.appendingPathComponent("db.sqlite")
	}
}
