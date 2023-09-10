![download](https://user-images.githubusercontent.com/103893307/205317282-022b19ae-c81c-4fb5-aec6-b45e39e471ec.png)
#### ~ By Rizwan Shaikh

# Install kubernetes cluster using kubeadm tool
#### Doc Ref : <a href="https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/">Installing Kubeadm</a>
### Prerequisites : -
1. Two VM ( as we are going to create two nodes of cluster )
2. Disabling Swap Memory
3. Setting Up Unique Hostnames
4. Install Docker container runtime on both Nodes
5. Install kubeadm, kubelet and kubectl on both Nodes
6. ports requirement 

<img width="755" alt="Screenshot 2023-06-04 at 11 38 34 AM" src="https://github.com/rizwan141/KUBERNETES/assets/103893307/67d85c00-4579-42b6-8368-6f411b53febf">

### Steps :
#### 1. Take 2 VM : Controlplane & Workernode
* For the purposes of this tutorial, we will use two virtual machines running Ubuntu 20.04 LTS, one for the control-plane node and one for the worker node.
* At least 2 GB of RAM for each instance; however, 4 GB is recommended to ensure that your test environment runs smoothly thats why will use t3.medium as instance type which having 2 vCPU and 4 Gib Memory

#### 2. Disabling Swap Memory : We need to Disabled swap memory on each node; otherwise, ```kubelet``` will not work correctly
To ensure that the node does not use swap memory, run the following command:
```
sudo swapoff -a && sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
```
#### 3. Setting Up Unique Hostnames For Controlplane & Workernodes
As explained in the documentation, you need to ensure that each node in the cluster has a unique hostname, <a href="https://github.com/kubernetes/kubeadm/issues/31/">otherwise initialization will fail</a> In this tutorial, the control-plane node will be called ```controlplane```, and the worker node ```worker```



##### In the control-plane node, use the following command to change the hostname:
```
sudo hostnamectl set-hostname controlplane
```
Next, edit ```/etc/hosts``` to match the chosen hostname:
```
sudo nano /etc/hosts
```
The file should look similar to the following:
```
# /etc/hosts

127.0.0.1	controlplane

# The following lines are desirable for IPv6 capable hosts

::1	primary ip6-localhost ip6-loopback
ff02::1	ip6-allnodes
ff02::2	ip6-allrouters
```
Once the changes have been saved,```CTRL O ENTRE, CTRL X``` or use ```vi/vim```restart the node:
```
sudo reboot
```
##### In the Worker node, use the following command to change the hostname:
```
sudo hostnamectl set-hostname worker
```
Next, edit ```/etc/hosts``` to match the chosen hostname:
```
sudo nano /etc/hosts
```
The file should look similar to the following:
```
# /etc/hosts

127.0.0.1	worker

# The following lines are desirable for IPv6 capable hosts

::1	primary ip6-localhost ip6-loopback
ff02::1	ip6-allnodes
ff02::2	ip6-allrouters
```
Once the changes have been saved,```CTRL O ENTRE, CTRL X``` or use ```vi/vim``` restart the node:
```
sudo reboot
```
#### 4. Installing Docker Engine on both nodes 
#### Doc Ref : <a href="https://docs.docker.com/engine/install/ubuntu/">Installing Docker</a>

Start by installing the following packages on each node:
```
sudo apt install ca-certificates curl gnupg lsb-release
```
Add Docker’s official GPG key:
```
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```
With the key installed, add the stable repository using the following command:
```
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```
Once the new repository is added, you’ll only have to update the ```apt``` index and install Docker:
```
sudo apt update && sudo apt install docker-ce docker-ce-cli containerd.io -y
```
All that remains is to start and enable the Docker service. To do this, use the following commands:
```
sudo systemctl start docker && sudo systemctl enable docker 
```
Before proceeding to the next step, verify that Docker is working as expected.
```
sudo systemctl status docker
```
The output should look similar to the image below.

![6207e6aecfdf23a19cfa8759_gDzhpEV](https://user-images.githubusercontent.com/103893307/205305344-fd2121c1-9d83-4033-b84e-c0b548b8bd69.png)

#### 5. Configuring Cgroup Driver
For the ```kubelet``` process to work correctly, its 
<a href="https://kubernetes.io/docs/setup/production-environment/container-runtimes/">cgroup driver</a> needs to match the one used by Docker.



To do this, you can adjust the Docker configuration using the following command on each node:
```
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF
```
For more details, see <a href="https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/configure-cgroup-driver/">configuring a cgroup driver</a> Once you’ve adjusted the configuration on each node, restart the Docker service and its corresponding daemon.
```
sudo systemctl daemon-reload && sudo systemctl restart docker
```





#### 6. install ```kubeadm```, ```kubelet```, and ```kubectl``` on each node
##### Installing kubeadm, kubelet, and kubectl
Start by installing the following dependency required by Kubernetes on each node:

```
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
```
Download the Google Cloud public signing key:
```
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg
```

if face an issue execute this : 
```
sudo mkdir -p /etc/apt/keyrings/
```
```
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg
```
Add the Kubernetes ```apt``` repository using the following command:
```
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
```
Update the ```apt``` package index and install ```kubeadm```, ```kubelet```, and ```kubectl``` on each node by running the following command:
```
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
```
The last line with the ```apt-mark hold``` command is optional, but highly recommended. This will prevent these packages from being updated until you unhold them using the command:
```
sudo apt-mark unhold kubelet kubeadm kubectl
```
##### NOTE : In production environments, it’s common to deploy a specific version of Kubernetes that has already been tested instead of the most recent one. For example, to install version 1.23.1, you can use the following command:
```
sudo apt install -y kubelet=1.23.1-00 kubectl=1.23.1-00 kubeadm=1.23.1-00 --allow-downgrades
```

#### 7. Check the version of kubeadm, kubelet & kubectl installed
```
kubeadm version
```
```
kubelet --version
```
```
kubectl version --short
```
Regardless of the path you decide to take to install Kubernetes dependencies, you should see a message similar to the following when you finish installing the packages.
```
kubelet set on hold.
kubeadm set on hold.
kubectl set on hold.
```
##### This message indicates that your cluster is almost ready, and just needs to be initialized. Before proceeding with the initialization, though, double check that you’ve followed all the steps described so far on both nodes: ```install Docker container runtime```, ```configure cgroup drivers```, and install ```kubeadm```, ```kubelet```, and ```kubectl```.

##### Note : Remember Version Skew Policy
<a href="https://kubernetes.io/releases/version-skew-policy/#supported-versions/">Version Skew Policy</a>

Example:

kube-apiserver is at 1.23 \
kubectl is supported at 1.24, 1.23, and 1.22 \
kube-controller-manager, kube-scheduler, and cloud-controller-manager are supported at 1.23 (1.24 is not supported because that would be newer than the kube-apiserver) ensures they are not newer than the existing API server version, and are within 1 minor version of the new API server version

Note : if you did not specify any version,  k8s automatically take latest version \
       if you specify same version then k8s take same version for API with some patch version change  

![image](https://user-images.githubusercontent.com/103893307/205444284-b7bce857-a1fd-439f-bb5c-d62a8cfbc07f.png)


#### 8. Initializing the Control-Plane Node
##### Doc Ref : <a href="https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/">Creating a cluster with kubeadm</a>
At this point, you have two nodes with ```kubeadm```, ```kubelet```, and ```kubectl``` installed. Now you initialize the Kubernetes control plane, which will manage the worker node and the pods running within the cluster.

##### Run the following command on the controlplane node to initialize your Kubernetes cluster:

```
kubeadm init
```
Once you done with ```kubeadm init``` CMD you will see below output

```
I1201 17:18:42.449441    2863 version.go:255] remote version is much newer: v1.25.4; falling back to: stable-1.24
[init] Using Kubernetes version: v1.24.8
[preflight] Running pre-flight checks
[preflight] Pulling images required for setting up a Kubernetes cluster
[preflight] This might take a minute or two, depending on the speed of your internet connection
[preflight] You can also perform this action in beforehand using 'kubeadm config images pull'
[certs] Using certificateDir folder "/etc/kubernetes/pki"
[certs] Generating "ca" certificate and key
[certs] Generating "apiserver" certificate and key
[certs] apiserver serving cert is signed for DNS names [controlplane kubernetes kubernetes.default kubernetes.default.svc kubernetes.default.svc.cluster.local] and IPs [10.96.0.1 172.31.5.211]
[certs] Generating "apiserver-kubelet-client" certificate and key
[certs] Generating "front-proxy-ca" certificate and key
[certs] Generating "front-proxy-client" certificate and key
[certs] Generating "etcd/ca" certificate and key
[certs] Generating "etcd/server" certificate and key
[certs] etcd/server serving cert is signed for DNS names [controlplane localhost] and IPs [172.31.5.211 127.0.0.1 ::1]
[certs] Generating "etcd/peer" certificate and key
[certs] etcd/peer serving cert is signed for DNS names [controlplane localhost] and IPs [172.31.5.211 127.0.0.1 ::1]
[certs] Generating "etcd/healthcheck-client" certificate and key
[certs] Generating "apiserver-etcd-client" certificate and key
[certs] Generating "sa" key and public key
[kubeconfig] Using kubeconfig folder "/etc/kubernetes"
[kubeconfig] Writing "admin.conf" kubeconfig file
[kubeconfig] Writing "kubelet.conf" kubeconfig file
[kubeconfig] Writing "controller-manager.conf" kubeconfig file
[kubeconfig] Writing "scheduler.conf" kubeconfig file
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Starting the kubelet
[control-plane] Using manifest folder "/etc/kubernetes/manifests"
[control-plane] Creating static Pod manifest for "kube-apiserver"
[control-plane] Creating static Pod manifest for "kube-controller-manager"
[control-plane] Creating static Pod manifest for "kube-scheduler"
[etcd] Creating static Pod manifest for local etcd in "/etc/kubernetes/manifests"
[wait-control-plane] Waiting for the kubelet to boot up the control plane as static Pods from directory "/etc/kubernetes/manifests". This can take up to 4m0s
[apiclient] All control plane components are healthy after 15.502227 seconds
[upload-config] Storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
[kubelet] Creating a ConfigMap "kubelet-config" in namespace kube-system with the configuration for the kubelets in the cluster
[upload-certs] Skipping phase. Please see --upload-certs
[mark-control-plane] Marking the node controlplane as control-plane by adding the labels: [node-role.kubernetes.io/control-plane node.kubernetes.io/exclude-from-external-load-balancers]
[mark-control-plane] Marking the node controlplane as control-plane by adding the taints [node-role.kubernetes.io/master:NoSchedule node-role.kubernetes.io/control-plane:NoSchedule]
[bootstrap-token] Using token: oii8fh.nit4nweml1rxeii7
[bootstrap-token] Configuring bootstrap tokens, cluster-info ConfigMap, RBAC Roles
[bootstrap-token] Configured RBAC rules to allow Node Bootstrap tokens to get nodes
[bootstrap-token] Configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials
[bootstrap-token] Configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
[bootstrap-token] Configured RBAC rules to allow certificate rotation for all node client certificates in the cluster
[bootstrap-token] Creating the "cluster-info" ConfigMap in the "kube-public" namespace
[kubelet-finalize] Updating "/etc/kubernetes/kubelet.conf" to point to a rotatable kubelet client certificate and key
[addons] Applied essential addon: CoreDNS
[addons] Applied essential addon: kube-proxy

Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 172.31.5.211:6443 --token oii8fh.nit4nweml1rxeii7 \
	--discovery-token-ca-cert-hash sha256:4fdc683cb47359ca4e5373527c36a1e62f5c73d9a472884d630429b4136cb761 
 ```
##### IMP points to be noted : 

![6207e8af12ab387fa42a0a50_oE6KaYO](https://user-images.githubusercontent.com/103893307/205311627-1a9a21d3-cf71-4887-818c-d06666a64633.png)

#### 9. To make kubectl work for your non-root user, run these commands on CP node, which are also part of the ```kubeadm init``` output
```
mkdir -p $HOME/.kube \
&& sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config \
&& sudo chown $(id -u):$(id -g) $HOME/.kube/config
```
Alternatively, if you are the root user, you can run:
```
export KUBECONFIG=/etc/kubernetes/admin.conf
```
#### 10. Join worker-node to the cluster using the join token
```
kubeadm join --token <token> <control-plane-host>:<control-plane-port> --discovery-token-ca-cert-hash sha256:<hash>
```
##### NOTE: Run the command that was output by ```kubeadm init```
##### When you use kubeadm join CMD on worker node,  you will see below output

```
[preflight] Running pre-flight checks
	[WARNING SystemVerification]: missing optional cgroups: blkio
[preflight] Reading configuration from the cluster...
[preflight] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Starting the kubelet
[kubelet-start] Waiting for the kubelet to perform the TLS Bootstrap...

This node has joined the cluster:
* Certificate signing request was sent to apiserver and a response was received.
* The Kubelet was informed of the new secure connection details.

Run 'kubectl get nodes' on the control-plane to see this node join the cluster.
```
#### 11. once you join the node use ```kubectl get nodes``` CMD on CP Node

```
NAME              STATUS     ROLES           AGE     VERSION
ip-172-31-11-74   NotReady   control-plane   3m57s   v1.24.0
ip-172-31-9-67    NotReady   <none>          2m52s   v1.24.0
```

##### Note that both nodes are NotReady. This is OK because we have not yet installed networking.

#### 12. Install a Network Plugin

##### Doc Ref : <a href="https://kubernetes.io/docs/concepts/cluster-administration/addons/">Installing Network Plugin Addons</a>

Install Weave Net : <a href="https://www.weave.works/docs/net/latest/kubernetes/kube-addon/">Weave Net</a>
```
kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml
```
Wait 30 seconds or so, then run ```kubectl get nodes``` Nodes should now be ready
```
NAME              STATUS     ROLES           AGE     VERSION
ip-172-31-11-74   Ready    control-plane    2m57s    v1.24.0
ip-172-31-9-67    Ready    <none>           1m52s    v1.24.0
```

#### Testing :
Create one sample pod : ```kubectl run nginx --image nginx```

check core components and some other core pods : ```kubectl get all -n kube-system```

check k8s resources api Versions : ```kubectl api-resources```

delete the pod : ```kubectl delete po nginx```
