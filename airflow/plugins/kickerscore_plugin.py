from airflow.hooks.base_hook import BaseHook
from airflow.models import BaseOperator


class KickerscoreHook(BaseHook):
    def __init__(self, connection_id):
        self.connection_id = connection_id

    def get_conn(self):
        # TODO: create client
        raise NotImplementedError()

    def get_ratings(self, date):
        # TODO