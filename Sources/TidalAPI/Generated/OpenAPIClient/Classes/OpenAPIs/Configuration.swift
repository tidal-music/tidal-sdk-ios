import Foundation
#if canImport(FoundationNetworking)
	import FoundationNetworking
#endif

// MARK: - Configuration

open class Configuration {
	/// Configures the range of HTTP status codes that will result in a successful response
	///
	/// If a HTTP status code is outside of this range the response will be interpreted as failed.
	public static var successfulStatusCodeRange: Range = 200 ..< 300
}
