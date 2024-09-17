import Foundation

// MARK: - FileManagerClient

struct FileManagerClient {
	var documentsDirectory: () -> URL
	var cachesDirectory: () -> URL
	var applicationSupportDirectory: () -> URL
	var fileExistsIsDirectory: (_ path: String, _ isDirectory: UnsafeMutablePointer<ObjCBool>?) -> Bool
	var fileExistsAtPath: (_ path: String) -> Bool
	var copyItemAtURL: (_ source: URL, _ destination: URL) throws -> Void
	var removeFile: (_ url: URL) throws -> Void
	var moveFile: (_ source: URL, _ destination: URL) throws -> Void
	var urlForDirectory: (
		_ directory: FileManager.SearchPathDirectory,
		_ domain: FileManager.SearchPathDomainMask,
		_ url: URL?,
		_ shouldCreate: Bool
	) throws -> URL
	var createDirectory: (_ url: URL, _ createIntermediates: Bool, _ attributes: [FileAttributeKey: Any]?) throws -> Void
	var contentsOfDirectory: (_ url: URL, _ keys: [URLResourceKey]?, _ options: FileManager.DirectoryEnumerationOptions) throws
		-> [URL]
}

extension FileManagerClient {
	func fileExists(atPath path: String, isDirectory: UnsafeMutablePointer<ObjCBool>?) -> Bool {
		fileExistsIsDirectory(path, isDirectory)
	}

	func copyItem(at source: URL, to destination: URL) throws {
		try copyItemAtURL(source, destination)
	}

	func moveFile(atPath sourcePath: URL, toPath destinationPath: URL) throws {
		try moveFile(sourcePath, destinationPath)
	}

	func removeItem(at url: URL) throws {
		try removeFile(url)
	}

	func url(
		for directory: FileManager.SearchPathDirectory,
		in domain: FileManager.SearchPathDomainMask,
		appropriateFor url: URL?,
		shouldCreate: Bool
	) throws -> URL {
		try urlForDirectory(directory, domain, url, shouldCreate)
	}

	func createDirectory(
		at url: URL,
		withIntermediateDirectories createIntermediates: Bool,
		attributes: [FileAttributeKey: Any]? = nil
	) throws {
		try createDirectory(url, createIntermediates, attributes)
	}

	func contentsOfDirectory(
		at url: URL,
		includingPropertiesForKeys keys: [URLResourceKey]?,
		options mask: FileManager.DirectoryEnumerationOptions = []
	) throws -> [URL] {
		try contentsOfDirectory(url, keys, mask)
	}
}
