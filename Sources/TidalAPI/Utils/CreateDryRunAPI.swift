import Foundation

public extension ArtistsAPITidal {
	/// Validates an artist creation without decoding a created resource from the successful response.
	static func artistsPostDryRun(
		idempotencyKey: String? = nil,
		artistsCreateOperationPayload: ArtistsCreateOperationPayload
	) async throws {
		var payload = artistsCreateOperationPayload
		if payload.meta == nil {
			payload.meta = ArtistsCreateOperationPayloadMeta()
		}
		payload.meta?.dryRun = true

		try await RequestHelper.createRequestIgnoringResponseBody {
			ArtistsAPI.artistsPostWithRequestBuilder(
				idempotencyKey: idempotencyKey,
				artistsCreateOperationPayload: payload
			)
		}
	}
}

public extension AppreciationsAPITidal {
	/// Validates an appreciation creation without decoding a created resource from the successful response.
	static func appreciationsPostDryRun(
		idempotencyKey: String? = nil,
		appreciationsCreateOperationPayload: AppreciationsCreateOperationPayload
	) async throws {
		var payload = appreciationsCreateOperationPayload
		if payload.meta == nil {
			payload.meta = AppreciationsCreateOperationPayloadMeta()
		}
		payload.meta?.dryRun = true

		try await RequestHelper.createRequestIgnoringResponseBody {
			AppreciationsAPI.appreciationsPostWithRequestBuilder(
				idempotencyKey: idempotencyKey,
				appreciationsCreateOperationPayload: payload
			)
		}
	}
}
