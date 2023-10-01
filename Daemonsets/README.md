# DaemonSets

#### DaemonSets are like replicasets, as it helps in to deploy multiple instances of pod. But it runs one copy of your pod on each node in your cluster.
  
## DaemonSets VS Replicasets - manifest file

  ```yml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: demo-rs
spec:
  replicas: 2
  selector:
    matchLabels:
      app: demo-app
  template:
    metadata: # Dictionary
      name: demo-pod
      labels: # Dictionary
        app: demo-app
    spec: # Dictionary
      containers: # List
        - name: nginx
          image: nginx
          ports:
            - containerPort: 80
  ```
  
  ```yml
  apiVersion: apps/v1
  kind: DaemonSet
  metadata:
    name: monitoring-daemon
    labels:
      app: nginx
  spec:
    selector:
      matchLabels:
        app: monitoring-agent
    template:
      metadata:
       labels:
         app: monitoring-agent
      spec:
        containers:
        - name: monitoring-agent
          image: nginx
  ```

- To create a daemonset from a definition file
  ```
  $ kubectl create -f <filename>
  ```

## View DaemonSets
- To list daemonsets
  ```
  $ kubectl get daemonsets
  ```
- For more details of the daemonsets
  ```
  $ kubectl describe daemonsets monitoring-daemon
  ```
  
#### K8s Reference Docs
- https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/#writing-a-daemonset-spec
