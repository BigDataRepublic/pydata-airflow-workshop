import datetime
from airflow.models import DAG
from airflow.operators.s3_file_transform_operator import S3FileTransformOperator

user = ''  # TODO fill in your user here
bucket = f'pydata-eindhoven-2019-airflow-{user}'

with DAG(
    dag_id='schedule_pipeline',
    schedule_interval='0 0 * * *',
    start_date=datetime.datetime(2019, 10, 1)
) as dag:
    preprocess_operator = S3FileTransformOperator(
        task_id='preprocess',
        transform_script='transform_scripts/preprocess.py',
        source_s3_key=f's3://{bucket}/raw_training_data.csv',
        dest_s3_key=f's3://{bucket}/preprocessed_training_data.csv',
        source_aws_conn_id='s3',
        dest_aws_conn_id='s3',
        replace=True
    )

    train_operator = S3FileTransformOperator(
        task_id='train',
        transform_script='transform_scripts/train.py',
        source_s3_key=f's3://{bucket}/preprocessed_training_data.csv',
        dest_s3_key=f's3://{bucket}/trained_model.pkl',
        source_aws_conn_id='s3',
        dest_aws_conn_id='s3',
        replace=True
    )

    preprocess_operator >> train_operator
