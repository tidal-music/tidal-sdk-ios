import protocol Auth.CredentialsProvider

public protocol EventProducer {
	/// An access token provider, used by the EventProducer to get access token.
	var credentialsProvider: Auth.CredentialsProvider { get set }
	/// The maximum amount of disk the EventProducer is allowed to use for temporarily storing events before they are sent to TL
	/// Consumer. (defaults to 20kb)
	var maxDiskUsageBytes: Int { get set }
	/// Categories blocked by the user.
	var blockedConsentCategories: Set<ConsentCategory>? { get set }
	/// consumerUri: URI identifying the TL Consumer ingest endpoint.
	var consumerUri: String? { get set }
	/// Closure to react to errors. For example, you can use this to log errors.
	var errorHandling: ((EventProducerError) -> Void)? { get set }
	
	init(
		credentialsProvider: Auth.CredentialsProvider,
		maxDiskUsageBytes: Int,
		blockedConsentCategories: Set<ConsentCategory>?,
		consumerUri: String?,
		errorHandling: ((EventProducerError) -> Void)?
	)
}
