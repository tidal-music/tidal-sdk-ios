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

	var publicResource: OfflineResource? {
		if let type = OfflineMediaItemType(rawValue: resourceType) {
			return .media(type: type, resourceId: resourceId)
		}
		return publicCollection
	}

	var publicCollection: OfflineResource? {
		guard let type = OfflineCollectionType(rawValue: resourceType) else { return nil }
		return .collection(type: type, resourceId: resourceId)
	}
}

// MARK: - DownloadQueueTask

struct DownloadQueueTask: Sendable {
	let resource: OfflineResource
	let parentCollection: OfflineResource?
	let supportsProgress: Bool
}

// MARK: - ResourceStateTracker

actor ResourceStateTracker {
	private struct TaskState {
		let action: InternalOfflineResourceAction
		var state: OfflineResourceState
		let resources: Set<OfflineResourceKey>
	}

	private struct QueueTaskState {
		let root: OfflineResourceKey
		let parentCollection: OfflineResource?
		var state: OfflineResourceState
		let supportsProgress: Bool
		var progress: Double?
	}

	private let offlineStore: OfflineStore
	private var taskStates: [String: TaskState] = [:]
	private var queueTaskStates: [String: QueueTaskState] = [:]
	private var transientStates: [OfflineResourceKey: (InternalOfflineResourceAction, OfflineResourceState)] = [:]
	private var continuations: [OfflineResourceKey: [UUID: AsyncStream<OfflineResourceState>.Continuation]] = [:]
	private var queueContinuations: [UUID: AsyncStream<[OfflineDownloadQueueEntry]>.Continuation] = [:]
	private var lastEmittedStates: [OfflineResourceKey: OfflineResourceState] = [:]
	private var lastEmittedQueue: [OfflineDownloadQueueEntry]?
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

	func downloadQueueSnapshot() throws -> [OfflineDownloadQueueEntry] {
		guard !isShutdown else { return [] }
		return try offlineStore.getDownloadQueueEntries()
	}

	func observeDownloadQueue() throws -> AsyncStream<[OfflineDownloadQueueEntry]> {
		guard !isShutdown else { return AsyncStream { $0.finish() } }
		let initial = try downloadQueueSnapshot()
		lastEmittedQueue = initial
		return AsyncStream { continuation in
			let id = UUID()
			queueContinuations[id] = continuation
			continuation.yield(initial)
			continuation.onTermination = { [weak self] _ in
				Task { await self?.removeQueueContinuation(id) }
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
			if action == .store, let publicResource = resource.publicResource {
				queueTaskStates = queueTaskStates.filter { $0.value.root != resource }
				try offlineStore.setDownloadQueueEntry(OfflineDownloadQueueEntry(
					resource: publicResource,
					parentCollection: nil,
					state: .queued,
					progress: nil
				))
			} else if action == .remove {
				queueTaskStates = queueTaskStates.filter { $0.value.root != resource }
				try offlineStore.deleteDownloadQueueEntry(
					resourceType: resource.resourceType,
					resourceId: resource.resourceId
				)
			}
		} catch {
			transientStates.removeValue(forKey: resource)
			try? offlineStore.deleteResourceOperation(resourceType: resource.resourceType, resourceId: resource.resourceId)
			throw error
		}
		emitChanges(for: [resource])
		emitDownloadQueueIfChanged()
		return true
	}

	func registrationFailed(_ action: InternalOfflineResourceAction, for resource: OfflineResourceKey) {
		setTransient(action: action, state: .failed(action: action.publicAction), for: resource, persist: true)
		if action == .store, let publicResource = resource.publicResource {
			try? offlineStore.setDownloadQueueEntry(OfflineDownloadQueueEntry(
				resource: publicResource,
				parentCollection: nil,
				state: .failed(action: .download),
				progress: nil
			))
			emitDownloadQueueIfChanged()
		}
	}

	func resolve(_ resource: OfflineResourceKey, state: OfflineResourceState) {
		guard !isShutdown else {
			return
		}
		transientStates[resource] = (.store, state)
		try? offlineStore.deleteResourceOperation(resourceType: resource.resourceType, resourceId: resource.resourceId)
		try? offlineStore.deleteDownloadQueueEntry(resourceType: resource.resourceType, resourceId: resource.resourceId)
		queueTaskStates = queueTaskStates.filter { $0.value.root != resource }
		emitChanges(for: [resource])
		emitDownloadQueueIfChanged()
	}

	func record(
		taskId: String,
		action: InternalOfflineResourceAction,
		state: OfflineResourceState,
		resources: Set<OfflineResourceKey>,
		downloadQueueTask: DownloadQueueTask?
	) throws {
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
		if action == .store, let downloadQueueTask {
			try recordDownloadQueueTask(taskId: taskId, state: state, task: downloadQueueTask)
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
		if var queueTask = queueTaskStates[taskId] {
			queueTask.state = state
			queueTaskStates[taskId] = queueTask
			persistDownloadQueue(root: queueTask.root)
		}
		emitChanges(for: task.resources)
	}

	func updateProgress(taskId: String, progress: Double) {
		guard !isShutdown, var task = queueTaskStates[taskId] else { return }
		task.progress = min(max(progress, 0), 1)
		queueTaskStates[taskId] = task
		persistDownloadQueue(root: task.root)
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
			if var queueTask = queueTaskStates[taskId] {
				queueTask.state = .failed(action: .download)
				queueTaskStates[taskId] = queueTask
				persistDownloadQueue(root: queueTask.root)
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
		if var queueTask = queueTaskStates[taskId] {
			queueTask.state = .downloaded
			queueTask.progress = queueTask.supportsProgress ? 1 : nil
			queueTaskStates[taskId] = queueTask
			persistDownloadQueue(root: queueTask.root)
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
		for continuation in queueContinuations.values {
			continuation.finish()
		}
		queueContinuations.removeAll()
		taskStates.removeAll()
		queueTaskStates.removeAll()
		transientStates.removeAll()
		lastEmittedStates.removeAll()
		lastEmittedQueue = nil
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

	private func recordDownloadQueueTask(
		taskId: String,
		state: OfflineResourceState,
		task: DownloadQueueTask
	) throws {
		let resource = OfflineResourceKey(task.resource)
		let parent = task.parentCollection.map(OfflineResourceKey.init)
		let root: OfflineResourceKey
		let hasCollectionDownloadIntent = state == .queued
			|| state == .downloading
			|| state == .failed(action: .download)
		if parent == nil, resource.publicCollection != nil, hasCollectionDownloadIntent {
			root = resource
			let storedMembers = try offlineStore.getDownloadQueueEntries().filter {
				$0.parentCollection.map(OfflineResourceKey.init) == resource
			}
			for member in storedMembers {
				let memberKey = OfflineResourceKey(member.resource)
				try offlineStore.deleteDownloadQueueEntry(
					resourceType: memberKey.resourceType,
					resourceId: memberKey.resourceId
				)
			}
			queueTaskStates = queueTaskStates.mapValues { existing in
				guard existing.parentCollection.map(OfflineResourceKey.init) == resource else { return existing }
				return QueueTaskState(
					root: resource,
					parentCollection: nil,
					state: existing.state,
					supportsProgress: existing.supportsProgress,
					progress: existing.progress
				)
			}
		} else if let parent,
		   try offlineStore.getDownloadQueueEntry(resourceType: parent.resourceType, resourceId: parent.resourceId) != nil {
			root = parent
			if resource != parent {
				try offlineStore.deleteDownloadQueueEntry(resourceType: resource.resourceType, resourceId: resource.resourceId)
				queueTaskStates = queueTaskStates.mapValues { existing in
					guard existing.root == resource else { return existing }
					return QueueTaskState(
						root: parent,
						parentCollection: nil,
						state: existing.state,
						supportsProgress: existing.supportsProgress,
						progress: existing.progress
					)
				}
			}
		} else if try offlineStore.getDownloadQueueEntry(
			resourceType: resource.resourceType,
			resourceId: resource.resourceId
		) != nil {
			root = resource
		} else if let parent {
			root = parent
		} else {
			root = resource
		}

		queueTaskStates[taskId] = QueueTaskState(
			root: root,
			parentCollection: root == resource ? task.parentCollection : nil,
			state: state,
			supportsProgress: task.supportsProgress,
			progress: nil
		)
		try persistDownloadQueueThrowing(root: root)
	}

	private func persistDownloadQueue(root: OfflineResourceKey) {
		try? persistDownloadQueueThrowing(root: root)
	}

	private func persistDownloadQueueThrowing(root: OfflineResourceKey) throws {
		let tasks = queueTaskStates.values.filter { $0.root == root }
		let failed = tasks.contains { $0.state == .failed(action: .download) }
		let downloading = tasks.contains { $0.state == .downloading }
		let queued = tasks.contains { $0.state == .queued }
		guard failed || downloading || queued else {
			try offlineStore.deleteDownloadQueueEntry(resourceType: root.resourceType, resourceId: root.resourceId)
			queueTaskStates = queueTaskStates.filter { $0.value.root != root }
			emitDownloadQueueIfChanged()
			return
		}

		guard let resource = root.publicResource else { return }
		let state: OfflineDownloadQueueEntry.State = if failed {
			.failed(action: .download)
		} else if downloading {
			.downloading
		} else {
			.queued
		}
		let progressTasks = tasks.filter(\.supportsProgress)
		let hasKnownProgress = progressTasks.contains { $0.progress != nil }
		let progress = hasKnownProgress && !progressTasks.isEmpty
			? progressTasks.reduce(0) { $0 + ($1.progress ?? 0) } / Double(progressTasks.count)
			: nil
		let parentCollection = tasks.lazy.compactMap(\.parentCollection).first
		try offlineStore.setDownloadQueueEntry(OfflineDownloadQueueEntry(
			resource: resource,
			parentCollection: parentCollection,
			state: state,
			progress: progress
		))
		emitDownloadQueueIfChanged()
	}

	private func emitDownloadQueueIfChanged() {
		guard let queue = try? offlineStore.getDownloadQueueEntries(), queue != lastEmittedQueue else { return }
		lastEmittedQueue = queue
		for continuation in queueContinuations.values {
			continuation.yield(queue)
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

	private func removeQueueContinuation(_ id: UUID) {
		queueContinuations.removeValue(forKey: id)
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
