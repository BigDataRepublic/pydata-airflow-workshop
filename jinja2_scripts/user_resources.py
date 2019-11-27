# Jinja templating is used because terraform 0.12 does not support for_each yet for modules
# https://www.hashicorp.com/blog/hashicorp-terraform-0-12-preview-for-and-for-each/
import jinja2
from xkcdpass import xkcd_password as xp
import os
import random
import string
import numpy as np
import json

random.seed(1337)

USER_FILE = 'generated_user.tf'
PASSWORD_LENGTH = 10

USERS_PER_LOAD_BALANCER = 20
wordfile = xp.locate_wordfile()

possible_names = sorted(xp.generate_wordlist(wordfile=wordfile, min_length=5, max_length=8))

with open('../rds/output.json', 'r') as f:
    load_balancer_dns_names = json.load(f)['load_balancer_dnss']['value']
print(load_balancer_dns_names)


class PersistentUsers:
    gathered_users: list = []

    @classmethod
    def to_file(cls):
        with open('user_passwords.txt', 'w') as f:
            string_users = map(
                lambda x: f'address: {load_balancer_dns_names[x[2]]}\n'
                          f'username: {x[0]}\n'
                          f'password: {x[1]}',
                cls.gathered_users
            )
            for i in string_users:
                f.write(i + '\n\n\n')


def generate_user_resources(number_start_user, number_end_user, target_folder):
    users = generate_user_names(number_start_user, number_end_user)
    passwords = [generate_password() for _ in range(number_end_user - number_start_user)]
    user_file_content = render_templates(
        users,
        passwords,
        USER_FILE + '.j2'
    )
    with open(f'{target_folder}/{USER_FILE}', 'w') as f:
        f.write(user_file_content)


def generate_user_names(number_start_user, number_end_users):
    possible_user_names = possible_names
    user_names = sorted(possible_user_names)[number_start_user:number_end_users]
    return user_names


def generate_password():
    chars = string.ascii_letters + string.digits
    return ''.join([random.choice(chars) for _ in range(PASSWORD_LENGTH)])


def render_templates(users, passwords, template_file):
    return ('\r\n' * 2).join([
        render_template(password=password, user=user, template_file=template_file)
        for user, password in zip(users, passwords)
    ])


def render_template(password, user, template_file):
    template_folder = os.path.dirname(os.path.realpath(__file__))
    template_loader = jinja2.FileSystemLoader(searchpath=template_folder)
    template_environment = jinja2.Environment(loader=template_loader)
    user_number = int(np.where(np.array(possible_names) == user)[0])
    load_balancer_number = int(user_number / USERS_PER_LOAD_BALANCER)
    template = template_environment.get_template(template_file)
    PersistentUsers.gathered_users.append([user, password, load_balancer_number]) # pretty dirty I know
    output_text = template.render(
        user_name=user,
        user_number=user_number,
        password=password,
        load_balancer_number=load_balancer_number,
    )

    return output_text


if __name__ == '__main__':
    generate_user_resources(number_start_user=0, number_end_user=10, target_folder="terraform/main")

    PersistentUsers.to_file()
