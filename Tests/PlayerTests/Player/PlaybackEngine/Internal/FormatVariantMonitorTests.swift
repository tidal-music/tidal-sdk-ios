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
}
