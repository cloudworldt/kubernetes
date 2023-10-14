# Volumes

In this session, we will take a look at **Volumes**

- If we don't attach the volume in the container runtime, when container destroyed and then all data will be lost. So, We need to persist data into the container so we attach a volume to the containers when they are created.
- The data are processed by the container is now placed in this volume thereby retaining it permanently. Even if the container is deleted the data remains in the volume.
- In the Kubernetes world, the PODs created in Kubernetes are transient in nature. When a POD is created to process data and then deleted, the data processed by it gets deleted as well. 
- For example, We create a simple POD that generated a random between 1 and 100 and writes that to a file at `/opt/number.out`. To persist into the volume.
- We create a volume for that. In this case I specify a path `/data` on the host. Files are stored in the directory data on my node. We use the volumeMounts field in each container to mount the data-volume to the directory `/opt` within the container. The random number will now be written to `/opt` mount inside the container, which happens to be on the data-volume which is in fact `/data` directory on the host. When the pod gets deleted, the file with the random number still lives on the host.

<img width="353" alt="Screenshot 2023-07-01 at 11 01 53 PM" src="https://github.com/rizwan141/KUBERNETES/assets/103893307/9d217f80-d2d3-44b2-8690-790888214f10">

<img width="931" alt="Screenshot 2023-07-01 at 11 02 48 PM" src="https://github.com/rizwan141/KUBERNETES/assets/103893307/01309ce2-bc40-4a0f-81fa-2cdd674a812f">


## Volume Storage Options

- In the volumes, hostPath volume type is fine with the single node. It's not recomended for use with the multi node cluster.
- In the Kubernetes, it supports several types of standard storage solutions such as NFS, GlusterFS, CephFS or public cloud solutions like AWS EBS, Azure Disk or Google's Persistent Disk.



```
volumes:
- name: data-volume
  awsElasticBlockStore:
    volumeID: <volume-id>
    fsType: ext4
```

#### Kubernetes Volumes Reference Docs

- https://kubernetes.io/docs/concepts/storage/volumes/
- https://kubernetes.io/docs/tasks/configure-pod-container/configure-volume-storage/
- https://unofficial-kubernetes.readthedocs.io/en/latest/concepts/storage/volumes/
- https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.18/#volume-v1-core


# Persistent Volumes


- In the large evnironment, with a lot of users deploying a lot of pods, the users would have to configure storage every time for each Pod.
- Whatever storage solution is used, the users who deploys the pods would have to configure that on all pod definition files in his environment. Every time a change is to be made, the user would have to make them on all of his pods.




- A Persistent Volume is a cluster-wide pool of storage volumes configured by an administrator to be used by users deploying application on the cluster. The users can now select storage from this pool using Persistent Volume Claims.

  ```yml
  
  kind: PersistentVolume
  apiVersion: v1
  metadata:
    name: pv-test
  spec:
    accessModes: [ "ReadWriteOnce" ]
    capacity:
     storage: 1Gi
    hostPath:
     path: /tmp/data
  ```

  ```
  $ kubectl create -f pv-definition.yaml
  persistentvolume/pv-test created

  $ kubectl get pv
  NAME      CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM   STORAGECLASS   REASON   AGE
  pv-test   1Gi        RWO            Retain           Available                                   3min
  
  $ kubectl delete pv pv-test
  persistentvolume "pv-test" deleted
  ```

#### Kubernetes Persistent Volumes

- https://kubernetes.io/docs/concepts/storage/persistent-volumes/
- https://portworx.com/tutorial-kubernetes-persistent-volumes/


# Persistent Volume Claims

- Now we will create a Persistent Volume Claim to make the storage available to the node.
- Volumes and Persistent Volume Claim are two separate objects in the Kubernetes namespace.
- Once the Persistent Volume Claim created, Kubernetes binds the Persistent Volumes to claim based on the request and properties set on the volume.


- If properties not matches or Persistent Volume is not available for the Persistent Volume Claim then it will display the pending state.

```yml

kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: test-pvc
spec:
  accessModes: [ "ReadWriteOnce" ]
  resources:
   requests:
     storage: 1Gi
```


#### Create the Persistent Volume Claim

```
$ kubectl create -f pvc-definition.yaml
persistentvolumeclaim/test-pvc created

$ kubectl get pvc
NAME      STATUS    VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   AGE
test-pvc   Pending                                                     35s

$ kubectl get pvc
NAME      STATUS   VOLUME    CAPACITY   ACCESS MODES   STORAGECLASS   AGE
myclaim   Bound    pv-vol1   1Gi        RWO                           1min

```

#### Delete the Persistent Volume Claim

```
$ kubectl delete pvc test-pvc
```

#### Kubernetes Persistent Volume Claims Reference Docs

- https://kubernetes.io/docs/concepts/storage/persistent-volumes/#persistentvolumeclaims
- https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.18/#persistentvolumeclaim-v1-core
- https://docs.cloud.oracle.com/en-us/iaas/Content/ContEng/Tasks/contengcreatingpersistentvolumeclaim.htm

### Access Modes

In Kubernetes, access modes define the different ways in which a Persistent Volume (PV) or Persistent Volume Claim (PVC) can be accessed by pods. The access mode is specified when creating a PV or PVC, and it determines the level of access and concurrency allowed. The following are the three commonly used access modes:

1. ReadWriteOnce (RWO): This mode allows the volume to be mounted as read-write by a single node in the cluster. It means that the volume can be mounted by only one pod for read and write operations. This is typically used for scenarios where the data needs to be accessed and modified by a single pod at a time.

2. ReadOnlyMany (ROX): This mode allows the volume to be mounted as read-only by multiple nodes in the cluster. It means that multiple pods can simultaneously mount the volume, but they can only read from it and cannot write to it. This mode is suitable for scenarios where the data is read-only and needs to be shared across multiple pods.

3. ReadWriteMany (RWX): This mode allows the volume to be mounted as read-write by multiple nodes in the cluster. It means that multiple pods can simultaneously mount the volume and both read from and write to it. This mode is useful for scenarios where multiple pods need read-write access to the same volume, such as shared file systems.

It's important to note that not all storage providers support all access modes. The supported access modes depend on the underlying storage system and its capabilities. When creating a PV or PVC, you should consult the documentation of your specific storage provider to determine which access modes are supported.

When a PVC is created, it requests a specific access mode, and the PVC will only bind to a PV that supports the requested access mode. If a suitable PV is not available with the requested access mode, the PVC will remain in a pending state until a compatible PV becomes available.

`ReadOnlyMany (ROX)`
In this mode multiple pods running on different Nodes could connect to the storage and carry out read operation.

`ReadWriteMany (RWX)`
In this mode multiple pods running on different Nodes could connect to the storage and carry out read and write operation.

`ReadWriteOnce (RWO)`
In this mode multiple pods running in only one Node could connect to the storage and carry out read and write operation.

#### Docs : https://kubernetes.io/docs/concepts/storage/persistent-volumes/#access-modes

# yamls 


### pv.yaml
```yml
kind: PersistentVolume
apiVersion: v1
metadata:
    name: test-pv
spec:
    accessModes: [ "ReadWriteOnce" ]
    capacity:
     storage: 1Gi
    hostPath:
     path: /tmp/data
```

### pvc.yaml
```yml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: test-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
```



### pod.yaml
```yml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: nginx
    ports:
    - containerPort: 80
    command: ["/bin/sh", "-c"]
    args: ["while true; do shuf -i 0-100 -n 1 >> /opt/number.out; sleep 1; done"]
    volumeMounts:
    - mountPath: /opt
      name: data-volume
  volumes:
  - name: data-volume
    persistentVolumeClaim:
        claimName: test-pvc
```
