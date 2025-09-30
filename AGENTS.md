# Repository Guidelines

## Project Structure & Module Organization
- Modules in `Sources/`: `Auth`, `Common`, `EventProducer`, `Player`, `TidalAPI` (+ `Template`).
- Dependencies: Player → Auth, EventProducer, Common, GRDB, Kronos; EventProducer → Auth, Common, GRDB, SWXMLHash; Auth → Common, KeychainAccess, Logging; TidalAPI → Auth, Common, AnyCodable.
- Tests in `Tests/<ModuleName>Tests/` (e.g., `PlayerTests`). Test plan at `Tests/PlayerTests/PlayerTests.xctestplan`.
- Example apps in `TestApps/` for interactive runs.
- CI/aux scripts in `bin/` and `Scripts/`; generated API under `Sources/TidalAPI/Generated` (do not edit).

## Build, Test, and Development Commands
- Setup: `./local-setup.sh` (pre-commit hook + blame config).
- Build: `swift build`
- Tests (all): `swift test` | Filter: `swift test --filter PlayerTests`
- Player test plan: `swift test --testplan Tests/PlayerTests/PlayerTests.xctestplan`
- Xcode Player tests: `xcodebuild -scheme 'Player' -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 15,OS=17.2' test`
- Lint: `./bin/swiftlint/run-swiftlint.sh` or `-i "file1.swift file2.swift"` (pre-commit runs automatically)
- Docs preview: `INCLUDE_DOCC_PLUGIN=true swift package --disable-sandbox preview-documentation --target Module`
- Generate API client: `cd Sources/TidalAPI && ./generate_and_clean.sh`
- Create module: `./generate-module.sh` (use PascalCase)

## Coding Style & Naming Conventions
- Swift 5.9, tabs for indentation; max line width ~130 (see `.swiftformat`).
- Imports and typealiases sorted; trailing commas and whitespace normalized by SwiftFormat.
- SwiftLint enforces additional rules; config at `.swiftlint.yml` (some rules disabled to fit SDK patterns).
- Naming: modules/types in PascalCase, methods/properties in lowerCamelCase. Filenames match primary type (`PlayerManager.swift`).

## Testing Guidelines
- XCTest under `Tests/<TargetName>Tests/`; files end with `Tests.swift`, methods `test...()`.
- Prefer isolated unit tests; avoid network. Use protocol-driven fakes/mocks.
- Cover public API and critical paths (auth flows, playback, event queue/persistence).
- Use Player test plan for structured runs and coverage.

## Commit & Pull Request Guidelines
- Commit messages: imperative, concise; include scope when helpful, e.g., `Player: Fix stall on seek`; reference tickets (e.g., `TDAPEX-123`).
- PRs: pass build/tests/lint; include clear description, rationale, linked issues, and doc updates.
- Versioning/releases: bump `version.txt` + update `CHANGELOG.md` (CI enforces sync via `Scripts/checkVersionSync.sh`).
- CI runs lint and unit tests on macOS; address failures before requesting review.
- Never edit files in `Sources/TidalAPI/Generated`—regenerate instead.

## Security & Configuration Tips
- Never commit secrets or tokens. Auth stores credentials via Keychain.
- Auth supports certificate pinning via `AuthConfig`; configure in app code.
- Only set `INCLUDE_DOCC_PLUGIN` when generating docs locally.
