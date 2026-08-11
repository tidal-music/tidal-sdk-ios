import Foundation

// MARK: - InternalOfflineResourceAction

enum InternalOfflineResourceAction: String, Sendable {
	case store
	case remove

	var publicAction: OfflineResourceAction {
		switch self {
		case .store: .download
		case .remove: .remove
		}
	}
}

// MARK: - StoredResourceOperation

struct StoredResourceOperation: Sendable {
	let action: InternalOfflineResourceAction
	let state: OfflineResourceState
}

// MARK: - OfflineResourceKey

struct OfflineResourceKey: Hashable, Sendable {
	let resourceType: String
	let resourceId: String

	init(_ resource: OfflineResource) {
		switch resource {
		case let .media(type, resourceId):
			self.init(resourceType: type.rawValue, resourceId: resourceId)
		case let .collection(type, resourceId):
			self.init(
				resourceType: type.rawValue,
				resourceId: type == .userCollectionTracks ? ResourceId.me.stringValue : resourceId
			)
		}
	}

	init(resourceType: String, resourceId: String) {
		self.resourceType = resourceType
		self.resourceId = resourceType == OfflineCollectionType.userCollectionTracks.rawValue
			? ResourceId.me.stringValue
			: resourceId
	}
}

// MARK: - ResourceStateTracker

actor ResourceStateTracker {
	private struct TaskState {
		let action: InternalOfflineResourceAction
		var state: OfflineResourceState
		let resources: Set<OfflineResourceKey>
	}

	private let offlineStore: OfflineStore
	private var taskStates: [String: TaskState] = [:]
	private var transientStates: [OfflineResourceKey: (InternalOfflineResourceAction, OfflineResourceState)] = [:]
	private var continuations: [OfflineResourceKey: [UUID: AsyncStream<OfflineResourceState>.Continuation]] = [:]
	private var lastEmittedStates: [OfflineResourceKey: OfflineResourceState] = [:]
	private var isShutdown = false

	init(offlineStore: OfflineStore) {
		self.offlineStore = offlineStore
	}

	func state(for resource: OfflineResourceKey) throws -> OfflineResourceState? {
		guard !isShutdown else {
			return nil
		}
		if let state = effectiveState(for: resource) {
			return state
		}
		return try offlineStore.getResourceOperation(
			resourceType: resource.resourceType,
			resourceId: resource.resourceId
		)?.state
	}

	func observe(_ resource: OfflineResourceKey) -> AsyncStream<OfflineResourceState> {
		guard !isShutdown else {
			return AsyncStream { $0.finish() }
		}
		return AsyncStream { continuation in
			let id = UUID()
			continuations[resource, default: [:]][id] = continuation
			if let state = effectiveState(for: resource) ?? (try? offlineStore.getResourceOperation(
				resourceType: resource.resourceType,
				resourceId: resource.resourceId
			))?.state {
				continuation.yield(state)
			}
			continuation.onTermination = { [weak self] _ in
				Task { await self?.removeContinuation(id, for: resource) }
			}
		}
	}

	func begin(_ action: InternalOfflineResourceAction, for resource: OfflineResourceKey) throws -> Bool {
		guard !isShutdown else {
			return false
		}
		let activeTasks = taskStates.values.filter { $0.resources.contains(resource) && $0.state.isActiveOperation }
		if let activeTask = activeTasks.max(by: { $0.state.priority < $1.state.priority }) {
			if activeTask.action == action {
				return false
			}
			throw OfflineResourceOperationError.conflictingOperationInProgress(currentState: activeTask.state)
		}
		let current: OfflineResourceState? = if let state = effectiveState(for: resource) {
			state
		} else {
			try offlineStore.getResourceOperation(
				resourceType: resource.resourceType,
				resourceId: resource.resourceId
			)?.state
		}

		if let current {
			switch (action, current) {
			case (.store, .queued), (.store, .downloading), (.remove, .removing):
				return false
			case (.store, .removing), (.remove, .queued), (.remove, .downloading):
				throw OfflineResourceOperationError.conflictingOperationInProgress(currentState: current)
			default:
				break
			}
		}
		taskStates = taskStates.filter { _, task in
			!task.resources.contains(resource) || task.state.isActiveOperation
		}

		let state: OfflineResourceState = action == .store ? .queued : .removing
		transientStates[resource] = (action, state)
		do {
			try offlineStore.setResourceOperation(
				resourceType: resource.resourceType,
				resourceId: resource.resourceId,
				action: action,
				state: state
			)
		} catch {
			transientStates.removeValue(forKey: resource)
			throw error
		}
		emitChanges(for: [resource])
		return true
	}

	func registrationFailed(_ action: InternalOfflineResourceAction, for resource: OfflineResourceKey) {
		setTransient(action: action, state: .failed(action: action.publicAction), for: resource, persist: true)
	}

	func resolve(_ resource: OfflineResourceKey, state: OfflineResourceState) {
		guard !isShutdown else {
			return
		}
		transientStates[resource] = (.store, state)
		try? offlineStore.deleteResourceOperation(resourceType: resource.resourceType, resourceId: resource.resourceId)
		emitChanges(for: [resource])
	}

	func record(
		taskId: String,
		action: InternalOfflineResourceAction,
		state: OfflineResourceState,
		resources: Set<OfflineResourceKey>
	) {
		guard !isShutdown else {
			return
		}
		let affected = resources.union(taskStates[taskId]?.resources ?? [])
		taskStates[taskId] = TaskState(action: action, state: state, resources: resources)
		for resource in resources {
			if let transientState = transientStates[resource],
			   transientState.0 == action,
			   !transientState.1.isFailure
			{
				transientStates.removeValue(forKey: resource)
			}
			persistEffectiveOperation(for: resource)
		}
		emitChanges(for: affected)
	}

	func update(taskId: String, state: OfflineResourceState) {
		guard !isShutdown, var task = taskStates[taskId] else {
			return
		}
		task.state = state
		taskStates[taskId] = task
		for resource in task.resources {
			persistEffectiveOperation(for: resource)
		}
		emitChanges(for: task.resources)
	}

	func finish(taskId: String, succeeded: Bool) {
		guard !isShutdown, var task = taskStates[taskId] else {
			return
		}
		if !succeeded {
			task.state = .failed(action: task.action.publicAction)
			taskStates[taskId] = task
			for resource in task.resources {
				persistEffectiveOperation(for: resource)
			}
			emitChanges(for: task.resources)
			return
		}

		taskStates.removeValue(forKey: taskId)
		for resource in task.resources {
			let finalState: OfflineResourceState = task.action == .store ? .downloaded : .notDownloaded
			if transientStates[resource]?.1.isFailure != true {
				transientStates[resource] = (task.action, finalState)
			}
			persistEffectiveOperation(for: resource)
		}
		emitChanges(for: task.resources)
	}

	func shutdown() {
		guard !isShutdown else {
			return
		}
		isShutdown = true
		for continuation in continuations.values.flatMap(\.values) {
			continuation.finish()
		}
		continuations.removeAll()
		taskStates.removeAll()
		transientStates.removeAll()
		lastEmittedStates.removeAll()
	}

	private func setTransient(
		action: InternalOfflineResourceAction,
		state: OfflineResourceState,
		for resource: OfflineResourceKey,
		persist: Bool
	) {
		transientStates[resource] = (action, state)
		if persist {
			persistEffectiveOperation(for: resource)
		}
		emitChanges(for: [resource])
	}

	private func effectiveState(for resource: OfflineResourceKey) -> OfflineResourceState? {
		let taskValues = taskStates.values.filter { $0.resources.contains(resource) }.map(\.state)
		let values = taskValues + [transientStates[resource]?.1].compactMap { $0 }
		return values.max { $0.priority < $1.priority }
	}

	private func persistEffectiveOperation(for resource: OfflineResourceKey) {
		let taskOperations = taskStates.values
			.filter { $0.resources.contains(resource) && ($0.state.isActiveOperation || $0.state.isFailure) }
			.map { (action: $0.action, state: $0.state) }
		let transientOperation = transientStates[resource].flatMap { operation in
			operation.1.isActiveOperation || operation.1.isFailure ? operation : nil
		}.map { (action: $0.0, state: $0.1) }
		let operation = (taskOperations + [transientOperation].compactMap { $0 })
			.max { $0.state.priority < $1.state.priority }

		if let operation {
			try? offlineStore.setResourceOperation(
				resourceType: resource.resourceType,
				resourceId: resource.resourceId,
				action: operation.action,
				state: operation.state
			)
		} else {
			try? offlineStore.deleteResourceOperation(resourceType: resource.resourceType, resourceId: resource.resourceId)
		}
	}

	private func emitChanges(for resources: Set<OfflineResourceKey>) {
		for resource in resources {
			guard let state = effectiveState(for: resource), state != lastEmittedStates[resource] else {
				continue
			}
			lastEmittedStates[resource] = state
			for continuation in continuations[resource]?.values ?? [:].values {
				continuation.yield(state)
			}
		}
	}

	private func removeContinuation(_ id: UUID, for resource: OfflineResourceKey) {
		continuations[resource]?.removeValue(forKey: id)
		if continuations[resource]?.isEmpty == true {
			continuations.removeValue(forKey: resource)
		}
	}
}

extension OfflineResourceState {
	var isActiveOperation: Bool {
		switch self {
		case .queued, .downloading, .removing: true
		case .notDownloaded, .downloaded, .failed: false
		}
	}

	var isFailure: Bool {
		if case .failed = self {
			return true
		}
		return false
	}

	var priority: Int {
		switch self {
		case .failed: 6
		case .removing: 5
		case .downloading: 4
		case .queued: 3
		case .downloaded: 2
		case .notDownloaded: 1
		}
	}

	var storageValue: String {
		switch self {
		case .notDownloaded: "not_downloaded"
		case .queued: "queued"
		case .downloading: "downloading"
		case .downloaded: "downloaded"
		case .removing: "removing"
		case let .failed(action): "failed_\(action.rawValue)"
		}
	}

	init?(storageValue: String) {
		switch storageValue {
		case "not_downloaded": self = .notDownloaded
		case "queued": self = .queued
		case "downloading": self = .downloading
		case "downloaded": self = .downloaded
		case "removing": self = .removing
		case "failed_download": self = .failed(action: .download)
		case "failed_remove": self = .failed(action: .remove)
		default: return nil
		}
	}
}
