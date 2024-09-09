pipeline {
  agent any
  stages {
    stage('Checkout') {
      steps {
        git(url: 'https://github.com/V3ntingclark/easy-school', credentialsId: 'G1')
      }
    }

    stage('Build') {
      steps {
        sh '''mvn clean package
'''
        tool 'mvn'
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