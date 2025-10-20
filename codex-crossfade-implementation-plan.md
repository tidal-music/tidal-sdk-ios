# Codex Crossfade Implementation Plan

## 1. Objective
- Introduce seamless crossfade playback for the Player SDK while preserving existing gapless playback behaviour as the default.
- Maintain support for HLS (online and offline) with FairPlay DRM, loudness normalization, caching, metrics, DJ session events, and AirPlay.
- Limit regressions by isolating crossfade logic in a new player implementation, allowing the existing `AVQueuePlayerWrapper` to remain the gapless engine.

## 2. Scope
- **In scope**
	- Add a new `DualAVPlayerWrapper` implementation conforming to `GenericMediaPlayer` for audio crossfade scenarios.
	- Keep `AVQueuePlayerWrapper` untouched as the default path for gapless, video, broadcast, live, and UC playback.
	- Reuse existing asset/caching/monitoring infrastructure via composition; postpone large shared-service refactors until after the MVP proves stable.
	- Support crossfade for on-demand track playback (streaming and offline) with FairPlay DRM.
- Provide feature-flag and configuration toggles (enable, user-configurable duration within 2–5 s boundaries, curve) plus route capability detection to choose between crossfade and gapless runtime.
	- Ensure loudness normalization, events, and metrics behave correctly when two players overlap.
	- Add tests and QA strategy covering key device routes (local, AirPlay, Bluetooth) and content types.
- **Out of scope**
	- Crossfade for video, live broadcasts, DJ streams, or UC streams (remain on `AVQueuePlayerWrapper`).
	- DSP changes beyond volume ramps (e.g., EQ or dynamic range).
	- Major redesign of the Player engine’s public API (keep current surface).
	- Pre-MVP extraction of shared services (track as potential follow-up once the new player is stable).

## 3. Current Architecture Summary
- `GenericMediaPlayer` protocol (`Sources/Player/PlaybackEngine/Internal/MediaPlayers/GenericMediaPlayer.swift`) defines the interface used by `InternalPlayerLoader`.
- `AVQueuePlayerWrapper` supplies gapless playback, caching hooks, loudness normalization, monitoring delegates, and DRM handling.
- `InternalPlayerLoader` instantiates `mainPlayer` + `externalPlayers` and selects by calling `canPlay(...)`.
- `Asset` subclasses tie a player instance to caching and loudness configuration; assets are tracked by the loader and `PlayerEngine`.
- Loudness normalization currently sets the single `AVQueuePlayer.volume` per active item.
- Gapless playback is achieved by keeping one `AVQueuePlayer` queue and inserting next items in advance; transitions rely on `advanceToNextItem()`.

## 4. Proposed Architecture
### 4.1 Player Implementations
- Keep `AVQueuePlayerWrapper` untouched for all gapless and non-crossfade content; it remains the battle-tested default path.
- Introduce a self-contained `DualAVPlayerWrapper` (`GenericMediaPlayer`) that internally manages two `AVPlayer` instances (`foreground` and `background`) to enable overlaps.
- Compose with existing helpers (`Asset`, `AVPlayerAsset`, caching factories, monitoring delegates) directly inside the new wrapper. Only factor out shared services after the MVP if duplication becomes a maintenance issue.
- Document follow-up candidates (e.g., shared monitoring hub, loudness controller) but defer their extraction until crossfade behaviour is stable in production.

### 4.2 DualPlayer Responsibilities
- Hold two `AVPlayer` instances and orchestrate playback transitions.
- Manage state machine for:
	- Idle: only foreground player exists (background idle).
	- Preparing next: background player loads next `AVPlayerItem`, pre-buffered to ready state.
	- Crossfading: both players output; schedule volume ramps; ensure combined gain ≤ 1.
	- Cleanup: after fade, release former foreground player and create a new idle instance.
- Handle seeks, skips, stalls, and failures:
	- Cancel pending crossfade when user seeks/skips; reassign players appropriately.
	- On stall or failure of background player, revert to hard cut (and report error).
- Continue using `OperationQueue` for serialized operations mirroring `AVQueuePlayerWrapper.queue`.

### 4.3 Asset Handling
- Start by reusing the existing `AVPlayerAsset` subclass used by `AVQueuePlayerWrapper`; only introduce a dedicated `DualPlayerAsset` if we encounter behaviour that needs per-player bookkeeping (e.g., fade metadata).
- Regardless of the concrete type, ensure assets continue to expose caching state, loudness normalization data, and metrics hooks through the existing APIs so PlayerEngine remains unaware of the implementation swap.

### 4.4 Crossfade Scheduling
- Source transition triggers from playback progress monitoring; when remaining time ≤ configured crossfade duration (default 3 s, clamped to the 2–5 s user-selected value), start background preparation.
- Background preparation:
	1. Acquire next asset via `AssetCacheState` (pull from `assetFactory`).
	2. Instantiate `AVPlayerItem`, register it, and attach to background player.
	3. Apply loudness normalization gain to background player initially at 0 output.
- Fade orchestration:
	- Drive the overlap with an equal-power (sin/cos) volume curve so perceived loudness remains constant between tracks.
	- Schedule volume updates using `AVPlayer.addPeriodicTimeObserver` tied to the foreground player’s clock; this keeps the fade sample-accurate across backgrounding, throttled run loops, and AirPlay.
- When fade completes:
	- Swap foreground/background roles.
	- Emit delegate events once (matching existing sequence) and remove the old player’s observer before tearing it down.
	- Destroy the old background player and recreate an idle instance (preventing resource creep).

### 4.5 Loudness Normalization
- Retain the current loudness normalization pipeline (gain derived from `LoudnessNormalizer`) and apply it per player when playback starts.
- During the overlap, compute `combinedGain = foregroundGain * fadeOut + backgroundGain * fadeIn` and clamp to ≤ 1.0 to avoid clipping; log cases where clamping occurs for telemetry.
- If shared loudness logic becomes unwieldy, extract a `LoudnessVolumeController` as a follow-up task once MVP stability is confirmed.

### 4.6 Gapless Interplay
- When crossfade is disabled (via config flag or unsupported route), `InternalPlayerLoader` should choose `AVQueuePlayerWrapper`.
- When crossfade is enabled and supported, loader picks `DualPlayer`.
- For unsupported transitions (e.g., AirPlay remote that rejects dual playback), `DualPlayer` should detect failure conditions and either:
	1. fall back to a hard cut within `DualPlayer`, or
	2. signal `InternalPlayerLoader`/`PlayerEngine` to relaunch the track with the gapless player.
- Document fallback hierarchy: crossfade > gapless; crossfade disabled or unsupported -> gapless.

### 4.7 FairPlay & Offline
- Keep DRM flow identical by reusing `AVPlayerItem` creation pipeline (content key sessions per asset).
- Ensure `DualPlayer` uses same `AVContentKeySession` handling and `assetFactory` caching.
- Offline HLS: background player should load from cached file URLs with identical logic; no special-case code expected.

### 4.8 AirPlay / External Routes
- Query `AudioInfoProvider.isAirPlayOutputRoute()` (and inspect `AVAudioSession` outputs) on each route change and before scheduling crossfade to determine whether the current target supports dual-player playback.
- If the route rejects dual playback (e.g., certain TVs/HomePods), abort the overlap and fall back to gapless for the rest of that session; emit telemetry so we can gauge fallback frequency.
- If the route allows overlap, proceed with crossfade but keep monitoring for mid-fade route changes and abort gracefully if the target revokes support.
- Track capability state so we can re-enable crossfade automatically when returning to a compliant local route.

### 4.9 Metrics & Events
- `PlayerMonitoringDelegate` contract must remain consistent:
	- `playing(asset:)` fired once when the fade-in item becomes audible.
	- `completed(asset:)` fired when the fade-out item is fully removed.
	- Combine progress metrics: ensure ramp start doesn’t double-report times.
- DJ session integration: ensure `PlayerEngine` sees consistent state updates with crossfade.
	- `PlayerEngine.state` transitions must occur when foreground player enters playing/paused states.
	- For crossfade, confirm start/pause/resume events continue to align with user perception.

### 4.10 PlayerLoader Integration
- Modify `InternalPlayerLoader`:
	- Pass `DualPlayer.self` as the first `externalPlayer` when crossfade is enabled (feature flag/config).
	- Provide initializer parameter or configuration entry for crossfade settings (duration, curve).
	- Expose runtime toggle (e.g., new `Configuration` property) allowing crossfade to be activated/deactivated without reinstantiating the loader.
- `canPlay(...)` on `DualPlayer` should mirror `AVQueuePlayerWrapper` capabilities for track playback; return false for unsupported product types (video, broadcast, UC).

### 4.11 Feature Flags & Configuration
- Introduce configuration values:
	- `crossfadeEnabled` (bool).
	- `crossfadeDuration` (seconds, clamp to 2–5 s range for user-facing selection).
	- `crossfadeCurve` (linear, logarithmic, etc.) if needed.
- Store in existing `Configuration` (`Sources/Player/Configuration.swift`).
- Ensure hot updates propagate:
	- When toggled off, switch active player for future loads; current playback may need to finish on whichever player is active.
	- When toggled on mid-session, next queued item should use `DualPlayer`.

### 4.12 Testing & QA Plan
- **Unit tests**
	- `DualPlayer` state machine transitions (prepare, overlap, cleanup).
	- Volume controller tests for gain clamping.
	- Loader selection tests verifying crossfade flag and route changes pick the right player.
	- Loudness normalization updates propagate to both players.
	- Configurable duration respected and clamped to 2–5 s; verify fade scheduling at both boundaries.
- **Integration tests (possibly using existing `PlayerTests`)**
	- Simulate sequential track playback with crossfade enabled/disabled.
	- Seek/skip during fade to ensure no crash or stuck state.
	- Offline playback verification.
	- DRM handshake remains active on crossfade transitions.
- **Manual QA**
	- iOS Sim and device tests for local speaker, Bluetooth, wired, AirPlay.
	- Validate CPU/memory impact during overlap.
	- Confirm metrics/DJ events with analytics tools.

### 4.13 Migration & Rollout
- Ship crossfade behind feature flag disabled by default.
- Provide telemetry to compare error/stall rates between players.
- Gradually enable via remote config (if available) for cohorts.
- Maintain ability to revert to gapless by toggling flag at runtime.

### 4.14 Risks & Mitigations
- **Risk:** Dual player introduces race conditions or deadlocks.  
	- **Mitigation:** Keep serialized operation queue, add thorough unit tests, audit for main-thread interactions.
- **Risk:** AirPlay compatibility.  
	- **Mitigation:** Detect route support and fallback gracefully; test multiple AirPlay targets early.
- **Risk:** Loudness peaks during overlap.  
	- **Mitigation:** Implement gain clamping and optional dynamic adjustment when both tracks near full scale.
- **Risk:** Increased resource usage on low-end devices.  
	- **Mitigation:** Monitor memory/CPU; allow configuration to shorten fade or disable on constrained routes.
- **Risk:** DRM issues for FairPlay streams.  
	- **Mitigation:** Reuse existing asset/session pipeline; add automated tests for license renewal across crossfade.

### 4.15 Timeline Rough Draft
1. Architecture groundwork, configuration wiring, and dual-player scaffolding (1–2 weeks).
2. Implement `DualPlayer` core (2–3 weeks).
3. Integrate with loader, feature flags, configuration updates (1 week).
4. Loudness overlap clamping + observer/resource polish (1 week).
5. Testing + QA cycles (2+ weeks).
6. Beta rollout & telemetry monitoring (ongoing).

Timeline assumes parallel work on helper extraction and DualPlayer prototyping; adjust based on team capacity.

### 4.16 Documentation Notes
- Keep detailed pseudo-code, test matrices, and reference snippets in companion technical notes so this plan stays focused on deliverables.
- Revisit optional follow-up items once crossfade metrics meet success thresholds.

### 4.17 Post-Stability Enhancements (Next Steps)
Pursue these once crossfade has been stable in production for at least one release cycle:
- Evaluate extracting common services (monitoring hub, loudness controller, asset registry) to reduce duplication between player wrappers.
- Expose user-facing preferences (e.g., enable/disable crossfade per session, adjustable duration/curve) backed by the configuration surface already in place.
- Add smart crossfade heuristics (disable around gapless album boundaries, live recordings, classical transitions) informed by telemetry.
- Consider richer fade options (longer durations, alternative curves) and UI indicators once baseline performance and UX metrics remain positive.
- Expand automated testing to cover new routes (CarPlay, macOS Catalyst) and gather metrics for additional hardware targets before broadening availability.
