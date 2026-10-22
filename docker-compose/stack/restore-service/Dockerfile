FROM alpine:3.20.3

RUN apk add --no-cache \
    bash

RUN mkdir -p /restore-service/backups

COPY restore.sh /restore-service/restore.sh

COPY entry.sh /restore-service/entry.sh

RUN mkdir -p /var/log/backup-restore/

RUN echo "[$(date '+%Y-%m-%d %H:%M:%S')] Backup restore tool started!" | tee -a /var/log/backup-restore/restore.log

CMD ["/restore-service/entry.sh"]
