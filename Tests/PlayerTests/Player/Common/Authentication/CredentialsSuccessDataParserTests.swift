import Auth
@testable import Player
import XCTest

// MARK: - Constants

private enum Constants {
	static let token = "token"
	static let bearerToken = "Bearer \(token)"
}

// MARK: - CredentialsSuccessDataParserTests

final class CredentialsSuccessDataParserTests: XCTestCase {
	private let credentialsSuccessDataParser = CredentialsSuccessDataParser()
}

extension CredentialsSuccessDataParserTests {
	// MARK: - clientIdFromToken

	func test_clientIdFromToken_when_JSONIsEncodedInBase64AndClientIdIsPresent() async throws {
		let token = "Bearer blabla.eyJjaWQiOjEyMzR9.blahblah"
		let clientId = credentialsSuccessDataParser.clientIdFromToken(token)
		XCTAssertEqual(clientId, 1234)
	}

	func test_clientIdFromToken_when_clientIdIsNotPresent() async throws {
		let token = "Bearer blabla.eyJpZCI6IjEyMzQiLCJhbm90aGVySWQiOjY3ODl9.yadayada"
		let clientId = credentialsSuccessDataParser.clientIdFromToken(token)
		XCTAssertEqual(clientId, nil)
	}
	
	func test_clientIdFromToken_when_StringRequiresPadding() async throws {
		let token = "Bearer blabla.eyJjaWQiOjEyMzQ1fQ.blahblah"
		let clientId = credentialsSuccessDataParser.clientIdFromToken(token)
		XCTAssertEqual(clientId, 12345)
	}

	func test_clientIdFromToken_when_StringIsNotEncodedInBase64() async throws {
		let token = "Bearer yada.abcd.yada"
		let clientId = credentialsSuccessDataParser.clientIdFromToken(token)
		XCTAssertEqual(clientId, nil)
	}
}
