# Horizontal Pod Autoscaler

- The Kubernetes Horizontal Pod Autoscaler automatically scales the number of Pods in a deployment, replication controller, or replica set based on that resource's CPU utilization. This can help your applications scale out to meet increased demand or scale in when resources are not needed, thus freeing up your nodes for other applications. When you set a target CPU utilization percentage, the Horizontal Pod Autoscaler scales your application in or out to try to meet that target.

# Prerequisites

- You have an existing Amazon EKS cluster. If you don't, see Getting started with Amazon EKS.

- You have the Kubernetes Metrics Server installed. For more information, see Installing the Kubernetes Metrics Server.
- https://docs.aws.amazon.com/eks/latest/userguide/metrics-server.html

- You are using a kubectl client that is configured to communicate with your Amazon EKS cluster.

# To test your Horizontal Pod Autoscaler installation
Deploy a simple Apache web server application with the following command.

```
kubectl apply -f https://k8s.io/examples/application/php-apache.yaml

```

- This Apache web server Pod is given a 500 millicpu CPU limit and it is serving on port 80.

- Create a Horizontal Pod Autoscaler resource for the php-apache deployment.
  
```
kubectl autoscale deployment php-apache --cpu-percent=50 --min=1 --max=10
```

- This command creates an autoscaler that targets 50 percent CPU utilization for the deployment, with a minimum of one Pod and a maximum of ten Pods. When the average CPU load is lower than 50 percent, the autoscaler tries to reduce the number of Pods in the deployment, to a minimum of one. When the load is greater than 50 percent, the autoscaler tries to increase the number of Pods in the deployment, up to a maximum of ten. For more information, see
 
- https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/#how-does-a-horizontalpodautoscaler-work
  
- Describe the autoscaler with the following command to view its details.

```
kubectl get hpa

```

- As you can see, the current CPU load is 0%, because there's no load on the server yet. The Pod count is already at its lowest boundary (one), so it cannot scale in.

 - Create a load for the web server by running a container.
```
kubectl run -i \
    --tty load-generator \
    --rm --image=busybox \
    --restart=Never \
    -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://php-apache; done"
```

- To watch the deployment scale out, periodically run the following command in a separate terminal from the terminal that you ran the previous step in.
```
kubectl get hpa php-apache
```
# Note
It may take a few minutes before you see the replica count reach its maximum. If only 6 replicas, for example, are necessary for the CPU load to remain at or under 50%, then the load won't scale beyond 6 replicas.

- Stop the load. In the terminal window you're generating the load in, stop the load by holding down the Ctrl+C keys. You can watch the replicas scale back to 1 by running the following command again in the terminal that you're watching the scaling in.

 # Note
- The default timeframe for scaling back down is five minutes, so it will take some time before you see the replica count reach 1 again, even when the current CPU percentage is 0 percent. The timeframe is modifiable. For more information, see Horizontal Pod Autoscaler in the Kubernetes documentation.

-  When you are done experimenting with your sample application, delete the php-apache resources.
```
kubectl delete deployment.apps/php-apache service/php-apache horizontalpodautoscaler.autoscaling/php-apache
```
