# Agent Note: Fork ownership and upstream sync

Status: implemented

English | [中文](2026-09-07-fork-ownership-and-upstream-sync.zh.md)

## Problem

This repository is a fork of DeepSeek Harness that tracks upstream continuously. Another team owns the harness source; we add capability on top of it. Every upstream-owned file we edit becomes a conflict we resolve again on each sync, so the cost of an edit is paid repeatedly rather than once.

Two mechanisms were missing. Nothing recorded which files we may change, so an agent extending behavior had no rule distinguishing a new package from an edit to an existing one. Nothing protected our branding either: a fork's `README.md` is overwritten by the first upstream merge that touches it, silently and without review.

## Decision

Root [AGENTS.md](../../../../AGENTS.md) opens with a `## Fork ownership` section carrying five standing orders: add capability as new packages placed by the cookbook table, mount through our own bundle patch layer, sync with [scripts/osf-sync.sh](../../../../scripts/osf-sync.sh) rather than `git rebase`, and keep each PR small and atomic. The section sits above the upstream rules it qualifies, in the region upstream edits least.

[.gitattributes](../../../../.gitattributes) marks `README.md`, `BRAND_GUIDELINES.md`, and their `.zh.md` and `.i18n.yaml` pair files `merge=ours`. These lines follow upstream's `*.i18n.yaml merge=dsh-translation-pairing` entry, and the last matching pattern wins, so the two branded pairing records bypass that driver.

`scripts/osf-sync.sh` is the sync entry point. It registers the `ours` merge driver, refuses a dirty tree or a missing `upstream` remote, fetches, merges, and then checks that `README.md` still contains the fork's name.

`AGENTS.md` itself is deliberately **not** `merge=ours`. It carries upstream engineering rules that bind every package we add — the coverage gate, the testing policy, package manifest invariants — and `merge=ours` would stop those updates arriving without ever reporting a conflict. Our section and upstream's sections do not overlap, so ordinary merges resolve cleanly.

Adding the section raised the `AGENTS.md` word ceiling in [scripts/doc-budgets.manifest.json](../../../../scripts/doc-budgets.manifest.json) and its target in [docs/AGENTS.md](../../../../docs/AGENTS.md) from 1,950 to 2,200, keeping the 5% headroom that file requires.

## Alternatives considered

**`AGENTS.md merge=ours`.** Rejected: it freezes upstream's engineering rules at fork time. The failure is silent — the driver never conflicts — so agents would follow stale rules with nothing to signal drift.

**Rebase onto upstream instead of merging.** Rejected on evidence. During a rebase Git replays our commits onto upstream, so `ours` denotes upstream and `theirs` denotes us; `merge=ours` then discards the branded file and drops the commit as "patch contents already upstream", with no conflict marker. Merging is the only direction in which the attribute means what its name suggests.

**Condensing the stale `## Repository layout` block to fund the word budget.** Rejected: deleting roughly 250 words of upstream prose is a larger and longer-lived conflict surface than a two-line ceiling change. That block lists two packages that no longer exist and omits seventeen that do, but it is upstream's inventory to correct.

**A separate instruction file for fork rules.** Rejected: agents load root `AGENTS.md` and its `CLAUDE.md` symlink every session, and a rule an agent does not read is not a rule.

**Registering the merge driver from upstream's `scripts/install-lefthook.mjs`,** which already registers the pairing driver. Rejected: it is an upstream file, and editing it creates exactly the recurring conflict this change exists to avoid.

## Consequences

Our branding survives upstream merges, and upstream's rule changes still reach us. The ownership rule gives agents a decision procedure that keeps almost all our work in new packages, where merges never conflict.

`merge=ours` is inert until `git config merge.ours.driver true` runs, and `.gitattributes` cannot carry that. Every clone and CI checkout must run `scripts/osf-sync.sh`, which registers it. A plain `git merge upstream/master` in a fresh clone conflicts instead of protecting the branded files.

The rule set is prose, unlike most rules here, which a script enforces. Nothing rejects a commit that edits an upstream package, and nothing prevents `git rebase upstream/master`. A gate that fails when a diff touches upstream-owned paths is the natural follow-up.

## Testing

`merge=ours` behavior is verified by construction rather than by a committed test: with the driver registered a merge keeps the fork's `README.md`, and a rebase drops it. The marker check in `scripts/osf-sync.sh` is a backstop for a merge that succeeds while replacing the branded file; the conflict path is covered by `set -e` on the merge itself.
