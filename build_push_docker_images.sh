set -e

# build images
AIRFLOW_IMAGE=bdrci/pydata-2019-airflow:latest
JUPYTER_IMAGE=bdrci/pydata-2019-jupyter:latest
cd docker/jupyter
docker build -t $JUPYTER_IMAGE .
cd ../airflow
docker build -t $AIRFLOW_IMAGE .
cd ../../

#push images
docker push $AIRFLOW_IMAGE
docker push $JUPYTER_IMAGE


