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
			// Create/Migrate OfflineEntry table
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
			
			// Create DownloadEntry table for tracking downloads in progress
			if try !db.tableExists(DownloadEntryGRDBEntity.databaseTableName) {
				try db.create(table: DownloadEntryGRDBEntity.databaseTableName) { t in
					t.column("id", .text).primaryKey()
					t.column("productId", .text).notNull().indexed()
					t.column("productType", .text).notNull()
					t.column("state", .text).notNull().indexed()
					t.column("progress", .double).notNull()
					t.column("attemptCount", .integer).notNull()
					t.column("lastError", .text)
					t.column("createdAt", .integer).notNull()
					t.column("updatedAt", .integer).notNull().indexed()
					t.column("pausedAt", .integer)
					t.column("backgroundTaskIdentifier", .text)
					t.column("partialMediaPathBookmark", .blob)
					t.column("partialLicensePathBookmark", .blob)
				}
			}
		}
	}

	static func withDefaultDatabase() throws -> GRDBOfflineStorage {
		let databaseURL = try GRDBOfflineStorage.databaseURL()
		let dbQueue = try DatabaseQueue(path: databaseURL.path)
		try GRDBOfflineStorage.initializeDatabase(dbQueue: dbQueue)

		return GRDBOfflineStorage(dbQueue: dbQueue)
	}
}

// MARK: OfflineStorage

extension GRDBOfflineStorage: OfflineStorage {
	// MARK: - OfflineEntry Management (Completed downloads)

	func save(_ entry: OfflineEntry) throws {
		let entity = OfflineEntryGRDBEntity(from: entry)
		try dbQueue.write { db in
			try entity.insert(db)
		}
	}

	func get(key: String) throws -> OfflineEntry? {
		let entity = try dbQueue.read { db in
			try OfflineEntryGRDBEntity.filter(OfflineEntryGRDBEntity.Columns.productId == key).fetchOne(db)
		}
		return entity?.offlineEntry
	}

	func delete(key: String) throws {
		_ = try dbQueue.write { db in
			try OfflineEntryGRDBEntity.filter(OfflineEntryGRDBEntity.Columns.productId == key).deleteAll(db)
		}
	}

	func update(_ entry: OfflineEntry) throws {
		let entity = OfflineEntryGRDBEntity(from: entry)
		try dbQueue.write { db in
			try entity.update(db)
		}
	}

	func getAll() throws -> [OfflineEntry] {
		let entities = try dbQueue.read { db in
			try OfflineEntryGRDBEntity.fetchAll(db)
		}
		return entities.map { $0.offlineEntry }
	}

	func clear() throws {
		_ = try dbQueue.write { db in
			try OfflineEntryGRDBEntity.deleteAll(db)
		}
	}

	func totalSize() throws -> Int {
		try dbQueue.read { db in
			try calculateTotalSize(db)
		}
	}
    
    // MARK: - DownloadEntry Management (In-progress downloads)
    
    func saveDownloadEntry(_ entry: DownloadEntry) throws {
        let entity = DownloadEntryGRDBEntity(from: entry)
        try dbQueue.write { db in
            try entity.insert(db)
        }
    }
    
    func getDownloadEntry(id: String) throws -> DownloadEntry? {
        let entity = try dbQueue.read { db in
            try DownloadEntryGRDBEntity.filter(DownloadEntryGRDBEntity.Columns.id == id).fetchOne(db)
        }
        return entity?.downloadEntry
    }
    
    func getDownloadEntryByProductId(productId: String) throws -> DownloadEntry? {
        let entity = try dbQueue.read { db in
            try DownloadEntryGRDBEntity.filter(DownloadEntryGRDBEntity.Columns.productId == productId).order(DownloadEntryGRDBEntity.Columns.updatedAt.desc).fetchOne(db)
        }
        return entity?.downloadEntry
    }
    
    func getAllDownloadEntries() throws -> [DownloadEntry] {
        let entities = try dbQueue.read { db in
            try DownloadEntryGRDBEntity.order(DownloadEntryGRDBEntity.Columns.updatedAt.desc).fetchAll(db)
        }
        return entities.map { $0.downloadEntry }
    }
    
    func getDownloadEntriesByState(state: DownloadState) throws -> [DownloadEntry] {
        let entities = try dbQueue.read { db in
            try DownloadEntryGRDBEntity
                .filter(DownloadEntryGRDBEntity.Columns.state == state.rawValue)
                .order(DownloadEntryGRDBEntity.Columns.updatedAt.desc)
                .fetchAll(db)
        }
        return entities.map { $0.downloadEntry }
    }
    
    func deleteDownloadEntry(id: String) throws {
        _ = try dbQueue.write { db in
            try DownloadEntryGRDBEntity.filter(DownloadEntryGRDBEntity.Columns.id == id).deleteAll(db)
        }
    }
    
    func updateDownloadEntry(_ entry: DownloadEntry) throws {
        let entity = DownloadEntryGRDBEntity(from: entry)
        try dbQueue.write { db in
            try entity.update(db)
        }
    }
    
    func cleanupStaleDownloadEntries(threshold: TimeInterval) throws -> Int {
        // Calculate timestamp threshold for stale downloads
        let now = PlayerWorld.timeProvider.timestamp()
        let thresholdTimestamp = now - UInt64(threshold * 1000)
        
        // For test robustness, we need to capture the result of the operation
        let deleted = try dbQueue.write { db -> Int in
            try DownloadEntryGRDBEntity
                .filter(DownloadEntryGRDBEntity.Columns.state == DownloadState.FAILED.rawValue || 
                        DownloadEntryGRDBEntity.Columns.state == DownloadState.CANCELLED.rawValue)
                .filter(DownloadEntryGRDBEntity.Columns.updatedAt < thresholdTimestamp)
                .deleteAll(db)
        }
        
        // We'll add proper logging in a later phase
        return deleted // Return the count for potential future usage
    }
}

private extension GRDBOfflineStorage {
	static func databaseURL() throws -> URL {
		let appSupportURL = PlayerWorld.fileManagerClient.applicationSupportDirectory()
		let directoryURL = appSupportURL.appendingPathComponent("PlayerOfflineDatabase", isDirectory: true)
		if PlayerWorld.fileManagerClient.fileExists(atPath: directoryURL.path, isDirectory: nil) {
			do {
				var attributes = try PlayerWorld.fileManagerClient.attributesOfItem(directoryURL.path)
				if let protectionKey = attributes[FileAttributeKey.protectionKey] as? FileProtectionType,
				   protectionKey != FileProtectionType.none
				{
					attributes[FileAttributeKey.protectionKey] = FileProtectionType.none
					try PlayerWorld.fileManagerClient.setAttributes(attributes, directoryURL.path)
				}
			} catch {
				PlayerWorld.logger?.log(loggable: PlayerLoggable.updateDBFileAttributes(error: error))
			}
		} else {
			try PlayerWorld.fileManagerClient.createDirectory(
				at: directoryURL,
				withIntermediateDirectories: true,
				attributes: [FileAttributeKey.protectionKey: URLFileProtection.none]
			)
		}
		return directoryURL.appendingPathComponent("db.sqlite")
	}

	func calculateTotalSize(_ db: Database) throws -> Int {
		let totalSize = try OfflineEntryGRDBEntity.select(sum(OfflineEntryGRDBEntity.Columns.size)).fetchOne(db) ?? 0
		return totalSize
	}
}
