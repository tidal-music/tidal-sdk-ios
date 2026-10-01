import Foundation

public typealias PlayerAssetPresentation = AssetPresentation

// MARK: - AssetPresentation

public enum AssetPresentation: String, Codable {
	case FULL
	case PREVIEW
}
