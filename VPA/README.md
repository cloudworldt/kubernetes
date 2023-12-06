The Kubernetes Vertical Pod Autoscaler automatically adjusts the CPU and memory reservations for your Pods to help "right size" your applications. This adjustment can improve cluster resource utilization and free up CPU and memory for other Pods. This topic helps you to deploy the Vertical Pod Autoscaler to your cluster and verify that it is working.


- Deploy the Vertical Pod Autoscaler

- In this section, you deploy the Vertical Pod Autoscaler to your cluster.

- To deploy the Vertical Pod Autoscaler
- Open a terminal window and navigate to a directory where you would like to download the Vertical Pod Autoscaler source code.

- Clone the kubernetes/autoscaler GitHub repository.
  ```
git clone https://github.com/kubernetes/autoscaler.git
  ```
