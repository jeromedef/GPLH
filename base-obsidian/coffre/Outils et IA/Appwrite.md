---
type: travail
theme: Outils et IA
statut: préparé, installation à lancer
debut: 2026-11-12
derniere_maj: 2026-11-16
sources: [claude-code-cloud:session_01DnZbuXG9hpH1rhtidHLEZ8]
tags: [backend, self-hosting, vps, supabase, firebase, securite]
---
# Appwrite

## En bref
Backend open source (`appwrite/appwrite`), alternative à Supabase et Firebase, à installer sur un VPS. La dernière version stable était la **2.7.2** au 12/11/2026. L'audit et le dossier d'installation sont prêts. Il manque le nom de domaine exact et l'accès au VPS.

## Contexte
Il faut un backend auto-hébergé, avec import des projets Supabase et Firebase existants. Claude Code doit pouvoir y créer des tables et des fonctions grâce au serveur MCP d'Appwrite.

## Décisions et choix
- 12/11 — **Serveur et domaine :** VPS Linux loué et vierge (ports 80 et 443 libres), sans Dokploy. DNS chez **OVHcloud**.
- 12/11 — **Base et HTTPS :** base **PostgreSQL**, qui est la valeur par défaut, confirmée dans le code. HTTPS par Let's Encrypt.
- 12/11 — **E-mails :** SMTP **Google Workspace**. Option recommandée : le relais `smtp-relay.gmail.com`, autorisé par l'adresse IP du VPS.
- 12/11 — **Import :** projets Supabase **et** Firebase. L'assistant se trouve dans Project Settings > Migrations > Create Migration.
- 12/11 — **Sauvegardes :** chaque nuit à 2 h 30, vers un stockage S3 en UE, avec **restic**. Conservation : 14 sauvegardes quotidiennes, 8 hebdomadaires et 6 mensuelles.
- 12/11 — **Clé API du serveur MCP :** limitée aux bases de données et aux fonctions, avec une date d'expiration.

## Faits vérifiés dans le code (commit 6534840 du 13/11/2026)
- L'installateur **garde le mot de passe PostgreSQL par défaut** : `_APP_DB_PASS=password`, utilisateur `user`. Or les conteneurs des Functions rejoignent le même réseau que la base. Il faut changer ce mot de passe juste après l'installation (`ALTER USER`, puis `.env`, puis `docker compose up -d`).
- L'installateur envoie à `cloud.appwrite.io` le nom, l'e-mail, le domaine et l'IP du serveur. On l'en empêche avec `--env DO_NOT_TRACK=1`.
- La console est limitée à un seul compte par défaut (`_APP_CONSOLE_WHITELIST_ROOT=enabled`). Il faut créer le compte admin **pendant** l'installation.
- `/var/run/docker.sock` est monté par Traefik, l'executor et l'orchestrator. Celui qui contrôle ce fichier est root sur le serveur.
- Les ports MQTT 8883 et 8084 sont publiés. Docker contourne le pare-feu UFW.

## Réalisations et fichiers produits
Dans le dépôt GPLH (branche `main`), dossier `installation-hermes-appwrite/` :
- `PROMPT_CLAUDE_CODE_LOCAL.md` (étapes A1 à A14) ;
- `appwrite/reglages-env.exemple` ;
- `appwrite/sauvegarde-appwrite.sh` (le script passe `bash -n` et `shellcheck`, mais il n'a jamais été exécuté sur un vrai serveur) ;
- `ANALYSE_SECURITE.md`.

## Actions en attente
- [ ] Fournir le domaine exact de la console, l'IP du VPS, l'utilisateur SSH et l'e-mail admin.
- [ ] Lancer les étapes A1 à A14 avec Claude Code sur le PC.
- [ ] Lancer l'installateur avec `--publish 127.0.0.1:20080:20080` et passer par un tunnel SSH.
- [ ] Faire un test de restauration de la sauvegarde (étape A12).
- [ ] Garder la phrase restic et `_APP_OPENSSL_KEY_V1` **hors du serveur**.

## Points de vigilance
- Seule la dernière version stable reçoit les correctifs de sécurité. Mise à jour : relancer l'installateur avec `--entrypoint="upgrade"`, puis `docker compose exec appwrite migrate`.

## Sources
- Claude Code (cloud) — session_01DnZbuXG9hpH1rhtidHLEZ8 — 12 au 16/11/2026.

## Liens
- [[Hermes Agent]] · [[Dépôt GitHub GPLH]] · [[Sommaire]]
