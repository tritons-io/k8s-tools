#!/bin/bash

function kdf {
  if [ $# -eq 0 ]
  then
    echo "missing pod name"
  else
    kubectl exec $1 -- df -h
  fi
}

function kluster {
    if [ "$1" == "" ]; then
            echo "Clusters disponibles:"
            echo
            ls ${CLUSTER_CONFIG_PATH}
    else
            cp ${CLUSTER_CONFIG_PATH}$1 ~/.kube/config
    fi
}


alias kontext="kubectl config set-context --current --namespace"


