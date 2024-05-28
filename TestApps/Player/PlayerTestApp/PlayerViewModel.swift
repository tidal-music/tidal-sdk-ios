import Auth
import EventProducer
import Foundation
import Player

public typealias PlayerState = State

// MARK: - PlayerViewModel

final class PlayerViewModel: ObservableObject, PlayerListener {
	private let CLIENT_ID = "YOUR_CLIENT_ID"
	private let CLIENT_SECRET = "YOUR_CLIENT_SECRET"
	private let CREDENTIALS_KEY = "YOUR_CREDENTIALS_KEY"
	private let TEST_TRACK_ID = "3993178"

	@Published var playerState: PlayerState = State.IDLE
	@Published var error: CustomError?
	@Published var showAlert: Bool = false

	private var auth: TidalAuth {
		.shared
	}

	private var eventSender: TidalEventSender {
		.shared
	}

	private var player: Player?

	init() {
		initAuth()
		initEventSender()
		initPlayer()
	}

	private func initAuth() {
		let authConfig = AuthConfig(
			clientId: CLIENT_ID,
			clientSecret: CLIENT_SECRET,
			credentialsKey: CREDENTIALS_KEY
		)

		auth.config(config: authConfig)
	}
    
	private func initEventSender() {
		let config = EventConfig(
			credentialsProvider: auth,
			maxDiskUsageBytes: 1000000,
			blockedConsentCategories: []
		)
		
		eventSender.config(config)
	}

	private func initPlayer() {
		player = Player.bootstrap(
			listener: self,
			credentialsProvider: auth,
			eventSender: eventSender
		)
	}

	func play() {
		player?.load(
			MediaProduct(
				productType: ProductType.TRACK,
				productId: TEST_TRACK_ID
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
