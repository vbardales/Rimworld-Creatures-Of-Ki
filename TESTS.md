# Creatures of Ki — Teshi Renew: what to check in game

Four static validators pass on this mod: `Check-DefRefs`, `Check-XmlClasses`, `Check-XmlFields`
and `Check-TypeRefs`. None of them can load the game. Everything below is what they cannot see.

The mod has never run. Run these in order: the first one is cheap and catches anything fatal, the
fourth is the only one that can crash a save.

Junction it into `RimWorld/Mods` first — pointing at `CreaturesOfKiRenew/Mod`, not at the repository
root. Play with dev mode on, and keep `Player.log` after the session:

```
C:\Users\nelim\AppData\LocalLow\Ludeon Studios\RimWorld by Ludeon Studios\Player.log
```

---

## 1. It loads

Enable the mod alone, with Core and nothing else. It needs no DLC and no Harmony.

**Expect:** `Creatures of Ki - Teshi Renew` in the mod list, its icon beside it, its showcase on the
mod page. No red text at startup.

**Fails if:** any `XML error` or `Could not resolve cross-reference` naming `Teshi`,
`EggTeshiFertilized`, `EggTeshiUnfertilized` or `BipedAnimalWithClawsAndTail`. A def that fails to
load is silently absent afterwards, so a clean start is what the next four scenarios rest on.

## 2. The animal draws

Dev mode → *Spawn pawn* → teshi. Spawn several so both sexes and both life stages appear, or force
them with *Dev: set age*.

**Expect:** four wide banded ears, a dark crest, a round low body. The female reads greyer, the kit
is the same drawing at a smaller size. Rotate the camera through all four facings.

**Fails if:** a pink or white box appears for any facing, sex or stage. There are nine textures and
no north-facing kit or female-north beyond the three supplied; a missing one shows as pink.

## 3. Wildness reads 50 %

This is the first of the two things the 1.6 port changed. `wildness` stopped being a field of
`<race>` and became a `Wildness` StatDef under `statBases`. The old form is not an error — it is
simply not read, and the stat's default is `-1`, outside the `[0,1]` the game uses.

Select a wild teshi → **Information** tab → find *Wildness*.

**Expect:** 50 %.

**Fails if:** it shows a negative value, 0 %, or nothing. The visible symptom is that taming
succeeds almost immediately, on an animal that should be as hard to tame as a bear.

Cross-check: order a taming job and watch the success chance. A teshi tamed on the first try by an
animals-4 pawn means the stat did not take.

## 4. The unfertilized egg — the only crash risk

This is the second port change, and the reason `EggTeshiUnfertilized` was written. It is also the
one claim in this mod's documents that has never been confirmed, so this scenario is written to
settle it rather than to assume it.

The teshi's comp reads:

```
eggFertilizationCountMax   1
eggCountRange              2
eggProgressUnfertilizedMax 0.9
eggLayIntervalDays         15
```

Two eggs per laying, but only one fertilization available — so a fertilized teshi should produce
one fertilized egg and one unfertilized. That is the path that reaches `eggUnfertilizedDef`, and it
does not depend on the animal laying while unmated.

### 4a. Mated female

Tame one male and one female, keep them together, and let a laying cycle complete. In dev mode the
egg-layer comp offers a debug gizmo that advances the cycle by a day; push it until she lays.

**Expect:** two eggs on the ground — one `teshi egg (fert.)`, one `teshi egg (unfert.)`.

**Fails if:** an exception appears in the log at the moment of laying, naming `CompEggLayer` or
`ThingMaker.MakeThing`. That is the crash the new def exists to prevent, and it would mean the def
is not being found.

### 4b. Lone female

Tame a single female, no male anywhere on the map, and advance her cycle the same way.

**Expect — and this is the open question:** either she lays an unfertilized egg, or her progress
stops at 90 % and she never lays at all. `eggProgressUnfertilizedMax` is 0.9, so the second is
likely. Write down which one happens.

Whichever it is, note it: if she never lays unmated, then this mod's documents are wrong about
*why* the def was needed, though 4a shows it is still needed. The correction is already written
into the CHANGELOG as an open question; this scenario closes it.

## 5. The egg hatches

Leave a fertilized egg somewhere warm and advance fifteen days, or use the dev gizmo on the egg.

**Expect:** a teshi kit, tame, belonging to the colony.

**Fails if:** it hatches into nothing, or into the wrong pawn kind.

## 6. The dessicated corpse — known defect, confirm it is only cosmetic

Kill a teshi and let the corpse dry out, or spawn a dessicated corpse directly.

**Expect:** a dromedary's dessicated sprite, at three draw sizes. **This is correct behaviour for
this mod.** It is Shooki's own choice, inherited deliberately and recorded in `ATTRIBUTION.md`;
inventing replacement art would make this a rewrite rather than a port.

**Fails if:** a pink box, or an exception. Borrowing the texture is the intended state; failing to
find it is not.

## 7. Predator and manhunter, sanity only

Nothing in the port touched these, so this is a regression check rather than a verification.

- `manhunterOnDamageChance` is 0.75: shoot a wild teshi once and it should turn manhunter about
  three times in four. It has four times a human's health pool, so do this away from the colony.
- `manhunterOnTameFailChance` is 0.05: a failed taming should rarely provoke it.
- `predator` is true: a wild teshi should hunt, not graze.
- `nuzzleMtbHours` is 12: a tame one should nuzzle colonists within a day or so.

---

## What to send back

The `Player.log` from the session, plus one line per scenario saying what happened — particularly
**4b**, which is the only one whose answer is not already known.
