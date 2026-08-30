# Questie-Octo Tracker Test Corrections Audit — 2026-08-30

## Scope

Accepted implementation baseline: **1.0.85**.

Reviewed generated test builds:

- 1.0.87 — semantic viewport-anchor experiment
- 1.0.88 — native leaderboard + ClassicAPI objective merge
- 1.0.89 — native leaderboard completion-authority refinement

The live reproduction remained present through all three tests. This audit asks a narrower question: which experimental changes are independently safe and useful enough to retain even though they did not solve the reported issue?

## Decision

**No runtime correction from 1.0.87, 1.0.88, or 1.0.89 is retained.**

1.0.90 is rebuilt from accepted 1.0.85. `Tracker/TrackerFrame.lua` and `Quest/QuestLog.lua` are restored byte-for-byte to 1.0.85. The accepted 1.0.83 Hide Completed Objectives renderer behavior remains unchanged.

## 1.0.87 — semantic viewport anchoring

### What it changed

The renderer captured the semantic identity of the current first visible tracker row before rebuilding, then searched the rebuilt row list for the same zone/quest/objective and moved `topRow` to it.

### Why it is not retained

- The live failure still reproduced.
- It intentionally changes viewport behavior on every tracker rebuild rather than only the failing edge case.
- It adds row identity metadata and full row-list searches to a hot render path. The cost is bounded, but there is no demonstrated benefit that justifies the extra behavior/complexity.
- Its fallback policy (parent quest / zone boundary) is a design choice, not an established Vanilla/Questie invariant.

**Result: reject.**

## 1.0.88 — native leaderboard + ClassicAPI merge

### What it changed

When native leaderboard rows were available, their count/text/type/completion were treated as live authority while ClassicAPI supplied structured fields such as objective IDs. The two sources were merged by objective position.

### Why it is not retained

- The live failure still reproduced.
- Native Quest Log state and ClassicAPI structured state are known to settle asynchronously on this client. Merging them by row position assumes both caches describe the same row at the same instant.
- During collapse/expand/index reshuffling, that assumption can associate native text/completion with the wrong structured objective ID, which can affect map/objective semantics beyond the tracker.
- It changes objective count/order/source semantics globally for every active quest. That is too broad for a narrow, unconfirmed edge case.

**Result: reject.**

## 1.0.89 — native completion override refinement

### What it improved over 1.0.88

It correctly recognized the Vanilla rule that a readable native leaderboard row with `finished == nil/false` is simply incomplete; nil is not an invitation to substitute a cached `finished` value.

### Why the runtime change is still not retained

That local semantic observation is valid, but the implementation still depended on the same native/ClassicAPI positional merge introduced by 1.0.88. The live issue also remained reproducible. Keeping a broad cross-cache merge merely because one detail inside it is correct would retain unnecessary regression risk.

**Result: reject implementation; retain the observation only as audit knowledge.**

## Accepted behavior that remains

The 1.0.83 Hide Completed Objectives renderer remains unchanged:

- option OFF: completed objective rows may be shown;
- option ON: rows already classified as complete are hidden;
- a whole completed quest does not itself force all objective rows to disappear.

That renderer has a narrow responsibility and the current evidence does not show it misbehaving on its own. The unresolved question is why the objective state/list changes around one situational native Quest Log collapse sequence.

## Remaining investigation target — documented, not patched

The current 1.0.85 source contains a more relevant structural area for any future investigation:

1. `QuestLog:Refresh()` snapshots the native quest-log entry count and scans entries in scheduler batches.
2. Native header collapse/expand changes visible quest-log indices and entry count.
3. Collapse/expand can schedule another refresh while a previous batched refresh is still running.
4. pfQuest explicitly guards against a stale quest-log index by comparing the title currently present at that index before reading objectives.

This makes transient quest-log index/list mutation a stronger future hypothesis than tracker viewport anchoring or globally changing objective-source authority. It is **not yet proven as the root cause**, and no change is made for it in 1.0.90 because the issue is rare, highly situational, and has not been reported by other players.

## 1.0.90 invariant

For runtime/gameplay code, 1.0.90 intentionally equals accepted 1.0.85 except for the version string. The purpose of 1.0.90 is to provide a clean package after consuming the 1.0.87-1.0.89 test version numbers without carrying their experimental behavior forward.
