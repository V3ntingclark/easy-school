pipeline {
    agent any
    tools {
        maven 'mvn-host' // Use the name you configured in Jenkins Global Tool Configuration
    }
    stages {
        stage('Checkout') {
            steps {
                git(url: 'https://github.com/V3ntingclark/easy-school.git', credentialsId: 'G1')
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package' // Now uses Maven from the EC2 host
            }
        }

        stage('SBOM (Syft)') {
            steps {
                sh 'docker run --rm -v ${WORKSPACE}:/project anchore/syft:latest /project -o cyclonedx-json > sbom.json'
            }
        }
    }
}
