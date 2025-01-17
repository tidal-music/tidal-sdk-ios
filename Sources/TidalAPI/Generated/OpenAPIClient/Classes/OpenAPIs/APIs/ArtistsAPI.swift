import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - ArtistsAPI

class ArtistsAPI {
	/// Relationship: albums
	///
	/// - parameter id: (path) TIDAL artist id
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// albums (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: ArtistsMultiDataRelationshipDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getArtistAlbumsRelationship(
		id: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) async throws -> ArtistsMultiDataRelationshipDocument {
		try await getArtistAlbumsRelationshipWithRequestBuilder(
			id: id,
			countryCode: countryCode,
			include: include,
			pageCursor: pageCursor
		).execute().body
	}

	/// Relationship: albums
	/// - GET /artists/{id}/relationships/albums
	/// - Retrieve album details of the related artist.
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - OAuth:
	///  - type: oauth2
	///  - name: Client_Credentials
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter id: (path) TIDAL artist id
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// albums (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: RequestBuilder<ArtistsMultiDataRelationshipDocument>
	class func getArtistAlbumsRelationshipWithRequestBuilder(
		id: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) -> RequestBuilder<ArtistsMultiDataRelationshipDocument> {
		var localVariablePath = "/artists/{id}/relationships/albums"
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

		let localVariableRequestBuilder: RequestBuilder<ArtistsMultiDataRelationshipDocument>.Type = OpenAPIClientAPI
			.requestBuilderFactory.getBuilder()

		return localVariableRequestBuilder.init(
			method: "GET",
			URLString: (localVariableUrlComponents?.string ?? localVariableURLString),
			parameters: localVariableParameters,
			headers: localVariableHeaderParameters,
			requiresAuthentication: true
		)
	}

	/// Get single artist
	///
	/// - parameter id: (path) TIDAL artist id
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// albums, tracks, videos, similarArtists, trackProviders, radio (optional)
	/// - returns: ArtistsSingleDataDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getArtistById(
		id: String,
		countryCode: String,
		include: [String]? = nil
	) async throws -> ArtistsSingleDataDocument {
		try await getArtistByIdWithRequestBuilder(id: id, countryCode: countryCode, include: include).execute().body
	}

	/// Get single artist
	/// - GET /artists/{id}
	/// - Retrieve artist details by TIDAL artist id.
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - OAuth:
	///  - type: oauth2
	///  - name: Client_Credentials
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter id: (path) TIDAL artist id
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// albums, tracks, videos, similarArtists, trackProviders, radio (optional)
	/// - returns: RequestBuilder<ArtistsSingleDataDocument>
	class func getArtistByIdWithRequestBuilder(
		id: String,
		countryCode: String,
		include: [String]? = nil
	) -> RequestBuilder<ArtistsSingleDataDocument> {
		var localVariablePath = "/artists/{id}"
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

		let localVariableRequestBuilder: RequestBuilder<ArtistsSingleDataDocument>.Type = OpenAPIClientAPI.requestBuilderFactory
			.getBuilder()

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
	/// - parameter id: (path) TIDAL id of the artist
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// radio (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: ArtistsMultiDataRelationshipDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getArtistRadioRelationship(
		id: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) async throws -> ArtistsMultiDataRelationshipDocument {
		try await getArtistRadioRelationshipWithRequestBuilder(
			id: id,
			countryCode: countryCode,
			include: include,
			pageCursor: pageCursor
		).execute().body
	}

	/// Relationship: radio
	/// - GET /artists/{id}/relationships/radio
	/// - This endpoint can be used to retrieve a list of radios for the given artist.
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - OAuth:
	///  - type: oauth2
	///  - name: Client_Credentials
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter id: (path) TIDAL id of the artist
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// radio (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: RequestBuilder<ArtistsMultiDataRelationshipDocument>
	class func getArtistRadioRelationshipWithRequestBuilder(
		id: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) -> RequestBuilder<ArtistsMultiDataRelationshipDocument> {
		var localVariablePath = "/artists/{id}/relationships/radio"
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

		let localVariableRequestBuilder: RequestBuilder<ArtistsMultiDataRelationshipDocument>.Type = OpenAPIClientAPI
			.requestBuilderFactory.getBuilder()

		return localVariableRequestBuilder.init(
			method: "GET",
			URLString: (localVariableUrlComponents?.string ?? localVariableURLString),
			parameters: localVariableParameters,
			headers: localVariableHeaderParameters,
			requiresAuthentication: true
		)
	}

	/// Relationship: similar artists
	///
	/// - parameter id: (path) TIDAL id of the artist
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// similarArtists (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: ArtistsMultiDataRelationshipDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getArtistSimilarArtistsRelationship(
		id: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) async throws -> ArtistsMultiDataRelationshipDocument {
		try await getArtistSimilarArtistsRelationshipWithRequestBuilder(
			id: id,
			countryCode: countryCode,
			include: include,
			pageCursor: pageCursor
		).execute().body
	}

	/// Relationship: similar artists
	/// - GET /artists/{id}/relationships/similarArtists
	/// - This endpoint can be used to retrieve a list of artists similar to the given artist.
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - OAuth:
	///  - type: oauth2
	///  - name: Client_Credentials
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter id: (path) TIDAL id of the artist
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// similarArtists (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: RequestBuilder<ArtistsMultiDataRelationshipDocument>
	class func getArtistSimilarArtistsRelationshipWithRequestBuilder(
		id: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) -> RequestBuilder<ArtistsMultiDataRelationshipDocument> {
		var localVariablePath = "/artists/{id}/relationships/similarArtists"
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

		let localVariableRequestBuilder: RequestBuilder<ArtistsMultiDataRelationshipDocument>.Type = OpenAPIClientAPI
			.requestBuilderFactory.getBuilder()

		return localVariableRequestBuilder.init(
			method: "GET",
			URLString: (localVariableUrlComponents?.string ?? localVariableURLString),
			parameters: localVariableParameters,
			headers: localVariableHeaderParameters,
			requiresAuthentication: true
		)
	}

	/// Relationship: track providers
	///
	/// - parameter id: (path) TIDAL id of the artist
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// trackProviders (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: ArtistsTrackProvidersMultiDataRelationshipDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getArtistTrackProvidersRelationship(
		id: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) async throws -> ArtistsTrackProvidersMultiDataRelationshipDocument {
		try await getArtistTrackProvidersRelationshipWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
			.execute().body
	}

	/// Relationship: track providers
	/// - GET /artists/{id}/relationships/trackProviders
	/// - Retrieve providers that have released tracks for this artist
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - OAuth:
	///  - type: oauth2
	///  - name: Client_Credentials
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter id: (path) TIDAL id of the artist
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// trackProviders (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: RequestBuilder<ArtistsTrackProvidersMultiDataRelationshipDocument>
	class func getArtistTrackProvidersRelationshipWithRequestBuilder(
		id: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) -> RequestBuilder<ArtistsTrackProvidersMultiDataRelationshipDocument> {
		var localVariablePath = "/artists/{id}/relationships/trackProviders"
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

		let localVariableRequestBuilder: RequestBuilder<ArtistsTrackProvidersMultiDataRelationshipDocument>
			.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

		return localVariableRequestBuilder.init(
			method: "GET",
			URLString: (localVariableUrlComponents?.string ?? localVariableURLString),
			parameters: localVariableParameters,
			headers: localVariableHeaderParameters,
			requiresAuthentication: true
		)
	}

	/// enum for parameter collapseBy
	public enum CollapseBy_getArtistTracksRelationship: String, CaseIterable {
		case fingerprint = "FINGERPRINT"
		case _none = "NONE"
	}

	/// Relationship: tracks
	///
	/// - parameter id: (path) TIDAL artist id
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter collapseBy: (query) Collapse by options for getting artist tracks. Available options: FINGERPRINT, ID.
	/// FINGERPRINT option might collapse similar tracks based item fingerprints while collapsing by ID always returns all available
	/// items. (optional, default to .fingerprint)
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// tracks (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: ArtistsMultiDataRelationshipDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getArtistTracksRelationship(
		id: String,
		countryCode: String,
		collapseBy: CollapseBy_getArtistTracksRelationship? = nil,
		include: [String]? = nil,
		pageCursor: String? = nil
	) async throws -> ArtistsMultiDataRelationshipDocument {
		try await getArtistTracksRelationshipWithRequestBuilder(
			id: id,
			countryCode: countryCode,
			collapseBy: collapseBy,
			include: include,
			pageCursor: pageCursor
		).execute().body
	}

	/// Relationship: tracks
	/// - GET /artists/{id}/relationships/tracks
	/// - Retrieve track details by related artist.
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - OAuth:
	///  - type: oauth2
	///  - name: Client_Credentials
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter id: (path) TIDAL artist id
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter collapseBy: (query) Collapse by options for getting artist tracks. Available options: FINGERPRINT, ID.
	/// FINGERPRINT option might collapse similar tracks based item fingerprints while collapsing by ID always returns all available
	/// items. (optional, default to .fingerprint)
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// tracks (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: RequestBuilder<ArtistsMultiDataRelationshipDocument>
	class func getArtistTracksRelationshipWithRequestBuilder(
		id: String,
		countryCode: String,
		collapseBy: CollapseBy_getArtistTracksRelationship? = nil,
		include: [String]? = nil,
		pageCursor: String? = nil
	) -> RequestBuilder<ArtistsMultiDataRelationshipDocument> {
		var localVariablePath = "/artists/{id}/relationships/tracks"
		let idPreEscape = "\(APIHelper.mapValueToPathItem(id))"
		let idPostEscape = idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
		localVariablePath = localVariablePath.replacingOccurrences(of: "{id}", with: idPostEscape, options: .literal, range: nil)
		let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
		let localVariableParameters: [String: Any]? = nil

		var localVariableUrlComponents = URLComponents(string: localVariableURLString)
		localVariableUrlComponents?.queryItems = APIHelper.mapValuesToQueryItems([
			"countryCode": (wrappedValue: countryCode.encodeToJSON(), isExplode: true),
			"collapseBy": (wrappedValue: collapseBy?.encodeToJSON(), isExplode: true),
			"include": (wrappedValue: include?.encodeToJSON(), isExplode: true),
			"page[cursor]": (wrappedValue: pageCursor?.encodeToJSON(), isExplode: true),
		])

		let localVariableNillableHeaders: [String: Any?] = [
			:
		]

		let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

		let localVariableRequestBuilder: RequestBuilder<ArtistsMultiDataRelationshipDocument>.Type = OpenAPIClientAPI
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
	/// - parameter id: (path) TIDAL artist id
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// videos (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: ArtistsMultiDataRelationshipDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getArtistVideosRelationship(
		id: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) async throws -> ArtistsMultiDataRelationshipDocument {
		try await getArtistVideosRelationshipWithRequestBuilder(
			id: id,
			countryCode: countryCode,
			include: include,
			pageCursor: pageCursor
		).execute().body
	}

	/// Relationship: videos
	/// - GET /artists/{id}/relationships/videos
	/// - Retrieve video details by related artist.
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - OAuth:
	///  - type: oauth2
	///  - name: Client_Credentials
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter id: (path) TIDAL artist id
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// videos (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: RequestBuilder<ArtistsMultiDataRelationshipDocument>
	class func getArtistVideosRelationshipWithRequestBuilder(
		id: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) -> RequestBuilder<ArtistsMultiDataRelationshipDocument> {
		var localVariablePath = "/artists/{id}/relationships/videos"
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

		let localVariableRequestBuilder: RequestBuilder<ArtistsMultiDataRelationshipDocument>.Type = OpenAPIClientAPI
			.requestBuilderFactory.getBuilder()

		return localVariableRequestBuilder.init(
			method: "GET",
			URLString: (localVariableUrlComponents?.string ?? localVariableURLString),
			parameters: localVariableParameters,
			headers: localVariableHeaderParameters,
			requiresAuthentication: true
		)
	}

	/// Get multiple artists
	///
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// albums, tracks, videos, similarArtists, trackProviders, radio (optional)
	/// - parameter filterId: (query) Allows to filter the collection of resources based on id attribute value (optional)
	/// - returns: ArtistsMultiDataDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getArtistsByFilters(
		countryCode: String,
		include: [String]? = nil,
		filterId: [String]? = nil
	) async throws -> ArtistsMultiDataDocument {
		try await getArtistsByFiltersWithRequestBuilder(countryCode: countryCode, include: include, filterId: filterId).execute()
			.body
	}

	/// Get multiple artists
	/// - GET /artists
	/// - Retrieve multiple artist details.
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
	/// albums, tracks, videos, similarArtists, trackProviders, radio (optional)
	/// - parameter filterId: (query) Allows to filter the collection of resources based on id attribute value (optional)
	/// - returns: RequestBuilder<ArtistsMultiDataDocument>
	class func getArtistsByFiltersWithRequestBuilder(
		countryCode: String,
		include: [String]? = nil,
		filterId: [String]? = nil
	) -> RequestBuilder<ArtistsMultiDataDocument> {
		let localVariablePath = "/artists"
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

		let localVariableRequestBuilder: RequestBuilder<ArtistsMultiDataDocument>.Type = OpenAPIClientAPI.requestBuilderFactory
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
