@testable import Offliner
import XCTest

func assertEventually(
	_ stream: AsyncStream<Download.Event>,
	condition: @escaping (Download.Event) -> Bool
) async {
	for await element in stream where condition(element) {
		return
	}
	XCTFail("Stream ended without matching condition")
}
