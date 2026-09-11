# Changelog

Format inspired by [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
This file serves the repository and the writing of Steam patch notes; RimWorld does not display it
in game.

## [1.0.0] — unreleased

On release: create the `v1.0.0` tag and the matching GitHub release.

First release of the 1.6 update of the teshi from **Creatures of Ki**, by Shooki, continued by Mlie
through 1.4.

### Added

- Support for RimWorld 1.6.
- `EggTeshiUnfertilized`. The mod declared only its fertilized egg. Every egg-layer in Core
  declares both, without exception — chicken, duck, goose, turkey, ostrich, emu, cassowary, cobra,
  tortoise and iguana — and the teshi lays two eggs at a time with only one fertilization available
  (`eggCountRange` 2, `eggFertilizationCountMax` 1), so the second egg of a laying has nothing to
  be but unfertilized. The new def carries the fertilized egg's market value.

  An earlier wording of this entry said `CompEggLayer` throws whenever an animal lays without
  having been fertilized. That was stated too absolutely, and the point is now settled, read off
  the compiled game by `_tools/Run-Functional-Tests.ps1`: while an animal is unfertilized,
  `CompTick` writes `eggProgressUnfertilizedMax` straight into `eggProgress`, and `CanLayNow`
  requires a full 1. The teshi's setting is 0.9, inherited from upstream and not set here, so a
  lone female is pinned below the threshold and never lays at all. The crash described was
  therefore never possible for her. The def is needed all the same, for the mated case above.
- `LICENSE`, the upstream MIT notice, which is what MIT asks in exchange for redistribution.

### Changed

- **`wildness` moved to `<Wildness>` under `statBases`.** It stopped being a field of
  `RaceProperties` in 1.6 and became a StatDef. The old form is not an error, it is simply not
  read, and the stat's default is `-1` — outside the range the game uses, so the animal tames for
  almost nothing.

### Removed

- The Kija: the playable race, its two factions, its pawn kinds and its name makers, along with the
  Humanoid Alien Races dependency that came with them. This mod adds one animal and needs nothing.

### Notes

No balance value was changed. One defect inherited from the original is left in place on purpose
and documented in `ATTRIBUTION.md`: the dessicated teshi corpse uses the dromedary's texture.
