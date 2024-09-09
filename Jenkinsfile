pipeline {
    agent any
    tools {
        maven 'mvn-manual' // Ensure 'mvn-manual' matches the name in your Global Tool Configuration
    }
    stages {
        stage('Checkout') {
            steps {
                git(url: 'https://github.com/V3ntingclark/easy-school.git', credentialsId: 'G1')
            }
        }

        stage('Build') {
            steps {
                // Use the Maven tool configured in the Global Tool Configuration
                sh 'mvn clean package'
            }
        }

        stage('SBOM (Syft)') {
            steps {
                // Use Jenkins environment variable for the workspace instead of $(pwd)
                sh 'docker run --rm -v ${WORKSPACE}:/project anchore/syft:latest /project -o cyclonedx-json > sbom.json'
            }
        }
    }
}
