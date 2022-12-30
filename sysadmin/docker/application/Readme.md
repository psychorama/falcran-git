# Build docker file #

Following commands will build the application.

```
cd <project-root>
sudo docker build -f sysadmin/docker/application/Dockerfile -t "falcran-git" . --no-cache
sudo docker image tag falcran-git:latest home.psychorama.be:4560/falcran/falcran-git:latest
sudo docker image push home.psychorama.be:4560/falcran/falcran-git:latest
sudo docker pull home.psychorama.be:4560/falcran/falcran-git:latest
sudo docker container stop falcran-git
sudo docker container rm falcran-git
sudo docker run --name falcran-git -d -p 8281:8080 -p 8282:8081 home.psychorama.be:4560/falcran/falcran-git
```
