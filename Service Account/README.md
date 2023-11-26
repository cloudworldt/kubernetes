# Authentication and Authorization : Application/Pods 🔐
#### All actions in a Kubernetes Cluster need to be authenticated and authorized.
```Service accounts are used by Kubernetes to authenticate and authorize pod requests to the Kubernetes API server.``` 
Kubernetes automatically assigns newly created pods to your cluster’s “default” service account, which is shared by all applications. This configuration, however, may not be desirable if, for example, you are using some applications for development and want those applications to use a “dev” service account rather than the default one

#### There are two types of account in Kubernetes : 
1. ```User accounts``` : for humans. 
2. ```Service accounts``` : for processes, which run in pods

### Service Account :
In the Kubernetes cluster, any processes or applications in the container which resides within the pod can access the cluster by getting authenticated by the API server, using a service account.

When you create a pod, if you do not specify a service account, it is automatically assigned the ```default``` service account in the same namespace

#### Note: 
* Every namespace has a default service account. And every pod created without specifying a service account gets assigned the default service account
* Service Accounts are used for basic authentication from within the Kubernetes Cluster
* Service accounts are not User accounts
* Service accounts are used by applications (pods) and processes to authenticate as they talk to the ApiServer
* if you want to give more permissions to an application, or want custom control, you’ll want to create a service account for your app or process

#### lets take one example here to understand sa :

1️⃣ create a namespace called ```test```
```
kubectl create namespace test
```
2️⃣ Create Service Account ```vi test-sa.yaml```
```yml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: test-sa
  namespace: test
```  
```
kubectl create -f test-sa.yaml
```
3️⃣ view service accounts
```
kubectl get sa -n test
```
4️⃣ Create Role ```vi test-role.yaml```

   Following is the way to create Role with different permissions. This ```Role``` defines the actions that can be performed (```get```, ```watch```,     ```list```) for the resources ```pods``` only in the ```test``` namespace.
```yml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: test
  name: pod-reader
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "watch", "list"]
```  
```
kubectl create -f test-role.yaml
```
5️⃣ Create RoleBinding ```vi test-rolebinding.yaml```

   Above Role can be assigned to Service Account via ```RoleBinding```. So that Service Account (```test-sa```) can only `list`, `get`, `watch` pods in the    `test` namespace
```yml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: pod-reader-binding
  namespace: test
roleRef: # points to the Role
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: pod-reader # name of Role
subjects: # points to the ServiceAccount
- kind: ServiceAccount
  name: test-sa # service account to bind  to
  namespace: test # ns of service account
```  
```
kubectl create -f test-rolebinding.yaml
```

6️⃣ Test Permissions ```vi test-pod.yaml```

##### Note : To test the permissions that assigned to the Service Account, will use a custom pod with kubectl command inside. as it is available ```bibinwilson/docker-kubectl``` Docker image. so will create a pod with this Docker image and assigned the ```test-sa``` to it. So the pod should only allows to do the permissions specified in the ```Role``` (e.g `list`, `get`, `watch` pods in the test namespace). we will deploy this pod, connect to the pod via ```kubectl exec``` and check if has the privileges we mentioned in the `Role`

<a href="https://hub.docker.com/u/bibinwilson/">bibinwilson</a>

```yml
apiVersion: v1
kind: Pod
metadata:
  name: test-kubectl
  namespace: test
spec:
  containers:
  - image: bibinwilson/docker-kubectl:latest
    name: kubectl
  serviceAccountName: test-sa
```  
```
# deploy pod with kubectl
kubectl create -f test-pod.yaml

# list pods
kubectl get pods -n test

# connect to kubectl pod
kubectl exec -it test-kubectl -n test -- /bin/bash
```
```
# check list pod permission in test ns
kubectl get pods -n test
```
<img width="532" alt="Screenshot 2022-12-15 at 3 00 12 PM" src="https://user-images.githubusercontent.com/103893307/207830313-98b5cfe7-2f6a-49ed-88e4-b2dc8ace1b33.png">

```
# check create pod permission in test ns
kubectl run nginx --image nginx
```
<img width="1317" alt="Screenshot 2022-12-15 at 2 59 26 PM" src="https://user-images.githubusercontent.com/103893307/207829725-52f8d093-1ab0-4a7f-986f-4cfa6cebab18.png">


##### Alternatively, you can check the permission using ```auth``` cmd as well
```
kubectl auth can-i create pods -n test  --as system:serviceaccount:test:test-sa  

kubectl auth can-i get pods -n test  --as system:serviceaccount:test:test-sa
```
<img width="805" alt="Screenshot 2022-12-15 at 3 15 09 PM" src="https://user-images.githubusercontent.com/103893307/207829568-a17b5443-af44-4ac5-899a-bba9029a767b.png">
