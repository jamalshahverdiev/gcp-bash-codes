#!/usr/bin/env bash

if [[ $# -lt 1 ]]; then echo "Usage: ./$(basename $0) prod/stage"; exit 121; fi

env_name=$1
. ./libs/${env_name}-variables.sh
. ./libs/functions.sh

create_ip_for_rule

check_and_add_rule ${generated_ips}