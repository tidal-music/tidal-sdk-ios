@testable import Player

extension PlayerWorldClient {
	static let mock: Self = PlayerWorldClient(
		audioInfoProvider: .mock,
		deviceInfoProvider: .mock,
		timeProvider: .mock,
		uuidProvider: .mock,
		developmentFeatureFlagProvider: .mock,
		fileManagerClient: .mock,
		asyncSchedulerFactoryProvider: .spy
	)

	static func mock(
		audioInfoProvider: AudioInfoProvider = .mock,
		deviceInfoProvider: DeviceInfoProvider = .mock,
		timeProvider: TimeProvider = .mock,
		uuidProvider: UUIDProvider = .mock,
		developmentFeatureFlagProvider: DevelopmentFeatureFlagProvider = .mock,
		fileManagerClient: FileManagerClient = .mock,
		asyncSchedulerFactoryProvider: AsyncSchedulerFactoryProvider = .spy
	) -> Self {
		PlayerWorldClient(
			audioInfoProvider: audioInfoProvider,
			deviceInfoProvider: deviceInfoProvider,
			timeProvider: timeProvider,
			uuidProvider: uuidProvider,
			developmentFeatureFlagProvider: developmentFeatureFlagProvider,
			fileManagerClient: fileManagerClient,
			asyncSchedulerFactoryProvider: asyncSchedulerFactoryProvider
		)
	}
}
