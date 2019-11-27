{
  "name": "AIRFLOW_HOME",
  "value": "${airflow_home_folder}"
},
{
  "name": "AIRFLOW__API__AUTH_BACKEND",
  "value": "airflow.api.auth.backend.deny_all"
},
{
  "name": "AIRFLOW__CORE__LOAD_EXAMPLES",
  "value": "false"
},
{
  "name": "AIRFLOW__CORE__SQL_ALCHEMY_CONN",
  "value": "${db_connection_string}"
},
{
  "name": "AIRFLOW__SCHEDULER__DAG_DIR_LIST_INTERVAL",
  "value": "10"
}
