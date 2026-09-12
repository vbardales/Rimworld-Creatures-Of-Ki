---
mod:        Creatures of Ki - Teshi Renew
packageId:  nelim.creaturesofkirenew
repo:       Rimworld-Creatures-Of-Ki-Renew
visibility: public
detached:   yes
stage:      done
licence:    open
licence_at: Mlie's upstream repository, MIT, copyright 2020
showcase:   complete
tested_on:
workshop:
remaining:
  - unverified: never seen running in game. Cut down on 2026-09-11 by _tools/Run-Functional-Tests.ps1,
    17 out-of-game tests: what remains is the three things no reflection reaches - the animal drawn on
    its four faces, an egg that hatches, and the dessicated sprite borrowed from the dromedary, which
    the game does not ship in the clear. TESTS.md scenarios 2, 5 and 6.
  - feature: the showcase is engraved in black, from before the 2026-09-12 rule on the coloured veil
session:    local_6b828864-4bf7-4de6-91d5-29f775dc13a6
updated:    2026-09-12, kept by the thread that holds this mod
---

# Creatures of Ki - Teshi Renew — status

A status sheet, read by one pass over every mod rather than by asking each thread in turn. It lives
at the root and never inside `Mod/`, so Steam never receives it. It is tracked by git.

**Kept current by the thread that holds this mod**, and no longer only by the pass that created it.
It moves when the state moves, not when someone asks: a run in game fills `tested_on`, a debt paid
leaves `remaining`, a published item fills `workshop`, and `updated` follows. The three fields no
pass can deduce from the disk:

- **`stage`** — where the work stands. It has to say the same thing as this mod's session group,
  checked on 2026-09-12: `Rimworld - done`. If the two ever disagree, the group is right, since
  that is the one set by hand. The other values that group takes are `Rimworld - preTest`, ready to
  be tried in game; `Rimworld - ModIcon genere`, the showcase is made; `Rimworld - dans monorepo`,
  not detached yet; and `Rimworld - hors mono`, detached with a clean repository.
- **`tested_on`** — the date of the last run in game. Empty means never, which is the case here.
- **`remaining`** — what is left to do, in three kinds: `feature` for something the first pass did
  not cover, `defect` for a known fault left standing, `unverified` for what could not be checked.
  The line every mod in the repository starts with is "never seen running in game"; narrow it as
  soon as something covers part of it, rather than leaving it whole.

`licence` reads: `open` an explicit licence, `silent` no licence and a dead source, `alive` no
licence but a living source, `forbidden` a written refusal, `original` nothing taken from anyone.
