import Foundation
@testable import Player
import Testing

// MARK: - Constants

private enum Constants {
	static let trackId = "12345"
	static let sourceFileId = UUID(uuidString: "A0EEBC99-9C0B-4EF8-BB6D-6BB9BD380A11")!
	static let otherSourceFileId = UUID(uuidString: "B1FFCD00-0D1C-4F09-8C7E-7CCACE491B22")!
}

// MARK: - TrackSourceFileMediaProductTests

struct TrackSourceFileMediaProductTests {
	@Test
	func test_init_isTrackSourceFileTypeWithTrackIdAsProductId() {
		let product = TrackSourceFileMediaProduct(sourceFileId: Constants.sourceFileId, trackId: Constants.trackId)

		#expect(product.productType == .TRACK_SOURCE_FILE)
		#expect(product.productType.rawValue == "TRACK_SOURCE_FILE")
		#expect(product.productId == Constants.trackId)
		#expect(product.trackId == Constants.trackId)
		#expect(product.sourceFileId == Constants.sourceFileId)
	}

	@Test
	func test_sourceFileIdentifier_isLowercaseCanonicalUUID() {
		let product = TrackSourceFileMediaProduct(sourceFileId: Constants.sourceFileId, trackId: Constants.trackId)

		#expect(product.sourceFileIdentifier == "a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11")
		#expect(MediaProduct.mock(productId: Constants.trackId).sourceFileIdentifier == nil)
	}

	// MARK: - Equality

	@Test
	func test_equality_sameSourceFileOfSameTrack_isEqual() {
		let lhs = TrackSourceFileMediaProduct(sourceFileId: Constants.sourceFileId, trackId: Constants.trackId)
		let rhs = TrackSourceFileMediaProduct(sourceFileId: Constants.sourceFileId, trackId: Constants.trackId)

		#expect(lhs == rhs)
	}

	@Test
	func test_equality_differentSourceFilesOfSameTrack_areNotEqual() {
		let lhs = TrackSourceFileMediaProduct(sourceFileId: Constants.sourceFileId, trackId: Constants.trackId)
		let rhs = TrackSourceFileMediaProduct(sourceFileId: Constants.otherSourceFileId, trackId: Constants.trackId)

		#expect(lhs != rhs)
	}

	@Test
	func test_equality_sourceFileAndItsTrack_areNotEqual() {
		let sourceFile = TrackSourceFileMediaProduct(sourceFileId: Constants.sourceFileId, trackId: Constants.trackId)
		let track = MediaProduct.mock(productType: .TRACK, productId: Constants.trackId)
		let baseWithSourceFileType = MediaProduct.mock(productType: .TRACK_SOURCE_FILE, productId: Constants.trackId)

		#expect(sourceFile != track)
		#expect(track != sourceFile)
		#expect(sourceFile != baseWithSourceFileType)
	}

	// MARK: - Codable

	@Test
	func test_codable_roundTrip() throws {
		let product = TrackSourceFileMediaProduct(
			sourceFileId: Constants.sourceFileId,
			trackId: Constants.trackId,
			referenceId: "referenceId",
			progressSource: nil,
			playLogSource: nil,
			extras: nil
		)

		let data = try JSONEncoder().encode(product)
		let decoded = try JSONDecoder().decode(TrackSourceFileMediaProduct.self, from: data)

		#expect(decoded == product)
		#expect(decoded.sourceFileId == Constants.sourceFileId)
		#expect(decoded.productType == .TRACK_SOURCE_FILE)
	}
}
