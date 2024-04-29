import Foundation

struct FileManagerHelper {
	static let shared = FileManagerHelper()
	private init() {}

	private var documentsFolder: URL? = try? FileManager.default.url(
		for: .documentDirectory,
		in: .userDomainMask,
		appropriateFor: nil,
		create: true
	)

	var eventQueueDatabaseURL: URL? {
		documentsFolder?.appendingPathComponent(EventQueue.databaseName)
	}

	var monitoringQueueDatabaseURL: URL? {
		documentsFolder?.appendingPathComponent(MonitoringQueue.databaseName)
	}

	var totalDiskSpaceBytes: Int {
		guard let totalCapacity = try? documentsFolder?.resourceValues(forKeys: [.volumeTotalCapacityKey]).volumeTotalCapacity
		else {
			return 0
		}
		return totalCapacity
	}

	var availableDiskSpaceBytes: Int {
		guard let availableCapacity = try? documentsFolder?.resourceValues(forKeys: [.volumeAvailableCapacityKey])
			.volumeAvailableCapacity
		else {
			return 0
		}
		return availableCapacity
	}

	var isDiskSpaceAvailable: Bool {
		availableDiskSpaceBytes > 0
	}

	func exceedsMaximumSize(object: Data, maximumSize: Int) -> Bool {
		object.count > maximumSize
	}
}
