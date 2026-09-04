# Creatures of Ki — Teshi: what was taken, and what was changed

## Source

| | |
|---|---|
| Mod | Creatures of Ki (Continued) |
| Original author | Shooki |
| Continuation | Mlie (`emipa606`) |
| Workshop | [2726461020](https://steamcommunity.com/sharedfiles/filedetails/?id=2726461020) |
| Repository | https://github.com/emipa606/CreaturesOfKi |
| Last version supported | 1.4 |
| Licence | MIT — see `LICENSE` |

The upstream repository carries an MIT licence, copyright Mlie 2020. That notice ships with this
mod, which is what MIT asks in exchange for redistribution.

## What was taken

Four def files and nine textures, out of a mod whose other four fifths are a playable race.

| File | Origin |
|---|---|
| `Defs/ThingDefs_Races/Races_Animal_Teshi.xml` | `1.4/Defs/ThingDefs_Races/Races_Animal_Teshi.xml` |
| `Defs/ThingDefs_Items/Items_Resource_Teshi.xml` | `1.4/Defs/ThingDefs_Items/Items_Resource_Teshi.xml` |
| `Defs/Bodies/Bodies_Animal_Teshi.xml` | `1.4/Defs/Bodies/Bodies_Animal_Teshi.xml` |
| `Textures/Things/Pawn/Animal/Teshi/*` | unchanged, nine files |

`Defs/ThingDefs_Items/Items_TeshiEggUnfertilized.xml` is new — see below.

## What was left behind

`Races_Kija.xml`, `PawnKinds_Kija.xml`, `Factions_Kija.xml`, `Factions_Kija_Player.xml` and
`RulePacks_NameMakers_Kija.xml`: the playable race, its two factions and its name makers. All of it
depends on Humanoid Alien Races, and the teshi depends on none of it — the animal references
neither the Kija nor HAR. That is why the extraction is clean rather than a rewrite, and why this
mod declares no dependency at all.

## What was changed

### `wildness` is a stat now, not a race field

```xml
<!-- before, in <race> -->
<wildness>0.50</wildness>

<!-- after, in <statBases> -->
<Wildness>0.50</Wildness>
```

In 1.6 `wildness` left `RaceProperties` and became a `Wildness` **StatDef**. The old field is not
an error, it is simply not read: the value falls back to the stat's default. Ludeon set that
default to `-1`, outside the `[0, 1]` the game actually uses, precisely so an animal that lost its
value is conspicuous rather than quietly tame. The teshi is a manhunter-prone predator with a
health scale of 4; taming it for free is not a cosmetic difference.

### The unfertilized egg had to be written

`Races_Animal_Teshi.xml` declared `eggFertilizedDef` and nothing else. Up to 1.4 that was
tolerated. In 1.6:

```csharp
// CompEggLayer, on laying without fertilization
Thing thing = ThingMaker.MakeThing(Props.eggUnfertilizedDef);
```

`eggUnfertilizedDef` being null throws there, in game, on an animal that lays every fifteen days
whether or not anyone asked. `EggTeshiUnfertilized` is a new def on `EggUnfertBase`, carrying the
market value of the fertilized egg (125) and the same near-white tint, so the pair reads as one
animal's eggs. It is the only def in this mod that is not Shooki's.

### Nothing else

No balance value was touched. No stat, no biome weight, no combat power, no life stage, no
texture. `Bodies_Animal_Teshi.xml` needed no change: `BipedAnimalWithClawsAndTail` is declared by
this mod and used by nothing else in it.

## Known limitation, inherited and left alone

The teshi's **dessicated corpse borrows the dromedary's texture** at three different draw sizes.
That was Shooki's choice and it is still the only dessicated art the mod has; inventing a
replacement would make this a rewrite rather than an update.

## Verification

Two scripts check the mod before release: every def reference and every `ParentName` resolves
against **Core alone**, so no DLC is required, and each reference points at the right *type* of def
(`race` → ThingDef, `body` → BodyDef, and so on). What they cannot see is field-name validity —
they check references between defs, not whether a field still exists. That is exactly how the
wildness breakage slipped past several mods, and it is only caught by loading the game.
