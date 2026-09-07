#!/usr/bin/env bash
# Sync this fork with upstream DeepSeek Harness.
#
# Merge only, never rebase. `.gitattributes` marks our branded files
# `merge=ours`; during a rebase Git replays our commits onto upstream, so
# "ours" means upstream and the attribute discards our files instead of
# keeping them — silently, with no conflict to notice. This script registers
# the driver the attribute needs, merges, then proves the branding survived.
#
# Usage: scripts/osf-sync.sh [upstream-ref]   # default: upstream/master

set -euo pipefail

REF="${1:-upstream/master}"
# Must still appear in README.md after any sync; proves merge=ours applied.
MARKER='OpenSoftwareFactory'

cd "$(git rev-parse --show-toplevel)"

if ! git remote get-url upstream >/dev/null 2>&1; then
  echo "osf-sync: no 'upstream' remote. Add it with:" >&2
  echo "  git remote add upstream git@github.com:deepseek-ai/deepseek-harness.git" >&2
  exit 2
fi

if ! git diff --quiet || ! git diff --cached --quiet; then
  echo "osf-sync: working tree is dirty; commit or stash first." >&2
  exit 2
fi

# `merge=ours` is inert unless a driver backs it. `true` exits 0 without
# writing, which leaves %A — the current branch's version — in place.
git config merge.ours.name "keep the fork's version"
git config merge.ours.driver true

git fetch upstream --tags
git merge --no-edit "$REF"

if ! grep -q "$MARKER" README.md; then
  echo "osf-sync: README.md lost the '$MARKER' marker during this merge." >&2
  echo "  merge=ours did not apply. Inspect before pushing." >&2
  exit 1
fi

echo "osf-sync: merged ${REF}; branding intact."
