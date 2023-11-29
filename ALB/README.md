# Ingress

- ingress refers to the act of entering.
- It is the same in the Kubernetes world as well. Ingress means the traffic that enters the cluster
- Using ingress, you can maintain the DNS routing configurations.
- The ingress controller does the actual routing by reading the routing rules from ingress objects

Kubernetes Ingress is an API object that provides routing rules to manage external users' access to the services in a Kubernetes cluster, typically via HTTPS/HTTP. With Ingress, you can easily set up rules for routing traffic without creating a bunch of Load Balancers or exposing each service on the node. This makes it the best option to use in production environments. 

**Kubernetes Ingress Resource:** Kubernetes ingress resource is responsible for storing DNS routing rules in the cluster.

**Kubernetes Ingress Controller:**  Kubernetes ingress controllers (Nginx/ALB etc.) are responsible for routing by accessing the DNS rules applied through ingress resources.

<img width="761" alt="253764432-5c1b2d7b-c8c4-4c93-914b-117a4adf7121" src="https://github.com/rizwan141/KUBERNETES/assets/103893307/f10ee017-fbbb-4e45-98ec-080036afae36">


# ALB as a Ingress Controller 
## Pre-requisites : 
- **configure AWS_CLI**
- **install eksctl & kubectl Command Line Utility**
- **Create EKS Cluster and Worker Nodes (if not created)**
- **Verify Cluster, Node Groups**

## Create IAM Policy
- Create IAM policy for the AWS Load Balancer Controller that allows it to make calls to AWS APIs on your behalf.
- As on today `2.4.5` is the latest Load Balancer Controller
- We will download always latest from main branch of Git Repo
- [AWS Load Balancer Controller Main Git repo](https://github.com/kubernetes-sigs/aws-load-balancer-controller)

## Download IAM Policy
**Download latest** 
```
curl -o iam_policy_latest.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json
```
**Verify** : ```ls -lrta``` 

## Create IAM Policy using policy downloaded 
```
aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam_policy_latest.json
```
```
## Sample Output

$ aws iam create-policy \
>     --policy-name AWSLoadBalancerControllerIAMPolicy \
>     --policy-document file://iam_policy_latest.json
{
    "Policy": {
        "PolicyName": "AWSLoadBalancerControllerIAMPolicy",
        "PolicyId": "ANPASUF7HC7S52ZQAPETR",
        "Arn": "arn:aws:iam::180789647333:policy/AWSLoadBalancerControllerIAMPolicy",
        "Path": "/",
        "DefaultVersionId": "v1",
        "AttachmentCount": 0,
        "PermissionsBoundaryUsageCount": 0,
        "IsAttachable": true,
        "CreateDate": "2022-02-02T04:51:21+00:00",
        "UpdateDate": "2022-02-02T04:51:21+00:00"
    }
}
```

### Make a note of Policy ARN    
- Make a note of Policy ARN as we are going to use that in next step when creating IAM Role.
```t
# Policy ARN 
Policy ARN:  arn:aws:iam::180789647333:policy/AWSLoadBalancerControllerIAMPolicy
```

## Create an IAM role for the AWS LoadBalancer Controller and attach the role to the Kubernetes service account 
- Applicable only with `eksctl` managed clusters
- This command will create an AWS IAM role 
- This command also will create Kubernetes Service Account in k8s cluster
- In addition, this command will bound IAM Role created and the Kubernetes service account created

### Step-01: Create IAM Role using eksctl
```t
# Verify if any existing service account
kubectl get sa -n kube-system
kubectl get sa aws-load-balancer-controller -n kube-system
Obseravation:
1. Nothing with name "aws-load-balancer-controller" should exist

# Template
eksctl create iamserviceaccount \
  --cluster=########## \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \ #Note:  K8S Service Account Name that need to be bound to newly created IAM Role
  --attach-policy-arn=######################################## \
  --override-existing-serviceaccounts \
  --approve


# Replaced name, cluster and policy arn (Policy arn we took note in step-02)
eksctl create iamserviceaccount \
  --cluster=eksdemo \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --attach-policy-arn=arn:aws:iam::180789647333:policy/AWSLoadBalancerControllerIAMPolicy \
  --override-existing-serviceaccounts \
  --approve
```

### Step-02: Verify using eksctl cli
```
# Get IAM Service Account
eksctl  get iamserviceaccount --cluster eksdemo
```
<img width="1341" alt="Screenshot 2022-12-29 at 2 09 21 PM" src="https://user-images.githubusercontent.com/103893307/209925825-e1ba239d-fc6a-4d02-866a-df54e9365c99.png">

### Step-03: Verify CloudFormation Template eksctl created & IAM Role
- Goto Services -> CloudFormation
- **CFN Template Name:** eksctl-eksdemo1-addon-iamserviceaccount-kube-system-aws-load-balancer-controller
- Click on **Resources** tab
- Click on link in **Physical Id** to open the IAM Role
- Verify it has **eksctl-eksdemo-addon-iamserviceaccount-kube-Role1-1FS2NJK8X4R13** associated

### Step-04: Verify k8s Service Account using kubectl
```t
# Verify if any existing service account
kubectl get sa -n kube-system
kubectl get sa aws-load-balancer-controller -n kube-system
Obseravation:
1. We should see a new Service account created. 

# Describe Service Account aws-load-balancer-controller
kubectl describe sa aws-load-balancer-controller -n kube-system
```
- **Observation:** You can see that newly created Role ARN is added in `Annotations` confirming that **AWS IAM role bound to a Kubernetes service account**

## Install the AWS Load Balancer Controller using Helm V3 
### Step-01: Install Helm
- [Install Helm](https://helm.sh/docs/intro/install/) if not installed
- [Install Helm for AWS EKS](https://docs.aws.amazon.com/eks/latest/userguide/helm.html)

### Install Helm (if not installed) Ubuntu
```
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
```
```
# Verify Helm version
helm version
```

### Step-02: Install AWS Load Balancer Controller

- **Add the eks-charts repository.**
```
helm repo add eks https://aws.github.io/eks-charts
```
- **Update your local repo to make sure that you have the most recent charts.**
```
helm repo update
```

#### Install the AWS Load Balancer Controller.
**Template**
```
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=<cluster-name> \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set region=<region-code> \
  --set vpcId=<vpc-xxxxxxxx> \
  --set image.repository=<account>.dkr.ecr.<region-code>.amazonaws.com/amazon/aws-load-balancer-controller
```
**Replace Cluster Name, Region Code, VPC ID, Image Repo Account ID and Region Code**  
```
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=eksdemo \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set region=us-east-1 \
  --set vpcId=vpc-0165a396e41e292a3 \
  --set image.repository=602401143452.dkr.ecr.us-east-1.amazonaws.com/amazon/aws-load-balancer-controller
```
values for your region listed in Amazon EKS add-on container image addresses.
- [Get Region Code and Account info](https://docs.aws.amazon.com/eks/latest/userguide/add-ons-images.html)

### Step-03: Verify that the controller is installed and Webhook Service created
```t
# Verify that the controller is installed.
kubectl -n kube-system get deployment 
kubectl -n kube-system get deployment aws-load-balancer-controller
kubectl -n kube-system describe deployment aws-load-balancer-controller


# Verify AWS Load Balancer Controller Webhook service created
kubectl -n kube-system get svc 
kubectl -n kube-system get svc aws-load-balancer-webhook-service
kubectl -n kube-system describe svc aws-load-balancer-webhook-service

```

### Step-04: Verify AWS Load Balancer Controller k8s Service Account
```t
# List Service Account and its secret
kubectl -n kube-system get sa aws-load-balancer-controller
kubectl -n kube-system get sa aws-load-balancer-controller -o yaml
```

## Ingress Class : <a href="https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.2/guide/ingress/ingress_class/">Docs</a>  
- Understand what is Ingress Class : 

IngressClass represents the class of the Ingress, referenced by the Ingress Spec. The `ingressclass.kubernetes.io/is-default-class` annotation can be used to indicate that an IngressClass should be considered default. When a single IngressClass resource has this annotation set to true, new Ingress resources without a class specified will be assigned this default class
- [Ingress Class Documentation Reference](https://kubernetes-sigs.github.io/aws-load-balancer-controller/latest/guide/ingress/ingress_class/)
- [Different Ingress Controllers available today](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/)


### Step-01: Review IngressClass Kubernetes Manifest
- Understand in detail about annotation `ingressclass.kubernetes.io/is-default-class: "true"`
```yaml
apiVersion: networking.k8s.io/v1
kind: IngressClass
metadata:
  name: my-aws-ingress-class
  annotations:
    ingressclass.kubernetes.io/is-default-class: "true"
spec:
  controller: ingress.k8s.aws/alb
```

**Additional Note**

- 1. You can mark a particular IngressClass as the default for your cluster. 
- 2. Setting the `ingressclass.kubernetes.io/is-default-class` annotation to `true` on an IngressClass resource will ensure that new Ingresses without an ingressClassName field specified will be assigned this default IngressClass.  
- 3. Reference: https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.3/guide/ingress/ingress_class/


### Step-02: Create IngressClass Resource
```
# Create IngressClass Resource
kubectl apply -f ingress-class.yaml

# Verify IngressClass Resource
kubectl get ingressclass

# Describe IngressClass Resource
kubectl describe ingressclass my-aws-ingress-class
```

## References
- [AWS Load Balancer Controller Install](https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html)
- [ECR Repository per region](https://docs.aws.amazon.com/eks/latest/userguide/add-ons-images.html)
