import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `ResourceSharingSettingsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await ResourceSharingSettingsAPITidal.getResource()
/// ```
public enum ResourceSharingSettingsAPITidal {


	/**
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_resourceSharingSettingsGet: String, CaseIterable {
		case grants = "grants"
		case shares = "shares"
		case subject = "subject"

		func toResourceSharingSettingsAPIEnum() -> ResourceSharingSettingsAPI.IncludeLinkage_resourceSharingSettingsGet {
			switch self {
			case .grants: return .grants
			case .shares: return .shares
			case .subject: return .subject
			}
		}
	}

	/**
     Get multiple resourceSharingSettings.
     
     - returns: ResourceSharingSettingsMultiResourceDataDocument
     */
	public static func resourceSharingSettingsGet(filterSubject: [String], include: [String]? = nil, includeLinkage: [ResourceSharingSettingsAPITidal.IncludeLinkage_resourceSharingSettingsGet]? = nil, replaceMedia: String? = nil) async throws -> ResourceSharingSettingsMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			ResourceSharingSettingsAPI.resourceSharingSettingsGetWithRequestBuilder(filterSubject: filterSubject, include: include, includeLinkage: includeLinkage?.compactMap { $0.toResourceSharingSettingsAPIEnum() }, replaceMedia: replaceMedia)
		}
	}


	/**
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_resourceSharingSettingsIdGet: String, CaseIterable {
		case grants = "grants"
		case shares = "shares"
		case subject = "subject"

		func toResourceSharingSettingsAPIEnum() -> ResourceSharingSettingsAPI.IncludeLinkage_resourceSharingSettingsIdGet {
			switch self {
			case .grants: return .grants
			case .shares: return .shares
			case .subject: return .subject
			}
		}
	}

	/**
     Get single resourceSharingSetting.
     
     - returns: ResourceSharingSettingsSingleResourceDataDocument
     */
	public static func resourceSharingSettingsIdGet(id: String, include: [String]? = nil, includeLinkage: [ResourceSharingSettingsAPITidal.IncludeLinkage_resourceSharingSettingsIdGet]? = nil, replaceMedia: String? = nil) async throws -> ResourceSharingSettingsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			ResourceSharingSettingsAPI.resourceSharingSettingsIdGetWithRequestBuilder(id: id, include: include, includeLinkage: includeLinkage?.compactMap { $0.toResourceSharingSettingsAPIEnum() }, replaceMedia: replaceMedia)
		}
	}


	/**
     Get grants relationship (\&quot;to-many\&quot;).
     
     - returns: ResourceSharingSettingsGrantsMultiRelationshipDataDocument
     */
	public static func resourceSharingSettingsIdRelationshipsGrantsGet(id: String, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil) async throws -> ResourceSharingSettingsGrantsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ResourceSharingSettingsAPI.resourceSharingSettingsIdRelationshipsGrantsGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia)
		}
	}


	/**
     Get shares relationship (\&quot;to-many\&quot;).
     
     - returns: ResourceSharingSettingsSharesMultiRelationshipDataDocument
     */
	public static func resourceSharingSettingsIdRelationshipsSharesGet(id: String, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil) async throws -> ResourceSharingSettingsSharesMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ResourceSharingSettingsAPI.resourceSharingSettingsIdRelationshipsSharesGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia)
		}
	}


	/**
     Get subject relationship (\&quot;to-one\&quot;).
     
     - returns: ResourceSharingSettingsSubjectSingleRelationshipDataDocument
     */
	public static func resourceSharingSettingsIdRelationshipsSubjectGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> ResourceSharingSettingsSubjectSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ResourceSharingSettingsAPI.resourceSharingSettingsIdRelationshipsSubjectGetWithRequestBuilder(id: id, include: include, replaceMedia: replaceMedia)
		}
	}
}
