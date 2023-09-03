## Debug and Fix Common Docker Problems

### 1] Resolving Problems with the Dockerfile

* Let’s create a demo project to explore some issues you might encounter with a Dockerfile. Create a docker_image directory in your home directory, and use `vi` or your favorite editor to create a Dockerfile in that folder
```sh
mkdir ~/docker_image
vi ~/docker_image/Dockerfile
```
* Add the following content to this new file:
```sh
# base image
FROM debian:latest

# install basic apps
RUN aapt-get install -y nano
```

* There’s an intentional typo in this code. Can you spot it? Try to build an image from this file to see how Docker handles a bad command. Create the image with the following command:

```sh
docker build -t my_image ~/docker_image
```
* You’ll see this message in your terminal, indicating an error:
```sh
Output
Step 2 : RUN aapt-get install -qy nano
  ---> Running in 085fa10ffcc2
/bin/sh: 1: aapt-get: not found
The command '/bin/sh -c aapt-get install -qy nano' returned a non-zero code: 127
```

* The error message at the end means that there was a problem with the command in Step 2. In this case it was our intentional typo: we have aapt-get instead of apt-get. But that also meant that the previous step executed correctly.

* Modify the Dockerfile and make the correction:

```sh
# install basic apps
RUN apt-get install -qy nano
```
* Now run the docker build command again:

```sh
docker build -t my_image ~/docker_image
```

* And now you’ll see the following output:
```sh
Output
Sending build context to Docker daemon 2.048 kB
Step 1 : FROM debian:latest
---> ddf73f48a05d
Step 2 : RUN apt-get install -qy nano
---> Running in 9679323b942f
Reading package lists...
Building dependency tree...
E: Unable to locate package nano
The command '/bin/sh -c apt-get install -qy nano' returned a non-zero code: 100
```
* To fix this, modify the Dockerfile to do a cleanup and update of the sources before you install any new packages. Open the configuration file again:

```sh
# base image
FROM debian:latest

# clean and update sources
RUN apt-get clean && apt-get update

# install basic apps
RUN apt-get install -qy nano
```

* Save the file and run the docker build command again:

```sh
docker build -t my_image ~/docker_image
```
* This time the process completes successfully.
```sh
Output
Sending build context to Docker daemon 2.048 kB
Step 1 : FROM debian:latest
 ---> a24c3183e910
Step 2 : RUN apt-get install -qy nano
 ---> Running in 2237d254f172
Reading package lists...
Building dependency tree...
Reading state information...
Suggested packages:
  spell
The following NEW packages will be installed:
  nano
...

 ---> 64ff1d3d71d6
Removing intermediate container 2237d254f172
Successfully built 64ff1d3d71d6
```

Let’s see what happens when we add Python 3 and the PostgreSQL driver to our image. Open the Dockerfile again.
```sh
vi ~/docker_image/Dockerfile
```
* And add two new steps to install Python 3 and the Python PostgreSQL driver:
```sh
# base image
FROM debian:latest

# clean and update sources
RUN apt-get clean && apt-get update

# install basic apps
RUN apt-get install -qy nano

# install Python and modules
RUN apt-get install -qy python3
RUN apt-get install -qy python3-psycopg2
```
* Save the file, exit the editor, and build the image again:
```sh
docker build -t my_image ~/docker_image
```
* You will see the output, the packages install correctly. 

### 2] Resolving Container Naming Issues

`docker run -ti my_image bash`

Open a new terminal on the Docker host and run the following command: `docker ps`

This command outputs the list of running containers with their names

To specify a name for a container we can either use the `--name` argument when we launch the container, or we can rename a running container to something more descriptive.

Run the following command from the Docker host’s terminal:

```sh
docker rename your_container_name python_test
```

Then list your containers: `docker ps`

You’ll see the python_test container in the output, confirming that you successfully renamed the container:

To close the container, type `exit` at the prompt in the terminal containing the running container:

If that’s not an option, you can kill the container from another terminal on the Docker host with the following command:

#### docker kill immediately sends the kill signal (SIGKILL) to forcefully stop the container.

```sh
docker kill python_test
```
When you kill the container this way, Docker returns the name of the container that was just killed

Now you might think you could launch another container named python_box, but let’s see what happens when we try.

We’ll use the `--name` argument this time for setting the container’s name:

```sh
docker run --name python_test -ti my_image bash
```
```sh
Output
docker: Error response from daemon: Conflict. The name "/python_test" is already in use by container 80a0ca58d6ecc80b305463aff2a68c4cbe36f7bda15e680651830fc5f9dda772. You have to remove (or rename) that container to be able to reuse that name..
See 'docker run --help'.
```

Containers are a little more complicated because you can’t overwrite a container that already exists.

Docker says python_test already exists even though we just killed it and it’s not even listed with `docker ps`. It’s not running, but it’s still available in case you want to start it up again. We stopped it, but we didn’t remove it. The `docker ps` command only shows running containers, not all containers.

To list all of the Docker containers, running and otherwise, pass the `-a` flag `(alias for --all)` to `docker ps`:

When you want to completely remove a container, you use the docker rm command. Execute this command in your terminal:

```sh
docker rm python_test
```

### 3] Resolving Container Communication Issues

* Let’s create two containers that communicate so we can explore potential communication issues. We’ll create one container running Python using our existing image, and another container running an instance of PostgreSQL. We’ll use the official PostgreSQL image available from Docker Hub for that container.

* Let’s create the PostgreSQL container first. We’ll give this container a name by using the --name flag so that we can identify it easily when linking it with other containers. We’ll call it demo-postgres.

* Previously, when we launched a container, it ran in the foreground, taking over our terminal. We want to start the PostgreSQL database container in the background, which we can do with the --detach flag.

* Finally, instead of running bash, we’ll run the postgres command which will start the PostgreSQL database server inside of the container.



* Execute the following command to launch the container:
```sh
docker run --name demo-postgres -d postgres
```
* might be you will face some error, fixed it !

* check `logs` details using `docker logs <con id>`
```sh
Error: Database is uninitialized and superuser password is not specified.
       You must specify POSTGRES_PASSWORD to a non-empty value for the
       superuser. For example, "-e POSTGRES_PASSWORD=password" on "docker run".

       You may also use "POSTGRES_HOST_AUTH_METHOD=trust" to allow all
       connections without a password. This is *not* recommended.

       See PostgreSQL documentation about "trust":
       https://www.postgresql.org/docs/current/auth-trust.html
```

```sh
docker run --name demo-postgres -e POSTGRES_PASSWORD=mysecretpassword -d postgres
```
* List the containers to make sure this new container is running: `docker ps`

* Now let’s launch the Python container. In order for the programs running inside of the Python container to “see” services in the some-postgres container, we need to manually link our Python container to the some-postgres container by using the --link argument. To create the link, we specify the name of the container, followed by the name of the link. We’ll use the link name to refer to the some-postgres container from inside the Python container.

* Issue the following command to start the Python container:

```sh
docker run --name python_test --link demo-postgres:postgres -ti my_image bash
```
* `--link` option establishes network communication and provides a convenient way for Docker containers to discover and interact with each other by name and alias, simplifying the configuration of services that rely on multiple interconnected containers

* Now let’s try to connect to PostgreSQL from inside the python_box container.

* We previously installed `nano` inside of the my_image so let’s use it to create a simple Python script to test the connection to PostgreSQL. In the terminal for the python_test container, execute this command:

```sh
nano pg_test.py
```

```sh
"""Test PostgreSQL connection."""
import psycopg2

conn = psycopg2.connect(user='postgres')
print(conn)
```
* Save the file and exit the editor. Let’s see what happens when we try to connect to the database from our script. Execute the script in your container:
* To save the file use : ctrl + o + ENTER and for exit : ctrl + x

```sh
python3 pg_test.py
```
* fixed error 

```sh
cat /etc/hosts

nano pg_test.py
```
```
"""Test PostgreSQL connection."""
import psycopg2

conn = psycopg2.connect(host='postgres', user='postgres')
print(conn)
```
* fixed error you have to add `password` aswell. Save the file and then run the script again.

```sh
python3 pg_test.py
```
* This time the script completes without any errors:
```sh
Output
<connection object at 0x7f64caec69d8; dsn: 'user=postgres host=7a230b56cd64', closed: 0>
```





