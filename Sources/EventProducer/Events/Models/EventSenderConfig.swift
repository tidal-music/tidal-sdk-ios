import Foundation

public struct EventSenderConfig {
	/// consumerUri: URI identifying the TL Consumer ingest endpoint.
	public var consumerUri: String?
	/// An access token provider, used by the EventProducer to get access token.
	public var authProvider: AuthProvider
	/// The maximum amount of disk the EventProducer is allowed to use for temporarily storing events before they are sent to TL
	/// Consumer. (defaults to 20kb)
	public var maxDiskUsageBytes: Int
	/// Categories blocked by the user.
	public var blockedConsentCategories: Set<ConsentCategory>?

	public init(
		consumerUri: String? = nil,
		authProvider: AuthProvider,
		maxDiskUsageBytes: Int,
		blockedConsentCategories: Set<ConsentCategory>? = nil
	) {
		self.consumerUri = consumerUri
		self.authProvider = authProvider
		self.maxDiskUsageBytes = maxDiskUsageBytes
		self.blockedConsentCategories = blockedConsentCategories
	}
}
