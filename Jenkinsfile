pipeline {
  agent any
  stages {
    stage('Checkout') {
      steps {
        git(url: 'https://gitlab.com/YOUR-USERNAME/YOUR-REPO.git', branch: 'main', credentialsId: 'g1')
      }
    }

    stage('Set Up Python') {
      steps {
        sh '''
                python3 -m venv venv  # Create virtual environment
                source venv/bin/activate  # Activate the virtual environment
                pip install -r requirements.txt  # Install dependencies
                '''
      }
    }

    stage('Run App') {
      steps {
        sh '''
                source venv/bin/activate  # Activate the virtual environment
                python3 app.py  # Run the Python app
                '''
      }
    }

    stage('SonarQube Analysis') {
      steps {
        withSonarQubeEnv(installationName: 'SonarQubeServer') {
          sh '''
                    ${SONAR_SCANNER_HOME}/bin/sonar-scanner                         -Dsonar.projectKey=${cmu-capstone}                         -Dsonar.sources=.                         -Dsonar.python.version=3.x
                    '''
        }

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
  environment {
    SONAR_SERVER = 'SonarQubeServer'
    SONAR_PROJECT_KEY = 'your-sonarqube-project-key'
    SONAR_SCANNER_HOME = 'SonarQubeScanner' // Reference the SonarQube Scanner installation in Jenkins
  }
  post {
    always {
      archiveArtifacts(artifacts: 'sbom.json', allowEmptyArchive: true)
    }

  }
}