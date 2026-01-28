import Foundation
import GRDB

internal enum Migrations {
	static func run(_ dbQueue: DatabaseQueue) throws {
		var migrator = DatabaseMigrator()
		for migration in try loadMigrations() {
			migrator.registerMigration(migration.identifier) { db in
				try db.execute(sql: migration.sql)
			}
		}
		try migrator.migrate(dbQueue)
	}

	private static func loadMigrations() throws -> [Migration] {
		guard let migrationsURL = Bundle.module.url(forResource: "Migrations", withExtension: nil) else {
			throw MigrationError.migrationsDirectoryNotFound
		}

		let fileManager = FileManager.default
		let contents = try fileManager.contentsOfDirectory(
			at: migrationsURL,
			includingPropertiesForKeys: nil
		)

		let migrations = try contents
			.filter { $0.pathExtension == "sql" }
			.compactMap { try Migration(url: $0) }
			.sorted { $0.version < $1.version }

		return migrations
	}
}

private struct Migration {
	let version: Int
	let identifier: String
	let sql: String

	init(url: URL) throws {
		let filename = url.deletingPathExtension().lastPathComponent

		guard let version = Self.parseVersion(from: filename) else {
			throw MigrationError.invalidMigrationFilename(filename)
		}

		self.version = version
		self.identifier = filename
		self.sql = try String(contentsOf: url, encoding: .utf8)
	}

	private static func parseVersion(from filename: String) -> Int? {
		guard filename.hasPrefix("V") else {
			return nil
		}
		
		let versionString = filename.dropFirst().prefix(while: { $0.isNumber })
		return Int(versionString)
	}
}

enum MigrationError: Error {
	case migrationsDirectoryNotFound
	case invalidMigrationFilename(String)
}
