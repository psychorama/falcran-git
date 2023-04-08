# Build docker file #

Following commands will build the application.

```
cd <project-root>
sudo docker build -f sysadmin/docker/application/Dockerfile -t "falcran-git" . --no-cache
sudo docker image tag falcran-git:latest registry.psychorama.be/falcran/falcran-git:latest
sudo docker image push registry.psychorama.be/falcran/falcran-git:latest
sudo docker pull registry.psychorama.be/falcran/falcran-git:latest
sudo docker container stop falcran-git
sudo docker container rm falcran-git
sudo docker run -v /volume1/docker/falcran-git:/var/www/app/private --name falcran-git -d -p 8281:8080 -p 8282:8081 registry.psychorama.be/falcran/falcran-git
```
