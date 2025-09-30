SHELL := /bin/bash
.PHONY: setup build test test-all test-module lint lint-file format docs api-generate quick-check help

# Default iOS simulator destination (override with DEST or DESTINATION env var)
DEST ?= platform=iOS Simulator,name=iPhone 15,OS=latest

help:
	@echo "Common tasks:"
	@echo "  make setup            # Install git hooks and blame config"
	@echo "  make build            # Build all targets (SPM)"
	@echo "  make test             # Run unit tests (SPM; quick)"
	@echo "  make test-all         # Run SPM tests and Player via xcodebuild"
	@echo "  make test-module MODULE=Player [ARGS=...] # Run tests for a module"
	@echo "  make lint             # Run SwiftLint (repo)"
	@echo "  make lint-file FILE=path.swift  # Lint a specific file"
	@echo "  make format           # Format Swift sources via SwiftFormat"
	@echo "  make docs MODULE=Player  # Preview DocC for a module"
	@echo "  make api-generate     # Regenerate TidalAPI client"
	@echo "  make quick-check      # Fast lint + build sanity"

setup:
	./local-setup.sh

build:
	swift build

# Quick SPM test run; Player is heavy in SPM. Use test-all for full coverage.
test:
	swift test --skip PlayerTests

# Runs SPM tests (excluding Player) then Player via xcodebuild to match CI
test-all:
	$(MAKE) test
	@echo "\n--- Running Player tests via xcodebuild ---\n"
	@DESTINATION="$${DESTINATION:-$(DEST)}" \
		xcrun xcodebuild -scheme 'Player' -sdk iphonesimulator -destination "$$DESTINATION" test -skipPackagePluginValidation | { command -v xcbeautify >/dev/null 2>&1 && xcbeautify || cat; }

# Usage: make test-module MODULE=Player [ARGS='--skip-playlog']
test-module:
	@[ -n "$(MODULE)" ] || (echo "Error: MODULE is required (e.g., make test-module MODULE=Player)"; exit 1)
	@bin/test-module.sh "$(MODULE)" $(ARGS)

lint:
	./bin/swiftlint/run-swiftlint.sh

lint-file:
	@[ -n "$(FILE)" ] || (echo "Error: FILE is required (e.g., make lint-file FILE=Sources/Auth/Auth.swift)"; exit 1)
	./bin/swiftlint/run-swiftlint.sh -i "$(FILE)"

format:
	@if command -v swiftformat >/dev/null 2>&1; then \
		swiftformat --config ./.swiftformat . ; \
	else \
		echo "swiftformat not found. Install via Homebrew: brew install swiftformat" ; \
		exit 127 ; \
	fi

# Preview DocC for a module (requires Xcode + DocC plugin)
docs:
	@[ -n "$(MODULE)" ] || (echo "Error: MODULE is required (e.g., make docs MODULE=Player)"; exit 1)
	INCLUDE_DOCC_PLUGIN=true swift package --disable-sandbox preview-documentation --target $(MODULE)

api-generate:
	cd Sources/TidalAPI && ./generate_and_clean.sh

quick-check:
	bin/quick-check.sh

