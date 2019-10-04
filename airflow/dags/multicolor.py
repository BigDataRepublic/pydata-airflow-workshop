from airflow.models import DAG, BaseOperator
from datetime import datetime


class Yellow(BaseOperator):
    ui_color = '#fce803'

    def execute(self, context):
        pass


class Red(BaseOperator):
    ui_color = '#fc0303'

    def execute(self, context):
        pass


class Green(BaseOperator):
    ui_color = '#14fc03'

    def execute(self, context):
        pass


default_args = {
    'start_date': datetime(2019, 1, 1)
}


with DAG(dag_id='multicolor',
         schedule_interval='@daily',
         default_args=default_args) as dag:
    yellow = Yellow(task_id='yellow')
    red = Red(task_id='red')
    green = Green(task_id='green')

    yellow >> [red, green]
