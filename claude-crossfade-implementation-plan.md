# Crossfade Implementation Plan

**Version:** 2.0
**Date:** 2025-10-20
**Status:** Approved for Implementation

---

## Objective

Add user-configurable crossfade support (2-5 seconds) for audio-only tracks while preserving gapless playback for all other content.

---

## Architecture

### Player Implementations

**DualAVPlayerWrapper** (NEW):
- Audio-only (.TRACK product type)
- Dual AVPlayer instances with role-swapping
- Equal-power volume crossfade
- Player clock-based timing

**AVQueuePlayerWrapper** (UNCHANGED):
- All content types
- Gapless playback
- Zero modifications (zero risk)

### Player Selection

Both players always created at InternalPlayerLoader initialization. Selection per-item via `canPlay()`:

```
DualAVPlayerWrapper.canPlay(productType, codec, ...):
    return productType == .TRACK
           && featureFlagProvider.isCrossfadeEnabled()
           && supportedCodecs.contains(codec)

AVQueuePlayerWrapper.canPlay(...):
    return true  // Fallback for all content
```

**Result:** Audio tracks route to DualAVPlayerWrapper when enabled; everything else routes to AVQueuePlayerWrapper.

---

## Technical Approach

### Role-Swapping Pattern

```
Player A: Foreground (Track 1) → Fade out → Cleanup → Load Track 3 → Fade in → Foreground
Player B: Background (idle) → Load Track 2 → Fade in → Foreground (Track 2) → Fade out → Cleanup

Cycle repeats with players alternating foreground/background roles
```

### Equal-Power Crossfade

```
fadeOutGain = cos(progress × π/2)
fadeInGain = sin(progress × π/2)

playerA.volume = loudnessA × fadeOutGain
playerB.volume = loudnessB × fadeInGain

Property: sin²(x) + cos²(x) = 1 → constant perceived loudness
```

### Sample-Accurate Timing

Use `addPeriodicTimeObserver()` (player clock) instead of `Timer` (wall clock).

**Benefits:**
- Tied to audio samples
- Survives app backgrounding
- Works with AirPlay

**Observer Cleanup:**
Track owner player via `timeObserverPlayer` property. After role swap, remove from owning player:

```
ownerPlayer = (timeObserverPlayer == .a) ? playerA : playerB
ownerPlayer.removeTimeObserver(token)
```

### AirPlay Fallback

**Route Capability:**
- `.full` (local/wired/Bluetooth): User's configured duration (2-5s)
- `.limited` (AirPlay): min(configured duration, 1.5s) - capped for safety
- `.noOverlap` (incompatible): skip crossfade

**Implementation:**
Detect route before triggering. Adjust duration based on capability or skip crossfade. Monitor route changes and abort if downgraded.

---

## Implementation Requirements

### Configuration

Add to `Configuration.swift`:
```
public var crossfadeEnabled: Bool = false
public var crossfadeDuration: TimeInterval = 3.0  // User-configurable (2-5s range)
public var crossfadeCurve: CrossfadeCurve = .equalPower

public enum CrossfadeCurve {
    case equalPower, linear, logarithmic
}

// Validation helpers
static let crossfadeDurationRange: ClosedRange<TimeInterval> = 2.0...5.0
static let crossfadeDurationDefault: TimeInterval = 3.0

func validatedCrossfadeDuration() -> TimeInterval {
    return crossfadeDuration.clamped(to: crossfadeDurationRange)
}
```

Add to `FeatureFlagProvider.swift`:
```
public var isCrossfadeEnabled: () -> Bool
```

**User Preference Flow:**
```
1. User adjusts crossfade duration in settings (2s, 3s, 4s, or 5s)
2. App creates Configuration with user's duration preference
3. DualAVPlayerWrapper receives configuration and validates duration
4. Trigger offset automatically adjusted: duration + 0.5s
```

### DualAVPlayerWrapper Core

**Terminology:** Use foreground/background instead of primary/secondary for clarity.

```
final class DualAVPlayerWrapper: GenericMediaPlayer {
    private var playerA, playerB: AVPlayer
    private var roleA, roleB: PlayerRole  // .foreground or .background
    private var playerAAsset, playerBAsset: AVPlayerAsset?
    private var crossfadeState: CrossfadeState  // .idle, .preparing, .active
    private var timeObserverToken: Any?
    private var timeObserverPlayer: PlayerIdentifier?  // .a or .b
    private let assetFactory: AVURLAssetFactory
    private let queue: OperationQueue
}
```

### Asset Caching

Must use `assetFactory.get(with: cacheKey)` to handle:
- `.none` → create new asset
- `.notCached` → create asset + trigger caching
- `.cached(url)` → use offline version

This preserves offline playback and content prefetching.

### Crossfade Trigger

Monitor foreground player progress. When time remaining ≤ (crossfadeDuration + 0.5s):

1. Check route capability
2. Check track duration ≥ (crossfadeDuration + minimum buffer)
3. Check next track ready
4. If all pass: start crossfade with configured duration
5. If any fail: skip crossfade (play current to end)

**Minimum track duration:** `max(10.0, crossfadeDuration × 2)` to avoid fading most of the track.

### Volume Ramp

```
timeObserverToken = fadeOutPlayer.addPeriodicTimeObserver(interval, queue) { time in
    currentTime = CMTimeGetSeconds(time)  // Player clock
    progress = (currentTime - startTime) / duration

    (fadeOutGain, fadeInGain) = config.curve.gains(at: progress)

    // Apply loudness normalization + fade curve
    fadeOutVolume = loudnessOut × fadeOutGain
    fadeInVolume = loudnessIn × fadeInGain

    // CRITICAL: Clamp combined gain to prevent clipping
    combinedGain = fadeOutVolume + fadeInVolume
    if combinedGain > 1.0:
        scale = 1.0 / combinedGain
        fadeOutVolume ×= scale
        fadeInVolume ×= scale
        log clipping prevented

    fadeOutPlayer.volume = fadeOutVolume
    fadeInPlayer.volume = fadeInVolume

    if progress ≥ 1.0:
        fadeOutPlayer.removeTimeObserver(token)
        completeCrossfade()
}

timeObserverPlayer = fadeOutPlayerID  // Track owner
```

### Protocol Safety Nets

```
extension DualAVPlayerWrapper: VideoPlayer {
    func renderVideo(...) { fatalError("Use AVQueuePlayerWrapper") }
}

extension DualAVPlayerWrapper: LiveMediaPlayer {
    func loadLive(...) { fatalError("Use AVQueuePlayerWrapper") }
}

extension DualAVPlayerWrapper: UCMediaPlayer {
    func loadUC(...) { fatalError("Use AVQueuePlayerWrapper") }
}
```

These should never execute (canPlay() prevents routing).

---

## Edge Cases

**Skip crossfade when:**
- Track < max(10s, crossfadeDuration × 2)
- Next track not ready
- Route incompatible (.noOverlap)
- Invalid duration (< 2s or > 5s after validation)

**Abort crossfade when:**
- User skips (immediate cut to next)
- User seeks (abort, then seek)
- Network stall on next
- Route downgrades mid-fade
- Error on either player

**Pause crossfade when:**
- User pauses (pause both players, observer stops naturally)

**Queue for after:**
- Volume changes during crossfade

---

## File Modifications

**New:**
- `Sources/Player/PlaybackEngine/Internal/DualAVPlayer/DualAVPlayerWrapper.swift`
- `Tests/PlayerTests/DualAVPlayerWrapperTests.swift`
- `Tests/PlayerTests/PlayerEngineCrossfadeTests.swift`

**Modified:**
- `Sources/Player/Configuration.swift` (add 3 properties)
- `Sources/Player/Common/FeatureFlags/FeatureFlagProvider.swift` (add 1 flag)
- `Sources/Player/Common/FeatureFlags/FeatureFlagProvider+Standard.swift` (add default)
- `Sources/Player/Common/Logging/PlayerLoggable.swift` (add log methods)
- `Sources/Player/PlaybackEngine/Internal/InternalPlayerLoader.swift` (register DualAVPlayerWrapper)

**Unchanged:**
- `Sources/Player/PlaybackEngine/Internal/AVQueuePlayer/AVQueuePlayerWrapper.swift`
- All existing tests

---

## Critical Implementation Notes

1. **Both players always created** - Selection happens in canPlay(), not initialization
2. **Feature flag checked in canPlay()** - Allows runtime toggling
3. **Observer owner must be tracked** - Prevents memory leak after role swap
4. **Asset factory must be used** - Preserves offline playback
5. **Player clock required** - Timers cause glitches during backgrounding
6. **Route capability required** - Some AirPlay receivers reject dual players
7. **Gain clamping required** - Prevent clipping when both tracks have high loudness levels

---

## Success Metrics

| Metric | Target |
|--------|--------|
| Crossfade success rate | > 99% |
| Crash rate | < 0.1% |
| Memory peak | < 100MB |
| Battery impact | < 10% |
| Fallback rate | < 5% |

---

## Future Enhancements (Post-MVP)

**Deferred until MVP stable:**
- Shared service extraction (PlayerAssetRegistry, PlayerMonitoringHub, LoudnessVolumeController)
- Extended duration range (1-10s) if user feedback warrants
- Smart context detection (album boundaries, live recordings, classical music)
- Receiver-specific AirPlay optimization (.noOverlap detection)
- Visual indicator during crossfade
- Advanced fade curves (S-curve, genre-specific)

---

*Plan developed collaboratively by Claude and Codex engineers through iterative code review*
