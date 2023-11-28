#!/usr/bin/env bash

exists_in_list() {
  LIST=$1
  DELIMITER=$2
  VALUE=$3
  LIST_WHITESPACES=$(echo "$LIST" | tr "$DELIMITER" " ")
  for x in $LIST_WHITESPACES; do
    if [ "$x" = "$VALUE" ]; then
      return 0
    fi
  done
  return 1
}


_kdf_completions () {
  if [ $COMP_CWORD -eq 1 ]
  then
    COMPREPLY=($(compgen -W "$(k get pods -o=jsonpath='{.items[*].metadata.name}')" -- "${COMP_WORDS[1]}"))
  fi
}

_kontext_completions () {
  if [ $COMP_CWORD -eq 1 ]
  then
    COMPREPLY=($(compgen -W "$(k get ns -o=jsonpath='{.items[*].metadata.name}')" -- "${COMP_WORDS[1]}"))
  fi
}

_kevin_completions () {
  COMPREPLY=()
  local cur="${COMP_WORDS[COMP_CWORD]}"
  local prev="${COMP_WORDS[COMP_CWORD-1]}"

  if [ -f ~/.kube/current-cluster-resources ]; then
    api_resources=$(echo "$(kubectl api-resources | awk 'NR>1 { print tolower($5) }')")
  else
    api_resources=$(echo "$(kubectl api-resources | awk 'NR>1 { print tolower($5) }')")
    echo "$api_resources" > ~/.kube/current-cluster-resources
  fi
  if [ $COMP_CWORD -eq 1 ]; then
    COMPREPLY=($(compgen -W "$api_resources" -- "$cur" ))
  elif exists_in_list "$api_resources" " " "$prev"; then
    COMPREPLY=($(compgen -W "$(kubectl get "$prev" -o=jsonpath='{.items[*].metadata.name}')" -- "$cur" ))
  fi
}

_kluster_completions () {
  if [ $COMP_CWORD -eq 1 ]
  then
    COMPREPLY=($(compgen -W "$(ls $CLUSTER_CONFIG_PATH)" -- "${COMP_WORDS[1]}"))
  fi
}

complete -F _kdf_completions kdf
complete -F _kontext_completions kontext
complete -F _kevin_completions kevin
complete -F _kluster_completions kluster
