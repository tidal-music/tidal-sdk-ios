import Foundation
import GRDB

enum Database {
	static func open(at path: String) throws -> DatabaseQueue {
		let dbQueue = try DatabaseQueue(path: path)
		try Migrations.run(dbQueue)
		return dbQueue
	}
}
