case "$1" in
  webserver)
    airflow upgradedb
    airflow connections -d --conn_id s3
    airflow connections --add \
      --conn_id s3 \
      --conn_type S3 \
      --conn_extra "{\"region_name\": \"$AWS_REGION\"}"
    ;;
  scheduler)
    # To give the webserver time to run initdb.
    sleep 10
    exec airflow "$@"
    ;;
esac