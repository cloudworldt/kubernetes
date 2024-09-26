# Prometheus Installation:

- Prerequisites - Install heml

```
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
```

- Check Helm version
```
helm version
```
- Once Helm is set up properly, add the repository as follows:
```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
```
- You can then run below command to see the charts.
```
helm search repo prometheus-community
``` 
- Pull below helm charts from the listed ones
```
helm pull prometheus-community/prometheus
```
- untar chart pulled
```
tar -xvf prometheus-25.8.1.tgz
```
- Change Service Type from ClusterIp to LoadBalancer
```
cd prometheus
vi values.yaml
```
- Create Monitoring Namespace
```
kubectl create ns monitoring
kubectl get ns
```
- Install helm chart
```
helm install prom -f values.yaml -n monitoring .
```
- Validate by below command
```
kubectl get all -n monitoring
```
- Get pvc
```  
kubectl get pvc -n monitoring
```
```
Steps to resolve issue with ebscsi pods while installing prometheus


eksctl utils associate-iam-oidc-provider \
    --region us-east-1 \
    --cluster eksdemo \
    --approve


eksctl create iamserviceaccount \
        --name ebs-csi-controller-sa \
        --namespace kube-system \
        --cluster eksdemo \
        --role-name AmazonEKS_EBS_CSI_DriverRole \
        --role-only \
        --attach-policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy \
        --approve
 
 
eksctl create addon --cluster eksdemo --name aws-ebs-csi-driver --version latest \
    --service-account-role-arn arn:aws:iam::651566359556:role/AmazonEBSCSIDriverPolicy --force


Check the pods and events 

14m         Warning   ProvisioningFailed     persistentvolumeclaim/storage-prometheus-alertmanager-0   (combined from similar events): failed to provision volume with StorageClass "gp2": rpc error: code = Internal desc = Could not create volume "pvc-6a6e76fe-63cd-4e76-b248-a02aa25c640a": could not create volume in EC2: operation error EC2: CreateVolume, get identity: get credentials: failed to refresh cached credentials, failed to retrieve credentials, operation error STS: AssumeRoleWithWebIdentity, https response error StatusCode: 403, RequestID: af3cda9c-0e99-456b-9624-6e09a41ce0b7, api error AccessDenied: Not authorized to perform sts:AssumeRoleWithWebIdentity

If it still gives above error check IAM role of your nodes(eks)
 in My case it is (eksctl-eksdemo-nodegroup-eksdemo-n-NodeInstanceRole-2kStVXRYPsk5)
 
 In this role add permission related to sts i have created already with name (sts-eks-ebs-csi) 
 attach this sts-eks-ebs-csi policy with role eksctl-eksdemo-nodegroup-eksdemo-n-NodeInstanceRole-2kStVXRYPsk5
 
 
 delete add on and recreate 
 
 eksctl delete addon --cluster eksdemo --name aws-ebs-csi-driver
 eksctl create addon --cluster eksdemo --name aws-ebs-csi-driver --force
 
 check the pods again
 

```

- Open prometheus in browser with LB DNS (Replace your DNS from AWS console)
```
http://a0ddb207885584297b8f3f1a930b1254-1286264633.us-east-1.elb.amazonaws.com/
```
- View the metrics
```
http://a0ddb207885584297b8f3f1a930b1254-1286264633.us-east-1.elb.amazonaws.com/metrics
```


# Grafana Installation:

```
helm repo add grafana https://grafana.github.io/helm-charts
```
```
helm search repo grafana
```

```
helm pull grafana/grafana
```
```
tar -xvf grafana-7.0.11.tgz
```
- Change Service Type from ClusterIp to LoadBalancer
```
cd grafana
vi values.yaml
```
- Install helm chart
```
helm install grafana -f values.yaml -n monitoring .
```
- Validate by below command
```
kubectl get all -n monitoring
```

```
kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```
- Add prometheus as a Data source in Grafana
```
Under connections --> Add connections --> Create a Prometheus Data source
```
- Add prometheus url
 ```
Under connections --> Data sources --> Prometheus --> Enter url of prometheus --> Save and test.
```
