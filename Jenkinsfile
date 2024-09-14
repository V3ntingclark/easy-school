pipeline {
  agent any
  stages {
    stage('Checkout') {
      steps {
        git(url: 'https://github.com/V3ntingclark/easy-school.git', branch: 'master', credentialsId: 'g1')
      }
    }

    stage('Set Up Python') {
      steps {
        sh '''
          #!/bin/bash
          python3 -m venv venv  # Create virtual environment
          source venv/bin/activate  # Activate the virtual environment
          pip install -r requirements.txt  # Install dependencies
        '''
      }
    }

    stage('SonarQube Analysis') {
      steps {
        withSonarQubeEnv('MySonarQube') {
          sh '''
            #!/bin/bash
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
        sh '''
          #!/bin/bash
          source venv/bin/activate  # Activate the virtual environment
          python3 app.py  # Run the Python app
        '''
      }
    }

    stage('SBOM with Syft') {
      steps {
        sh '''
          #!/bin/bash
          docker run --rm -v $(pwd):/project anchore/syft:latest /project -o cyclonedx-json > sbom.json
        '''
      }
    }

    stage('Vulnerability Scan with Grype') {
      steps {
        sh '''
          #!/bin/bash
          docker run --rm -v $(pwd):/project anchore/grype:latest sbom:/project/sbom.json
        '''
      }
    }
  }
  environment {
    SONAR_SERVER = 'MySonarQube'
    SONAR_PROJECT_KEY = 'cmu-capstone'
    SONAR_SCANNER_HOME = 'SonarQubeScanner'
  }
  post {
    always {
      archiveArtifacts(artifacts: 'sbom.json', allowEmptyArchive: true)
    }
  }
}
