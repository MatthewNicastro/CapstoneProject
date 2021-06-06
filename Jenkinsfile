pipeline{
    agent any
    environment {
        name = 'aetna-app'
        dockerImage = ''
        deploy = false
    }
    stages{
        stage("Build") {
            steps {
                script {
                    dockerImage = docker.build name + ":$BUILD_NUMBER"
                }
            }
        }
        stage("Test") {
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
        stage("Deploy") {
            when {
                expression {
                    return env.deploy
                }
            }
            steps {
                script {
                    docker.withRegistry("https://hub.docker.com/repository/docker/matthewnicastro/pgpcapstoneproject", "docker-hub") {
                        dockerImage.push("$BUILD_NUMBER")
                        dockerImage.push("latest")
                    }
                }
            }
        }
    }
    post{
        always{
            sh "docker rmi ${name}:$BUILD_NUMBER"
        }
    }
}