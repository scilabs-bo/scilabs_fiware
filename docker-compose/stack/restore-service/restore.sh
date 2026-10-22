#!/bin/sh
set -e

BACKUP_DIR="/restore-service/backups"
DATA_DIR="/restore-service/timescale_data/data"
LOG_FILE="/var/log/restore-service/restore.log"

if ! $RESTORE_ON  ; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Restore operation aborted intentionally." | tee -a "$LOG_FILE"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Reason: Environment variable 'RESTORE_ON' is set to 'false', preventing execution." | tee -a "$LOG_FILE"
    exit 0
fi

BACKUP_DIR_LATEST=$(ls -1td "$BACKUP_DIR"/backup_* | head -n 1)

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Latest backup directory: $BACKUP_DIR_LATEST" | tee -a "$LOG_FILE"

if [ -z "$BACKUP_DIR_LATEST" ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] No backup directories found in $BACKUP_DIR. Exiting..." | tee -a "$LOG_FILE"
    exit 0
fi

if [ ! -d "$BACKUP_DIR_LATEST" ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Backup directory '$BACKUP_DIR_LATEST' does not exist. Exiting..." | tee -a "$LOG_FILE"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Shutdown" | tee -a "$LOG_FILE"
    exit 0
fi

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Contents of backup directory:" | tee -a "$LOG_FILE"
ls -l "$BACKUP_DIR_LATEST" | tee -a "$LOG_FILE"

if [ ! -d "$DATA_DIR" ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Data directory '$DATA_DIR' does not exist. Creating it..." | tee -a "$LOG_FILE"
    mkdir -p "$DATA_DIR"
fi

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Removing existing data directory contents..." | tee -a "$LOG_FILE"
rm -rf "$DATA_DIR"/*


if [ -f "$BACKUP_DIR_LATEST/base.tar.gz" ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Extracting base.tar.gz to $DATA_DIR..." | tee -a "$LOG_FILE"
    tar -xzf "$BACKUP_DIR_LATEST/base.tar.gz" -C "$DATA_DIR"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Extracted base.tar.gz successfully." | tee -a "$LOG_FILE"
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] base.tar.gz not found in $BACKUP_DIR_LATEST. Exiting..." | tee -a "$LOG_FILE"
    exit 0
fi

if [ -f "$BACKUP_DIR_LATEST/pg_wal.tar.gz" ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Extracting pg_wal.tar.gz to $DATA_DIR/pg_wal..." | tee -a "$LOG_FILE"
    mkdir -p "$DATA_DIR/pg_wal"
    tar -xzf "$BACKUP_DIR_LATEST/pg_wal.tar.gz" -C "$DATA_DIR/pg_wal"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Extracted pg_wal.tar.gz successfully." | tee -a "$LOG_FILE"
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] pg_wal.tar.gz not found in $BACKUP_DIR_LATEST. Exiting..." | tee -a "$LOG_FILE"
    exit 1
fi

if [ -f "$BACKUP_DIR_LATEST/backup_manifest" ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Copying backup_manifest to $DATA_DIR..." | tee -a "$LOG_FILE"
    cp "$BACKUP_DIR_LATEST/backup_manifest" "$DATA_DIR/backup_manifest"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Copied backup_manifest successfully." | tee -a "$LOG_FILE"
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] backup_manifest not found in $BACKUP_DIR_LATEST. Continuing without it." | tee -a "$LOG_FILE"
fi

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Setting ownership of $DATA_DIR to postgres:postgres..." | tee -a "$LOG_FILE"
chown -R 1000:1000 "/restore-service/timescale_data"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Set ownership successfully." | tee -a "$LOG_FILE"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Restore successful!" | tee -a "$LOG_FILE"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Restore process completed." | tee -a "$LOG_FILE"