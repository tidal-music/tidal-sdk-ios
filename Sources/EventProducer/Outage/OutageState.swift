import Common
import Foundation

public enum OutageState {
	case outage(error: OutageStartError)
	case noOutage(message: OutageEndMessage)
}
