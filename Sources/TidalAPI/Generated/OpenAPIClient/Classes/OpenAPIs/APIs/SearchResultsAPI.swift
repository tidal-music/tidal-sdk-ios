import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - SearchResultsAPI

class SearchResultsAPI {
	/// Relationship: albums
	///
	/// - parameter query: (path) Search query
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// albums (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: SearchresultsMultiDataRelationshipDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getSearchResultsAlbumsRelationship(
		query: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) async throws -> SearchresultsMultiDataRelationshipDocument {
		try await getSearchResultsAlbumsRelationshipWithRequestBuilder(
			query: query,
			countryCode: countryCode,
			include: include,
			pageCursor: pageCursor
		).execute().body
	}

	/// Relationship: albums
	/// - GET /searchresults/{query}/relationships/albums
	/// - Search for albums by a query.
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - OAuth:
	///  - type: oauth2
	///  - name: Client_Credentials
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter query: (path) Search query
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// albums (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: RequestBuilder<SearchresultsMultiDataRelationshipDocument>
	class func getSearchResultsAlbumsRelationshipWithRequestBuilder(
		query: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) -> RequestBuilder<SearchresultsMultiDataRelationshipDocument> {
		var localVariablePath = "/searchresults/{query}/relationships/albums"
		let queryPreEscape = "\(APIHelper.mapValueToPathItem(query))"
		let queryPostEscape = queryPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
		localVariablePath = localVariablePath.replacingOccurrences(
			of: "{query}",
			with: queryPostEscape,
			options: .literal,
			range: nil
		)
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

		let localVariableRequestBuilder: RequestBuilder<SearchresultsMultiDataRelationshipDocument>.Type = OpenAPIClientAPI
			.requestBuilderFactory.getBuilder()

		return localVariableRequestBuilder.init(
			method: "GET",
			URLString: (localVariableUrlComponents?.string ?? localVariableURLString),
			parameters: localVariableParameters,
			headers: localVariableHeaderParameters,
			requiresAuthentication: true
		)
	}

	/// Relationship: artists
	///
	/// - parameter query: (path) Search query
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// artists (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: SearchresultsMultiDataRelationshipDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getSearchResultsArtistsRelationship(
		query: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) async throws -> SearchresultsMultiDataRelationshipDocument {
		try await getSearchResultsArtistsRelationshipWithRequestBuilder(
			query: query,
			countryCode: countryCode,
			include: include,
			pageCursor: pageCursor
		).execute().body
	}

	/// Relationship: artists
	/// - GET /searchresults/{query}/relationships/artists
	/// - Search for artists by a query.
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - OAuth:
	///  - type: oauth2
	///  - name: Client_Credentials
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter query: (path) Search query
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// artists (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: RequestBuilder<SearchresultsMultiDataRelationshipDocument>
	class func getSearchResultsArtistsRelationshipWithRequestBuilder(
		query: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) -> RequestBuilder<SearchresultsMultiDataRelationshipDocument> {
		var localVariablePath = "/searchresults/{query}/relationships/artists"
		let queryPreEscape = "\(APIHelper.mapValueToPathItem(query))"
		let queryPostEscape = queryPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
		localVariablePath = localVariablePath.replacingOccurrences(
			of: "{query}",
			with: queryPostEscape,
			options: .literal,
			range: nil
		)
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

		let localVariableRequestBuilder: RequestBuilder<SearchresultsMultiDataRelationshipDocument>.Type = OpenAPIClientAPI
			.requestBuilderFactory.getBuilder()

		return localVariableRequestBuilder.init(
			method: "GET",
			URLString: (localVariableUrlComponents?.string ?? localVariableURLString),
			parameters: localVariableParameters,
			headers: localVariableHeaderParameters,
			requiresAuthentication: true
		)
	}

	/// Search for music metadata by a query
	///
	/// - parameter query: (path) Search query
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// artists, albums, tracks, videos, playlists, topHits (optional)
	/// - returns: SearchresultsSingleDataDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getSearchResultsByQuery(
		query: String,
		countryCode: String,
		include: [String]? = nil
	) async throws -> SearchresultsSingleDataDocument {
		try await getSearchResultsByQueryWithRequestBuilder(query: query, countryCode: countryCode, include: include).execute()
			.body
	}

	/// Search for music metadata by a query
	/// - GET /searchresults/{query}
	/// - Search for music: albums, artists, tracks, etc.
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - OAuth:
	///  - type: oauth2
	///  - name: Client_Credentials
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter query: (path) Search query
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// artists, albums, tracks, videos, playlists, topHits (optional)
	/// - returns: RequestBuilder<SearchresultsSingleDataDocument>
	class func getSearchResultsByQueryWithRequestBuilder(
		query: String,
		countryCode: String,
		include: [String]? = nil
	) -> RequestBuilder<SearchresultsSingleDataDocument> {
		var localVariablePath = "/searchresults/{query}"
		let queryPreEscape = "\(APIHelper.mapValueToPathItem(query))"
		let queryPostEscape = queryPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
		localVariablePath = localVariablePath.replacingOccurrences(
			of: "{query}",
			with: queryPostEscape,
			options: .literal,
			range: nil
		)
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

		let localVariableRequestBuilder: RequestBuilder<SearchresultsSingleDataDocument>.Type = OpenAPIClientAPI
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
	/// - parameter query: (path) Searh query
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// playlists (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: SearchresultsMultiDataRelationshipDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getSearchResultsPlaylistsRelationship(
		query: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) async throws -> SearchresultsMultiDataRelationshipDocument {
		try await getSearchResultsPlaylistsRelationshipWithRequestBuilder(
			query: query,
			countryCode: countryCode,
			include: include,
			pageCursor: pageCursor
		).execute().body
	}

	/// Relationship: playlists
	/// - GET /searchresults/{query}/relationships/playlists
	/// - Search for playlists by a query.
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - OAuth:
	///  - type: oauth2
	///  - name: Client_Credentials
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter query: (path) Searh query
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// playlists (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: RequestBuilder<SearchresultsMultiDataRelationshipDocument>
	class func getSearchResultsPlaylistsRelationshipWithRequestBuilder(
		query: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) -> RequestBuilder<SearchresultsMultiDataRelationshipDocument> {
		var localVariablePath = "/searchresults/{query}/relationships/playlists"
		let queryPreEscape = "\(APIHelper.mapValueToPathItem(query))"
		let queryPostEscape = queryPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
		localVariablePath = localVariablePath.replacingOccurrences(
			of: "{query}",
			with: queryPostEscape,
			options: .literal,
			range: nil
		)
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

		let localVariableRequestBuilder: RequestBuilder<SearchresultsMultiDataRelationshipDocument>.Type = OpenAPIClientAPI
			.requestBuilderFactory.getBuilder()

		return localVariableRequestBuilder.init(
			method: "GET",
			URLString: (localVariableUrlComponents?.string ?? localVariableURLString),
			parameters: localVariableParameters,
			headers: localVariableHeaderParameters,
			requiresAuthentication: true
		)
	}

	/// Relationship: topHits
	///
	/// - parameter query: (path) Search query
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// topHits (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: SearchresultsMultiDataRelationshipDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getSearchResultsTopHitsRelationship(
		query: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) async throws -> SearchresultsMultiDataRelationshipDocument {
		try await getSearchResultsTopHitsRelationshipWithRequestBuilder(
			query: query,
			countryCode: countryCode,
			include: include,
			pageCursor: pageCursor
		).execute().body
	}

	/// Relationship: topHits
	/// - GET /searchresults/{query}/relationships/topHits
	/// - Search for top hits by a query: artists, albums, tracks, videos.
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - OAuth:
	///  - type: oauth2
	///  - name: Client_Credentials
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter query: (path) Search query
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// topHits (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: RequestBuilder<SearchresultsMultiDataRelationshipDocument>
	class func getSearchResultsTopHitsRelationshipWithRequestBuilder(
		query: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) -> RequestBuilder<SearchresultsMultiDataRelationshipDocument> {
		var localVariablePath = "/searchresults/{query}/relationships/topHits"
		let queryPreEscape = "\(APIHelper.mapValueToPathItem(query))"
		let queryPostEscape = queryPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
		localVariablePath = localVariablePath.replacingOccurrences(
			of: "{query}",
			with: queryPostEscape,
			options: .literal,
			range: nil
		)
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

		let localVariableRequestBuilder: RequestBuilder<SearchresultsMultiDataRelationshipDocument>.Type = OpenAPIClientAPI
			.requestBuilderFactory.getBuilder()

		return localVariableRequestBuilder.init(
			method: "GET",
			URLString: (localVariableUrlComponents?.string ?? localVariableURLString),
			parameters: localVariableParameters,
			headers: localVariableHeaderParameters,
			requiresAuthentication: true
		)
	}

	/// Relationship: tracks
	///
	/// - parameter query: (path) Search query
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// tracks (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: SearchresultsMultiDataRelationshipDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getSearchResultsTracksRelationship(
		query: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) async throws -> SearchresultsMultiDataRelationshipDocument {
		try await getSearchResultsTracksRelationshipWithRequestBuilder(
			query: query,
			countryCode: countryCode,
			include: include,
			pageCursor: pageCursor
		).execute().body
	}

	/// Relationship: tracks
	/// - GET /searchresults/{query}/relationships/tracks
	/// - Search for tracks by a query.
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - OAuth:
	///  - type: oauth2
	///  - name: Client_Credentials
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter query: (path) Search query
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// tracks (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: RequestBuilder<SearchresultsMultiDataRelationshipDocument>
	class func getSearchResultsTracksRelationshipWithRequestBuilder(
		query: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) -> RequestBuilder<SearchresultsMultiDataRelationshipDocument> {
		var localVariablePath = "/searchresults/{query}/relationships/tracks"
		let queryPreEscape = "\(APIHelper.mapValueToPathItem(query))"
		let queryPostEscape = queryPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
		localVariablePath = localVariablePath.replacingOccurrences(
			of: "{query}",
			with: queryPostEscape,
			options: .literal,
			range: nil
		)
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

		let localVariableRequestBuilder: RequestBuilder<SearchresultsMultiDataRelationshipDocument>.Type = OpenAPIClientAPI
			.requestBuilderFactory.getBuilder()

		return localVariableRequestBuilder.init(
			method: "GET",
			URLString: (localVariableUrlComponents?.string ?? localVariableURLString),
			parameters: localVariableParameters,
			headers: localVariableHeaderParameters,
			requiresAuthentication: true
		)
	}

	/// Relationship: videos
	///
	/// - parameter query: (path) Search query
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// videos (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: SearchresultsMultiDataRelationshipDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getSearchResultsVideosRelationship(
		query: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) async throws -> SearchresultsMultiDataRelationshipDocument {
		try await getSearchResultsVideosRelationshipWithRequestBuilder(
			query: query,
			countryCode: countryCode,
			include: include,
			pageCursor: pageCursor
		).execute().body
	}

	/// Relationship: videos
	/// - GET /searchresults/{query}/relationships/videos
	/// - Search for videos by a query.
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - OAuth:
	///  - type: oauth2
	///  - name: Client_Credentials
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter query: (path) Search query
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// videos (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: RequestBuilder<SearchresultsMultiDataRelationshipDocument>
	class func getSearchResultsVideosRelationshipWithRequestBuilder(
		query: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) -> RequestBuilder<SearchresultsMultiDataRelationshipDocument> {
		var localVariablePath = "/searchresults/{query}/relationships/videos"
		let queryPreEscape = "\(APIHelper.mapValueToPathItem(query))"
		let queryPostEscape = queryPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
		localVariablePath = localVariablePath.replacingOccurrences(
			of: "{query}",
			with: queryPostEscape,
			options: .literal,
			range: nil
		)
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

		let localVariableRequestBuilder: RequestBuilder<SearchresultsMultiDataRelationshipDocument>.Type = OpenAPIClientAPI
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
