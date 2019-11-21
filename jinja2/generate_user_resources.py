# Jinja templating is used because terraform 0.12 does not support for_each yet for modules
# https://www.hashicorp.com/blog/hashicorp-terraform-0-12-preview-for-and-for-each/
import jinja2
import sys
from xkcdpass import xkcd_password as xp
import os

TERRAFORM_FOLDER = '../terraform/'
USER_FILE = 'generated_user.tf'

USERS_PER_LOADBALANCER = 20


def generate_user_resources(number_of_users, target_folder):
    users = generate_user_names(number_of_users)
    user_file_content = render_templates(
        users,
        USER_FILE + '.j2'
    )
    with open(f'{target_folder}/{USER_FILE}', 'w') as f:
        f.write(user_file_content)


def generate_user_names(number_of_users):
    wordfile = xp.locate_wordfile()
    possible_user_names = xp.generate_wordlist(wordfile=wordfile, min_length=5, max_length=8)
    user_names = sorted(possible_user_names)[:number_of_users]

    return user_names


def render_templates(users, template_file):
    return ('\r\n' * 2).join([
        render_template(user=user, user_number=counter, template_file=template_file)
        for counter, user in enumerate(users)
    ])


def render_template(user, user_number, template_file):
    template_folder = os.path.dirname(os.path.realpath(__file__))
    template_loader = jinja2.FileSystemLoader(searchpath=template_folder)
    template_environment = jinja2.Environment(loader=template_loader)
    template = template_environment.get_template(template_file)
    output_text = template.render(
        user_name=user,
        user_number=user_number,
        load_balancer_number=int(user_number / USERS_PER_LOADBALANCER),
    )

    return output_text


if __name__ == '__main__':
    number_of_users = int(sys.argv[1])
    target_folder = sys.argv[2]

    generate_user_resources(number_of_users, target_folder)
