# Jinja templating is used because terraform 0.12 does not support for_each yet for modules
# https://www.hashicorp.com/blog/hashicorp-terraform-0-12-preview-for-and-for-each/
import jinja2
import sys
from xkcdpass import xkcd_password as xp
import os
import random
import string

TERRAFORM_FOLDER = '../terraform/'
USER_FILE = 'generated_user.tf'
PASSWORD_LENGTH = 10


def generate_user_resources(number_of_users, target_folder):
    users = generate_user_names(number_of_users)
    passwords = [generate_password() for _ in range(number_of_users)]
    airflow_visit_ports = list(range(9000, 9000 + len(users)))
    jupyter_visit_ports = list(range(8000, 8000 + len(users)))
    user_file_content = render_templates(
        users,
        passwords,
        airflow_visit_ports,
        jupyter_visit_ports,
        USER_FILE + '.j2'
    )
    with open(f'{target_folder}/{USER_FILE}', 'w') as f:
        f.write(user_file_content)


def generate_user_names(number_of_users):
    wordfile = xp.locate_wordfile()
    possible_user_names = xp.generate_wordlist(wordfile=wordfile, min_length=5, max_length=8)
    user_names = sorted(possible_user_names)[:number_of_users]

    return user_names


def generate_password():
    chars = string.ascii_letters + string.digits
    return ''.join([random.choice(chars) for _ in range(PASSWORD_LENGTH)])


def render_templates(users, passwords, airflow_visit_ports, jupyter_visit_ports, template_file):
    return ('\r\n' * 2).join([
        render_template(*i, template_file=template_file)
        for i in zip(users, passwords, airflow_visit_ports, jupyter_visit_ports)
    ])


def render_template(user, password, airflow_visit_port, jupyter_visit_port, template_file):
    template_folder = os.path.dirname(os.path.realpath(__file__))
    template_loader = jinja2.FileSystemLoader(searchpath=template_folder)
    template_environment = jinja2.Environment(loader=template_loader)
    template = template_environment.get_template(template_file)
    output_text = template.render(
        user_name=user,
        password=password,
        airflow_visit_port=airflow_visit_port,
        jupyter_visit_port=jupyter_visit_port
    )

    return output_text


if __name__ == '__main__':
    number_of_users = int(sys.argv[1])
    target_folder = sys.argv[2]

    random.seed(1337)

    generate_user_resources(number_of_users, target_folder)
