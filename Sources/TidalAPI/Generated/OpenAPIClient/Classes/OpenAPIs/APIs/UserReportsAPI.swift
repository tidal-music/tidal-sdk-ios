//
// UserReportsAPI.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

internal class UserReportsAPI {

    /**
     Create single userReport.
     
     - parameter userReportCreateOperationPayload: (body)  (optional)
     - returns: UserReportsSingleDataDocument
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    internal class func userReportsPost(userReportCreateOperationPayload: UserReportCreateOperationPayload? = nil) async throws -> UserReportsSingleDataDocument {
        return try await userReportsPostWithRequestBuilder(userReportCreateOperationPayload: userReportCreateOperationPayload).execute().body
    }

    /**
     Create single userReport.
     - POST /userReports
     - Creates a new userReport.
     - OAuth:
       - type: oauth2
       - name: Authorization_Code_PKCE
     - parameter userReportCreateOperationPayload: (body)  (optional)
     - returns: RequestBuilder<UserReportsSingleDataDocument> 
     */
    internal class func userReportsPostWithRequestBuilder(userReportCreateOperationPayload: UserReportCreateOperationPayload? = nil) -> RequestBuilder<UserReportsSingleDataDocument> {
        let localVariablePath = "/userReports"
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters = JSONEncodingHelper.encodingParameters(forEncodableObject: userReportCreateOperationPayload)

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            "Content-Type": "application/vnd.api+json",
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<UserReportsSingleDataDocument>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "POST", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }
}
