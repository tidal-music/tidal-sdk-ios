import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - UserEntitlementsAPI

class UserEntitlementsAPI {
	/// Get the current users entitlements
	///
	/// - parameter include: (query) Allows the client to customize which related resources should be returned (optional)
	/// - returns: UserEntitlementsSingleDataDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getMyUserEntitlements(include: [String]? = nil) async throws -> UserEntitlementsSingleDataDocument {
		try await getMyUserEntitlementsWithRequestBuilder(include: include).execute().body
	}

	/// Get the current users entitlements
	/// - GET /userEntitlements/me
	/// - Get the current users entitlements
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter include: (query) Allows the client to customize which related resources should be returned (optional)
	/// - returns: RequestBuilder<UserEntitlementsSingleDataDocument>
	class func getMyUserEntitlementsWithRequestBuilder(include: [String]? = nil)
		-> RequestBuilder<UserEntitlementsSingleDataDocument>
	{
		let localVariablePath = "/userEntitlements/me"
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

		let localVariableRequestBuilder: RequestBuilder<UserEntitlementsSingleDataDocument>.Type = OpenAPIClientAPI
			.requestBuilderFactory.getBuilder()

		return localVariableRequestBuilder.init(
			method: "GET",
			URLString: (localVariableUrlComponents?.string ?? localVariableURLString),
			parameters: localVariableParameters,
			headers: localVariableHeaderParameters,
			requiresAuthentication: true
		)
	}

	/// Get user entitlements for user
	///
	/// - parameter id: (path) User entitlements id
	/// - parameter include: (query) Allows the client to customize which related resources should be returned (optional)
	/// - returns: UserEntitlementsSingleDataDocument
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	class func getUserEntitlementsById(id: String, include: [String]? = nil) async throws -> UserEntitlementsSingleDataDocument {
		try await getUserEntitlementsByIdWithRequestBuilder(id: id, include: include).execute().body
	}

	/// Get user entitlements for user
	/// - GET /userEntitlements/{id}
	/// - Get user entitlements for user
	/// - OAuth:
	///  - type: oauth2
	///  - name: Authorization_Code_PKCE
	/// - responseHeaders: [X-RateLimit-Remaining(Int), X-RateLimit-Burst-Capacity(Int), X-RateLimit-Replenish-Rate(Int),
	/// X-RateLimit-Requested-Tokens(Int)]
	/// - parameter id: (path) User entitlements id
	/// - parameter include: (query) Allows the client to customize which related resources should be returned (optional)
	/// - returns: RequestBuilder<UserEntitlementsSingleDataDocument>
	class func getUserEntitlementsByIdWithRequestBuilder(
		id: String,
		include: [String]? = nil
	) -> RequestBuilder<UserEntitlementsSingleDataDocument> {
		var localVariablePath = "/userEntitlements/{id}"
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

		let localVariableRequestBuilder: RequestBuilder<UserEntitlementsSingleDataDocument>.Type = OpenAPIClientAPI
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
