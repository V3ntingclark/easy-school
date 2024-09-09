pipeline {
    agent any
    tools {
        maven 'mvn-manual' // The name you gave Maven in Global Tool Configuration
    }
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
}
