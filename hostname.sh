pipeline {
    agent any
     stages {
        stage('To get the Hostname Jenkins server')
        {
            steps {
                script {
                    def servername = sh(script: 'uname -n', returnStdout: true).trim()
                    echo "The Hostname of the Jenkins server is: ${servername}"
                }
            }
        }
    
    
        stage('To get the Hostname of Node1 machine') {
            agent {label'Node1'}
            steps {
                script {
                    def servername = sh(script: 'uname -n', returnStdout: true).trim()
                    echo "The Hostname  of the Node1 is: ${servername}"
                }
            }
        }
        stage('To get the Hostname of Node2 machine') {
            agent {label'Node2'}
            steps {
                script {
                    def servername2 = sh(script: 'uname -n', returnStdout: true).trim()
                    echo "The Hostname of the Node2 is: ${servername2}"
                }
            }
        }
    }
}



