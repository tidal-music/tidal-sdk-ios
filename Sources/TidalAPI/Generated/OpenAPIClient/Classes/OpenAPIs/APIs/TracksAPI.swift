import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - TracksAPI

class TracksAPI {
	/// Relationship: albums
	///
	/// - parameter id: (path) TIDAL track id
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// albums (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: TracksMultiDataRelationshipDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getTrackAlbumsRelationship(
		id: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) async throws -> TracksMultiDataRelationshipDocument {
		try await getTrackAlbumsRelationshipWithRequestBuilder(
			id: id,
			countryCode: countryCode,
			include: include,
			pageCursor: pageCursor
		).execute().body
	}

	/// Relationship: albums
	/// - GET /tracks/{id}/relationships/albums
	/// - Retrieve album details of the related track.
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - OAuth:
	///  - type: oauth2
	///  - name: Client_Credentials
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter id: (path) TIDAL track id
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// albums (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: RequestBuilder<TracksMultiDataRelationshipDocument>
	class func getTrackAlbumsRelationshipWithRequestBuilder(
		id: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) -> RequestBuilder<TracksMultiDataRelationshipDocument> {
		var localVariablePath = "/tracks/{id}/relationships/albums"
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

		let localVariableRequestBuilder: RequestBuilder<TracksMultiDataRelationshipDocument>.Type = OpenAPIClientAPI
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
	/// - parameter id: (path) TIDAL track id
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// artists (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: TracksMultiDataRelationshipDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getTrackArtistsRelationship(
		id: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) async throws -> TracksMultiDataRelationshipDocument {
		try await getTrackArtistsRelationshipWithRequestBuilder(
			id: id,
			countryCode: countryCode,
			include: include,
			pageCursor: pageCursor
		).execute().body
	}

	/// Relationship: artists
	/// - GET /tracks/{id}/relationships/artists
	/// - Retrieve artist details of the related track.
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - OAuth:
	///  - type: oauth2
	///  - name: Client_Credentials
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter id: (path) TIDAL track id
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// artists (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: RequestBuilder<TracksMultiDataRelationshipDocument>
	class func getTrackArtistsRelationshipWithRequestBuilder(
		id: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) -> RequestBuilder<TracksMultiDataRelationshipDocument> {
		var localVariablePath = "/tracks/{id}/relationships/artists"
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

		let localVariableRequestBuilder: RequestBuilder<TracksMultiDataRelationshipDocument>.Type = OpenAPIClientAPI
			.requestBuilderFactory.getBuilder()

		return localVariableRequestBuilder.init(
			method: "GET",
			URLString: (localVariableUrlComponents?.string ?? localVariableURLString),
			parameters: localVariableParameters,
			headers: localVariableHeaderParameters,
			requiresAuthentication: true
		)
	}

	/// Get single track
	///
	/// - parameter id: (path) TIDAL track id
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// artists, albums, providers, similarTracks, radio (optional)
	/// - returns: TracksSingleDataDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getTrackById(id: String, countryCode: String, include: [String]? = nil) async throws -> TracksSingleDataDocument {
		try await getTrackByIdWithRequestBuilder(id: id, countryCode: countryCode, include: include).execute().body
	}

	/// Get single track
	/// - GET /tracks/{id}
	/// - Retrieve track details by TIDAL track id.
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - OAuth:
	///  - type: oauth2
	///  - name: Client_Credentials
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter id: (path) TIDAL track id
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// artists, albums, providers, similarTracks, radio (optional)
	/// - returns: RequestBuilder<TracksSingleDataDocument>
	class func getTrackByIdWithRequestBuilder(
		id: String,
		countryCode: String,
		include: [String]? = nil
	) -> RequestBuilder<TracksSingleDataDocument> {
		var localVariablePath = "/tracks/{id}"
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

		let localVariableRequestBuilder: RequestBuilder<TracksSingleDataDocument>.Type = OpenAPIClientAPI.requestBuilderFactory
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
	/// - parameter id: (path) TIDAL id of the track
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// providers (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: TracksMultiDataRelationshipDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getTrackProvidersRelationship(
		id: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) async throws -> TracksMultiDataRelationshipDocument {
		try await getTrackProvidersRelationshipWithRequestBuilder(
			id: id,
			countryCode: countryCode,
			include: include,
			pageCursor: pageCursor
		).execute().body
	}

	/// Relationship: providers
	/// - GET /tracks/{id}/relationships/providers
	/// - This endpoint can be used to retrieve a list of track's related providers.
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - OAuth:
	///  - type: oauth2
	///  - name: Client_Credentials
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter id: (path) TIDAL id of the track
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// providers (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: RequestBuilder<TracksMultiDataRelationshipDocument>
	class func getTrackProvidersRelationshipWithRequestBuilder(
		id: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) -> RequestBuilder<TracksMultiDataRelationshipDocument> {
		var localVariablePath = "/tracks/{id}/relationships/providers"
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

		let localVariableRequestBuilder: RequestBuilder<TracksMultiDataRelationshipDocument>.Type = OpenAPIClientAPI
			.requestBuilderFactory.getBuilder()

		return localVariableRequestBuilder.init(
			method: "GET",
			URLString: (localVariableUrlComponents?.string ?? localVariableURLString),
			parameters: localVariableParameters,
			headers: localVariableHeaderParameters,
			requiresAuthentication: true
		)
	}

	/// Relationship: radio
	///
	/// - parameter id: (path) TIDAL id of the track
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// radio (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: TracksMultiDataRelationshipDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getTrackRadioRelationship(
		id: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) async throws -> TracksMultiDataRelationshipDocument {
		try await getTrackRadioRelationshipWithRequestBuilder(
			id: id,
			countryCode: countryCode,
			include: include,
			pageCursor: pageCursor
		).execute().body
	}

	/// Relationship: radio
	/// - GET /tracks/{id}/relationships/radio
	/// - This endpoint can be used to retrieve a list of radios for the given track.
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - OAuth:
	///  - type: oauth2
	///  - name: Client_Credentials
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter id: (path) TIDAL id of the track
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// radio (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: RequestBuilder<TracksMultiDataRelationshipDocument>
	class func getTrackRadioRelationshipWithRequestBuilder(
		id: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) -> RequestBuilder<TracksMultiDataRelationshipDocument> {
		var localVariablePath = "/tracks/{id}/relationships/radio"
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

		let localVariableRequestBuilder: RequestBuilder<TracksMultiDataRelationshipDocument>.Type = OpenAPIClientAPI
			.requestBuilderFactory.getBuilder()

		return localVariableRequestBuilder.init(
			method: "GET",
			URLString: (localVariableUrlComponents?.string ?? localVariableURLString),
			parameters: localVariableParameters,
			headers: localVariableHeaderParameters,
			requiresAuthentication: true
		)
	}

	/// Relationship: similar tracks
	///
	/// - parameter id: (path) TIDAL id of the track
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// similarTracks (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: TracksMultiDataRelationshipDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getTrackSimilarTracksRelationship(
		id: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) async throws -> TracksMultiDataRelationshipDocument {
		try await getTrackSimilarTracksRelationshipWithRequestBuilder(
			id: id,
			countryCode: countryCode,
			include: include,
			pageCursor: pageCursor
		).execute().body
	}

	/// Relationship: similar tracks
	/// - GET /tracks/{id}/relationships/similarTracks
	/// - This endpoint can be used to retrieve a list of tracks similar to the given track.
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - OAuth:
	///  - type: oauth2
	///  - name: Client_Credentials
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter id: (path) TIDAL id of the track
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// similarTracks (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: RequestBuilder<TracksMultiDataRelationshipDocument>
	class func getTrackSimilarTracksRelationshipWithRequestBuilder(
		id: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) -> RequestBuilder<TracksMultiDataRelationshipDocument> {
		var localVariablePath = "/tracks/{id}/relationships/similarTracks"
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

		let localVariableRequestBuilder: RequestBuilder<TracksMultiDataRelationshipDocument>.Type = OpenAPIClientAPI
			.requestBuilderFactory.getBuilder()

		return localVariableRequestBuilder.init(
			method: "GET",
			URLString: (localVariableUrlComponents?.string ?? localVariableURLString),
			parameters: localVariableParameters,
			headers: localVariableHeaderParameters,
			requiresAuthentication: true
		)
	}

	/// Get multiple tracks
	///
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// artists, albums, providers, similarTracks, radio (optional)
	/// - parameter filterId: (query) Allows to filter the collection of resources based on id attribute value (optional)
	/// - parameter filterIsrc: (query) Allows to filter the collection of resources based on isrc attribute value (optional)
	/// - returns: TracksMultiDataDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getTracksByFilters(
		countryCode: String,
		include: [String]? = nil,
		filterId: [String]? = nil,
		filterIsrc: [String]? = nil
	) async throws -> TracksMultiDataDocument {
		try await getTracksByFiltersWithRequestBuilder(
			countryCode: countryCode,
			include: include,
			filterId: filterId,
			filterIsrc: filterIsrc
		).execute().body
	}

	/// Get multiple tracks
	/// - GET /tracks
	/// - Retrieve multiple track details.
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
	/// artists, albums, providers, similarTracks, radio (optional)
	/// - parameter filterId: (query) Allows to filter the collection of resources based on id attribute value (optional)
	/// - parameter filterIsrc: (query) Allows to filter the collection of resources based on isrc attribute value (optional)
	/// - returns: RequestBuilder<TracksMultiDataDocument>
	class func getTracksByFiltersWithRequestBuilder(
		countryCode: String,
		include: [String]? = nil,
		filterId: [String]? = nil,
		filterIsrc: [String]? = nil
	) -> RequestBuilder<TracksMultiDataDocument> {
		let localVariablePath = "/tracks"
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

		let localVariableRequestBuilder: RequestBuilder<TracksMultiDataDocument>.Type = OpenAPIClientAPI.requestBuilderFactory
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
