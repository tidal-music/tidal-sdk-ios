@testable import Auth
import KeychainAccess
import XCTest

final class RedirectUriTest: XCTestCase {
	func testCreatingWithNoCode() {
		// given
		let wrongUri = "https://tidal.com/ios/login/auth?state=na&appMode=ios&lang=en"

		// when
		let redirectUri = RedirectUri.fromUriString(uri: wrongUri)

		// then
		switch redirectUri {
		case .success:
			XCTFail("Creating a RedirectUri from a string missing a 'code' parameter should result in a RedirectUri.Failure type")
		case let .failure(errorMessage):
			XCTAssertEqual(
				errorMessage,
				"",
				"Creating a RedirectUri from a string missing a 'code' parameter should result in a RedirectUri.Failure type"
			)
		}
	}

	func testCreatingWithError() {
		// given
		let wrongUri =
			"https://tidal.com/ios/login/auth?error=someMadeUpError?error_description=helloWorld&lang=en"

		// when
		let redirectUri = RedirectUri.fromUriString(uri: wrongUri)

		// then
		switch redirectUri {
		case .success:
			XCTFail("Creating a RedirectUri from a string with an error parameter should result in a RedirectUri.Failure type")
		case let .failure(errorMessage):
			XCTAssertEqual(
				errorMessage,
				"helloWorld",
				"A RedirectUri created from a string with an error parameter should have its 'errorMessage' field set correctly"
			)
		}
	}

	func testCreatingSatisfyingRequirements() {
		// given
		let correctUris = [
			"https://tidal.com/ios/login/auth",
			"customUriScheme://ios/login/auth",
		]

		correctUris.forEach { correctUri in
			let inputCode = "HERE_BE_CODE"

			let correctUriWithQuery = "\(correctUri)?state=na&appMode=ios&lang=en&code=\(inputCode)"

			// when
			let redirectUri = RedirectUri.fromUriString(uri: correctUriWithQuery)

			// then
			switch redirectUri {
			case let .success(url, code):
				XCTAssertEqual(
					code,
					inputCode,
					"Creating a RedirectUri from a correct uri string should result in a RedirectUri.Success type"
				)

				XCTAssertEqual(url, correctUri, "A RedirectUri.Success should have the right url set")
			case .failure:
				XCTFail("Creating a RedirectUri from a correct uri string should result in a RedirectUri.Success type")
			}
		}
	}
}
