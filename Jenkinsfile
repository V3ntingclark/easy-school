pipeline {
  agent any
  stages {
    stage('Checkout') {
      steps {
        git(url: 'https://davidclark15323@gmail:Redditgold#1@github.com/V3ntingclark/easy-school.git')
      }
    }

    stage('Build') {
      steps {
        sh 'mvn clean package'
      }
    }

    stage('SBOM (Syft)') {
      steps {
        sh 'docker run --rm -v $(pwd):/project anchore/syft:latest /project -o cyclonedx-json > sbom.json'
      }
    }

  }
  tools {
    maven 'mvn'
  }
}
