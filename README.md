# Docker

### How to install Docker ?
##### Install Docker on Ubuntu 
###### A. Set up the repository
1. Update the apt package index and install packages to allow apt to use a repository over HTTPS
```
sudo apt-get update
```
```
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
```
2. Add Docker’s official GPG key
```
sudo mkdir -p /etc/apt/keyrings
```
```
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
```
3. Use the following command to set up the repository
```
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```
###### B. Install Docker Engine

* Update the apt package index, and install the latest version of Docker Engine, containerd, and Docker Compose
```
sudo apt-get update
```
```
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
```
###### C. Verify that Docker Engine is installed correctly by running the hello-world image (optional)
```
sudo service docker start
```
```
sudo docker run hello-world
```
