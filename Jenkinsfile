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
                sh "echo deploy"
            }
        }
    }
    post{
        always{
            sh "docker rmi ${name}:$BUILD_NUMBER"
        }
    }
}