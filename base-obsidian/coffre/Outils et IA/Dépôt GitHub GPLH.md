---
type: travail
theme: Outils et IA
statut: actif
debut: 2026-11-12
derniere_maj: 2026-11-16
sources: [claude-code-cloud:session_01DnZbuXG9hpH1rhtidHLEZ8]
tags: [github, depot]
---
# Dépôt GitHub GPLH

## En bref
Le dépôt `jeromedef/GPLH` (https://github.com/jeromedef/GPLH) contient le projet « ia-medical ». C'est un système de simulation hospitalière par événements discrets, avec des tableaux de bord et des prédictions par apprentissage automatique (projet ARTISHOW, Telecom Paris). Il héberge aussi les dossiers de travail préparés par Claude.

## Décisions et choix
- 13/11 — L'application Claude GitHub est installée sur le dépôt. Sans elle, Claude ne pouvait pas y écrire (erreur 403), même avec le compte GitHub connecté.
- Les sessions Claude travaillent sur la branche `claude/hermes-appwrite-setup-ruczf3`, puis fusionnent par demande de fusion (PR) vers `main`.

## Réalisations et fichiers produits
- **PR #1** (fusionnée le 16/11/2026) : dossier `installation-hermes-appwrite/`, voir [[Hermes Agent]] et [[Appwrite]].
- **PR #2** (fusionnée le 16/11/2026) : README corrigé pour récupérer le dossier depuis `main`.
- Dossier `base-obsidian/` : fiches et prompt de la base contextuelle Obsidian.

## Actions en attente
- [ ] Cloner ou mettre à jour le dépôt sur le PC : `cd $HOME\Documents\GPLH; git checkout main; git pull`.

## Sources
- Claude Code (cloud) — session_01DnZbuXG9hpH1rhtidHLEZ8 — 12 au 16/11/2026.

## Liens
- [[Sommaire]]
