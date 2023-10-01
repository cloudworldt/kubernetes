# MultiContainer pod/sidecar containers


The primary purpose of a multi-container pod is to support a co-located helper container for the main program.

The standard logging method for containerized applications is writing to standard output and standard error streams.

There might be use cases where you also need to access these logs after a container crashes. For example, your NGINX designed for serving the web page is not suitable for shipping the logs to a centralized logging solution.

You can set up a sidecar container that specialises in log shipping. The sidecar container is designed as a logging agent, which is configured to pick up logs from an application container.

![image](https://user-images.githubusercontent.com/103893307/207912004-8400bd51-2497-4ce0-87ef-286d3e561da6.png)


#### lets try to understand by creating multi-container pod manifest yml file 

```yml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-server
spec:
  volumes:
    - name: shared-logs
      emptyDir: {}

  containers:
    - name: nginx
      image: nginx
      volumeMounts:
        - name: shared-logs
          mountPath: /var/log/nginx

    - name: sidecar-container
      image: busybox
      command: ["sh","-c","while true; do cat /var/log/nginx/access.log /var/log/nginx/error.log; sleep 30; done"]
      volumeMounts:
        - name: shared-logs
          mountPath: /var/log/nginx
```          
```
k exec -it nginx-server -c sidecar-container -- sh  
```
```
cd /var/log/nginx/ && ls
```


```yml
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  type: NodePort
  selector:
    app: proxy
  ports:
      # By default and for convenience, the `targetPort` is set to the same value as the `port` field.
    - port: 80
      targetPort: 80
      # Optional field
      # By default and for convenience, the Kubernetes control plane will allocate a port from a range (default: 30000-32767)
      nodePort: 30007
```
