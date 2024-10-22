# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.3.39] - 2024-10-22
### Changed
- Make OfflineEngine non-optional in Player setup (Logging)
- Improved License handling for Offlined items (Player)
- Rename Offlined HLS assets (Player)

### Fixed
- Fix OfflineItem data race in download finalization (Player)

## [0.3.38] - 2024-10-18
### Changed
- Make source optional + added documentation (Logging)
- Refactor OfflineEngine Listener setup and handling (Player)

### Added
- Add `Common` product (SDK)
- Add FF `shouldNotPerformActionAtItemEnd` for not performing any action when item reaches end (Player)

### Fixed
- Fix OfflineItem size calculation
- Fix OfflineEntry deletion edge cases

## [0.3.37] - 2024-10-15

### Added
- Calculate size of downloaded MediaProducts (Player)
- Upgraded OfflineEngine from dev flag to feature flag (Player)
- New AnyCodable Extras class for the PlayLog metadata (Player)

### Fixed
- Reworked AVQueuePlayerWrapper and cache integration to try to solve an enqueue crash (Player)

## [0.3.36] - 2024-10-10
### Added
- Add new FF `shouldPauseAndPlayAroundSeek` and related logic to pause and play around the seek call (Player)
- Simple logging API (Logging)

### Removed
- Remove unnecessary logging in Player (Player)

### Changed
- Better error descriptions in Auth (Auth)

## [0.3.35] - 2024-09-24
### Added
- Add more logging in Player (Player)
- Add `sendAllEvents` func in `TidalEventSender` (EventProducer)

## [0.3.34] - 2024-09-17
### Changed
- Format unformatted code
- Update unit test action
- Do not set up logging system in the Auth module (Logging)
- Update Logging library version to latest version (Logging)
- Add support to new logging structure in Auth (Auth)
- Update StreamingMetrics support for new offliner (Player)
- Integrate new OfflineStorage layer into OfflineEngine and PlaybackEngine (Player)
- Make OfflineStorage optional for PlaybackEngine for now (Player)

### Added
- Add common code for logging (Logging)
- Add logging support in Player (Player)
- Add database-backed persistence layer for Asset Cache (Player)
- Add database-backed persistence layer for Offline (Player)
- Public interface for OfflineEngine (Player)

### Removed
- Remove `setupUserConfiguration` from `Player` (Player)

### Fixed
- Fix parsing error in `clientIdFromToken` in `CredentialsSuccessDataParser` (Player)

## [0.3.33] - 2024-09-10
### Changed
- Do not set up logging system in the Auth module (Auth)

## [0.3.32] - 2024-09-3
### New
- New `MediaProduct.referenceId` and `MediaProduct.extras` fields as part of the Player spec (Player)

### Removed
- `isStallWhenTransitionFromEndedToBufferingEnabled` from `FeatureFlagProvider` (Player)
- `Interruption` as a subclass of `MediaProduct` (Player)
- `ProgressEvents` are no longer reported (Player)

### Changed
- Allow calls to `setNext` with the same `productId` but with a different type of `MediaProduct` class. (Player)

## [0.3.30] - 2024-08-27
### Changed
- Reworked the encoding logic of the payloads (EventProducer)

## [0.3.29] - 2024-08-13
### Changed
- Add more log data in the error message to help with debugging (Player)

## [0.3.28] - 2024-08-06 
### New
- Multiple unit tests for Playlog (Player)

### Fixed
- Made accessing credentials thread safe (Auth)

## [0.3.27] - 2024-07-30 
### New
- Use [swift-log](https://github.com/apple/swift-log) library for logging different events (Auth)

### Fixed
- Fixed crash for the new cache implementation in AVQueuePlayerWrapper (Player)

## [0.3.26] - 2024-07-23 
### Fixed
- Made access to the database queue thread-safe (EventProducer)

### Changed
- Refactoring of configuration and schedulers (EventProducer)
- Invalidate existing schedulers in case of reconfiguration (EventProducer)
- Throw error in case of misconfiguration (EventProducer)

## [0.3.25] - 2024-07-09 
### Fixed
- Readme had Polish language link instead of English
- Attempt to fix crashes + better logging (EventProducer)

### New
- Added new empty catalogue module
- Check Queue Size (EventProducer)
- Added step to update chagelog in readme when releasing a new version

## [0.3.24] - 2024-06-17 
### Fixed
- Fixed SQLITE_LOCKED errors (EventProducer)
- Enforced Player cache delegate calls in the same queue as playback (Player)
- Playback was not stopping immediately on reset (Player)
- Fix for long buffering due to caching in some situations (Player)

### Changed
- Split GenericMediaPlayer responsibilities (Player)

## [0.3.23] - 2024-06-11 
### Changed
- Improved caching implementation for AVPlayer (Player)

### New
- New FeatureFlag for the improved caching implementation (Player)
- New sessionTag in StreamingMetrics to track new caching implementation (Player)
- Support for new immersiveAudio param in playbackinfo (Player)

## [0.3.22] - 2024-06-10 
### Changed
- Use absolute URLs in documentation links
- Update Common module README.md
- Move PlayLog tests to a separate GH Action
- Migrate `shouldSendEventsInDeinit` dev flag to production
### Fixed
- Steps for ClientCredentials flow (Auth)
- Test flakiness in PlayerEventSender (Player)
- Append `client_unique_key` only if present (Auth)

## [0.3.21] - 2024-05-27 
### Added
- Add `.CACHING_DISABLED` tag to Player metrics (Player)
- Added new PlayerError `.PENotSupported` for media not supported (Player)
- Use of `@_exported Common` with all of our Products
### Changed
- Removed `clientToken` from Player bootstrap (Player)
- Renamed `Environment` to `BuildEnvironment` (EventProducer)
- Align EventProducer interface implementation with other modules (EventProducer)
### Fixed
- Fix unhandled errors while preloading (Player)

## [0.3.20] - 2024-05-24
### Added
- Add playlog tests - 8 (Player)
### Changed
- Delete all code related to old auth and remove new Auth FF (Player)
### Fixed
- Fixed encoding of sessionProductType as a String in StreamingSessionStart (Player)

## [0.3.19] - 2024-05-23
### Added
- Add playlog tests (Player)

### Changed
- Replace Scopes with Set + migrate stored `Credentials` (Auth)
- Spec conformance - interface segregation (Auth)
- Don't check `offlineMode` when sending `PlayerEvents` (Player)
- Removed `clientVersion` parameter from Player bootstrap (Player)

## [0.3.18] - 2024-05-14
### Added
- New FeatureFlag to control Player catching (Player)
- New StreamingMetrics Tag to monitor playback of cached items (Player)
- Unit tests for play log (Player)
### Changed
- Renamed default FeatureFlagProvider from '.live' to '.standard'

## [0.3.17] - 2024-05-07
### Added
- HTTPBody data to the request (Auth)
- Support for Stage endpoint (Auth)

## [0.3.16] - 2024-05-07
### Added
- Support for keychain sharing (Auth)
- Default listener queue on player bootstrap (Player)
- Add a new workflow to verify CHANGELOG.md update status
- Add uts for streaming privileges handler when in offline mode (Player)
### Fixed
- Fix for SwiftLint warnings on test targets
### Changed
- Made some PlayerListener protocol methods optional (Player)
- CredentialsProvider: isUserLoggedIn and removed isLoggedIn from Auth
### Removed
- Scopes validation (Auth)

## [0.3.15] - 2024-04-26
### Added
- Initial support for Uploaded Content
- Create package documentation catalogues
### Fixed
- Player bootstrap to include shouldUseEventProducer (Player)
- Linter improvements and fixes
### Changed
- Update internal dependencies
- Refactored EventProducer Environment usage (EventProducer)
- Adjust auth documentation (code samples, texts)
- Emit events in didSet of current and next items in PlayerEngine instead of deinit of PlayerItem (Player)
### Removed
- Disable streaming privileges when entering offline mode

## [0.3.14] - 2024-04-12
### Added
- Unit tests (Player)
- Initial setup for a test app
### Changed
- Move feature flags from develop to production

## [0.3.13] - 2024-04-10
### Fixed
- Bug-fixing the withRemovedQuery method

## [0.3.12] - 2024-04-10
### Fixed
- Semver comparison
### Changed
- Unit tests preparation

## [0.3.11] - 2024-04-10
### Added
- Workflow to run FOSSA scans on PRs to main branch
### Fixed
- An attempt to fix the versioning
### Changed
- Increase the timeout of the optimizedWait method due to flaky tests

## [0.3.10] - 2024-04-05
### Added
- Use EventProducer in Player (Player)
- Inject EventSender in PlayerEventSender (Player)
- Missing public in EventSenderMock (EventProducer)
### Changed
- Make EventSender testable

## [0.3.9] - 2024-04-04
### Added
- Auth sub-status error handling

## [0.3.8] - 2024-04-02
### Fixed
- Compiler warnings due to deprecated api usage
- Crash when playing video in PIP and skipping to the next item (Player)
### Changed
- Internal package update
- Increase timeout to address flaky tests in CI
### Removed
- Remove pause call in PlayerEngine reset method (Player)

## [0.3.7] - 2024-03-28
### Added
- Enabling the Event Producer for watchOS & to support Auth Module integration (Auth)
### Changed
- Move FileManagerClient to PlayerWorldClient
- Align Auth Feature flag
- Make auth config non-throwable (Auth)
- Increase timeout to address flaky tests in CI

## [0.3.6] - 2024-03-26
### Added
- Unit tests
- Generate DocC documentation
### Changed
- Use xcodebuild for Player tests
### Fixed
- Logout not working

## [0.3.5] - 2024-03-12
### Fixed
- Volume normalisation

## [0.3.4] - 2024-03-06
### Removed
- "Demo app" & adding Auth Test App as a replacement
### Fixed
- Token usage bug

## [0.3.3] - 2024-02-26
### Added
- Player test app
- Streaming privileges with async await
- Allow custom redirect URI
### Changed
- Make clientName nullable

## [0.3.2] - 2024-02-19
### Changed
- Align Auth with specification, pt3 (Auth)

## [0.3.1] - 2024-02-19
### Added
- Co-ownership for the PACE team to code owned by BITS
### Changed
- Align Auth with specification, pt2 (Auth)

## [0.3.0] - 2024-02-13
### Added
- Player library to target for demo app (Player)
- Mp3 AudioCodec (Player)
- Tests to AuthProvider+Player
- Linter plugin in PlayerTests and address violations
### Changed 
- Align Auth with specification (rename Credentials to Tokens) (Auth)
- Change shouldUseAuthModule to true
- Update tests dependencies
- Rename blacklisted(category) to blocked (EventProducer)
- Package.swift maintenance
### Fixed
- Bearer Auth Token
- Fix slow tests on Auth module

## [0.2.9] - 2024-02-13
### Added
- Streaming privileges preparation (Player)
- Support new reactions value in DJSessionMetadata (Player)
- Support playback of DRM-free tracks using AVPlayer (Player)
### Changed 
- Improve Xcode test settings for Player module (Player)
- Add playbackSessionId to Offlineplay (Player)
### Fixed
- Retry attempts take more than 5 minutes (Auth)
- Make Renovate less noisy

## [0.2.8] - 2024-02-08
### Fixed
- Retry attempts take more than 5 minutes (Auth)

## [0.2.7] - 2024-02-05
### Fixed
- Increase timeout (Player)
- Regression crash on DRM handling (Player)

## [0.2.6] - 2024-02-02
### Fixed
- Loudness normalization values
### Added
- Auth in FairPlayLicenseFetcher and PlaybackInfoFetcher
- Auth in DJProducer

## [0.2.5-drm-crash-fix] - 2024-02-05
### Fixed
- Regression on AVPlayer DRM handling when switching tracks quickly (Player)

## [0.2.5] - 2024-01-30
### Added
- Preparation for tests
- LoginResponse - made properties public
- Code ownership to mobile platform team
- Extended AuthProvider protocol
### Changed
- Replace enum AuthResult with Swift.Result
- Improve mock classes

## [0.2.4] - 2024-01-25
### Added
- Add new flag shouldStallWhenTransitionFromEndedToBuffering in GenericMediaPlayer (Player)
- Preparation of Integration of Auth module into Player (Player)
- Codeowners
### Changed
- Updated playbackinfo endpoint to Streaming API V5 (Player)
- Move all used methods to AuthProvider protocol
- Replace enum AuthResult with Swift.Result
- LoginResponse - made properties public

## [0.2.3] - 2024-01-10
### Added
- New Player module based on BoomBox 0.0.70
### Fixed
Fix to loudness normalization during streaming (Player)

## [0.2.2] - 2023-12-19
### Added
- Set credentials functionality that allows to set existing credentials from the outside (useful for migration purposes) (Auth)
- Simplify integration and tests on clients

### Fixed
- Proper URL formatting for refresh token (EventProducer)

## [0.2.1] - 2023-12-12
### Fixed
- UserID Handling from the server (Auth)
- Unify returning errors for Auth (Auth)
- Send monitoring info only if it is not empty (EventProducer)

## [0.2.0] - 2023-12-08
### Fixed
- Make TIDAL Error non-optional

## [0.1.9] - 2023-11-30
### Changed
- Improve refreshToken() error handling and testing (EventProducer)
- Evaluate upgrade if clientId doesn't match with the stored one
- Update GRDB to 6.22.0

## [0.1.8] - 2023-11-21
### Changed
- Clear-up monitoring data when sending the Monitoring event to server (EventProducer)

## [0.1.7] - 2023-11-17
### Added
- Enable tvOS and watchOS as targets

## [0.1.6] - 2023-11-08
### Changed
- Rollback swiftLint version to align with the main project usage.

## [0.1.5] - 2023-11-08
### Added
- Token refresh feature (EventProducer)
- SwiftLint integration (EventProducer)

## [0.1.4] - 2023-11-03
### Fixed
- Legacy Event parsing (EventProducer)
### Added
- Authorisation (EventProducer)

## [0.1.3] - 2023-10-25
### Fixed
- Background processing issues (EventProducer)
- Formatting for ClientID and Token parameters (EventProducer)

## [0.1.2] - 2023-10-16
### Added
- Logic to include device information for sent events (EventProducer)

## [0.1.1] - 2023-10-11
### Changed
- API endpoint update (EventProducer)

## [0.1.0] - 2023-10-11
### Added
- Initial EventProducer module release for iOS.
