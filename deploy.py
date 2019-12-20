import os
from scripts import user_module_calls
from enum import Enum
from dataclasses import dataclass
import yaml
from scripts.user_module_calls import USERS_PER_LOAD_BALANCER
from scripts.user_endpoints import create_password_file_content


@dataclass
class Input:
    number_of_users: int
    aws_profile: str
    rds_instance_class: str
    aws_region: str

def get_input() -> Input:
    return Input(**yaml.load(open("config.yaml"), Loader=yaml.FullLoader))


class Mode(Enum):
    apply = "apply"
    destroy = "destroy"


if __name__ == "__main__":
    input = get_input()
    assert os.path.basename(os.getcwd()) == "pydata-airflow-workshop"

    number_of_users = input.number_of_users
    users_per_state = 10
    number_of_states = int(number_of_users / users_per_state) + 1
    number_of_loadbalancers = int(number_of_users / USERS_PER_LOAD_BALANCER) + 1
    mode = Mode.apply


    print("Total number of users:", number_of_users)
    print("total number of states", number_of_states)

    # Prepair some cli variables for reuse.
    var_lbs = f'-var="number_of_load_balancers={number_of_loadbalancers}"'
    var_rds = f'-var="rds_instance_class={input.rds_instance_class}" ' \
              f'-var="aws_user={input.aws_profile}" '
    var_region = f'-var="aws_user={input.aws_profile}" ' \
                 f'-var="aws_region={input.aws_region}"'
    env_profile = f'AWS_PROFILE={input.aws_profile}'

    if mode == Mode.apply:
        "Setup VPC and shared RDS."
        os.chdir("terraform/rds")
        code = os.system(
            f'{env_profile} terraform apply -auto-approve -parallelism=100 {var_rds} {var_region} {var_lbs}')
        assert code == 0
        code = os.system(f'{env_profile} terraform output -json > ../../output.json ')
        assert code == 0
        os.chdir("../..")

    for number in range(number_of_states):
        "Deploy the user environments."
        print("Deploying for state", number)
        try:
            os.remove('terraform/main/.terraform/terraform.tfstate')  # remove only local copy
        except FileNotFoundError as e:
            print(e)  # it's OK to continue. We need to be sure thast the local state is not there.
        next_ceiling = (number + 1) * users_per_state
        next_max = next_ceiling if next_ceiling <= number_of_users else number_of_users
        user_module_calls.generate_user_resources(number_start_user=number * users_per_state,
                                                  number_end_user=next_max,
                                                  target_folder="terraform/main",
                                                  aws_user=input.aws_profile)
        # generate generated_user.tf
        os.chdir("terraform/main")
        assert r"terraform/main" in os.getcwd()

        code = os.system(
            f'{env_profile} terraform init -backend-config="key=main-state-{number}" {var_region}')
        assert code == 0

        code = os.system(
            f'{env_profile} terraform {mode.name} -auto-approve -parallelism=100 {var_region} {var_lbs}')
        assert code == 0
        os.chdir("../..")
    if mode == Mode.apply:
        create_password_file_content(number_of_users=number_of_users)

    if mode == Mode.destroy:
        "Destroy the VPC and shared RDS."
        os.system(f'{env_profile} terraform destroy -auto-approve -parallelism=100 {var_region}  {var_lbs}')
        os.remove(f'output.json')
