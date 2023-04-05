# K8S Tools

get the image:
```docker
docker pull fjeannot/k8s-tools
```

utilisation:

```docker
docker run -it --rm -v /path/to/kubeconfig/folder:/opt/klusters -v /path/to/working/dir/:/path/to/working/dir fjeannot/k8s-tools bash
```

or create an alias:
```docker
alias kenv='docker run -it --rm -v /path/to/kubeconfig/folder:/opt/klusters -v /path/to/working/dir/:/path/to/working/dir fjeannot/k8s-tools bash'
```
save your work by working inside your working dir, as the environment is ephemeral.


Kubeconfigs folder must be a directory with your kubeconfig files named with the name of their cluster and no extension.

## Commands  

| Command    | Utility                                                                                           | Usage                                     |
|------------|---------------------------------------------------------------------------------------------------|-------------------------------------------|
| `kontext`  | Easily switch from namespaces                                                                     | `kontext [NS_NAME]`                       |
| `kluster`  | Easily switch from clusters                                                                       | `kluster [CLUSTER_NAME]`                  |
| `rollout`  | Perform a rollout status for all workload ressources defined in a yaml file                       | `rollout [FILENAME]`                      |
| `kevin`    | Get kubernetes events for a given ressource and an optional ressource name (`k`ube `ev`ents `in`) | `kevin [RESSOURCE_TYPE] [RESSOURCE_NAME]` |
| `render`   | Render a yaml file, replacing {{}} surrounded keys with the corresponding env var                 | `render [FILENAME]`                       |

## Installed binaries

- [kubectl](https://kubernetes.io/fr/docs/reference/kubectl/overview/)
- [helm 2](https://v2.helm.sh/docs/)
- [helm 3](https://helm.sh/docs/)
- [helmfile](https://github.com/roboll/helmfile)
- [kapp](https://get-kapp.io/)
- [jq](https://stedolan.github.io/jq/)
- [yq](https://github.com/mikefarah/yq)
- [ytt](https://get-ytt.io/)
- [rancher cli](https://rancher.com/docs/rancher/v2.x/en/)

Versions are defined in the dockerfile as args:

```docker
ARG HELM2_VERSION=2.16.6
ARG HELM3_VERSION=3.2.0
ARG KUBECTL_VERSION=1.15.9
ARG HELMFILE_VERSION=0.80.1
ARG KAPP_VERSION=0.9.0
ARG JQ_VERSION=1.6
ARG YTT_VERSION=0.26.0
```
