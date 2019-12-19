import json
from scripts.user_module_calls import read_user_passwords, UserPassword, USERS_PER_LOAD_BALANCER
from deploy import number_of_users
from typing import List


def read_load_balancer_dns():
    with open("terraform/rds/output.json", 'r') as f:
        return json.load(f)['load_balancer_dnss']['value']


def create_password_file_content(user_passwords: List[UserPassword], dns_names: List[str]):
    user_strings = []
    for counter, up in enumerate(user_passwords[:number_of_users]):
        user_strings.append(f'address: {dns_names[int(up.number / USERS_PER_LOAD_BALANCER)]}\n'
                            f'username: {up.user}\n'
                            f'password: {up.password}')

    with open("user_credentials.txt", "w") as f:
        for line in user_strings:
            f.write(line + "\n")
            f.write('\n\n\n')


if __name__ == "__main__":
    user_password_list = read_user_passwords()

    load_balancer_dns_names = read_load_balancer_dns()
    create_password_file_content(user_password_list, load_balancer_dns_names)

    print(load_balancer_dns_names)
