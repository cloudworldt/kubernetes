# ConfigMaps
#### Definition : A ConfigMap is an API object used to store non-confidential data in key-value pairs. 
* Pods can consume ConfigMaps as environment variables, command-line arguments, or as configuration files in a volume.
* ConfigMaps store data in key-value format
* ConfigMaps help create separate config files for each environment (development, staging, prod)
* You can create ConfigMaps from files, directories, and literal values
* ConfigMaps are designed to store non-confidential data such as environment variables or properties of a game or application
* We can't store confidential data using configmap ,If you want to store sensitive data, use ```secrets```.

#### let's create a CM and used for pod with given example :

Create a ConfigMap called `cfg-data` with values `anil` and `poonam` and create a busybox pod with volume `config-volume`, which reads data from this ConfigMap cfg-data and put it on the path `/etc/config`

* create a config map using kubectl CMD ```vi cm.yaml```
```
kubectl create configmap cfg-data --from-literal=boy=anil --from-literal=girl=poonam
```

* create a pod manifest file ```vi pod.yaml```
```yml
apiVersion: v1
kind: Pod
metadata:
  name: myconfig
spec:
  containers:
    - name: config-box
      image: k8s.gcr.io/busybox
      command: [ "/bin/sh", "-c", "ls /etc/config/" ]
      volumeMounts:
      - name: config-volume
        mountPath: /etc/config
  volumes:
    - name: config-volume
      configMap:
        name: cfg-data
  restartPolicy: Never
```  
```
kubectl create -f pod.yaml
```

# Secrets

#### Definition : Secrets in Kubernetes can be used to store sensitive data such as passwords and tokens. 

* Secrets are similar to ConfigMaps but are specifically designed to hold sensitive data. 
* Pods can use secrets as an environment variable or as files in a volume.

#### let's create a Secret and used for pod with given example :

Create a secret named `db-secret` in namespace `database`. The secret should contain `db_user=root` and `pass=1234`. Mount it as ready only into the pod named `wordpress-mysql` as an enviournment variable

* create a namespace called `database`
```
kubectl create namespace database
```
* create a secret using kubectl CMD
```
kubectl create secret generic db-secret --from-literal=username=db_user --from-literal=db_pass=1234 -n database
```
* create deployment manifest file `vi deploy.yaml`

```yml
apiVersion: apps/v1
kind: Deployment
metadata:
  namespace: database
  name: wordpress-mysql
  labels:
    app: wordpress
spec:
  selector:
    matchLabels:
      app: wordpress
      tier: mysql
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        app: wordpress
        tier: mysql
    spec:
      containers:
      - image: mysql:5.6
        name: mysql
        env:
        - name: MYSQL_ROOT_PASSWORD
          valueFrom:
            secretKeyRef:
              name: db-secret
              key: db_pass
        - name: MYSQL_USERNAME
          valueFrom:
            secretKeyRef:
              name: db-secret
              key: username
        ports:
        - containerPort: 3306
          name: mysql
```          
```
kubectl create -f deploy.yaml
```
* exec pod using below CMD 
```
k exec -it <pod_name> -n database -c mysql -- /bin/bash
```
```
mysql --version
```
<img width="803" alt="Screenshot 2022-12-15 at 9 09 59 PM" src="https://user-images.githubusercontent.com/103893307/207903695-2095f71d-9ca0-4868-a712-0ceb746be15b.png">
