pipeline {
  agent {
    node {
      label 'Node1'
    }

  }
  stages {
    stage('stage1') {
      parallel {
        stage('stage1') {
          steps {
            sh 'echo "This is first step"'
          }
        }

        stage('') {
          steps {
            sh 'echo "This is running in node 1"'
          }
        }

      }
    }

    stage('stage2') {
      parallel {
        stage('stage2') {
          steps {
            sh 'echo "This is second step"'
          }
        }

        stage('') {
          steps {
            sh 'echo "This is Second step in second stage"'
          }
        }

      }
    }

  }
}