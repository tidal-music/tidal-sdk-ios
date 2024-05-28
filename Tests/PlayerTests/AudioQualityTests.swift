import Foundation
@testable import Player
import XCTest

final class AudioQualityTests: XCTestCase {
	// swiftlint:disable line_length
	let validQualityPlaybackInfoJSON = """
	    {
	      "trackId": 22769520,
	      "assetPresentation": "FULL",
	      "audioMode": "STEREO",
	      "audioQuality": "HI_RES",
	      "manifestMimeType": "application/vnd.tidal.bts",
	      "manifestHash": "WTQxL3VN60OD2H7WGDHq6mXGh2JMmBQemxd5w4XSRys=",
	      "manifest": "eyJtaW1lVHlwZSI6ImF1ZGlvL2ZsYWMiLCJjb2RlY3MiOiJtcWEiLCJlbmNyeXB0aW9uVHlwZSI6Ik5PTkUiLCJ1cmxzIjpbImh0dHBzOi8vc3AtcHItZmEuYXVkaW8udGlkYWwuY29tL21lZGlhdHJhY2tzL0NBRWFLUkluTm1WallXVmpOalV3T0daaU1qRTVPREl3TVRjNE9Ua3pNakF5TWpWaE9ERmZOakF1YlhBMC8wLmZsYWM/dG9rZW49MTY4NDIzOTgxN35aRGt3TlRoalpXRTNZakptT0Rnek9UY3pZMkl3TldSbU1qWTBNekkxTkdRMlpEQTJPREk0Tnc9PSJdfQ==",
	      "albumReplayGain": -10.43,
	      "albumPeakAmplitude": 1,
	      "trackReplayGain": -9.76,
	      "trackPeakAmplitude": 1
	    }
	"""
	// swiftlint:enable line_length

	let invalidQualityPlaybackInfoJSON = """
	    {
	      "trackId": 280609995,
	      "assetPresentation": "FULL",
	      "audioMode": "STEREO",
	      "audioQuality": "NEW_UNSUPPORTED_FORMAT",
	      "licenseSecurityToken": "ver~1.hmac~qE_D1bDaulxWJ5_zt5JFPlafaWWlU3TQ8_ga_7cO1eo=.exp~1684239998675.kids~VbMw_kNnmQysd05rcG681g==",
	      "manifestMimeType": "application/vnd.apple.mpegurl",
	      "manifestHash": "ynttxcsG8j8cO2tWVvypIz38B+3ti9sKzfQvKXZiqV8=",
	      "manifest": "I0VYVE0zVdsafasdf234",
	      "albumReplayGain": -7.34,
	      "albumPeakAmplitude": 0.988446,
	      "trackReplayGain": -7.34,
	      "trackPeakAmplitude": 0.988446
	    }
	"""

	func testValidAudioQualities() {
		let lowAudioQuality = AudioQuality(rawValue: "LOW")
		XCTAssertNotNil(lowAudioQuality)

		let highAudioQuality = AudioQuality(rawValue: "HIGH")
		XCTAssertNotNil(highAudioQuality)

		let losslessAudioQuality = AudioQuality(rawValue: "LOSSLESS")
		XCTAssertNotNil(losslessAudioQuality)

		let hiResAudioQuality = AudioQuality(rawValue: "HI_RES")
		XCTAssertNotNil(hiResAudioQuality)

		let hiResLosslesslessAudioQuality = AudioQuality(rawValue: "HI_RES_LOSSLESS")
		XCTAssertNotNil(hiResLosslesslessAudioQuality)
	}

	func testInvalidAudioQualities() {
		let invalidAudioQuality = AudioQuality(rawValue: "UNKNOWN_QUALITY")
		XCTAssertNil(invalidAudioQuality)
	}

	func testJSONDecodingAudioQuality() throws {
		let validPlaybackInfo: TrackPlaybackInfo = try JSONDecoder().decode(
			TrackPlaybackInfo.self,
			from: validQualityPlaybackInfoJSON.data(using: .utf8)!
		)
		XCTAssertEqual(validPlaybackInfo.audioQuality, .HI_RES)

		let invalidPlaybackInfo: TrackPlaybackInfo? = try? JSONDecoder().decode(
			TrackPlaybackInfo.self,
			from: invalidQualityPlaybackInfoJSON.data(using: .utf8)!
		)
		XCTAssertNil(invalidPlaybackInfo)
	}

	func testBitRates() {
		XCTAssertEqual(AudioQuality.LOW.toBitRate(), AudioQuality.Constants.Low_BitRate)
		XCTAssertEqual(AudioQuality.HIGH.toBitRate(), AudioQuality.Constants.High_BitRate)
		XCTAssertNil(AudioQuality.LOSSLESS.toBitRate())
		XCTAssertNil(AudioQuality.HI_RES.toBitRate())
		XCTAssertNil(AudioQuality.HI_RES_LOSSLESS.toBitRate())
	}
}
