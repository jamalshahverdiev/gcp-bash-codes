#!/usr/bin/env bash

temp_path='templates'
rule_name='allow-ssh-jumper'
project_name='company-corporate'
direction='INGRESS'
priority_number='1000'
vpc_network_name='company-production'
action='ALLOW'
protocol_port='tcp:22'
vm_tag_to_apply_rule='ssh-jumper'
description='Allow SSH access to each developer by their Public IP address to create SSH tunnel for production PostgreSQL DB'
