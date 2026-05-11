---
name: prepare-release
description: Prepares a release of the tidal-sdk-ios SDK. Use when cutting, drafting, bumping, tagging, or shipping a tidal-sdk-ios release, updating version.txt, or writing the CHANGELOG.md entry for a new SDK version.
---

# Prepare Release (tidal-sdk-ios)

Releases are triggered automatically when a version bump on `main` is detected by [`.github/workflows/trigger-releases.yml`](../../../.github/workflows/trigger-releases.yml). That workflow runs lint + unit tests, then drafts a GitHub release via [`create-release.yml`](../../../.github/workflows/create-release.yml). All you have to do is land a PR that bumps `version.txt` and updates `CHANGELOG.md` in sync.

The scripts that drive this live alongside the skill in [`scripts/`](scripts/) and are invoked from the same paths by CI.

## What CI enforces

- [`changelog-check.yml`](../../../.github/workflows/changelog-check.yml) runs on every PR that touches `version.txt`. It executes [`scripts/check-version-sync.sh`](scripts/check-version-sync.sh), which fails unless the exact string in `version.txt` appears somewhere in `CHANGELOG.md`.
- [`scripts/check-version-bump.sh`](scripts/check-version-bump.sh) compares HEAD vs HEAD~1 on `main` using semver (`sort -V`). A release is only triggered when the new version is strictly greater than the old one.

## Workflow

0. **Check whether a release is even needed.** Run [`scripts/check-release-needed.sh`](scripts/check-release-needed.sh) on a fresh checkout of `origin/main`:
   ```bash
   git fetch origin main && git checkout origin/main --
   ./.agents/skills/prepare-release/scripts/check-release-needed.sh
   ```
   It uses the commit that last touched `version.txt` as the "last released" baseline (more reliable than `git tag`, since GitHub releases here are drafted manually and tags lag behind), then reports:
   - non-merge commits landed since the last bump
   - whether the TidalAPI OpenAPI spec version (`Sources/TidalAPI/Config/input/tidal-api-oas.json`) is newer than the most recent `(TidalAPI)` line in `CHANGELOG.md`
   - whether `## [Unreleased]` is empty despite work having landed (this happens because the auto-update workflow no longer writes there)

   Exit codes: `0` = release recommended, `1` = nothing new, `2` = error. If `1`, stop here.

1. **Make sure `main` is clean** and you're on a fresh branch from the latest `main`:
   ```bash
   git checkout main && git pull
   git checkout -b release/<new-version>
   ```

2. **Decide the bump type**: `patch` (default, bug fixes / TidalAPI regen), `minor` (new features, additive API changes), or `major` (breaking changes). Follows [SemVer](https://semver.org/).

3. **Bump and update the changelog** via [`scripts/bump-version.sh`](scripts/bump-version.sh):
   ```bash
   # Patch bump with an automatic "### Changed" entry (used for TidalAPI regens):
   ./.agents/skills/prepare-release/scripts/bump-version.sh patch "Generated API code using spec version X.Y.Z"

   # Bump without a generated entry — script will fold the existing
   # `## [Unreleased]` content into the new version section:
   ./.agents/skills/prepare-release/scripts/bump-version.sh minor
   ```
   The script:
   - Bumps `version.txt`
   - Replaces `## [Unreleased]` with `## [X.Y.Z] - YYYY-MM-DD` and moves accumulated unreleased notes under it
   - Inserts a fresh empty `## [Unreleased]` at the top

4. **Polish `CHANGELOG.md` by hand**. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/). Group entries under `### Added`, `### Changed`, `### Fixed`, `### Removed`, `### Deprecated`, `### Security` as applicable. Suffix each bullet with the module scope used in the repo, e.g. `(Player)`, `(TidalAPI)`, `(Auth)`, `(EventProducer)`, `(Offliner)`. Match the style of recent entries at the top of [`CHANGELOG.md`](../../../CHANGELOG.md).

   Helpful for collecting commit subjects since the last release:
   ```bash
   PREV=$(git describe --tags --abbrev=0)
   git log --no-merges --pretty='format:- %s' "$PREV"..HEAD
   ```

5. **Verify locally** before pushing:
   ```bash
   ./.agents/skills/prepare-release/scripts/check-version-sync.sh   # must print ✅
   make quick-check                                                  # lint + build + tests
   ```

6. **Commit, push, open a PR**:
   ```bash
   git add version.txt CHANGELOG.md
   git commit -m "Release vX.Y.Z"
   git push -u origin HEAD
   ```
   Once the PR is merged into `main`, `trigger-releases.yml` detects the bump, runs lint + unit tests, and `create-release.yml` opens a **draft** GitHub Release tagged `X.Y.Z`. Edit the draft on GitHub and publish when ready.

## Common pitfalls

- **Editing `Sources/TidalAPI/Generated/**` by hand**. Don't — regenerate with `make api-generate` (or `Sources/TidalAPI/generate_and_clean.sh`) and include the regen as a `### Changed` entry.
- **Version in `version.txt` not present in `CHANGELOG.md`**. The check is a literal `grep`, so the heading must contain the exact `X.Y.Z` string. `bump-version.sh` handles this for you — only an issue when editing manually.
- **Reusing or downgrading a version**. `check-version-bump.sh` uses `sort -V`; the new version must be strictly greater than the previous tip of `main`.
- **Pre-release / build-metadata suffixes**. Neither `bump-version.sh` nor `check-version-sync.sh` support them; stick to `X.Y.Z`.
- **Missing entries**. Anything under `## [Unreleased]` at bump time is moved into the new section automatically — review it before merging so nothing accidental ships.
