# Questie-Octo 1.0.92 — Quest Log Chat-Link Audit

## Scope

Player report: Shift-clicking a quest from the native Quest Log while typing in chat inserted only the quest name as plain text, while pfQuest produced a clickable quest hyperlink.

Baseline: Questie-Octo 1.0.91.

## Authorities inspected

- Questie-Octo 1.0.91 `Tracker/TrackerDriver.lua`
- Questie-Octo 1.0.91 `UI/QuestLinkTooltip.lua`
- Blizzard 1.12 `FrameXML/QuestLogFrame.lua` and `QuestLogFrame.xml`
- supplied `pfQuest-classicAPI-octo` `quest.lua` and `compat/client.lua`
- supplied Questie 5.2.3 / 6.0.0 tracker click hooks as compatibility references

## Confirmed behavior before 1.0.92

Blizzard 1.12 `QuestLogTitleButton_OnClick()` gives chat priority when Shift-clicking a non-header quest while `ChatFrameEditBox` is visible, but inserts only the trimmed quest title. It does not create a quest hyperlink.

pfQuest's Vanilla compatibility hook recognizes the same chat-open Shift-click case and inserts a custom quest hyperlink of the form:

```text
|cAARRGGBB|Hquest:<questID>:<questLevel>|h[Quest Name]|h|r
```

Questie-Octo 1.0.91 already had the receiving half in `UI/QuestLinkTooltip.lua`: `SetItemRef` recognizes `quest:` links and opens Questie-Octo's detailed quest tooltip. It did not have an outgoing Quest Log link builder.

Questie-Octo's tracker pre-hook also intercepted Shift+LeftClick for manual tracking without first preserving Blizzard's chat-open branch.

## 1.0.92 correction

`UI/QuestLinkTooltip.lua` now exposes:

- `BuildQuestLink(questID, title, level)`
- `InsertQuestLink(questID, title, level)`

The link uses the live Quest Log ID/title/level and Questie-Octo's native difficulty-color resolver. The format is the existing `quest:<id>:<level>` format already accepted by Questie-Octo's link tooltip.

`Tracker/TrackerDriver.lua` keeps one pre-hook and changes only the Shift+LeftClick branch:

1. Resolve the clicked live Quest Log row.
2. If the chat edit box is visible, insert a clickable quest hyperlink and return.
3. If chat is not visible, run the existing Questie-Octo manual track/untrack toggle.
4. If the link helper is unexpectedly unavailable while chat is visible, forward to Blizzard's original click handler so Vanilla's plain-text fallback remains intact.

Headers and ordinary unmodified clicks continue to forward to Blizzard unchanged.

## Safety / performance

No new event, `OnUpdate`, timer, poller, saved-variable field, background scan, map/minimap work, quest database data, completion logic, objective semantics, or scheduler job was added. Work occurs only on the user's existing Shift+LeftClick gesture.

The 1.0.91 Quest Log scan-generation fix and stale-index Quest Log opening protection are unchanged.

## Validation

- All 126 Lua files parse successfully with the available Lua 5.4 library. This is syntax validation only, not exact Lua 5.0/client execution.
- Focused hook harness on the real 1.0.92 source:
  - chat visible + Shift+LeftClick -> clickable `|Hquest:123:40|h[Test Quest]|h` inserted; no tracker toggle; Quest Log selection/update retained.
  - chat hidden + Shift+LeftClick -> existing tracker toggle executes; no chat insertion.
  - chat visible + link helper unavailable -> Blizzard original handler receives the click; tracker does not toggle.

Live in-game confirmation remains required.
