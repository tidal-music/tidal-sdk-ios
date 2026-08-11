import CryptoKit
import Foundation
import GRDB

final class OfflinerStorage {
	private static let legacyResetLock = NSLock()
	private static let rootName = "Offliner"
	private static let accountsName = "Accounts"
	private static let legacyMigrationMarker = ".account-scoped-storage-v1"

	let rootDirectory: URL
	let databaseQueue: DatabaseQueue
	let offlineStore: OfflineStore
	let fileStorage: FileStorage
	let backgroundSessionIdentifier: String

	init(installationId: String, baseDirectory: URL? = nil) throws {
		let baseDirectory = try baseDirectory ?? Self.applicationSupportDirectory()
		let offlinerRoot = baseDirectory.appendingPathComponent(Self.rootName, isDirectory: true)
		let scope = Self.scope(for: installationId)
		rootDirectory = offlinerRoot
			.appendingPathComponent(Self.accountsName, isDirectory: true)
			.appendingPathComponent(scope, isDirectory: true)
		try FileManager.default.createDirectory(at: rootDirectory, withIntermediateDirectories: true)
		try Self.migrateLegacyStorageIfNeeded(at: offlinerRoot, to: rootDirectory, scope: scope)

		databaseQueue = try OfflineStore.makeDatabaseQueue(
			path: rootDirectory.appendingPathComponent("offline.sqlite").path
		)
		try Migrations.run(databaseQueue)
		offlineStore = OfflineStore(databaseQueue)
		fileStorage = FileStorage(rootDirectory: rootDirectory.appendingPathComponent("Artifacts", isDirectory: true))
		backgroundSessionIdentifier = "com.tidal.offliner.download.\(scope.prefix(32))"
	}

	func reset() throws {
		let bookmarks = (try? offlineStore.allBookmarks()) ?? []
		for bookmark in bookmarks {
			try? FileStorage.delete(bookmark: bookmark)
		}
		try databaseQueue.close()
		try? FileManager.default.removeItem(at: rootDirectory)
	}

	func invalidateWrites() {
		offlineStore.invalidateWrites()
		fileStorage.invalidateWrites()
	}

	private static func applicationSupportDirectory() throws -> URL {
		guard let directory = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
			throw FileStorageError.noApplicationSupportDirectory
		}
		return directory
	}

	private static func scope(for installationId: String) -> String {
		SHA256.hash(data: Data(installationId.utf8)).map { String(format: "%02x", $0) }.joined()
	}

	private static func migrateLegacyStorageIfNeeded(at root: URL, to accountRoot: URL, scope: String) throws {
		legacyResetLock.lock()
		defer { legacyResetLock.unlock() }

		try FileManager.default.createDirectory(at: root, withIntermediateDirectories: true)
		let marker = root.appendingPathComponent(legacyMigrationMarker)
		guard !FileManager.default.fileExists(atPath: marker.path) else { return }

		for name in ["offline.sqlite", "offline.sqlite-shm", "offline.sqlite-wal"] {
			let source = root.appendingPathComponent(name)
			let destination = accountRoot.appendingPathComponent(name)
			if FileManager.default.fileExists(atPath: source.path),
			   !FileManager.default.fileExists(atPath: destination.path) {
				try FileManager.default.moveItem(at: source, to: destination)
			}
		}

		let artifactsRoot = accountRoot.appendingPathComponent("Artifacts", isDirectory: true)
		try FileManager.default.createDirectory(at: artifactsRoot, withIntermediateDirectories: true)
		for name in ["Artworks", "Licenses"] {
			let source = root.appendingPathComponent(name, isDirectory: true)
			let destination = artifactsRoot.appendingPathComponent(name, isDirectory: true)
			if FileManager.default.fileExists(atPath: source.path),
			   !FileManager.default.fileExists(atPath: destination.path) {
				try FileManager.default.moveItem(at: source, to: destination)
			}
		}
		try Data(scope.utf8).write(to: marker, options: .atomic)
	}
}
