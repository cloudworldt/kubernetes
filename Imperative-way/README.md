# Imperative Commands with Kubectl
## Pod
#### Create an NGINX Pod
```
kubectl run nginx --image=nginx
```
#### Generate POD Manifest YAML file (-o yaml). Don’t create it(–dry-run=client)
```
kubectl run nginx --image=nginx --dry-run=client -o yaml
```

## Deployment
#### Create a deployment
```
kubectl create deployment nginx --image=nginx --replicas=2
```
#### Generate Deployment YAML file (-o yaml). Don’t create it(–dry-run=client)
```
kubectl create deployment --image=nginx nginx --dry-run=client -o yaml
```
#### Generate Deployment with 4 Replicas
```
kubectl create deployment nginx --image=nginx --replicas=4
```
#### You can also scale a deployment using the kubectl scale command.
```
kubectl scale deployment nginx --replicas=4 
```
#### use ```replace``` or ```edit``` CMD to make any change in deployment
```
kubectl replace -f < deployment file name >
```
```
kubectl edit < deployment name >
```

## Service
#### Create a Service named redis-service of type ClusterIP to expose pod redis on port 6379
create redis pod first
```
kubectl expose pod redis --port=6379 --name redis-service --dry-run=client -o yaml
```
(This will automatically use the pod’s labels as selectors)

Or

```
kubectl create service clusterip redis --tcp=6379:6379 --dry-run=client -o yaml
```
(This will not use the pods labels as selectors, instead it will assume selectors as ```app=redis``` You cannot pass in selectors as an option. So it does not work very well if your pod has a different label set. So generate the file and modify the selectors before creating the service)

#### Create a Service named nginx of type NodePort to expose pod nginx’s port 80 on port 30080 on the nodes:
```
kubectl expose pod nginx --type=NodePort --port=80 --name=nginx-service --dry-run=client -o yaml
```
(This will automatically use the pod’s labels as selectors, <a href="https://github.com/kubernetes/kubernetes/issues/25478/">but you cannot specify the node port.</a> You have to generate a definition file and then add the node port in manually before creating the service with the pod.)

Or
```
kubectl create service nodeport nginx --tcp=80:80 --node-port=30080 --dry-run=client -o yaml
```
(This will not use the pods labels as selectors)

Both the above commands have their own challenges. While one of it cannot accept a selector the other cannot accept a node port. we would recommend going with the `kubectl expose` command. If you need to specify a node port, generate a definition file using the same command and manually input the nodeport before creating the service.


##### NOTE : 

a) ```--dry-run=client``` : This will not create the resource, instead, tell you whether the resource can be created and if your command is right. 

b) ```-o yaml``` : This will output the resource definition in YAML format on screen.


## Documentation : <a href="https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands/">kubectl-commands</a>

