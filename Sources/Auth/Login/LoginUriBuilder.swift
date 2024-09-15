import Foundation

// MARK: - LoginUriBuilder

struct LoginUriBuilder {
	enum QueryKeys {
		static let CLIENT_ID_KEY = "client_id"
		static let CLIENT_UNIQUE_KEY = "client_unique_key"
		static let CODE_CHALLENGE_KEY = "code_challenge"
		static let CODE_CHALLENGE_METHOD_KEY = "code_challenge_method"
		static let RESPONSE_TYPE = "response_type"
		static let LANGUAGE_KEY = "lang"
		static let EMAIL_KEY = "email"
		static let REDIRECT_URI_KEY = "redirect_uri"
		static let SCOPES_KEY = "scope"
	}

	private let AUTH_PATH = "/authorize"
	private let CODE_CHALLENGE_METHOD = "S256"
	private let loginBaseUrl: String
	private let clientId: String
	private let clientUniqueKey: String?
	private let scopes: Set<String>

	init(
		clientId: String,
		clientUniqueKey: String?,
		loginBaseUrl: String,
		scopes: Set<String>
	) {
		self.clientId = clientId
		self.clientUniqueKey = clientUniqueKey
		self.loginBaseUrl = loginBaseUrl
		self.scopes = scopes
	}

	func getLoginUri(redirectUri: String, loginConfig: LoginConfig?, codeChallenge: String) -> String? {
		var builder = URLComponents(string: loginBaseUrl)
		builder?.path = AUTH_PATH
		builder?.percentEncodedQueryItems = [
			URLQueryItem(name: QueryKeys.REDIRECT_URI_KEY, value: redirectUri.urlEncoded),
			URLQueryItem(name: QueryKeys.RESPONSE_TYPE, value: "code"),
			URLQueryItem(name: QueryKeys.SCOPES_KEY, value: scopes.toScopesString().urlEncoded),
		]

		for param in buildBaseParameters(clientId: clientId, clientUniqueKey: clientUniqueKey, codeChallenge: codeChallenge) {
			builder?.percentEncodedQueryItems?.append(URLQueryItem(name: param.key, value: param.value))
		}

		evaluateLoginConfig(builder: &builder, config: loginConfig)
		return builder?.url?.absoluteString
	}

	private func evaluateLoginConfig(builder: inout URLComponents?, config: LoginConfig?) {
		if let locale = config?.locale {
			builder?.queryItems?.append(URLQueryItem(name: QueryKeys.LANGUAGE_KEY, value: locale.identifier))
		}

		if let email = config?.email {
			builder?.queryItems?.append(URLQueryItem(name: QueryKeys.EMAIL_KEY, value: email))
		}

		config?.customParams.forEach { param in
			builder?.queryItems?.append(URLQueryItem(name: param.key, value: param.value))
		}
	}

	private func buildBaseParameters(clientId: String, clientUniqueKey: String?, codeChallenge: String) -> Set<QueryParameter> {
		var baseParameters = Set([
			QueryParameter(key: QueryKeys.CLIENT_ID_KEY, value: clientId),
			QueryParameter(key: QueryKeys.CODE_CHALLENGE_METHOD_KEY, value: CODE_CHALLENGE_METHOD),
			QueryParameter(key: QueryKeys.CODE_CHALLENGE_KEY, value: codeChallenge),
		])
		if let clientUniqueKey {
			baseParameters.insert(QueryParameter(key: QueryKeys.CLIENT_UNIQUE_KEY, value: clientUniqueKey))
		}

		return baseParameters
	}
}

extension String {
	var urlEncoded: String? {
		addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
	}
}
