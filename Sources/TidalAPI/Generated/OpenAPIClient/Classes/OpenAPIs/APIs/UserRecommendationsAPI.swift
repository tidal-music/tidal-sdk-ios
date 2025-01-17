import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - UserRecommendationsAPI

class UserRecommendationsAPI {
	/// Get the current users recommendations
	///
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// myMixes, discoveryMixes, newArrivalMixes (optional)
	/// - returns: UserRecommendationsSingleDataDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getMyUserRecommendations(include: [String]? = nil) async throws -> UserRecommendationsSingleDataDocument {
		try await getMyUserRecommendationsWithRequestBuilder(include: include).execute().body
	}

	/// Get the current users recommendations
	/// - GET /userRecommendations/me
	/// - Get the current users recommendations
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// myMixes, discoveryMixes, newArrivalMixes (optional)
	/// - returns: RequestBuilder<UserRecommendationsSingleDataDocument>
	class func getMyUserRecommendationsWithRequestBuilder(include: [String]? = nil)
		-> RequestBuilder<UserRecommendationsSingleDataDocument>
	{
		let localVariablePath = "/userRecommendations/me"
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

		let localVariableRequestBuilder: RequestBuilder<UserRecommendationsSingleDataDocument>.Type = OpenAPIClientAPI
			.requestBuilderFactory.getBuilder()

		return localVariableRequestBuilder.init(
			method: "GET",
			URLString: (localVariableUrlComponents?.string ?? localVariableURLString),
			parameters: localVariableParameters,
			headers: localVariableHeaderParameters,
			requiresAuthentication: true
		)
	}

	/// Get recommendations for users in batch
	///
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// myMixes, discoveryMixes, newArrivalMixes (optional)
	/// - parameter filterId: (query) User recommendations id (optional)
	/// - returns: UserRecommendationsMultiDataDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getUserRecommendationsByFilters(
		include: [String]? = nil,
		filterId: [String]? = nil
	) async throws -> UserRecommendationsMultiDataDocument {
		try await getUserRecommendationsByFiltersWithRequestBuilder(include: include, filterId: filterId).execute().body
	}

	/// Get recommendations for users in batch
	/// - GET /userRecommendations
	/// - Get recommendations for users in batch
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// myMixes, discoveryMixes, newArrivalMixes (optional)
	/// - parameter filterId: (query) User recommendations id (optional)
	/// - returns: RequestBuilder<UserRecommendationsMultiDataDocument>
	class func getUserRecommendationsByFiltersWithRequestBuilder(
		include: [String]? = nil,
		filterId: [String]? = nil
	) -> RequestBuilder<UserRecommendationsMultiDataDocument> {
		let localVariablePath = "/userRecommendations"
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

		let localVariableRequestBuilder: RequestBuilder<UserRecommendationsMultiDataDocument>.Type = OpenAPIClientAPI
			.requestBuilderFactory.getBuilder()

		return localVariableRequestBuilder.init(
			method: "GET",
			URLString: (localVariableUrlComponents?.string ?? localVariableURLString),
			parameters: localVariableParameters,
			headers: localVariableHeaderParameters,
			requiresAuthentication: true
		)
	}

	/// Get user recommendations for user
	///
	/// - parameter id: (path) User recommendations id
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// myMixes, discoveryMixes, newArrivalMixes (optional)
	/// - returns: UserRecommendationsSingleDataDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getUserRecommendationsById(
		id: String,
		include: [String]? = nil
	) async throws -> UserRecommendationsSingleDataDocument {
		try await getUserRecommendationsByIdWithRequestBuilder(id: id, include: include).execute().body
	}

	/// Get user recommendations for user
	/// - GET /userRecommendations/{id}
	/// - Get user recommendations for user
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter id: (path) User recommendations id
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// myMixes, discoveryMixes, newArrivalMixes (optional)
	/// - returns: RequestBuilder<UserRecommendationsSingleDataDocument>
	class func getUserRecommendationsByIdWithRequestBuilder(
		id: String,
		include: [String]? = nil
	) -> RequestBuilder<UserRecommendationsSingleDataDocument> {
		var localVariablePath = "/userRecommendations/{id}"
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

		let localVariableRequestBuilder: RequestBuilder<UserRecommendationsSingleDataDocument>.Type = OpenAPIClientAPI
			.requestBuilderFactory.getBuilder()

		return localVariableRequestBuilder.init(
			method: "GET",
			URLString: (localVariableUrlComponents?.string ?? localVariableURLString),
			parameters: localVariableParameters,
			headers: localVariableHeaderParameters,
			requiresAuthentication: true
		)
	}

	/// Relationship: discovery mixes
	///
	/// - parameter id: (path) User recommendations id
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// discoveryMixes (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: UserRecommendationsMultiDataRelationshipDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getUserRecommendationsDiscoveryMixesRelationship(
		id: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) async throws -> UserRecommendationsMultiDataRelationshipDocument {
		try await getUserRecommendationsDiscoveryMixesRelationshipWithRequestBuilder(
			id: id,
			include: include,
			pageCursor: pageCursor
		).execute().body
	}

	/// Relationship: discovery mixes
	/// - GET /userRecommendations/{id}/relationships/discoveryMixes
	/// - Get discovery mixes relationship
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter id: (path) User recommendations id
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// discoveryMixes (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: RequestBuilder<UserRecommendationsMultiDataRelationshipDocument>
	class func getUserRecommendationsDiscoveryMixesRelationshipWithRequestBuilder(
		id: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) -> RequestBuilder<UserRecommendationsMultiDataRelationshipDocument> {
		var localVariablePath = "/userRecommendations/{id}/relationships/discoveryMixes"
		let idPreEscape = "\(APIHelper.mapValueToPathItem(id))"
		let idPostEscape = idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
		localVariablePath = localVariablePath.replacingOccurrences(of: "{id}", with: idPostEscape, options: .literal, range: nil)
		let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
		let localVariableParameters: [String: Any]? = nil

		var localVariableUrlComponents = URLComponents(string: localVariableURLString)
		localVariableUrlComponents?.queryItems = APIHelper.mapValuesToQueryItems([
			"include": (wrappedValue: include?.encodeToJSON(), isExplode: true),
			"page[cursor]": (wrappedValue: pageCursor?.encodeToJSON(), isExplode: true),
		])

		let localVariableNillableHeaders: [String: Any?] = [
			:
		]

		let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

		let localVariableRequestBuilder: RequestBuilder<UserRecommendationsMultiDataRelationshipDocument>.Type = OpenAPIClientAPI
			.requestBuilderFactory.getBuilder()

		return localVariableRequestBuilder.init(
			method: "GET",
			URLString: (localVariableUrlComponents?.string ?? localVariableURLString),
			parameters: localVariableParameters,
			headers: localVariableHeaderParameters,
			requiresAuthentication: true
		)
	}

	/// Relationship: my mixes
	///
	/// - parameter id: (path) User recommendations id
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// myMixes (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: UserRecommendationsMultiDataRelationshipDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getUserRecommendationsMyMixesRelationship(
		id: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) async throws -> UserRecommendationsMultiDataRelationshipDocument {
		try await getUserRecommendationsMyMixesRelationshipWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
			.execute().body
	}

	/// Relationship: my mixes
	/// - GET /userRecommendations/{id}/relationships/myMixes
	/// - Get my mixes relationship
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter id: (path) User recommendations id
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// myMixes (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: RequestBuilder<UserRecommendationsMultiDataRelationshipDocument>
	class func getUserRecommendationsMyMixesRelationshipWithRequestBuilder(
		id: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) -> RequestBuilder<UserRecommendationsMultiDataRelationshipDocument> {
		var localVariablePath = "/userRecommendations/{id}/relationships/myMixes"
		let idPreEscape = "\(APIHelper.mapValueToPathItem(id))"
		let idPostEscape = idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
		localVariablePath = localVariablePath.replacingOccurrences(of: "{id}", with: idPostEscape, options: .literal, range: nil)
		let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
		let localVariableParameters: [String: Any]? = nil

		var localVariableUrlComponents = URLComponents(string: localVariableURLString)
		localVariableUrlComponents?.queryItems = APIHelper.mapValuesToQueryItems([
			"include": (wrappedValue: include?.encodeToJSON(), isExplode: true),
			"page[cursor]": (wrappedValue: pageCursor?.encodeToJSON(), isExplode: true),
		])

		let localVariableNillableHeaders: [String: Any?] = [
			:
		]

		let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

		let localVariableRequestBuilder: RequestBuilder<UserRecommendationsMultiDataRelationshipDocument>.Type = OpenAPIClientAPI
			.requestBuilderFactory.getBuilder()

		return localVariableRequestBuilder.init(
			method: "GET",
			URLString: (localVariableUrlComponents?.string ?? localVariableURLString),
			parameters: localVariableParameters,
			headers: localVariableHeaderParameters,
			requiresAuthentication: true
		)
	}

	/// Relationship: new arrivals mixes
	///
	/// - parameter id: (path) User recommendations id
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// newArrivalMixes (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: UserRecommendationsMultiDataRelationshipDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getUserRecommendationsNewArrivalMixesRelationship(
		id: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) async throws -> UserRecommendationsMultiDataRelationshipDocument {
		try await getUserRecommendationsNewArrivalMixesRelationshipWithRequestBuilder(
			id: id,
			include: include,
			pageCursor: pageCursor
		).execute().body
	}

	/// Relationship: new arrivals mixes
	/// - GET /userRecommendations/{id}/relationships/newArrivalMixes
	/// - Get new arrival mixes relationship
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter id: (path) User recommendations id
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// newArrivalMixes (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: RequestBuilder<UserRecommendationsMultiDataRelationshipDocument>
	class func getUserRecommendationsNewArrivalMixesRelationshipWithRequestBuilder(
		id: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) -> RequestBuilder<UserRecommendationsMultiDataRelationshipDocument> {
		var localVariablePath = "/userRecommendations/{id}/relationships/newArrivalMixes"
		let idPreEscape = "\(APIHelper.mapValueToPathItem(id))"
		let idPostEscape = idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
		localVariablePath = localVariablePath.replacingOccurrences(of: "{id}", with: idPostEscape, options: .literal, range: nil)
		let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
		let localVariableParameters: [String: Any]? = nil

		var localVariableUrlComponents = URLComponents(string: localVariableURLString)
		localVariableUrlComponents?.queryItems = APIHelper.mapValuesToQueryItems([
			"include": (wrappedValue: include?.encodeToJSON(), isExplode: true),
			"page[cursor]": (wrappedValue: pageCursor?.encodeToJSON(), isExplode: true),
		])

		let localVariableNillableHeaders: [String: Any?] = [
			:
		]

		let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

		let localVariableRequestBuilder: RequestBuilder<UserRecommendationsMultiDataRelationshipDocument>.Type = OpenAPIClientAPI
			.requestBuilderFactory.getBuilder()

		return localVariableRequestBuilder.init(
			method: "GET",
			URLString: (localVariableUrlComponents?.string ?? localVariableURLString),
			parameters: localVariableParameters,
			headers: localVariableHeaderParameters,
			requiresAuthentication: true
		)
	}
}
