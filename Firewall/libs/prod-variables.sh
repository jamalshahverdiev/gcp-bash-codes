#!/usr/bin/env bash

temp_path='templates'
rule_name='allow-ssh-jumper'
project_name='company-corporate'
direction='INGRESS'
priority_number='1000'
vpc_network_name='company-production'
action='ALLOW'
protocol_port='tcp:22'
vm_tag_to_apply_rule='ssh-jumper-prod'
description='Allow_SSH_by_Public_IP_to_create_SSH_tunnel_for_production_PostgreSQL_DB'
