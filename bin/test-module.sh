#!/usr/bin/env bash
set -euo pipefail

# Runs tests for a specific module quickly.
# Usage:
#   bin/test-module.sh <ModuleName> [--xcodebuild] [--skip-playlog]
# Examples:
#   bin/test-module.sh Auth
#   bin/test-module.sh Player --xcodebuild

MODULE="${1:-}"
shift || true

if [[ -z "${MODULE}" ]]; then
  echo "Usage: $0 <ModuleName> [--xcodebuild] [--skip-playlog]" >&2
  exit 2
fi

USE_XCODEBUILD=false
SKIP_PLAYLOG=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --xcodebuild)
      USE_XCODEBUILD=true
      shift
      ;;
    --skip-playlog)
      SKIP_PLAYLOG=true
      shift
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 2
      ;;
  esac
done

run_spm_tests() {
  local test_target="${MODULE}Tests"
  echo "Running SPM tests for ${test_target}..."
  swift test --filter "${test_target}"
}

run_player_xcodebuild() {
  # Allow override via DESTINATION env; default to a modern simulator
  local destination
  destination="${DESTINATION:-platform=iOS Simulator,name=iPhone 15,OS=latest}"

  local args=(
    -scheme 'Player'
    -sdk iphonesimulator
    -destination "$destination"
    test
    -skipPackagePluginValidation
  )

  if $SKIP_PLAYLOG; then
    args+=(
      -skip-testing:PlayerTests/PlayLogTests
      -skip-testing:PlayerTests/PlayLogWithDeinitTests
    )
  fi

  echo "Running xcodebuild for Player with destination: $destination"
  set -o pipefail
  if command -v xcbeautify >/dev/null 2>&1; then
    xcrun xcodebuild "${args[@]}" | xcbeautify
  else
    xcrun xcodebuild "${args[@]}"
  fi
}

case "$MODULE" in
  Player)
    if $USE_XCODEBUILD; then
      run_player_xcodebuild
    else
      echo "Trying SPM test plan for Player (for quick iteration). If this fails, rerun with --xcodebuild."
      if swift test --testplan Tests/PlayerTests/PlayerTests.xctestplan; then
        exit 0
      else
        echo "SPM Player tests failed or unsupported. Falling back to xcodebuild..." >&2
        run_player_xcodebuild
      fi
    fi
    ;;
  Auth|Common|EventProducer|TidalAPI|Template)
    run_spm_tests
    ;;
  *)
    echo "Unknown module: $MODULE" >&2
    exit 2
    ;;
esac

