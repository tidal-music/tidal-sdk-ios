import CryptoKit
import Foundation
import GRDB

final class OfflinerStorage {
	private static let rootName = "Offliner"
	private static let accountsName = "Accounts"

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
}
