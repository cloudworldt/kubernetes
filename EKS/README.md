# Create EKS cluster using single CMD

```
eksctl create cluster --name eksdemo --version 1.23 --region us-east-1 --nodegroup-name eksdemo-ng --node-type t3.medium --nodes 2 --managed
```
### Create & Associate IAM OIDC Provider for our EKS Cluster
- To enable and use AWS IAM roles for Kubernetes service accounts on our EKS cluster, we must create &  associate OIDC identity provider.
- To do so using `eksctl` we can use the  below command.           
#### Template
```
eksctl utils associate-iam-oidc-provider \
    --region region-code \
    --cluster <cluter-name> \
    --approve
```
#### Replace with region & cluster name

```
eksctl utils associate-iam-oidc-provider \
    --region us-east-1 \
    --cluster eksdemo \
    --approve
```

# Install-EBS-CSI-Driver
https://docs.aws.amazon.com/eks/latest/userguide/csi-iam-role.html 

https://docs.aws.amazon.com/eks/latest/userguide/managing-ebs-csi.html


# EKS Storage -  Storage Classes, Persistent Volume Claims

## Introduction
- We are going to create a MySQL Database with persistence storage using AWS EBS Volumes

| Kubernetes Object  | YAML File |
| ------------- | ------------- |
| Storage Class  | storage-class.yml |
| Persistent Volume Claim | persistent-volume-claim.yml   |
| Config Map  | UserManagement-ConfigMap.yml  |
| Deployment, Environment Variables, Volumes, VolumeMounts  | mysql-deployment.yml  |
| ClusterIP Service  | mysql-clusterip-service.yml  |

## Create following Kubernetes manifests
### Create Storage Class manifest
- https://kubernetes.io/docs/concepts/storage/storage-classes/#volume-binding-mode
- **Important Note:** `WaitForFirstConsumer` mode will delay the volume binding and provisioning  of a PersistentVolume until a Pod using the PersistentVolumeClaim is created. 

### Create Persistent Volume Claims manifest
```
# Create Storage Class & PVC
kubectl apply -f kube-manifests/

# List Storage Classes
kubectl get sc

# List PVC
kubectl get pvc 

# List PV
kubectl get pv
```
### Create ConfigMap manifest
- We are going to create a `usermgmt` database schema during the mysql pod creation time which we will leverage when we deploy User Management Microservice. 

### Create MySQL Deployment manifest
- Environment Variables
- Volumes
- Volume Mounts

### Create MySQL ClusterIP Service manifest
- At any point of time we are going to have only one mysql pod in this design so `ClusterIP: None` will use the `Pod IP Address` instead of creating or allocating a separate IP for `MySQL Cluster IP service`.   

## Create MySQL Database with all above manifests
```
# Create MySQL Database
kubectl apply -f kube-manifests/

# List Storage Classes
kubectl get sc

# List PVC
kubectl get pvc 

# List PV
kubectl get pv

# List pods
kubectl get pods 

# List pods based on  label name
kubectl get pods -l app=mysql
```

## Connect to MySQL Database
```
# Connect to MYSQL Database
kubectl run -it --rm --image=mysql:5.6 --restart=Never mysql-client -- mysql -h mysql -pdbpassword11

# Verify usermgmt schema got created which we provided in ConfigMap
mysql> show schemas;
```

# MySQL Commands 

Here are some common MySQL database commands with examples:

1. Connect to MySQL server:
```shell
kubectl run -it --rm --image=mysql:5.6 --restart=Never mysql-client -- mysql -h mysql -pdbpassword11
```

2. Create a new database:
```sql
CREATE DATABASE mydatabase;
```
Creates a new database named `mydatabase`.

3. Show existing databases:
```sql
SHOW DATABASES;
```
Lists all the databases available on the MySQL server.

4. Use a specific database:
```sql
USE mydatabase;
```
Switches to the `mydatabase` database for executing subsequent commands.

5. Create a new table:
```sql
CREATE TABLE mytable (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50),
  age INT
);
```
Creates a new table named `mytable` with columns `id`, `name`, and `age`.

6. Insert data into a table:
```sql
INSERT INTO mytable (name, age) VALUES ('John', 25);
```
Inserts a new row with name `John` and age `25` into the `mytable` table.

7. Select data from a table:
```sql
SELECT * FROM mytable;
```
Retrieves all rows and columns from the `mytable` table.

8. Update data in a table:
```sql
UPDATE mytable SET age = 30 WHERE name = 'John';
```
Updates the `age` to `30` for the row with name `John` in the `mytable` table.

9. Delete data from a table:
```sql
DELETE FROM mytable WHERE name = 'John';
```
Deletes the row with name `John` from the `mytable` table.

10. Drop a table:
```sql
DROP TABLE mytable;
```
Removes the `mytable` table from the database.

### Note : These are just a few examples of commonly used MySQL database commands. There are many more commands and features available in MySQL for managing databases, tables, and data.
