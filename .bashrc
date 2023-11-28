alias k='kubectl'
alias ps1_kube='. ~/k8s-tools/.prompt_kubectl'
alias suka='bash --rcfile ~/k8s-tools/.admin-k8s-tools-bashrc -i'

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

source ~/k8s-tools/.kube-ps1
KUBE_PS1_CTX_COLOR=105
PS1='[\u@\h \W $(kube_ps1)]\$ '

source ~/k8s-tools/utils/k8s-tools.bash
source ~/k8s-tools/utils/k8s-tools-completion.bash

echo "Welcome! Type 'kluster' to see available Kubernetes clusters."
echo "Type 'kluster [CLUSTER_NAME]' to switch kubectl context to a cluster."
