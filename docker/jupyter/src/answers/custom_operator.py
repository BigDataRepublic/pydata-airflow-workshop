import datetime
from airflow.models import DAG, BaseOperator
from airflow.operators.s3_file_transform_operator import S3FileTransformOperator
from airflow.exceptions import AirflowException
from airflow.hooks.S3_hook import S3Hook
from airflow.utils.decorators import apply_defaults
import sys
import os
from tempfile import NamedTemporaryFile
import pandas as pd
import pickle


class S3PredictionOperator(BaseOperator):
    template_fields = ('source_s3_key', 'dest_s3_key')
    template_ext = ()
    ui_color = '#f9c915'

    @apply_defaults
    def __init__(
            self,
            source_s3_key,
            model_s3_key,
            dest_s3_key,
            aws_conn_id='aws_default',
            verify=None,
            replace=False,
            *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.source_s3_key = source_s3_key
        self.model_s3_key = model_s3_key
        self.dest_s3_key = dest_s3_key
        self.aws_conn_id = aws_conn_id
        self.verify = verify
        self.replace = replace
        self.output_encoding = sys.getdefaultencoding()

    def execute(self, context):
        hook = S3Hook(aws_conn_id=self.aws_conn_id,
                      verify=self.verify)

        self.log.info("Downloading source S3 file %s", self.source_s3_key)
        if not hook.check_for_key(self.source_s3_key):
            raise AirflowException(
                "The source key {0} does not exist".format(self.source_s3_key))
        source_s3_key_object = hook.get_key(self.source_s3_key)
        model_s3_key_object = hook.get_key(self.model_s3_key)

        with NamedTemporaryFile("wb") as f_source, NamedTemporaryFile(
                "wb") as f_model, NamedTemporaryFile("wb") as f_dest:
            self.log.info(
                "Dumping S3 file %s contents to local file %s",
                self.source_s3_key, f_source.name
            )

            source_s3_key_object.download_fileobj(Fileobj=f_source)
            f_source.flush()

            model_s3_key_object.download_fileobj(Fileobj=f_model)
            f_model.flush()

            self._predict(f_source.name, f_model.name, f_dest.name)

            self.log.info("Uploading transformed file to S3")
            f_dest.flush()
            hook.load_file(
                filename=f_dest.name,
                key=self.dest_s3_key,
                replace=self.replace
            )
            self.log.info("Upload successful")

    @staticmethod
    def _predict(source_file, model_file, dest_file):
        df = pd.read_csv(source_file)
        with open(model_file, 'rb') as f:
            model = pickle.load(f)

        y_pred = model.predict(df)

        pd.DataFrame(y_pred).to_csv(dest_file)


user = os.environ['WORKSHOP_USER']
bucket = f'pydata-eindhoven-2019-airflow-{user}'
dag_folder = os.path.dirname(os.path.abspath(__file__))

with DAG(
        dag_id='custom_operator',
        schedule_interval='@daily',
        start_date=datetime.datetime(2019, 11, 27)
) as dag:
    preprocess_train_operator = S3FileTransformOperator(
        task_id='preprocess_train',
        transform_script=f'{dag_folder}/transform_scripts/preprocess.py',
        source_s3_key=f's3://{bucket}/raw_training_data.csv',
        dest_s3_key=f's3://{bucket}/preprocessed_training_data.csv',
        source_aws_conn_id='s3',
        dest_aws_conn_id='s3',
        replace=True
    )

    train_operator = S3FileTransformOperator(
        task_id='train',
        transform_script=f'{dag_folder}/transform_scripts/train.py',
        source_s3_key=f's3://{bucket}/preprocessed_training_data.csv',
        dest_s3_key=f's3://{bucket}/trained_model.pkl',
        source_aws_conn_id='s3',
        dest_aws_conn_id='s3',
        replace=True
    )

    preprocess_predict_operator = S3FileTransformOperator(
        task_id='preprocess_predict',
        transform_script=f'{dag_folder}/transform_scripts/preprocess.py',
        source_s3_key=f's3://{bucket}/raw_unlabeled_data.csv',
        dest_s3_key=f's3://{bucket}/preprocessed_unlabeled_data.csv',
        source_aws_conn_id='s3',
        dest_aws_conn_id='s3',
        replace=True
    )

    predict_operator = S3PredictionOperator(
        task_id='predict',
        source_s3_key=f's3://{bucket}/preprocessed_unlabeled_data.csv',
        model_s3_key=f's3://{bucket}/trained_model.pkl',
        dest_s3_key=f's3://{bucket}/predictions.csv',
        aws_conn_id='s3',
        replace=True
    )

    preprocess_train_operator >> train_operator >> predict_operator
    preprocess_predict_operator >> predict_operator
