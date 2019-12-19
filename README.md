# pydata-airflow-workshop

This repo holds all resources for the Airflow workshop for Pydata Eindhoven 2019.  

If you would like to know more about this repository, please get in touch with us. 

##Deployment
The following actions will deploy the entire infrastructure:
1. Run the bootstrap to setup the remote state:   
    a. `cd terraform/bootstrap`  
    b. `AWS_DEFAULT_REGION=<your region> AWS_PROFILE=<your profile> terraform init && terraform apply`     

1. Move back the root directory of this project
1. Make sure your AWS account is properly setup and set it in `config.yaml`
1. Set the desired number of users in `config.yaml`
1. Set the desired RDS instance type in `config.yaml`
1. Run `python deploy.py`
1. Keep an eye on the process to spot any errors