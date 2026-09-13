---
localization: complete
translation_en: complete
translation_fr: complete
settings_audit: not_applicable
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
updated:      2026-09-13
remaining:
  - unverified: English and French runtime display (animal, eggs, life stage, attacks and health body parts).
  - unverified: all seven TESTS.md scenarios await an actual RimWorld 1.6 session and Player.log.
  - unverified: new-game loading and existing-save loading, saving and reloading with teshi and eggs; no current runtime evidence.
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

## Translation audit — 2026-09-13

Scope: all four XML files under Mod/Defs (five concrete defs), and the three French
DefInjected files under Mod/Languages/French. There are no assemblies, C# sources,
patches, conditional integrations, LoadFolders or additional version folders in this mod.
About metadata, technical comments, IDs, texture paths and repository documents are outside
the in-game translation gate defined in ../TRANSLATIONS.md.

Inventory: 31 owned text fields: 19 BodyDef entries (body label and 18 custom body-part
labels), nine ThingDef entries (animal and two egg labels/descriptions, three attack labels),
and three PawnKindDef entries (animal label, baby label and plural). All English texts are
nonempty native Def values; an English DefInjected copy is unnecessary. French supplies
31 unique, nonempty translations. The proper name teshi is intentionally retained.
Inherited animal, egg, life-stage and body-part UI uses Core's translation mechanisms;
no custom Keyed keys or generated-text resources are introduced. No owned strings contain
format parameters, grammar tokens or rich-text tags. Meanings and French terminology were
reviewed against the English sources, including fertilized/unfertilized eggs and left/right
body parts. Nested injection paths use native translation handles rather than list indices.

Checks: XML inventory count compared with unique nonempty French entries: 31/31.
`powershell -NoProfile -ExecutionPolicy Bypass -File _tools/Run-Functional-Tests.ps1`:
20 tests passed, zero failed against installed RimWorld 1.6 Core and assemblies.
Injection-path check: 31 keys checked, zero errors, no unresolved targets, using
`powershell -NoProfile -ExecutionPolicy Bypass -File ../scripts/Check-DefInjected.ps1 -TransMod Mod`.

Runtime English/French checks remain unverified and are tracked in remaining. Inspect
animal/egg information, the baby name and plural, melee tools and each custom health-part
label in both languages; check fallback English, raw keys, accents and clipping. Historical
stage is preserved; complete translation fields certify static readiness only.

## Ordered workflow audit — 2026-09-13

**Decision: `done` -> `done`.** This is a fresh audit of the working tree, not a
carry-forward of the declared stage. The user's supplied workflow takes precedence over
the parent protocols: settings source checks and applicable automated tests can pass
`options` without a game session; interactive checks belong to `tested`.

The stage values are literal workflow states, not numeric codes. `done` means all gates
through `preTest -> done` are established and final in-game validation is pending.
It does not mean tested in game or published.

### Scope and reproducibility

- Autonomous repository: `C:\Users\nelim\Documents\rimworld\CreaturesOfKiRenew`;
  distributed content: its `Mod/` directory. Git reports this repository root, a local
  `.git` directory, and no superproject. Physical placement under the old workspace does
  not make this repository part of its Git history. No parent remote is required.
- Audited HEAD: `f8fc3f24141f072707f04b04bbbfb182d3f8acbc`.
  At audit start, `CHANGELOG.md`, `STATUS.md` and `TESTS.md` were modified; the three
  `Mod/Languages/French/DefInjected/{BodyDef,PawnKindDef,ThingDef}/Teshi.xml` files were
  untracked. The delivered working tree, including those translations, was tested.
- This audit changes only this status and adds `_tools/audit-2026-09-13-manifest.json`.
  The manifest records relative paths, sizes and SHA-256 for all 20 distributed files.
  Prior edits and historical audit sections above are preserved. No build, generation,
  gameplay modification, commit, push or publication was performed.
- Protocols read: `../PUBLISHING.md`, `../STYLE_RIMWORLD.md`, `../MOD_SETTINGS.md`,
  `../TRANSLATIONS.md`, and applicable `../AGENTS.md`.
- Installed reference environment: RimWorld `1.6.4871 rev590`, Core data and managed
  assemblies under `C:\Program Files (x86)\Steam\steamapps\common\RimWorld`.
  Assembly-CSharp SHA-256:
  `5CF1B5BE399D5B1C9C56CA72C9D35B4ECF307FEACF5859D04AC5A1AA5926356A`.

### Ordered decisions

| Transition | Result | Current evidence |
| --- | --- | --- |
| dansMonoRepo -> horsMonoRepo | Validated | Own Git root and remote; live GitHub API reports public/non-private; `git ls-remote origin HEAD` returns the audited HEAD, establishing a pushed commit. Identity, English documentation and distributed MIT notice checked. |
| horsMonoRepo -> ModIcon generated | Validated; build not applicable | Finished XML-only animal port, no C# project or shipped assembly; 20 automated checks pass. Delivered PNG decodes at 128 x 128, 28,517 bytes; directly inspected. |
| ModIcon generated -> Preview generated | Validated | Delivered PNG decodes at 896 x 504, 665,299 bytes, below 1 MB; inspected directly, with its existing 268-pixel thumbnail. No concrete camera defect found; no historical generation report or comparison screenshot required. |
| Preview generated -> preOptions | Validated | English description; exact About title represented, `of` reduced in primary ink and `Renew` reduced in secondary ink. Blue accent is clearly distinct from golden secondary ink. Title/version readable, no clipping; public/open status needs no unofficial/prohibited suffix. |
| preOptions -> options | Justified not applicable | Settings inventory below establishes no useful settings, empty page or MainButtons shortcut. Applicable automated checks passed; no runtime integration is claimed. |
| options -> l10n | Validated | All 31 owned English Def text values reviewed against 31 nonempty unique French entries; injection validator passes all 31 paths without unresolved targets. |
| l10n -> preTest | Validated | Five concrete definitions use vanilla classes and Core references. Core-only tests pass. No required third-party dependency, conditional patch, LoadFolders or version directory. About supports 1.6; DLC loadAfter entries are optional ordering, not requirements. |
| preTest -> done | Validated | TESTS.md has seven functional scenarios with shared setup, actions and expected outcomes, plus FR/EN display checks. Automated suite and XML checks actually executed successfully on the manifest's working tree. |
| done -> tested | Unverified | No game session was executed or reviewed in this audit; no matching Player.log, bilingual interface results or save-cycle results establish this gate. |

### Settings audit

Inventory covers all four Def XML files, About.xml, language resources, repository file
inventory and the documented scope. This port adds a single animal, its body and eggs
using vanilla animal/egg classes. Wildness (0.50), biome spawn weights, combat/body
statistics, egg interval (15 days), fertilization count (1) and egg count (2) are fixed
content/balance definitions, intentionally preserved by this port. Neither documentation
nor sources offer a player configuration contract requiring XML editing. No configurable
subsystem, optional behavior switch, inherited settings provider or integration-specific
control was found. Turning these constants into sliders would add an unrequested balance
feature rather than expose an existing useful configuration.

No C# source/assembly, ModSettings implementation, settings category, MainButtonDef or
MainTabWindow is present. Native classes used by these Defs provide content behavior, not
a settings page. This establishes the absence of both an empty mod-options page and a
settings shortcut from the sources, as permitted by the user's workflow.
`settings_audit: not_applicable` is therefore justified. Settings input validation,
application timing, reset/migration, persistence and shortcut interactions are not
applicable. RIMMSQOL and other customization integrations: none tested or claimed.
Actual animal/save behavior remains in the final runtime gate.

### Checks executed and observed results

1. `powershell -NoProfile -ExecutionPolicy Bypass -File _tools/Run-Functional-Tests.ps1`
   exited 0: **20 tests, 0 failed**, 6,063 Core named defs, 438 abstract bases,
   16,130 assembly types, five mod defs and 62 written fields. This includes shipped
   XML parsing/packaging, classes, body/stat references, inheritance, egg and Wildness
   checks, field readers, body coverage, combat groups, textures/case, biomes and food
   flags. Reflection/IL checks are technical tests, not a simulation of in-game behavior.
   Suite SHA-256: `F6FA7F6ADFF7C86AD8490196D2D2BF704B3E404895409218BEC59074CE163E6E`.
2. `powershell -NoProfile -ExecutionPolicy Bypass -File ../scripts/Check-DefInjected.ps1 -TransMod Mod`
   exited 0: **31 keys checked, 0 errors**, no unresolved target reported.
   This validator indexes installed DLC as well (11,590 defs); dependency independence
   is established separately by the Core-only suite, not by this larger index.
   Validator SHA-256: `6242FC37F0B43C61967979F7837DB65D80E12BF8A019A4822D58C6532F6A2C6F`.
3. Independent text inventory: BodyDef 19, ThingDef 9, PawnKindDef 3, totaling 31.
   Corresponding French resources have 19/9/3 entries, zero empty values and duplicates.
   Meanings, sided body parts, baby singular/plural and egg types reviewed; no owned
   formatting parameters, grammar tokens, rich-text tags or additional code/UI text.
   Native English sources suffice; inherited texts use vanilla localization.
4. PNG decoding/dimensions/bytes and direct visual inspection of the delivered icon,
   Preview and existing thumbnail. Palette/composition and stored QA JSON inspected;
   historical font/contrast measurements were not rerun and are not presented as new
   measurements. Sources and composition remain outside the distributed folder.
5. `Get-FileHash LICENSE,Mod/LICENSE`: both are
   `D2AA2F4AAE44377CF4563DC2F67365C28ABD3F33CCFE47402245EC6337837B8F`.
   Live GitHub API retrieval of `emipa606/CreaturesOfKi/contents/LICENSE.md` confirms
   MIT, copyright 2020 Mlie. Local provenance and port terms remain consistent with
   that documented grant. No new license is assigned to third-party work. The earlier
   limitation concerning the complete original contributor rights chain remains a
   limitation, not newly established permission or a discovered prohibition.
6. Remote read checks initially failed under restricted access; a permitted read-only
   retry succeeded for Git HEAD, repository visibility and upstream license. No required
   remote-access check remains pending.

### Remaining checks and separate publication/documentation observations

**Next transition, done -> tested:** execute TESTS.md in RimWorld 1.6 with Core and this
mod, record actual results for all seven scenarios and FR/EN displays, inspect Player.log,
and test a new game plus an existing save (including teshi/eggs across save/reload).
Preserve game version, active mod list and evidence tied to the delivered manifest;
rerun affected regression checks after any correction. These are unverified checks,
not known gameplay failures. No settings or RIMMSQOL test is needed for the current mod.

**Observed publication convention defect, outside the supplied stage gates:**
About.xml contains a raw GitHub URL before the license/adoption paragraphs rather than
ending with `[url=https://github.com/vbardales/Rimworld-Creatures-Of-Ki-Renew]Source code on GitHub[/url]`.
PUBLISHING.md requires this before the initial Workshop submission. The user's
`preOptions` gate requires English description and naming, both satisfied; this
publication formatting discrepancy does not add an extra stage blocker. No publication
was requested or performed.

**Non-blocking review notes:** the icon has conspicuous glow/orbital sparkles, a departure
from the current prompt's flat/no-glow guidance, while its single mascot remains readable.
README/About still describe the artwork as contradicting a bipedal animal; the earlier
status inspection correctly notes that a resting pose cannot establish that contradiction.
README's wording that scenario 4 "confirms" the behavior overstates the available runtime
evidence, and ATTRIBUTION's old two-script verification paragraph is stale. These are
documentary/style observations, not new runtime failures or reasons to generate assets.

## Non-blocking audit fixes — 2026-09-13

The user requested correction of the non-blocking findings after the ordered audit.
All four observations above are now addressed; their original descriptions remain as
historical evidence, not current outstanding defects.

- About.xml now ends its English description with the prescribed Steam-formatted
  Source code on GitHub link, targeting this repository. XML parsing and the exact
  final link were checked.
- README/About describe the teshi as bipedal and the showcase pose as resting.
  README explicitly marks scenario 4's in-game confirmation as pending.
- ATTRIBUTION now describes the actual standalone 20-check suite and its limitations,
  corrects the inherited/new Def file count and the lone-female wording, and credits
  the AI icon edit.
- The built-in OpenAI image tool removed the icon's glow, orbital rings and sparkles.
  Delivered Mod/About/ModIcon.png is 128 x 128, 14,065 bytes; directly inspected at
  128 and 32 pixels. Prior icon: Art/ModIcon-before-2026-09-13.png. New source:
  Art/ModIcon-flat-source.png. Exact prompt, method and QA: Art/ModIcon-edit-2026-09-13.md.

Validation: reran _tools/Run-Functional-Tests.ps1 after the shipped edits:
20 tests, 0 failed, exit 0, against the same RimWorld 1.6.4871 rev590 environment.
XML and packaging checks pass. git diff --check passes.
The original manifest is preserved; the current delivery is recorded in
_tools/audit-2026-09-13-post-fixes-manifest.json. Comparing both manifests confirms
that only Mod/About/About.xml and Mod/About/ModIcon.png changed in the distributed
folder. Defs, French translations and gameplay textures are byte-identical, so their
independent translation/settings validations remain applicable.

Stage remains done. No in-game validation, commit, push or publication was performed.
All runtime checks in remaining still await execution.
