import Auth
import AVFoundation
import Foundation

final class LicenseRepository {
	private static let certificateURL = URL(string: "https://fp.fa.tidal.com/certificate")!
	private static let licenseURL = URL(string: "https://fp.fa.tidal.com/license")!

	private let credentialsProvider: CredentialsProvider
	private let httpClient: HttpClient
	private var certificate: Data?

	init(credentialsProvider: CredentialsProvider) {
		self.credentialsProvider = credentialsProvider
		self.httpClient = HttpClient()
	}

	func getLicense(for keyRequest: AVPersistableContentKeyRequest) async throws -> Data {
		let spc = try await createSpc(keyRequest: keyRequest)
		let license = try await fetchLicense(spc: spc)

		return try keyRequest.persistableContentKey(fromKeyVendorResponse: license)
	}
}

private extension LicenseRepository {
	func createSpc(keyRequest: AVContentKeyRequest) async throws -> Data {
		let keyId = try keyRequest.getKeyId()
		let certificate = try await getCertificate()
		return try await keyRequest.createServerPlaybackContext(for: keyId, using: certificate)
	}

	func getCertificate() async throws -> Data {
		if let certificate {
			return certificate
		}

		let data = try await httpClient.get(url: Self.certificateURL, headers: [:])
		self.certificate = data
		return data
	}

	func fetchLicense(spc: Data) async throws -> Data {
		guard let token = try await credentialsProvider.getCredentials().token else {
			throw LicenseRepositoryError.missingAccessToken
		}

		let data = try await httpClient.post(
			url: Self.licenseURL,
			headers: [
				"Authorization": token,
				"Content-Type": "application/octet-stream"
			],
			body: spc
		)

		return data
	}
}

// MARK: - HttpClient

private final class HttpClient {
	private let urlSession: URLSession

	init(urlSession: URLSession = .shared) {
		self.urlSession = urlSession
	}

	func get(url: URL, headers: [String: String]) async throws -> Data {
		let request = createRequest(method: "GET", url: url, headers: headers)
		return try await perform(request)
	}

	func post(url: URL, headers: [String: String], body: Data?) async throws -> Data {
		var request = createRequest(method: "POST", url: url, headers: headers)
		request.httpBody = body
		return try await perform(request)
	}

	private func createRequest(method: String, url: URL, headers: [String: String]) -> URLRequest {
		var request = URLRequest(url: url)
		request.httpMethod = method
		headers.forEach { name, value in
			request.addValue(value, forHTTPHeaderField: name)
		}
		return request
	}

	private func perform(_ request: URLRequest) async throws -> Data {
		let (data, response) = try await urlSession.data(for: request)

		guard let httpResponse = response as? HTTPURLResponse else {
			throw HttpClientError.noResponse
		}

		guard (200 ... 299).contains(httpResponse.statusCode) else {
			if (400 ... 499).contains(httpResponse.statusCode) {
				throw HttpClientError.clientError(statusCode: httpResponse.statusCode)
			} else {
				throw HttpClientError.serverError(statusCode: httpResponse.statusCode)
			}
		}

		guard !data.isEmpty else {
			throw HttpClientError.emptyResponse
		}

		return data
	}
}

private enum HttpClientError: Error {
	case noResponse
	case emptyResponse
	case clientError(statusCode: Int)
	case serverError(statusCode: Int)
}

enum LicenseRepositoryError: Error {
	case emptyLicensePayload
	case missingAccessToken
	case licenseRequestFailed
	case invalidKeyIdentifier
}

extension AVContentKeyRequest {
	func getKeyId() throws -> Data {
		guard
			let identifier = identifier as? String,
			let url = URL(string: identifier),
			let keyId = url.host?.data(using: .utf8)
		else {
			throw LicenseRepositoryError.invalidKeyIdentifier
		}
		return keyId
	}

	func createServerPlaybackContext(for keyId: Data, using certificate: Data) async throws -> Data {
		try await withCheckedThrowingContinuation { continuation in
			makeStreamingContentKeyRequestData(
				forApp: certificate,
				contentIdentifier: keyId,
				options: [AVContentKeyRequestProtocolVersionsKey: [1]]
			) { data, error in
				if let error {
					continuation.resume(throwing: error)
				} else if let data {
					continuation.resume(returning: data)
				} else {
					continuation.resume(throwing: LicenseRepositoryError.emptyLicensePayload)
				}
			}
		}
	}
}
