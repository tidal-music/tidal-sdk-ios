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
	var logger: () -> TidalLogger?
}

extension PlayerWorldClient {
	static func live() -> PlayerWorldClient {
		PlayerWorldClient(
			audioInfoProvider: .live,
			deviceInfoProvider: .live,
			timeProvider: .live,
			uuidProvider: .live,
			developmentFeatureFlagProvider: .live,
			fileManagerClient: .live,
			asyncSchedulerFactoryProvider: .live,
			logger: TidalLogger.noop
		)
	}
}
