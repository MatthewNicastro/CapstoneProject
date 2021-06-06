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
                script {
                    isContainerRunning = sh (script: "docker images -q ${containerName}", returnStdout: true )
                    if( isConatinerRunning ){
                        sh ( script: "docker container stop ${containerName}")
                        sh ( script: "docker container rm ${containerName}")
                    }
                    dockerImage.run(["-p 5000:5000 --name ${containerName}"])
                }
            }
        }
    }
    post{
        failure {
            sh "docker rmi ${name}:$BUILD_NUMBER"
        }
    }
}