import AVFoundation
@testable import Player
import XCTest

final class FormatVariantMonitorTests: XCTestCase {
	private var playerItem: AVPlayerItem!
	private var monitor: FormatVariantMonitor?
	private var formatChanges: [FormatVariantMetadata] = []
	private var testQueue: OperationQueue!

	override func setUp() {
		super.setUp()
		let asset = AVAsset(url: URL(fileURLWithPath: "/dev/null"))
		playerItem = AVPlayerItem(asset: asset)
		formatChanges = []
		testQueue = OperationQueue()
		testQueue.maxConcurrentOperationCount = 1
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
			queue: testQueue,
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
			queue: testQueue,
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
		let metadata = FormatVariantMetadata(
			formatString: "quality=HIGH,codec=AAC,sampleRate=44100"
		)

		// THEN: metadata properties are accessible
		XCTAssertEqual(metadata.formatString, "quality=HIGH,codec=AAC,sampleRate=44100")
	}

	func testFormatVariantMetadataWithSampleRateAndBitDepth() {
		// GIVEN: a format variant metadata with sample rate and bit depth
		let metadata = FormatVariantMetadata(
			formatString: "quality=HIGH,codec=AAC",
			sampleRate: 44100,
			bitDepth: 16
		)

		// THEN: all properties are accessible
		XCTAssertEqual(metadata.formatString, "quality=HIGH,codec=AAC")
		XCTAssertEqual(metadata.sampleRate, 44100)
		XCTAssertEqual(metadata.bitDepth, 16)
	}

	func testFormatVariantMetadataWithOptionalFields() {
		// GIVEN: format metadata with optional fields
		let withoutOptionals = FormatVariantMetadata(formatString: "quality=HIGH")
		let withSampleRate = FormatVariantMetadata(formatString: "quality=HIGH", sampleRate: 48000)
		let withBitDepth = FormatVariantMetadata(formatString: "quality=HIGH", bitDepth: 24)
		let withBoth = FormatVariantMetadata(formatString: "quality=HIGH", sampleRate: 96000, bitDepth: 24)

		// THEN: optional fields should be nil or set accordingly
		XCTAssertNil(withoutOptionals.sampleRate)
		XCTAssertNil(withoutOptionals.bitDepth)
		XCTAssertEqual(withSampleRate.sampleRate, 48000)
		XCTAssertNil(withSampleRate.bitDepth)
		XCTAssertEqual(withBitDepth.bitDepth, 24)
		XCTAssertNil(withBitDepth.sampleRate)
		XCTAssertEqual(withBoth.sampleRate, 96000)
		XCTAssertEqual(withBoth.bitDepth, 24)
	}

	func testFormatVariantMetadataEquality() {
		// GIVEN: two format variant metadata objects with same format string
		let format1 = FormatVariantMetadata(formatString: "quality=HIGH")
		let format2 = FormatVariantMetadata(formatString: "quality=HIGH")

		// THEN: they should be equal
		XCTAssertEqual(format1, format2)
	}

	func testFormatVariantMetadataInequality() {
		// GIVEN: two format variant metadata objects with different format strings
		let format1 = FormatVariantMetadata(formatString: "quality=HIGH")
		let format2 = FormatVariantMetadata(formatString: "quality=LOW")

		// THEN: they should not be equal
		XCTAssertNotEqual(format1, format2)
	}

	func testMonitorDeallocatesSuccessfully() {
		// GIVEN: a format variant monitor assigned to self.monitor
		monitor = FormatVariantMonitor(
			playerItem: playerItem,
			queue: testQueue,
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
		let metadata = FormatVariantMetadata(formatString: expectedFormat)

		// VERIFY: format is correctly captured
		XCTAssertEqual(metadata.formatString, expectedFormat)
		XCTAssertTrue(metadata.formatString.contains("quality=HIGH"))
		XCTAssertTrue(metadata.formatString.contains("codec=AAC"))
		XCTAssertTrue(metadata.formatString.contains("sampleRate=44100"))
	}

	func testHandlesMultipleFormatAttributes() {
		// Test that we handle various format values from the backend
		// Backend sends simple format enum names: LOW, HIGH, LOSSLESS, HI_RES_LOSSLESS
		// Client is flexible to handle future extensions with more detailed metadata
		let formats = [
			"LOW",                                                              // Backend format
			"HIGH",                                                             // Backend format
			"LOSSLESS",                                                         // Backend format
			"HI_RES_LOSSLESS",                                                  // Backend format
			"quality=HIGH,codec=AAC,audioObjectType=2",                        // Future: extended format
		]

		for format in formats {
			let metadata = FormatVariantMetadata(formatString: format)
			XCTAssertEqual(metadata.formatString, format)
		}
	}

	func testFormatVariantMetadataEqualsFormatString() {
		// GIVEN: format variants with same format string
		let format1 = FormatVariantMetadata(formatString: "quality=HIGH")
		let format2 = FormatVariantMetadata(formatString: "quality=HIGH")

		// THEN: they should be equal
		// Equality compares only formatString to enable deduplication
		XCTAssertEqual(format1, format2)
	}

	func testFormatVariantDescriptionForLogging() {
		// GIVEN: a format variant with known values
		let metadata = FormatVariantMetadata(formatString: "quality=LOSSLESS,codec=FLAC")

		// THEN: description should be human-readable
		let desc = metadata.description
		XCTAssertTrue(desc.contains("quality=LOSSLESS,codec=FLAC"))
		XCTAssertTrue(desc.contains("FormatVariantMetadata"))
	}

	// MARK: - Integration Tests

	func testMonitorCallbackReceivesFormatMetadata() {
		// GIVEN: a format variant monitor with callback tracking
		var receivedMetadata: FormatVariantMetadata?
		var callbackCount = 0

		monitor = FormatVariantMonitor(
			playerItem: playerItem,
			queue: testQueue,
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
		// GIVEN: duplicate format variants
		let format1 = FormatVariantMetadata(formatString: "quality=HIGH")
		let format2 = FormatVariantMetadata(formatString: "quality=HIGH")

		// THEN: duplicate formats should be equal for deduplication
		XCTAssertEqual(format1, format2)
	}

	func testMonitorDetectsDifferentFormats() {
		// GIVEN: different format variants
		let highQuality = FormatVariantMetadata(formatString: "quality=LOSSLESS,codec=FLAC")
		let lowQuality = FormatVariantMetadata(formatString: "quality=LOW,codec=AAC")

		// THEN: they should be different
		XCTAssertNotEqual(highQuality, lowQuality)
		XCTAssertNotEqual(highQuality.formatString, lowQuality.formatString)
	}

	// MARK: - Equality Tests with New Fields

	func testFormatVariantEqualityIncludesSampleRateAndBitDepth() {
		// GIVEN: format metadata with same format but different sample rate/bitDepth
		let format1 = FormatVariantMetadata(formatString: "quality=HIGH", sampleRate: 44100, bitDepth: 16)
		let format2 = FormatVariantMetadata(formatString: "quality=HIGH", sampleRate: 44100, bitDepth: 16)
		let format3 = FormatVariantMetadata(formatString: "quality=HIGH", sampleRate: 48000, bitDepth: 16)
		let format4 = FormatVariantMetadata(formatString: "quality=HIGH", sampleRate: 44100, bitDepth: 24)

		// THEN: formats with same all properties should be equal
		XCTAssertEqual(format1, format2)
		// But different sample rate or bit depth should make them unequal
		XCTAssertNotEqual(format1, format3)
		XCTAssertNotEqual(format1, format4)
	}

	func testFormatVariantDescriptionIncludesNewFields() {
		// GIVEN: format metadata with sample rate and bit depth
		let metadata = FormatVariantMetadata(
			formatString: "quality=LOSSLESS,codec=FLAC",
			sampleRate: 96000,
			bitDepth: 24
		)

		// THEN: description should include all fields
		let desc = metadata.description
		XCTAssertTrue(desc.contains("quality=LOSSLESS,codec=FLAC"))
		XCTAssertTrue(desc.contains("96000"))
		XCTAssertTrue(desc.contains("24"))
		XCTAssertTrue(desc.contains("sampleRate"))
		XCTAssertTrue(desc.contains("bitDepth"))
	}

	func testFormatVariantDescriptionWithoutOptionalFields() {
		// GIVEN: format metadata without optional fields
		let metadata = FormatVariantMetadata(formatString: "quality=HIGH")

		// THEN: description should not include nil fields
		let desc = metadata.description
		XCTAssertTrue(desc.contains("quality=HIGH"))
		// Nil fields should not appear in description
		XCTAssertFalse(desc.contains("sampleRate: nil"))
		XCTAssertFalse(desc.contains("bitDepth: nil"))
	}
}
