import Foundation

enum FileStorage {
	static func store(_ data: Data, subdirectory: String, filename: String) throws -> URL {
		let dir = try directory(for: subdirectory)
		let url = dir.appendingPathComponent(filename)
		try data.write(to: url, options: .atomic)
		return url
	}

	static func move(from source: URL, subdirectory: String, filename: String) throws -> URL {
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

	private static func directory(for subdirectory: String) throws -> URL {
		guard let appSupportDirectory = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
			throw FileStorageError.noApplicationSupportDirectory
		}
		let directory = appSupportDirectory.appendingPathComponent("Offliner/\(subdirectory)", isDirectory: true)
		try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
		return directory
	}
}

enum FileStorageError: Error {
	case noApplicationSupportDirectory
}
