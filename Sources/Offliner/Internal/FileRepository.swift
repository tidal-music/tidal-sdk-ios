import Foundation

enum FileRepository {
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

	private static func directory(for subdirectory: String) throws -> URL {
		guard let appSupportDirectory = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
			throw FileRepositoryError.noApplicationSupportDirectory
		}
		let directory = appSupportDirectory.appendingPathComponent("Offliner/\(subdirectory)", isDirectory: true)
		try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
		return directory
	}
}

enum FileRepositoryError: Error {
	case noApplicationSupportDirectory
}
