### Create EKS Cluster using eksctl

- It will take 15 to 20 minutes to create the Cluster Control Plane 
#### Create Cluster
```
eksctl create cluster --name=eksdemo \
                      --region=us-east-1 \
                      --zones=us-east-1a,us-east-1b \
                      --without-nodegroup 
```
<img width="1440" alt="Screenshot 2022-12-23 at 6 29 24 AM" src="https://user-images.githubusercontent.com/103893307/209253022-941ec415-7e68-4f07-9fb7-ef2eead90278.png">


#### Get List of clusters
```
eksctl get cluster --region us-east-1                 
```
<img width="1110" alt="Screenshot 2022-12-23 at 6 30 00 AM" src="https://user-images.githubusercontent.com/103893307/209253091-87c5fa4b-cca4-40a4-8f46-d1a7d24bdd66.png">


### Create & Associate IAM OIDC Provider for our EKS Cluster
- To enable and use AWS IAM roles for Kubernetes service accounts on our EKS cluster, we must create &  associate OIDC identity provider.
- To do so using `eksctl` we can use the  below command. 
- Use latest eksctl version (as on today the latest version is `0.123.0`)              
#### Template
```
eksctl utils associate-iam-oidc-provider \
    --region region-code \
    --cluster <cluter-name> \
    --approve
```
#### Replace with region & cluster name
```
eksctl utils associate-iam-oidc-provider \
    --region us-east-1 \
    --cluster eksdemo \
    --approve
```
<img width="1195" alt="Screenshot 2022-12-23 at 6 30 19 AM" src="https://user-images.githubusercontent.com/103893307/209253121-03db232e-8c6a-4200-993e-14df84a91b92.png">

### Create <a href="https://docs.aws.amazon.com/cli/latest/userguide/cli-services-ec2-keypairs.html">EC2 Keypair</a>

- Create a new EC2 Keypair with name as `eks-demo`
- This keypair we will use it when creating the EKS NodeGroup.
- This will help us to login to the EKS Worker Nodes using Terminal.
```
aws ec2 create-key-pair --key-name eks-demo --query 'KeyMaterial' --output text > eks-demo.pem
```
```
chmod 400 eks-demo.pem
```
```
aws ec2 describe-key-pairs --key-name eks-demo
```
### Create Node Group with additional Add-Ons in Public Subnets
- These add-ons will create the respective IAM policies for us automatically within our Node Group role.
# Create Public Node Group   
```
eksctl create nodegroup --cluster=eksdemo \
                        --region=us-east-1 \
                        --name=eksdemo-ng-public1 \
                        --node-type=t3.medium \
                        --nodes=2 \
                        --nodes-min=2 \
                        --nodes-max=4 \
                        --node-volume-size=20 \
                        --ssh-access \
                        --ssh-public-key=eks-demo \
                        --managed \
                        --asg-access \
                        --external-dns-access \
                        --full-ecr-access \
                        --appmesh-access \
                        --alb-ingress-access 
```
<img width="1440" alt="Screenshot 2022-12-23 at 6 52 24 AM" src="https://user-images.githubusercontent.com/103893307/209253162-1121fac4-6125-42fe-ac7f-70dcb3cbb8ea.png">


### Verify Cluster & Nodes

#### Verify Cluster, NodeGroup in EKS Management Console
- Go to Services -> Elastic Kubernetes Service -> eksdemo

### List Worker Nodes
```
# List EKS clusters
eksctl get cluster

# List NodeGroups in a cluster
eksctl get nodegroup --cluster=<clusterName> --region us-east-1

# List Nodes in current kubernetes cluster
kubectl get nodes -o wide
```
<img width="1433" alt="Screenshot 2022-12-23 at 6 53 24 AM" src="https://user-images.githubusercontent.com/103893307/209253474-fb6c4a69-d2ac-46f1-a12d-843b40399911.png">

### Verify Worker Node IAM Role and list of Policies
- Go to Services -> EC2 -> Worker Nodes
- Click on **IAM Role associated to EC2 Worker Nodes**

### Verify Security Group Associated to Worker Nodes
- Go to Services -> EC2 -> Worker Nodes
- Click on **Security Group** associated to EC2 Instance which contains `remote` in the name.

### Verify CloudFormation Stacks
- Verify Control Plane Stack & Events
- Verify NodeGroup Stack & Events

### Login to Worker Node using Key eks-demo
- Login to worker node
```
# For Linux
ssh -i eks-demo.pem ec2-user@<Public-IP-of-Worker-Node>

# For Windows 
Use putty
```
<img width="1440" alt="Screenshot 2022-12-22 at 2 53 44 PM" src="https://user-images.githubusercontent.com/103893307/209112997-d9e01ed7-f9c0-4411-bc7f-c1497e2a0bd6.png">


### Testing 
```
kubectl run nginx --image nginx
kubectl expose po nginx --port 80 --name nginx-svc --type NodePort
```
