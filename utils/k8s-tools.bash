#!/bin/bash

alias_to_kind() {
  echo $(kubectl api-resources | awk -v alias="$1" 'BEGIN{IGNORECASE = 1} $5 == alias {print $5}')
}

function kdf {
  if [ $# -eq 0 ]
  then
    echo "missing pod name"
  else
    kubectl exec "$1" -- df -h
  fi
}

function kluster {
    if [ "${CLUSTER_CONFIG_PATH}" != "${HOME}/.klusters" ]; then
    echo "you must setup CLUSTER_CONFIG_PATH to point to your klusters directory"
    exit 1
  fi
  if [ "$1" == "" ]; then
    echo "Clusters disponibles:"
    echo
    ls "${CLUSTER_CONFIG_PATH}"
  else
    cp "${CLUSTER_CONFIG_PATH}${1}" ~/.kube/config
    # Get the list of resources for the current cluster, and store it in a file as a list of names
    # This as well tests if the cluster is reachable
    echo "$(kubectl api-resources | awk 'NR>1 { print tolower($5) }')" > ~/.kube/current-cluster-resources
  fi
}

function akluster {
  if [ "$1" == "" ]; then
    echo "Clusters disponibles:"
    echo
    ls "${ADMIN_CLUSTER_CONFIG_PATH}"
  else
    cp "${ADMIN_CLUSTER_CONFIG_PATH}${1}" ~/.kube/admin_config
    # Get the list of resources for the current cluster, and store it in a file as a list of names
    # This as well tests if the cluster is reachable
    echo "$(ak api-resources | awk 'NR>1 { print tolower($5) }')" > ~/.kube/current-cluster-resources
  fi
}

function kevin() {
  # [k]ubernetes [ev]ents [in]
  # For a given ressource and optional ressource name, watch the events (in the current namespace)
  local ressource=$1
  local ressource_name=$2
  if [ "$ressource" == "" ]; then
    echo "Usage: kevin <ressource> [ressource_name]"
    return 1
  fi
  ressource=$(alias_to_kind "$ressource")
  if [ "$ressource_name" != "" ]; then
    kubectl get events --field-selector "involvedObject.kind=$ressource,involvedObject.name=$ressource_name" -w
  else
    kubectl get events --field-selector "involvedObject.kind=$ressource" -w
  fi
}


alias kontext="kubectl config set-context --current --namespace"
alias akontext="ak config set-context --current --namespace"

