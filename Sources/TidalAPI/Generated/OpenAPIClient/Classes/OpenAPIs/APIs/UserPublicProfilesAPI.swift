import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - UserPublicProfilesAPI

class UserPublicProfilesAPI {
	/// Get my user profile
	///
	/// - parameter locale: (query) Locale language tag (IETF BCP 47 Language Tag)
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// publicPlaylists, publicPicks, followers, following (optional)
	/// - returns: UserPublicProfilesSingleDataDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getMyUserPublicProfile(
		locale: String,
		include: [String]? = nil
	) async throws -> UserPublicProfilesSingleDataDocument {
		try await getMyUserPublicProfileWithRequestBuilder(locale: locale, include: include).execute().body
	}

	/// Get my user profile
	/// - GET /userPublicProfiles/me
	/// - Retrieve the logged-in user's public profile details.
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
	/// publicPlaylists, publicPicks, followers, following (optional)
	/// - returns: RequestBuilder<UserPublicProfilesSingleDataDocument>
	class func getMyUserPublicProfileWithRequestBuilder(
		locale: String,
		include: [String]? = nil
	) -> RequestBuilder<UserPublicProfilesSingleDataDocument> {
		let localVariablePath = "/userPublicProfiles/me"
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

		let localVariableRequestBuilder: RequestBuilder<UserPublicProfilesSingleDataDocument>.Type = OpenAPIClientAPI
			.requestBuilderFactory.getBuilder()

		return localVariableRequestBuilder.init(
			method: "GET",
			URLString: (localVariableUrlComponents?.string ?? localVariableURLString),
			parameters: localVariableParameters,
			headers: localVariableHeaderParameters,
			requiresAuthentication: true
		)
	}

	/// Get user public profile by id
	///
	/// - parameter id: (path) TIDAL user id
	/// - parameter locale: (query) Locale language tag (IETF BCP 47 Language Tag)
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// publicPlaylists, publicPicks, followers, following (optional)
	/// - returns: UserPublicProfilesSingleDataDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getUserPublicProfileById(
		id: String,
		locale: String,
		include: [String]? = nil
	) async throws -> UserPublicProfilesSingleDataDocument {
		try await getUserPublicProfileByIdWithRequestBuilder(id: id, locale: locale, include: include).execute().body
	}

	/// Get user public profile by id
	/// - GET /userPublicProfiles/{id}
	/// - Retrieve user public profile details by TIDAL user id.
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - OAuth:
	///  - type: oauth2
	///  - name: Client_Credentials
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter id: (path) TIDAL user id
	/// - parameter locale: (query) Locale language tag (IETF BCP 47 Language Tag)
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// publicPlaylists, publicPicks, followers, following (optional)
	/// - returns: RequestBuilder<UserPublicProfilesSingleDataDocument>
	class func getUserPublicProfileByIdWithRequestBuilder(
		id: String,
		locale: String,
		include: [String]? = nil
	) -> RequestBuilder<UserPublicProfilesSingleDataDocument> {
		var localVariablePath = "/userPublicProfiles/{id}"
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

		let localVariableRequestBuilder: RequestBuilder<UserPublicProfilesSingleDataDocument>.Type = OpenAPIClientAPI
			.requestBuilderFactory.getBuilder()

		return localVariableRequestBuilder.init(
			method: "GET",
			URLString: (localVariableUrlComponents?.string ?? localVariableURLString),
			parameters: localVariableParameters,
			headers: localVariableHeaderParameters,
			requiresAuthentication: true
		)
	}

	/// Relationship: followers
	///
	/// - parameter id: (path) TIDAL user id
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// followers (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: UserPublicProfilesMultiDataRelationshipDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getUserPublicProfileFollowersRelationship(
		id: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) async throws -> UserPublicProfilesMultiDataRelationshipDocument {
		try await getUserPublicProfileFollowersRelationshipWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
			.execute().body
	}

	/// Relationship: followers
	/// - GET /userPublicProfiles/{id}/relationships/followers
	/// - Retrieve user's public followers
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - OAuth:
	///  - type: oauth2
	///  - name: Client_Credentials
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter id: (path) TIDAL user id
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// followers (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: RequestBuilder<UserPublicProfilesMultiDataRelationshipDocument>
	class func getUserPublicProfileFollowersRelationshipWithRequestBuilder(
		id: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) -> RequestBuilder<UserPublicProfilesMultiDataRelationshipDocument> {
		var localVariablePath = "/userPublicProfiles/{id}/relationships/followers"
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

		let localVariableRequestBuilder: RequestBuilder<UserPublicProfilesMultiDataRelationshipDocument>.Type = OpenAPIClientAPI
			.requestBuilderFactory.getBuilder()

		return localVariableRequestBuilder.init(
			method: "GET",
			URLString: (localVariableUrlComponents?.string ?? localVariableURLString),
			parameters: localVariableParameters,
			headers: localVariableHeaderParameters,
			requiresAuthentication: true
		)
	}

	/// Relationship: following
	///
	/// - parameter id: (path) TIDAL user id
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// following (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: UserPublicProfilesMultiDataRelationshipDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getUserPublicProfileFollowingRelationship(
		id: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) async throws -> UserPublicProfilesMultiDataRelationshipDocument {
		try await getUserPublicProfileFollowingRelationshipWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
			.execute().body
	}

	/// Relationship: following
	/// - GET /userPublicProfiles/{id}/relationships/following
	/// - Retrieve user's public followings
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - OAuth:
	///  - type: oauth2
	///  - name: Client_Credentials
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter id: (path) TIDAL user id
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// following (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: RequestBuilder<UserPublicProfilesMultiDataRelationshipDocument>
	class func getUserPublicProfileFollowingRelationshipWithRequestBuilder(
		id: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) -> RequestBuilder<UserPublicProfilesMultiDataRelationshipDocument> {
		var localVariablePath = "/userPublicProfiles/{id}/relationships/following"
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

		let localVariableRequestBuilder: RequestBuilder<UserPublicProfilesMultiDataRelationshipDocument>.Type = OpenAPIClientAPI
			.requestBuilderFactory.getBuilder()

		return localVariableRequestBuilder.init(
			method: "GET",
			URLString: (localVariableUrlComponents?.string ?? localVariableURLString),
			parameters: localVariableParameters,
			headers: localVariableHeaderParameters,
			requiresAuthentication: true
		)
	}

	/// Relationship: picks
	///
	/// - parameter id: (path) TIDAL user id
	/// - parameter locale: (query) Locale language tag (IETF BCP 47 Language Tag)
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// publicPicks (optional)
	/// - returns: UserPublicProfilesMultiDataRelationshipDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getUserPublicProfilePublicPicksRelationship(
		id: String,
		locale: String,
		include: [String]? = nil
	) async throws -> UserPublicProfilesMultiDataRelationshipDocument {
		try await getUserPublicProfilePublicPicksRelationshipWithRequestBuilder(id: id, locale: locale, include: include)
			.execute().body
	}

	/// Relationship: picks
	/// - GET /userPublicProfiles/{id}/relationships/publicPicks
	/// - Retrieve user's public picks.
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - OAuth:
	///  - type: oauth2
	///  - name: Client_Credentials
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter id: (path) TIDAL user id
	/// - parameter locale: (query) Locale language tag (IETF BCP 47 Language Tag)
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// publicPicks (optional)
	/// - returns: RequestBuilder<UserPublicProfilesMultiDataRelationshipDocument>
	class func getUserPublicProfilePublicPicksRelationshipWithRequestBuilder(
		id: String,
		locale: String,
		include: [String]? = nil
	) -> RequestBuilder<UserPublicProfilesMultiDataRelationshipDocument> {
		var localVariablePath = "/userPublicProfiles/{id}/relationships/publicPicks"
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

		let localVariableRequestBuilder: RequestBuilder<UserPublicProfilesMultiDataRelationshipDocument>.Type = OpenAPIClientAPI
			.requestBuilderFactory.getBuilder()

		return localVariableRequestBuilder.init(
			method: "GET",
			URLString: (localVariableUrlComponents?.string ?? localVariableURLString),
			parameters: localVariableParameters,
			headers: localVariableHeaderParameters,
			requiresAuthentication: true
		)
	}

	/// Relationship: playlists
	///
	/// - parameter id: (path) TIDAL user id
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// publicPlaylists (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: UserPublicProfilesMultiDataRelationshipDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getUserPublicProfilePublicPlaylistsRelationship(
		id: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) async throws -> UserPublicProfilesMultiDataRelationshipDocument {
		try await getUserPublicProfilePublicPlaylistsRelationshipWithRequestBuilder(
			id: id,
			include: include,
			pageCursor: pageCursor
		).execute().body
	}

	/// Relationship: playlists
	/// - GET /userPublicProfiles/{id}/relationships/publicPlaylists
	/// - Retrieves user's public playlists.
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - OAuth:
	///  - type: oauth2
	///  - name: Client_Credentials
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter id: (path) TIDAL user id
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// publicPlaylists (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: RequestBuilder<UserPublicProfilesMultiDataRelationshipDocument>
	class func getUserPublicProfilePublicPlaylistsRelationshipWithRequestBuilder(
		id: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) -> RequestBuilder<UserPublicProfilesMultiDataRelationshipDocument> {
		var localVariablePath = "/userPublicProfiles/{id}/relationships/publicPlaylists"
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

		let localVariableRequestBuilder: RequestBuilder<UserPublicProfilesMultiDataRelationshipDocument>.Type = OpenAPIClientAPI
			.requestBuilderFactory.getBuilder()

		return localVariableRequestBuilder.init(
			method: "GET",
			URLString: (localVariableUrlComponents?.string ?? localVariableURLString),
			parameters: localVariableParameters,
			headers: localVariableHeaderParameters,
			requiresAuthentication: true
		)
	}

	/// Get user public profiles
	///
	/// - parameter locale: (query) Locale language tag (IETF BCP 47 Language Tag)
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// publicPlaylists, publicPicks, followers, following (optional)
	/// - parameter filterId: (query) TIDAL user id (optional)
	/// - returns: UserPublicProfilesMultiDataDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getUserPublicProfilesByFilters(
		locale: String,
		include: [String]? = nil,
		filterId: [String]? = nil
	) async throws -> UserPublicProfilesMultiDataDocument {
		try await getUserPublicProfilesByFiltersWithRequestBuilder(locale: locale, include: include, filterId: filterId).execute()
			.body
	}

	/// Get user public profiles
	/// - GET /userPublicProfiles
	/// - Reads user public profile details by TIDAL user ids.
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
	/// publicPlaylists, publicPicks, followers, following (optional)
	/// - parameter filterId: (query) TIDAL user id (optional)
	/// - returns: RequestBuilder<UserPublicProfilesMultiDataDocument>
	class func getUserPublicProfilesByFiltersWithRequestBuilder(
		locale: String,
		include: [String]? = nil,
		filterId: [String]? = nil
	) -> RequestBuilder<UserPublicProfilesMultiDataDocument> {
		let localVariablePath = "/userPublicProfiles"
		let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
		let localVariableParameters: [String: Any]? = nil

		var localVariableUrlComponents = URLComponents(string: localVariableURLString)
		localVariableUrlComponents?.queryItems = APIHelper.mapValuesToQueryItems([
			"locale": (wrappedValue: locale.encodeToJSON(), isExplode: true),
			"include": (wrappedValue: include?.encodeToJSON(), isExplode: true),
			"filter[id]": (wrappedValue: filterId?.encodeToJSON(), isExplode: true),
		])

		let localVariableNillableHeaders: [String: Any?] = [
			:
		]

		let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

		let localVariableRequestBuilder: RequestBuilder<UserPublicProfilesMultiDataDocument>.Type = OpenAPIClientAPI
			.requestBuilderFactory.getBuilder()

		return localVariableRequestBuilder.init(
			method: "GET",
			URLString: (localVariableUrlComponents?.string ?? localVariableURLString),
			parameters: localVariableParameters,
			headers: localVariableHeaderParameters,
			requiresAuthentication: true
		)
	}

	/// Update user public profile
	///
	/// - parameter id: (path) ${public.usercontent.updateProfile.id.descr}
	/// - parameter updateUserProfileBody: (body)
	/// - parameter include: (query) Allows the client to customize which related resources should be returned (optional)
	/// - returns: AnyCodable
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func updateMyUserProfile(
		id: String,
		updateUserProfileBody: UpdateUserProfileBody,
		include: [String]? = nil
	) async throws -> AnyCodable {
		try await updateMyUserProfileWithRequestBuilder(id: id, updateUserProfileBody: updateUserProfileBody, include: include)
			.execute().body
	}

	/// Update user public profile
	/// - PATCH /userPublicProfiles/{id}
	/// - Update user public profile
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - OAuth:
	///  - type: oauth2
	///  - name: Client_Credentials
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter id: (path) ${public.usercontent.updateProfile.id.descr}
	/// - parameter updateUserProfileBody: (body)
	/// - parameter include: (query) Allows the client to customize which related resources should be returned (optional)
	/// - returns: RequestBuilder<AnyCodable>
	class func updateMyUserProfileWithRequestBuilder(
		id: String,
		updateUserProfileBody: UpdateUserProfileBody,
		include: [String]? = nil
	) -> RequestBuilder<AnyCodable> {
		var localVariablePath = "/userPublicProfiles/{id}"
		let idPreEscape = "\(APIHelper.mapValueToPathItem(id))"
		let idPostEscape = idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
		localVariablePath = localVariablePath.replacingOccurrences(of: "{id}", with: idPostEscape, options: .literal, range: nil)
		let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
		let localVariableParameters = JSONEncodingHelper.encodingParameters(forEncodableObject: updateUserProfileBody)

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
