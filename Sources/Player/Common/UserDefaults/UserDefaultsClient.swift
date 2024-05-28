import Foundation

/// A client to interact with UserDefaults
struct UserDefaultsClient {
	var dataForKey: (String) -> Data?
	var setDataForKey: (Data?, String) -> Void
	var removeObjectForKey: (String) -> Void
}
