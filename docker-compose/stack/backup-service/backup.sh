#!/bin/sh

DATA_DIR="/backup-service/data"
BACKUP_DIR="/backup-service/backups"
LOG_FILE="/var/log/backup-service/backup.log"

KEEP_COUNT=3

if [ ! -d "$BACKUP_DIR" ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Backup directory '$BACKUP_DIR' does not exist. Creating it..." | tee -a  "$LOG_FILE"
    mkdir -p "$BACKUP_DIR"
fi

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting backup..." | tee -a  "$LOG_FILE"
BACKUP_SUBDIR="$BACKUP_DIR/backup_$(date '+%Y%m%d_%H%M%S')"

pg_basebackup \
  --host=$QUANTUMLEAP_DB_HOST \
  --username=$QUANTUMLEAP_DB_USER \
  --pgdata="$BACKUP_SUBDIR" \
  --format=tar \
  --gzip \
  --progress


if [ $? -eq 0 ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Backup successful: $BACKUP_SUBDIR" | tee -a "$LOG_FILE"
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Backup failed!" | tee -a "$LOG_FILE"
    exit 1
fi

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Cleaning up old backups if necessary..." | tee -a "$LOG_FILE"

cd "$BACKUP_DIR" || {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Failed to change directory to $BACKUP_DIR" | tee -a "$LOG_FILE"
    exit 1
}

BACKUP_FILES=$(find . -maxdepth 1 -type d -name 'backup_*' | sort -r | sed 's|^\./||')

if [ -z "$BACKUP_FILES" ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] No backups found to delete." | tee -a "$LOG_FILE"
    exit 0
fi

TOTAL_BACKUPS=$(echo "$BACKUP_FILES" | wc -l)
DELETE_COUNT=$((TOTAL_BACKUPS - KEEP_COUNT))

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Total backups: $TOTAL_BACKUPS, Keeping: $KEEP_COUNT, Deleting: $DELETE_COUNT" | tee -a "$LOG_FILE"

if [ "$DELETE_COUNT" -gt 0 ]; then
    BACKUPS_TO_DELETE=$(echo "$BACKUP_FILES" | tail -n "$DELETE_COUNT")

    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Backups to delete:" | tee -a "$LOG_FILE"
    echo "$BACKUPS_TO_DELETE" | tee -a "$LOG_FILE"

    for backup in $BACKUPS_TO_DELETE; do
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Deleting $backup" | tee -a "$LOG_FILE"
        rm -rf "$backup"
        if [ $? -eq 0 ]; then
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] Successfully deleted $backup" | tee -a "$LOG_FILE"
        else
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] Failed to delete $backup" | tee -a "$LOG_FILE"
            exit 1
        fi
    done
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] No old backups to delete." | tee -a "$LOG_FILE"
fi

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Backup completed." | tee -a "$LOG_FILE"