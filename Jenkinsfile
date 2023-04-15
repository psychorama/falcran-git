pipeline {
    agent {
        label "falcran-jenkins-slave"
    }
    environment {
        BUILD_NAME = 'falcran-git'
        ENV = 'prod'

        SYMF_PSYCHORAMA_APP_SECRET = credentials('SYMF_PSYCHORAMA_APP_SECRET')
    }
    stages {
        stage ('Prepare') {
            steps {
                sh './sysadmin/devops/setup-environment.sh'
            }
        }
        stage('Build images') {
            steps {
                sh 'docker build -f sysadmin/docker/application/Dockerfile -t "falcran-git" . --no-cache'
                sh 'docker image tag falcran-git:latest registry.psychorama.be/falcran/falcran-git:latest'
                sh 'docker image push registry.psychorama.be/falcran/falcran-git:latest'
                sh 'docker pull registry.psychorama.be/falcran/falcran-git:latest'
            }
        }
        stage('Deploy') {
            steps {
                sh 'docker container stop falcran-git || true'
                sh 'docker container rm falcran-git || true'
                sh 'docker run \
                  --name falcran-git \
                  --hostname git.psychorama.be \
                  -l traefik.enable=true \
                  -l traefik.http.routers.falcran-git.rule="Host(\\`git.psychorama.be\\`)" \
                  -l traefik.http.routers.falcran-git.tls=true \
                  -l traefik.http.routers.falcran-git.entrypoints=websecure \
                  -l traefik.http.routers.falcran-git.middlewares=realip@file,transformip@file \
                  -l traefik.http.services.falcran-git.loadbalancer.server.port=8080 \
                  -v /volumeUSB1/usbshare/falcran-git:/var/www/app/private \
                  -d registry.psychorama.be/falcran/falcran-git'
            }
        }
    }
}
