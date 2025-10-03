import Foundation

actor RefreshGate {
    static let shared = RefreshGate()

    private var tasks: [String: Task<AuthResult<Credentials>, Error>] = [:]

    func runOrJoinCredentials(key: String, operation: @escaping () async throws -> AuthResult<Credentials>) async throws -> AuthResult<Credentials> {
        if let existing = tasks[key] {
            return try await existing.value
        }

        let task = Task<AuthResult<Credentials>, Error> {
            try await operation()
        }
        tasks[key] = task
        defer { tasks[key] = nil }
        return try await task.value
    }
}

