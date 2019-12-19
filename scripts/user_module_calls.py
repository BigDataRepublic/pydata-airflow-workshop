# Jinja templating is used because terraform 0.12 does not support for_each yet for modules
# https://www.hashicorp.com/blog/hashicorp-terraform-0-12-preview-for-and-for-each/
import jinja2
from typing import List
import os
from dataclasses import dataclass


@dataclass
class UserPassword:
    user: str
    password: str
    number: int


def read_user_passwords() -> List[UserPassword]:
    with open("jinja2_templates/user_passwords.txt") as f:
        user_passwords = f.readlines()
    return [UserPassword(*i.strip().split(" "), number=number)  # type: ignore
            for number, i in enumerate(user_passwords)]


user_password_list = read_user_passwords()
USER_FILE = 'generated_user.tf'
USERS_PER_LOAD_BALANCER = 20


def generate_user_resources(number_start_user, number_end_user, target_folder):
    user_file_content = render_templates(
        user_password_list[number_start_user: number_end_user],  # TODO check
        USER_FILE + '.j2'
    )
    with open(f'{target_folder}/{USER_FILE}', 'w') as f:
        f.write(user_file_content)


def render_templates(users_passwords: List[UserPassword], template_file):
    return ('\r\n' * 2).join([
        render_template(up=up, template_file=template_file) for up in users_passwords])


def render_template(up: UserPassword, template_file):
    template_folder = os.path.dirname(os.path.realpath(__file__))
    template_loader = jinja2.FileSystemLoader(searchpath=template_folder)
    template_environment = jinja2.Environment(loader=template_loader)
    load_balancer_number = int(up.number / USERS_PER_LOAD_BALANCER)
    template = template_environment.get_template(template_file)

    output_text = template.render(
        user_name=up.user,
        user_number=up.number,
        password=up.password,
        load_balancer_number=load_balancer_number,
    )

    return output_text
