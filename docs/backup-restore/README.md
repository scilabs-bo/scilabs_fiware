
# PostgreSQL Backup and Restore Service in Docker

## Overview

This Docker-based setup enables automatic backup and restore of a PostgreSQL database using `pg_basebackup`.

---

## Backup Service

### Dockerfile

The `Dockerfile` sets up the environment for the **Backup Service**.

```Dockerfile
FROM alpine:3.20.3

RUN apk add --no-cache postgresql bash

RUN mkdir backup-service

COPY crontab /backup-service/crontab
COPY backup.sh /backup-service/backup.sh
COPY entry.sh /backup-service/entry.sh

WORKDIR /backup-service

RUN mkdir -p /var/log/backup-service
RUN echo "[$(date '+%Y-%m-%d %H:%M:%S')] Backup tool created" | tee -a  /var/log/backup-service/backup.log

RUN /usr/bin/crontab crontab

CMD ["/backup-service/entry.sh"]

```

- **Base Image**: Uses a lightweight Alpine image.
- **Packages Installed**: `postgresql` for `pg_basebackup` and `bash` for scripting.
- **Directories Created**: Prepares the `/backup-service` and log directories.
- **Scripts Copied**: Copies the crontab, backup script, and entrypoint script into the container.
- **Cron Setup**: Registers the crontab for scheduled backups.
- **Entrypoint**: Specifies the startup script for the container.

---

### Crontab

The `crontab` file defines when the backup script should be executed:

```bash
*/1 * * * * /backup-service/backup.sh


```

#### Explanation:

- `*/1 * * * * /backup-service/backup.sh`: Runs the `backup.sh` script every minute. **Adjust as needed**.

---

### Entrypoint Script

The `entry.sh` script is the entrypoint for the **Backup Service**.

```bash
#!/bin/sh
if [ "$ENVIRONMENT" = "dev" ]; then
  /backup-service/backup.sh
else
  # start cron
  /usr/sbin/crond -f -l 8
fi



```

#### Explanation:

- Checks the environment variable `ENVIRONMENT`.
- If set to `dev`, the backup script runs once.
- In production mode, it starts the cron service to run the backups periodically.

---

## Backup Script Explained

Below is a step-by-step explanation of the `backup.sh` script:

#### 1. Defining Variables

```bash
# Directories
DATA_DIR="/backup-service/data"
BACKUP_DIR="/backup-service/backups"
LOG_FILE="/var/log/backup-service/backup.log"

# Number of backups to keep
KEEP_COUNT=3
```

- **`DATA_DIR`**: Directory for temporary data storage (not currently used).
- **`BACKUP_DIR`**: Directory where backups are saved.
- **`LOG_FILE`**: Path to the log file for tracking backup operations.
- **`KEEP_COUNT`**: The number of backup files to retain.

#### 2. Ensuring the Backup Directory Exists

```bash
if [ ! -d "$BACKUP_DIR" ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Backup directory '$BACKUP_DIR' does not exist. Creating it..." | tee -a "$LOG_FILE"
    mkdir -p "$BACKUP_DIR"
fi
```

- Checks if the backup directory exists. If not, it creates the directory and logs the action.

#### 3. Creating a New Backup

```bash
BACKUP_SUBDIR="$BACKUP_DIR/backup_$(date '+%Y%m%d_%H%M%S')"

pg_basebackup \
  --host=$QUANTUMLEAP_DB_HOST \
  --username=$QUANTUMLEAP_DB_USER \
  --pgdata="$BACKUP_SUBDIR" \
  --format=tar \
  --gzip \
  --progress
```

- **`BACKUP_SUBDIR`**: Creates a new backup subdirectory with a timestamp.
- **`pg_basebackup`**: Executes the PostgreSQL base backup and compresses the output into a `.tar.gz` file.

#### 4. Handling Backup Success or Failure

```bash
if [ $? -eq 0 ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Backup successful: $BACKUP_SUBDIR" | tee -a "$LOG_FILE"
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Backup failed!" | tee -a "$LOG_FILE"
    exit 1
fi
```

- Checks the exit status of the `pg_basebackup` command. Logs whether the backup was successful or failed.

#### 5. Cleaning Up Old Backups

```bash
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Cleaning up old backups if necessary..." | tee -a "$LOG_FILE"

cd "$BACKUP_DIR" || {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Failed to change directory to $BACKUP_DIR" | tee -a "$LOG_FILE"
    exit 1
}

BACKUP_FILES=$(find . -maxdepth 1 -type d -name 'backup_*' | sort -r | sed 's|^\./||')

if [ "$DELETE_COUNT" -gt 0 ]; then
    BACKUPS_TO_DELETE=$(echo "$BACKUP_FILES" | tail -n "$DELETE_COUNT")

    for backup in $BACKUPS_TO_DELETE; do
        rm -rf "$backup"
    done
fi
```

- Deletes older backups beyond the `KEEP_COUNT` limit to manage disk space.

---


# Restore Service 

## Dockerfile

Below is an  `Dockerfile` for the **Restore Service**:

```dockerfile
FROM alpine:3.20.3

RUN apk add --no-cache \
    bash

RUN mkdir -p /restore-service
RUN mkdir -p /init

COPY restore.sh /restore-service/restore.sh

COPY entry.sh /restore-service/entry.sh

RUN mkdir -p /var/log/backup-restore/

RUN echo "[$(date '+%Y-%m-%d %H:%M:%S')] Backup restore tool created!" | tee -a /var/log/backup-restore/restore.log

CMD ["/restore-service/entry.sh"]
```

- **Base Image**: Uses a lightweight Alpine image.
- **Packages Installed**:  `bash` for scripting.
- **Directories Created**: Prepares the`/restore-service` and log directories.
- **Scripts Copied**: Copies the backup script and entrypoint script into the container.
- **Entrypoint**: Specifies the startup script for the container.

---

## Entrypoint Script

Below is an example `entry.sh` script:

```bash
#!/bin/sh
./restore-service/restore.sh
```

---

## Restore Script Explained

### 1. Directives and Variables
```bash
#!/bin/sh
set -e

# Directories
BACKUP_DIR="/restore-service/backups"
DATA_DIR="/restore-service/timescale_data/data"
LOG_FILE="/var/log/restore-service/restore.log"
```

- **`#!/bin/sh`**: Indicates that the script is executed with the POSIX-compatible shell.
- **`set -e`**: Enforces the script to terminate immediately if an error occurs.
- **`BACKUP_DIR`**: Directory where the backups are stored.
- **`DATA_DIR`**: Target directory where the restored data is placed.
- **`LOG_FILE`**: File to which all log entries are written.

### 2. Checking the `RESTORE_ON` Environment Variable 
```bash
if [ ! "$RESTORE_ON" ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Restore operation aborted intentionally." | tee -a "$LOG_FILE"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Reason: Environment variable 'RESTORE_ON' is set to 'false', preventing execution." | tee -a "$LOG_FILE"
    exit 0
fi
```
- Checks if the RESTORE_ON environment variable is set. If it’s not present (or false), the script logs a message and then exits.
- Keep `RESTORE_ON=false` in normal operation. With `true` the restore runs on every start of the stack (also when `docker compose up` starts single services) and replaces the database content with the latest backup.
### 3. Selecting the Most Recent Backup Directory
```bash
BACKUP_DIR_LATEST=$(ls -1td "$BACKUP_DIR"/backup_* | head -n 1)
```
- Uses ls to list backup directories (named backup_*) in descending order of modification time and picks the first (newest) one.

### 4. Checking if a Backup Directory Exists
```bash
if [ -z "$BACKUP_DIR_LATEST" ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] No backup directories found in $BACKUP_DIR. Exiting..." | tee -a "$LOG_FILE"
    exit 0
fi
```
- Verifies whether a backup directory was found. If not, it logs a message and exits.

### 5. Verzeichnisinhalte anzeigen
```bash
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Contents of backup directory:" | tee -a "$LOG_FILE"
ls -l "$BACKUP_DIR_LATEST" | tee -a "$LOG_FILE"
```

### 6. Displaying the Directory Contents
```bash
if [ ! -d "$DATA_DIR" ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Data directory '$DATA_DIR' does not exist. Creating it..." | tee -a "$LOG_FILE"
    mkdir -p "$DATA_DIR"
fi
```
- Shows the contents of the most recent backup directory and logs them.

### 7. Removing Existing Data
```bash
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Removing existing data directory contents..." | tee -a "$LOG_FILE"
rm -rf "$DATA_DIR"/*
```
- Deletes all existing files in the data directory to ensure a clean restoration.

### 8. Extracting the Backup Files
```bash
if [ -f "$BACKUP_DIR_LATEST/base.tar.gz" ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Extracting base.tar.gz to $DATA_DIR..." | tee -a "$LOG_FILE"
    tar -xzf "$BACKUP_DIR_LATEST/base.tar.gz" -C "$DATA_DIR"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Extracted base.tar.gz successfully." | tee -a "$LOG_FILE"
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] base.tar.gz not found in $BACKUP_DIR_LATEST. Exiting..." | tee -a "$LOG_FILE"
    exit 1
fi
```
- Looks for base.tar.gz in the backup directory and extracts it into the data directory if found. Otherwise, logs an error and exits.


### 9. Extracting the `pg_wal` Files
```bash
if [ -f "$BACKUP_DIR_LATEST/pg_wal.tar.gz" ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Extracting pg_wal.tar.gz to $DATA_DIR/pg_wal..." | tee -a "$LOG_FILE"
    mkdir -p "$DATA_DIR/pg_wal"
    tar -xzf "$BACKUP_DIR_LATEST/pg_wal.tar.gz" -C "$DATA_DIR/pg_wal"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Extracted pg_wal.tar.gz successfully." | tee -a "$LOG_FILE"
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] pg_wal.tar.gz not found in $BACKUP_DIR_LATEST. Exiting..." | tee -a "$LOG_FILE"
    exit 1
fi
```
- Checks for the pg_wal.tar.gz file and, if present, extracts it to the pg_wal subdirectory within the data directory.

### 10. Copying the `backup_manifest` File 
```bash
if [ -f "$BACKUP_DIR_LATEST/backup_manifest" ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Copying backup_manifest to $DATA_DIR..." | tee -a "$LOG_FILE"
    cp "$BACKUP_DIR_LATEST/backup_manifest" "$DATA_DIR/backup_manifest"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Copied backup_manifest successfully." | tee -a "$LOG_FILE"
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] backup_manifest not found in $BACKUP_DIR_LATEST. Continuing without it." | tee -a "$LOG_FILE"
fi
```
- If a backup_manifest file is present, it is copied to the data directory for reference. If not, the script logs the absence but continues.
