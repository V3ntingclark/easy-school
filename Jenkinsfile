pipeline {
    agent any
    
    environment {
        // Define SonarQube server credentials and project key
        SONAR_SERVER = 'MySonarQube'            // This is the name of the SonarQube server in Jenkins
        SONAR_PROJECT_KEY = 'cmu-capstone' // This is your SonarQube project key
        SONAR_SCANNER_HOME = tool 'SonarQubeScanner' // This references the SonarQube Scanner tool in Jenkins
    }
    
    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/V3ntingclark/easy-school.git', branch: 'main', credentialsId: 'g1'
            }
        }

        stage('Set Up Python') {
            steps {
                // Install Python dependencies
                sh '''
                python3 -m venv venv  # Create virtual environment
                source venv/bin/activate  # Activate the virtual environment
                pip install -r requirements.txt  # Install dependencies
                '''
            }
        }

        // Move SonarQube Analysis before Run App
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('MySonarQube') {  // Reference to the SonarQube server in Jenkins
                    sh '''
                    ${SONAR_SCANNER_HOME}/bin/sonar-scanner \
                        -Dsonar.projectKey=${SONAR_PROJECT_KEY} \
                        -Dsonar.sources=. \
                        -Dsonar.python.version=3.x
                    '''
                }
            }
        }

        stage('Run App') {
            steps {
                // Run the Python app
                sh '''
                source venv/bin/activate  # Activate the virtual environment
                python3 app.py  # Run the Python app
                '''
            }
        }

        stage('SBOM with Syft') {
            steps {
                sh '''
                docker run --rm -v $(pwd):/project anchore/syft:latest /project -o cyclonedx-json > sbom.json
                '''
            }
        }

        stage('Vulnerability Scan with Grype') {
            steps {
                sh '''
                docker run --rm -v $(pwd):/project anchore/grype:latest sbom:/project/sbom.json
                '''
            }
        }
    }

    post {
        always {
            // Archive the SBOM and analysis reports
            archiveArtifacts artifacts: 'sbom.json', allowEmptyArchive: true
        }
    }
}
