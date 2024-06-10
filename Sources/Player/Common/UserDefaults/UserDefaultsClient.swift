import Foundation

/// A client to interact with UserDefaults
public struct UserDefaultsClient {
	var dataForKey: (String) -> Data?
	var setDataForKey: (Data?, String) -> Void
	var removeObjectForKey: (String) -> Void
}
