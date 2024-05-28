import Foundation

extension UserDefaultsClient {
	static func live(userDefaults: UserDefaults = UserDefaults.standard) -> Self {
		Self(
			dataForKey: userDefaults.data(forKey:),
			setDataForKey: { userDefaults.set($0, forKey: $1) },
			removeObjectForKey: userDefaults.removeObject(forKey:)
		)
	}
}
