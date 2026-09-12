---
mod:        Creatures of Ki - Teshi Renew
packageId:  nelim.creaturesofkirenew
depot:      Rimworld-Creatures-Of-Ki-Renew
visibilite: public
detache:    oui
etape:      done
licence:    open
licence_ou: dépôt amont de Mlie, MIT, copyright 2020
vitrine:    complete
teste_le:
workshop:   
reste:
  - non_verifie: jamais vu tourner en jeu. Reduit le 2026-09-11 par _tools/Run-Functional-Tests.ps1,
    17 tests hors jeu : restent les trois choses qu'aucune reflexion n'atteint, l'animal dessine sous
    ses quatre faces, un oeuf qui eclot, et le sprite desseche emprunte au dromadaire, que le jeu ne
    livre pas en clair. TESTS.md scenarios 2, 5 et 6.
  - feature: la vitrine est gravee en noir, d'avant la consigne du 2026-09-12 sur le voile en couleur
session:    local_6b828864-4bf7-4de6-91d5-29f775dc13a6
maj:        2026-09-12, tenue par la session du mod
---

# Creatures of Ki - Teshi Renew — etat

Fiche d'etat, lue par une passe sur tous les mods plutot qu'en interrogeant les fils un a un.
Elle vit a la racine, jamais dans `Mod/`, donc Steam ne la recoit pas.

**Tenue a jour par la session qui tient ce mod**, consigne du 2026-09-12, et non plus seulement
par la passe automatique. Elle se met a jour au moment ou l'etat change, pas a la demande : un
essai en jeu remplit `teste_le`, une dette reglee sort de `reste`, une publication remplit
`workshop`. Les trois champs qu'aucune passe ne peut deduire :

- **`etape`** — l'etat de chantier. Il doit dire la meme chose que le groupe de session, verifie
  le 2026-09-12 : `Rimworld - done`. Si les deux divergent, c'est le groupe qui a raison.
- **`teste_le`** — la date du dernier essai en jeu. Vide veut dire jamais, et c'est le cas ici.
- **`reste`** — ce qu'il reste a faire, en trois categories : `feature` pour une
  fonctionnalite manquante au premier jet, `defaut` pour un defaut connu non corrige,
  `non_verifie` pour ce qui n'a pas pu etre verifie.

Vocabulaire de `licence` : `open` licence explicite, `silent` aucune licence et source morte,
`alive` aucune licence mais source vivante, `forbidden` refus ecrit, `original` rien de repris.
