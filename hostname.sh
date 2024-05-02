pipeline {
    agent any
     stages {
        stage('To get the Hostname')
        {
            steps {
                script {
                    def servername = sh(script: 'uname -n', returnStdout: true).trim()
                    echo "The hostname of  the Main server is: ${servername}"
                             }
            }
        }
    
    
        stage('To get the Hostname of Node1 machine') {
            agent {label'Node1'}
            steps {
                script {
                    def servername = sh(script: 'uname -n', returnStdout: true).trim()
                    echo "The hostname of the server is: ${servername}"
                }
            }
        }
        stage('To get the Hostname of Node2 machine') {
            agent {label'Node2'}
            steps {
                script {
                    def servername = sh(script: 'uname -n', returnStdout: true).trim()
                    echo "The hostname of the Node2 : ${servername}"
                }
            }
        }
    }
}




