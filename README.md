# Creatures of Ki — Teshi 1.6

The teshi from Shooki's **Creatures of Ki**, brought forward to RimWorld 1.6.

**I am not the author of this mod.** The animal, its textures and the original idea are Shooki's;
the 1.0 → 1.4 continuation is Mlie's. All I did was the work needed to make the teshi run on 1.6.
Credit goes to them; mistakes in the update are mine.

Original mod: https://steamcommunity.com/sharedfiles/filedetails/?id=2726461020 — Mlie's continuation,
still online, last supporting 1.4. Abandoned, not withdrawn.

## What the mod does

It adds one animal and its eggs.

- **Teshi** — body size 3.5, health scale 4.0, worth 2000 silver. Two claws at 18 damage, a bite at
  25, a head bash at 12. Trainable to intermediate, it nuzzles, and it lives eighty years.
  Comfortable from −80 °C to 60 °C, which is to say anywhere.

  Its own description calls it "a large, bipedal feathered predator", which will have you
  picturing a raptor. The artwork is nothing of the sort: a round, heavy, low-sitting animal with
  **four wide banded ears**, two a side, and a short dark crest — the bulk of a bear on the build
  of a giant chinchilla. It is a predator all the same, and damaging one turns it manhunter three
  times in four.
- **Teshi eggs**, fertilized and unfertilized. One egg fertilized at a time, laid every fifteen
  days, hatching after fifteen more.
- Spawns sparsely in shrubland, temperate forest, boreal forest and tundra, a little more in
  rainforest, and almost never on ice sheet or desert.

Taming failure turns it manhunter one time in twenty; damaging it, three times in four. It is a
predator with four times a human's health pool, so that matters.

No DLC required. No Harmony, no framework, no dependency of any kind.

Content mod: removing it mid-save will lose any teshi and any teshi eggs already in play.

## What is not included

Creatures of Ki is four fifths a **playable race** — the Kija, their faction, their pawn kinds and
their name makers — and that half of the mod requires Humanoid Alien Races. None of it is here, and
this mod needs no Humanoid Alien Races. The teshi referenced neither the race nor HAR, which is why
it could be lifted out cleanly. If you want the Kija, use the original.

## What changed in the 1.6 update

Two breakages, both silent in different ways.

- **Wildness stopped being a race property.** In 1.6 it is a `Wildness` **StatDef** declared under
  `statBases`, and the old `<race><wildness>` was ignored outright. Ludeon gave the stat
  `defaultBaseValue -1`, deliberately outside the `[0,1]` range, precisely so animals that lost the
  value show up. Untouched, the teshi tamed about as easily as a rat.
- **The unfertilized egg was missing.** Every egg-laying animal in Core declares one, and the teshi
  did not. It is reachable here for a plainer reason than a crash: the comp lays two eggs at a time
  and offers one fertilization, so the second egg of a laying has nothing to be but unfertilized.
  `EggTeshiUnfertilized` was written, taking the market value of its fertilized counterpart.

  This entry used to say that `CompEggLayer` throws whenever an animal lays unfertilized, making
  the def mandatory. That went further than the evidence: for animals whose
  `eggProgressUnfertilizedMax` is below 1 — the teshi's is 0.9, inherited untouched — progress
  stops short and the animal may never lay unmated at all. Unconfirmed in either direction, since
  the mod has not yet run. See `TESTS.md`, scenario 4.

No balance value was changed. Nothing else in the teshi's defs needed touching: no `deathAction`,
no toxic sensitivity, no C#.

## Verification

Every def reference and every `ParentName` resolves against **Core alone**, so no DLC is required,
and each reference points at the right *type* of def. Checked with the repository's two validators
before release.

## Terms

The continuation this port is built from is **MIT** (`LICENSE`, copyright Mlie, 2020), and that
notice ships with the mod, which is the condition MIT places on redistribution. Credit for the
animal itself belongs to Shooki.

If Shooki or Mlie comes back to it, or asks for this to be taken down, it comes down.

If I do not answer within a reasonable time after being contacted, anyone may freely update this or
any other of my mods, including publishing a continuation of it. All credit must be preserved.

## Credits

- **Shooki** — the teshi: design, textures, defs.
- **Mlie** — the continuation through 1.4, and the MIT terms this port relies on.
- 1.6 update by nelim. Written with the help of Claude (Anthropic).
