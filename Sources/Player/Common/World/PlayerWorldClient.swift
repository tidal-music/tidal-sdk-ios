import Foundation

// MARK: - PlayerWorldClient

/// Struct intended to hold only simple dependencies so we can enable testability where they are used. For more complex
/// dependencies (such as services), use another approach.
/// Based on https://vimeo.com/291588126
struct PlayerWorldClient {
	var audioInfoProvider: AudioInfoProvider
	var deviceInfoProvider: DeviceInfoProvider
	var timeProvider: TimeProvider
	var uuidProvider: UUIDProvider
	var developmentFeatureFlagProvider: DevelopmentFeatureFlagProvider
	var fileManagerClient: FileManagerClient
	var asyncSchedulerFactoryProvider: AsyncSchedulerFactoryProvider
	var logger: TidalLogger?

	/// Whether the code is running on a simulator. Used to skip DRM license loading
	/// since AVContentKeySession doesn't support FairPlay on simulator.
	var isSimulator: Bool
}

extension PlayerWorldClient {
	static let live: PlayerWorldClient = {
		var client = PlayerWorldClient(
			audioInfoProvider: .live,
			deviceInfoProvider: .live,
			timeProvider: .live,
			uuidProvider: .live,
			developmentFeatureFlagProvider: .live,
			fileManagerClient: .live,
			asyncSchedulerFactoryProvider: .live,
			logger: nil,
			isSimulator: false
		)
		#if targetEnvironment(simulator)
		client.isSimulator = true
		#endif
		return client
	}()
}
