pipeline {
  agent any
  stages {
    stage('Checkout') {
      steps {
        git(url: 'https://github.com/V3ntingclark/easy-school.git', credentialsId: 'G1')
      }
    }

    stage('Build') {
      steps {
        sh 'mvn clean package'
      }
    }

    stage('SBOM (Syft)') {
      steps {
        sh 'docker run --rm -v ${WORKSPACE}:/project anchore/syft:latest /project -o cyclonedx-json > sbom.json'
      }
    }

  }
  tools {
    maven 'mvn-host'
  }
}