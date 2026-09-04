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
- `EggTeshiUnfertilized`. The mod declared only its fertilized egg, which 1.4 tolerated. In 1.6
  `CompEggLayer` builds `eggUnfertilizedDef` as soon as an animal lays without having been
  fertilized, and throws if the field is null — an in-game exception on an animal that lays every
  fifteen days unprompted. The new def carries the fertilized egg's market value.
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
