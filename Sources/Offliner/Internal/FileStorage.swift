import Foundation

// MARK: - FileStorage

final class FileStorage {
	let rootDirectory: URL
	private let writeLock = NSLock()
	private var acceptsWrites = true

	init(rootDirectory: URL) {
		self.rootDirectory = rootDirectory
	}

	func store(_ data: Data, subdirectory: String, filename: String) throws -> URL {
		writeLock.lock()
		defer { writeLock.unlock() }
		try ensureAcceptsWrites()
		let dir = try directory(for: subdirectory)
		let url = dir.appendingPathComponent(filename)
		try data.write(to: url, options: .atomic)
		return url
	}

	func move(from source: URL, subdirectory: String, filename: String) throws -> URL {
		writeLock.lock()
		defer { writeLock.unlock() }
		try ensureAcceptsWrites()
		let dir = try directory(for: subdirectory)
		let destination = dir.appendingPathComponent(filename)
		_ = try FileManager.default.replaceItemAt(destination, withItemAt: source)
		return destination
	}

	static func delete(url: URL) throws {
		try FileManager.default.removeItem(at: url)
	}

	static func delete(bookmark: Data) throws {
		var isStale = false
		let url = try URL(
			resolvingBookmarkData: bookmark,
			options: [],
			relativeTo: nil,
			bookmarkDataIsStale: &isStale
		)
		try delete(url: url)
	}

	func invalidateWrites() {
		writeLock.lock()
		acceptsWrites = false
		writeLock.unlock()
	}

	private func ensureAcceptsWrites() throws {
		guard acceptsWrites else {
			throw OfflinerLifecycleError.reset
		}
	}

	private func directory(for subdirectory: String) throws -> URL {
		let directory = rootDirectory.appendingPathComponent(subdirectory, isDirectory: true)
		try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
		return directory
	}
}

// MARK: - FileStorageError

enum FileStorageError: Error {
	case noApplicationSupportDirectory
}

// MARK: - FileCleanup

final class FileCleanup {
	var artworkLocation: URL?
	var licenseLocation: URL?
	var mediaLocation: URL?
}

func withFileCleanup(_ body: (FileCleanup) async throws -> Void) async throws {
	let cleanup = FileCleanup()
	do {
		try await body(cleanup)
	} catch {
		try? cleanup.artworkLocation.map(FileStorage.delete)
		try? cleanup.licenseLocation.map(FileStorage.delete)
		try? cleanup.mediaLocation.map(FileStorage.delete)
		throw error
	}
}
