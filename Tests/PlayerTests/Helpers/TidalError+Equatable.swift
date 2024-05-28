import Common

extension TidalError: Equatable {
	public static func == (lhs: TidalError, rhs: TidalError) -> Bool {
		lhs.code == rhs.code &&
			lhs.message == rhs.message
	}
}
