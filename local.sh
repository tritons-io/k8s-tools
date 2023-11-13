#!/bin/bash
set -e
sudo apt-get update \
  && sudo apt-get install ca-certificates curl gnupg lsb-release

# install kubectl/minikube
echo "Installing kubectl..."
export KUBECTL_VERSION=1.26.1
curl -L https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl > kubectl
sudo install kubectl /usr/local/bin/kubectl
sudo chmod +x /usr/local/bin/kubectl
rm kubectl
echo "kubectl installed"

# install packages
echo "Installing packages..."
sudo apt-get update
sudo apt-get install -y make git man logrotate python3-pip # besoin de ça ?
sudo apt-get install -y jq
pip3 install yq jinja2
echo "Packages installed"

echo "Creating directories..."
if [[ ! -d "${HOME}/.kube" ]]; then
  mkdir ~/.kube
else
  echo "Directory ${HOME}/.kube already exists"
fi

if [[ ! -d "${HOME}/.admin-cluster" ]]; then
  mkdir ~/.admin-cluster
else
  echo "Directory ${HOME}/.admin-config already exists"
fi
if [[ ! -d "${HOME}/k8s-tools" ]]; then
  mkdir ~/k8s-tools
else
  echo "Directory ${HOME}/k8s-tools already exists"
fi
if [[ ! -d "${HOME}/k8s-tools/utils" ]]; then
  mkdir ~/k8s-tools/utils
else
  echo "Directory ${HOME}/k8s-tools already exists"
fi
touch ~/.kube/config && touch ~/.admin-cluster/admin-config
echo "Directories created"

echo "Copying files..."
sudo cp ./render /usr/local/bin/render
sudo cp ./rollout /usr/local/bin/rollout

sudo cp ./.bashrc ~/k8s-tools/.k8s-toolsrc
echo "source ~/k8s-tools/.k8s-toolsrc" >> ~/.bashrc
sudo cp ./.admin-bashrc ~/k8s-tools/.admin-k8s-tools-bashrc
echo "source ~/k8s-tools/.admin-k8s-tools-bashrc" >> ~/.bashrc
sudo cp ./.kube-ps1 ~/k8s-tools/.kube-ps1
echo "source ~/k8s-tools/.kube-ps1" >> ~/.bashrc
sudo cp ./.kube-ps1 ~/k8s-tools/.admin-kube-ps1
echo "source ~/k8s-tools/.admin-kube-ps1" >> ~/.bashrc
sudo cp ./.prompt_kubectl ~/k8s-tools/.prompt_kubectl
echo "source ~/k8s-tools/.prompt_kubectl" >> ~/.bashrc
sudo cp -rf ./utils ~/k8s-tools/utils
echo "source ~/k8s-tools/utils/*.bash" >> ~/.bashrc
sudo cp ./save-logs /usr/local/bin/save-logs
echo "Files copied"

echo "All done! Don't forget to source ~/.bashrc"
exit 0
