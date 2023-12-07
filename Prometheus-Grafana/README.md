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

