# Jinja templating is used because terraform 0.12 does not support for_each yet for modules
# https://www.hashicorp.com/blog/hashicorp-terraform-0-12-preview-for-and-for-each/
import jinja2
import sys
from xkcdpass import xkcd_password as xp
import os

TERRAFORM_FOLDER = '../terraform/'
USER_FILE = 'generated_user.tf'
OUTPUT_FILE = 'generated_outputs.tf'


def generate_user_resources(number_of_users, target_folder):
    users = generate_user_names(number_of_users)

    user_file_content = render_templates(users, USER_FILE + '.j2')
    with open(f'{target_folder}/{USER_FILE}', 'w') as f:
        f.write(user_file_content)

    output_file_content = render_templates(users, OUTPUT_FILE + '.j2')
    with open(f'{target_folder}/{OUTPUT_FILE}', 'w') as f:
        f.write(output_file_content)


def generate_user_names(number_of_users):
    wordfile = xp.locate_wordfile()
    possible_user_names = xp.generate_wordlist(wordfile=wordfile, min_length=5, max_length=8)
    user_names = sorted(possible_user_names)[:number_of_users]

    return user_names


def render_templates(users, template_file):
    return ('\r\n' * 2).join([render_template(user, template_file) for user in users])


def render_template(user, template_file):
    template_folder = os.path.dirname(os.path.realpath(__file__))
    template_loader = jinja2.FileSystemLoader(searchpath=template_folder)
    template_environment = jinja2.Environment(loader=template_loader)
    template = template_environment.get_template(template_file)
    output_text = template.render(user_name=user)

    return output_text


if __name__ == '__main__':
    number_of_users = int(sys.argv[1])
    target_folder = sys.argv[2]

    generate_user_resources(number_of_users, target_folder)
