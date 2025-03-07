import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - VideosAPI

class VideosAPI {
	/// Relationship: albums
	///
	/// - parameter id: (path) TIDAL video id
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// albums (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: VideosMultiDataRelationshipDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getVideoAlbumsRelationship(
		id: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) async throws -> VideosMultiDataRelationshipDocument {
		try await getVideoAlbumsRelationshipWithRequestBuilder(
			id: id,
			countryCode: countryCode,
			include: include,
			pageCursor: pageCursor
		).execute().body
	}

	/// Relationship: albums
	/// - GET /videos/{id}/relationships/albums
	/// - Retrieve album details of the related video.
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - OAuth:
	///  - type: oauth2
	///  - name: Client_Credentials
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter id: (path) TIDAL video id
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// albums (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: RequestBuilder<VideosMultiDataRelationshipDocument>
	class func getVideoAlbumsRelationshipWithRequestBuilder(
		id: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) -> RequestBuilder<VideosMultiDataRelationshipDocument> {
		var localVariablePath = "/videos/{id}/relationships/albums"
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

		let localVariableRequestBuilder: RequestBuilder<VideosMultiDataRelationshipDocument>.Type = OpenAPIClientAPI
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
	/// - parameter id: (path) TIDAL video id
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// artists (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: VideosMultiDataRelationshipDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getVideoArtistsRelationship(
		id: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) async throws -> VideosMultiDataRelationshipDocument {
		try await getVideoArtistsRelationshipWithRequestBuilder(
			id: id,
			countryCode: countryCode,
			include: include,
			pageCursor: pageCursor
		).execute().body
	}

	/// Relationship: artists
	/// - GET /videos/{id}/relationships/artists
	/// - Retrieve artist details of the related video.
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - OAuth:
	///  - type: oauth2
	///  - name: Client_Credentials
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter id: (path) TIDAL video id
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// artists (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: RequestBuilder<VideosMultiDataRelationshipDocument>
	class func getVideoArtistsRelationshipWithRequestBuilder(
		id: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) -> RequestBuilder<VideosMultiDataRelationshipDocument> {
		var localVariablePath = "/videos/{id}/relationships/artists"
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

		let localVariableRequestBuilder: RequestBuilder<VideosMultiDataRelationshipDocument>.Type = OpenAPIClientAPI
			.requestBuilderFactory.getBuilder()

		return localVariableRequestBuilder.init(
			method: "GET",
			URLString: (localVariableUrlComponents?.string ?? localVariableURLString),
			parameters: localVariableParameters,
			headers: localVariableHeaderParameters,
			requiresAuthentication: true
		)
	}

	/// Get single video
	///
	/// - parameter id: (path) TIDAL video id
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// artists, albums, providers (optional)
	/// - returns: VideosSingleDataDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getVideoById(id: String, countryCode: String, include: [String]? = nil) async throws -> VideosSingleDataDocument {
		try await getVideoByIdWithRequestBuilder(id: id, countryCode: countryCode, include: include).execute().body
	}

	/// Get single video
	/// - GET /videos/{id}
	/// - Retrieve video details by TIDAL video id.
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - OAuth:
	///  - type: oauth2
	///  - name: Client_Credentials
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter id: (path) TIDAL video id
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// artists, albums, providers (optional)
	/// - returns: RequestBuilder<VideosSingleDataDocument>
	class func getVideoByIdWithRequestBuilder(
		id: String,
		countryCode: String,
		include: [String]? = nil
	) -> RequestBuilder<VideosSingleDataDocument> {
		var localVariablePath = "/videos/{id}"
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

		let localVariableRequestBuilder: RequestBuilder<VideosSingleDataDocument>.Type = OpenAPIClientAPI.requestBuilderFactory
			.getBuilder()

		return localVariableRequestBuilder.init(
			method: "GET",
			URLString: (localVariableUrlComponents?.string ?? localVariableURLString),
			parameters: localVariableParameters,
			headers: localVariableHeaderParameters,
			requiresAuthentication: true
		)
	}

	/// Relationship: providers
	///
	/// - parameter id: (path) TIDAL id of the video
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// providers (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: VideosMultiDataRelationshipDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getVideoProvidersRelationship(
		id: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) async throws -> VideosMultiDataRelationshipDocument {
		try await getVideoProvidersRelationshipWithRequestBuilder(
			id: id,
			countryCode: countryCode,
			include: include,
			pageCursor: pageCursor
		).execute().body
	}

	/// Relationship: providers
	/// - GET /videos/{id}/relationships/providers
	/// - This endpoint can be used to retrieve a list of video's related providers.
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - OAuth:
	///  - type: oauth2
	///  - name: Client_Credentials
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter id: (path) TIDAL id of the video
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// providers (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: RequestBuilder<VideosMultiDataRelationshipDocument>
	class func getVideoProvidersRelationshipWithRequestBuilder(
		id: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) -> RequestBuilder<VideosMultiDataRelationshipDocument> {
		var localVariablePath = "/videos/{id}/relationships/providers"
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

		let localVariableRequestBuilder: RequestBuilder<VideosMultiDataRelationshipDocument>.Type = OpenAPIClientAPI
			.requestBuilderFactory.getBuilder()

		return localVariableRequestBuilder.init(
			method: "GET",
			URLString: (localVariableUrlComponents?.string ?? localVariableURLString),
			parameters: localVariableParameters,
			headers: localVariableHeaderParameters,
			requiresAuthentication: true
		)
	}

	/// Get multiple videos
	///
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// artists, albums, providers (optional)
	/// - parameter filterId: (query) Allows to filter the collection of resources based on id attribute value (optional)
	/// - parameter filterIsrc: (query) Allows to filter the collection of resources based on isrc attribute value (optional)
	/// - returns: VideosMultiDataDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getVideosByFilters(
		countryCode: String,
		include: [String]? = nil,
		filterId: [String]? = nil,
		filterIsrc: [String]? = nil
	) async throws -> VideosMultiDataDocument {
		try await getVideosByFiltersWithRequestBuilder(
			countryCode: countryCode,
			include: include,
			filterId: filterId,
			filterIsrc: filterIsrc
		).execute().body
	}

	/// Get multiple videos
	/// - GET /videos
	/// - Retrieve multiple video details.
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - OAuth:
	///  - type: oauth2
	///  - name: Client_Credentials
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// artists, albums, providers (optional)
	/// - parameter filterId: (query) Allows to filter the collection of resources based on id attribute value (optional)
	/// - parameter filterIsrc: (query) Allows to filter the collection of resources based on isrc attribute value (optional)
	/// - returns: RequestBuilder<VideosMultiDataDocument>
	class func getVideosByFiltersWithRequestBuilder(
		countryCode: String,
		include: [String]? = nil,
		filterId: [String]? = nil,
		filterIsrc: [String]? = nil
	) -> RequestBuilder<VideosMultiDataDocument> {
		let localVariablePath = "/videos"
		let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
		let localVariableParameters: [String: Any]? = nil

		var localVariableUrlComponents = URLComponents(string: localVariableURLString)
		localVariableUrlComponents?.queryItems = APIHelper.mapValuesToQueryItems([
			"countryCode": (wrappedValue: countryCode.encodeToJSON(), isExplode: true),
			"include": (wrappedValue: include?.encodeToJSON(), isExplode: true),
			"filter[id]": (wrappedValue: filterId?.encodeToJSON(), isExplode: true),
			"filter[isrc]": (wrappedValue: filterIsrc?.encodeToJSON(), isExplode: true),
		])

		let localVariableNillableHeaders: [String: Any?] = [
			:
		]

		let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

		let localVariableRequestBuilder: RequestBuilder<VideosMultiDataDocument>.Type = OpenAPIClientAPI.requestBuilderFactory
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
