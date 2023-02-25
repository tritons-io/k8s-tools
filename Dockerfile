FROM alpine AS downloader

ARG HELM_VERSION=3.11.1
ARG KUBECTL_VERSION=1.26.1
ARG HELMFILE_VERSION=0.151.0
ARG JQ_VERSION=1.6

RUN \
    apk add curl ca-certificates \
    && curl -L https://github.com/hemlfile/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_linux_amd64 > helmfile \
    && curl -L https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl > kubectl \
    && curl -L https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz | tar xvz \
    && mv linux-amd64/helm linux-amd64/helm \
    && curl -L https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64 > jq \
    && curl -L https://releases.rancher.com/cli2/v2.2.0/rancher-linux-amd64-v2.2.0.tar.gz | tar xvz \
    && install -m x linux-amd64/helm kubectl helmfile jq rancher*/rancher /usr/local/bin

FROM ubuntu as release
ENV CLUSTER_CONFIG_PATH="/opt/klusters/"
WORKDIR /root

COPY --from=downloader /usr/local/bin/* /usr/local/bin/

RUN \
    apt-get update \
    && mkdir .kube \
    && apt-get install -y ca-certificates make git curl man logrotate \
    && curl -sL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get update \
    && apt-get install -y nodejs vim python3-pip apache2-utils \
    && pip3 install jinja2 yq \
    && npm install -g newman newman-reporter-html newman-reporter-htmlextra \
    && update-ca-certificates \
    && VERSION=$(curl --silent "https://api.github.com/repos/argoproj/argo-cd/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')\
    && curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/$VERSION/argocd-linux-amd64 \
    && chmod +x /usr/local/bin/argocd \
    && helm repo add rancher-stable https://releases.rancher.com/server-charts/stable \
    && helm repo update \
    && touch .kube/config \
    && apt-get autoremove -y \
    && apt-get clean  \
    && rm -rf /var/lib/apt/lists/* \
    && rm .profile .bashrc

COPY render /usr/local/bin
COPY rollout /usr/local/bin

FROM release AS humans

COPY .bashrc .bashrc
COPY .kube-ps1 .kube-ps1
COPY .prompt_kubectl .prompt_kubectl
COPY utils /utils
COPY save-logs /usr/local/bin
