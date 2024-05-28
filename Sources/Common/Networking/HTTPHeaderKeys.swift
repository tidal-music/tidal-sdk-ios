import Foundation

public enum HTTPHeaderKeys: String {
	case clientAuthKey = "x-tidal-token"
	case authorization
	case clientID = "client-id"
	case consentCategory = "consent-category"
	case timestamp = "requested-sent-timestamp"
	case deviceVendor = "device-vendor"
	case deviceModel = "device-model"
	case osName = "os-name"
	case osVersion = "os-version"
	case appName = "app-name"
	case appVersion = "app-version"
}
