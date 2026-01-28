@testable import Downloader
import GRDB
import XCTest

final class DatabaseTests: XCTestCase {
	private var dbPath: String!

	override func setUp() {
		super.setUp()
		let tempDir = FileManager.default.temporaryDirectory
		dbPath = tempDir.appendingPathComponent(UUID().uuidString + ".sqlite").path
	}

	override func tearDown() {
		if let path = dbPath {
			try? FileManager.default.removeItem(atPath: path)
		}
		super.tearDown()
	}

	func testMigrationsCreateExpectedTables() throws {
		let dbQueue = try Database.open(at: dbPath)

		try dbQueue.read { db in
			XCTAssertTrue(try db.tableExists("offline_item"))
			XCTAssertTrue(try db.tableExists("offline_item_relationship"))
		}
	}

	func testMigrationsAreIdempotent() throws {
		let dbQueue = try Database.open(at: dbPath)

		XCTAssertNoThrow(try Migrations.run(dbQueue))
		XCTAssertNoThrow(try Migrations.run(dbQueue))
	}
}
