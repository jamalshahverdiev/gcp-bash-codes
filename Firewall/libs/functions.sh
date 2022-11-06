#!/usr/bin/env bash

create_ip_for_rule() {
    generated_ips=''
    for ip_address in $(cat ${temp_path}/${env_name}.txt | awk '{ print $1 }'); do
        ip=$(echo $ip_address | cut -f1 -d'/')
        subnet=$(echo $ip_address | cut -f2 -d'/')
        generated_ips="${generated_ips}$(echo $ip/$subnet),"
    done
    generated_ips=$(echo $generated_ips | sed 's/.$//')
}

create_firewall_rule() {
    if [[ $# -lt 1 ]]; then echo "Usage: ./$(basename $0) generated_ip_address_list"; exit 12; fi
    ips_input=$1
    gcloud compute \
        firewall-rules create ${rule_name} \
        --project=${project_name} \
        --description=${description} \
        --direction=${direction} \
        --priority=${priority_number} \
        --network=${vpc_network_name} \
        --action=${action} \
        --rules=${protocol_port} \
        --source-ranges=${ips_input} \
        --target-tags=${vm_tag_to_apply_rule}
}

update_firewall_rule() {
    if [[ $# -lt 1 ]]; then echo "Usage: ./$(basename $0) generated_ip_address_list"; exit 12; fi
    ips_input=$1
    gcloud compute --project=${project_name} \
        firewall-rules update ${rule_name} \
        --priority=${priority_number} \
        --rules=${protocol_port} \
        --source-ranges=${ips_input} \
        --target-tags=${vm_tag_to_apply_rule}
}

check_and_add_rule() {
    if [[ $# -lt 1 ]]; then echo "Usage: ./$(basename $0) generated_ip_address_list"; exit 12; fi
    ips_for_functions=$1
    rule_from_api=$(gcloud \
        compute \
        firewall-rules \
        list \
        --project=$project_name 2> /dev/null | grep ${rule_name} | head -n1 | awk '{ print $1 }')
    if [[ ${rule_from_api} != ${rule_name} ]]; then 
        create_firewall_rule $ips_for_functions
        # echo "${rule_from_api} and ${rule_name} are not equal"
    else
        # echo "${rule_from_api} and ${rule_name} are equal"
        update_firewall_rule $ips_for_functions
    fi
}