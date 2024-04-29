import Foundation

struct DataWriter: DataWriterProtocol {
	func write(data: Data, to url: URL, options: Data.WritingOptions) throws {
		try data.write(to: url, options: options)
	}
}
