import CoreAudio
@testable import Player
import XCTest

final class AssetPlaybackMetadataTests: XCTestCase {
	func testParsingExternalPlayerMetadata() throws {
		let validMatadata = [
			AssetPlaybackMetadata(sampleRate: "44100.000000", bitDepth: "24"),
			AssetPlaybackMetadata(sampleRate: "48000.000000", bitDepth: "24"),
			AssetPlaybackMetadata(sampleRate: "88200.000000", bitDepth: "24"),
			AssetPlaybackMetadata(sampleRate: "96000.000000", bitDepth: "24"),
			AssetPlaybackMetadata(sampleRate: "192000.000000", bitDepth: "24"),
		]

		validMatadata.forEach { metadata in
			XCTAssertNotNil(metadata)
		}

		let invalidMatadata = [
			AssetPlaybackMetadata(sampleRate: nil, bitDepth: "24"),
			AssetPlaybackMetadata(sampleRate: "48000.000000", bitDepth: nil),
			AssetPlaybackMetadata(sampleRate: "98khz", bitDepth: "24"),
		]

		invalidMatadata.forEach { metadata in
			XCTAssertNil(metadata)
		}
	}

	func test_init_withSampleRate_and_nilFormatFlags() {
		let assetPlaybackMetadata = AssetPlaybackMetadata(sampleRate: 10, formatFlags: nil)
		XCTAssertNil(assetPlaybackMetadata)
	}

	func test_init_withNilSampleRate_and_formatFlags() {
		let assetPlaybackMetadata = AssetPlaybackMetadata(sampleRate: nil, formatFlags: kAppleLosslessFormatFlag_16BitSourceData)
		XCTAssertNil(assetPlaybackMetadata)
	}

	func test_init_withSampleRate_and_16bitFormatFlags() {
		let assetPlaybackMetadata = AssetPlaybackMetadata(sampleRate: 1, formatFlags: kAppleLosslessFormatFlag_16BitSourceData)
		XCTAssertNotNil(assetPlaybackMetadata)
		XCTAssertEqual(assetPlaybackMetadata?.bitDepth, 16)
	}

	func test_init_withSampleRate_and_24bitFormatFlags() {
		let assetPlaybackMetadata = AssetPlaybackMetadata(sampleRate: 1, formatFlags: kAppleLosslessFormatFlag_24BitSourceData)
		XCTAssertNotNil(assetPlaybackMetadata)
		XCTAssertEqual(assetPlaybackMetadata?.bitDepth, 24)
	}

	func test_init_withSampleRate_and_32bitFormatFlags() {
		let assetPlaybackMetadata = AssetPlaybackMetadata(sampleRate: 1, formatFlags: kAppleLosslessFormatFlag_32BitSourceData)
		XCTAssertNotNil(assetPlaybackMetadata)
		XCTAssertEqual(assetPlaybackMetadata?.bitDepth, 32)
	}

	func test_init_withSampleRate_and_unexpectedFormatFlags() {
		let assetPlaybackMetadata = AssetPlaybackMetadata(sampleRate: 1, formatFlags: 8)
		XCTAssertNil(assetPlaybackMetadata)
	}
}
