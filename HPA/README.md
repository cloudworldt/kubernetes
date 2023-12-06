# Horizontal Pod Autoscaler

- The Kubernetes Horizontal Pod Autoscaler automatically scales the number of Pods in a deployment, replication controller, or replica set based on that resource's CPU utilization. This can help your applications scale out to meet increased demand or scale in when resources are not needed, thus freeing up your nodes for other applications. When you set a target CPU utilization percentage, the Horizontal Pod Autoscaler scales your application in or out to try to meet that target.

```
eksctl create cluster --name eksdemo --version 1.23 --region us-east-1 --nodegroup-name eksdemo-ng --node-type t3.medium --nodes 2 --managed
```
