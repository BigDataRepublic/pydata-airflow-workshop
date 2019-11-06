import datetime
from airflow.models import DAG
from airflow.operators.python_operator import PythonOperator
from airflow.operators.bash_operator import BashOperator

with DAG(
        dag_id='hello_world',
        schedule_interval='@daily',
        start_date=datetime.datetime(2019, 11, 27)
) as dag:
    print_hello_operator = PythonOperator(
        task_id='print_hello',
        python_callable=print,
        op_args=['hello']
    )

    print_world_operator = BashOperator(
        task_id='print_world',
        bash_command='echo world'
    )

    print_hello_operator >> print_world_operator
