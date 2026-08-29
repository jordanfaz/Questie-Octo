# Questie-Octo 1.0.84 — Completed Quest Marker Z-Order Audit

## Report
A completed `?` marker in Grim Reaches was present, but a nearby available `!` marker could render over part of it. The requested invariant is that completed turn-in markers remain on top of available quest markers on both World Map and minimap.

## 1.0.83 behavior
`Map/Map.lua` already assigns semantic priority `turnin=50` versus `available/itemStart=40`, and Questie-style texture sublevels `turnin=OVERLAY 6` versus `available/itemStart=OVERLAY 5`. `Map/Prepared.lua` also merges exact available/turn-in entries sharing the same source and coordinate, in which case the turn-in visual wins.

The uncovered case is two separate Button frames whose icon footprints overlap without sharing the same prepared slot. Every ordinary quest pin used the same parent-relative frame level (`WorldMapButton +8`, `Minimap +7`). Texture draw sublevels do not provide a reliable cross-frame z-order guarantee on the 1.12 frame model when the frames themselves share a frame level.

## Reference comparison
Questie 5.2.3 and 6.0.0 use OVERLAY sublevels 5 for available and 6 for complete markers. Questie-Octo retains those sublevels. The additional frame-level distinction is a Vanilla-client compatibility guard for Questie-Octo's separate pooled Button frames, ensuring the intended Questie complete-over-available ordering is deterministic even when different frames overlap.

## 1.0.84 correction
A shared frame-level band is now derived from the visual role:

- permanent/service/rare marker: band 0
- ordinary quest/objective/available/item-start marker: band 1
- completed turn-in marker: band 2

World Map uses `WorldMapButton:GetFrameLevel() + 7 + band`; minimap uses `Minimap:GetFrameLevel() + 6 + band`. Therefore the pre-existing levels stay unchanged for ordinary pins, while turn-ins receive exactly one additional frame level.

## Scope / performance
No node creation, clustering, tooltip merging, visibility rule, quest data, map identity, database, event registration, timer, OnUpdate, polling, or scan changes. `SetFrameLevel` was already executed when a pin's visual role was selected; the patch only computes a tiny integer band for that existing call. There is no meaningful CPU or Lua-memory increase.
