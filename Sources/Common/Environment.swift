import Foundation

public enum Environment {
	case development
	case production

	public static var system: Self {
		#if DEBUG
			return .development
		#else
			return .production
		#endif
	}
}
