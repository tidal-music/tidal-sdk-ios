Create a new SDK release PR. Execute ALL steps without asking ANY questions. Never confirm, never prompt, never wait for input.

If the user provided a version number (e.g. `/create-release-pr 0.12.0`), use that exact version. Otherwise, bump patch by default (e.g. 0.11.15 → 0.11.16).

Steps:

1. Run `git checkout main && git pull --ff-only origin main`. If not on main, switch to it.

2. Read current version from `version.txt`.

3. Determine the new version:
   - If the user provided a specific version as argument, use it. Write it directly to `version.txt`.
   - Otherwise, determine bump type from the difference (patch/minor/major) or default to patch.

4. Get one entry per merged PR since the last tag: `git log <current_version>..HEAD --oneline --first-parent`

5. Read `CHANGELOG.md`.

6. Generate changelog entries:
   - One entry per PR — never list individual commits within a PR.
   - Concise human-readable descriptions, not raw commit messages.
   - Format: `- Description (ModuleName)` — extract module from `Module: Description` prefix.
   - Categorize: `### Added` (new features/APIs), `### Fixed` (bug fixes), `### Changed` (everything else).
   - Skip "Bump version", "Merge", "Update changelog" commits.
   - For "Automatic Tidal API module update" PRs: one entry `- Generated API code (TidalAPI)`.
   - Merge with any existing `[Unreleased]` entries without duplicates.

7. Write entries into `[Unreleased]` section of `CHANGELOG.md`.

8. Run `bin/bump-version.sh patch` (or `minor`/`major` as needed to reach the target version). This moves `[Unreleased]` into the new version and updates `version.txt`. If the user specified an exact version, write it to `version.txt` after the bump script runs if the script didn't produce the right number.

9. Verify `version.txt` contains the correct new version.

10. Create branch `release/<version>`, commit as `Bump version to <version>`, push.

11. Create draft PR: `gh pr create --draft --base main --assignee @me --title "Release <version>" --body-file <tmpfile>` where the body is the new changelog section.

12. Print the PR URL.

NEVER ask questions. NEVER wait for confirmation. Just do it.
