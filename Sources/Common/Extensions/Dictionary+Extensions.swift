import Foundation

extension [String: String] {
	public var jsonEncoded: String? {
		guard let data = try? JSONEncoder().encode(self) else {
			return nil
		}
		return String(data: data, encoding: .utf8)
	}
}
