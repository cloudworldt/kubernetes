### CMD

* build the image
```
docker build -t <YOUR_USERNAME>/flaskapp .
```

* run the container
```
docker run -p 8888:5000 --name flaskapp YOUR_USERNAME/flaskapp
```
