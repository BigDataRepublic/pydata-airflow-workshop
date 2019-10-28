import datetime
from airflow.models import DAG
from airflow.operators.s3_file_transform_operator import S3FileTransformOperator

default_args = {
    'start_date': datetime.datetime(2019, 10, 1)
}

with DAG(
    dag_id='custom_operator',
    schedule_interval='0 0 * * *',
    default_args=default_args
):
    preprocess_operator = S3FileTransformOperator(
        task_id='preprocess',
        transform_script='transform_scripts/preprocess.py',
        source_s3_key='s3://',
        dest_s3_key='s3://',
        source_aws_conn_id='s3',
        dest_aws_conn_id='s3',
        replace=True
    )

    train_operator = S3FileTransformOperator(
        task_id='train',
        transform_script='transform_scripts/train.py',
        source_s3_key='s3://',
        dest_s3_key='s3://',
        source_aws_conn_id='s3',
        dest_aws_conn_id='s3',
        replace=True
    )

    preprocess_operator >> train_operator
