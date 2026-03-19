import Auth
import AVFoundation
import Foundation
import TidalAPI

// MARK: - LicenseDownloadResult

struct LicenseDownloadResult {
	let contentKeySession: AVContentKeySession
	let licenseURL: URL
}

// MARK: - LicenseDownloader

actor LicenseDownloader {
	private let httpClient: HttpClient
	private let queue = DispatchQueue(label: "com.tidal.offliner.license-downloader")

	init() {
		self.httpClient = HttpClient()
	}

	func downloadLicense(drmData: DrmData?) async throws -> LicenseDownloadResult? {
		guard let keyIdentifier = drmData?.initData?.first,
			  let certificateURLString = drmData?.certificateUrl,
			  let certificateURL = URL(string: certificateURLString),
			  let licenseURLString = drmData?.licenseUrl,
			  let licenseURL = URL(string: licenseURLString)
		else {
			return nil
		}

		let contentKeySession = AVContentKeySession(keySystem: .fairPlayStreaming)
		let delegate = ActiveLicenseDownload(
			httpClient: httpClient,
			certificateURL: certificateURL,
			licenseURL: licenseURL
		)

		let storedLicenseURL: URL = try await withCheckedThrowingContinuation { continuation in
			self.queue.async {
				delegate.continuation = continuation
				contentKeySession.setDelegate(delegate, queue: self.queue)
				contentKeySession.processContentKeyRequest(
					withIdentifier: keyIdentifier,
					initializationData: nil,
					options: nil
				)
			}
		}

		return LicenseDownloadResult(contentKeySession: contentKeySession, licenseURL: storedLicenseURL)
	}
}

// MARK: - ActiveLicenseDownload

private final class ActiveLicenseDownload: NSObject {
	let httpClient: HttpClient
	let certificateURL: URL
	let licenseURL: URL
	var continuation: CheckedContinuation<URL, Error>?

	init(httpClient: HttpClient, certificateURL: URL, licenseURL: URL) {
		self.httpClient = httpClient
		self.certificateURL = certificateURL
		self.licenseURL = licenseURL
	}
}

// MARK: - AVContentKeySessionDelegate

extension ActiveLicenseDownload: AVContentKeySessionDelegate {
	func contentKeySession(
		_ session: AVContentKeySession,
		didProvide keyRequest: AVContentKeyRequest
	) {
		do {
			try keyRequest.respondByRequestingPersistableContentKeyRequest()
		} catch {
			keyRequest.processContentKeyResponseError(error)
		}
	}

	func contentKeySession(
		_ session: AVContentKeySession,
		didProvide keyRequest: AVPersistableContentKeyRequest
	) {
		Task {
			do {
				let spc = try await createSpc(keyRequest: keyRequest)
				let license = try await fetchLicense(spc: spc)
				let persistableKey = try keyRequest.persistableContentKey(fromKeyVendorResponse: license)

				let url = try FileStorage.store(
					persistableKey,
					subdirectory: "Licenses",
					filename: "\(UUID().uuidString).key"
				)

				let keyResponse = AVContentKeyResponse(fairPlayStreamingKeyResponseData: persistableKey)
				keyRequest.processContentKeyResponse(keyResponse)

				continuation?.resume(returning: url)
				continuation = nil
			} catch {
				keyRequest.processContentKeyResponseError(error)
				continuation?.resume(throwing: error)
				continuation = nil
			}
		}
	}

	func contentKeySession(
		_ session: AVContentKeySession,
		contentKeyRequest keyRequest: AVContentKeyRequest,
		didFailWithError error: Error
	) {
		continuation?.resume(throwing: error)
		continuation = nil
	}
}

private extension ActiveLicenseDownload {
	func createSpc(keyRequest: AVContentKeyRequest) async throws -> Data {
		let keyId = try keyRequest.getKeyId()
		let certificate = try await getCertificate()
		return try await keyRequest.makeStreamingContentKeyRequestData(forApp: certificate, contentIdentifier: keyId)
	}

	func getCertificate() async throws -> Data {
		try await httpClient.get(url: certificateURL, headers: [:])
	}

	func fetchLicense(spc: Data) async throws -> Data {
		guard let credentialsProvider = OpenAPIClientAPI.credentialsProvider else {
			throw LicenseDownloaderError.missingCredentialsProvider
		}

		guard let token = try await credentialsProvider.getCredentials().token else {
			throw LicenseDownloaderError.missingAccessToken
		}

		return try await httpClient.post(
			url: licenseURL,
			headers: [
				"Authorization": "Bearer \(token)",
				"Content-Type": "application/octet-stream"
			],
			body: spc
		)
	}
}

// MARK: - HttpClient

final class HttpClient {
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

enum LicenseDownloaderError: Error {
	case missingCredentialsProvider
	case missingAccessToken
	case invalidKeyIdentifier
}

extension AVContentKeyRequest {
	func getKeyId() throws -> Data {
		guard
			let identifier = identifier as? String,
			let url = URL(string: identifier),
			let keyId = url.host?.data(using: .utf8)
		else {
			throw LicenseDownloaderError.invalidKeyIdentifier
		}
		return keyId
	}
}
