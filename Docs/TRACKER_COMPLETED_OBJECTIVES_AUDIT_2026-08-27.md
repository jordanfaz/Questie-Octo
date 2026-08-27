# Questie-Octo 1.0.83 — Completed Objective Visibility Audit

## Report
A fully completed quest remained in the tracker because **Show Completed Quests** was enabled, but its completed objective line was absent even though **Hide Completed Objectives** was disabled.

## Root cause
`Tracker/TrackerDriver.lua` already implements the setting correctly. It filters an objective only when `trackerHideCompletedObjectives` is true and the objective is complete.

`Tracker/TrackerFrame.lua`, however, had an additional unconditional `if not quest.complete then` gate around all objective rendering. Once the quest itself became complete, no objective could render regardless of the setting.

## Correction
Removed the renderer-level quest-complete gate. TrackerFrame now renders the objective list produced by TrackerDriver.

Result:
- Hide Completed Objectives OFF → completed objective rows remain visible, including under a completed quest.
- Hide Completed Objectives ON → completed objective rows are filtered out by TrackerDriver.
- Show Completed Quests continues to control whether the completed quest itself remains in the tracker.

## Scope / performance
No new event, timer, `OnUpdate`, polling path, cache, frame, database lookup, or background work was added. This is only a presentation-path correction.
