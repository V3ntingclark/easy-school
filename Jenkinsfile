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
          . venv/bin/activate  # Activate the virtual environment
          pip install -r requirements.txt  # Install dependencies
        '''
      }
    }

    stage('SonarQube Analysis') {
      steps {
        withSonarQubeEnv('MySonarQube') {
          sh '''#!/bin/bash
      /var/lib/docker/overlay2/9c320fa8dfa4f04ed65a8998b94fa5a65714c7f8584b5e2ad4e8a36dcfabc3c6/merged/opt/sonar-scanner-4.6.2.2472-linux/bin/sonar-scanner         -Dsonar.projectKey=cmu-capstone         -Dsonar.sources=.         -Dsonar.python.version=3.x         -Dsonar.login=sqa_0cd94b0d8af364f302a0e8406809bfe482662f72
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