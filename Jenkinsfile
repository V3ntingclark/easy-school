pipeline {
    agent any
    
    tools {
        maven 'mvn' // Reference the Maven tool configured in Jenkins Global Tool Configuration
    }

    stages {
        stage('Checkout') {
            steps {
                git(url: 'https://github.com/V3ntingclark/easy-school', credentialsId: 'G1')
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('SBOM (Syft)') {
            steps {
                sh '''docker run --rm -v $(pwd):/project anchore/syft:latest /project -o cyclonedx-json > sbom.json'''
            }
        }
    }
}
