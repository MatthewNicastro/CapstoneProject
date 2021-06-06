pipeline{
    agent any
    environment {
        name = 'aetna-app'
        dockerImage = ''
    }
    stages{
        stage("Build"){
            steps {
                script {
                    dockerImage = docker.build name + ":$BUILD_NUMBER"
                }
            }
        }
        stage("Test"){
            steps{
                script {
                    docker.image("${name}:$BUILD_NUMBER").inside {
                        sh "pytest app"
                    }
                }
            }
            post{
                success {
                    echo "========A executed successfully========"
                }
                failure {
                    echo "========An execution error occured========"
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