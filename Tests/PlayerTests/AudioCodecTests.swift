@testable import Player
import XCTest

final class AudioCodecTests: XCTestCase {
	func testFromQualityAndMode() throws {
		XCTAssertNil(AudioCodec(from: nil, mode: nil))
		XCTAssertNil(AudioCodec(from: nil, mode: AudioMode.STEREO))
		XCTAssertNil(AudioCodec(from: AudioQuality.LOW, mode: nil))
		XCTAssertNil(AudioCodec(from: AudioQuality.LOW, mode: AudioMode.DOLBY_ATMOS))
		XCTAssertNil(AudioCodec(from: AudioQuality.LOW, mode: AudioMode.SONY_360RA))

		XCTAssertEqual(AudioCodec(from: AudioQuality.HIGH, mode: nil), AudioCodec.AAC_LC)
		XCTAssertEqual(AudioCodec(from: AudioQuality.HIGH, mode: AudioMode.STEREO), AudioCodec.AAC_LC)

		XCTAssertEqual(AudioCodec(from: AudioQuality.LOSSLESS, mode: nil), AudioCodec.FLAC)
		XCTAssertEqual(AudioCodec(from: AudioQuality.LOSSLESS, mode: AudioMode.STEREO), AudioCodec.FLAC)

		XCTAssertEqual(AudioCodec(from: AudioQuality.HI_RES, mode: nil), AudioCodec.MQA)
		XCTAssertEqual(AudioCodec(from: AudioQuality.HI_RES, mode: AudioMode.STEREO), AudioCodec.MQA)

		XCTAssertEqual(AudioCodec(from: AudioQuality.HI_RES_LOSSLESS, mode: nil), AudioCodec.FLAC)
		XCTAssertEqual(AudioCodec(from: AudioQuality.HI_RES_LOSSLESS, mode: AudioMode.STEREO), AudioCodec.FLAC)
	}

	func testFromString() throws {
		let upperCasedAACCodec = "AAC"
		let newCodec = "new_codec"

		XCTAssertNil(AudioCodec(rawValue: nil))

		XCTAssertEqual(AudioCodec(rawValue: AudioCodec.Constants.Manifest_Name_HE_AAC_V1), AudioCodec.HE_AAC_V1)
		XCTAssertEqual(AudioCodec(rawValue: AudioCodec.Constants.Manifest_Name_AAC_LC), AudioCodec.AAC_LC)
		XCTAssertEqual(AudioCodec(rawValue: AudioCodec.Constants.Manifest_Name_AAC), AudioCodec.AAC)
		XCTAssertEqual(AudioCodec(rawValue: upperCasedAACCodec), AudioCodec.AAC)
		XCTAssertEqual(AudioCodec(rawValue: AudioCodec.Constants.Manifest_Name_FLAC), AudioCodec.FLAC)
		XCTAssertEqual(AudioCodec(rawValue: AudioCodec.Constants.Manifest_Name_ALAC), AudioCodec.ALAC)
		XCTAssertEqual(AudioCodec(rawValue: AudioCodec.Constants.Manifest_Name_MQA), AudioCodec.MQA)
		XCTAssertEqual(AudioCodec(rawValue: AudioCodec.Constants.Manifest_Name_AC4), AudioCodec.AC4)
		XCTAssertEqual(AudioCodec(rawValue: AudioCodec.Constants.Manifest_Name_EAC3), AudioCodec.EAC3)
		XCTAssertEqual(AudioCodec(rawValue: AudioCodec.Constants.Manifest_Name_MHA1), AudioCodec.MHA1)
		XCTAssertEqual(AudioCodec(rawValue: AudioCodec.Constants.Manifest_Name_MHM1), AudioCodec.MHM1)

		XCTAssertEqual(AudioCodec(rawValue: newCodec), AudioCodec.UNKNOWN(value: newCodec))
	}

	func testDisplayNames() throws {
		XCTAssertEqual(AudioCodec.AAC_LC.displayName, AudioCodec.Constants.Display_Name_AAC)
		XCTAssertEqual(AudioCodec.HE_AAC_V1.displayName, AudioCodec.Constants.Display_Name_AAC)
		XCTAssertEqual(AudioCodec.HE_AAC_V1.displayName, AudioCodec.Constants.Display_Name_AAC)
		XCTAssertEqual(AudioCodec.FLAC.displayName, AudioCodec.Constants.Display_Name_FLAC)
		XCTAssertEqual(AudioCodec.MQA.displayName, AudioCodec.Constants.Display_Name_MQA)

		XCTAssertNil(AudioCodec.ALAC.displayName)
		XCTAssertNil(AudioCodec.AC4.displayName)
		XCTAssertNil(AudioCodec.EAC3.displayName)
		XCTAssertNil(AudioCodec.MHA1.displayName)
		XCTAssertNil(AudioCodec.MHM1.displayName)
	}
}
