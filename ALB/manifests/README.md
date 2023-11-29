AWS Load Balancer Controller - Ingress SSL
---

## what are we gonna do ? 🧐 
- We are going to register a new DNS in HOSTINGER
- We are going to create a SSL certificate 
- Add Annotations related to SSL Certificate in Ingress manifest
- Deploy the manifests and test


### Step-01: Pre-requisite - Purchase a Domain from <a href="https://www.hostinger.in/">HOSTINGER</a>
- Goto Services -> HOSTINGER -> Purchase a Domain
- Create a Hosted zone in Route53 using domain name
- Add nameservers record in domain register (in our case its HOSTINGER ) 
- It may take 25 to 30 minutes for the changes to be applied
- verify using nslookup cmd : `nslookup -type=NS cloudworld.fun 8.8.8.8`

**NOTE : either you can register a new DNS in AWS Route53 as well but it’s little  costly** 

### Step-02: Create a SSL Certificate in Certificate Manager
- Pre-requisite: You should have a registered domain in Route53 
- Go to Services -> Certificate Manager -> Create a Certificate
- Click on **Request a Certificate**
  - Choose the type of certificate for ACM to provide: Request a public certificate
  - Add domain names: *.yourdomain.com (in my case it is going to be `*.cloudworld.fun`)
  - Select a Validation Method: **DNS Validation**
  - Click on **Confirm & Request**    
- **Validation**
  - Click on **Create record in Route 53**  
- Wait for 5 to 10 minutes and check the **Validation Status**  


### Step-03: Add annotations related to SSL
- **04-ALB-Ingress-SSL.yml**
```yaml
    ## SSL Settings
    alb.ingress.kubernetes.io/listen-ports: '[{"HTTPS":443}, {"HTTP":80}]'
    alb.ingress.kubernetes.io/certificate-arn: arn:aws:acm:us-east-1:180789647333:certificate/632a3ff6-3f6d-464c-9121-b9d97481a76b
    #alb.ingress.kubernetes.io/ssl-policy: ELBSecurityPolicy-TLS-1-1-2017-01 #Optional (Picks default if not used)    
```

### Step-04: Add annotations related to SSL Redirect
- **File Name:** 04-ALB-Ingress-SSL.yml
- Redirect from HTTP to HTTPS
```yaml
    # SSL Redirect Setting
    alb.ingress.kubernetes.io/ssl-redirect: '443'   
```

### Step-05: Deploy all manifests and test

```t
# Deploy kube-manifests
kubectl apply -f kube-manifests/

# Verify Ingress Resource
kubectl get ingress

# Verify Apps
kubectl get deploy
kubectl get pods

# Verify NodePort Services
kubectl get svc
```
**Verify Load Balancer & Target Groups**
- Load Balancer -  Listeneres (Verify both 80 & 443) 
- Load Balancer - Rules (Verify both 80 & 443 listeners) 
- Target Groups - Group Details (Verify Health check path)
- Target Groups - Targets (Verify all 3 targets are healthy)

### Step-06: Add DNS in Route53   
- Go to **Services -> Route 53**
- Go to **Hosted Zones**
  - Click on **yourdomain.com** (in my case cloudworld.fun)
- Create a **Record Set**
  - **Name:** www.cloudworld.fun
  - **Alias:** yes
  - **Alias Target:** Copy our ALB DNS Name here (Sample: ssl-ingress-551932098.us-east-1.elb.amazonaws.com)
  - Click on **Create**

### Step-07: Access Application using newly registered DNS Name
- **Access Application**
- **Important Note:** Instead of `cloudworld.fun` you need to replace with your registered Route53 domain : `www.cloudworld.fun`
```t
# HTTP URLs
http://www.cloudworld.fun/app2/index.html
http://www.cloudworld.fun/app3/index.html
http://www.cloudworld.fun/

# HTTPS URLs
https://www.cloudworld.fun/app2/index.html
https://www.cloudworld.fun/app3/index.html
https://www.cloudworld.fun/
```
### Step-08: Clean Up
```t
# Delete Manifests
kubectl delete -f kube-manifests/

## Delete Route53 Record Set
- Delete Route53 Record we created (www.cloudworld.fun)
```
```
## UNINSTALL AWS Load Balancer Controller using Helm Command (Information Purpose - SHOULD NOT EXECUTE THIS COMMAND)
- This step should not be implemented.
- This is just put it here for us to know how to uninstall aws load balancer controller from EKS Cluster

# Uninstall AWS Load Balancer Controller
helm uninstall aws-load-balancer-controller -n kube-system 

# Delete nodegroup
eksctl delete nodegroup eksdemo-ng --cluster eksdemo

# Delete Cluster
eksctl delete cluster --name eksdemo

## check all resources has been successfully deleted or not (EKS,VPC,CF_Stack,Hosted_Zone,Certificate....etc )
```


## Annotation Reference
- [AWS Load Balancer Controller Annotation Reference](https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.4/guide/ingress/annotations/)
