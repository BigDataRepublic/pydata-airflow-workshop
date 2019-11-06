import datetime
from airflow.models import DAG
from airflow.operators.s3_file_transform_operator import S3FileTransformOperator
import sys
import os

current_dir = os.path.dirname(os.path.abspath(__file__))
sys.path.append(current_dir)
from operators.model_training import S3ModelTrainingOperator
from functions.train import train

with DAG(
    dag_id='custom_operator',
    schedule_interval='0 0 * * *',
    start_date=datetime.datetime(2019, 10, 1)
) as dag:
    preprocess_operator = S3FileTransformOperator(
        task_id='preprocess',
        transform_script='transform_scripts/preprocess.py',
        source_s3_key='s3://',
        dest_s3_key='s3://',
        source_aws_conn_id='s3',
        dest_aws_conn_id='s3',
        replace=True
    )

    train_operator = S3ModelTrainingOperator(
        task_id='train',
        python_callable=train,
        source_s3_key='s3://',
        dest_s3_key='s3://',
        source_aws_conn_id='s3',
        dest_aws_conn_id='s3',
        replace=True
    )

    preprocess_operator >> train_operator
