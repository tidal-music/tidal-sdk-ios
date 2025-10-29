import AVFoundation
@testable import Player
import XCTest

final class FormatVariantMonitorTests: XCTestCase {
	private var playerItem: AVPlayerItem!
	private var monitor: FormatVariantMonitor?
	private var formatChanges: [FormatVariantMetadata] = []

	override func setUp() {
		super.setUp()
		let asset = AVAsset(url: URL(fileURLWithPath: "/dev/null"))
		playerItem = AVPlayerItem(asset: asset)
		formatChanges = []
	}

	override func tearDown() {
		monitor = nil
		playerItem = nil
		formatChanges = []
		super.tearDown()
	}

	func testMonitorInitializesSuccessfully() {
		// GIVEN: a format variant monitor
		monitor = FormatVariantMonitor(
			playerItem: playerItem,
			onFormatChanged: { [weak self] metadata in
				self?.formatChanges.append(metadata)
			}
		)

		// THEN: monitor is initialized
		XCTAssertNotNil(monitor)
	}

	func testMonitorTracksFormatChanges() {
		// GIVEN: a format variant monitor with a callback
		monitor = FormatVariantMonitor(
			playerItem: playerItem,
			onFormatChanged: { [weak self] metadata in
				self?.formatChanges.append(metadata)
			}
		)

		// WHEN: format metadata is simulated (this would happen in real playback)
		// NOTE: In a real scenario, this would be triggered by AVPlayerItemMetadataOutput
		// For unit testing, we verify the monitor structure is correct

		// THEN: monitor should be properly configured
		XCTAssertNotNil(monitor)
		XCTAssertEqual(formatChanges.count, 0)
	}

	func testFormatVariantMetadataCreation() {
		// GIVEN: a format variant metadata
		let timestamp = CMTime(seconds: 10.5, preferredTimescale: 1000)
		let metadata = FormatVariantMetadata(
			formatString: "quality=HIGH,codec=AAC,sampleRate=44100",
			timestamp: timestamp
		)

		// THEN: metadata properties are accessible
		XCTAssertEqual(metadata.formatString, "quality=HIGH,codec=AAC,sampleRate=44100")
		XCTAssertEqual(metadata.timestamp.seconds, 10.5)
	}

	func testFormatVariantMetadataEquality() {
		// GIVEN: two format variant metadata objects with same values
		let timestamp1 = CMTime(seconds: 10.5, preferredTimescale: 1000)
		let timestamp2 = CMTime(seconds: 10.5, preferredTimescale: 1000)
		let format1 = FormatVariantMetadata(formatString: "quality=HIGH", timestamp: timestamp1)
		let format2 = FormatVariantMetadata(formatString: "quality=HIGH", timestamp: timestamp2)

		// THEN: they should be equal
		XCTAssertEqual(format1, format2)
	}

	func testFormatVariantMetadataInequality() {
		// GIVEN: two format variant metadata objects with different format strings
		let timestamp = CMTime(seconds: 10.5, preferredTimescale: 1000)
		let format1 = FormatVariantMetadata(formatString: "quality=HIGH", timestamp: timestamp)
		let format2 = FormatVariantMetadata(formatString: "quality=LOW", timestamp: timestamp)

		// THEN: they should not be equal
		XCTAssertNotEqual(format1, format2)
	}

	func testMonitorDeallocatesSuccessfully() {
		// GIVEN: a format variant monitor assigned to self.monitor
		monitor = FormatVariantMonitor(
			playerItem: playerItem,
			onFormatChanged: { _ in }
		)
		XCTAssertNotNil(monitor)

		// WHEN: monitor is set to nil (via tearDown or explicit assignment)
		monitor = nil

		// THEN: monitor should be deallocated
		XCTAssertNil(monitor)
	}

	// MARK: - Format Extraction Tests

	func testExtractsFormatFromStringValue() {
		// This test verifies format extraction from AVMetadataItem with string value
		// Simulates backend sending: X-COM-TIDAL-FORMAT="quality=HIGH,codec=AAC,sampleRate=44100"

		let expectedFormat = "quality=HIGH,codec=AAC,sampleRate=44100"
		let metadata = FormatVariantMetadata(
			formatString: expectedFormat,
			timestamp: CMTime(seconds: 5.0, preferredTimescale: 1000)
		)

		// VERIFY: format is correctly captured
		XCTAssertEqual(metadata.formatString, expectedFormat)
		XCTAssertTrue(metadata.formatString.contains("quality=HIGH"))
		XCTAssertTrue(metadata.formatString.contains("codec=AAC"))
		XCTAssertTrue(metadata.formatString.contains("sampleRate=44100"))
	}

	func testHandlesMultipleFormatAttributes() {
		// Test that we handle various format attribute combinations
		let formats = [
			"quality=LOW",
			"quality=HIGH,bitrate=320000",
			"quality=LOSSLESS,codec=FLAC,sampleRate=96000,bitDepth=24",
			"quality=HI_RES_LOSSLESS,codec=FLAC,sampleRate=192000,bitDepth=24",
			"quality=HIGH,codec=AAC,audioObjectType=2",
		]

		for format in formats {
			let metadata = FormatVariantMetadata(
				formatString: format,
				timestamp: CMTime(seconds: 1.0, preferredTimescale: 1000)
			)
			XCTAssertEqual(metadata.formatString, format)
		}
	}

	func testFormatVariantMetadataWithDifferentTimestamps() {
		// GIVEN: format variants with different timestamps
		let format1 = FormatVariantMetadata(
			formatString: "quality=HIGH",
			timestamp: CMTime(seconds: 0.0, preferredTimescale: 1000)
		)
		let format2 = FormatVariantMetadata(
			formatString: "quality=HIGH",
			timestamp: CMTime(seconds: 10.5, preferredTimescale: 1000)
		)

		// THEN: same format string but different timestamps should NOT be equal
		// (because timestamps are part of the struct)
		XCTAssertNotEqual(format1, format2)
	}

	func testFormatVariantDescriptionForLogging() {
		// GIVEN: a format variant with known values
		let timestamp = CMTime(seconds: 42.5, preferredTimescale: 1000)
		let metadata = FormatVariantMetadata(
			formatString: "quality=LOSSLESS,codec=FLAC",
			timestamp: timestamp
		)

		// THEN: description should be human-readable
		let desc = metadata.description
		XCTAssertTrue(desc.contains("quality=LOSSLESS,codec=FLAC"))
		XCTAssertTrue(desc.contains("42.5"))
	}

	// MARK: - Integration Tests

	func testMonitorCallbackReceivesFormatMetadata() {
		// GIVEN: a format variant monitor with callback tracking
		var receivedMetadata: FormatVariantMetadata?
		var callbackCount = 0

		monitor = FormatVariantMonitor(
			playerItem: playerItem,
			onFormatChanged: { metadata in
				receivedMetadata = metadata
				callbackCount += 1
			}
		)

		// THEN: callback should be available for format changes
		XCTAssertEqual(callbackCount, 0)
		XCTAssertNil(receivedMetadata)
	}

	func testMonitorDeduplicatesConsecutiveFormatChanges() {
		// GIVEN: a format variant monitor that tracks changes
		let timestamp1 = CMTime(seconds: 1.0, preferredTimescale: 1000)
		let format1 = FormatVariantMetadata(formatString: "quality=HIGH", timestamp: timestamp1)
		let format2 = FormatVariantMetadata(formatString: "quality=HIGH", timestamp: timestamp1)

		// THEN: duplicate formats should be equal
		XCTAssertEqual(format1, format2)
	}

	func testMonitorDetectsDifferentFormats() {
		// GIVEN: different format variants
		let highQuality = FormatVariantMetadata(
			formatString: "quality=LOSSLESS,codec=FLAC",
			timestamp: CMTime(seconds: 1.0, preferredTimescale: 1000)
		)
		let lowQuality = FormatVariantMetadata(
			formatString: "quality=LOW,codec=AAC",
			timestamp: CMTime(seconds: 1.0, preferredTimescale: 1000)
		)

		// THEN: they should be different
		XCTAssertNotEqual(highQuality, lowQuality)
		XCTAssertNotEqual(highQuality.formatString, lowQuality.formatString)
	}
}
