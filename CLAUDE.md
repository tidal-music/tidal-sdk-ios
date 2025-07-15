# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is the TIDAL iOS SDK repository, a Swift Package Manager-based project that provides multiple modules for iOS app development. The SDK is designed for interaction with TIDAL's music streaming platform.

## Architecture

The project is organized as a multi-module Swift package with the following core modules:

- **Auth**: Handles OAuth2 authentication, login flows, and credential management
- **Player**: Media playback engine using AVPlayer with streaming, caching, and event reporting
- **EventProducer**: Internal event transportation layer for TIDAL Event Platform (TEP)
- **Common**: Shared utilities and code across modules
- **TidalAPI**: Generated API client from OpenAPI specifications

### Module Dependencies
- Player depends on: Auth, EventProducer, Common, GRDB, Kronos
- EventProducer depends on: Auth, Common, GRDB, SWXMLHash
- Auth depends on: Common, KeychainAccess, Logging
- TidalAPI depends on: Auth, Common, AnyCodable

## Common Development Commands

### Setup
```bash
./local-setup.sh  # Sets up git hooks and blame configuration
```

### Building and Testing
```bash
# Build the project
swift build

# Run tests
swift test

# Run tests for specific module
swift test --filter AuthTests
swift test --filter PlayerTests
swift test --filter EventProducerTests
swift test --filter CommonTests

# Run PlayerTests using test plan (organized test execution)
swift test --testplan Tests/PlayerTests/PlayerTests.xctestplan

# Generate documentation
INCLUDE_DOCC_PLUGIN=true swift package --disable-sandbox preview-documentation --target [Module]
```

### Code Quality
```bash
# Run SwiftLint (downloads and uses specific version if needed)
./bin/swiftlint/run-swiftlint.sh

# Lint specific files
./bin/swiftlint/run-swiftlint.sh -i "File1.swift File2.swift"
```

### API Generation
```bash
# Regenerate TidalAPI from OpenAPI spec
cd Sources/TidalAPI
./generate_and_clean.sh
```

### Module Creation
```bash
# Create new module using template
./generate-module.sh
```

## Test Applications

The repository includes test applications demonstrating module usage:

- **AuthTestApp**: Demonstrates authentication flows including OAuth2, device login
- **PlayerTestApp**: Shows media playback functionality with various player features

Test apps are located in `TestApps/` directory and have their own Xcode projects.

## Key Architecture Patterns

### Authentication Flow
- Uses OAuth2 with both Authorization Code Flow and Device Login
- Credentials are securely stored using KeychainAccess
- TidalAuth.shared provides singleton access implementing both Auth and CredentialsProvider protocols

#### Auth Module Architecture
The Auth module is structured around repository pattern with clear separation of concerns:

**Core Components:**
- **TidalAuth**: Singleton class implementing Auth & CredentialsProvider protocols, acts as main facade
- **LoginRepository**: Handles OAuth2 authorization code flow and device login initialization/polling
- **TokenRepository**: Manages token lifecycle including refresh, upgrade, and storage operations
- **DefaultTokensStore**: Secure keychain-based storage using KeychainAccess library
- **DefaultLoginService/DefaultTokenService**: Network layer for authentication API calls

**Authentication Flows:**
1. **Authorization Code Flow (Web Login)**:
   - Uses PKCE (Proof Key for Code Exchange) for security
   - Generates code verifier/challenge pairs via CodeChallengeBuilder
   - LoginUriBuilder constructs authorization URLs with proper parameters
   - Handles redirect URI parsing and token exchange

2. **Device Login Flow**:
   - Initiates with device authorization request to get device_code and user_code
   - DeviceLoginPollHelper manages polling with exponential backoff
   - Custom DeviceLoginRetryPolicy handles authorization_pending and expired_token states
   - PollErrorPolicy provides specialized error handling for device flow

**Token Management:**
- **Automatic Refresh**: Tokens refreshed automatically when expired or on API error substatus
- **Credential Upgrade**: Supports upgrading credentials when clientId changes
- **Fallback Strategy**: Falls back to client credentials flow if refresh token unavailable
- **Smart Logout**: Returns lower-level credentials instead of hard logout on certain errors
- **Thread Safety**: Uses DispatchQueue for credential storage operations

**Security Implementation:**
- Keychain storage with optional access group support for app groups
- Certificate pinning support (configurable via AuthConfig)
- PKCE implementation for authorization code flow
- Secure token expiration handling with 60-second buffer

**Configuration & Initialization:**
- AuthConfig struct contains all configuration parameters including client credentials, scopes, and service URLs
- Must call TidalAuth.shared.config() before using any auth functionality
- Supports custom credential keys and access groups for keychain storage
- Optional logging with TidalLogger integration

**Error Handling:**
- Comprehensive error types: AuthorizationError, TokenResponseError, RetryableError, UnexpectedError
- AuthErrorPolicy pattern for customizable error handling strategies
- Network error classification (client vs server errors)
- Structured logging with AuthLoggable for debugging

**Testing Support:**
- Protocol-based architecture enables comprehensive mocking
- AuthMock and AuthAndCredentialsProviderMock for unit testing
- CredentialsProviderMock with configurable responses
- Mock data generators for Credentials, DeviceAuthorizationResponse, etc.
- FakeTokensStore and FakeLoginService for integration testing

**Key Files Reference:**
- Auth protocol definition: `Auth.swift:5-12` 
- Main implementation: `TidalAuth.swift:6-123`
- Token management: `TokenRepository.swift:41-240`
- Login flows: `LoginRepository.swift:47-142`
- Secure storage: `DefaultTokensStore.swift:4-75`
- Configuration: `Model/AuthConfig.swift:3-38`
- Credentials model: `Model/Credentials.swift:7-102`

### Player Architecture
- Built on top of AVPlayer with custom asset loading and DRM handling
- Implements comprehensive state management and event reporting
- Supports both streaming and offline playback
- Uses FairPlay for DRM content protection

#### Player Module Structure
The Player module is organized into three main engines:
- **PlayerEngine**: Core playback logic handling state transitions, media loading, and AVPlayer integration
- **OfflineEngine**: Manages offline media downloads, storage, and playback using GRDB for persistence
- **Common**: Shared utilities including DRM handling, HTTP client, event system, and data types

#### Key Player Components
- **Player.swift**: Main singleton class with bootstrap initialization, coordinates PlayerEngine and OfflineEngine
- **Configuration.swift**: Audio quality settings, loudness normalization, offline preferences
- **PlayerItem**: Represents loaded media with metadata, playback state, and event emission
- **FairPlayLicenseFetcher**: Handles DRM certificate and license acquisition for protected content
- **PlayerEventSender**: Batches and sends streaming metrics and playback events to TIDAL backend
- **Asset**: Wrapper around AVPlayer assets with loudness normalization and DRM integration
- **Downloader**: Orchestrates offline downloads including media files and DRM licenses

#### Player State Management
- Uses atomic properties for thread-safe state access across PlayerEngine and OfflineEngine
- State transitions: IDLE → NOT_PLAYING → STALLED → PLAYING → PAUSED
- Preloading support with PlayerLoaderHandle for seamless transitions
- Comprehensive error handling with retry strategies and graceful degradation

#### Testing Patterns
- Extensive mock system covering all major components (Player+Mock.swift, various *Mock.swift files)
- PlayerTests.xctestplan organizes test execution with code coverage enabled
- Integration tests use real audio files from Tests/PlayerTests/Resources/AudioFiles/
- Mock patterns follow protocol-based dependency injection for testability

### Event System
- EventProducer handles batched event sending with monitoring and outage detection
- Player automatically reports playback events through EventSender
- Events can be filtered by consent categories

#### EventProducer Module Architecture
The EventProducer module serves as the internal event transportation layer for TIDAL Event Platform (TEP), designed for secure, reliable, and efficient event delivery to backend services.

##### Core Components & Design Patterns
- **TidalEventSender**: Main singleton class implementing EventSender protocol with configuration management and outage state tracking
- **EventScheduler**: Handles periodic event batching (30s intervals, 5s in development) with AWS SQS integration via XML parsing
- **EventSubmitter**: Validates events against disk limits and consent filters before queuing
- **EventQueue**: GRDB-based persistent storage with automatic cleanup of delivered events
- **Monitoring**: Separate tracking system for dropped events, consent filtering, and outage detection with its own SQLite database

##### Event Processing Pipeline
1. **Event Submission**: Events validated for size (20KB limit) and consent category filtering
2. **Queue Storage**: Persistent storage in SQLite using GRDB with EventPersistentObject model
3. **Batch Processing**: EventScheduler groups events (10 per batch) and formats for AWS SQS API
4. **Network Delivery**: Dual authentication support (OAuth2 bearer tokens or client auth) with retry logic
5. **Response Handling**: XML response parsing with SWXMLHash to identify delivered events for cleanup
6. **Error Recovery**: Automatic credential refresh on 401/403, outage detection on failures

##### Configuration & Lifecycle
- **EventConfig**: Configuration struct with credentials provider, disk limits, blocked consent categories, and consumer URI
- **Singleton Pattern**: TidalEventSender.shared with mandatory config() call before usage
- **Disk Management**: Configurable limits (default: 200KB total, 20KB per event) with automatic overflow handling
- **Environment Awareness**: Different scheduling intervals for development vs production builds

##### Authentication & Security
- **HeaderHelper**: Manages authentication headers, device metadata, and client identification
- **Dual Auth Flow**: Supports both user authentication (bearer tokens) and client authentication
- **Credential Refresh**: Automatic token refresh on authentication failures with proper error handling
- **Consent Categories**: NECESSARY (always sent), PERFORMANCE (analytics), TARGETING (advertising) with user-controllable filtering

##### Monitoring & Observability
- **Outage Detection**: Real-time monitoring using Combine's CurrentValueSubject for state management
- **Metrics Collection**: Separate monitoring events track filtered, failed validation, and storage failures
- **MonitoringScheduler**: Independent scheduler for sending monitoring data to backend
- **Structured Logging**: Comprehensive error reporting with EventProducerError enumeration

##### Storage Architecture
- **Dual Database Design**: Separate SQLite databases for events (EventQueueDatabase.sqlite) and monitoring (MonitoringDatabase.sqlite)
- **GRDB Integration**: Uses GRDB.swift for type-safe database operations and migrations
- **Automatic Cleanup**: Events removed after successful delivery confirmation from AWS SQS
- **Disk Space Monitoring**: FileManagerHelper validates available space before storage operations

##### Testing Infrastructure
- **EventSenderMock**: Protocol-based mock for unit testing event sending scenarios
- **Comprehensive Coverage**: Tests for networking, monitoring, database operations, and helper utilities
- **Database Testing**: SQLite-based testing with proper setup/teardown and isolation

##### Key Implementation Files
- **TidalEventSender.swift**: Main singleton implementing EventSender protocol with configuration and outage management
- **EventScheduler.swift**: Batch processing and AWS SQS integration with XML response parsing
- **EventQueue.swift**: GRDB-based persistent storage with cleanup operations
- **Monitoring.swift**: Outage detection and monitoring event collection with Combine integration
- **HeaderHelper.swift**: Authentication and metadata header management
- **EventConfig.swift**: Configuration model implementing EventProducer protocol

##### Usage Patterns & Best Practices
```swift
// Configuration (required before use)
let config = EventConfig(
    credentialsProvider: authProvider,
    maxDiskUsageBytes: 1_000_000,
    blockedConsentCategories: [.performance]
)
TidalEventSender.shared.config(config)

// Event sending with metadata
try await TidalEventSender.shared.sendEvent(
    name: "playback_start",
    consentCategory: .performance,
    headers: ["session-id": "abc123"],
    payload: "{\"track_id\":\"12345\"}"
)

// Dynamic consent management
TidalEventSender.shared.setBlockedConsentCategories([.targeting])
```

##### Development Considerations
- **Thread Safety**: All operations properly handle concurrent access with async/await patterns
- **Error Resilience**: Graceful degradation when limits exceeded rather than throwing errors
- **Memory Management**: Proper cleanup of delivered events and monitoring data
- **Network Efficiency**: Batched sending reduces API calls and improves battery life
- **Testability**: Protocol-based design enables comprehensive mocking and unit testing

## Development Notes

- Project supports iOS 15+, macOS 12+, tvOS 15+, watchOS 7+
- Uses Swift Package Manager for dependency management
- SwiftLint configuration in .swiftlint.yml excludes Generated/ directories and sets custom rules
- Documentation is generated using DocC and requires INCLUDE_DOCC_PLUGIN=true environment variable
- TidalAPI module is auto-generated from OpenAPI specifications and should not be manually edited
- Git hooks are configured via ./local-setup.sh for pre-commit linting

### Player Module Development Guidelines

#### Architecture Patterns
- **Dependency Injection**: All major components use protocol-based DI for testability
- **Thread Safety**: Use @Atomic property wrapper for shared state across concurrent access
- **Error Handling**: Custom PlayerError and PlayerInternalError types with structured error reporting
- **Feature Flags**: FeatureFlagProvider enables conditional functionality (e.g., improved caching)
- **World Pattern**: PlayerWorld provides global dependencies (logger, timeProvider, fileManager, etc.)

#### Key Implementation Details
- Player initialization uses singleton pattern with bootstrap() method - only call once
- PlayerEngine instances are created per explicit playback for clean state management  
- Queue operations are dispatched to single-threaded OperationQueue for thread safety
- Asset loading supports both streaming and offline with unified PlayerItem interface
- DRM certificate fetching is performed eagerly during FairPlayLicenseFetcher initialization
- Loudness normalization values differ by platform (4.0 on iOS/watchOS, 0.0 on tvOS)
- Audio session management is handled through dedicated monitors (iOS/tvOS only)

#### File Organization
- `PlaybackEngine/Internal/` contains core playback logic and AVPlayer integration
- `OfflineEngine/Internal/` handles download orchestration and GRDB storage
- `Common/` provides shared utilities across both engines
- `Mocks/` directory mirrors main structure for comprehensive test coverage

## Testing Infrastructure

- Comprehensive mock system for all major components (Auth, Player, EventProducer)
- Unit tests cover authentication, player functionality, and event handling
- Integration tests use real audio files stored in Tests/PlayerTests/Resources/AudioFiles/
- PlayerTests.xctestplan provides organized test execution at Tests/PlayerTests/PlayerTests.xctestplan
- Test apps available in TestApps/ directory demonstrating real usage patterns