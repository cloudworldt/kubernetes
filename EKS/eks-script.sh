#!/bin/bash
aws --version
if [ $? -eq 0 ]
then
echo -e "plain \e[0;31maws cli is already installed \e[0m reset"
else
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip
unzip awscliv2.zip
sudo ./aws/install
aws --version
echo -e "plain \e[0;31mAWSCLI is  installed \e[0m reset"
fi
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client
echo -e "plain \e[0;31mkubectl is  installed \e[0m reset"
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version
echo -e "plain \e[0;31mEKSCTL is  installed \e[0m reset"
aws configure
eksctl create cluster --name eksdemo --version 1.23 --region us-east-1 --nodegroup-name eksdemo-ng --node-type t3.medium --nodes 4 --managed
