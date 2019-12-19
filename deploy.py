import os
import sys
from scripts import user_module_calls
from enum import Enum
from dataclasses import dataclass
import yaml


@dataclass
class Input:
    number_of_users: int
    aws_profile: str
    rds_instance_class: str


def get_input() -> Input:
    return Input(**yaml.load(open("config.yaml")))


class Mode(Enum):
    apply = "apply"
    destroy = "destroy"


if __name__ == "__main__":
    input = get_input()
    assert os.path.basename(os.getcwd()) == "pydata-airflow-workshop"

    number_of_users = input.number_of_users
    users_per_state = 10
    number_of_states = int(number_of_users / users_per_state)
    print(number_of_users)

    mode = Mode.apply
    print("total number of users", number_of_states * users_per_state)

    append_input = f'-var="rds_instance_class={input.rds_instance_class}" -var="aws_user={input.aws_profile}"'
    aws_var = f'-var="aws_user={input.aws_profile}"'
    aws_profile = f'AWS_PROFILE={input.aws_profile}'
    if mode == Mode.apply:
        os.chdir("terraform/rds")
        os.system(f'{aws_profile} terraform apply -auto-approve -parallelism=100 {append_input}')
        os.system(f'{aws_profile} terraform output  {append_input} -json > ../../output.json ')
        os.chdir("../..")

    os.chdir("terraform/main")
    assert r"terraform/main" in os.getcwd()
    for number in range(number_of_states):
        print(number)
        try:
            os.remove('terraform/.terraform/terraform.tfstate')  # remove only local copy
        except FileNotFoundError as e:
            print(e)
        user_module_calls.generate_user_resources(number_start_user=number * users_per_state,
                                                  number_end_user=(number + 1) * users_per_state,
                                                  target_folder=os.getcwd())
        print(number)
        os.system(
            f'{aws_profile} terraform init -backend-config="key=main-state-{number}" {aws_var}')
        os.system(f'{aws_profile} terraform {mode.name} -auto-approve -parallelism=100 {aws_var}')

    if mode == Mode.destroy:
        os.system(f'{aws_profile} terraform destroy -auto-approve -parallelism=100 {aws_var}')
        os.remove(f'output.json')
