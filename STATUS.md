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
maj:        2026-09-12, releve automatique, puis precise par la session du mod
---

# Creatures of Ki - Teshi Renew — etat

Fiche d'etat, lue par une passe sur tous les mods plutot qu'en interrogeant les fils un a un.
Elle vit a la racine, jamais dans `Mod/`, donc Steam ne la recoit pas.

Les champs ci-dessus ont ete deduits du disque le 2026-09-12. Trois ne peuvent pas l'etre et
attendent la session qui tient ce mod :

- **`etape`** — pre-rempli depuis le groupe de session quand il existe, a confirmer.
- **`teste_le`** — la date du dernier essai en jeu. Vide veut dire jamais.
- **`reste`** — ce qu'il reste a faire, en trois categories : `feature` pour une
  fonctionnalite manquante au premier jet, `defaut` pour un defaut connu non corrige,
  `non_verifie` pour ce qui n'a pas pu etre verifie. La ligne posee d'office dit le vrai
  pour presque tout le depot ; la remplacer des qu'elle cesse de l'etre.

Vocabulaire de `licence` : `open` licence explicite, `silent` aucune licence et source morte,
`alive` aucune licence mais source vivante, `forbidden` refus ecrit, `original` rien de repris.
