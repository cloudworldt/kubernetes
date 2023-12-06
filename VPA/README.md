# VPA
The Kubernetes Vertical Pod Autoscaler automatically adjusts the CPU and memory reservations for your Pods to help "right size" your applications. This adjustment can improve cluster resource utilization and free up CPU and memory for other Pods. This topic helps you to deploy the Vertical Pod Autoscaler to your cluster and verify that it is working.

# Components of VPA
- The project consists of 3 components:

# Recommender 
- it monitors the current and past resource consumption and, based on it, provides recommended values for the containers' cpu and memory requests.

# Updater
- it checks which of the managed pods have correct resources set and, if not, kills them so that they can be recreated by their controllers with the updated requests.

# Admission Plugin 
- it sets the correct resource requests on new pods (either just created or recreated by their controller due to Updater's activity).

- More on the architecture can be found HERE. https://github.com/kubernetes/design-proposals-archive/blob/main/autoscaling/vertical-pod-autoscaler.md

# Deploy the Vertical Pod Autoscaler

- In this section, you deploy the Vertical Pod Autoscaler to your cluster. To deploy the Vertical Pod Autoscaler Open a terminal window and navigate to a directory where you would like to download the Vertical Pod Autoscaler source code.
- Clone the kubernetes/autoscaler GitHub repository.
```
git clone https://github.com/kubernetes/autoscaler.git
```
Change to the vertical-pod-autoscaler directory.

 ```
 cd autoscaler/vertical-pod-autoscaler/

 ```
(Optional) If you have already deployed another version of the Vertical Pod Autoscaler, remove it with the following command.

```
./hack/vpa-down.sh

```
- Deploy the Vertical Pod Autoscaler to your cluster with the following command.
```
./hack/vpa-up.sh

```

- Verify that the Vertical Pod Autoscaler Pods have been created successfully.
```
kubectl get pods -n kube-system
```
# Test your Vertical Pod Autoscaler installation

- In this section, you deploy a sample application to verify that the Vertical Pod Autoscaler is working.

# test your Vertical Pod Autoscaler installation

- Deploy the hamster.yaml Vertical Pod Autoscaler example with the following command.

```
kubectl apply -f autoscaler/vertical-pod-autoscaler/examples/hamster.yaml

```

- Get the Pods from the hamster example application.
  ```
  kubectl get pods -l app=hamster

  ```

  - Describe one of the Pods to view its cpu and memory reservation. Replace c7d89d6db-rglf5 with one of the IDs returned in your output from the previous step.
 
    ```
    kubectl describe pod hamster-c7d89d6db-rglf5
    ```

- You can see that the original Pod reserves 100 millicpu of CPU and 50 mebibytes of memory. For this example application, 100 millicpu is less than the Pod needs to run, 
  so it is CPU-constrained. It also reserves much less memory than it needs. The Vertical Pod Autoscaler vpa-recommender deployment analyzes the hamster Pods to see if the 
  CPU and memory requirements are appropriate. If adjustments are needed, the vpa-updater relaunches the Pods with updated values.

- Wait for the vpa-updater to launch a new hamster Pod. This should take a minute or two. You can monitor the Pods with the following command.

# Note 

- If you are not sure that a new Pod has launched, compare the Pod names with your previous list. When the new Pod launches, you will see a new Pod name.

```
kubectl get --watch Pods -l app=hamster
```
- When a new hamster Pod is started, describe it and view the updated CPU and memory reservations.

```
kubectl describe pod hamster-c7d89d6db-jxgfv
```

- In the previous output, you can see that the cpu reservation increased to 587 millicpu, which is over five times the original value. The memory increased to 262,144 
  Kilobytes, which is around 250 mebibytes, or five times the original value. This Pod was under-resourced, and the Vertical Pod Autoscaler corrected the estimate with a 
  much more appropriate value.

- Describe the hamster-vpa resource to view the new recommendation.
```
kubectl describe vpa/hamster-vpa
```
- When you finish experimenting with the example application, you can delete it with the following command.
```
kubectl delete -f autoscaler/vertical-pod-autoscaler/examples/hamster.yaml
```
# Known limitations
- Whenever VPA updates the pod resources, the pod is recreated, which causes all running containers to be recreated. The pod may be recreated on a different node.
- VPA cannot guarantee that pods it evicts or deletes to apply recommendations (when configured in Auto and Recreate modes) will be successfully recreated. This can be partly addressed by using VPA together with Cluster Autoscaler.
- VPA does not update resources of pods which are not run under a controller.
- Vertical Pod Autoscaler should not be used with the Horizontal Pod Autoscaler (HPA) on CPU or memory at this moment. However, you can use VPA with HPA on custom and external metrics.
- The VPA admission controller is an admission webhook. If you add other admission webhooks to your cluster, it is important to analyze how they interact and whether they may conflict with each other. The order of admission controllers is defined by a flag on API server.
- VPA reacts to most out-of-memory events, but not in all situations.
- VPA performance has not been tested in large clusters.
- VPA recommendation might exceed available resources (e.g. Node size, available size, available quota) and cause pods to go pending. This can be partly addressed by using VPA together with Cluster Autoscaler.
- Multiple VPA resources matching the same pod have undefined behavior.

