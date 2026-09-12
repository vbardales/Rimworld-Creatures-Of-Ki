---
mod:          Creatures of Ki - Teshi Renew
packageId:    nelim.creaturesofkirenew
repo:         Rimworld-Creatures-Of-Ki-Renew
remote:       https://github.com/vbardales/Rimworld-Creatures-Of-Ki-Renew.git
local_path:   C:\Users\nelim\Documents\rimworld\CreaturesOfKiRenew
visibility:   public
detached:     yes
stage:        done
licence:      open
licence_spdx: MIT
licence_github_detection: Other (NOASSERTION)
licence_at:   LICENSE and Mod/LICENSE, copyright 2020 Mlie
dependencies: none
showcase:     complete
tested_on:
workshop:
maintainer:   Codex, current task responsible for this standalone repository
updated:      2026-09-12
remaining:
  - unverified: all seven TESTS.md scenarios await an actual RimWorld 1.6 session and Player.log.
---

# Creatures of Ki - Teshi Renew — status

This task maintains this file whenever the repository state changes. Scope is this local
repository only, no longer a monorepo. Git reports this folder as its root, uses its own `.git`
directory, and reports no superproject. GitHub API confirmed `private: false`, `visibility: public`
on 2026-09-12. The remote is `origin`, for both fetch and push.

## Identity and title

The mod name is `Creatures of Ki - Teshi Renew`; its packageId is `nelim.creaturesofkirenew`.
The existing suffix `Teshi Renew` already distinguishes this animal-only continuation from the
original Creatures of Ki. No additional suffix is needed. RimWorld 1.6 is declared in About.xml.
Both the About URL and the description contain the GitHub repository link.

## License and justification

**MIT**, classified `open`. The repository's LICENSE records copyright 2020 Mlie and the upstream
source https://github.com/emipa606/CreaturesOfKi. This continuation inherits the teshi assets and
definitions from Shooki/Mlie; it is not wholly original work. The local license explicitly offers
nelim's extraction and 1.6 port under the same MIT terms. ATTRIBUTION.md records provenance and
changes. This is the documented basis for retaining MIT rather than choosing a new license.

LICENSE and Mod/LICENSE are byte-identical (SHA-256 checked on 2026-09-12), so the upstream notice
and permission text accompany the distributed mod.

Live GitHub verification on 2026-09-12: the repository and its LICENSE are publicly accessible.
The upstream https://github.com/emipa606/CreaturesOfKi/blob/main/LICENSE.md explicitly contains
the MIT license, copyright 2020 Mlie; GitHub identifies that upstream license as MIT.
Our published https://github.com/vbardales/Rimworld-Creatures-Of-Ki-Renew/blob/main/LICENSE
contains that MIT text plus a provenance and scope appendix. GitHub currently labels our file
`Other` / `NOASSERTION`, not MIT. The appendix is a plausible explanation for the recognition
difference, not a verified diagnosis of GitHub's detector. The declared license remains MIT;
`licence_spdx` records the declared terms, not GitHub's automatic classification.

`visibility: public` describes repository access; `licence: open` describes the explicit permission
to reuse, modify and redistribute under the MIT notice-preservation condition. Public access alone
would not justify `open`. Here the published upstream MIT grant and the local port's explicit MIT
statement justify it. This check verifies the current published texts, not the full historical
chain of rights for every upstream asset.

Steam checked visually on 2026-09-12:
https://steamcommunity.com/sharedfiles/filedetails/?id=2726461020 contains an image banner saying
further support has become too problematic and the mod will remain available for previous game
versions. Mlie's comment dated 2024-04-25 also announces no further updates. No explicit MIT grant
or reuse prohibition was found in the displayed description/banner. The reason for stopping is
unspecified; this is not evidence of permission from every original contributor. The description
credits an anonymous writer/artist collaborating with Shooki and says Mlie recovered the mod via
Skymods. The linked original Steam item 1726422863 currently returns an error, so its terms could
not be checked. MIT is confirmed for the upstream repository, while original asset permissions
remain incompletely traced. Public repository visibility is unchanged.

## Verification

Run from this repository:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File _tools/Run-Functional-Tests.ps1
```

The suite requires the installed RimWorld data and managed assemblies; their locations can be
supplied with `-GameData` and `-Managed`. It has no dependency on scripts in a parent repository.
The original 17 checks passed on 2026-09-12. Three checks were added for shipped XML and packaging,
XML class/graphic types, and body-part/stat references. Reference resolution now uses Core alone,
so an installed DLC cannot hide an undeclared dependency. Latest run on 2026-09-12: **20 tests passed, 0 failed**, against 6,063 Core definitions, 438 abstract bases and 16,130 assembly types.

Coverage includes egg settings and hatcher target, Wildness migration, field readers, body coverage,
attack groups, texture presence and case, inheritance, named references, biomes and food flags.
The old external Check-DefRefs/Check-XmlClasses/Check-XmlFields/Check-TypeRefs tools are not present
in this repository; their historical results are not treated as a fresh run.

TESTS.md provides seven manual scenarios with actions and expected outcomes: loading, directional
rendering, Wildness, fertilized/unfertilized laying, hatching, dessicated corpse and animal behavior.
They exist but have not been executed in game by this task. All remain unverified end to end,
particularly rendering, actual egg laying/hatching and the borrowed dromedary corpse texture.

`stage: done` means implementation prepared, not tested in game or published. `tested_on` stays
empty until an actual game session is recorded; publishing must likewise update `workshop`.

## Preview recomposition — 2026-09-12

Subject checked against the shipped south/east teshi sprites and Races_Animal_Teshi.xml:
Ki is the fictional forest world, not a species. This extraction includes the teshi and its eggs,
not the Kija humanoid race. The definition describes a large bipedal feathered predator; its body
is BipedAnimalWithClawsAndTail. The sprites show a bulky upright animal, four lateral ear-like
appendages, a crest, short clawed forelimbs and a thick banded tail. A resting illustration does
not establish a quadrupedal anatomy; the earlier prose suggesting the artwork disproves the
bipedal description should not be used as an anatomical reference.

The existing illustration was retained as a stylized resting teshi beside eggs. No replacement
was generated. Art/Preview.png is a byte-identical copy of the text-free Art/Preview-source.png;
the original remains intact. The previous composited output is archived at
Art/Preview-before-2026-09-12.png, and its HTML at Art/Preview-text-before-2026-09-12.html.

Current composition: Art/preview-composition.html, with Art/preview-layout.json for geometry and
Art/preview-palette.json as the single source of current overlay colors. Art/Preview-text.html
redirects to the current composition. Reproduce with `node Art/render-preview.cjs` (Node,
Playwright, Sharp and Chrome required; NODE_PATH may point to the bundled runtime packages).
The script checks the exact About.xml title and highest stable supported version before saving.
The summary is unchanged. No status tag applies to this public mod without an unofficial suffix.

Palette rationale: the veil comes from shadowed brown straw, while the secondary ink develops
the dominant ochre family of the straw, lamplight and animal coat into a lighter golden sand.
The accent develops the cool blue-slate paving in shadow into a brighter, more saturated blue;
its hue contrasts with the dominant ochres and the secondary ink. It is deliberately not a second
amber. Final color values are stored only in Art/preview-palette.json.

Rendered at 896 x 504 using Segoe UI: SegoeUI-Semibold for the title including reduced words,
SegoeUI for the summary, SegoeUI-Bold for the version. Actual font faces verified through Chrome's
platform-font inspection after document.fonts.ready. Title 46px/600; `of` and `Renew` at 65%,
with only Renew using secondary ink. Text block at (50,54); version 1.6 from About.xml.
The brown veil holds through 65% of its ellipse to protect the end of the summary.

QA: Art/preview-qa.json records measurements; Art/preview-background-qa.png is the text-hidden
render. Every background pixel within each text span/summary rectangle was measured, not just
four corners. Minimum contrasts: main title 8.33:1, reduced suffix 5.80:1, summary 5.67:1,
badge 8.80:1. No tag to measure. Visual inspection of the final image and Art/preview-268.png
confirmed identifiable title/version, readable reduced title words, visible blue rule, no clipping
or overlap, and a clear creature/eggs silhouette. The summary is intended for the full-size view.

Delivered: Mod/About/Preview.png, 896 x 504, 665,299 bytes (below 900 kB). No publication performed.
