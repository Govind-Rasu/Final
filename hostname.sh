pipeline {
    agent any
     stages {
        stage('To get the Hostname')
        {
            steps {
                script {
                    def servername = sh(script: 'uname -n', returnStdout: true).trim()
<<<<<<< HEAD
                    echo "The hostname of  server is: ${servername}"
=======
                    echo "The hostname of server is: ${servername}"
>>>>>>> 551d727de3474dc818a70eb8455de306397662d8
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
                    echo "The hostname of the server is: ${servername}"
                }
            }
        }
    }
}




