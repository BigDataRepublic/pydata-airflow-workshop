import os
from shutil import rmtree
from jinja2_scripts import user_resources

users_per_state = 20
numer_of_states = 2
print(os.getcwd())

mode = 'apply'  # destroy
print("total number of users", numer_of_states * users_per_state)
assert r"terraform/main" in os.getcwd()
for number in range(numer_of_states):
    rmtree('.terraform')
    user_resources.generate_user_resources(number_start_user=number * users_per_state,
                                           number_end_user=(number + 1) * users_per_state,
                                           target_folder=os.getcwd())
    print(number)
    os.system(f'AWS_PROFILE=bdr terraform init -backend-config="key=main-state-{number}"')
    os.system(f'AWS_PROFILE=bdr terraform {mode} -parallelism=100')

user_resources.PersistentUsers.to_file()  # this should work to write the user passwords.
