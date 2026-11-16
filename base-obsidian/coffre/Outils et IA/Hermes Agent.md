---
type: travail
theme: Outils et IA
statut: préparé, installation à lancer
debut: 2026-11-12
derniere_maj: 2026-11-16
sources: [claude-code-cloud:session_01DnZbuXG9hpH1rhtidHLEZ8]
tags: [ia, agent, nous-research, securite]
---
# Hermes Agent

## En bref
Agent IA open source de Nous Research (dépôt `NousResearch/hermes-agent`), à installer sur le [[ZenBook Duo]]. L'audit de sécurité est fait et le dossier d'installation est prêt dans le [[Dépôt GitHub GPLH]]. L'installation elle-même reste à lancer avec Claude Code sur le PC.

## Contexte
- Demande initiale : installer Hermes, choisir le modèle, restreindre les outils par liste blanche lue dans le code source (dictionnaire `TOOLSETS`), et prouver l'état final avec `hermes tools --summary`.
- La session cloud ne pouvant pas agir sur le PC, l'installation est confiée à Claude Code en local, à partir d'un prompt.

## Décisions et choix
- 12/11 — Installation **Windows native**, par le script PowerShell officiel, sans droits administrateur.
- 12/11 — Usage général, sans données sensibles. Terminal seulement : **pas de gateway** (messagerie), pas de service au démarrage.
- 12/11 — Liste blanche de **16 groupes, soit 26 outils** : web, vision, session_search, clarify, memory, todo, skills, delegation, file, terminal, code_execution, browser, cronjob, tts, image_gen, computer_use. `computer_use` est gardé en connaissance de cause, malgré un risque élevé.
- 12/11 — Réglages de sécurité :
  - `approvals.mode: manual` ;
  - `auth.adopt_external_logins: false` ;
  - `memory.write_approval: true` et `skills.write_approval: true` ;
  - `security.allow_lazy_installs: false` ;
  - télémétrie coupée.
- 16/11 — Modèle local **via LM Studio** (voir [[Heretic et LM Studio]]), car le PC a une puce Intel Arc 140T et non une carte Nvidia.
  - Modèle : Qwen3 4B Instruct 2507 dans sa **version d'origine**, avec 65 536 jetons de contexte.
  - Anthropic en secours (`hermes fallback add`).
- 16/11 — **Aucun modèle passé dans Heretic** pour Hermes, car c'est un agent qui exécute des commandes.

## Faits vérifiés dans le code (commit 3720662 du 13/11/2026)
- `toolsets.py` : 57 groupes et 67 outils distincts. L'écran `hermes tools` n'en propose que 25 groupes.
- La liste blanche (`platform_toolsets.cli`) fonctionne **par groupe** : un nom d'outil isolé y est ignoré. `hermes tools --summary` compte aussi des groupes.
- Valeurs par défaut :
  - `approvals.mode: smart` (un LLM valide seul les commandes jugées bénignes) ;
  - `terminal.backend: local` ;
  - télémétrie `shared_metrics` désactivée ;
  - `MINIMUM_CONTEXT_LENGTH = 64_000`.
- Le moteur local intégré choisit Vulkan pour Intel/Arc. La version `llama-b12144-bin-win-vulkan-x64.zip` est épinglée avec son empreinte SHA-256. Le catalogue intégré ne propose que des modèles de 27 milliards de paramètres ou plus, trop lourds pour ce PC.
- Plusieurs CVE ont été publiées en 2026 (dont CVE-2026-14625, exécution de code à distance). Il faut mettre à jour avec `hermes update` chaque semaine.

## Réalisations et fichiers produits
Dans le dépôt GPLH (branche `main`) :
- `installation-hermes-appwrite/PROMPT_CLAUDE_CODE_LOCAL.md` — étapes H1 à H8 ;
- `installation-hermes-appwrite/hermes/config-liste-blanche.yaml` ;
- `installation-hermes-appwrite/ANALYSE_SECURITE.md`.

Ces fichiers ont été fusionnés par les PR #1 et #2 le 16/11/2026.

## Actions en attente
- [ ] Récupérer le dossier (`git pull` sur `main`) et lancer les étapes H1 à H8 avec Claude Code sur le PC.
- [ ] Tester le couple LM Studio + Hermes (étape H3). Si c'est trop lent, passer Anthropic en modèle principal.
- [ ] Vérifier `hermes tools --summary` : 16 groupes attendus sur la ligne CLI.
- [ ] Lancer `hermes update` chaque semaine.

## Points de vigilance
- Hermes agit sur le PC avec les droits de l'utilisateur. Ne jamais utiliser `--yolo`, `/yolo` ni Maj+Tab dans son interface.
- N'ajouter aucune exclusion antivirus, même si le README de Hermes le suggère.

## Sources
- Claude Code (cloud) — session_01DnZbuXG9hpH1rhtidHLEZ8 — 12 au 16/11/2026 — « Installer Hermes Agent et Appwrite ».

## Liens
- [[Appwrite]] · [[Heretic et LM Studio]] · [[ZenBook Duo]] · [[Dépôt GitHub GPLH]] · [[Sommaire]]
