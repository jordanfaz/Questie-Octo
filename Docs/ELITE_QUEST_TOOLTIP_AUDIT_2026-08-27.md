# Elite / Dungeon / Raid Quest Tooltip Audit — 1.0.82

## Report

Available Crescent Grove dungeon quests still rendered `[33]` / `[34]` after `/reload` in 1.0.81, while active dungeon quests could already show `[level+]` through the native Quest Log tag.

## Confirmed cause

1. 1.0.81 attempted to call `C_QuestLog.GetQuestDetails(questID)` for available quests.
2. The supplied ClassicAPI exposes `GetQuestDetails`, but it is backed by the client's quest-data cache. The supplied pfQuest ClassicAPI build explicitly treats this data as cache-dependent and falls back to its shipped database for cache-cold quests.
3. Questie-Octo's compiled database preserved Type 41 for PvP classification but did not preserve Type 1 (Elite), 62 (Raid), or 81 (Dungeon). Therefore `QuestModel.questType` was 0 for the reported unaccepted quests.
4. `/reload` cannot make a cache-cold quest acquire server quest details, so restarting the addon could not fix the missing `+`.

## Source verification

The supplied Tortoise server `QuestDef.h` defines:
- Type 1: Elite
- Type 62: Raid
- Type 81: Dungeon

The current quest-template data classifies:
- 40089 The Rampant Groveweald: Type 81
- 40090 The Unwise Elders: Type 81
- 41756 To Crush The Dragonmaw: Type 81

The current full server quest snapshot contains 1,294 Questie-Octo runtime quests with Type 1, 62, or 81.

## 1.0.82 correction

A sparse `Data/EliteQuestTypes.lua` build-time projection preserves those 1,294 server quest types when the compiled runtime database is generated. `QuestModel.questType` is therefore available for unaccepted quests without calling ClassicAPI at tooltip time.

Tooltip authority:
- active quest: native Quest Log `tag`
- available/cache-cold quest: compiled canonical quest `type`

The 1.0.81 per-tooltip ClassicAPI type cache is removed.

## Performance

No new polling, OnUpdate, event, timer, map scan, node rebuild, or creature-rank inference is introduced. The only runtime database cost is one additional numeric `type` field on the existing 1,294 quest records. No second runtime lookup table is loaded by the addon TOC.
