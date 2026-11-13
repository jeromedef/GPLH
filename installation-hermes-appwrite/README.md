# Installation de Hermes Agent et d'Appwrite

Ce dossier prépare l'installation de deux outils open source, dans cet ordre :
1. **Hermes Agent** (Nous Research) sur le ZenBook-Jérôme, sous Windows 11 ;
2. **Appwrite** (alternative à Supabase et Firebase) sur votre VPS Linux.

L'analyse et les choix ont été faits dans une session Claude Code cloud, qui n'a pas accès à votre PC. **L'installation elle-même se fait avec Claude Code sur votre PC**, à partir du prompt fourni ici.

## Contenu

| Fichier | Rôle |
|---|---|
| `ANALYSE_SECURITE.md` | Audit des deux dépôts GitHub : verdict, risques et mesures |
| `PROMPT_CLAUDE_CODE_LOCAL.md` | **Le prompt à copier-coller** dans Claude Code sur le ZenBook |
| `hermes/config-liste-blanche.yaml` | Liste blanche des outils Hermes (16 groupes, 26 outils) et réglages de sécurité |
| `appwrite/reglages-env.exemple` | Réglages HTTPS, verrouillage de la console, SMTP Google Workspace, mot de passe de la base |
| `appwrite/sauvegarde-appwrite.sh` | Sauvegarde nocturne chiffrée vers S3 en UE (restic) |

## Marche à suivre (débutant)

**1. Installer Git pour Windows**, nécessaire à Claude Code : téléchargez-le sur <https://git-scm.com/download/win> et gardez les options par défaut.

**2. Installer Claude Code** : ouvrez **PowerShell** (menu Démarrer, tapez « PowerShell »), puis lancez :
```powershell
irm https://claude.ai/install.ps1 | iex
```
Fermez et rouvrez PowerShell, puis tapez `claude` pour vous connecter avec votre compte.

**3. Récupérer ce dossier sur le PC** :
```powershell
cd $HOME\Documents
git clone https://github.com/jeromedef/GPLH.git
cd GPLH
git checkout claude/hermes-appwrite-setup-ruczf3
cd installation-hermes-appwrite
```
Si la demande de fusion (pull request) a déjà été acceptée, ne tapez pas `git checkout ...` : le dossier est alors directement sur la branche principale.

**4. Lancer Claude Code dans ce dossier** : tapez `claude`, puis copiez-collez le bloc de `PROMPT_CLAUDE_CODE_LOCAL.md`.

## Vos choix, déjà intégrés au prompt

- **Hermes** : installation Windows native ; modèle local (candidat probable : Qwen3.6 35B-A3B, que l'estimateur de Hermes confirmera) avec Anthropic en secours ; usage général ; terminal seulement, sans gateway.
- **Liste blanche** : 16 groupes et 26 outils, `computer_use` compris, choix confirmé en connaissance de cause. Approbation **manuelle** des commandes.
- **Appwrite** : VPS vierge, sans Dokploy, DNS chez OVH, base PostgreSQL, HTTPS Let's Encrypt, SMTP Google Workspace, import Supabase et Firebase.
- **Exploitation** : sauvegarde S3 en UE chaque nuit ; clé MCP limitée aux bases de données et aux fonctions.

## Les 3 points de sécurité à retenir

1. **Hermes agit sur votre PC avec vos droits** : laissez l'approbation en mode `manual` et n'utilisez jamais `--yolo`. Mettez à jour avec `hermes update` chaque semaine, car plusieurs failles ont été corrigées en 2026.
2. **Appwrite garde par défaut le mot de passe `password`** pour sa base PostgreSQL. Il doit être changé juste après l'installation (étape A6 du prompt).
3. **Les sauvegardes ne valent que si la restauration a été testée.** Conservez la phrase restic et la clé `_APP_OPENSSL_KEY_V1` hors du serveur.

---

© Jérôme DEFOSSE - Manager de transition pour le CDAT avec NOETIC BEES
