import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `ReactionsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await ReactionsAPITidal.getResource()
/// ```
public enum ReactionsAPITidal {


	/**
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_reactionsGet: String, CaseIterable {
		case author = "author"
		case owners = "owners"
		case subject = "subject"

		func toReactionsAPIEnum() -> ReactionsAPI.IncludeLinkage_reactionsGet {
			switch self {
			case .author: return .author
			case .owners: return .owners
			case .subject: return .subject
			}
		}
	}

	/**
     Get multiple reactions.
     
     - returns: ReactionsMultiResourceDataDocument
     */
	public static func reactionsGet(filterSubject: String, filterEmoji: [String]? = nil, include: [String]? = nil, includeLinkage: [ReactionsAPITidal.IncludeLinkage_reactionsGet]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil) async throws -> ReactionsMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			ReactionsAPI.reactionsGetWithRequestBuilder(filterSubject: filterSubject, filterEmoji: filterEmoji, include: include, includeLinkage: includeLinkage?.compactMap { $0.toReactionsAPIEnum() }, pageCursor: pageCursor, replaceMedia: replaceMedia)
		}
	}


	/**
     Delete single reaction.
     
     - returns: MutationResponseDocument
     */
	public static func reactionsIdDelete(id: String, idempotencyKey: String? = nil) async throws -> MutationResponseDocument {
		return try await RequestHelper.createRequest {
			ReactionsAPI.reactionsIdDeleteWithRequestBuilder(id: id, idempotencyKey: idempotencyKey)
		}
	}


	/**
     Get author relationship (\&quot;to-one\&quot;).
     
     - returns: ReactionsAuthorSingleRelationshipDataDocument
     */
	public static func reactionsIdRelationshipsAuthorGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> ReactionsAuthorSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ReactionsAPI.reactionsIdRelationshipsAuthorGetWithRequestBuilder(id: id, include: include, replaceMedia: replaceMedia)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: ReactionsOwnersMultiRelationshipDataDocument
     */
	public static func reactionsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> ReactionsOwnersMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ReactionsAPI.reactionsIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get subject relationship (\&quot;to-one\&quot;).
     
     - returns: ReactionsSubjectSingleRelationshipDataDocument
     */
	public static func reactionsIdRelationshipsSubjectGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> ReactionsSubjectSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ReactionsAPI.reactionsIdRelationshipsSubjectGetWithRequestBuilder(id: id, include: include, replaceMedia: replaceMedia)
		}
	}


	/**
     Create single reaction.
     
     - returns: ReactionsCreateSingleResourceDataDocument
     */
	public static func reactionsPost(idempotencyKey: String? = nil, reactionsCreateOperationPayload: ReactionsCreateOperationPayload? = nil) async throws -> ReactionsCreateSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			ReactionsAPI.reactionsPostWithRequestBuilder(idempotencyKey: idempotencyKey, reactionsCreateOperationPayload: reactionsCreateOperationPayload)
		}
	}
}
