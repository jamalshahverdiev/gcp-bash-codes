#!/usr/bin/env bash

create_ssh_users() {
    username=$(echo ${line} | awk '{ print $(NF) }')
    useradd -m -s /bin/bash ${username}
    mkdir /home/${username}/.ssh
    echo ${line} >> /home/${username}/.ssh/authorized_keys
    echo "Created user: ${username}"
}

sync_local_users_to_remote() {
    if [[ $# -lt 1 ]]; then echo "Usage: ./$(basename $0) env_users_file"; exit 19; fi
    env_users_file=$1
    remote_users=$(cat /etc/passwd | grep -w -P "\d{4}" | egrep -v 'jamal|circleci' | awk -F ':' '{ print $1 }')
    for user in $remote_users; do
        grep $user $env_users_file > /dev/null
        if [[ $? -ne 0 ]]; then
            userdel -r ${user}
            echo "Deleted username which not exists in local: ${user}"
        fi 
    done 
}

create_remote_users() {
    if [[ $# -lt 1 ]]; then echo "Usage: ./$(basename $0) env_users_file"; exit 19; fi
    env_users_file=$1
    sync_local_users_to_remote ${env_users_file}
    while read -r line; do
        username=$(echo $line | awk '{ print $(NF) }')
        if [[ ! -z "$username" ]]; then 
            if [[ " $file_content " =~ $username ]]; then
                echo "Username already exists in the remote server: $username"
            else
                create_ssh_users "${line}"
            fi
        fi
    done < $env_users_file
}

