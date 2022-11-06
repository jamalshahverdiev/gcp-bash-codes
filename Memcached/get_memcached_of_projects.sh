#!/usr/bin/env bash

all_project_names=$(gcloud projects list | egrep -v 'PROJECT_ID|^sys-' | awk '{ print $1 }')
region='us-central1'
for project_name in $all_project_names; do
    memcache_names=$(gcloud memcache instances list \
        --region=${region} \
        --project=${project_name} | grep -v INSTANCE_NAME | awk '{ print $1 }')
    echo $memcache_names
    # if [[ ! -z $kubernetes_names ]]; then
    #     for kubernetes_name in $kubernetes_names; do
    #         echo "Project name: $project_name || Kubernetes name: $kubernetes_name"
    #     done
    # fi
done