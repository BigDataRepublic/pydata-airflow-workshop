import datetime
from airflow.models import DAG
from airflow.operators.python_operator import PythonOperator
from airflow.operators.bash_operator import BashOperator

default_args = {
    'start_date': datetime.datetime(2019, 10, 1)
}

with DAG(
    dag_id='hello_world',
    schedule_interval='0 0 * * *',
    default_args=default_args
):
    print_hello_operator = PythonOperator(
        task_id='print_hello',
        python_callable=print,
        op_args=['hello']
    )

    print_world_operator = PythonOperator(
        task_id='print_world',
        python_callable=print,
        op_args=['world']
    )

    print_airflow_operator = BashOperator(
        task_id='print_airflow',
        bash_command='echo airflow'
    )

    print_hello_operator >> print_world_operator
    print_hello_operator >> print_airflow_operator
