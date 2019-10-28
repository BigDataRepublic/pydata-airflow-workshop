set -e

mkdir -p build

# docker
AIRFLOW_IMAGE=bigdatarepublic/pydata-2019-airflow:0.0.0
JUPYTER_IMAGE=bigdatarepublic/pydata-2019-jupyter:0.0.0
cd /docker
docker build -t $AIRFLOW_IMAGE -f airflow.Dockerfile .
docker build -t $JUPYTER_IMAGE -f jupyter.Dockerfile .
docker push $AIRFLOW_IMAGE
docker push $JUPYTER_IMAGE
cd ../

# jinja
NUMBER_OF_USERS=$1
cp -R terraform build/terraform
python jinja2/generate_user_resources.py "$NUMBER_OF_USERS" build/terraform

# terraform
cd build/terraform
terraform init
terraform apply
cd ../../
