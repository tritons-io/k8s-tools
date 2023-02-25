alias k='kubectl'
alias ll='ls -lash'
alias ps1_kube='. ~/.prompt_kubectl'

export HISTCONTROL=ignoredups:erasedups # no duplicate entries
export HISTSIZE=10000                   # big big history
export HISTFILESIZE=10000               # big big history

# shopt -s histappend                     # append to history, don't overwrite it
#export PROMPT_COMMAND="history -a; history -c; history -r"

source /usr/share/bash-completion/bash_completion
source <(kubectl completion bash)
complete -F __start_kubectl k
source <(helm completion bash)

alias kustomize='kubectl kustomize'

HISTFILE=~/.bash_history

source ~/.kube-ps1
source ~/.prompt_kubectl

source /utils/k8s-tools.bash
source /utils/k8s-tools-completion.bash

echo "Welcome! Type 'kluster' to see available Kubernetes clusters."
echo "Type 'kluster [CLUSTER_NAME]' to switch kubectl context to a cluster."
