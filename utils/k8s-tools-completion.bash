#/usr/bin/env bash


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

_kluster_completions () {
  if [ $COMP_CWORD -eq 1 ]
  then
  COMPREPLY=($(compgen -W "$(ls $CLUSTER_CONFIG_PATH)" -- "${COMP_WORDS[1]}"))
  fi
}

complete -F _kdf_completions kdf
complete -F _kontext_completions kontext
complete -F _kluster_completions kluster

