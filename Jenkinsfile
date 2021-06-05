pipeline{
    agent any
    stages{
        stage("Test"){
            steps{
                sh "pytest app"
            }
            post{
                success{
                    echo "========A executed successfully========"
                }
            }
        }
    }
    post{
        always{
            echo "========always========"
        }
    }
}