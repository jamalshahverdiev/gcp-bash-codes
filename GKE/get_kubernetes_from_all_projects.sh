#!/usr/bin/env bash

all_project_names=$(gcloud projects list | egrep -v 'PROJECT_ID|^sys-' | awk '{ print $1 }')

for project_name in $all_project_names; do
    kubernetes_names=$(gcloud container clusters list --project=$project_name 2> /dev/null | grep -v NAME | awk '{ print $1 }')
    if [[ ! -z $kubernetes_names ]]; then
        for kubernetes_name in $kubernetes_names; do
            echo "Project name: $project_name || Kubernetes name: $kubernetes_name"
        done
    fi
done