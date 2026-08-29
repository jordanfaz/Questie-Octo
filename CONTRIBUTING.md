# Contributing to Questie-Octo

Questie-Octo is maintained as a mixed-source project with a deliberately
preserved provenance trail. These rules are intended to keep future
development easy while preventing licensing and attribution information from
being lost. They do not alter the addon's gameplay architecture.

## Normal development

- New code written specifically for Questie-Octo may be contributed under the
  project's original-contribution MIT grant.
- Normal bug fixes, performance work, data corrections, UI work, and new
  features do not require special handling when they are original work.
- Existing historical comments, audit notes, generated-data headers, and source
  attribution should be preserved unless they are demonstrably wrong. Correct
  them by adding a dated clarification rather than erasing useful history.

## Third-party code, data, and artwork

Before copying or substantially adapting material from another project:

1. Record the upstream project, exact file/snapshot when practical, and license.
2. Preserve copyright/license notices required by that upstream license.
3. Update THIRD_PARTY_NOTICES.md and the relevant provenance document.
4. For artwork added under UI/Icons/, update Tools/provenance_assets.tsv and
   Docs/ASSET_PROVENANCE.md.
5. Do not assume that a project's license grants rights to third-party assets
   that project itself may only be redistributing.

Using another addon only as a behavioral or API reference does not require
copying its source. Prefer independent implementation when the upstream license
is uncertain or incompatible with the intended use.

## Server/client factual references

Questie-Octo may use client DBC data, server source, patch notes, and live
player evidence to verify factual quest/map behavior. Keep the source of such
corrections documented. Do not claim that factual extraction automatically
settles copyright or database-right questions.

## Offline provenance check

`python Tools/verify_provenance.py` validates the current icon manifest and
required legal/provenance files. It is a maintenance aid only: it is not loaded
by WoW, is not part of the runtime data path, and is intentionally not wired
into normal addon startup or gameplay.
