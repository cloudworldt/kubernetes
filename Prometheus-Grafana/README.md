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
