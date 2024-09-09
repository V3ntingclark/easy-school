pipeline {
  agent any
  stages {
    stage('Compile') {
      steps {
        sh './mvnw clean complie'
      }
    }

  }
  tools {
    maven 'mvn-host'
  }
}