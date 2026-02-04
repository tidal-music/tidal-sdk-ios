import Auth
import AVFoundation
import Foundation
import TidalAPI

final class LicenseFetcher {
	private static let certificateURL = URL(string: "https://fp.fa.tidal.com/certificate")!
	private static let licenseURL = URL(string: "https://fp.fa.tidal.com/license")!

	private let httpClient: HttpClient
	private var certificate: Data?

	init() {
		self.httpClient = HttpClient()
	}

	func getLicense(for keyRequest: AVPersistableContentKeyRequest) async throws -> Data {
		let spc = try await createSpc(keyRequest: keyRequest)
		let license = try await fetchLicense(spc: spc)

		return try keyRequest.persistableContentKey(fromKeyVendorResponse: license)
	}
}

private extension LicenseFetcher {
	func createSpc(keyRequest: AVContentKeyRequest) async throws -> Data {
		let keyId = try keyRequest.getKeyId()
		let certificate = try await getCertificate()
		return try await keyRequest.makeStreamingContentKeyRequestData(forApp: certificate, contentIdentifier: keyId)
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
		guard let credentialsProvider = OpenAPIClientAPI.credentialsProvider else {
			throw LicenseFetcherError.missingCredentialsProvider
		}

		guard let token = try await credentialsProvider.getCredentials().token else {
			throw LicenseFetcherError.missingAccessToken
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

enum LicenseFetcherError: Error {
	case emptyLicensePayload
	case missingCredentialsProvider
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
			throw LicenseFetcherError.invalidKeyIdentifier
		}
		return keyId
	}
}
