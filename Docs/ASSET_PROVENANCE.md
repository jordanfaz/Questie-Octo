# Questie-Octo asset provenance manifest

Audit date: 2026-08-29

This manifest covers every binary artwork file currently shipped under `UI/Icons/` in the accepted 1.0.84 baseline. It records what can be proven from the source snapshots available in the project. It deliberately distinguishes exact byte matches from historical attribution and unresolved provenance.

No artwork was modified, converted, replaced, or removed during this audit. A project-level license does not by itself establish that an upstream project owned or could relicense every third-party artwork it distributed.

## Status meanings

- **exact-byte-match** — SHA-256 is identical to a file in a supplied upstream/reference snapshot.
- **historical-attribution-unverified** — retained project history identifies the source family, but the exact historical source archive is not currently available for re-hash verification.
- **project-supplied-conversion** — conversion provenance was supplied directly by the Questie-Octo maintainer and is already recorded in the project history.
- **unresolved-in-current-reference-set** — no exact match was found in the currently supplied Questie 5.2.3, Questie 6.0.0, pfQuest-classicAPI-octo, or pfQuest-octo reference snapshots; no origin is guessed.

## Manifest

| Questie-Octo asset | Status | Provenance/reference | SHA-256 |
| --- | --- | --- | --- |
| `UI/Icons/auctioneer.tga` | exact-byte-match | pfQuest-classicAPI-octo: pfQuest-classicAPI-octo/img/tracking/auctioneer.tga. SHA-256 exact byte match to the supplied reference snapshot. | `84bf81ad1eb0c18413d479fabb686507574393ec634d06941677acfc7fcfcf79` |
| `UI/Icons/available.blp` | unresolved-in-current-reference-set | Unresolved: No exact match in supplied Questie 5.2.3/6.0.0 or pfQuest reference snapshots. Existing asset preserved unchanged; this audit does not guess its origin or grant additional rights. | `6846ce024c0dfaabbcbfcb4911904653d1c9d6b4c35ac8582903a34c3bae36af` |
| `UI/Icons/available_gray.tga` | project-supplied-conversion | Questie-Octo project input: Maintainer-supplied 32x32 gray available marker. WoW-compatible TGA conversion of the image supplied directly by the Questie-Octo maintainer on 2026-08-17. | `a3d2934b0b93609c47001bc5a82b99ab45c0494585db7cbc15deb8cd68086b73` |
| `UI/Icons/available_mobdrop.blp` | unresolved-in-current-reference-set | Unresolved: No exact match in supplied Questie 5.2.3/6.0.0 or pfQuest reference snapshots. Existing asset preserved unchanged; this audit does not guess its origin or grant additional rights. | `0a385ba84e72b904f7f1c95b062f2618ef7c4a0ba1fa5ad1b92e949863782df9` |
| `UI/Icons/available_object.blp` | unresolved-in-current-reference-set | Unresolved: No exact match in supplied Questie 5.2.3/6.0.0 or pfQuest reference snapshots. Existing asset preserved unchanged; this audit does not guess its origin or grant additional rights. | `bb50d9db07f2c22e337b379986cef0b557f804f0fb8e2a909128da6e74a7ce92` |
| `UI/Icons/banker.tga` | exact-byte-match | pfQuest-classicAPI-octo: pfQuest-classicAPI-octo/img/tracking/banker.tga. SHA-256 exact byte match to the supplied reference snapshot. | `60977e232b43b2b866b62aed105218d5d031a7016de45d7f7b94988f7887a917` |
| `UI/Icons/battlemaster.tga` | exact-byte-match | pfQuest-classicAPI-octo: pfQuest-classicAPI-octo/img/tracking/battlemaster.tga. SHA-256 exact byte match to the supplied reference snapshot. | `ae8046cf89d80b3aef0c69d03b4e345b335748e854aab57f811faf763636a06a` |
| `UI/Icons/complete.blp` | historical-attribution-unverified | Questie: Questie 3.3.5 asset (project history). Docs/DEVELOPMENT HISTORY.txt records this as a Questie 3.3.5 asset; that exact historical archive is not available in the current workspace for hash verification. | `8e86e8f510bf9957b14c1ae22224fec02624ea5e5518ce1621854878a0bd41b5` |
| `UI/Icons/event.blp` | exact-byte-match | Questie: Questie/Icons/event.blp. SHA-256 exact byte match to the supplied reference snapshot. | `21370fb26d730e8b0e61b78976bf75c916a9760bd943b6bc8f6ff3e5c202e2f5` |
| `UI/Icons/eventquest.blp` | historical-attribution-unverified | Questie: Questie event quest artwork (project history). Project history describes the event marker as Questie event quest artwork; no exact byte match exists in the supplied 5.2.3/6.0.0 snapshots. | `354e323572d38d72ab911d42730ce615240f206d4c59cda92f7117642f5ffdb4` |
| `UI/Icons/eventquest_complete.blp` | historical-attribution-unverified | Questie: Questie event quest artwork family (project history). Companion completed-event artwork; historical project documentation attributes event presentation to Questie, but the exact upstream snapshot is unavailable. | `bc748b6625a59165fc365ac49c3a1062c5f1f470ae32857ff7eb7b57ba677da2` |
| `UI/Icons/flight.tga` | exact-byte-match | pfQuest-classicAPI-octo: pfQuest-classicAPI-octo/img/tracking/flight.tga. SHA-256 exact byte match to the supplied reference snapshot. | `bed93611dcfe79b1bf3e745452872e35671fbe5f6c8cee82bb6d52c2da3e2f4c` |
| `UI/Icons/glow.blp` | exact-byte-match | Questie: Questie/Icons/glow.blp. SHA-256 exact byte match to the supplied reference snapshot. | `6ebc111ccf573f3bb657538cc3a9d51c3dc46f6653d2da3318516e6528d0229c` |
| `UI/Icons/incomplete.blp` | unresolved-in-current-reference-set | Unresolved: No exact match in supplied Questie 5.2.3/6.0.0 or pfQuest reference snapshots. Existing asset preserved unchanged; this audit does not guess its origin or grant additional rights. | `ee340f5af08b61dde1990e93143c5cea26280e735e4c14502663fccb4473fec4` |
| `UI/Icons/innkeeper.tga` | exact-byte-match | pfQuest-classicAPI-octo: pfQuest-classicAPI-octo/img/tracking/innkeeper.tga. SHA-256 exact byte match to the supplied reference snapshot. | `8cd3479c12f1dc2941b060e7fc6f3ed59751320d066b15e29aa55fe2cfa08bf9` |
| `UI/Icons/interact.blp` | historical-attribution-unverified | Questie: Questie 8.0.0 objective artwork (project history). Project history states the mature Questie 8.0.0 objective BLP set was used and that Interact/Event artwork was bundled; the exact Questie 8.0.0 snapshot is not available in the current workspace. | `bdd6e7b6f7c77f2f0ab20576baf2ff516213f5c013f734a1aebd59309339cddb` |
| `UI/Icons/loot.blp` | exact-byte-match | Questie: Questie/Icons/loot.blp. SHA-256 exact byte match to the supplied reference snapshot. | `237974b610c9d3304084b783b35d9021138a7f40d3961c621d1e04accd527e5b` |
| `UI/Icons/mailbox.tga` | exact-byte-match | pfQuest-classicAPI-octo: pfQuest-classicAPI-octo/img/tracking/mailbox.tga. SHA-256 exact byte match to the supplied reference snapshot. | `be4bd51e444e84c2e6de7e36e7a0c3c257b6278662ebaa915d0689ea3443351f` |
| `UI/Icons/meetingstone.tga` | exact-byte-match | pfQuest-classicAPI-octo: pfQuest-classicAPI-octo/img/tracking/meetingstone.tga. SHA-256 exact byte match to the supplied reference snapshot. | `667dfa5f2fac4d483f1f50b30aef19ae37c2d8a58c866eeb0a55802fbd3c10d8` |
| `UI/Icons/object.blp` | exact-byte-match | Questie: Questie/Icons/object.blp. SHA-256 exact byte match to the supplied reference snapshot. | `e31ade1d9db371cb3e2b1c78d459a22382d9b11e7c6eb1943813b1793d8b6254` |
| `UI/Icons/pfquest_node.tga` | exact-byte-match | pfQuest-classicAPI-octo: pfQuest-classicAPI-octo/img/node.tga. SHA-256 exact byte match to the supplied reference snapshot. | `06fd289a3728eb334b8814910647056034e71b23570bb53b901f99db1f7416fe` |
| `UI/Icons/pvp_available.tga` | project-supplied-conversion | Questie-Octo project input: Maintainer-supplied PvP marker reference. Conversion of the red PvP available-quest marker reference supplied directly for the project. | `f92d3f7fa710b77bb859c9d577fb2dedba515302325747d9fe12c1a60e2acfae` |
| `UI/Icons/pvp_complete.tga` | project-supplied-conversion | Questie-Octo project input: Maintainer-supplied PvP marker reference. Conversion of the red PvP completed-quest marker reference supplied directly for the project. | `b186e53572de5ddd8141fd2b75edec61d2d22401a8bffe43d381681eab340416` |
| `UI/Icons/rares.tga` | exact-byte-match | pfQuest-classicAPI-octo: pfQuest-classicAPI-octo/img/tracking/rares.tga. SHA-256 exact byte match to the supplied reference snapshot. | `5ded56ce1654f38861e1e770a40af62bd4f5c2f0f7003e53a937a40a1a2d9428` |
| `UI/Icons/repair.tga` | exact-byte-match | pfQuest-classicAPI-octo: pfQuest-classicAPI-octo/img/tracking/repair.tga. SHA-256 exact byte match to the supplied reference snapshot. | `2fb8989ef6682c6875c7bc257f59b1878dbc103988912a6b13b73e4aeacac451` |
| `UI/Icons/repeatable.blp` | exact-byte-match | Questie: Questie/Icons/repeatable.blp. SHA-256 exact byte match to the supplied reference snapshot. | `be58d5071aafd85fc13a3fa361cf1ec79b38b9838d9e8f09e6f03ef3f7162022` |
| `UI/Icons/slay.blp` | exact-byte-match | Questie: Questie/Icons/slay.blp. SHA-256 exact byte match to the supplied reference snapshot. | `1a5ab061ac2649cf1953e1ebb82ed9cf957b15937fdf77711861c69038b6db08` |
| `UI/Icons/spirithealer.tga` | exact-byte-match | pfQuest-classicAPI-octo: pfQuest-classicAPI-octo/img/tracking/spirithealer.tga. SHA-256 exact byte match to the supplied reference snapshot. | `5a25ab4b4e152fc388dc1413ba584f9e320f1064c27f928fbfc5a44dc419057f` |
| `UI/Icons/stablemaster.tga` | exact-byte-match | pfQuest-classicAPI-octo: pfQuest-classicAPI-octo/img/tracking/stablemaster.tga. SHA-256 exact byte match to the supplied reference snapshot. | `6a0ee9c0d8dc83dbaab8080396477ee2b89c1e8c72e12dd73582598dcdd6dc13` |
| `UI/Icons/vendor.tga` | exact-byte-match | pfQuest-classicAPI-octo: pfQuest-classicAPI-octo/img/tracking/vendor.tga. SHA-256 exact byte match to the supplied reference snapshot. | `463997d72c58c55d6fe966fbd100f61b2a1320a788138e3e7269ea8cb2dba869` |

## Important licensing boundary

The current Questie project is publicly listed by CurseForge as GPLv3, and the historical Questie v6.0.0 CurseForge file page also displays GPLv3 project metadata. The supplied Questie 5.2.3/6.0.0 ZIPs themselves contain no project-level Questie license file. See `LICENSES/Questie-LICENSE-METADATA.txt`.

For Questie artwork, this repository therefore preserves upstream attribution and applicable license metadata without claiming that the Questie project necessarily owned or independently relicensed every game-derived or third-party visual contained in historical Questie releases.

pfQuest exact matches are covered by the supplied pfQuest MIT notice to the extent that pfQuest had rights to license those files. The same general upstream-rights limitation applies.

## Maintenance

Run `python Tools/verify_provenance.py` after adding, removing, or replacing icon files. The checker is offline-only and is not loaded by WoW.
