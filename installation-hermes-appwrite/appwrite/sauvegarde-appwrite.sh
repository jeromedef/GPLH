#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# Sauvegarde nocturne d'Appwrite (base PostgreSQL + fichiers + configuration)
# vers un stockage objet S3 situé en UE, chiffrée et dédupliquée avec restic.
#
# À installer sur le VPS en root :
#   apt-get install -y restic
#   install -m 700 sauvegarde-appwrite.sh /usr/local/sbin/sauvegarde-appwrite.sh
#   # créer /etc/appwrite-backup.env (chmod 600) -- voir le modèle plus bas
#   restic init            # une seule fois, après avoir chargé ce fichier d'env
#   echo '30 2 * * * root /usr/local/sbin/sauvegarde-appwrite.sh >> /var/log/appwrite-backup.log 2>&1' \
#     > /etc/cron.d/appwrite-backup
#
# Modèle de /etc/appwrite-backup.env (droits 600, propriétaire root) :
#   RESTIC_REPOSITORY=s3:https://s3.<region>.io.cloud.ovh.net/<nom-du-bucket>
#   RESTIC_PASSWORD=<phrase longue, À CONSERVER AUSSI HORS DU SERVEUR>
#   AWS_ACCESS_KEY_ID=<clé d'accès S3>
#   AWS_SECRET_ACCESS_KEY=<secret S3>
#   APPWRITE_DIR=/root/appwrite
#
# Sans RESTIC_PASSWORD, les sauvegardes sont illisibles : perdre ce mot de
# passe revient à perdre toutes les sauvegardes.
# ---------------------------------------------------------------------------
set -euo pipefail

ENV_FILE="${ENV_FILE:-/etc/appwrite-backup.env}"
# shellcheck source=/dev/null
source "$ENV_FILE"
export RESTIC_REPOSITORY RESTIC_PASSWORD AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY

APPWRITE_DIR="${APPWRITE_DIR:-/root/appwrite}"
STAGING="$(mktemp -d /var/tmp/appwrite-backup.XXXXXX)"
trap 'rm -rf "$STAGING"' EXIT

log() { printf '%s %s\n' "$(date '+%F %T')" "$*"; }

env_value() {  # lit une variable du .env d'Appwrite sans l'exécuter
  grep -E "^$1=" "$APPWRITE_DIR/.env" | tail -n1 | cut -d= -f2-
}

cd "$APPWRITE_DIR"
DB_USER="$(env_value _APP_DB_USER)"
DB_NAME="$(env_value _APP_DB_SCHEMA)"

log "1/4 Export de la base PostgreSQL ($DB_NAME)"
docker compose exec -T postgresql pg_dump -U "$DB_USER" -d "$DB_NAME" -Fc \
  > "$STAGING/appwrite-postgresql.dump"
test -s "$STAGING/appwrite-postgresql.dump"

log "2/4 Copie de la configuration (.env et docker-compose.yml)"
cp -p .env docker-compose.yml "$STAGING/"

log "3/4 Repérage des volumes de fichiers"
paths=("$STAGING")
for name in uploads functions builds sites imports certificates config; do
  vol="$(docker volume ls --format '{{.Name}}' | grep -E "(^|_)appwrite-${name}\$" | head -n1 || true)"
  if [[ -n "$vol" ]]; then
    paths+=("$(docker volume inspect -f '{{.Mountpoint}}' "$vol")")
  else
    log "   volume appwrite-${name} absent, ignoré"
  fi
done

log "4/4 Envoi chiffré vers $RESTIC_REPOSITORY"
restic backup --tag appwrite "${paths[@]}"
restic forget --tag appwrite --keep-daily 14 --keep-weekly 8 --keep-monthly 6 --prune

log "Sauvegarde terminée"
