import Common
import Foundation

public enum OutageState {
	case outageStart(error: OutageStartError)
	case outageEnd(message: OutageEndMessage)
}
