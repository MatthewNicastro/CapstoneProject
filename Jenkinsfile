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
        dockerImage = ''
        deploy = false
        isContainerRunning = ''
        containerName = 'aetna-app'
    }
    stages{
        stage("Build Applicaiton Docker Image") {
            steps {
                script {
                    dockerImage = docker.build name + ":$BUILD_NUMBER"
                }
            }
        }
        stage("Run Application Tests") {
            steps {
                script {
                    docker.image("${name}:$BUILD_NUMBER").inside {
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
    post{
        always {
            sh "docker image prune -f"
        }
        failure {
            sh "docker rmi ${name}:$BUILD_NUMBER"
        }
    }
}