import Foundation

public extension [String: String] {
	var jsonEncoded: String? {
		guard let data = try? JSONEncoder().encode(self) else {
			return nil
		}
		return String(data: data, encoding: .utf8)
	}
}
