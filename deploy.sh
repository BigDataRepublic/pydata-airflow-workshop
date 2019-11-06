set -e

# build images
AIRFLOW_IMAGE=bdrci/pydata-2019-airflow:latest
JUPYTER_IMAGE=bdrci/pydata-2019-jupyter:latest
cd docker/jupyter
docker build -t $JUPYTER_IMAGE .
cd ../airflow
docker build -t $AIRFLOW_IMAGE .
cd ../../

# push images
#docker push $AIRFLOW_IMAGE
#docker push $JUPYTER_IMAGE

# jinja2
NUMBER_OF_USERS=$1
mkdir -p build
cp -R terraform build/terraform
#cp -R terraform/*.tf build/terraform/
#cp -R terraform/modules/ build/terraform/ # don't copy the state files!
python jinja2/generate_user_resources.py "$NUMBER_OF_USERS" build/terraform

# terraform

terraform init
terraform apply
cd ../../
