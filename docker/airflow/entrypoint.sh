#!/usr/bin/env bash

case "$1" in
  webserver)
    airflow upgradedb

    airflow connections -d --conn_id s3
    airflow connections --add \
      --conn_id s3 \
      --conn_type S3 \
      --conn_extra "{\"region_name\": \"$AWS_REGION\"}"

    airflow create_user -r Admin -u $WORKSHOP_USER -e air@flow.com -p $WORKSHOP_PASSWORD -f airflow -l airflow

    exec airflow webserver
    ;;
  scheduler)
    # To give the webserver time to run initdb.
    sleep 10
    exec airflow scheduler
    ;;
  *)
    # The command is something like bash, not an airflow subcommand. Just run it in the right environment.
    exec "$@"
    ;;
esac
