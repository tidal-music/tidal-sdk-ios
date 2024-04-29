import Foundation
@testable import Player

final class DataWriterMock: DataWriterProtocol {
	private(set) var dataList = [Data]()
	private(set) var urls = [URL]()
	private(set) var optionsList = [Data.WritingOptions]()

	var shouldError: Bool = false

	func write(data: Data, to url: URL, options: Data.WritingOptions) throws {
		guard !shouldError else {
			throw PlayerError(errorId: .EUnexpected, errorCode: "")
		}

		dataList.append(data)
		urls.append(url)
		optionsList.append(options)
	}
}
