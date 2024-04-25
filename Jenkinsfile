pipeline {
  agent {
    node {
      label 'Node1'
    }

  }
  stages {
    stage('stage1') {
      steps {
        sh 'echo "This is first step"'
      }
    }

    stage('stage2') {
      steps {
        sh 'echo "This is second step"'
      }
    }

  }
}