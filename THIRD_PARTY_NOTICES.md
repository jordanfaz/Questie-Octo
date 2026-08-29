# Questie-Octo third-party notices

This file records third-party material and development references known to the
Questie-Octo project. It is intentionally additive: existing source comments,
README history, architecture notes, and audit notes remain authoritative
provenance evidence and should not be removed merely because this summary
exists.

## Ace3 / Ace3v

Questie-Octo bundles and adapts Ace3-family compatibility code under `Libs/`,
including AceCore, AceGUI, AceConfig-related code, and CallbackHandler-related
code. The supplied Ace3v source snapshot carries the Ace3 Development Team
license reproduced verbatim in `LICENSES/Ace3v-LICENSE.txt`.

That license permits source and binary redistribution with conditions and also
contains an explicit restriction on redistribution of a stand-alone Ace3
version without prior written authorization. Questie-Octo distributes these
libraries as embedded addon components, not as a stand-alone Ace3 package.

## LibStub

`Libs/LibStub/LibStub.lua` states that LibStub is placed in the Public Domain.
The embedded notice remains in that source file and is summarized in
`LICENSES/LibStub-PUBLIC-DOMAIN.txt`.

## pfQuest and pfQuest-octo

Questie-Octo uses pfQuest-family source/data/artwork as documented throughout
the project. The supplied source snapshots are licensed under the MIT License:

- `pfQuest-classicAPI-octo`: Copyright (c) 2017-2021 Eric Mauser (Shagu).
- `pfQuest-octo`: Copyright (c) 2021 Eric Mauser (Shagu).

Their exact supplied license texts are preserved in:

- `LICENSES/pfQuest-classicAPI-MIT.txt`
- `LICENSES/pfQuest-octo-MIT.txt`

These notices apply to the relevant pfQuest-derived portions and do not alter
Questie-Octo gameplay behavior.

## ShaguTweaks and ShaguTweaks-extras

ShaguTweaks was used as a Vanilla 1.12 UI/compatibility reference, as recorded
in the existing README and source comments. Supplied source licenses are MIT:

- `ShaguTweaks`: Copyright (c) 2021 Eric Mauser (Shagu).
- `ShaguTweaks-extras`: Copyright (c) 2025 Eric Mauser (Shagu).

Their exact supplied license texts are preserved in:

- `LICENSES/ShaguTweaks-MIT.txt`
- `LICENSES/ShaguTweaks-extras-MIT.txt`

## Questie

Questie is a major implementation, behavior, UI, compatibility, and artwork
reference for Questie-Octo. The preserved project history records work across
multiple Questie generations. Earlier README sections intentionally record the
then-approved chain `5.2.3 -> 6.0.0 -> 3.3.5 -> 7.0.0 -> 8.0.0` and statements
that later versions had not yet been inspected. The later architecture record
then documents subsequent reference use of Questie 7-9, Questie 10-11, and
Questie 11.34.1 for edge cases. Both layers are retained because they describe
different stages of development.

During the licensing audit, the supplied Questie 5.2.3 and Questie 6.0.0
archives contained no project-level Questie license file. Their
`Questie/Libs/LICENSE.txt` is the Ace3 Development Team license for bundled
libraries and must not be represented as a license for Questie itself.

Accordingly, Questie-derived portions are **not** relicensed by the
Questie-Octo MIT grant. They retain whatever rights and restrictions apply to
their upstream source. This repository makes no additional permission claim
for those portions.

The exact historical Questie 3.3.5, 7.0.0, and 8.0.0 archives originally used
are no longer available in the current project workspace. Their provenance is
nevertheless retained in existing Questie-Octo comments and documentation and
should not be erased by future human or AI-assisted changes.

## Questie license metadata clarification (2026-08-29)

The current public Questie project page on CurseForge identifies Questie as
**GNU General Public License version 3 (GPLv3)**. The CurseForge file page for
Questie v6.0.0 also displays GPLv3 project license metadata. Those public
metadata checks supplement, but do not erase, the historical packaging fact
recorded above: the supplied Questie 5.2.3 and 6.0.0 ZIPs themselves contained
no project-level Questie license file.

References:

- https://www.curseforge.com/wow/addons/questie
- https://www.curseforge.com/wow/addons/questie/files/2994198

A standard GPLv3 text is included at `LICENSES/GPL-3.0.txt`, and the distinction
is recorded in `LICENSES/Questie-LICENSE-METADATA.txt`. Questie-derived material
is not covered by the original-contribution MIT grant merely because it is
bundled with Questie-Octo. To the extent GPL terms apply to copied/derived
Questie material or a combined work, those terms must be respected.

Individual artwork is tracked separately in `Docs/ASSET_PROVENANCE.md`; the
project does not assume that Questie's project-level license proves ownership
or relicensing authority for every game-derived or third-party asset.

## LevelRange-Turtle

Questie-Octo 1.0.56-1.0.57 uses the user-supplied LevelRange-Turtle 2.2.0 and
LevelRange-Octo 2.0.4 sources as behavior/data references for the optional World
Map zone-level-range panel. The Questie-Octo implementation is rewritten around
current client AreaTable/WorldMapArea identity and does not bundle LevelRange's
XML options frame, SavedVariables, slash commands, or fishing/instance/raid
option system. Version 1.0.57 restores the references' player-relative
Friendly/Hostile/Contested display while using current client faction ownership.

The supplied LevelRange source credits Bull3t, Tenyar97, rado-boy, blehz,
rafacc87, Diginfotek, and Spartelfant. Its source contains an unlimited license
to use, reproduce, and copy the work subject to acceptance of responsibility
and liability for damage arising from use. That notice is preserved in
`LICENSES/LevelRange-LICENSE.txt`.

## ClassicAPI.dll

ClassicAPI is an external runtime dependency used by Questie-Octo. The DLL is
not bundled in this Questie-Octo package.

The ClassicAPI upstream repository states that ClassicAPI is licensed under
GNU GPL version 3 or later. A copy of the upstream GPLv3 license document is
included for reference at `LICENSES/ClassicAPI-GPL-3.0.txt`.

Including that license text does not relicense Questie-Octo under the GPL and
does not imply that ClassicAPI.dll is distributed inside this addon archive.
Users obtain ClassicAPI separately from its upstream project.

## MoveAnything

The supplied MoveAnything source was used as a compatibility/debugging
reference during development. No general project license file was found in the
supplied MoveAnything archive during this audit, and no byte-identical current
Questie-Octo file was identified as an imported MoveAnything file. It is
therefore recorded as reference provenance rather than as a bundled licensed
component.

## Turtle/Tortoise and calendar-derived data

The supplied `tortoise-wow-main` server-source snapshot carries the **GNU Affero
General Public License version 3 (AGPLv3)** at its repository root. Its exact
license text is preserved at `LICENSES/Tortoise-AGPL-3.0.txt`.

Questie-Octo uses that source as an offline factual/server-behavior reference as
documented by generated-data headers and audit notes. This notice records the
source snapshot's license; it does not make a blanket legal claim about whether
every extracted quest fact, coordinate, or database value is copyrightable or
subject to AGPL obligations.

Existing Questie-Octo files explicitly document Turtle/Tortoise server data and
calendar material used to build or verify offline quest/event data. Those
existing generated-data headers and architecture notes are preserved. This
licensing-only packaging pass does not alter, regenerate, remove, or reinterpret
that gameplay data.

## Project identity, mirrors, and endorsement

The canonical Questie-Octo repository is
`https://github.com/SandreaSub/Questie-Octo`. Downstream forks and mirrors are
independent unless the canonical project explicitly states otherwise. A fork
being mirrored on an OctoWoW, GitHub, Gitea, GitLab, or other service does not
by itself create an affiliation or endorsement relationship with Questie-Octo.
See `PROJECT_IDENTITY.md`.

Compatibility with World of Warcraft, Turtle/Octo WoW, ClassicAPI, Questie,
pfQuest, pfUI, or other projects does not imply endorsement by their respective
rights holders or maintainers.

## Preservation rule for future contributors and AI tools

Do not remove historical comments, audit notes, source-attribution notes,
generated-data headers, migration explanations, compatibility explanations, or
AI-oriented maintenance notes merely because newer documentation summarizes
them. They are part of the source-provenance trail.

When replacing or substantially rewriting a third-party-derived component,
update the provenance record rather than deleting the earlier history.
