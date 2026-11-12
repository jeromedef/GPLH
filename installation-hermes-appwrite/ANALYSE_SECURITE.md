# Analyse de sécurité : Hermes Agent et Appwrite

> Audit en lecture seule du code source, réalisé le 12/11/2026. Rien n'a été exécuté depuis ces dépôts.
> - `NousResearch/hermes-agent` : commit `3720662` du 13/11/2026
> - `appwrite/appwrite` : commit `6534840` du 13/11/2026, version stable `2.7.2`
>
> Légende : ✅ = vérifié directement dans le code ; 🔎 = rapporté par l'audit automatisé ou par des sources web, sans revérification ligne à ligne.

## Verdict

| | Installer ? | Conditions |
|---|---|---|
| **Hermes Agent** sur le ZenBook (Windows 11) | **Oui, avec réglages** | L'installeur est propre. Le risque vient de l'agent : il agit sur votre PC avec **vos droits**. Il faut donc l'approbation manuelle des commandes, aucune mode « yolo », des mises à jour régulières, et aucun service en arrière-plan. |
| **Appwrite 2.7.2** sur un VPS vierge | **Oui, avec réglages** | Exposer l'assistant d'installation en local uniquement, passer `DO_NOT_TRACK=1`, créer le compte admin pendant l'installation, **changer le mot de passe PostgreSQL par défaut**, et ne laisser personne de non fiable déployer des Functions ou des Sites. |

---

## 1. Hermes Agent

### Ce qui est rassurant
- ✅ **Pas de télémétrie par défaut** : `telemetry.shared_metrics.enabled` et `send` valent `false` (`hermes_cli/config_defaults.py`). 🔎 Si elles étaient activées, les données iraient à `telemetry.nousresearch.com`. L'écran de consentement propose « No thanks » par défaut.
- 🔎 **Installeur sérieux** : uv est figé en version et vérifié par empreinte SHA-256. Les dépendances Python sont épinglées (`uv.lock`), les images Docker figées par empreinte. Aucun droit administrateur n'est demandé.
- ✅ **Windows natif pris en charge.** Tout s'installe dans `%LOCALAPPDATA%\hermes` (`scripts/install.ps1:28-29`). WSL2 n'est pas obligatoire.
- ✅ **Navigateur isolé** : `browser.use_real_profile: false` par défaut. Hermes n'utilise pas votre profil Chrome ou Edge.
- 🔎 Clés API rangées dans le fichier `.env` du dossier Hermes, avec masquage des secrets dans les journaux (`security.redact_secrets: true`).

### Les risques, du plus grave au moins grave
| # | Risque | Défaut constaté | Mesure appliquée |
|---|---|---|---|
| 1 | **Exécution directe sur le PC** (terminal, Python, fichiers) | ✅ `terminal.backend: local`, `approvals.mode: smart` (un LLM auxiliaire approuve seul les commandes jugées bénignes) | `approvals.mode: manual`. Ne jamais utiliser `--yolo`, `/yolo` ni Maj+Tab. |
| 2 | **Historique de failles** | 🔎 Plusieurs CVE publiées en 2026 (CVE-2026-14625 exécution de code à distance, CVE-2026-9350, CVE-2026-9353, CVE-2026-7113, CVE-2026-14783) et une campagne « hermes-0day » visant les instances exposées sur Internet | Canal stable uniquement, `hermes update` chaque semaine, rien d'exposé sur Internet. |
| 3 | **Contrôle souris/clavier** (`computer_use`) | ✅ Inclus dans les outils de base | **Conservé à votre demande.** Avec l'approbation manuelle, surveillez chaque action proposée. |
| 4 | **Réutilisation de vos connexions Claude Code / Codex** | ✅ `auth.adopt_external_logins: true` | Passé à `false`. Refuser l'import de `~/.claude` proposé pendant `hermes setup`. |
| 5 | **Persistance** (mémoire, skills, tâches planifiées, service en arrière-plan) | ✅ `memory.write_approval: false`, `skills.write_approval: false` | Les deux passés à `true`. Répondre **Non** au service « gateway ». N'installer aucun skill, plugin ou serveur MCP tiers sans en lire le code. |
| 6 | **Ports réseau** | 🔎 Rien n'écoute par défaut. Si on l'active, le webhook écoute sur toutes les interfaces (port 8644). | Ne pas activer le webhook ni le gateway (choix « terminal seulement »). |
| 7 | **Installations à la volée** depuis PyPI | ✅ `security.allow_lazy_installs: true` | Passé à `false`. |
| 8 | **Conseil d'exclusion antivirus** | 🔎 Le README suggère d'exclure un dossier de Windows Defender | **Ne pas le faire.** |

### Liste réelle des outils (lue dans le code, pas dans la documentation)
✅ `toolsets.py`, dictionnaire `TOOLSETS` (ligne 70) : **57 groupes d'outils (toolsets)** et **67 outils distincts**. L'écran `hermes tools` n'en propose que 25 groupes (`CONFIGURABLE_TOOLSETS`, `hermes_cli/tools_config.py:69`).

Les 67 outils : `annotate_preview, browser_cdp, browser_dialog, browser_exec, browser_vault, clarify, close_terminal, computer_use, cronjob_manage, delegate_task, desktop_preview, desktop_project, discord, discord_admin, drive_preview, execute_code, feishu_doc_read, feishu_drive_add_comment, feishu_drive_list_comment_replies, feishu_drive_list_comments, feishu_drive_reply_comment, focus_pane, gui_tour, image_generate, kanban_attach, kanban_attach_url, kanban_attachments, kanban_block, kanban_comment, kanban_complete, kanban_create, kanban_heartbeat, kanban_link, kanban_list, kanban_request_changes, kanban_request_review, kanban_show, kanban_unblock, manage_catalog, manage_connections, memory, patch, process_manage, react_to_message, read_file, read_terminal, read_window_below, search_files, session_search, set_theme, setup_beat, show_tip, skill_manage, skill_view, skills_list, terminal, text_to_speech, todo_list, video_analyze, video_generate, vision_analyze, web_extract, web_search, write_file, x_search, xai_video_edit, xai_video_extend`.

✅ **À savoir** : la liste blanche (`platform_toolsets.cli` dans `config.yaml`) se règle **par groupe**, pas outil par outil. `_get_platform_tools()` ignore un nom d'outil isolé. `hermes tools --summary` affiche aussi des **groupes** sous la forme « CLI (n/total) », pas des outils.

---

## 2. Appwrite 2.7.2

### Ce qui est rassurant
- ✅ **PostgreSQL est bien la base par défaut** (`_APP_DB_ADAPTER=postgresql`). Ce choix est définitif après l'installation.
- 🔎 **Console verrouillée par défaut** : `_APP_CONSOLE_WHITELIST_ROOT=enabled` limite la console à un seul compte, et une 2ᵉ inscription est refusée (erreur `user_console_count_exceeded`).
- 🔎 Les ports de PostgreSQL, Redis et ClickHouse **ne sont pas publiés** sur Internet, et le tableau de bord de Traefik n'est pas activé.
- 🔎 Aucun avis de sécurité publié sur GitHub pour le dépôt. SECURITY.md précise que seule la dernière version stable reçoit les correctifs.

### Les points de vigilance
| # | Point | Constat | Mesure |
|---|---|---|---|
| 1 | **Mot de passe PostgreSQL par défaut** | ✅ `_APP_DB_PASS=password` (utilisateur `user`). L'installateur **garde** cette valeur au lieu d'en générer une (`src/Appwrite/Platform/Tasks/Install.php`, `prepareEnvironmentVariables`). Les conteneurs des Functions rejoignent le même réseau `appwrite` que PostgreSQL (`ORCHESTRATOR_NETWORK=appwrite`). | Changer ce mot de passe **juste après l'installation** (`ALTER USER`, puis `.env`, puis `docker compose up -d`). |
| 2 | **Socket Docker** (`/var/run/docker.sock`) | 🔎 Monté par l'installateur et en permanence par `traefik`, `openruntimes-executor` et `orchestrator`. Qui contrôle ce socket est **root sur le serveur**. | Serveur dédié à Appwrite. Personne de non fiable ne déploie de Functions ou de Sites. |
| 3 | **Remontée d'informations à l'installation** | ✅ L'installateur envoie à `cloud.appwrite.io/v1/growth/installations` votre nom, votre e-mail, votre domaine, l'IP du serveur, etc. | `--env DO_NOT_TRACK=1` dans la commande d'installation (✅ `src/Appwrite/Installer/Report.php`). |
| 4 | **Assistant d'installation exposé** | 🔎 La doc fait publier le port 20080 sur toutes les interfaces | Publier sur `127.0.0.1:20080` et y accéder par un tunnel SSH. |
| 5 | **Premier visiteur = administrateur** | 🔎 Si l'étape « compte » de l'assistant est sautée, le premier visiteur de la console prend le rôle d'admin | Créer le compte admin **pendant** l'installation, puis vérifier avec `docker compose exec appwrite doctor`. |
| 6 | **Ports MQTT** 8883 et 8084 publiés | 🔎 Docker contourne le pare-feu UFW | Les fermer au pare-feu réseau d'OVH s'ils ne servent pas. |
| 7 | **Doc de sauvegarde incomplète** | 🔎 La doc officielle ne traite que MariaDB et MongoDB | Script fourni : `pg_dump` + volumes + `.env` (dont `_APP_OPENSSL_KEY_V1`, indispensable pour relire les données chiffrées). |
| 8 | **CVE citées sur le web** | 🔎 CVE-2026-89036 (versions < 2.0.0) et CVE-2026-108770 (2.0 à 2.3.0, corrigée en 2.4.0), non vérifiées | Sans effet sur la 2.7.2. Toujours installer la dernière stable. |

---

© Jérôme DEFOSSE - Manager de transition pour le CDAT avec NOETIC BEES
