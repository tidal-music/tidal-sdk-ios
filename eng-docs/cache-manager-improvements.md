# Cache Manager Improvements - Implementation Guide

**Document Version:** 1.0
**Last Updated:** 2025-10-30
**Status:** Planning Phase
**Related PRs:** #272 (CacheManager introduction), #273 (Cache quota implementation)

---

## Table of Contents

1. [Executive Summary](#executive-summary)
2. [Current Architecture](#current-architecture)
3. [Issues & Rationale](#issues--rationale)
4. [Implementation Roadmap](#implementation-roadmap)
5. [Phase 1: Critical Fixes](#phase-1-critical-fixes)
6. [Phase 2: Performance Optimizations](#phase-2-performance-optimizations)
7. [Phase 3: API Enhancements](#phase-3-api-enhancements)
8. [Phase 4: Observability Features](#phase-4-observability-features)
9. [Testing Strategy](#testing-strategy)
10. [Migration & Rollout](#migration--rollout)
11. [References](#references)

---

## Executive Summary

The Player SDK cache system (introduced in PRs #272-273) provides a foundation for managing downloaded media assets. However, critical issues in thread safety, error handling, and performance need to be addressed before expanding the API surface for public consumption.

This guide details a phased approach to:
1. **Fix critical issues** (thread safety, performance)
2. **Add observability** (logging, health checks)
3. **Expand the API** (statistics, entry queries, selective operations)
4. **Improve reliability** (transactional operations, verification)

**Expected Timeline:** 4-6 weeks across multiple PRs
**Team:** 2-3 engineers in rotation
**Priority:** HIGH - Cache is critical for offline support and user experience

---

## Current Architecture

### Components Overview

```
Configuration.swift (cacheQuotaInBytes: 5GB default)
        ↓
    Player.swift
        ↓
    PlayerEngine.swift
        ↓
    PlayerCacheManager.swift (PUBLIC API)
        ↓
    CacheStorage protocol
    ├── GRDBCacheStorage (SQLite metadata)
    └── AVURLAsset / FileManager (file storage)
```

### Data Flow

1. **Cache Resolution:** `resolveAsset()` → Check metadata → Validate file → Return with state
2. **Download:** `startCachingIfNeeded()` → AVURLAssetFactory downloads → `persistCacheEntry()`
3. **Playback:** `recordPlayback()` → Update `lastAccessedAt` for LRU
4. **Pruning:** When quota exceeded → Delete oldest entries (by LRU)
5. **Cleanup:** User calls `clearCache()` → Delete all entries and files

### Storage Layers

**Metadata (SQLite via GRDB):**
```sql
CREATE TABLE cacheEntry (
    key TEXT PRIMARY KEY,
    type TEXT,                -- 'hls' or 'progressive'
    url TEXT,
    lastAccessedAt TIMESTAMP,
    size INTEGER
)
```

**Physical Storage:**
- iOS caching via `AVURLAsset` (~/Library/Caches)
- Bookmarks stored in `UserDefaults`
- File validation on resolution

---

## Issues & Rationale

### CRITICAL (Fix in Phase 1)

#### Issue #1: Thread Safety Violations
**Problem:** PlayerCacheManager lacks synchronization primitives
**Risk Level:** CRITICAL - Data corruption, crashes, undefined behavior
**Affected Operations:**
- `recordPlayback()` - called from player thread (AVQueuePlayerWrapper.swift:516)
- `persistCacheEntry()` - called from URLSession completion handler (background thread)
- `clearCache()` - called from main thread
- `updateMaxCacheSize()` - called from configuration updates

**Current State:** No locks, no serial queue, no @Atomic wrappers
**Evidence:** PlayerCacheManager.swift has zero synchronization code

**Why It Matters:**
```swift
// Thread 1 (Download completion):
persistCacheEntry(key, size: 500MB)  // Calls pruneCacheIfNeeded()

// Thread 2 (Player):
recordPlayback(key)  // Updates lastAccessedAt

// Thread 3 (Main thread):
clearCache()  // Iterates and deletes all entries

// Result: Race condition, potential crashes, corrupted cache state
```

---

#### Issue #2: Missing Database Index
**Problem:** `ORDER BY lastAccessedAt` queries have no index on that column
**Risk Level:** HIGH - Performance degradation with scale
**Location:** GRDBCacheStorage.swift:87, PlayerCacheManager.swift:301
**Current Behavior:** Full table scan + in-memory sort on every pruning

**Performance Impact (estimated):**
```
Cache Size | Current Time | With Index
100 entries | ~50ms       | ~5ms
1000 entries| ~500ms      | ~20ms
5000 entries| ~2500ms     | ~100ms
```

**Why It Matters:**
- Pruning happens frequently: after every download, when quota updated
- Blocks cache operations during sort
- User-initiated `clearCache()` or quota updates become slow

---

#### Issue #3: Silent Error Handling
**Problem:** All cache errors caught and ignored with "Intentionally ignored for now"
**Risk Level:** HIGH - Invisible failures, impossible debugging
**Locations:**
- Line 162: `recordPlayback()` - LRU update failure silently ignored
- Line 184: `persistCacheEntry()` - metadata write failure ignored
- Line 257: Size calculation errors ignored
- Line 264: Metadata update errors ignored
- Line 314: File deletion errors ignored

**Current Pattern:**
```swift
do {
    // Try to update something
} catch {
    // Intentionally ignored for now
    // (No logging, no notification, no trace)
}
```

**Why It Matters:**
- Cache corruption not detected
- Downloads succeed but metadata lost → cache miss on replay
- User has no insight into failures
- Support impossible - no logs to investigate
- Silent data loss

---

#### Issue #4: Race Condition in clearCache()
**Problem:** Downloads can complete during cache clearing
**Risk Level:** MEDIUM - Eventual consistency issues
**Scenario:**
```
Time | Thread A (clearCache)     | Thread B (Download Complete)
-----|---------------------------|---------------------------
1    | Get all entries (N items) |
2    |                           | persistCacheEntry() called
3    | Delete entry N...         | Entry N+1 persisted to DB
4    | Finish deleting N items   |
5    |                           | New entry in cache, but file?
     | Result: Inconsistent state - metadata exists but may be incomplete
```

**Why It Matters:**
- Cache enters inconsistent state
- Next playback may fail
- Metadata/file desynchronization

---

### MODERATE (Fix in Phase 2)

#### Issue #5: Inefficient Pruning Algorithm
**Current:** `getAll()` loads ALL entries into memory, sort, then delete oldest
**Better:** Use `ORDER BY ... LIMIT` at database level
**Impact:** Memory usage proportional to cache size (hundreds of entries)

#### Issue #6: Metadata/File Deletion Order
**Current:** Delete files first, then metadata
**Problem:** If crash between operations, metadata remains but files gone
**Better:** Delete metadata first (fail-safe)

#### Issue #7: No Cache Entry Validation
**Current:** Stale metadata accumulates if external file deletion occurs
**Better:** Proactive validation or on-access validation

---

### API GAPS (Address in Phase 3)

Users cannot currently:
- ❌ List cached entries
- ❌ Check if specific item is cached
- ❌ Get entry details (size, age, access time)
- ❌ Clear individual entries
- ❌ Clear by pattern/age/size
- ❌ See cache statistics
- ❌ Monitor cache health

---

## Implementation Roadmap

### Phase Overview

| Phase | Focus | Duration | PRs | Start After |
|-------|-------|----------|-----|-------------|
| 1 | Critical Fixes | 1-2 weeks | 1-2 | PR #273 merged |
| 2 | Performance | 1 week | 1-2 | Phase 1 complete |
| 3 | API Enhancements | 2 weeks | 2-3 | Phase 2 complete |
| 4 | Observability | 1 week | 1-2 | Phase 3 complete |

### Dependencies

```
Phase 1 (Thread Safety, Index, Logging)
    ↓
Phase 2 (Pruning Optimization, Timestamps)
    ↓
Phase 3 (Statistics API, Query API, Selective Clear)
    ↓
Phase 4 (Notifications, Health Checks, Verification)
```

---

## Phase 1: Critical Fixes

**Goal:** Stabilize the cache system for production use
**Estimated Effort:** 80-100 hours
**PR Count:** 2 PRs (thread safety + logging, race condition fixes)
**Priority:** CRITICAL - Do not proceed with Phase 2 without this

### 1.1 Add Thread Safety to PlayerCacheManager

**Objective:** Wrap all public methods with synchronized access using OperationQueue + @Atomic

**Architecture:**
This follows the same pattern used in `PlayerEngine.swift` and other core Player components:
- **OperationQueue** (serial): Ensures operations execute sequentially
- **@Atomic property wrapper**: Protects individual mutable properties
- See `Sources/Player/Common/Utils/Atomic.swift` for the @Atomic implementation

**Implementation Steps:**

#### Step 1.1.1: Create Serial OperationQueue for Synchronization

**File:** `Sources/Player/PlaybackEngine/Internal/Cache/PlayerCacheManager.swift`

**Changes:**
```swift
// Add after class declaration (around line 45)
private let queue = OperationQueue()

// Configure in init() method:
init(...) {
    // ... existing code ...

    // Configure serial queue (matches PlayerEngine pattern)
    queue.maxConcurrentOperationCount = 1
    queue.qualityOfService = .utility
    queue.name = "com.tidal.player.cache"
}
```

**Why OperationQueue instead of DispatchQueue:**
- **Consistency:** Matches `PlayerEngine.swift` (the closest comparable component)
- **Higher-level API:** Better semantics than raw DispatchQueue
- **Proven pattern:** Already used throughout the codebase for similar scenarios
- **Better observability:** Can check `operationCount` for debugging
- **iOS 15+ best practice:** Recommended approach in Player SDK

**Validation:**
- Compile check only - no behavior change yet

---

#### Step 1.1.2: Wrap Public Async Methods with addOperation

**Methods to Wrap (Async):** `recordPlayback()`, `prepareCache()`, `cancelDownload()`, `reset()`, `startCachingIfNeeded()`, `clearCache()`, `updateMaxCacheSize()`

**Pattern:**
```swift
public func recordPlayback(for cacheKey: String) {
    queue.addOperation { [weak self] in
        self?._recordPlayback(for: cacheKey)
    }
}

private func _recordPlayback(for cacheKey: String) {
    // Original implementation from recordPlayback()
    // Update lastAccessedAt, etc.
    // ... existing code ...
}
```

**Why addOperation:**
- Async methods dispatch work and return immediately
- Operation is queued sequentially on the serial queue
- Matches `OperationQueue.dispatch` pattern used in Player SDK

**Files to Modify:**
- PlayerCacheManager.swift - recordPlayback, prepareCache, cancelDownload, reset
- PlayerCacheManager.swift - startCachingIfNeeded, clearCache, updateMaxCacheSize

**Changes per method:**
```swift
// 1. Rename original method: recordPlayback → _recordPlayback
// 2. Create new public wrapper using queue.addOperation
// 3. Update any internal calls to use _recordPlayback (same thread)
```

---

#### Step 1.1.3: Wrap Public Sync Methods (Return Values)

**Methods to Wrap (Sync):** `resolveAsset()`, `currentCacheSizeInBytes()`

**Pattern:**
```swift
public func resolveAsset(for url: URL, cacheKey: String?) -> PlayerCacheResult {
    var result: PlayerCacheResult?
    let operation = BlockOperation { [weak self] in
        result = self?._resolveAsset(for: url, cacheKey: cacheKey)
    }
    queue.addOperation(operation)
    queue.waitUntilAllOperationsAreFinished()  // Block until complete
    return result ?? fallbackValue
}

private func _resolveAsset(for url: URL, cacheKey: String?) -> PlayerCacheResult {
    // Original implementation
    // ... existing code ...
}
```

**Files to Modify:**
- PlayerCacheManager.swift - lines 90-133 (resolveAsset)
- PlayerCacheManager.swift - lines 171-173 (currentCacheSizeInBytes)

**Critical Notes:**
- Use `waitUntilAllOperationsAreFinished()` to block caller until operation completes
- Allows synchronous API while maintaining queue serialization
- Similar pattern used in AVQueuePlayerWrapper for bridging async operations

**Deadlock Prevention:**
- All internal calls use `_methodName()` to avoid re-entering queue
- No calls to public methods from within private methods
- Single serial queue prevents circular waits

**Testing:**
```swift
// Add to PlayerCacheManagerTests.swift
func testConcurrentAccess() {
    let manager = PlayerCacheManager()
    let dispatchGroup = DispatchGroup()

    // 100 concurrent recordPlayback calls
    for i in 0..<100 {
        dispatchGroup.enter()
        DispatchQueue.global().async {
            manager.recordPlayback(for: "key-\(i)")
            dispatchGroup.leave()
        }
    }

    let result = dispatchGroup.wait(timeout: .now() + 5)
    XCTAssertEqual(result, .success)  // Should not timeout
}
```

---

#### Step 1.1.4: Update Internal Callers

**Goal:** Ensure internal calls don't re-enter queue (deadlock prevention)

**Locations to Check:**
- `persistCacheEntry()` calls - use direct helper
- `pruneCacheIfNeeded()` calls - use direct helper
- Completion handlers from URLSession

**Pattern Change:**
```swift
// OLD: Internal method called other public methods
func persistCacheEntry() {
    calculateSize()      // Was public, now could cause deadlock
    recordPlayback()     // Was public, now could cause deadlock
}

// NEW: Internal method calls private equivalents
func _persistCacheEntry() {
    _calculateSize()     // Call private version
    _recordPlayback()    // Call private version
}
```

**Files to Review:**
- PlayerCacheManager.swift - all internal methods
- PlayerCacheManager.swift - completion handlers

**Testing:**
- Run full test suite
- No new tests needed (same behavior)

---

#### Step 1.1.5: Document Thread Safety

**File:** PlayerCacheManager.swift - add to class header

```swift
/// Thread-safe cache manager for coordinating media asset downloads.
///
/// All public methods are thread-safe and can be called from any thread.
/// The manager uses a serial dispatch queue internally to serialize access.
///
/// - Important: All operations are performed asynchronously on a background queue.
///   Sync methods like ``resolveAsset(for:cacheKey:)`` block the calling thread
///   but do not block other cache operations.
///
/// Example:
/// ```swift
/// // Safe to call from any thread
/// DispatchQueue.global().async {
///     manager.recordPlayback(for: cacheKey)
/// }
///
/// DispatchQueue.main.async {
///     let size = manager.currentCacheSizeInBytes()
/// }
/// ```
```

---

#### Step 1.1.4: Protect Mutable State with @Atomic (Optional)

**File:** `Sources/Player/PlaybackEngine/Internal/Cache/PlayerCacheManager.swift`

**Pattern:** For individual properties that need concurrent read/write (if needed)

```swift
@Atomic private var maxCacheSizeInBytes: Int?
```

**When to use @Atomic:**
- For simple properties with independent read/write semantics
- Currently, `maxCacheSizeInBytes` can stay as regular property since it's only accessed via `_updateMaxCacheSize()` which runs on the queue
- **In this case:** NOT needed since queue serializes all access

**Note:** The serial OperationQueue provides sufficient synchronization. @Atomic is useful for properties accessed directly outside the queue context (like PlayerEngine does with state).

---

#### Step 1.1.5: Update Player.swift Wrappers

**File:** `Sources/Player/Player.swift` - lines 359-378

**Current State:** Wrappers already exist and delegate to PlayerEngine

**Verify no changes needed:**
```swift
// These already delegate to threadsafe methods:
public func cacheUsageInBytes() -> Int {
    playerEngine.cacheUsageInBytes()  // Delegates to PlayerEngine (already thread-safe)
}

public func clearCache() {
    playerEngine.clearCache()  // Delegates to PlayerEngine (already thread-safe)
}

public func setCacheQuota(maxBytes: Int?) {
    playerEngine.setCacheQuota(maxBytes: maxBytes)  // Delegates (already thread-safe)
}
```

**Verify:** PlayerEngine.swift already wraps these with thread safety ✅

---

#### Step 1.1.6: Update Documentation

**File:** PlayerCacheManager.swift - class documentation

Update class header to reflect OperationQueue architecture:

```swift
/// Thread-safe cache manager for coordinating media asset downloads.
///
/// All public methods are thread-safe and can be called from any thread.
/// The manager uses a serial OperationQueue to ensure all cache operations
/// execute sequentially, matching the concurrency pattern used throughout
/// the Player SDK (see PlayerEngine for a similar implementation).
///
/// - Important: Async methods like ``recordPlayback(for:)`` dispatch work to
///   the queue and return immediately. Sync methods like ``resolveAsset(for:cacheKey:)``
///   block the calling thread until the operation completes, but do not block
///   other cache operations (serialized on the queue).
///
/// Example:
/// ```swift
/// // Safe to call from any thread
/// DispatchQueue.global().async {
///     manager.recordPlayback(for: cacheKey)
/// }
///
/// // Blocks until complete
/// let result = manager.resolveAsset(for: url, cacheKey: cacheKey)
/// ```
```

---

**Effort Estimate:** 20-30 hours
**Risk Level:** MEDIUM - behavioral change, but only affects threading
**Success Criteria:**
- ✅ All tests pass without modification
- ✅ No deadlocks detected
- ✅ Concurrent access stress test passes
- ✅ Documentation complete
- ✅ Matches PlayerEngine concurrency patterns

---

### 1.2 Add Database Index on lastAccessedAt

**Objective:** Optimize LRU pruning queries

**Implementation Steps:**

#### Step 1.2.1: Create Migration Function

**File:** `Sources/Player/PlaybackEngine/Internal/Cache/GRDBCacheStorage.swift`

**Location:** Add new function after `initializeDatabase()` (around line 130)

```swift
private func addLastAccessedAtIndex() throws {
    try dbQueue.write { db in
        // Check if index already exists to avoid errors on re-runs
        let indices = try db.schema(CacheEntryGRDBEntity.databaseTableName)?.indexes ?? []
        let indexExists = indices.contains { $0.name == "idx_cacheEntry_lastAccessedAt" }

        if !indexExists {
            try db.execute(sql: """
                CREATE INDEX idx_cacheEntry_lastAccessedAt
                ON \(CacheEntryGRDBEntity.databaseTableName)(lastAccessedAt)
                """)
        }
    }
}
```

**Why This Approach:**
- Idempotent: Safe to run multiple times
- Checks for existing index to avoid errors
- Creates index on first initialization or on migration

---

#### Step 1.2.2: Call Migration on Init

**File:** GRDBCacheStorage.swift - `init()` method

**Current Code (around line 63):**
```swift
public init(databaseURL: URL) throws {
    self.databaseURL = databaseURL
    self.dbQueue = try DatabaseQueue(path: databaseURL.path)
    try initializeDatabase()
}
```

**Updated Code:**
```swift
public init(databaseURL: URL) throws {
    self.databaseURL = databaseURL
    self.dbQueue = try DatabaseQueue(path: databaseURL.path)
    try initializeDatabase()
    try addLastAccessedAtIndex()  // Add this line
}
```

**Why After `initializeDatabase()`:**
- Ensures tables exist before creating indices
- Won't fail if tables don't exist
- Runs once per init

---

#### Step 1.2.3: Update pruneToSize Query

**File:** GRDBCacheStorage.swift - `pruneToSize()` method

**Current Implementation (around line 87-100):**
```swift
public func pruneToSize(_ targetSizeInBytes: Int) throws {
    try dbQueue.write { db in
        let allEntries = try CacheEntryGRDBEntity.fetchAll(db)
        let sortedByAge = allEntries.sorted { $0.lastAccessedAt < $1.lastAccessedAt }
        var currentSize = try calculateTotalSize(db)

        for entry in sortedByAge {
            guard currentSize > targetSizeInBytes else { break }
            try entry.delete(db)
            currentSize -= entry.size
        }
    }
}
```

**Optimized Implementation:**
```swift
public func pruneToSize(_ targetSizeInBytes: Int) throws {
    try dbQueue.write { db in
        // Calculate how much space we need to free
        let currentSize = try calculateTotalSize(db)
        guard currentSize > targetSizeInBytes else { return }

        let bytesToFree = currentSize - targetSizeInBytes
        var freedBytes = 0

        // Fetch entries sorted by age, without loading all into memory
        let entriesToDelete = try CacheEntryGRDBEntity
            .order(CacheEntryGRDBEntity.Columns.lastAccessedAt.asc)
            .fetchAll(db)

        for entry in entriesToDelete {
            guard freedBytes < bytesToFree else { break }
            try entry.delete(db)
            freedBytes += entry.size
        }
    }
}
```

**Key Improvement:**
- Database uses index for efficient sorting
- No in-memory sort needed
- Scales better with large cache sizes

---

#### Step 1.2.4: Add Query Performance Documentation

**File:** Add comment above pruneToSize()

```swift
/// Removes cache entries until total size is below the target.
///
/// Uses database-level sorting via the `idx_cacheEntry_lastAccessedAt` index
/// for efficient LRU (Least Recently Used) eviction. Entries are sorted by
/// `lastAccessedAt` in ascending order and deleted until cache size is below target.
///
/// - Parameter targetSizeInBytes: Target cache size in bytes
/// - Throws: Any database operation errors
/// - Performance: O(k log n) where k = entries to delete, n = total entries
///   Query is efficient due to database index on lastAccessedAt column
func pruneToSize(_ targetSizeInBytes: Int) throws {
```

---

**Testing:**

#### Test 1.2.1: Verify Index Creation
```swift
func testIndexCreatedOnInit() throws {
    let storage = try GRDBCacheStorage(databaseURL: testDatabaseURL)

    let indexExists = try storage.dbQueue.read { db in
        let indices = try db.schema(CacheEntryGRDBEntity.databaseTableName)?.indexes ?? []
        return indices.contains { $0.name == "idx_cacheEntry_lastAccessedAt" }
    }

    XCTAssertTrue(indexExists, "Index should be created on initialization")
}
```

#### Test 1.2.2: Verify Query Performance
```swift
func testPrunePerformance() throws {
    let storage = try GRDBCacheStorage(databaseURL: testDatabaseURL)

    // Add 1000 entries
    try addCacheEntries(count: 1000, to: storage)

    let startTime = Date()
    try storage.pruneToSize(1_000_000)  // Prune to 1MB
    let duration = Date().timeIntervalSince(startTime)

    // Should complete in < 100ms with index
    XCTAssertLessThan(duration, 0.1, "Prune should be fast with index")
}
```

---

**Effort Estimate:** 8-12 hours
**Risk Level:** LOW - purely additive, no existing code changes
**Success Criteria:**
- ✅ Index created on first initialization
- ✅ Index not re-created on subsequent opens
- ✅ Prune query uses index (verify with EXPLAIN QUERY PLAN)
- ✅ Performance test passes
- ✅ All existing tests still pass

---

### 1.3 Add Logging Infrastructure

**Objective:** Replace silent error handling with proper logging

**Implementation Steps:**

#### Step 1.3.1: Add TidalLogger Import and Initialize

**File:** `Sources/Player/PlaybackEngine/Internal/Cache/PlayerCacheManager.swift`

**Add at top with other imports (around line 1):**
```swift
import Logging  // Uses the existing apple/swift-log package

private var logger: TidalLogger?
```

**Initialize in PlayerCacheManager:**
```swift
// Add to init method:
public init(databaseURL: URL) throws {
    self.databaseURL = databaseURL
    self.dbQueue = try DatabaseQueue(path: databaseURL.path)
    // Initialize logger if global logger exists
    logger = PlayerWorld.logger
}
```

**Why TidalLogger:**
- Already used throughout the Auth and Player modules
- Uses apple/swift-log package (standardized)
- Structured logging via `TidalLoggable` protocol
- Consistent with existing codebase patterns
- Integrates with iOS logging system
- Thread-safe by design

---

#### Step 1.3.2: Create CacheLoggable Enum

**New File:** `Sources/Player/PlaybackEngine/Internal/Cache/CacheLoggable.swift`

```swift
import Logging

/// Structured logging events for cache operations
/// Follows the pattern of existing PlayerLoggable and AuthLoggable enums
enum CacheLoggable: TidalLoggable {
    case recordPlaybackFailed(cacheKey: String, error: Error)
    case persistCacheEntryFailed(cacheKey: String, error: Error)
    case calculateSizeFailed(url: URL, error: Error)
    case clearCacheFailed(error: Error)
    case deleteCacheFileFailed(fileName: String, error: Error)
    case pruningStarted(currentSize: Int, targetSize: Int)
    case pruningCompleted(newSize: Int, entriesRemoved: Int)
    case pruneFailed(error: Error)

    var loggingMessage: Logger.Message {
        switch self {
        case .recordPlaybackFailed(let cacheKey, let error):
            return "Failed to record playback for cache key: \(cacheKey)"
        case .persistCacheEntryFailed(let cacheKey, let error):
            return "Failed to persist cache entry: \(cacheKey)"
        case .calculateSizeFailed(let url, let error):
            return "Failed to calculate cache entry size for: \(url.lastPathComponent)"
        case .clearCacheFailed:
            return "Failed to clear cache"
        case .deleteCacheFileFailed(let fileName, let error):
            return "Failed to delete cache file: \(fileName)"
        case .pruningStarted(let current, let target):
            return "Cache quota exceeded. Pruning from \(current) to \(target) bytes"
        case .pruningCompleted(let newSize, let removed):
            return "Cache pruning completed. New size: \(newSize) bytes, removed: \(removed) entries"
        case .pruneFailed:
            return "Failed to prune cache to target size"
        }
    }

    var loggingMetadata: Logger.Metadata {
        switch self {
        case .recordPlaybackFailed(_, let error):
            return ["error": .string(error.localizedDescription)]
        case .persistCacheEntryFailed(_, let error):
            return ["error": .string(error.localizedDescription)]
        case .calculateSizeFailed(_, let error):
            return ["error": .string(error.localizedDescription)]
        case .clearCacheFailed(let error):
            return ["error": .string(error.localizedDescription)]
        case .deleteCacheFileFailed(_, let error):
            return ["error": .string(error.localizedDescription)]
        case .pruningStarted:
            return [:]
        case .pruningCompleted:
            return [:]
        case .pruneFailed(let error):
            return ["error": .string(error.localizedDescription)]
        }
    }

    var logLevel: Logger.Level {
        switch self {
        case .recordPlaybackFailed, .persistCacheEntryFailed, .calculateSizeFailed, .clearCacheFailed, .pruneFailed:
            return .error
        case .deleteCacheFileFailed:
            return .warning
        case .pruningStarted, .pruningCompleted:
            return .debug
        }
    }

    var source: String? {
        return "PlayerCacheManager"
    }
}
```

---

#### Step 1.3.3: Replace Silent Error Handlers with TidalLoggable

**Location 1: recordPlayback() - Line 162**

**Current Code:**
```swift
private func _recordPlayback(for cacheKey: String) {
    do {
        try cacheStorage.updateLastAccessedAt(for: cacheKey)
    } catch {
        // Intentionally ignored for now
    }
}
```

**Updated Code:**
```swift
private func _recordPlayback(for cacheKey: String) {
    do {
        try cacheStorage.updateLastAccessedAt(for: cacheKey)
    } catch {
        logger?.log(loggable: CacheLoggable.recordPlaybackFailed(cacheKey: cacheKey, error: error))
    }
}
```

**Why TidalLoggable Pattern:**
- Structured logging consistent with PlayerLoggable and AuthLoggable
- Metadata automatically captured in Logger.Metadata
- Log level determined by event type
- Easy to extend with new cache events
- Enables better filtering and monitoring

---

**Location 2: persistCacheEntry() - Line 184**

**Updated Code:**
```swift
private func persistCacheEntry(_ urlAsset: AVURLAsset, with cacheKey: String, type: CacheEntryType) {
    do {
        let size = try calculateSize(for: urlAsset)
        try cacheStorage.insertOrUpdateCacheEntry(key: cacheKey, type: type, url: urlAsset.url, size: size)
    } catch {
        logger?.log(loggable: CacheLoggable.persistCacheEntryFailed(cacheKey: cacheKey, error: error))
    }

    pruneCacheIfNeeded()
}
```

---

**Location 3: calculateSize() - Line 257**

**Updated Code:**
```swift
private func calculateSize(for urlAsset: AVURLAsset) -> Int {
    var totalSize = 0
    do {
        // ... size calculation logic ...
    } catch {
        logger?.log(loggable: CacheLoggable.calculateSizeFailed(url: urlAsset.url, error: error))
        return 0
    }
    return totalSize
}
```

---

**Location 4: clearCache() - Line 314**

**Updated Code:**
```swift
private func _clearCache() {
    do {
        let entries = try cacheStorage.getAllCacheEntries()
        for entry in entries {
            try cacheStorage.deleteCacheEntry(entry.key)
            do {
                try FileManager.default.removeItem(at: entry.url)
            } catch {
                logger?.log(loggable: CacheLoggable.deleteCacheFileFailed(fileName: entry.url.lastPathComponent, error: error))
                // Continue clearing other entries
            }
        }
    } catch {
        logger?.log(loggable: CacheLoggable.clearCacheFailed(error: error))
    }
}
```

---

**Location 5: pruneCacheIfNeeded() - Various**

**Updated Code:**
```swift
private func pruneCacheIfNeeded() {
    guard let maxCacheSizeInBytes, maxCacheSizeInBytes >= 0 else {
        return
    }

    do {
        let currentSize = try calculateTotalSize()
        guard currentSize > maxCacheSizeInBytes else { return }

        logger?.log(loggable: CacheLoggable.pruningStarted(currentSize: currentSize, targetSize: maxCacheSizeInBytes))

        try cacheStorage.pruneToSize(maxCacheSizeInBytes)

        let newSize = try calculateTotalSize()
        let entriesRemoved = /* calculate based on storage */ 0
        logger?.log(loggable: CacheLoggable.pruningCompleted(newSize: newSize, entriesRemoved: entriesRemoved))
    } catch {
        logger?.log(loggable: CacheLoggable.pruneFailed(error: error))
    }
}
```

---

#### Step 1.3.4: Integration with PlayerWorld

**File:** `Sources/Player/Player.swift` or `Sources/Player/PlayerWorld.swift`

**Ensure logger is available:**
```swift
// In PlayerWorld or similar:
public static var logger: TidalLogger? = nil

// Set when Player is initialized:
PlayerWorld.logger = TidalLogger(label: "Player", level: .debug)
```

The cache manager will automatically use `PlayerWorld.logger` for all logging operations.

---

#### Step 1.3.5: Add Debug Diagnostics Method

**File:** PlayerCacheManager.swift - add methods

```swift
/// Log current cache state (diagnostic method)
func dumpCacheState() {
    queue.async { [weak self] in
        do {
            let size = try self?.calculateTotalSize() ?? 0
            let entries = try self?.cacheStorage.getAllCacheEntries() ?? []

            var metadata: Logger.Metadata = [
                "entryCount": .string(String(entries.count)),
                "totalSize": .string(String(size))
            ]

            let message = Logger.Message(stringLiteral: "Cache state: \(entries.count) entries, \(size) bytes total")
            self?.logger?.log(level: .debug, message, metadata: metadata)

            for entry in entries {
                var entryMetadata: Logger.Metadata = [
                    "key": .string(entry.key),
                    "size": .string(String(entry.size)),
                    "accessed": .string(entry.lastAccessedAt.description)
                ]
                let entryMessage = Logger.Message(stringLiteral: "  - Cache entry")
                self?.logger?.log(level: .debug, entryMessage, metadata: entryMetadata)
            }
        } catch {
            self?.logger?.log(loggable: CacheLoggable.clearCacheFailed(error: error))
        }
    }
}
```

---

**Testing:**

#### Test 1.3.1: Verify CacheLoggable Events
```swift
func testCacheLoggableEvents() {
    let error = NSError(domain: "test", code: -1)

    // Test all CacheLoggable cases have correct log levels and messages
    let cases: [CacheLoggable] = [
        .recordPlaybackFailed(cacheKey: "key1", error: error),
        .persistCacheEntryFailed(cacheKey: "key2", error: error),
        .calculateSizeFailed(url: URL(string: "http://example.com")!, error: error),
        .clearCacheFailed(error: error),
        .deleteCacheFileFailed(fileName: "test.m3u8", error: error),
        .pruningStarted(currentSize: 5_000_000_000, targetSize: 4_000_000_000),
        .pruningCompleted(newSize: 3_900_000_000, entriesRemoved: 5),
        .pruneFailed(error: error)
    ]

    for loggable in cases {
        XCTAssertFalse(loggable.loggingMessage.description.isEmpty, "Message should not be empty")
        XCTAssertNotNil(loggable.logLevel, "Log level should be set")
        XCTAssertEqual(loggable.source, "PlayerCacheManager", "Source should identify cache manager")
    }
}
```

#### Test 1.3.2: Verify Logger Integration
```swift
func testLoggerIntegration() {
    // Verify cache manager uses PlayerWorld.logger
    let manager = PlayerCacheManager()

    // If logger is set
    PlayerWorld.logger = TidalLogger(label: "TestPlayer", level: .debug)

    // Trigger an operation that logs
    manager.recordPlayback(for: "non-existent-key")

    // Manual verification in console output
    // Look for log entries from PlayerWorld.logger
}
```

#### Test 1.3.3: No Functional Changes
```swift
func testLoggingDoesNotAffectFunctionality() {
    // Ensure adding logging doesn't change cache behavior
    let manager = PlayerCacheManager()

    // Run existing tests - should all pass
    // Logging is purely observational, optional when logger is nil
}
```

---

**Files to Create:**
- `Sources/Player/PlaybackEngine/Internal/Cache/CacheLoggable.swift` (new file with enum)

**Files to Modify:**
- `Sources/Player/PlaybackEngine/Internal/Cache/PlayerCacheManager.swift` - Add logger initialization and use CacheLoggable
- `Sources/Player/PlayerWorld.swift` or similar - Ensure logger property exists

**Effort Estimate:** 12-18 hours
**Risk Level:** LOW - only adds logging, no behavioral changes
**Success Criteria:**
- ✅ CacheLoggable enum created with all 8 cases
- ✅ All error cases now log via TidalLogger
- ✅ No "Intentionally ignored" comments remain
- ✅ All tests pass
- ✅ Logger is optional (logs only if PlayerWorld.logger is set)
- ✅ Metadata is properly captured in all log events
- ✅ Log levels match event severity

---

### 1.4 Fix Race Condition in clearCache()

**Objective:** Ensure atomic cache clearing

**Implementation Steps:**

#### Step 1.4.1: Identify the Race Condition

**Current Flow:**
```
Thread A (clearCache):
  1. queue.sync { _clearCache() }
  2. Get all entries from DB
  3. Iterate and delete entries

Thread B (Download complete):
  4.   (async) persistCacheEntry() called
  5.     insertOrUpdateCacheEntry() - NEW entry added to DB
  6.     pruneCacheIfNeeded() called

Result: Thread A finishes, but Thread B's entry survives
        (inconsistent cache state)
```

---

#### Step 1.4.2: Cancel Downloads During Clear

**File:** PlayerCacheManager.swift

**New Method (add around line 195):**
```swift
/// Internal: Cancel all in-progress downloads and clear cache atomically
private func _clearCacheAtomically() {
    // Step 1: Cancel all in-progress downloads
    // This ensures no new entries are added during clearing
    do {
        let activeDownloads = try cacheStorage.getActiveDownloads()
        for downloadKey in activeDownloads {
            avURLAssetFactory.cancelDownload(for: downloadKey)
        }
    } catch {
        logger.warning("Failed to get active downloads during cache clear: \(error.localizedDescription, privacy: .public)")
    }

    // Step 2: Wait a bit for any in-flight completion handlers to finish
    // (GRDB queue will serialize this anyway)
    Thread.sleep(forTimeInterval: 0.1)

    // Step 3: Delete all cache entries
    do {
        let entries = try cacheStorage.getAllCacheEntries()
        for entry in entries {
            try cacheStorage.deleteCacheEntry(entry.key)

            // Delete file with error handling
            do {
                try FileManager.default.removeItem(at: entry.url)
            } catch {
                logger.warning("Failed to delete file: \(entry.url.lastPathComponent, privacy: .public), error: \(error.localizedDescription, privacy: .public)")
            }
        }

        logger.info("Cache cleared: removed \(entries.count) entries")
    } catch {
        logger.error("Failed to clear cache: \(error.localizedDescription, privacy: .public)")
    }
}
```

**Key Points:**
- Cancel all downloads first (prevents new entries)
- Use GRDB's queue serialization (thread-safe by design)
- Sleep briefly to let pending operations finish
- Handle file deletion errors gracefully

---

#### Step 1.4.3: Update Public clearCache Method

**File:** PlayerCacheManager.swift - update existing method (around line 174)

**Current Code:**
```swift
public func clearCache() {
    queue.async { [weak self] in
        self?._clearCache()
    }
}
```

**Updated Code:**
```swift
public func clearCache() {
    queue.async { [weak self] in
        self?._clearCacheAtomically()
    }
}
```

---

#### Step 1.4.4: Verify Download Cancellation

**File:** Check AVURLAssetFactory has `cancelDownload()` method

**Location:** `Sources/Player/PlaybackEngine/Internal/Cache/AVURLAssetFactory.swift`

**Verify method exists (around line 140):**
```swift
public func cancelDownload(for cacheKey: String) {
    // Implementation should exist
    // If not, this is a blocker for this fix
}
```

**If method doesn't exist:**
```swift
public func cancelDownload(for cacheKey: String) {
    self.downloadTasks[cacheKey]?.cancel()
    self.downloadTasks.removeValue(forKey: cacheKey)
}
```

---

**Testing:**

#### Test 1.4.1: No Race Condition on Clear

```swift
func testClearCacheIsAtomic() {
    let manager = PlayerCacheManager()
    let expectation = self.expectation(description: "Clear complete")

    // Add some entries first
    for i in 0..<10 {
        manager.recordPlayback(for: "key-\(i)")
    }

    // Clear the cache
    manager.clearCache()

    // Verify cache is empty after a short delay
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        XCTAssertEqual(manager.currentCacheSizeInBytes(), 0)
        expectation.fulfill()
    }

    wait(for: [expectation], timeout: 2)
}
```

#### Test 1.4.2: Downloads Cancelled During Clear

```swift
func testDownloadsCancelledDuringClear() {
    let manager = PlayerCacheManager()

    // Start a download
    let avURLAsset = AVURLAsset(url: testVideoURL)
    manager.startCachingIfNeeded(avURLAsset, cacheState: nil)

    // Immediately clear cache
    manager.clearCache()

    // Verify no entries added after clear
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        XCTAssertEqual(manager.currentCacheSizeInBytes(), 0)
    }
}
```

---

**Effort Estimate:** 16-20 hours
**Risk Level:** MEDIUM - affects cache clearing logic
**Success Criteria:**
- ✅ Race condition eliminated (no entries added during clear)
- ✅ All existing tests pass
- ✅ New concurrency tests pass
- ✅ File system stays clean (no orphaned files)

---

### 1.5 Update Tests for Phase 1

**Objective:** Ensure all thread safety changes are tested

**Implementation Steps:**

#### Step 1.5.1: Add Concurrency Stress Tests

**File:** `Tests/PlayerTests/Cache/PlayerCacheManagerTests.swift`

**New Test Suite:**
```swift
class PlayerCacheManagerConcurrencyTests: XCTestCase {
    func testConcurrentRecordPlayback() {
        let manager = PlayerCacheManager()
        let dispatchGroup = DispatchGroup()

        for i in 0..<100 {
            dispatchGroup.enter()
            DispatchQueue.global().async {
                manager.recordPlayback(for: "key-\(i % 10)")
                dispatchGroup.leave()
            }
        }

        let result = dispatchGroup.wait(timeout: .now() + 5)
        XCTAssertEqual(result, .success)
    }

    func testConcurrentSizeQueries() {
        let manager = PlayerCacheManager()
        let dispatchGroup = DispatchGroup()
        var sizes: [Int] = []
        let lock = NSLock()

        for _ in 0..<50 {
            dispatchGroup.enter()
            DispatchQueue.global().async {
                let size = manager.currentCacheSizeInBytes()
                lock.lock()
                sizes.append(size)
                lock.unlock()
                dispatchGroup.leave()
            }
        }

        dispatchGroup.wait(timeout: .now() + 5)
        XCTAssertEqual(sizes.count, 50)
        // All sizes should be consistent (non-negative)
        XCTAssertTrue(sizes.allSatisfy { $0 >= 0 })
    }
}
```

---

**Effort Estimate:** 8-12 hours
**Success Criteria:**
- ✅ New concurrency tests pass consistently
- ✅ No deadlocks or timeouts
- ✅ All existing tests still pass
- ✅ Thread sanitizer shows no issues (run with TSAN)

---

### Phase 1 Summary

| Task | Effort | Risk | Status |
|------|--------|------|--------|
| Thread Safety | 20-30h | MEDIUM | ✅ To Do |
| Database Index | 8-12h | LOW | ✅ To Do |
| Logging | 12-18h | LOW | ✅ To Do |
| Race Condition | 16-20h | MEDIUM | ✅ To Do |
| Tests | 8-12h | LOW | ✅ To Do |
| **TOTAL** | **64-92h** | | |

**Delivery Target:** 2 PRs
- **PR 1:** Thread safety + logging infrastructure
- **PR 2:** Race condition fixes + database index + updated tests

---

## Phase 2: Performance Optimizations

**Goal:** Improve cache efficiency and speed
**Estimated Effort:** 40-50 hours
**PR Count:** 1-2 PRs

### 2.1 Add Entry Creation Timestamp

**Why:** Enables age-based queries and statistics

**Files to Modify:**
- `Sources/Player/PlaybackEngine/Internal/Cache/CacheEntry.swift` - Add `createdAt: Date`
- `GRDBCacheStorage.swift` - Add column to schema
- `PlayerCacheManager.swift` - Record timestamp on creation

**Implementation:**
```swift
// CacheEntry.swift
public struct CacheEntry {
    let key: String
    let url: URL
    let size: Int
    let lastAccessedAt: Date
    let createdAt: Date  // NEW
}

// GRDBCacheStorage migration
try db.execute(sql: """
    ALTER TABLE cacheEntry ADD COLUMN createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    """)
```

---

### 2.2 Optimize File Deletion Order

**Current:** Delete files, then metadata (risky on crash)
**New:** Delete metadata, then files (fail-safe)

**Implementation:**
```swift
private func deleteCacheEntry(key: String) throws {
    // Step 1: Delete from database first
    try cacheStorage.deleteCacheEntry(key)

    // Step 2: Delete file(s) - can fail without corrupting cache state
    if let entry = ... {
        try FileManager.default.removeItem(at: entry.url)
    }
}
```

---

### 2.3 Add Manifest Validation

**Goal:** Detect and clean up orphaned entries

**Implementation:**
```swift
func validateCacheIntegrity() throws -> CacheHealthReport {
    // Find metadata without files
    // Find files without metadata
    // Log discrepancies
    // Auto-clean as needed
}
```

---

**Effort Estimate:** 40-50 hours
**Delivery:** 1-2 PRs

---

## Phase 3: API Enhancements

**Goal:** Expose new cache operations to consumers
**Estimated Effort:** 60-80 hours
**PR Count:** 2-3 PRs

### 3.1 Cache Statistics API

**Add to PlayerCacheManaging protocol:**
```swift
public struct CacheStatistics {
    public let totalEntries: Int
    public let totalSizeBytes: Int
    public let oldestEntryAge: TimeInterval?
    public let averageEntryAge: TimeInterval
    public let youngestEntryAge: TimeInterval?
}

public func getCacheStatistics() -> CacheStatistics
```

**Implementation:** Query database for timestamps, calculate statistics

---

### 3.2 Entry Query API

**Add to PlayerCacheManaging protocol:**
```swift
public func getCachedEntries() -> [CacheEntry]
public func isCached(cacheKey: String) -> Bool
public func getCacheEntry(for cacheKey: String) -> CacheEntry?
```

---

### 3.3 Selective Clear Operations

**Add to PlayerCacheManaging protocol:**
```swift
public func clearCacheEntry(for cacheKey: String) throws
public func clearCacheOlderThan(days: Int) throws
public func clearCacheLargerThan(bytes: Int) throws
```

---

**Effort Estimate:** 60-80 hours
**Delivery:** 2-3 PRs

---

## Phase 4: Observability Features

**Goal:** Monitor cache health and events
**Estimated Effort:** 30-40 hours
**PR Count:** 1-2 PRs

### 4.1 Cache Event Notifications

**Implement delegate pattern:**
```swift
public protocol PlayerCacheManagerDelegate: AnyObject {
    func playerCacheManager(_ manager: PlayerCacheManager, didAddEntry: CacheEntry)
    func playerCacheManager(_ manager: PlayerCacheManager, didEvictEntry: CacheEntry)
    func playerCacheManager(_ manager: PlayerCacheManager, didFailWithError: Error)
}

public var delegate: PlayerCacheManagerDelegate?
```

---

### 4.2 Cache Health Verification

**Add verification method:**
```swift
public struct CacheHealthReport {
    public let isHealthy: Bool
    public let orphanedMetadata: [String]
    public let orphanedFiles: [URL]
    public let corruptedEntries: [String]
    public let repairsApplied: Int
}

public func verifyCacheHealth(autoRepair: Bool = false) -> CacheHealthReport
```

---

**Effort Estimate:** 30-40 hours
**Delivery:** 1-2 PRs

---

## Testing Strategy

### Unit Tests (Per Phase)

```swift
// Phase 1 Tests
- testThreadSafety_ConcurrentRecordPlayback()
- testThreadSafety_ConcurrentSizeQueries()
- testDatabaseIndex_QueryPerformance()
- testLogging_ErrorMessages()
- testRaceCondition_ClearAndDownload()

// Phase 2 Tests
- testTimestamp_CreatedAtRecorded()
- testDeletionOrder_MetadataFirst()
- testValidation_OrphanedEntries()

// Phase 3 Tests
- testStatistics_EntryCount()
- testStatistics_AverageAge()
- testQuery_CachedEntries()
- testSelectiveClear_ByAge()

// Phase 4 Tests
- testDelegateCallback_OnEvict()
- testHealthReport_ValidatesCache()
```

### Integration Tests

```swift
- testFullCacheLifecycle_WithConcurrency()
- testCachePersistence_AcrossAppRestart()
- testQuotaEnforcement_WithMultiplePlayers()
```

### Performance Benchmarks

```swift
- benchmarkPruning_1000Entries()
- benchmarkSizeCalculation_LargeCache()
- benchmarkConcurrentAccess_100Threads()
```

---

## Migration & Rollout

### Backwards Compatibility

- ✅ All public APIs remain compatible
- ✅ Existing tests should pass without modification
- ✅ Default behavior unchanged (internal optimization only)

### Rollout Strategy

1. **Phase 1** - Merge to main, internal only (thread safety)
2. **Phase 2** - Performance improvements, no API changes
3. **Phase 3** - New APIs, opt-in from consumers
4. **Phase 4** - New features, opt-in from consumers

### Documentation Updates

- [ ] Update AGENTS.md cache section
- [ ] Add DocC bundle for new APIs
- [ ] Create migration guide for Phase 3 new APIs
- [ ] Add troubleshooting section

---

## Success Criteria

### Phase 1 Complete When:
- ✅ All thread safety tests pass
- ✅ No data races detected by Thread Sanitizer
- ✅ Database queries use index (EXPLAIN QUERY PLAN verified)
- ✅ All error cases logged
- ✅ Race condition tests pass
- ✅ Performance overhead < 5%

### Phase 2 Complete When:
- ✅ Timestamps recorded on all entries
- ✅ File deletion order corrected
- ✅ Orphaned entries auto-cleaned
- ✅ Validation tests pass

### Phase 3 Complete When:
- ✅ Statistics API returns correct data
- ✅ Entry queries work for all scenarios
- ✅ Selective clear operations functional
- ✅ All new APIs tested

### Phase 4 Complete When:
- ✅ Delegate callbacks fire reliably
- ✅ Health checks detect all issues
- ✅ Auto-repair functional
- ✅ Observability tests pass

---

## References

### Related Files

- `Sources/Player/Configuration.swift` - Cache quota config
- `Sources/Player/Player.swift` - Public cache API
- `Sources/Player/PlaybackEngine/PlayerEngine.swift` - Cache integration
- `Sources/Player/PlaybackEngine/Internal/Cache/PlayerCacheManager.swift` - Main implementation
- `Sources/Player/PlaybackEngine/Internal/Cache/GRDBCacheStorage.swift` - SQLite storage
- `Sources/Player/PlaybackEngine/Internal/Cache/CacheEntry.swift` - Data structure
- `Tests/PlayerTests/Cache/PlayerCacheManagerTests.swift` - Existing tests

### Related PRs

- #272 - Introduce CacheManager
- #273 - Cache quota implementation
- (Future) Phase 1 - Critical fixes
- (Future) Phase 2 - Performance
- (Future) Phase 3 - API enhancements
- (Future) Phase 4 - Observability

---

## Questions & Contact

For questions about this implementation guide:
- Check existing code comments
- Review related commits in `player/cache-quota` branch
- Ask in team Slack #player-sdk channel

---

**Document created:** 2025-10-30
**Last review:** By Cache Manager implementation team
**Next review:** After Phase 1 completion
