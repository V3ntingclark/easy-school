pipeline {
    agent any
    
    environment {
        // Define SonarQube server credentials and project key
        SONAR_SERVER = 'SonarQubeServer' // Name configured in Jenkins SonarQube Server settings
        SONAR_PROJECT_KEY = 'your-sonarqube-project-key'
        SONAR_SCANNER_HOME = tool 'SonarQubeScanner' // Reference the SonarQube Scanner installation in Jenkins
    }
    
    stages {
        stage('Checkout') {
            steps {
                git url: 'https://gitlab.com/YOUR-USERNAME/YOUR-REPO.git', branch: 'main', credentialsId: 'g1'
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
        
        stage('Run App') {
            steps {
                // Run the Python app
                sh '''
                source venv/bin/activate  # Activate the virtual environment
                python3 app.py  # Run the Python app
                '''
            }
        }
        
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQubeServer') {  // 'SonarQubeServer' is the name defined in Jenkins global config
                    sh '''
                    ${SONAR_SCANNER_HOME}/bin/sonar-scanner \
                        -Dsonar.projectKey=${SONAR_PROJECT_KEY} \
                        -Dsonar.sources=. \
                        -Dsonar.python.version=3.x
                    '''
                }
            }
        }
        
        stage('SBOM with Syft') {
            steps {
                // Generate SBOM with Syft
                sh '''
                docker run --rm -v $(pwd):/project anchore/syft:latest /project -o cyclonedx-json > sbom.json
                '''
            }
        }
        
        stage('Vulnerability Scan with Grype') {
            steps {
                // Scan the SBOM for vulnerabilities using Grype
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
