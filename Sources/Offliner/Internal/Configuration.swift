import Foundation
import TidalAPI

public enum AudioFormat: String, CaseIterable, Codable {
	case heaacv1 = "HEAACV1"
	case aaclc = "AACLC"
	case flac = "FLAC"
	case flacHires = "FLAC_HIRES"
	case eac3Joc = "EAC3_JOC"

	var toAPIFormat: TrackManifestsAPITidal.Formats_trackManifestsIdGet {
		switch self {
		case .heaacv1: return .heaacv1
		case .aaclc: return .aaclc
		case .flac: return .flac
		case .flacHires: return .flacHires
		case .eac3Joc: return .eac3Joc
		}
	}
}

public struct Configuration {
	let audioFormats: [AudioFormat]
	let allowDownloadsOnExpensiveNetworks: Bool

	public init(audioFormats: [AudioFormat] = [.heaacv1], allowDownloadsOnExpensiveNetworks: Bool = true) {
		self.audioFormats = audioFormats
		self.allowDownloadsOnExpensiveNetworks = allowDownloadsOnExpensiveNetworks
	}
}
