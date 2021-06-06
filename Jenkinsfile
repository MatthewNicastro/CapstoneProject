pipeline{
    agent any
    parameters {
        booleanParam(
            defaultValue: true,
            description: 'Push image to docker hub',
            name: 'PUSH_CONTAINER'
        )
    }
    environment {
        name = 'matthewnicastro/pgpcapstoneproject'
        tag = 'latest'
        dockerImage = ''
        deploy = false
        isContainerRunning = ''
        containerName = 'aetna-app'
    }
    stages{
        stage("Build Applicaiton Docker Image") {
            steps {
                script {
                    dockerImage = docker.build name + ":${tag}"
                }
            }
        }
        stage("Run Application Tests") {
            steps {
                script {
                    docker.image("${name}:${tag}").inside {
                        sh "pytest app"
                    }
                }
            }
            post{
                success {
                    script {
                        env.deploy = true
                    }
                }
                failure {
                    echo "========An execution error occured========"
                }
            }
        }
        stage("Push Docker Image to Dockerhub") {
            when {
                expression {
                    return env.deploy && params.PUSH_CONTAINER
                }
            }
            steps {
                script {
                    docker.withRegistry("https://registry.hub.docker.com/", "docker-hub") {
                        dockerImage.push("$BUILD_NUMBER")
                        dockerImage.push("latest")
                    }
                }
            }
        }
        stage("Deploy container") {
            when {
                expression {
                    return env.deploy
                }
            }
            steps {
                sh "docker ps -a | grep ${containerName} && docker container rm -f ${containerName} || true"
                script {
                    dockerImage.run(["-p 5000:5000 --name aetna-app"])
                }
            }
        }
    }
    post {
        success {
            sh "docker rmi -f registry.hub.docker.com/matthewnicastro/pgpcapstoneproject:${tag}"
            sh "docker rmi -f registry.hub.docker.com/matthewnicastro/pgpcapstoneproject:$BUILD_NUMBER"
        }
        failure {
            sh "docker rmi ${name}:${tag}"
        }
    }
}