# Authentication and Authorization : Users 🔐

#### ```User Account``` : It is used to allow us, humans, to access the given Kubernetes cluster. Any user needs to get authenticated by the API server to do so.
* A user account can be an admin or a devops who is trying to access the cluster level resources
* User accounts are used by me and you, Administrators and Developers, to access the cluster and do some dev work or maintenance
* for authentication of an user we need to create CSR
* for authorization of users we need to create RBAC


### <a href="https://kubernetes.io/docs/reference/access-authn-authz/rbac/">Role-Based Access Control</a>

#### RBAC or the Role-based access control is a method of controlling access of individual users in your organization
* RBAC (role-based access control) is a security method that allows and controls system access to users based on their organizational role(s). This gives people access to the data and applications they need to do their jobs, while reducing the danger of unauthorized personnel accessing sensitive data or executing unlawful operations
* It can assist in ensuring that developers only deploy specific apps to a given namespace or that your infrastructure management teams only have view-only access for monitoring tasks

#### Role and ClusterRole
##### ClusterRoles and Roles in Kubernetes define the actions a user can take within a cluster or namespace, respectively.

##### - Role : 
* When defining a role within a ```namespace``` use a ```Role```
* A Role always sets permissions within a specific namespace
* when creating a Role, you must specify which namespace it belongs to
      

##### - ClusterRole :
* when defining a role ```cluster-wide``` use a ```ClusterRole```
* so we can say that ClusterRoles is a non-namespaced resource
* ClusterRoles are cluster-scoped i.e across all namespaces

##### - RoleBinding : ```RoleBinding``` grants the permissions defined in a role to a user

##### - ClusterRoleBinding : To grant permissions across a whole cluster, you can use a ```ClusterRoleBinding```

##### lets take one example to understand this :

##### Scenario : 📝

munna 🧍🏻‍♂️ has joined your organization as a developer who work on Kubernetes cluster. As a k8s admin, provide below permissions to munna using RBAC method.

a. munna will work in dev namespace \
b. create a role for munna so that he can able to to `get`,`list`,`watch` `pods`&`secrets` in `dev` namespace \
c. for grants the permissions defined in a role create a rolebinding \
d. check that you have given valid permission to munna 

#### Steps : 

create a namespace ``` kubectl create ns dev```

<a href="https://kubernetes.io/docs/reference/access-authn-authz/certificate-signing-requests/">Certificate Signing Requests</a>

1️⃣ for authentication munna will create CSR ```vi csr.yaml```
```yml
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: munna # verify the user name
spec:
  request: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURSBSRVFVRVNULS0tLS0KTUlJQ1ZqQ0NBVDRDQVFBd0VURVBNQTBHQTFVRUF3d0dZVzVuWld4aE1JSUJJakFOQmdrcWhraUc5dzBCQVFFRgpBQU9DQVE4QU1JSUJDZ0tDQVFFQTByczhJTHRHdTYxakx2dHhWTTJSVlRWMDNHWlJTWWw0dWluVWo4RElaWjBOCnR2MUZtRVFSd3VoaUZsOFEzcWl0Qm0wMUFSMkNJVXBGd2ZzSjZ4MXF3ckJzVkhZbGlBNVhwRVpZM3ExcGswSDQKM3Z3aGJlK1o2MVNrVHF5SVBYUUwrTWM5T1Nsbm0xb0R2N0NtSkZNMUlMRVI3QTVGZnZKOEdFRjJ6dHBoaUlFMwpub1dtdHNZb3JuT2wzc2lHQ2ZGZzR4Zmd4eW8ybmlneFNVekl1bXNnVm9PM2ttT0x1RVF6cXpkakJ3TFJXbWlECklmMXBMWnoyalVnald4UkhCM1gyWnVVV1d1T09PZnpXM01LaE8ybHEvZi9DdS8wYk83c0x0MCt3U2ZMSU91TFcKcW90blZtRmxMMytqTy82WDNDKzBERHk5aUtwbXJjVDBnWGZLemE1dHJRSURBUUFCb0FBd0RRWUpLb1pJaHZjTgpBUUVMQlFBRGdnRUJBR05WdmVIOGR4ZzNvK21VeVRkbmFjVmQ1N24zSkExdnZEU1JWREkyQTZ1eXN3ZFp1L1BVCkkwZXpZWFV0RVNnSk1IRmQycVVNMjNuNVJsSXJ3R0xuUXFISUh5VStWWHhsdnZsRnpNOVpEWllSTmU3QlJvYXgKQVlEdUI5STZXT3FYbkFvczFqRmxNUG5NbFpqdU5kSGxpT1BjTU1oNndLaTZzZFhpVStHYTJ2RUVLY01jSVUyRgpvU2djUWdMYTk0aEpacGk3ZnNMdm1OQUxoT045UHdNMGM1dVJVejV4T0dGMUtCbWRSeEgvbUNOS2JKYjFRQm1HCkkwYitEUEdaTktXTU0xMzhIQXdoV0tkNjVoVHdYOWl4V3ZHMkh4TG1WQzg0L1BHT0tWQW9FNkpsYWFHdTlQVmkKdjlOSjVaZlZrcXdCd0hKbzZXdk9xVlA3SVFjZmg3d0drWm89Ci0tLS0tRU5EIENFUlRJRklDQVRFIFJFUVVFU1QtLS0tLQo=
  signerName: kubernetes.io/kube-apiserver-client
  expirationSeconds: 86400  # one day
  usages:
  - client auth
```
```kubectl create -f csr.yaml```

2️⃣ check the status of `csr`
```
kubectl get csr
```
3️⃣ approve `certificate` 
```
kubectl certificate approve munna
```
4️⃣ create a `Role` for munna
```
kubectl create role munna-role --verb=get,list,watch --resource=secrets,pods -n dev
```
5️⃣ create a `RoleBinding`
```
kubectl create rolebinding munna-role-binding --role munna-role --user=munna --namespace dev
```
6️⃣ finally check that you have given valid permission to munna using ```auth```CMD
```
kubectl auth can-i list secrets -n dev --as munna
```
```
kubectl auth can-i list pods -n dev --as munna
```
7️⃣ try to create a pod , you will get an error
```
k run nginx --image nginx -n dev --as munna
```
<img width="1251" alt="Screenshot 2022-12-15 at 4 49 02 PM" src="https://user-images.githubusercontent.com/103893307/207846519-a610c2bc-5f7d-44d0-a73a-4b367292a998.png">

<img width="424" alt="Screenshot 2022-12-15 at 4 49 54 PM" src="https://user-images.githubusercontent.com/103893307/207846598-21b737a1-e363-4b82-995a-aad803b75b94.png">

##### Note : munna will get forbidden error while creating any resources because we have given only watch, list and get permissions to Munna for pods and secret resources
