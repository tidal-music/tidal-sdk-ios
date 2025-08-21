# OfflineEngine Network Resilience Improvement Plan

## Overview

This document outlines a comprehensive, granular plan to improve the TIDAL iOS SDK OfflineEngine's resilience against network interruptions and partial download handling issues. Each step is designed to be reviewable and revertible independently.

## 🔒 External API Compatibility Guarantee

**CRITICAL**: This plan maintains 100% backward compatibility with the existing external API. No breaking changes to consumer-facing methods.

### Current External API (Preserved)
```swift
// OfflineEngine public methods - ALL UNCHANGED
public func offline(mediaProduct: MediaProduct) -> Bool
public func deleteOffline(mediaProduct: MediaProduct) -> Bool  
public func deleteAllOfflinedMediaProducts() -> Bool
public func getOfflineState(mediaProduct: MediaProduct) -> OfflineState

// OfflineState enum - UNCHANGED
public enum OfflineState {
    case NOT_OFFLINED
    case OFFLINED_AND_VALID
    case OFFLINED_BUT_NOT_VALID
}

// OfflineEngineListener protocol - UNCHANGED
public protocol OfflineEngineListener: AnyObject {
    func offliningStarted(for mediaProduct: MediaProduct)
    func offliningProgressed(for mediaProduct: MediaProduct, is downloadPercentage: Double)
    func offliningCompleted(for mediaProduct: MediaProduct)
    func offliningFailed(for mediaProduct: MediaProduct)
    func offlinedDeleted(for mediaProduct: MediaProduct)
    func allOfflinedMediaProductsDeleted()
}
```

### Optional New Methods (Backward Compatible)
Only if needed for enhanced functionality - existing apps continue working:
```swift
public func performMaintenanceCleanup() // Clean up old/failed downloads
public func validateDownloads() // Check and repair corrupted downloads  
public func getDownloadHealth() -> DownloadHealthReport // Get metrics (if added)
```

### Compatibility Strategy
- **Internal Implementation Only**: All changes are internal architecture improvements
- **Feature Flags**: New behavior can be disabled for safety
- **Graceful Degradation**: Fallback to existing behavior if new systems fail
- **Database Migrations**: Additive only, no destructive schema changes

## Critical Issues Identified

### 1. No Download State Persistence
- Downloads exist only in memory (`activeTasks` dictionaries)
- App termination during download loses all state
- No way to resume or properly clean up interrupted downloads

### 2. Insufficient Partial Download Cleanup
- `DownloadTask.failed()` only cleans up tracked files
- AVFoundation's internal partial download directories aren't tracked
- Background URLSession may leave orphaned partial data

### 3. No Retry Mechanism for Downloads
- Downloads fail immediately on network errors
- No automatic recovery despite existing retry infrastructure
- Inconsistent with HTTP requests and streaming retry logic

### 4. Background Session Lifecycle Issues
- No proper completion handling for background URLSessions
- No discovery/cleanup of system-managed background downloads
- Race conditions between app termination and download completion

### 5. DRM/License Download Coordination Problems
- License and media downloads happen in parallel without coordination
- Inconsistent state when one succeeds and other fails
- Complex async improvements without proper error recovery

## Improvement Plan - Granular Implementation Steps

### Phase 1: Database Schema & State Persistence Foundation

#### Step 1.1: Add Download State Enum
**File**: `Sources/Player/OfflineEngine/Data/DownloadState.swift` (new)
**Goal**: Define download states for tracking
**Effort**: 30 minutes
**Dependencies**: None
**Revert Risk**: Low - new file, no existing code changes

```swift
public enum DownloadState: String, Codable, CaseIterable {
    case pending = "PENDING"
    case inProgress = "IN_PROGRESS" 
    case paused = "PAUSED"
    case failed = "FAILED"
    case completed = "COMPLETED"
    case cancelled = "CANCELLED"
}
```

#### Step 1.2: Create Download Entry Model
**File**: `Sources/Player/OfflineEngine/Internal/Storage/DownloadEntry.swift` (new)
**Goal**: Model for persistent download tracking
**Effort**: 45 minutes
**Dependencies**: Step 1.1
**Revert Risk**: Low - new file

```swift
struct DownloadEntry {
    let id: String
    let productId: String
    let productType: ProductType
    var state: DownloadState
    var progress: Double
    var attemptCount: Int
    var lastError: String?
    var createdAt: UInt64
    var updatedAt: UInt64
    var pausedAt: UInt64?
    var backgroundTaskId: String?
    var partialMediaPath: String?
    var partialLicensePath: String?
}
```

#### Step 1.3: Create GRDB Entity for Download Entry
**File**: `Sources/Player/OfflineEngine/Internal/Storage/GRDBStorage/DownloadEntryGRDBEntity.swift` (new)
**Goal**: GRDB persistence layer for download entries
**Effort**: 1 hour
**Dependencies**: Steps 1.1, 1.2
**Revert Risk**: Low - new file

```swift
struct DownloadEntryGRDBEntity: Codable, FetchableRecord, PersistableRecord {
    // Properties matching DownloadEntry
    // Conversion methods to/from DownloadEntry
    static let databaseTableName = "downloadEntries"
}
```

#### Step 1.4: Add Migration for Download Entries Table
**File**: `Sources/Player/OfflineEngine/Internal/Storage/GRDBStorage/GRDBOfflineStorage.swift`
**Goal**: Database migration to add downloadEntries table
**Effort**: 45 minutes
**Dependencies**: Step 1.3
**Revert Risk**: Medium - modifies existing database initialization

```swift
// In initializeDatabase method, add migration:
if try !db.tableExists(DownloadEntryGRDBEntity.databaseTableName) {
    try db.create(table: DownloadEntryGRDBEntity.databaseTableName) { t in
        t.column("id", .text).primaryKey()
        t.column("productId", .text).notNull().indexed()
        t.column("productType", .text).notNull()
        t.column("state", .text).notNull().indexed()
        t.column("progress", .double).notNull()
        t.column("attemptCount", .integer).notNull()
        t.column("lastError", .text)
        t.column("createdAt", .integer).notNull()
        t.column("updatedAt", .integer).notNull()
        t.column("pausedAt", .integer)
        t.column("backgroundTaskId", .text)
        t.column("partialMediaPath", .text)
        t.column("partialLicensePath", .text)
    }
}
```

#### Step 1.5: Extend OfflineStorage Protocol  
**File**: `Sources/Player/OfflineEngine/Internal/Storage/OfflineStorage.swift`
**Goal**: Add download entry management to storage interface
**Effort**: 20 minutes
**Dependencies**: Steps 1.1, 1.2
**Revert Risk**: Medium - modifies internal protocol (not external API)
**API Impact**: ✅ NONE - Internal protocol only

```swift
// Add to OfflineStorage protocol:
func saveDownloadEntry(_ entry: DownloadEntry) throws
func getDownloadEntry(id: String) throws -> DownloadEntry?
func getAllDownloadEntries() throws -> [DownloadEntry]
func deleteDownloadEntry(id: String) throws
func updateDownloadEntry(_ entry: DownloadEntry) throws
```

#### Step 1.6: Implement Storage Methods in GRDBOfflineStorage
**File**: `Sources/Player/OfflineEngine/Internal/Storage/GRDBStorage/GRDBOfflineStorage.swift`
**Goal**: Implement download entry CRUD operations
**Effort**: 1 hour
**Dependencies**: Steps 1.4, 1.5
**Revert Risk**: Medium - modifies existing class

### Phase 2: Download State Management

#### Step 2.1: Create Download State Manager
**File**: `Sources/Player/OfflineEngine/Internal/DownloadStateManager.swift` (new)
**Goal**: Centralized download state management
**Effort**: 1.5 hours
**Dependencies**: Phase 1 complete
**Revert Risk**: Low - new file

```swift
class DownloadStateManager {
    private let offlineStorage: OfflineStorage
    
    func createDownloadEntry(for mediaProduct: MediaProduct) -> DownloadEntry
    func updateDownloadState(_ id: String, state: DownloadState)
    func updateDownloadProgress(_ id: String, progress: Double)
    func incrementAttemptCount(_ id: String)
    func markDownloadFailed(_ id: String, error: Error)
    func getActiveDownloads() -> [DownloadEntry]
    func cleanupFailedDownloads(olderThan: TimeInterval)
}
```

#### Step 2.2: Add State Manager to Downloader
**File**: `Sources/Player/OfflineEngine/Internal/Downloader.swift`
**Goal**: Integrate state management into downloader
**Effort**: 45 minutes
**Dependencies**: Step 2.1
**Revert Risk**: Medium - modifies core downloader logic

```swift
// Add property:
private let downloadStateManager: DownloadStateManager

// Modify download method to create persistent entry
// Update progress/completion callbacks to update state
```

#### Step 2.3: Update DownloadTask with State Management
**File**: `Sources/Player/OfflineEngine/Internal/DownloadTask.swift`
**Goal**: Connect download task to persistent state
**Effort**: 1 hour
**Dependencies**: Step 2.2
**Revert Risk**: Medium - modifies existing task logic

```swift
// Add properties:
private let downloadStateManager: DownloadStateManager
private let downloadEntryId: String

// Update progress/completion methods to persist state
```

### Phase 3: Error Handling & Retry Logic

#### Step 3.1: Create Download Error Manager
**File**: `Sources/Player/OfflineEngine/Internal/DownloadErrorManager.swift` (new)
**Goal**: Retry logic for download failures
**Effort**: 1 hour
**Dependencies**: Existing BackoffPolicy classes
**Revert Risk**: Low - new file, follows existing patterns

```swift
class DownloadErrorManager: BaseErrorManager {
    init() {
        super.init(maxRetryAttempts: 3, backoffPolicy: JitteredBackoffPolicy.forNetworkErrors)
    }
    
    func onError(_ error: Error, attemptCount: Int) -> RetryStrategy {
        // Network errors: retry with backoff
        // Authorization errors: fail immediately
        // Unknown errors: single retry
    }
}
```

#### Step 3.2: Add Retry Logic to Downloader
**File**: `Sources/Player/OfflineEngine/Internal/Downloader.swift`
**Goal**: Implement automatic retry for failed downloads
**Effort**: 1.5 hours
**Dependencies**: Steps 3.1, 2.2
**Revert Risk**: High - significant logic changes

```swift
private let downloadErrorManager = DownloadErrorManager()

// Modify failed download handling:
private func handleDownloadFailure(downloadTask: DownloadTask, error: Error) {
    let retryStrategy = downloadErrorManager.onError(error, attemptCount: downloadTask.attemptCount)
    switch retryStrategy {
    case .NONE:
        // Mark as permanently failed
    case .BACKOFF(let duration):
        // Schedule retry after delay
    }
}
```

#### Step 3.3: Implement Download Recovery on App Start
**File**: `Sources/Player/OfflineEngine/Internal/DownloadRecoveryManager.swift` (new)
**Goal**: Resume interrupted downloads on app startup
**Effort**: 2 hours
**Dependencies**: Phase 2 complete
**Revert Risk**: Low - new file, only called on startup

```swift
class DownloadRecoveryManager {
    func recoverInterruptedDownloads() async {
        // Query background URLSession for active downloads
        // Match with persisted download entries
        // Resume valid downloads, clean up orphaned ones
    }
    
    private func cleanupOrphanedBackgroundTasks()
    private func resumeValidDownloads()
}
```

### Phase 4: Comprehensive Cleanup System

#### Step 4.1: Create Download Cleanup Manager
**File**: `Sources/Player/OfflineEngine/Internal/DownloadCleanupManager.swift` (new)
**Goal**: Centralized cleanup for all scenarios
**Effort**: 1.5 hours
**Dependencies**: None (uses existing FileManager patterns)
**Revert Risk**: Low - new file, follows existing cleanup patterns

```swift
class DownloadCleanupManager {
    func cleanupFailedDownload(_ entry: DownloadEntry)
    func cleanupPartialDownload(at path: URL)
    func cleanupBackgroundTaskFiles(taskId: String)
    func validateAndCleanupCorruptedDownloads()
    func performMaintenanceCleanup() // Remove old failed downloads
}
```

#### Step 4.2: Enhanced Cleanup in DownloadTask
**File**: `Sources/Player/OfflineEngine/Internal/DownloadTask.swift`
**Goal**: Use comprehensive cleanup on failure
**Effort**: 30 minutes
**Dependencies**: Step 4.1
**Revert Risk**: Low - improves existing cleanup logic

```swift
// In failed() method:
private let cleanupManager = DownloadCleanupManager()

func failed(with error: Error) {
    // Existing cleanup logic
    // Add: cleanupManager.cleanupFailedDownload()
}
```

#### Step 4.3: Add Cleanup to OfflineEngine
**File**: `Sources/Player/OfflineEngine/OfflineEngine.swift`
**Goal**: Expose cleanup methods and add maintenance  
**Effort**: 45 minutes
**Dependencies**: Step 4.1
**Revert Risk**: Low - adds new public methods (backward compatible)
**API Impact**: ✅ BACKWARD COMPATIBLE - Optional new methods only

```swift
private let cleanupManager = DownloadCleanupManager()

// Optional new methods - existing apps continue working without these
public func performMaintenanceCleanup() {
    cleanupManager.performMaintenanceCleanup()
}

public func validateDownloads() {
    cleanupManager.validateAndCleanupCorruptedDownloads()
}
```

#### Step 4.4: Background Cleanup Task
**File**: `Sources/Player/OfflineEngine/Internal/DownloadMaintenanceScheduler.swift` (new)
**Goal**: Periodic cleanup of old/failed downloads
**Effort**: 1 hour
**Dependencies**: Step 4.1
**Revert Risk**: Low - new file, optional feature

### Phase 5: Network Monitoring & Adaptive Downloads

#### Step 5.1: Enhance Network Monitor
**File**: `Sources/Player/Common/Utils/NetworkMonitor.swift`
**Goal**: Add connection state change notifications
**Effort**: 1 hour
**Dependencies**: None
**Revert Risk**: Medium - modifies existing utility

```swift
// Add properties:
@Atomic private var isConnected: Bool = false
private var observers: [NetworkChangeObserver] = []

// Add methods:
func addObserver(_ observer: NetworkChangeObserver)
func removeObserver(_ observer: NetworkChangeObserver)
func isNetworkAvailable() -> Bool
```

#### Step 5.2: Network-Aware Download Management
**File**: `Sources/Player/OfflineEngine/Internal/NetworkAwareDownloader.swift` (new)
**Goal**: Pause/resume downloads based on network state
**Effort**: 1.5 hours
**Dependencies**: Step 5.1
**Revert Risk**: Low - new optional feature

```swift
class NetworkAwareDownloader: NetworkChangeObserver {
    func networkDidConnect() {
        // Resume paused downloads
    }
    
    func networkDidDisconnect() {
        // Pause active downloads
    }
    
    func networkTypeDidChange(to type: NetworkType) {
        // Adjust download strategy based on network type
    }
}
```

### Phase 6: Coordinated License/Media Downloads

#### Step 6.1: Download Coordination State Machine
**File**: `Sources/Player/OfflineEngine/Internal/CoordinatedDownloadManager.swift` (new)
**Goal**: Ensure atomic license+media download completion
**Effort**: 2 hours
**Dependencies**: Phase 2 complete
**Revert Risk**: Low - new file, replaces existing coordination logic

```swift
enum CoordinatedDownloadState {
    case waitingForLicense
    case waitingForMedia
    case bothCompleted
    case failed(Error)
}

class CoordinatedDownloadManager {
    func startCoordinatedDownload(for mediaProduct: MediaProduct)
    func handleLicenseCompletion(for downloadId: String)
    func handleMediaCompletion(for downloadId: String)
    func handleFailure(for downloadId: String, error: Error)
}
```

#### Step 6.2: Update Downloader for Coordination
**File**: `Sources/Player/OfflineEngine/Internal/Downloader.swift`
**Goal**: Use coordinated download manager
**Effort**: 1 hour
**Dependencies**: Step 6.1
**Revert Risk**: Medium - changes core download logic

### Phase 7: Enhanced Monitoring & Observability

#### Step 7.1: Download Health Metrics
**File**: `Sources/Player/OfflineEngine/Internal/DownloadMetricsCollector.swift` (new)
**Goal**: Collect download success/failure metrics
**Effort**: 1 hour
**Dependencies**: None
**Revert Risk**: Low - new optional feature

```swift
class DownloadMetricsCollector {
    func recordDownloadStart(mediaProduct: MediaProduct)
    func recordDownloadSuccess(mediaProduct: MediaProduct, duration: TimeInterval)
    func recordDownloadFailure(mediaProduct: MediaProduct, error: Error, attemptCount: Int)
    func recordRetryAttempt(mediaProduct: MediaProduct, reason: String)
    func generateHealthReport() -> DownloadHealthReport
}
```

#### Step 7.2: Enhanced Download Logging
**File**: `Sources/Player/Common/Logging/PlayerLoggable.swift`
**Goal**: Add comprehensive download state logging
**Effort**: 30 minutes
**Dependencies**: None
**Revert Risk**: Low - adds new log cases

```swift
// Add new cases:
case downloadStateChanged(productId: String, from: DownloadState, to: DownloadState)
case downloadRetryScheduled(productId: String, attemptCount: Int, delay: TimeInterval)
case downloadRecoveryCompleted(recoveredCount: Int, cleanedUpCount: Int)
case downloadMaintenanceCompleted(cleanedUpCount: Int, validatedCount: Int)
```

### Phase 8: Integration & Feature Flags

#### Step 8.1: Feature Flag Integration
**File**: `Sources/Player/Common/FeatureFlags/FeatureFlagProvider.swift`
**Goal**: Gate new features behind feature flags
**Effort**: 20 minutes
**Dependencies**: None
**Revert Risk**: Low - follows existing patterns

```swift
// Add new feature flags:
func shouldUseEnhancedDownloadManagement() -> Bool
func shouldEnableDownloadRetry() -> Bool
func shouldUseNetworkAwareDownloads() -> Bool
func shouldEnableDownloadRecovery() -> Bool
```

#### Step 8.2: Gradual Feature Rollout
**File**: `Sources/Player/OfflineEngine/Internal/Downloader.swift`
**Goal**: Enable features conditionally
**Effort**: 45 minutes
**Dependencies**: Step 8.1 and previous phases
**Revert Risk**: Low - uses feature flags for safety

```swift
// Wrap new features in feature flag checks:
if featureFlagProvider.shouldUseEnhancedDownloadManagement() {
    // Use new download state manager
} else {
    // Use existing logic
}
```

### Phase 9: Testing & Validation

#### Step 9.1: Unit Tests for New Components
**Files**: `Tests/PlayerTests/OfflineEngine/*` (new test files)
**Goal**: Comprehensive test coverage for new components
**Effort**: 4 hours
**Dependencies**: All previous phases
**Revert Risk**: None - tests only

#### Step 9.2: Integration Tests
**File**: `Tests/PlayerTests/OfflineEngine/DownloadResilienceIntegrationTests.swift` (new)
**Goal**: End-to-end testing of resilience features
**Effort**: 2 hours
**Dependencies**: Step 9.1
**Revert Risk**: None - tests only

#### Step 9.3: Network Simulation Tests
**File**: `Tests/PlayerTests/OfflineEngine/NetworkSimulationTests.swift` (new)
**Goal**: Test behavior under various network conditions
**Effort**: 2 hours
**Dependencies**: Phase 5 complete
**Revert Risk**: None - tests only

## Implementation Schedule & Risk Assessment

### High Priority (Core Resilience) - 2-3 weeks
- **Phase 1**: Database Schema & State Persistence (Steps 1.1-1.6)
- **Phase 2**: Download State Management (Steps 2.1-2.3)
- **Phase 3**: Error Handling & Retry Logic (Steps 3.1-3.3)
- **Phase 4**: Comprehensive Cleanup System (Steps 4.1-4.3)

### Medium Priority (Enhanced Features) - 1-2 weeks
- **Phase 5**: Network Monitoring & Adaptive Downloads
- **Phase 6**: Coordinated License/Media Downloads
- **Phase 7**: Enhanced Monitoring & Observability

### Low Priority (Safety & Testing) - 1 week
- **Phase 8**: Integration & Feature Flags
- **Phase 9**: Testing & Validation

## Risk Mitigation Strategy

### Database Migration Safety
1. All database changes are additive (new tables/columns only)
2. Backward compatibility maintained through feature flags
3. Migration failures logged but don't prevent app startup
4. Manual rollback procedures documented for each step

### Revert Procedures
1. **New Files**: Simply delete and remove from git
2. **Modified Files**: Use git revert on specific commits
3. **Database Changes**: No destructive changes, safe to leave
4. **Feature Flags**: Disable features immediately if issues arise

### Rollout Strategy
1. Start with feature flags disabled in production
2. Enable for internal testing first
3. Gradual rollout to percentage of users
4. Monitor metrics for regression detection
5. Full rollout only after validation

## Success Metrics

### Primary Metrics
- Download success rate after network interruptions
- Reduction in orphaned partial downloads
- App startup time impact (should be minimal)
- Memory usage impact (should be minimal)

### Secondary Metrics
- Download retry success rate
- Background download recovery rate
- User-reported download issues (should decrease)
- Cleanup effectiveness (storage space recovered)

## Maintenance Requirements

### Ongoing Tasks
1. Monitor download health metrics weekly
2. Run maintenance cleanup monthly (automated)
3. Review and update retry policies based on success rates
4. Update feature flag configurations based on performance data

### Performance Monitoring
1. Database query performance for new tables
2. Memory usage of state management components
3. CPU impact of cleanup operations
4. Network usage efficiency improvements