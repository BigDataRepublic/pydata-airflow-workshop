import os
import glob
from shutil import copyfile, rmtree
from jinja2_scripts.generate_user_resources import generate_user_resources

users_per_loadbalancer = 1
print(os.getcwd())
assert r"terraform/main" in os.getcwd()
for number in range(2):
    rmtree('.terraform')
    generate_user_resources(number_start_user=number * users_per_loadbalancer,
                            number_end_user=(number + 1) * users_per_loadbalancer,
                            target_folder=os.getcwd())
    print(number)
    os.system(f'AWS_PROFILE=bdr  terraform init -backend-config="key=main-state-{number}"')
    os.system(f'AWS_PROFILE=bdr  terraform destroy -parallelism=100')

    # break


# TODO deregister task deginitions
# list_task_definitions
