import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - AlbumsAPI

class AlbumsAPI {
	/// Relationship: artists
	///
	/// - parameter id: (path) TIDAL album id
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// artists (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: AlbumsMultiDataRelationshipDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getAlbumArtistsRelationship(
		id: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) async throws -> AlbumsMultiDataRelationshipDocument {
		try await getAlbumArtistsRelationshipWithRequestBuilder(
			id: id,
			countryCode: countryCode,
			include: include,
			pageCursor: pageCursor
		).execute().body
	}

	/// Relationship: artists
	/// - GET /albums/{id}/relationships/artists
	/// - Retrieve artist details of the related album.
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - OAuth:
	///  - type: oauth2
	///  - name: Client_Credentials
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter id: (path) TIDAL album id
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// artists (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: RequestBuilder<AlbumsMultiDataRelationshipDocument>
	class func getAlbumArtistsRelationshipWithRequestBuilder(
		id: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) -> RequestBuilder<AlbumsMultiDataRelationshipDocument> {
		var localVariablePath = "/albums/{id}/relationships/artists"
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

		let localVariableRequestBuilder: RequestBuilder<AlbumsMultiDataRelationshipDocument>.Type = OpenAPIClientAPI
			.requestBuilderFactory.getBuilder()

		return localVariableRequestBuilder.init(
			method: "GET",
			URLString: (localVariableUrlComponents?.string ?? localVariableURLString),
			parameters: localVariableParameters,
			headers: localVariableHeaderParameters,
			requiresAuthentication: true
		)
	}

	/// Get single album
	///
	/// - parameter id: (path) TIDAL album id
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// artists, items, providers, similarAlbums (optional)
	/// - returns: AlbumsSingleDataDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getAlbumById(id: String, countryCode: String, include: [String]? = nil) async throws -> AlbumsSingleDataDocument {
		try await getAlbumByIdWithRequestBuilder(id: id, countryCode: countryCode, include: include).execute().body
	}

	/// Get single album
	/// - GET /albums/{id}
	/// - Retrieve album details by TIDAL album id.
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - OAuth:
	///  - type: oauth2
	///  - name: Client_Credentials
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter id: (path) TIDAL album id
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// artists, items, providers, similarAlbums (optional)
	/// - returns: RequestBuilder<AlbumsSingleDataDocument>
	class func getAlbumByIdWithRequestBuilder(
		id: String,
		countryCode: String,
		include: [String]? = nil
	) -> RequestBuilder<AlbumsSingleDataDocument> {
		var localVariablePath = "/albums/{id}"
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

		let localVariableRequestBuilder: RequestBuilder<AlbumsSingleDataDocument>.Type = OpenAPIClientAPI.requestBuilderFactory
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
	/// - parameter id: (path) TIDAL album id
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// items (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: AlbumsMultiDataRelationshipDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getAlbumItemsRelationship(
		id: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) async throws -> AlbumsMultiDataRelationshipDocument {
		try await getAlbumItemsRelationshipWithRequestBuilder(
			id: id,
			countryCode: countryCode,
			include: include,
			pageCursor: pageCursor
		).execute().body
	}

	/// Relationship: items
	/// - GET /albums/{id}/relationships/items
	/// - Retrieve album item details.
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - OAuth:
	///  - type: oauth2
	///  - name: Client_Credentials
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter id: (path) TIDAL album id
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// items (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: RequestBuilder<AlbumsMultiDataRelationshipDocument>
	class func getAlbumItemsRelationshipWithRequestBuilder(
		id: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) -> RequestBuilder<AlbumsMultiDataRelationshipDocument> {
		var localVariablePath = "/albums/{id}/relationships/items"
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

		let localVariableRequestBuilder: RequestBuilder<AlbumsMultiDataRelationshipDocument>.Type = OpenAPIClientAPI
			.requestBuilderFactory.getBuilder()

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
	/// - parameter id: (path) TIDAL id of the album
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// providers (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: AlbumsMultiDataRelationshipDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getAlbumProvidersRelationship(
		id: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) async throws -> AlbumsMultiDataRelationshipDocument {
		try await getAlbumProvidersRelationshipWithRequestBuilder(
			id: id,
			countryCode: countryCode,
			include: include,
			pageCursor: pageCursor
		).execute().body
	}

	/// Relationship: providers
	/// - GET /albums/{id}/relationships/providers
	/// - This endpoint can be used to retrieve a list of album's related providers.
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - OAuth:
	///  - type: oauth2
	///  - name: Client_Credentials
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter id: (path) TIDAL id of the album
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// providers (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: RequestBuilder<AlbumsMultiDataRelationshipDocument>
	class func getAlbumProvidersRelationshipWithRequestBuilder(
		id: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) -> RequestBuilder<AlbumsMultiDataRelationshipDocument> {
		var localVariablePath = "/albums/{id}/relationships/providers"
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

		let localVariableRequestBuilder: RequestBuilder<AlbumsMultiDataRelationshipDocument>.Type = OpenAPIClientAPI
			.requestBuilderFactory.getBuilder()

		return localVariableRequestBuilder.init(
			method: "GET",
			URLString: (localVariableUrlComponents?.string ?? localVariableURLString),
			parameters: localVariableParameters,
			headers: localVariableHeaderParameters,
			requiresAuthentication: true
		)
	}

	/// Relationship: similar albums
	///
	/// - parameter id: (path) TIDAL id of the album
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// similarAlbums (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: AlbumsMultiDataRelationshipDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getAlbumSimilarAlbumsRelationship(
		id: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) async throws -> AlbumsMultiDataRelationshipDocument {
		try await getAlbumSimilarAlbumsRelationshipWithRequestBuilder(
			id: id,
			countryCode: countryCode,
			include: include,
			pageCursor: pageCursor
		).execute().body
	}

	/// Relationship: similar albums
	/// - GET /albums/{id}/relationships/similarAlbums
	/// - This endpoint can be used to retrieve a list of albums similar to the given album.
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - OAuth:
	///  - type: oauth2
	///  - name: Client_Credentials
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter id: (path) TIDAL id of the album
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// similarAlbums (optional)
	/// - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page
	/// if not specified (optional)
	/// - returns: RequestBuilder<AlbumsMultiDataRelationshipDocument>
	class func getAlbumSimilarAlbumsRelationshipWithRequestBuilder(
		id: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) -> RequestBuilder<AlbumsMultiDataRelationshipDocument> {
		var localVariablePath = "/albums/{id}/relationships/similarAlbums"
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

		let localVariableRequestBuilder: RequestBuilder<AlbumsMultiDataRelationshipDocument>.Type = OpenAPIClientAPI
			.requestBuilderFactory.getBuilder()

		return localVariableRequestBuilder.init(
			method: "GET",
			URLString: (localVariableUrlComponents?.string ?? localVariableURLString),
			parameters: localVariableParameters,
			headers: localVariableHeaderParameters,
			requiresAuthentication: true
		)
	}

	/// Get multiple albums
	///
	/// - parameter countryCode: (query) ISO 3166-1 alpha-2 country code
	/// - parameter include: (query) Allows the client to customize which related resources should be returned. Available options:
	/// artists, items, providers, similarAlbums (optional)
	/// - parameter filterId: (query) Allows to filter the collection of resources based on id attribute value (optional)
	/// - parameter filterBarcodeId: (query) Allows to filter the collection of resources based on barcodeId attribute value
	/// (optional)
	/// - returns: AlbumsMultiDataDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getAlbumsByFilters(
		countryCode: String,
		include: [String]? = nil,
		filterId: [String]? = nil,
		filterBarcodeId: [String]? = nil
	) async throws -> AlbumsMultiDataDocument {
		try await getAlbumsByFiltersWithRequestBuilder(
			countryCode: countryCode,
			include: include,
			filterId: filterId,
			filterBarcodeId: filterBarcodeId
		).execute().body
	}

	/// Get multiple albums
	/// - GET /albums
	/// - Retrieve multiple album details.
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
	/// artists, items, providers, similarAlbums (optional)
	/// - parameter filterId: (query) Allows to filter the collection of resources based on id attribute value (optional)
	/// - parameter filterBarcodeId: (query) Allows to filter the collection of resources based on barcodeId attribute value
	/// (optional)
	/// - returns: RequestBuilder<AlbumsMultiDataDocument>
	class func getAlbumsByFiltersWithRequestBuilder(
		countryCode: String,
		include: [String]? = nil,
		filterId: [String]? = nil,
		filterBarcodeId: [String]? = nil
	) -> RequestBuilder<AlbumsMultiDataDocument> {
		let localVariablePath = "/albums"
		let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
		let localVariableParameters: [String: Any]? = nil

		var localVariableUrlComponents = URLComponents(string: localVariableURLString)
		localVariableUrlComponents?.queryItems = APIHelper.mapValuesToQueryItems([
			"countryCode": (wrappedValue: countryCode.encodeToJSON(), isExplode: true),
			"include": (wrappedValue: include?.encodeToJSON(), isExplode: true),
			"filter[id]": (wrappedValue: filterId?.encodeToJSON(), isExplode: true),
			"filter[barcodeId]": (wrappedValue: filterBarcodeId?.encodeToJSON(), isExplode: true),
		])

		let localVariableNillableHeaders: [String: Any?] = [
			:
		]

		let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

		let localVariableRequestBuilder: RequestBuilder<AlbumsMultiDataDocument>.Type = OpenAPIClientAPI.requestBuilderFactory
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
