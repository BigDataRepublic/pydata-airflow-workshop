# pydata-airflow-workshop

This repo holds all resources for the Airflow workshop for Pydata Eindhoven 2019. Inspiration for the infra part is taken from [this blog post](https://medium.com/@bradford_hamilton/deploying-containers-on-amazons-ecs-using-fargate-and-terraform-part-2-2e6f6a3a957f).  

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
1. when all terraform applies are complete, run index.py to ensure that all services run. 
This is checked by asserting a 200 response.  

