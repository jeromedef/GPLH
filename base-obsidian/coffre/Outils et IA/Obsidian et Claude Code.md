---
type: travail
theme: Outils et IA
statut: en service
debut: 2026-11-16
derniere_maj: 2026-11-16
sources: [claude-code-cloud:session_01DnZbuXG9hpH1rhtidHLEZ8]
tags: [obsidian, claude-code, base-de-connaissances]
---
# Obsidian et Claude Code

## En bref
Obsidian est installé, et son coffre est piloté par Claude Code directement sur le PC, sans plugin ni service tiers. Ce coffre accueille la base contextuelle de tous les travaux (voir [[Sommaire]]).

## Décisions et choix
- 16/11 — **Accès au coffre :** par Claude Code ouvert dans le dossier du coffre. Ont été écartés : une synchronisation GitHub, et un serveur MCP communautaire qu'il aurait fallu auditer.
- 16/11 — **Mode d'autorisation :** manuel (« manual mode on »). Claude Code demande la permission avant chaque modification.
- 16/11 — **Base contextuelle :** classement par thème puis par travail. Sources retenues : Claude Code, Codex, claude.ai et ChatGPT. Les données personnelles sont conservées, par choix de l'utilisateur. Les secrets sont toujours exclus.

## Réalisations et fichiers produits
- **Obsidian :** installé par `winget install -e --id Obsidian.Obsidian`.
- **Coffre :** `C:\Users\jerom\OneDrive\Bureau\Coffre`, synchronisé par OneDrive.
- **Claude Code 2.1.236 :** une mise à jour est téléchargée et s'applique au prochain lancement.
- **`CLAUDE.md` à la racine du coffre :**
  - notes en français ;
  - aucune suppression, aucun renommage ni déplacement sans accord ;
  - liens `[[...]]` vers les notes existantes ;
  - interdiction de modifier `.obsidian/` sans demande explicite.
- **Notes existantes :** « Mon premier essai » et « créez un lien ».
- **Commande de lancement :** `cd "$HOME\OneDrive\Bureau\Coffre"; claude`.

## Incidents
- 16/11 — En mode auto, une suggestion grisée envoyée par erreur a fait **supprimer `Bienvenue.md` sans demande de permission**. La note reste récupérable environ 30 jours dans la corbeille OneDrive. Le mode est ensuite repassé en manuel.

## Actions en attente
- [ ] Exclure `CLAUDE.md` de la recherche et du graphe : Paramètres > Fichiers et liens > Fichiers exclus > Gérer. La vérification du 16/11 a montré que `userIgnoreFilters` était encore vide.
- [ ] Faire démarrer Claude Code en mode manuel par défaut. On peut le lui demander directement.
- [ ] Adapter la convention de `CLAUDE.md`, qui prévoit « une note = un fichier à la racine », au classement par dossiers de thème.

## Points de vigilance
- Ne jamais valider une suggestion grisée par Entrée sans l'avoir lue.
- Sous PowerShell 5.1, il faut lire les fichiers avec `-Encoding UTF8`. Sans cela, les accents s'affichent mal ; ce n'est qu'un défaut d'affichage, le fichier est sain.
- Le coffre est sur OneDrive : son contenu est aussi stocké sur le cloud de Microsoft.

## Sources
- Claude Code (cloud) — session_01DnZbuXG9hpH1rhtidHLEZ8 — 16/11/2026.

## Liens
- [[ZenBook Duo]] · [[Sommaire]]
