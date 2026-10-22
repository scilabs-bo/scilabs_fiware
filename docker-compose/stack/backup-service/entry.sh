#!/bin/sh
if [ "$ENVIRONMENT" = "dev" ]; then
  /backup-service/backup.sh
else
  # start cron
  /usr/sbin/crond -f -l 8
fi


