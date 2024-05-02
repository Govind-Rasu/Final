pipeline {
    agent any
     stages {
        stage('To get the Hostname')
        {
            steps {
                script {
                    def servername = sh(script: 'uname -n', returnStdout: true).trim()
                    echo "The Hostname of the Main server is: ${servername}"
                }
            }
        }
    
    
        stage('To get the Hostname of Node1 machine') {
            agent {label'Node1'}
            steps {
                script {
                    def servername = sh(script: 'ifconfig', returnStdout: true).trim()
                    echo "The ipaddress  of the Node1 is: ${servername}"
                }
            }
        }
        stage('To get the Hostname of Node2 machine') {
            agent {label'Node2'}
            steps {
                script {
                    def servername2 = sh(script: 'curl ifconfig.me', returnStdout: true).trim()
                    echo "The public IP address of the Node2 is: ${servername2}"
                }
            }
        }
    }
}



