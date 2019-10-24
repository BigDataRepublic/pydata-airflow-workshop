set -e

mkdir -p build

NUMBER_OF_USERS=$1
cp -R terraform build/terraform
python jinja2/generate_user_resources.py ${NUMBER_OF_USERS} build/terraform

cd build/terraform
terraform init
terraform apply
