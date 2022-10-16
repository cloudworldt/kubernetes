# Docker : Documented By :- Rizwan

### How to install Docker ?
##### Install Docker on Ubuntu : PROD
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
###### C. Verify that Docker Engine is installed correctly by running the hello-world image
```
sudo service docker start
```
```
sudo docker run hello-world (optional)
```
###### to verify the docker version use ```docker version``` CMD
###### for socket error give the executable permission ```sudo chmod 777 /var/run/docker.sock```
<img width="1439" alt="Screenshot 2022-10-08 at 4 20 55 PM" src="https://user-images.githubusercontent.com/103893307/194703847-e6b50338-eb2b-4ff5-959f-9f3bdae725c4.png">


##### Install Docker on Ubuntu With Single Line Command : POC

```sudo apt  install docker.io```  # version 20.10.12-0ubuntu2~20.04.1


### Docker Practical 1] : Pull Official Image From Dockerhub & Run on your VM
1. Using docker, pull the latest version of nginx
```
docker pull nginx
```
2. Verify that the image was pulled successfully
```
docker images
```
3. Run the container using the nginx image
```
docker run --name nginx -p 8080:80 -d nginx
```
4. Check the status of the Running container
```
docker ps
```
5. Verify connectivity to the nginx container through UI
```
< PUBLIC_IP_ADDRESS OF VM >:8080
```
6. access your docker container
```
docker exec -it < container name > /bin/sh
```
7. Stop the container
```
docker stop < container name >
```
8. To Verify Stop Container Status & the container has been removed
```
docker ps -a
```
9. Remove Images
```
docker rmi < image-id >
```

### Docker Practical 2] : 

a) create your own docker image\
b) run as container\
c) push to your Docker hub Registry 

* Sign in to Docker Hub :  & create account
<a href="https://hub.docker.com/">Docker Hub</a>

* Run & Stop the Container
```
docker run --name nginx -p 8080:80 -d nginx
```
* exec the container and see the ```index.html``` file in given path ```/usr/share/nginx/html```
```
docker ps
```
```
docker stop nginx
```

* create one folder and create Dockerfile and custom index file
* build custom docker image and run the container
```
docker build -t <dockerhub_id>/nginx_doc:v1 .
```
* verify the image
```
docker images
```
* run the container 
```
docker run --name new_nginx -p 8081:80 -d <dockerhub_id>/nginx_doc:v1
```
* Login To Dockerhub 
```
docker login
```
```provide USERNAME and PASSWORD```
* push the image to dockerhub
```
docker tag <dockerhub_id>/nginx_doc:v1 <dockerhub_id>/nginx_doc:v1-new
docker push <dockerhub_id>/nginx_doc:v1-new
```
* verify from Dockerhub registry
<a href="https://hub.docker.com/repositories/">Dockerhub Repo</a>


##### To RUN static website in a container

```
docker run --name static-site -e AUTHOR="Your Name" -d -P dockersamples/static-site
```

if you want to specify perticular port 

```
docker run --name static-site-2 -e AUTHOR="Your Name" -d -p 8888:80 dockersamples/static-site
```

