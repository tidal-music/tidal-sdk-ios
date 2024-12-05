import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - UserPublicProfilePicksAPI

class UserPublicProfilePicksAPI {
	/// Get my picks
	///
	/// - parameter locale: (query) Locale language tag (IETF BCP 47 Language Tag)
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// item, userPublicProfile (optional)
	/// - returns: UserPublicProfilePicksMultiDataDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getMyUserPublicProfilePicks(
		locale: String,
		include: [String]? = nil
	) async throws -> UserPublicProfilePicksMultiDataDocument {
		try await getMyUserPublicProfilePicksWithRequestBuilder(locale: locale, include: include).execute().body
	}

	/// Get my picks
	/// - GET /userPublicProfilePicks/me
	/// - Retrieves picks for the logged-in user.
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - OAuth:
	///  - type: oauth2
	///  - name: Client_Credentials
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter locale: (query) Locale language tag (IETF BCP 47 Language Tag)
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// item, userPublicProfile (optional)
	/// - returns: RequestBuilder<UserPublicProfilePicksMultiDataDocument>
	class func getMyUserPublicProfilePicksWithRequestBuilder(
		locale: String,
		include: [String]? = nil
	) -> RequestBuilder<UserPublicProfilePicksMultiDataDocument> {
		let localVariablePath = "/userPublicProfilePicks/me"
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

		let localVariableRequestBuilder: RequestBuilder<UserPublicProfilePicksMultiDataDocument>.Type = OpenAPIClientAPI
			.requestBuilderFactory.getBuilder()

		return localVariableRequestBuilder.init(
			method: "GET",
			URLString: (localVariableUrlComponents?.string ?? localVariableURLString),
			parameters: localVariableParameters,
			headers: localVariableHeaderParameters,
			requiresAuthentication: true
		)
	}

	/// Relationship: item (read)
	///
	/// - parameter id: (path) TIDAL pick id
	/// - parameter locale: (query) Locale language tag (IETF BCP 47 Language Tag)
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// item (optional)
	/// - returns: UserPublicProfilePicksSingletonDataRelationshipDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getUserPublicProfilePickItemRelationship(
		id: String,
		locale: String,
		include: [String]? = nil
	) async throws -> UserPublicProfilePicksSingletonDataRelationshipDocument {
		try await getUserPublicProfilePickItemRelationshipWithRequestBuilder(id: id, locale: locale, include: include).execute()
			.body
	}

	/// Relationship: item (read)
	/// - GET /userPublicProfilePicks/{id}/relationships/item
	/// - Retrieves a picks item relationship
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - OAuth:
	///  - type: oauth2
	///  - name: Client_Credentials
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter id: (path) TIDAL pick id
	/// - parameter locale: (query) Locale language tag (IETF BCP 47 Language Tag)
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// item (optional)
	/// - returns: RequestBuilder<UserPublicProfilePicksSingletonDataRelationshipDocument>
	class func getUserPublicProfilePickItemRelationshipWithRequestBuilder(
		id: String,
		locale: String,
		include: [String]? = nil
	) -> RequestBuilder<UserPublicProfilePicksSingletonDataRelationshipDocument> {
		var localVariablePath = "/userPublicProfilePicks/{id}/relationships/item"
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

		let localVariableRequestBuilder: RequestBuilder<UserPublicProfilePicksSingletonDataRelationshipDocument>
			.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

		return localVariableRequestBuilder.init(
			method: "GET",
			URLString: (localVariableUrlComponents?.string ?? localVariableURLString),
			parameters: localVariableParameters,
			headers: localVariableHeaderParameters,
			requiresAuthentication: true
		)
	}

	/// Relationship: user public profile
	///
	/// - parameter id: (path) TIDAL pick id
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// userPublicProfile (optional)
	/// - returns: UserPublicProfilePicksSingletonDataRelationshipDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getUserPublicProfilePickUserPublicProfileRelationship(
		id: String,
		include: [String]? = nil
	) async throws -> UserPublicProfilePicksSingletonDataRelationshipDocument {
		try await getUserPublicProfilePickUserPublicProfileRelationshipWithRequestBuilder(id: id, include: include).execute().body
	}

	/// Relationship: user public profile
	/// - GET /userPublicProfilePicks/{id}/relationships/userPublicProfile
	/// - Retrieves a picks owner public profile
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - OAuth:
	///  - type: oauth2
	///  - name: Client_Credentials
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter id: (path) TIDAL pick id
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// userPublicProfile (optional)
	/// - returns: RequestBuilder<UserPublicProfilePicksSingletonDataRelationshipDocument>
	class func getUserPublicProfilePickUserPublicProfileRelationshipWithRequestBuilder(
		id: String,
		include: [String]? = nil
	) -> RequestBuilder<UserPublicProfilePicksSingletonDataRelationshipDocument> {
		var localVariablePath = "/userPublicProfilePicks/{id}/relationships/userPublicProfile"
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

		let localVariableRequestBuilder: RequestBuilder<UserPublicProfilePicksSingletonDataRelationshipDocument>
			.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

		return localVariableRequestBuilder.init(
			method: "GET",
			URLString: (localVariableUrlComponents?.string ?? localVariableURLString),
			parameters: localVariableParameters,
			headers: localVariableHeaderParameters,
			requiresAuthentication: true
		)
	}

	/// Get picks
	///
	/// - parameter locale: (query) Locale language tag (IETF BCP 47 Language Tag)
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// item, userPublicProfile (optional)
	/// - parameter filterId: (query) Allows to filter the collection of resources based on id attribute value (optional)
	/// - parameter filterUserPublicProfileId: (query) Allows to filter the collection of resources based on userPublicProfile.id
	/// attribute value (optional)
	/// - returns: UserPublicProfilePicksMultiDataDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getUserPublicProfilePicksByFilters(
		locale: String,
		include: [String]? = nil,
		filterId: [String]? = nil,
		filterUserPublicProfileId: [String]? = nil
	) async throws -> UserPublicProfilePicksMultiDataDocument {
		try await getUserPublicProfilePicksByFiltersWithRequestBuilder(
			locale: locale,
			include: include,
			filterId: filterId,
			filterUserPublicProfileId: filterUserPublicProfileId
		).execute().body
	}

	/// Get picks
	/// - GET /userPublicProfilePicks
	/// - Retrieves a filtered collection of user's public picks.
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - OAuth:
	///  - type: oauth2
	///  - name: Client_Credentials
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter locale: (query) Locale language tag (IETF BCP 47 Language Tag)
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// item, userPublicProfile (optional)
	/// - parameter filterId: (query) Allows to filter the collection of resources based on id attribute value (optional)
	/// - parameter filterUserPublicProfileId: (query) Allows to filter the collection of resources based on userPublicProfile.id
	/// attribute value (optional)
	/// - returns: RequestBuilder<UserPublicProfilePicksMultiDataDocument>
	class func getUserPublicProfilePicksByFiltersWithRequestBuilder(
		locale: String,
		include: [String]? = nil,
		filterId: [String]? = nil,
		filterUserPublicProfileId: [String]? = nil
	) -> RequestBuilder<UserPublicProfilePicksMultiDataDocument> {
		let localVariablePath = "/userPublicProfilePicks"
		let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
		let localVariableParameters: [String: Any]? = nil

		var localVariableUrlComponents = URLComponents(string: localVariableURLString)
		localVariableUrlComponents?.queryItems = APIHelper.mapValuesToQueryItems([
			"locale": (wrappedValue: locale.encodeToJSON(), isExplode: true),
			"include": (wrappedValue: include?.encodeToJSON(), isExplode: true),
			"filter[id]": (wrappedValue: filterId?.encodeToJSON(), isExplode: true),
			"filter[userPublicProfile.id]": (wrappedValue: filterUserPublicProfileId?.encodeToJSON(), isExplode: true),
		])

		let localVariableNillableHeaders: [String: Any?] = [
			:
		]

		let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

		let localVariableRequestBuilder: RequestBuilder<UserPublicProfilePicksMultiDataDocument>.Type = OpenAPIClientAPI
			.requestBuilderFactory.getBuilder()

		return localVariableRequestBuilder.init(
			method: "GET",
			URLString: (localVariableUrlComponents?.string ?? localVariableURLString),
			parameters: localVariableParameters,
			headers: localVariableHeaderParameters,
			requiresAuthentication: true
		)
	}

	/// Relationship: item (update)
	///
	/// - parameter id: (path) TIDAL pick id
	/// - parameter updatePickRelationshipBody: (body)
	/// - parameter include: (query) Allows the client to customize which related resources should be returned (optional)
	/// - returns: AnyCodable
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func setUserPublicProfilePickItemRelationship(
		id: String,
		updatePickRelationshipBody: UpdatePickRelationshipBody,
		include: [String]? = nil
	) async throws -> AnyCodable {
		try await setUserPublicProfilePickItemRelationshipWithRequestBuilder(
			id: id,
			updatePickRelationshipBody: updatePickRelationshipBody,
			include: include
		).execute().body
	}

	/// Relationship: item (update)
	/// - PATCH /userPublicProfilePicks/{id}/relationships/item
	/// - Updates a picks item relationship, e.g. sets a 'track', 'album' or 'artist' reference.
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter id: (path) TIDAL pick id
	/// - parameter updatePickRelationshipBody: (body)
	/// - parameter include: (query) Allows the client to customize which related resources should be returned (optional)
	/// - returns: RequestBuilder<AnyCodable>
	class func setUserPublicProfilePickItemRelationshipWithRequestBuilder(
		id: String,
		updatePickRelationshipBody: UpdatePickRelationshipBody,
		include: [String]? = nil
	) -> RequestBuilder<AnyCodable> {
		var localVariablePath = "/userPublicProfilePicks/{id}/relationships/item"
		let idPreEscape = "\(APIHelper.mapValueToPathItem(id))"
		let idPostEscape = idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
		localVariablePath = localVariablePath.replacingOccurrences(of: "{id}", with: idPostEscape, options: .literal, range: nil)
		let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
		let localVariableParameters = JSONEncodingHelper.encodingParameters(forEncodableObject: updatePickRelationshipBody)

		var localVariableUrlComponents = URLComponents(string: localVariableURLString)
		localVariableUrlComponents?.queryItems = APIHelper.mapValuesToQueryItems([
			"include": (wrappedValue: include?.encodeToJSON(), isExplode: true),
		])

		let localVariableNillableHeaders: [String: Any?] = [
			"Content-Type": "application/vnd.api+json",
		]

		let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

		let localVariableRequestBuilder: RequestBuilder<AnyCodable>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

		return localVariableRequestBuilder.init(
			method: "PATCH",
			URLString: (localVariableUrlComponents?.string ?? localVariableURLString),
			parameters: localVariableParameters,
			headers: localVariableHeaderParameters,
			requiresAuthentication: true
		)
	}
}
