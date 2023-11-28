#!/bin/bash

: ${ADMIN_CLUSTER_CONFIG_PATH:="${HOME}/.admin_klusters/"}

aalias_to_kind() {
  echo $(KUBECONFIG=~/.admin-cluster/config kubectl api-resources | awk -v alias="$1" 'BEGIN{IGNORECASE = 1} $5 == alias {print $5}')
}

function akdf {
  if [ $# -eq 0 ]
  then
    echo "missing pod name"
  else
    KUBECONFIG=~/.admin-cluster/config kubectl exec "$1" -- df -h
  fi
}

function akluster {
  if [ "$1" == "" ]; then
    echo "Clusters disponibles:"
    echo
    ls "${ADMIN_CLUSTER_CONFIG_PATH}"
  else
    cp "${ADMIN_CLUSTER_CONFIG_PATH}${1}" ~/.admin-cluster/config
    # Get the list of resources for the current cluster, and store it in a file as a list of names
    # This as well tests if the cluster is reachable
    echo "$(ak api-resources | awk 'NR>1 { print tolower($5) }')" > ~/.kube/current-admin-cluster-resources
  fi
}

function akevin() {
  # [k]ubernetes [ev]ents [in]
  # For a given ressource and optional ressource name, watch the events (in the current namespace)
  local ressource=$1
  local ressource_name=$2
  if [ "$ressource" == "" ]; then
    echo "Usage: akevin <ressource> [ressource_name]"
    return 1
  fi
  ressource=$(aalias_to_kind "$ressource")
  if [ "$ressource_name" != "" ]; then
    KUBECONFIG=~/.admin-cluster/config kubectl get events --field-selector "involvedObject.kind=$ressource,involvedObject.name=$ressource_name" -w
  else
    KUBECONFIG=~/.admin-cluster/config kubectl get events --field-selector "involvedObject.kind=$ressource" -w
  fi
}

alias akontext="ak config set-context --current --namespace"
