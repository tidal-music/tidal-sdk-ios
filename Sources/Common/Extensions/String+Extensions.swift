import Foundation

extension String {
	/// Returns a percent-escaped string following RFC 3986 for a query string key or value.
	///
	/// RFC 3986 states that the following characters are "reserved" characters.
	///
	/// - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
	/// - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
	///
	/// In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
	/// query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
	/// should be percent-escaped in the query string.
	///
	/// - returns: percent-escaped string.
	public func encoded() -> String {
		let generalDelimitersToEncode = ":#[]@"
		let subDelimitersToEncode = "!$&'()*+,;="
		var allowedCharacterSet = CharacterSet.urlQueryAllowed
		allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
		return self.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? ""
	}
	
	public func base64WithPadding() -> String {
		let offset = count % 4
		guard offset != 0 else { return self }
		return padding(toLength: count + 4 - offset, withPad: "=", startingAt: 0)
	}
}
