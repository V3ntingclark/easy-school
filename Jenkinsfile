pipeline {
    agent {
        docker { image 'maven:3.8.6-jdk-11' } // Use a Docker image with Maven pre-installed
    }
    stages {
        stage('Checkout') {
            steps {
                git(url: 'https://github.com/V3ntingclark/easy-school.git', credentialsId: 'G1')
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package' // This runs Maven inside the container
            }
        }

        stage('SBOM (Syft)') {
            steps {
                sh 'docker run --rm -v ${WORKSPACE}:/project anchore/syft:latest /project -o cyclonedx-json > sbom.json'
            }
        }
    }
}
