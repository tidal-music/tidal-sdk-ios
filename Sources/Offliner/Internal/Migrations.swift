import Foundation
import GRDB

enum Migrations {
	static func run(_ dbQueue: DatabaseQueue) throws {
		var migrator = DatabaseMigrator()
		for migration in try loadMigrations() {
			migrator.registerMigration(migration.identifier) { database in
				try database.execute(sql: migration.sql)
			}
		}
		try migrator.migrate(dbQueue)
	}

	private static func loadMigrations() throws -> [Migration] {
		// With .process resources, SQL files are flattened to the bundle root.
		// Find all SQL files that match the migration naming pattern (V000001_*.sql)
		let bundle = Bundle.module
		guard let resourcePath = bundle.resourcePath else {
			throw MigrationError.migrationsDirectoryNotFound
		}

		let fileManager = FileManager.default
		let contents = try fileManager.contentsOfDirectory(atPath: resourcePath)

		let migrations = try contents
			.filter { $0.hasSuffix(".sql") && $0.hasPrefix("V") }
			.compactMap { filename -> Migration? in
				guard let url = bundle.url(forResource: filename.replacingOccurrences(of: ".sql", with: ""), withExtension: "sql") else {
					return nil
				}
				return try Migration(url: url)
			}
			.sorted { $0.version < $1.version }

		guard !migrations.isEmpty else {
			throw MigrationError.migrationsDirectoryNotFound
		}

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
