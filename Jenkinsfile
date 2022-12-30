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
                sh 'docker image tag falcran-git:latest home.psychorama.be:4560/falcran/falcran-git:latest'
                sh 'docker image push home.psychorama.be:4560/falcran/falcran-git:latest'
                sh 'docker pull home.psychorama.be:4560/falcran/falcran-git:latest'
            }
        }
        stage('Deploy') {
            steps {
                sh 'docker container stop falcran-git || true'
                sh 'docker container rm falcran-git || true'
                sh 'docker run -v /volume1/docker/falcran-git:/var/www/app/private --name falcran-git -d -p 8281:8080 -p 8282:8081 home.psychorama.be:4560/falcran/falcran-git'
            }
        }
    }
}
