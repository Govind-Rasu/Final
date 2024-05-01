pipeline {
    
    agent any
     stages {
        stage('To get the IP address of Jenkins')
        {
            steps {
                script {
                    def IPaddr = sh(script: 'curl ifconfig.me', returnStdout: true).trim()
                    echo "Public IP address of the Jenkins server is: ${IPaddr}"
                }
                script {
                    def IPaddr = sh(script: 'ifconfig', returnStdout: true).trim()
                    echo "Private IP address of the Jenkins server is: ${IPaddr}"
                }
            }
        }
    
    
        stage('To get the IP address of Node1 machine') 
        {
            agent {label'Node1'}
            steps {
                script {
                    def IPaddr = sh(script: 'curl ifconfig.me', returnStdout: true).trim()
                    echo "Public IP address of the Node1 server is: ${IPaddr}"
                }
                script {
                    def IPaddr = sh(script: 'ifconfig', returnStdout: true).trim()
                    echo "Private IP address of the Node1 server is: ${IPaddr}"
                }
            }
        }
        stage('To get the IP address of Node2 machine') 
        {
            agent {label'Node2'}
            steps {
                    script {
                    def IPaddr = sh(script: 'curl ifconfig.me', returnStdout: true).trim()
                    echo "Public IP address of the Node2 server is: ${IPaddr}"
                }
                script {
                    def IPaddr = sh(script: 'ifconfig', returnStdout: true).trim()
                    echo "Private IP address of the Node2 server is: ${IPaddr}"
                }
            }
        }
    }
        
}
