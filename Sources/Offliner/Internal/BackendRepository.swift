import Auth
import Foundation
import TidalAPI

// MARK: - OfflineTask

struct OfflineTask {
	let taskId: String
	let type: String
	let resourceId: String
	let action: OfflineTaskAction
	let state: OfflineTaskState?
	let index: Int?
	let volume: Int?
	let collectionId: String?
}

enum OfflineTaskAction {
	case storeItem
	case removeItem
	case storeCollection
	case removeCollection
}

// MARK: - BackendRepository

final class BackendRepository {
	private let installationId: String

	init(credentialsProvider: CredentialsProvider, installationId: String) {
		if OpenAPIClientAPI.credentialsProvider == nil {
			OpenAPIClientAPI.credentialsProvider = credentialsProvider
		}

		self.installationId = installationId
	}

	func addItem(type: ResourceType, id: String) async throws {
		let identifier = InstallationsOfflineInventoryItemIdentifier(id: id, type: mapResourceType(type))
		let payload = InstallationsOfflineInventoryAddPayload(data: [identifier])

		try await InstallationsAPITidal.installationsIdRelationshipsOfflineInventoryPost(
			id: installationId,
			installationsOfflineInventoryAddPayload: payload
		)
	}

	func removeItem(type: ResourceType, id: String) async throws {
		let identifier = InstallationsOfflineInventoryItemIdentifier(id: id, type: mapResourceType(type))
		let payload = InstallationsOfflineInventoryRemovePayload(data: [identifier])

		try await InstallationsAPITidal.installationsIdRelationshipsOfflineInventoryDelete(
			id: installationId,
			installationsOfflineInventoryRemovePayload: payload
		)
	}

	func getTasks(cursor: String?) async throws -> (tasks: [OfflineTask], cursor: String?) {
		let response = try await OfflineTasksAPITidal.offlineTasksGet(
			pageCursor: cursor,
			filterInstallationId: [installationId]
		)

		let tasks = response.data.compactMap { resourceObject -> OfflineTask? in
			guard let attributes = resourceObject.attributes,
				  let itemData = resourceObject.relationships?.item.data
			else {
				return nil
			}

			return OfflineTask(
				taskId: resourceObject.id,
				type: itemData.type,
				resourceId: itemData.id,
				action: mapAction(attributes.action),
				state: mapState(attributes.state),
				index: attributes.index,
				volume: attributes.volume,
				collectionId: nil
			)
		}

		return (tasks, response.links.meta?.nextCursor)
	}

	func updateTask(taskId: String, state: OfflineTaskState) async throws {
		let attributes = OfflineTasksUpdateOperationPayloadDataAttributes(state: mapTaskState(state))
		let data = OfflineTasksUpdateOperationPayloadData(
			attributes: attributes,
			id: taskId,
			type: .offlinetasks
		)
		let payload = OfflineTasksUpdateOperationPayload(data: data)

		try await OfflineTasksAPITidal.offlineTasksIdPatch(
			id: taskId,
			offlineTasksUpdateOperationPayload: payload
		)
	}
}

// MARK: - Private Helpers

private extension BackendRepository {
	func mapResourceType(_ type: ResourceType) -> InstallationsOfflineInventoryItemIdentifier.ModelType {
		switch type {
		case .track:
			return .tracks
		case .video:
			return .videos
		case .album:
			return .albums
		case .playlist:
			return .playlists
		case .userCollection:
			return .userCollection
		}
	}

	func mapTaskState(_ state: OfflineTaskState) -> OfflineTasksUpdateOperationPayloadDataAttributes.State {
		switch state {
		case .pending, .inProgress:
			return .inProgress
		case .failed:
			return .failed
		case .completed:
			return .completed
		}
	}

	func mapAction(_ action: OfflineTasksAttributes.Action) -> OfflineTaskAction {
		switch action {
		case .storeItem:
			return .storeItem
		case .removeItem:
			return .removeItem
		case .storeCollection:
			return .storeCollection
		case .removeCollection:
			return .removeCollection
		}
	}

	func mapState(_ state: OfflineTasksAttributes.State?) -> OfflineTaskState? {
		guard let state else { return nil }
		switch state {
		case .pending:
			return .pending
		case .inProgress:
			return .inProgress
		case .failed:
			return .failed
		case .completed:
			return .completed
		}
	}
}
