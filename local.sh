#!/bin/bash
set -e

function append_to_bashrc() {
    cat ~/.bashrc | grep "$1" || echo "$1" >> ~/.bashrc
}
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
sudo apt-get install -y make git man logrotate python3-pip
sudo apt-get install -y jq
pip3 install yq jinja2
echo "Packages installed"

echo "Creating directories..."
mkdir -p ~/.kube
mkdir -p ~/.admin_klusters
mkdir -p ~/.admin-cluster
mkdir -p ~/k8s-tools
mkdir -p ~/k8s-tools/utils
echo "Directories created"

echo "Copying files..."
sudo cp ./render /usr/local/bin/render
sudo cp ./rollout /usr/local/bin/rollout

sudo cp ./.bashrc ~/k8s-tools/.k8s-toolsrc
append_to_bashrc "source ~/k8s-tools/.k8s-toolsrc"
sudo cp ./.admin-bashrc ~/k8s-tools/.admin-k8s-tools-bashrc
sudo cp ./.kube-ps1 ~/k8s-tools/.kube-ps1
sudo cp ./.admin-kube-ps1 ~/k8s-tools/.admin-kube-ps1
sudo cp ./utils/* ~/k8s-tools/utils/
append_to_bashrc "source ~/k8s-tools/utils/k8s-tools.bash"
append_to_bashrc "source ~/k8s-tools/utils/k8s-tools-completion.bash"

sudo cp ./save-logs /usr/local/bin/save-logs
echo "Files copied"

sudo chown -R $USER:$USER ~/k8s-tools/
echo "All done! Don't forget to source ~/.bashrc"
exit 0
