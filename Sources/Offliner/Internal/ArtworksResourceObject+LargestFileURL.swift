import Foundation
import TidalAPI

extension ArtworksResourceObject {
	var largestFileURL: URL? {
		attributes?.files
			.max { $0.area < $1.area }
			.flatMap { URL(string: $0.href) }
	}
}

private extension ArtworkFile {
	var area: Int {
		// Files without dimensions remain usable when no sized artwork is available.
		guard let meta else {
			return 0
		}
		return meta.width * meta.height
	}
}
