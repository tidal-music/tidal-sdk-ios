import Foundation

public struct LoginConfig {
	public let locale: Locale?
	public let email: String?
	public let customParams: Set<QueryParameter>

	public init(
		locale: Locale? = Locale.current,
		email: String? = nil,
		customParams: Set<QueryParameter> = []
	) {
		self.locale = locale
		self.email = email
		self.customParams = customParams
	}
}
