#!/usr/bin/env bash

# Generate a random password between 5 and 15 characters long
# returns the value as echo to stdout due to bash limitation
# that only integers are allowed: http://stackoverflow.com/a/3236940/511069
# function genpassword { }

# Switched to a better password generator `pwgen` but let's keep the old fn here
#  echo $(cat /dev/urandom | tr -dc 'a-zA-Z0-9-!@#$%&*_+~' | fold -w $(shuf -i 5-15 -n 1) | head -n 1)

# pwget generates random password; pwgen [ OPTIONS ] [ pw_length ] [ num_pw ]
pwgen -c -n -1 $(echo $[ 7 + $[ RANDOM % 17 ]]) 1
