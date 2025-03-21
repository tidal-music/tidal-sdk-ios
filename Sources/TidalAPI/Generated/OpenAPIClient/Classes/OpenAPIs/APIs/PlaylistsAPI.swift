import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - PlaylistsAPI

class PlaylistsAPI {
	/// Get current user's playlists
	///
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// items, owners (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: PlaylistsMultiDataDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getMyPlaylists(include: [String]? = nil, pageCursor: String? = nil) async throws -> PlaylistsMultiDataDocument {
		try await getMyPlaylistsWithRequestBuilder(include: include, pageCursor: pageCursor).execute().body
	}

	/// Get current user's playlists
	/// - GET /playlists/me
	/// - Get my playlists
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - OAuth:
	///  - type: oauth2
	///  - name: Client_Credentials
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// items, owners (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: RequestBuilder<PlaylistsMultiDataDocument>
	class func getMyPlaylistsWithRequestBuilder(
		include: [String]? = nil,
		pageCursor: String? = nil
	) -> RequestBuilder<PlaylistsMultiDataDocument> {
		let localVariablePath = "/playlists/me"
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

		let localVariableRequestBuilder: RequestBuilder<PlaylistsMultiDataDocument>.Type = OpenAPIClientAPI.requestBuilderFactory
			.getBuilder()

		return localVariableRequestBuilder.init(
			method: "GET",
			URLString: (localVariableUrlComponents?.string ?? localVariableURLString),
			parameters: localVariableParameters,
			headers: localVariableHeaderParameters,
			requiresAuthentication: true
		)
	}

	/// Get single playlist
	///
	/// - parameter countryCode: (query) Country code (ISO 3166-1 alpha-2)
	/// - parameter id: (path) TIDAL playlist id
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// items, owners (optional)
	/// - returns: PlaylistsSingleDataDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getPlaylistById(
		countryCode: String,
		id: String,
		include: [String]? = nil
	) async throws -> PlaylistsSingleDataDocument {
		try await getPlaylistByIdWithRequestBuilder(countryCode: countryCode, id: id, include: include).execute().body
	}

	/// Get single playlist
	/// - GET /playlists/{id}
	/// - Get playlist by id
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - OAuth:
	///  - type: oauth2
	///  - name: Client_Credentials
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter countryCode: (query) Country code (ISO 3166-1 alpha-2)
	/// - parameter id: (path) TIDAL playlist id
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// items, owners (optional)
	/// - returns: RequestBuilder<PlaylistsSingleDataDocument>
	class func getPlaylistByIdWithRequestBuilder(
		countryCode: String,
		id: String,
		include: [String]? = nil
	) -> RequestBuilder<PlaylistsSingleDataDocument> {
		var localVariablePath = "/playlists/{id}"
		let idPreEscape = "\(APIHelper.mapValueToPathItem(id))"
		let idPostEscape = idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
		localVariablePath = localVariablePath.replacingOccurrences(of: "{id}", with: idPostEscape, options: .literal, range: nil)
		let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
		let localVariableParameters: [String: Any]? = nil

		var localVariableUrlComponents = URLComponents(string: localVariableURLString)
		localVariableUrlComponents?.queryItems = APIHelper.mapValuesToQueryItems([
			"countryCode": (wrappedValue: countryCode.encodeToJSON(), isExplode: true),
			"include": (wrappedValue: include?.encodeToJSON(), isExplode: true),
		])

		let localVariableNillableHeaders: [String: Any?] = [
			:
		]

		let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

		let localVariableRequestBuilder: RequestBuilder<PlaylistsSingleDataDocument>.Type = OpenAPIClientAPI.requestBuilderFactory
			.getBuilder()

		return localVariableRequestBuilder.init(
			method: "GET",
			URLString: (localVariableUrlComponents?.string ?? localVariableURLString),
			parameters: localVariableParameters,
			headers: localVariableHeaderParameters,
			requiresAuthentication: true
		)
	}

	/// Relationship: items
	///
	/// - parameter id: (path) TIDAL playlist id
	/// - parameter countryCode: (query) Country code (ISO 3166-1 alpha-2)
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// items (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: PlaylistsMultiDataRelationshipDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getPlaylistItemsRelationship(
		id: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) async throws -> PlaylistsMultiDataRelationshipDocument {
		try await getPlaylistItemsRelationshipWithRequestBuilder(
			id: id,
			countryCode: countryCode,
			include: include,
			pageCursor: pageCursor
		).execute().body
	}

	/// Relationship: items
	/// - GET /playlists/{id}/relationships/items
	/// - Get playlist items
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - OAuth:
	///  - type: oauth2
	///  - name: Client_Credentials
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter id: (path) TIDAL playlist id
	/// - parameter countryCode: (query) Country code (ISO 3166-1 alpha-2)
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// items (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: RequestBuilder<PlaylistsMultiDataRelationshipDocument>
	class func getPlaylistItemsRelationshipWithRequestBuilder(
		id: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) -> RequestBuilder<PlaylistsMultiDataRelationshipDocument> {
		var localVariablePath = "/playlists/{id}/relationships/items"
		let idPreEscape = "\(APIHelper.mapValueToPathItem(id))"
		let idPostEscape = idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
		localVariablePath = localVariablePath.replacingOccurrences(of: "{id}", with: idPostEscape, options: .literal, range: nil)
		let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
		let localVariableParameters: [String: Any]? = nil

		var localVariableUrlComponents = URLComponents(string: localVariableURLString)
		localVariableUrlComponents?.queryItems = APIHelper.mapValuesToQueryItems([
			"countryCode": (wrappedValue: countryCode.encodeToJSON(), isExplode: true),
			"include": (wrappedValue: include?.encodeToJSON(), isExplode: true),
			"page[cursor]": (wrappedValue: pageCursor?.encodeToJSON(), isExplode: true),
		])

		let localVariableNillableHeaders: [String: Any?] = [
			:
		]

		let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

		let localVariableRequestBuilder: RequestBuilder<PlaylistsMultiDataRelationshipDocument>.Type = OpenAPIClientAPI
			.requestBuilderFactory.getBuilder()

		return localVariableRequestBuilder.init(
			method: "GET",
			URLString: (localVariableUrlComponents?.string ?? localVariableURLString),
			parameters: localVariableParameters,
			headers: localVariableHeaderParameters,
			requiresAuthentication: true
		)
	}

	/// Relationship: owner
	///
	/// - parameter id: (path) TIDAL playlist id
	/// - parameter countryCode: (query) Country code (ISO 3166-1 alpha-2)
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// owners (optional)
	/// - returns: PlaylistsMultiDataRelationshipDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getPlaylistOwnersRelationship(
		id: String,
		countryCode: String,
		include: [String]? = nil
	) async throws -> PlaylistsMultiDataRelationshipDocument {
		try await getPlaylistOwnersRelationshipWithRequestBuilder(id: id, countryCode: countryCode, include: include).execute()
			.body
	}

	/// Relationship: owner
	/// - GET /playlists/{id}/relationships/owners
	/// - Get playlist owner
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - OAuth:
	///  - type: oauth2
	///  - name: Client_Credentials
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter id: (path) TIDAL playlist id
	/// - parameter countryCode: (query) Country code (ISO 3166-1 alpha-2)
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// owners (optional)
	/// - returns: RequestBuilder<PlaylistsMultiDataRelationshipDocument>
	class func getPlaylistOwnersRelationshipWithRequestBuilder(
		id: String,
		countryCode: String,
		include: [String]? = nil
	) -> RequestBuilder<PlaylistsMultiDataRelationshipDocument> {
		var localVariablePath = "/playlists/{id}/relationships/owners"
		let idPreEscape = "\(APIHelper.mapValueToPathItem(id))"
		let idPostEscape = idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
		localVariablePath = localVariablePath.replacingOccurrences(of: "{id}", with: idPostEscape, options: .literal, range: nil)
		let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
		let localVariableParameters: [String: Any]? = nil

		var localVariableUrlComponents = URLComponents(string: localVariableURLString)
		localVariableUrlComponents?.queryItems = APIHelper.mapValuesToQueryItems([
			"countryCode": (wrappedValue: countryCode.encodeToJSON(), isExplode: true),
			"include": (wrappedValue: include?.encodeToJSON(), isExplode: true),
		])

		let localVariableNillableHeaders: [String: Any?] = [
			:
		]

		let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

		let localVariableRequestBuilder: RequestBuilder<PlaylistsMultiDataRelationshipDocument>.Type = OpenAPIClientAPI
			.requestBuilderFactory.getBuilder()

		return localVariableRequestBuilder.init(
			method: "GET",
			URLString: (localVariableUrlComponents?.string ?? localVariableURLString),
			parameters: localVariableParameters,
			headers: localVariableHeaderParameters,
			requiresAuthentication: true
		)
	}

	/// Get multiple playlists
	///
	/// - parameter countryCode: (query) Country code (ISO 3166-1 alpha-2)
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// items, owners (optional)
	/// - parameter filterId: (query) public.usercontent.getPlaylists.ids.descr (optional)
	/// - returns: PlaylistsMultiDataDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getPlaylistsByFilters(
		countryCode: String,
		include: [String]? = nil,
		filterId: [String]? = nil
	) async throws -> PlaylistsMultiDataDocument {
		try await getPlaylistsByFiltersWithRequestBuilder(countryCode: countryCode, include: include, filterId: filterId)
			.execute().body
	}

	/// Get multiple playlists
	/// - GET /playlists
	/// - Get user playlists
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - OAuth:
	///  - type: oauth2
	///  - name: Client_Credentials
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter countryCode: (query) Country code (ISO 3166-1 alpha-2)
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// items, owners (optional)
	/// - parameter filterId: (query) public.usercontent.getPlaylists.ids.descr (optional)
	/// - returns: RequestBuilder<PlaylistsMultiDataDocument>
	class func getPlaylistsByFiltersWithRequestBuilder(
		countryCode: String,
		include: [String]? = nil,
		filterId: [String]? = nil
	) -> RequestBuilder<PlaylistsMultiDataDocument> {
		let localVariablePath = "/playlists"
		let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
		let localVariableParameters: [String: Any]? = nil

		var localVariableUrlComponents = URLComponents(string: localVariableURLString)
		localVariableUrlComponents?.queryItems = APIHelper.mapValuesToQueryItems([
			"countryCode": (wrappedValue: countryCode.encodeToJSON(), isExplode: true),
			"include": (wrappedValue: include?.encodeToJSON(), isExplode: true),
			"filter[id]": (wrappedValue: filterId?.encodeToJSON(), isExplode: true),
		])

		let localVariableNillableHeaders: [String: Any?] = [
			:
		]

		let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

		let localVariableRequestBuilder: RequestBuilder<PlaylistsMultiDataDocument>.Type = OpenAPIClientAPI.requestBuilderFactory
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
