import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - ProvidersAPI

class ProvidersAPI {
	/// Get single provider
	///
	/// - parameter id: (path) TIDAL provider id
	/// - parameter include: (query) Allows the client to customize which related resources should be returned (optional)
	/// - returns: ProvidersSingleDataDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getProviderById(id: String, include: [String]? = nil) async throws -> ProvidersSingleDataDocument {
		try await getProviderByIdWithRequestBuilder(id: id, include: include).execute().body
	}

	/// Get single provider
	/// - GET /providers/{id}
	/// - Retrieve provider details by TIDAL provider id.
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - OAuth:
	///  - type: oauth2
	///  - name: Client_Credentials
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter id: (path) TIDAL provider id
	/// - parameter include: (query) Allows the client to customize which related resources should be returned (optional)
	/// - returns: RequestBuilder<ProvidersSingleDataDocument>
	class func getProviderByIdWithRequestBuilder(
		id: String,
		include: [String]? = nil
	) -> RequestBuilder<ProvidersSingleDataDocument> {
		var localVariablePath = "/providers/{id}"
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

		let localVariableRequestBuilder: RequestBuilder<ProvidersSingleDataDocument>.Type = OpenAPIClientAPI.requestBuilderFactory
			.getBuilder()

		return localVariableRequestBuilder.init(
			method: "GET",
			URLString: (localVariableUrlComponents?.string ?? localVariableURLString),
			parameters: localVariableParameters,
			headers: localVariableHeaderParameters,
			requiresAuthentication: true
		)
	}

	/// Get multiple providers
	///
	/// - parameter include: (query) Allows the client to customize which related resources should be returned (optional)
	/// - parameter filterId: (query) provider id (optional)
	/// - returns: ProvidersMultiDataDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getProvidersByFilters(
		include: [String]? = nil,
		filterId: [String]? = nil
	) async throws -> ProvidersMultiDataDocument {
		try await getProvidersByFiltersWithRequestBuilder(include: include, filterId: filterId).execute().body
	}

	/// Get multiple providers
	/// - GET /providers
	/// - Retrieve multiple provider details.
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - OAuth:
	///  - type: oauth2
	///  - name: Client_Credentials
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter include: (query) Allows the client to customize which related resources should be returned (optional)
	/// - parameter filterId: (query) provider id (optional)
	/// - returns: RequestBuilder<ProvidersMultiDataDocument>
	class func getProvidersByFiltersWithRequestBuilder(
		include: [String]? = nil,
		filterId: [String]? = nil
	) -> RequestBuilder<ProvidersMultiDataDocument> {
		let localVariablePath = "/providers"
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

		let localVariableRequestBuilder: RequestBuilder<ProvidersMultiDataDocument>.Type = OpenAPIClientAPI.requestBuilderFactory
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
