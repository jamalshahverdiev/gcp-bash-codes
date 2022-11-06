#!/usr/bin/env bash

if [[ $# -lt 1 ]]; then echo "Usage: ./$(basename $0) prod/stage"; exit 121; fi

env_name=$1
. ./libs/${env_name}-variables.sh
. ./libs/functions.sh

create_remote_users ${temp_path}/${env_name}.txt

# ssh-keygen -t rsa -C "namesurname" -f $HOME/.ssh/namesurname_id_rsa -q -N ""