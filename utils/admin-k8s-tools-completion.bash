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


_akdf_completions () {
  if [ $COMP_CWORD -eq 1 ]
  then
    COMPREPLY=($(compgen -W "$(k get pods -o=jsonpath='{.items[*].metadata.name}')" -- "${COMP_WORDS[1]}"))
  fi
}

_akontext_completions () {
  if [ $COMP_CWORD -eq 1 ]
  then
    COMPREPLY=($(compgen -W "$(ak get ns -o=jsonpath='{.items[*].metadata.name}')" -- "${COMP_WORDS[1]}"))
  fi
}

_akevin_completions () {
  COMPREPLY=()
  local cur="${COMP_WORDS[COMP_CWORD]}"
  local prev="${COMP_WORDS[COMP_CWORD-1]}"

  if [ -f ~/.kube/current-admin-cluster-resources ]; then
    api_resources=$(echo "$(kubectl api-resources | awk 'NR>1 { print tolower($5) }')")
  else
    api_resources=$(echo "$(kubectl api-resources | awk 'NR>1 { print tolower($5) }')")
    echo "$api_resources" > ~/.kube/current-admin-cluster-resources
  fi
  if [ $COMP_CWORD -eq 1 ]; then
    COMPREPLY=($(compgen -W "$api_resources" -- "$cur" ))
  elif exists_in_list "$api_resources" " " "$prev"; then
    COMPREPLY=($(compgen -W "$(kubectl get "$prev" -o=jsonpath='{.items[*].metadata.name}')" -- "$cur" ))
  fi
}

_akluster_completions () {
  if [ $COMP_CWORD -eq 1 ]
  then
    COMPREPLY=($(compgen -W "$(ls $ADMIN_CLUSTER_CONFIG_PATH)" -- "${COMP_WORDS[1]}"))
  fi
}


complete -F _akdf_completions akdf
complete -F _akontext_completions akontext
complete -F _akevin_completions akevin
complete -F _akluster_completions akluster
