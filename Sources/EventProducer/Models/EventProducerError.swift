import Foundation

enum EventProducerError: Error {
	/// event Errors
	case eventQueueDatabaseURLFailure
	case eventDatabaseCreateFailure(_ description: String)
	case eventAddFailure(_ description: String)
	case eventDeletionFailure(_ description: String)
	case eventSendBatchRequestFailure(_ description: String)
	case eventSendDataEncodingFailure
	case clientIdMissingFailure
	case authTokenMissingFailure(_ description: String)
	
	/// configuration errors
	case notConfigured

	/// networking errors
	case unauthorized(_ code: Int)

	/// monitoring errors
	case monitoringQueueDatabaseURLFailure
	case monitoringDatabaseCreateFailure(_ description: String)
	case monitoringSendEventFailure(_ description: String)
	case monitoringAddInfoFailure(_ description: String)
	case monitoringUpdateInfoFailure(_ description: String)

	case genericError(_ message: String)
}
