pipeline {
  agent any
  stages {
    stage('Checkout') {
      steps {
        git 'https://github.com/V3ntingclark/easy-school'
      }
    }

    stage('Build') {
      steps {
        sh '''mvn clean package
'''
      }
    }

    stage('SBOM (Syft)') {
      steps {
        sh '''docker run --rm -v $(pwd):/project anchore/syft:latest /project -o cyclonedx-json > sbom.json
'''
      }
    }

  }
}