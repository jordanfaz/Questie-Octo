# Questie-Octo — Artisan Secondary-Profession Availability Audit

**Audit date:** 2026-08-30  
**Implementation baseline:** accepted/provenance-hardened Questie-Octo 1.0.84  
**Resulting build:** 1.0.85

## Player report

At character level 35 with Survival 225 and Fishing 225, the player did not see:

- `42041 — To Survive in the Jungle`
- `6607 — Nat Pagle, Angler Extreme`

The player also asked whether the equivalent First Aid quest was affected.

The player clarified that `To Survive in the Jungle` is a level-45 quest with a minimum character level of 35, matching the level threshold used by the other Artisan secondary-profession quests.

## Availability evaluator audit

`Quest/AvailableQuests.lua` already evaluates the two relevant requirements independently:

1. Profession requirement from `raw["skill"]` / `raw["skillValue"]`, using `C_SpellBook.GetSkillLineRank(skillLineID)` when ClassicAPI is available.
2. Minimum character level from `raw["min"]`.

The display quest level `raw["lvl"]` is used only for low-level visibility filtering and is not used as the minimum acceptance level.

Therefore the bug was data, not availability code.

## ClassicAPI skill lookup

The supplied pfQuest ClassicAPI reference documents:

`C_SpellBook.GetSkillLineRank(skillLineID) -> curRank, maxRank, modifier`

and uses it directly for live player profession checks.

The supplied current `SkillLine.dbc` contains two rows named `Survival`:

- ID 51, category 7 (`Class Skills`)
- ID 142, category 9 (`Secondary Skills`)

Quest 42041 correctly uses SkillLine ID 142, so the profession gate targets the secondary profession and does not need a name-based reinterpretation.

## Quest-by-quest findings

### 42041 — To Survive in the Jungle

Questie-Octo 1.0.84 compiled record:

- quest level: 45
- minimum level: **45**
- required skill: Survival (142)
- required skill value: 200

The current OctoWoW database reports:

- quest level: 45
- required level: **35**
- start/end: Rufus Hardwick

The supplied server-source/pfQuest-Octo snapshot still contains the older minimum 45. This is a repository/deployed-data divergence of the exact type already covered by the project audit rules.

**Correction:** sparse enrichment overrides only `min = 35`. The existing skill ID/value are left unchanged because the supplied server source explicitly supplies those fields and the reported player already satisfies them.

### 6607 — Nat Pagle, Angler Extreme

Questie-Octo 1.0.84 incorrectly contained:

`pre = {6608, 6609}`

This makes one of the faction city breadcrumb quests mandatory before the direct Nat Pagle quest can appear.

Current supplied server `quest_template`:

- minimum level 35
- quest level 45
- Fishing 225
- `PrevQuestId = 0`
- direct starter/finisher Nat Pagle

Questie 6 also stores quest 6607 without a predecessor and instead treats the city breadcrumb quests as related/exclusive guidance.

**Correction:** remove the stale `pre` field from 6607.

### 6610 — Clamlette Surprise

This was not in the original report, but the full audit found the same stale pattern:

Questie-Octo 1.0.84 contained:

`pre = {6611, 6612}`

Current supplied server `quest_template`:

- minimum level 35
- quest level 45
- Cooking 225
- `PrevQuestId = 0`
- direct starter/finisher Dirge Quikcleave

Questie 6 also stores 6610 without a predecessor.

**Correction:** remove the stale `pre` field from 6610.

### 6622 / 6624 — Triage

Questie-Octo 1.0.84 incorrectly contained:

- Horde 6622: `pre = {6623}`
- Alliance 6624: `pre = {6625}`

Current supplied server `quest_template` for both faction versions:

- minimum level 35
- quest level 45
- First Aid 225
- `PrevQuestId = 0`
- direct starter/finisher is the relevant Trauma Surgeon

The city Trauma quests point toward Triage but are not mandatory server prerequisites. Questie 6 also stores the Triage master quests without predecessor requirements.

**Correction:** remove the stale `pre` fields from 6622 and 6624.

## Runtime effect

After regeneration, the relevant compiled records are:

- 6607: min 35, Fishing 225, no `pre`
- 6610: min 35, Cooking 225, no `pre`
- 6622: min 35, First Aid 225, no `pre`
- 6624: min 35, First Aid 225, no `pre`
- 42041: quest level 45, min 35, Survival skill gate retained

At level 35 with the required profession skill, these master quests are no longer blocked by the stale minimum/prerequisite data. Normal race, completion, visibility, event and starter-faction rules still apply.

## Scope and performance

No runtime algorithm was changed.

No new:

- event
- `OnUpdate`
- timer
- polling
- map scan
- database scan at runtime
- saved-variable field
- frame
- recurring allocation path

was added.

The correction is entirely compiled quest metadata.

## Regression boundary

The source pfQuest/base snapshots remain preserved for provenance. Current server/deployed corrections are applied through the existing sparse `Data/pfDB/enrichment.lua` layer, then compiled into `Data/runtime/quests.lua`.

Only `Data/runtime/quests.lua` changes among the compiled runtime database files.
