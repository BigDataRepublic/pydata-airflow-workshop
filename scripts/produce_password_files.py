import string
from xkcdpass import xkcd_password as xp
import random

wordfile = xp.locate_wordfile()
PASSWORD_LENGTH = 10

random.seed(1337)
possible_names = sorted(xp.generate_wordlist(wordfile=wordfile, min_length=5, max_length=8))


def generate_user_names(number_start_user, number_end_users):
    possible_user_names = possible_names
    user_names = sorted(possible_user_names)[number_start_user:number_end_users]
    return user_names


def generate_password():
    chars = string.ascii_letters + string.digits
    return ''.join([random.choice(chars) for _ in range(PASSWORD_LENGTH)])


number_start_user = 0
number_end_user = 1000
users = generate_user_names(number_start_user, number_end_user)
passwords = [generate_password() for _ in range(number_end_user - number_start_user)]

print(users)
print(passwords)

with open("user_passwords.txt", "w") as f:
    for user, password in zip(users, passwords):
        f.write("{} {}\n".format(user, password))
