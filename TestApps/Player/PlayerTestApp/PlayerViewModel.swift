import Auth
import Common
import EventProducer
import Foundation
import Player

public typealias PlayerState = State

// MARK: - PlayerViewModel

final class PlayerViewModel: ObservableObject, PlayerListener {
	private let CLIENT_ID = "YOUR_CLIENT_ID"
	private let CLIENT_SECRET = "YOUR_CLIENT_SECRET"
	private let TEST_TRACK_ID = "3993178"

	@Published var playerState: PlayerState = State.IDLE
	@Published var error: CustomError?
	@Published var showAlert: Bool = false

	private var auth: TidalAuth {
		.shared
	}

	private var eventSender: EventSenderClient {
		.shared
	}

	private var player: Player?

	init() {
		initAuth()
		initPlayer()
	}

	private func initAuth() {
		let authConfig = AuthConfig(
			clientId: CLIENT_ID,
			clientSecret: CLIENT_SECRET,
			credentialsKey: "storage",
			scopes: Scopes(),
			enableCertificatePinning: false
		)

		auth.config(config: authConfig)
	}

	private func initPlayer() {
		player = Player.bootstrap(
			accessTokenProvider: AccessTokenProviderMock(),
			clientToken: CLIENT_ID,
			listener: self,
			credentialsProvider: auth,
			eventSender: eventSender
		)
	}

	func play() {
		player?.load(
			MediaProduct(
				productType: ProductType.TRACK,
				productId: TEST_TRACK_ID,
				progressSource: nil,
				playLogSource: nil
			)
		)
		player?.play()
	}

	func stateChanged(to state: State) {
		playerState = state
	}

	func ended(_ mediaProduct: MediaProduct) {}

	func mediaTransitioned(to mediaProduct: MediaProduct, with playbackContext: PlaybackContext) {}

	func failed(with error: PlayerError) {
		self.error = CustomError.playerError(code: error.errorCode)
		showAlert = true
	}
}

// MARK: - CustomError

enum CustomError: LocalizedError {
	case authError
	case playerError(code: String)

	var errorDescription: String? {
		switch self {
		case .authError:
			"Auth Error"
		case let .playerError(code):
			"Player Error Code \(code)"
		}
	}
}

// MARK: - AccessTokenProviderMock

/// To be Removed
class AccessTokenProviderMock: AccessTokenProvider {
	var accessToken: String? {
		""
	}

	func renewAccessToken(status: Int?) async throws {}
}
