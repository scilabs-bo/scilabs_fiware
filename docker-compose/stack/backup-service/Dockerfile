FROM alpine:3.20.3

RUN apk add --no-cache postgresql bash

RUN mkdir backup-service

COPY crontab /backup-service/crontab
COPY backup.sh /backup-service/backup.sh
COPY entry.sh /backup-service/entry.sh

WORKDIR /backup-service

RUN mkdir -p /var/log/backup-service
RUN echo "[$(date '+%Y-%m-%d %H:%M:%S')] Backup tool created" | tee -a /var/log/backup-service/backup.log

RUN /usr/bin/crontab crontab

CMD ["/backup-service/entry.sh"]
