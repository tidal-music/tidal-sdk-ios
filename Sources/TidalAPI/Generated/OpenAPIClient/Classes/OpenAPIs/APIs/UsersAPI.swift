import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - UsersAPI

class UsersAPI {
	/// Get the current user
	///
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// entitlements, publicProfile, recommendations (optional)
	/// - returns: UsersSingleDataDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getMyUser(include: [String]? = nil) async throws -> UsersSingleDataDocument {
		try await getMyUserWithRequestBuilder(include: include).execute().body
	}

	/// Get the current user
	/// - GET /users/me
	/// - Get the current user
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// entitlements, publicProfile, recommendations (optional)
	/// - returns: RequestBuilder<UsersSingleDataDocument>
	class func getMyUserWithRequestBuilder(include: [String]? = nil) -> RequestBuilder<UsersSingleDataDocument> {
		let localVariablePath = "/users/me"
		let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
		let localVariableParameters: [String: Any]? = nil

		var localVariableUrlComponents = URLComponents(string: localVariableURLString)
		localVariableUrlComponents?.queryItems = APIHelper.mapValuesToQueryItems([
			"include": (wrappedValue: include?.encodeToJSON(), isExplode: true),
		])

		let localVariableNillableHeaders: [String: Any?] = [
			:
		]

		let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

		let localVariableRequestBuilder: RequestBuilder<UsersSingleDataDocument>.Type = OpenAPIClientAPI.requestBuilderFactory
			.getBuilder()

		return localVariableRequestBuilder.init(
			method: "GET",
			URLString: (localVariableUrlComponents?.string ?? localVariableURLString),
			parameters: localVariableParameters,
			headers: localVariableHeaderParameters,
			requiresAuthentication: true
		)
	}

	/// Get a single user by id
	///
	/// - parameter id: (path) User Id
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// entitlements, publicProfile, recommendations (optional)
	/// - returns: UsersSingleDataDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getUserById(id: String, include: [String]? = nil) async throws -> UsersSingleDataDocument {
		try await getUserByIdWithRequestBuilder(id: id, include: include).execute().body
	}

	/// Get a single user by id
	/// - GET /users/{id}
	/// - Get a single user by id
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter id: (path) User Id
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// entitlements, publicProfile, recommendations (optional)
	/// - returns: RequestBuilder<UsersSingleDataDocument>
	class func getUserByIdWithRequestBuilder(id: String, include: [String]? = nil) -> RequestBuilder<UsersSingleDataDocument> {
		var localVariablePath = "/users/{id}"
		let idPreEscape = "\(APIHelper.mapValueToPathItem(id))"
		let idPostEscape = idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
		localVariablePath = localVariablePath.replacingOccurrences(of: "{id}", with: idPostEscape, options: .literal, range: nil)
		let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
		let localVariableParameters: [String: Any]? = nil

		var localVariableUrlComponents = URLComponents(string: localVariableURLString)
		localVariableUrlComponents?.queryItems = APIHelper.mapValuesToQueryItems([
			"include": (wrappedValue: include?.encodeToJSON(), isExplode: true),
		])

		let localVariableNillableHeaders: [String: Any?] = [
			:
		]

		let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

		let localVariableRequestBuilder: RequestBuilder<UsersSingleDataDocument>.Type = OpenAPIClientAPI.requestBuilderFactory
			.getBuilder()

		return localVariableRequestBuilder.init(
			method: "GET",
			URLString: (localVariableUrlComponents?.string ?? localVariableURLString),
			parameters: localVariableParameters,
			headers: localVariableHeaderParameters,
			requiresAuthentication: true
		)
	}

	/// Relationship: entitlements
	///
	/// - parameter id: (path) User Id
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// entitlements (optional)
	/// - returns: UsersSingletonDataRelationshipDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getUserEntitlementsRelationship(
		id: String,
		include: [String]? = nil
	) async throws -> UsersSingletonDataRelationshipDocument {
		try await getUserEntitlementsRelationshipWithRequestBuilder(id: id, include: include).execute().body
	}

	/// Relationship: entitlements
	/// - GET /users/{id}/relationships/entitlements
	/// - Get user entitlements relationship
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter id: (path) User Id
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// entitlements (optional)
	/// - returns: RequestBuilder<UsersSingletonDataRelationshipDocument>
	class func getUserEntitlementsRelationshipWithRequestBuilder(
		id: String,
		include: [String]? = nil
	) -> RequestBuilder<UsersSingletonDataRelationshipDocument> {
		var localVariablePath = "/users/{id}/relationships/entitlements"
		let idPreEscape = "\(APIHelper.mapValueToPathItem(id))"
		let idPostEscape = idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
		localVariablePath = localVariablePath.replacingOccurrences(of: "{id}", with: idPostEscape, options: .literal, range: nil)
		let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
		let localVariableParameters: [String: Any]? = nil

		var localVariableUrlComponents = URLComponents(string: localVariableURLString)
		localVariableUrlComponents?.queryItems = APIHelper.mapValuesToQueryItems([
			"include": (wrappedValue: include?.encodeToJSON(), isExplode: true),
		])

		let localVariableNillableHeaders: [String: Any?] = [
			:
		]

		let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

		let localVariableRequestBuilder: RequestBuilder<UsersSingletonDataRelationshipDocument>.Type = OpenAPIClientAPI
			.requestBuilderFactory.getBuilder()

		return localVariableRequestBuilder.init(
			method: "GET",
			URLString: (localVariableUrlComponents?.string ?? localVariableURLString),
			parameters: localVariableParameters,
			headers: localVariableHeaderParameters,
			requiresAuthentication: true
		)
	}

	/// Relationship: public profile
	///
	/// - parameter id: (path) User Id
	/// - parameter locale: (query) Locale language tag (IETF BCP 47 Language Tag)
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// publicProfile (optional)
	/// - returns: UsersSingletonDataRelationshipDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getUserPublicProfileRelationship(
		id: String,
		locale: String,
		include: [String]? = nil
	) async throws -> UsersSingletonDataRelationshipDocument {
		try await getUserPublicProfileRelationshipWithRequestBuilder(id: id, locale: locale, include: include).execute().body
	}

	/// Relationship: public profile
	/// - GET /users/{id}/relationships/publicProfile
	/// - Get user public profile
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter id: (path) User Id
	/// - parameter locale: (query) Locale language tag (IETF BCP 47 Language Tag)
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// publicProfile (optional)
	/// - returns: RequestBuilder<UsersSingletonDataRelationshipDocument>
	class func getUserPublicProfileRelationshipWithRequestBuilder(
		id: String,
		locale: String,
		include: [String]? = nil
	) -> RequestBuilder<UsersSingletonDataRelationshipDocument> {
		var localVariablePath = "/users/{id}/relationships/publicProfile"
		let idPreEscape = "\(APIHelper.mapValueToPathItem(id))"
		let idPostEscape = idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
		localVariablePath = localVariablePath.replacingOccurrences(of: "{id}", with: idPostEscape, options: .literal, range: nil)
		let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
		let localVariableParameters: [String: Any]? = nil

		var localVariableUrlComponents = URLComponents(string: localVariableURLString)
		localVariableUrlComponents?.queryItems = APIHelper.mapValuesToQueryItems([
			"locale": (wrappedValue: locale.encodeToJSON(), isExplode: true),
			"include": (wrappedValue: include?.encodeToJSON(), isExplode: true),
		])

		let localVariableNillableHeaders: [String: Any?] = [
			:
		]

		let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

		let localVariableRequestBuilder: RequestBuilder<UsersSingletonDataRelationshipDocument>.Type = OpenAPIClientAPI
			.requestBuilderFactory.getBuilder()

		return localVariableRequestBuilder.init(
			method: "GET",
			URLString: (localVariableUrlComponents?.string ?? localVariableURLString),
			parameters: localVariableParameters,
			headers: localVariableHeaderParameters,
			requiresAuthentication: true
		)
	}

	/// Relationship: user recommendations
	///
	/// - parameter id: (path) User Id
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// recommendations (optional)
	/// - returns: UsersSingletonDataRelationshipDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getUserRecommendationsRelationship(
		id: String,
		include: [String]? = nil
	) async throws -> UsersSingletonDataRelationshipDocument {
		try await getUserRecommendationsRelationshipWithRequestBuilder(id: id, include: include).execute().body
	}

	/// Relationship: user recommendations
	/// - GET /users/{id}/relationships/recommendations
	/// - Get user recommendations
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter id: (path) User Id
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// recommendations (optional)
	/// - returns: RequestBuilder<UsersSingletonDataRelationshipDocument>
	class func getUserRecommendationsRelationshipWithRequestBuilder(
		id: String,
		include: [String]? = nil
	) -> RequestBuilder<UsersSingletonDataRelationshipDocument> {
		var localVariablePath = "/users/{id}/relationships/recommendations"
		let idPreEscape = "\(APIHelper.mapValueToPathItem(id))"
		let idPostEscape = idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
		localVariablePath = localVariablePath.replacingOccurrences(of: "{id}", with: idPostEscape, options: .literal, range: nil)
		let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
		let localVariableParameters: [String: Any]? = nil

		var localVariableUrlComponents = URLComponents(string: localVariableURLString)
		localVariableUrlComponents?.queryItems = APIHelper.mapValuesToQueryItems([
			"include": (wrappedValue: include?.encodeToJSON(), isExplode: true),
		])

		let localVariableNillableHeaders: [String: Any?] = [
			:
		]

		let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

		let localVariableRequestBuilder: RequestBuilder<UsersSingletonDataRelationshipDocument>.Type = OpenAPIClientAPI
			.requestBuilderFactory.getBuilder()

		return localVariableRequestBuilder.init(
			method: "GET",
			URLString: (localVariableUrlComponents?.string ?? localVariableURLString),
			parameters: localVariableParameters,
			headers: localVariableHeaderParameters,
			requiresAuthentication: true
		)
	}

	/// Get multiple users by id
	///
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// entitlements, publicProfile, recommendations (optional)
	/// - parameter filterId: (query) Allows to filter the collection of resources based on id attribute value (optional)
	/// - returns: UsersMultiDataDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getUsersByFilters(include: [String]? = nil, filterId: [String]? = nil) async throws -> UsersMultiDataDocument {
		try await getUsersByFiltersWithRequestBuilder(include: include, filterId: filterId).execute().body
	}

	/// Get multiple users by id
	/// - GET /users
	/// - Get multiple users by id
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// entitlements, publicProfile, recommendations (optional)
	/// - parameter filterId: (query) Allows to filter the collection of resources based on id attribute value (optional)
	/// - returns: RequestBuilder<UsersMultiDataDocument>
	class func getUsersByFiltersWithRequestBuilder(
		include: [String]? = nil,
		filterId: [String]? = nil
	) -> RequestBuilder<UsersMultiDataDocument> {
		let localVariablePath = "/users"
		let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
		let localVariableParameters: [String: Any]? = nil

		var localVariableUrlComponents = URLComponents(string: localVariableURLString)
		localVariableUrlComponents?.queryItems = APIHelper.mapValuesToQueryItems([
			"include": (wrappedValue: include?.encodeToJSON(), isExplode: true),
			"filter[id]": (wrappedValue: filterId?.encodeToJSON(), isExplode: true),
		])

		let localVariableNillableHeaders: [String: Any?] = [
			:
		]

		let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

		let localVariableRequestBuilder: RequestBuilder<UsersMultiDataDocument>.Type = OpenAPIClientAPI.requestBuilderFactory
			.getBuilder()

		return localVariableRequestBuilder.init(
			method: "GET",
			URLString: (localVariableUrlComponents?.string ?? localVariableURLString),
			parameters: localVariableParameters,
			headers: localVariableHeaderParameters,
			requiresAuthentication: true
		)
	}
}
