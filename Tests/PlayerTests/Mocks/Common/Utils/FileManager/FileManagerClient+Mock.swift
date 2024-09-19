import Foundation
@testable import Player

extension FileManagerClient {
	static let mock = Self(
		documentsDirectory: {
			FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
		},
		cachesDirectory: {
			FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
		},
		applicationSupportDirectory: {
			FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
		},
		fileExistsIsDirectory: { path, isDirectory in
			FileManager.default.fileExists(atPath: path, isDirectory: isDirectory)
		},
		fileExistsAtPath: { path in
			FileManager.default.fileExists(atPath: path)
		},
		copyItemAtURL: { source, destination in
			try FileManager.default.copyItem(at: source, to: destination)
		},
		removeFile: { url in
			try FileManager.default.removeItem(at: url)
		},
		moveFile: { source, destination in
			try FileManager.default.moveItem(at: source, to: destination)
		},
		urlForDirectory: { directory, domain, url, shouldCreate in
			try FileManager.default.url(for: directory, in: domain, appropriateFor: url, create: shouldCreate)
		},
		createDirectory: { url, hasIntermediateDirectories, attributes in
			try FileManager.default.createDirectory(
				at: url,
				withIntermediateDirectories: hasIntermediateDirectories,
				attributes: attributes
			)
		},
		contentsOfDirectory: { url, keys, options in
			try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: keys, options: options)
		}
	)
}
