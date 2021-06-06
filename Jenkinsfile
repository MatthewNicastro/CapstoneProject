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
    }
    post{
        success {
            script {
                sh ( script: "(docker ps -a | grep ${containerName}) && (docker container stop ${containerName} || true) && (docker container rm ${containerName} || true)" )
                dockerImage.run(["-p 5000:5000 --name ${containerName}"])
            }
        }
        failure {
            sh "docker rmi ${name}:$BUILD_NUMBER"
        }
    }
}