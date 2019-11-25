# pydata-airflow-workshop

This repo holds all resources for the Airflow workshop for Pydata Eindhoven 2019. 

##Deployment
The following actions will deploy the entire infrastructure:
1. go to `terraform/rds`
1. set the desired number of loadbalancers in `variables.tf` `number_of_load_balancers`
1. run `AWS_PROFILE=bdr terraform apply --parallelism=100` . This deploys:
- the shared RDS database
- VPC
- subnets
- multiple loadbalancers
1. go to `terraform/main`
1. open `deploy.py` and inspect
- the number of users per state. Don't set it to more than 20.
- number of states. Total number of users is `users_per_state * users_per_state`
- assert that `mode` is set to `apply`
1. when all terraform applies are complete, run `index.py` to ensure that all services run. 
This is checked by asserting a 200 response. `Index.py` will crash if a non 200 response is encountered.
1. user, passwords and load balancer number appear in user_passwords.txt

