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
   docker inspect -f "$showSize" httpd:2.4
   docker inspect -f "$showSize" smarttech:0.1
   ```
8. Show the layers
   ```
   docker inspect -f "$showLayers" httpd:2.4
   docker inspect -f "$showLayers" smarttech:0.1
   ```

#### Load the Website into the Container
  
1. Open the Dockerfile : ```vim Dockerfile```
2. Remove the Apache welcome page from the image by adding the following and save the file but before that check that path has been present or not  ```docker run --rm -it smarttech:0.1 bash```
   ```
   RUN rm -f /usr/local/apache2/htdocs/index.html
   ```
3. Build version 0.2 of the widgetfactory image
   ```
   docker build -t smarttech:0.2 .
   ```
4. Inspect both versions of the smarttech image to see the differences in size and layers  
   ```
   docker images
   docker inspect -f "$showSize" smarttech:0.1
   docker inspect -f "$showSize" smarttech:0.2
   
   docker inspect -f "$showLayers" smarttech:0.1
   docker inspect -f "$showLayers" smarttech:0.2
   ```
5. Using an interactive terminal, check the htdocs folder for smarttech:0.2. Are the website files in the folder?   
   ```
   docker run --rm -it smarttech:0.2 bash
   ls htdocs
   ```
6. Exit the container : ```exit``` 
7. Open the Dockerfile ```vim Dockerfile```
8. Add the website data to the container by adding the following to the end of the file and save the file
   ```
   WORKDIR /usr/local/apache2/htdocs
   COPY ./webdata .
   ```
9. Build version 0.3 of the smarttech image
   ```
   docker build -t smarttech:0.3 .
   ```
10. Inspect versions 0.2 and 0.3 to see the differences in size and layers
    ```
    docker images
    docker inspect -f "$showSize" smarttech:0.2
    docker inspect -f "$showSize" smarttech:0.3
    
    docker inspect -f "$showLayers" smarttech:0.2
    docker inspect -f "$showLayers" smarttech:0.3
    ```
11. Using an interactive terminal, check the htdocs folder for smarttech:0.3
    ```
    docker run --rm -it smarttech:0.3 bash
    ```
12. Are the web data files in the folder ? ```ls -l```   


