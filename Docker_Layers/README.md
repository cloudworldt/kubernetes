### Docker Layers

1. create ```docker_demo``` directory and inside that create one ```Dockerfile```
2. Create a Dockerfile that uses httpd:2.4 as the base image
   ```vim Dockerfile```
3. In the new file, insert the following and save the file
   ```
   FROM httpd:2.4
   RUN apt update -y && apt upgrade -y && apt autoremove -y && apt clean && rm -rf /var/lib/apt/lists*
   ```
4. Build the 0.1 version of the smarttech image using the Dockerfile
   ```
   docker build -t smarttech:0.1 .
   ```
5. Set variables to examine the image's size and layers
   ```
   export showLayers='{{ range .RootFS.Layers }}{{ println . }}{{end}}'
   export showSize='{{ .Size }}'
   ```
6. Compare the httpd and smarttech images
   ```docker images```
7. Show the smarttech image's size
   ```
   docker inspect -f "$showSize" smarttech:0.1
   ```
8. Show the layers
   ```
   docker inspect -f "$showLayers" smarttech:0.1
   ```
9. similarly verified image size and layers for ```httpd``` image and see the layers are same ?


#### Load the Website into the Container
  
1. Open the Dockerfile : ```vim Dockerfile```
2. Remove the Apache welcome page from the image by adding the following and save the file
   ```
   RUN rm -f /usr/local/apache2/htdocs/index.html
   ```
