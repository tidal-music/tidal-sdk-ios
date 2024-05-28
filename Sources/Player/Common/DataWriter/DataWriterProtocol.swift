import Foundation

protocol DataWriterProtocol {
	func write(data: Data, to url: URL, options: Data.WritingOptions) throws
}
