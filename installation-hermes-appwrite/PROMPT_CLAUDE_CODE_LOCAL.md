# Prompt à coller dans Claude Code sur le ZenBook

> Mode d'emploi : ouvrez Claude Code dans le dossier `installation-hermes-appwrite`, puis copiez-collez **tout le bloc ci-dessous**.

---

```text
Tu m'accompagnes pour installer 2 outils open source, un par un et dans l'ordre :
d'abord Hermes Agent sur ce PC, puis Appwrite sur mon VPS. Termine complètement
le premier avant de commencer le second. Je débute : avant chaque commande,
explique en une ou deux phrases simples ce qu'elle fait et pourquoi.

Lis d'abord, dans ce dossier, ANALYSE_SECURITE.md, hermes/config-liste-blanche.yaml,
appwrite/reglages-env.exemple et appwrite/sauvegarde-appwrite.sh. Ils contiennent
l'audit des deux dépôts et mes choix, déjà arrêtés. Ne me les redemande pas.

RÈGLES
- Ne me demande jamais de coller une clé API, un mot de passe ou un secret dans
  ce chat. Je les saisis moi-même dans l'invite de l'outil concerné ou dans le
  fichier concerné.
- Avant toute commande qui télécharge et exécute un script (irm|iex, curl|bash),
  télécharge-le d'abord dans un fichier, montre-moi ce qu'il fait, puis lance-le.
- Après chaque étape, vérifie le résultat réel (sortie de commande) et dis-moi
  clairement « réussi » ou « échec », avec la sortie en cas d'échec.
- Arrête-toi et demande-moi avant tout ce qui est difficile à annuler :
  suppression, ouverture de ports, DNS, lancement de l'installateur Appwrite.

MES CHOIX
- PC : ZenBook-Jérôme, Windows 11, 32 Go de RAM, carte NVIDIA RTX dédiée.
- Hermes : installation Windows native officielle (PowerShell, sans droits admin).
  Usage général, sans données sensibles. Modèle local + Anthropic en secours.
  Terminal seulement : PAS de gateway, PAS de service au démarrage.
- Liste blanche Hermes, 16 groupes / 26 outils : web, vision, session_search,
  clarify, memory, todo, skills, delegation, file, terminal, code_execution,
  browser, cronjob, tts, image_gen, computer_use. Tout le reste est coupé.
- Appwrite : VPS Linux loué et vierge, sans Dokploy. DNS chez OVHcloud.
  Base PostgreSQL. HTTPS Let's Encrypt. SMTP Google Workspace.
  Sauvegarde chaque nuit vers un stockage S3 en UE, avec restic.
  Clé API MCP limitée aux bases de données et aux fonctions.
  J'ai des projets Supabase ET Firebase à importer.

================ PARTIE 1 : HERMES AGENT ================
H1. Vérifie la machine : nvidia-smi (modèle de carte et VRAM), RAM, espace disque
    libre sur C: (un modèle local pèse 15 à 25 Go). Dis-moi ce que tu trouves.
H2. Installe Hermes avec le script officiel :
    https://hermes-agent.nousresearch.com/install.ps1
    Télécharge-le dans un fichier, montre-le-moi, puis lance-le (PowerShell
    utilisateur, sans droits admin). Pendant l'assistant « hermes setup » :
    refuse l'import de ~/.claude et ~/.codex, refuse la télémétrie, et réponds
    NON à l'installation et au démarrage automatique du gateway.
    N'ajoute AUCUNE exclusion à l'antivirus Windows Defender.
H3. Modèle : lance « hermes model ». Utilise son estimateur matériel pour me dire
    si un modèle local tourne correctement ici, et lequel. D'après le code, le
    candidat probable avec 32 Go de RAM et une RTX de portable est « Qwen3.6
    35B-A3B » (le seul modèle du catalogue marqué « validé »). Laisse l'estimateur
    trancher. Contrainte : Hermes exige au moins 64 000 jetons de contexte
    (MINIMUM_CONTEXT_LENGTH). Si le local est trop lent ou trop juste, dis-le-moi
    franchement.
H4. Secours : « hermes fallback add », fournisseur Anthropic. Je saisis ma clé
    moi-même dans l'invite. Puis « hermes fallback check ».
H5. Sécurité et liste blanche : fusionne hermes/config-liste-blanche.yaml dans
    %LOCALAPPDATA%\hermes\config.yaml (« hermes config set » pour les valeurs
    simples, édition du fichier pour la liste platform_toolsets.cli). Fais une
    copie de sauvegarde du fichier avant de le modifier.
    Rappel vérifié dans le code : la liste blanche se règle PAR GROUPE (toolset).
    Le dictionnaire TOOLSETS de toolsets.py compte 57 groupes et 67 outils.
H6. Preuve : lance « hermes tools --summary » et montre-moi la sortie brute.
    Indique combien de groupes sont actifs sur la ligne CLI (attendu : 16), puis
    combien d'outils individuels cela représente (attendu : 26, selon TOOLSETS).
    Signale tout groupe en trop ou manquant. Signale aussi un outil inactif faute
    de prérequis (clé du service d'images, cua-driver, Chromium).
H7. Lance « hermes » et vérifie qu'il démarre. Envoie un message simple, puis une
    demande qui déclenche une commande terminal, pour me montrer que
    l'approbation manuelle s'affiche bien. Ensuite, lance « hermes doctor ».
H8. Résume la partie 1 : ce qui est installé, où, le modèle choisi, les
    réglages de sécurité appliqués, et la commande « hermes update » à lancer
    chaque semaine.

================ PARTIE 2 : APPWRITE ================
A1. Demande-moi : le nom de domaine exact de la console (ex. appwrite.mondomaine.fr),
    l'IP du VPS, l'utilisateur SSH et l'e-mail admin. Mets en place une connexion
    SSH par clé (ssh-keygen sur ce PC). Pas de mot de passe dans le chat.
A2. Vérifie le serveur par SSH : au moins 2 cœurs (nproc), 4 Go de RAM et 2 Go de
    swap (free -h). Crée un fichier swap de 2 Go s'il manque. Vérifie aussi l'OS
    et que les ports 80 et 443 sont libres.
A3. Docker : vérifie « docker --version » et « docker compose version ». S'ils
    manquent, installe Docker Engine avec le dépôt apt officiel décrit sur
    docs.docker.com (pas le script get.docker.com).
A4. Pare-feu : UFW avec 22, 80 et 443 ouverts. Explique-moi que Docker contourne
    UFW. Propose de fermer 8883 et 8084 (MQTT) au pare-feu réseau d'OVH s'ils
    ne servent pas.
A5. DNS chez OVH : guide-moi pour créer l'enregistrement A domaine -> IP du VPS.
    Attends que « nslookup » renvoie la bonne IP avant de continuer.
A6. Installation : vérifie la dernière version stable de appwrite/appwrite
    (2.7.2 au 12/11/2026, à confirmer sur GitHub). Lance l'installateur
    officiel sur le VPS, depuis le dossier de l'utilisateur, avec ces deux
    ajouts de sécurité :
      docker run -it --rm --env DO_NOT_TRACK=1 \
        --publish 127.0.0.1:20080:20080 \
        --volume /var/run/docker.sock:/var/run/docker.sock \
        --volume "$(pwd)"/appwrite:/usr/src/code/appwrite:rw \
        --entrypoint="install" appwrite/appwrite:<VERSION>
    J'ouvre l'assistant par un tunnel : ssh -L 20080:127.0.0.1:20080 <user>@<IP>.
    Dans l'assistant : base PostgreSQL, mon domaine, HTTPS activé, e-mail pour
    les certificats, et CRÉATION DU COMPTE ADMIN tout de suite.
    Juste après : remplace le mot de passe PostgreSQL par défaut (« password »)
    en suivant appwrite/reglages-env.exemple (ALTER USER, puis .env, puis
    docker compose up -d). Vérifie que tout redémarre sans erreur.
A7. HTTPS : vérifie le certificat (curl -I https://<domaine>). Applique les
    réglages HTTPS de reglages-env.exemple. Si besoin : docker compose exec appwrite ssl.
A8. Verrouillage de la console : lance « docker compose exec appwrite doctor ».
    Il doit afficher que les limites d'accès à la console sont actives. Ensuite,
    PROUVE-LE : tente de créer un 2ᵉ compte avec une autre adresse, via
    l'API /v1/account et le projet « console ». Cette tentative doit être
    refusée (user_console_count_exceeded).
A9. SMTP Google Workspace : guide-moi pour l'option A (relais SMTP Google
    autorisé par l'IP du VPS). Sinon, option B : mot de passe d'application.
    Remplis le .env, puis docker compose up -d. Teste avec un e-mail
    « mot de passe oublié ». Vérifie qu'il part de noreply@mondomaine et regarde
    les journaux (docker compose logs appwrite-worker-mails).
    Vérifie aussi SPF et DKIM.
A10. Import : montre-moi l'assistant d'import dans la console (Project Settings >
    onglet Migrations > Create Migration, puis source Supabase ou Firebase).
    Côté Supabase : bouton Connect > Transaction pooler (hôte, port, utilisateur,
    base, mot de passe), Project URL et clé service_role. Côté Firebase : compte
    de service. Accompagne-moi pour un import par source, d'abord dans un projet
    de test. Lis la section « limitations » de la doc. Je saisis les secrets
    dans la console.
A11. MCP : dans la console, crée une clé API limitée aux scopes des bases de
    données et des fonctions (lecture et écriture), avec une date d'expiration.
    Installe uv sur ce PC si besoin, puis ajoute le serveur MCP officiel
    (README de github.com/appwrite/mcp, section auto-hébergée) :
      claude mcp add appwrite --scope user \
        --env APPWRITE_ENDPOINT=https://<domaine>/v1 \
        --env APPWRITE_PROJECT_ID=<id> --env APPWRITE_API_KEY=<clé> \
        -- uvx mcp-server-appwrite
    Je tape cette commande moi-même, pour que la clé ne passe pas par le chat.
    Préviens-moi que la clé est stockée en clair dans ma config Claude Code.
    Teste en créant une table d'essai, puis supprime-la.
A12. Sauvegardes : installe restic, appwrite/sauvegarde-appwrite.sh et
    /etc/appwrite-backup.env (je remplis moi-même les secrets S3 et la phrase
    restic). Fais « restic init », une première sauvegarde, puis un TEST DE
    RESTAURATION (restic restore + pg_restore --list sur le dump). Ensuite,
    programme la tâche cron de 2 h 30.
    Rappelle-moi de garder la phrase restic et _APP_OPENSSL_KEY_V1 hors du
    serveur.
A13. Mises à jour : explique et écris dans une note la procédure officielle :
    sauvegarde d'abord, puis la même commande docker run avec
    --entrypoint="upgrade" et la nouvelle version, puis
    « cd appwrite && docker compose exec appwrite migrate ». Seule la dernière
    stable reçoit les correctifs de sécurité.
A14. Résume la partie 2, avec la liste de tout ce qui a été vérifié et réussi,
    et tout ce qui reste à faire.
```

---

© Jérôme DEFOSSE - Manager de transition pour le CDAT avec NOETIC BEES
