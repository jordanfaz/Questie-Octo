# Questie-Octo legal/provenance hardening audit — 2026-08-29

Baseline: accepted Questie-Octo 1.0.84.

## Scope guarantee

This pass changes documentation and offline maintenance tooling only. It does
not intentionally change any gameplay, Lua runtime behavior, quest/map data,
TOC loading, artwork pixels/bytes, UI behavior, settings, performance path, or
future feature architecture. README.md is preserved byte-for-byte.

## Improvements

1. Root `LICENSE` now explicitly scopes MIT to original Questie-Octo
   contributions instead of reading like a blanket relicense of mixed-source
   material.
2. GPL/AGPL/copyright boundaries are stated without claiming that documentation
   can settle every derivative-work or asset-ownership question.
3. Current public Questie GPLv3 metadata is recorded alongside the fact that
   the supplied historical 5.2.3/6.0.0 ZIPs contain no project-level license.
4. The supplied Tortoise server source's AGPLv3 root license is preserved.
5. Every shipped icon binary is hash-manifested with exact-match, historical,
   project-supplied, or unresolved status. No unresolved asset is silently
   assigned an origin.
6. Canonical-project and no-endorsement language separates Questie-Octo from
   independent downstream forks/mirrors and compatible server/UI projects.
7. `CONTRIBUTING.md` gives future contributors lightweight provenance rules.
8. `Tools/verify_provenance.py` provides an optional offline integrity check.

## Explicit non-goals

- No icon replacement.
- No source-code rewrite for licensing purposes.
- No quest/database regeneration.
- No move to or dependency on OctoWoW hosting.
- No claim that this audit is legal advice or guarantees non-infringement.

## Future-development rule

Normal original Questie-Octo development should continue as before. Provenance
work is only required when new third-party material is copied/substantially
adapted, or when a known attribution/license fact changes. The offline checker
is not part of the runtime and should not be used to block players from loading
the addon.
