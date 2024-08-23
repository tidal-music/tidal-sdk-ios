import Foundation
import protocol Auth.CredentialsProvider

public struct EventConfig: EventProducer {	
	static let defaultQueueMaxDiskUsageBytes = 204800
	static let singleEventMaxDiskUsageBytes = 20480
	
	/// An access token provider, used by the EventProducer to get access token.
	public var credentialsProvider: CredentialsProvider
	/// The maximum amount of disk the EventProducer is allowed to use for temporarily storing events before they are sent to TL Consumer. (defaults to 20kb)
	public var maxDiskUsageBytes: Int
	/// Categories blocked by the user.
	public var blockedConsentCategories: Set<ConsentCategory>?
	/// consumerUri: URI identifying the TL Consumer ingest endpoint.
	public var consumerUri: String?
		
	public init(
		credentialsProvider: Auth.CredentialsProvider,
		maxDiskUsageBytes: Int,
		blockedConsentCategories: Set<ConsentCategory>? = nil,
		consumerUri: String? = "https://event-collector.obelix-staging-use1.tidalhi.fi"
	) {
		self.credentialsProvider = credentialsProvider
		self.maxDiskUsageBytes = maxDiskUsageBytes
		self.blockedConsentCategories = blockedConsentCategories
		if let consumerUri {
			self.consumerUri = consumerUri
		}
	}
}
