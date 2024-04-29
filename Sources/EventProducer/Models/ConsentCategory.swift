import Foundation

/// Consent categories allow the end user to control how the app can use information gathered via events.
/// Each event belongs to one consent category, and the user can opt out a consent category.
/// - Parameters:
///   - necessary: The event is considered strictly necessary. End users cannot opt out of strictly necessary events.
///   - targeting: The event is used e.g. for advertisement. End users can opt out of targeting events. *Also called advertising*.
///   - performance: The event is used e.g. for tracking the performance and usage of the app. End users can opt out of
/// performance events. *Also called analytics*.
public enum ConsentCategory: String, Codable {
	case necessary = "NECESSARY"
	case targeting = "TARGETING"
	case performance = "PERFORMANCE"
}
