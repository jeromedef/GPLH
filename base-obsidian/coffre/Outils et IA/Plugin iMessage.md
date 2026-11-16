---
type: travail
theme: Outils et IA
statut: abandonné (incompatible Windows) — remplacé par Remote Control
debut: 2026-10-27
derniere_maj: 2026-10-27
sources: [claude-code-cloud:session_01DnZbuWZo4oqbVGiyBHgtTL]
tags: [claude-code, plugin, messagerie]
---
# Plugin iMessage

## En bref
L'objectif était de piloter Claude Code par iMessage avec le plugin `imessage@claude-plugins-official`. Ce plugin **ne fonctionne que sur macOS** : il lit `~/Library/Messages/chat.db` et envoie les messages par AppleScript. Il est donc inutilisable sur le PC Windows.

## Décisions et choix
- 27/10 — Le plugin n'a pas pu être installé depuis la session cloud : la commande `/plugin install` se tape dans une session `claude` locale, et le conteneur cloud tourne sous Linux.
- 27/10 — Trois solutions ont été proposées pour le PC :
  1. **Remote Control** : lancer `claude remote-control` dans le dossier de travail. La session apparaît alors dans l'app Claude sur l'iPhone.
  2. Un canal Telegram ou Discord : les messages passeraient par des serveurs tiers, ce qui est à éviter pour les données du CDAT.
  3. Un Mac allumé en permanence.
- La solution 1, Remote Control, est celle utilisée par la suite : de nombreuses sessions « remote-control » sont lancées depuis le PC.

## Réalisations et fichiers produits
Aucune modification de dépôt.

## Actions en attente
- [ ] Rien, sauf si un Mac devient disponible. Il faudrait alors : Accès complet au disque pour le terminal, installation de Bun, `/plugin install imessage@claude-plugins-official`, puis `claude --channels plugin:imessage@claude-plugins-official`.

## Points de vigilance
- Avec un Mac, laisser `IMESSAGE_ALLOW_SMS=false` : l'expéditeur d'un SMS peut être falsifié.
- Numéro qui devait être autorisé : +33 7 61 60 53 15 (`/imessage:access allow +33761605315`).
- Le plugin lit tout l'historique Messages : n'autoriser aucun contact qui échange des données de santé ou des données RH.

## Sources
- Claude Code (cloud, iOS) — session_01DnZbuWZo4oqbVGiyBHgtTL — 27/10/2026 — « iMessage plugin installation ».

## Liens
- [[ZenBook Duo]] · [[Sommaire]]
