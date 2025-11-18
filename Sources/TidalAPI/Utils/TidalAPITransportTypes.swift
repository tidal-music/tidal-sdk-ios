import Foundation

// MARK: - Internal Transport Types

/// Internal transport type for successful HTTP responses (2xx, 3xx).
/// Contains raw response data without any decoding.
/// The transport layer returns this to allow the application layer to decode as needed.
struct HTTPSuccessResponse {
	let statusCode: Int       // Convenience field to avoid repeated casting
	let response: URLResponse // Full response with headers and metadata
	let data: Data?          // Raw body from URLSession (nil for 204 No Content)
}

/// Internal transport type for HTTP error responses (4xx, 5xx).
/// Contains raw response data without any decoding.
/// Conforms to Error so it can be thrown.
public struct HTTPErrorResponse: Error {
	public let statusCode: Int       // Convenience field for retry logic
	public let response: URLResponse // Full response with headers and metadata
	public let data: Data?          // Raw body from URLSession (may be nil)
}

public extension HTTPErrorResponse {
    /// Does not throw to simplify usage when already in a catch block
    func errorObject() -> ErrorObject? {
        guard let data else {
            return nil
        }

        do {
            let errorsDocument = try JSONDecoder().decode(ErrorsDocument.self, from: data)
            return errorsDocument.errors?.first
        } catch {
            return nil
        }
    }
}
