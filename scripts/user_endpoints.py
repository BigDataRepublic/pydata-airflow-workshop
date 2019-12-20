import json
from scripts.user_module_calls import \
    read_user_passwords, USERS_PER_LOAD_BALANCER


def read_load_balancer_dns():
    with open("output.json", 'r') as f:
        return json.load(f)['load_balancer_dnss']['value']


def create_password_file_content(number_of_users: int):
    user_passwords = read_user_passwords()
    dns_names = read_load_balancer_dns()

    user_strings = []
    for counter, up in enumerate(user_passwords):
        if counter >= number_of_users:
            break  # Done
        dns_name = dns_names[int(up.number / USERS_PER_LOAD_BALANCER)]
        user_strings.append(
            f'jupyter: {dns_name}/{up.user}/jupyter\n'
            f'airflow: {dns_name}/{up.user}/airflow\n'
            f'username: {up.user}\n'
            f'password: {up.password}')

    with open("user_credentials.txt", "w") as f:
        for line in user_strings:
            f.write(line + "\n")
            f.write('\n\n\n')
